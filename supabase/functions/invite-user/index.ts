import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

type InviteBody = {
  email?: string
  fullName?: string
  role?: string
  schoolId?: string
  batchRowId?: string
}

const json = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })

const failRow = async (
  supabase: ReturnType<typeof createClient>,
  batchRowId: string | undefined,
  message: string,
) => {
  if (!batchRowId) return
  await supabase
    .from('invite_batch_rows')
    .update({ status: 'failed', error: message })
    .eq('id', batchRowId)
}

// Deploy after applying supabase/migrations/invite_tracking.sql:
//   supabase functions deploy invite-user
// The browser calls this function because auth.admin.inviteUserByEmail requires
// the service-role key and must never run client-side.
Deno.serve(async req => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (req.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405)
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
  if (!supabaseUrl || !serviceRoleKey) {
    return json({ error: 'Supabase function environment is not configured.' }, 500)
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey)
  const authHeader = req.headers.get('Authorization') ?? ''
  const token = authHeader.replace(/^Bearer\s+/i, '')
  if (!token) {
    return json({ error: 'Missing authorization token.' }, 401)
  }

  const { data: authData, error: authError } = await supabase.auth.getUser(token)
  if (authError || !authData.user) {
    return json({ error: 'Invalid authorization token.' }, 401)
  }

  let body: InviteBody
  try {
    body = await req.json()
  } catch {
    return json({ error: 'Invalid JSON body.' }, 400)
  }

  const email = body.email?.trim().toLowerCase()
  const fullName = body.fullName?.trim() || null
  const role = body.role?.trim().toLowerCase()
  const schoolId = body.schoolId
  const batchRowId = body.batchRowId

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return json({ error: 'A valid email is required.' }, 400)
  }

  if (role !== 'teacher' && role !== 'parent') {
    return json({ error: 'Role must be teacher or parent.' }, 400)
  }

  if (!schoolId) {
    return json({ error: 'schoolId is required.' }, 400)
  }

  const { data: adminProfile, error: profileError } = await supabase
    .from('profiles')
    .select('id, role, school_id')
    .eq('id', authData.user.id)
    .single()

  if (profileError || !adminProfile || adminProfile.role !== 'admin' || adminProfile.school_id !== schoolId) {
    return json({ error: 'Only school admins can invite users for their school.' }, 403)
  }

  if (batchRowId) {
    const { data: batchRow, error: batchRowError } = await supabase
      .from('invite_batch_rows')
      .select('id, batch_id')
      .eq('id', batchRowId)
      .single()

    if (batchRowError || !batchRow) {
      return json({ error: 'Invite batch row not found.' }, 404)
    }

    const { data: batch, error: batchError } = await supabase
      .from('invite_batches')
      .select('school_id')
      .eq('id', batchRow.batch_id)
      .single()

    if (batchError || !batch || batch.school_id !== schoolId) {
      return json({ error: 'Invite batch row does not belong to this school.' }, 403)
    }

    await supabase
      .from('invite_batch_rows')
      .update({ status: 'importing', error: null })
      .eq('id', batchRowId)
  }

  try {
    const redirectTo = Deno.env.get('SITE_URL')
      ? `${Deno.env.get('SITE_URL')}/login`
      : undefined

    const { data: inviteData, error: inviteError } = await supabase.auth.admin.inviteUserByEmail(email, {
      data: {
        full_name: fullName,
        role,
        school_id: schoolId,
      },
      redirectTo,
    })

    if (inviteError) throw inviteError

    const userId = inviteData.user?.id
    if (!userId) throw new Error('Supabase did not return an invited user id.')

    const { error: upsertError } = await supabase
      .from('profiles')
      .upsert({
        id: userId,
        email,
        full_name: fullName,
        role,
        school_id: schoolId,
      }, { onConflict: 'id' })

    if (upsertError) throw upsertError

    if (batchRowId) {
      const { error: rowError } = await supabase
        .from('invite_batch_rows')
        .update({ status: 'success', error: null, user_id: userId })
        .eq('id', batchRowId)

      if (rowError) throw rowError
    }

    return json({ userId })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Invitation failed.'
    await failRow(supabase, batchRowId, message)
    return json({ error: message }, 400)
  }
})
