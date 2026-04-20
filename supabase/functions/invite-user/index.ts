import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

// Accepts either camelCase or snake_case body keys.
type InviteBody = {
  email?: string
  fullName?: string
  full_name?: string
  role?: string
  schoolId?: string
  school_id?: string
  batchRowId?: string
  batch_row_id?: string
  skipEmail?: boolean
  skip_email?: boolean
  password?: string
}

const ALLOWED_ROLES = new Set(['teacher', 'parent', 'admin', 'superadmin'])
// Only superadmins can create these roles.
const PRIVILEGED_ROLES = new Set(['admin', 'superadmin'])

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

// Deploy:  supabase functions deploy invite-user
// Behavior: when skipEmail is true, creates the auth user WITHOUT sending
// the Supabase invite email; otherwise sends the normal invite.
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

  // --- auth check ---
  const authHeader = req.headers.get('Authorization') ?? ''
  const token = authHeader.replace(/^Bearer\s+/i, '')
  if (!token) return json({ error: 'Missing authorization token.' }, 401)

  const { data: authData, error: authError } = await supabase.auth.getUser(token)
  if (authError || !authData.user) return json({ error: 'Invalid authorization token.' }, 401)

  // --- parse + normalize body (accept camelCase or snake_case) ---
  let body: InviteBody
  try {
    body = await req.json()
  } catch {
    return json({ error: 'Invalid JSON body.' }, 400)
  }

  const email      = body.email?.trim().toLowerCase()
  const fullName   = (body.fullName ?? body.full_name)?.trim() || null
  const role       = body.role?.trim().toLowerCase()
  const schoolId   = body.schoolId ?? body.school_id
  const batchRowId = body.batchRowId ?? body.batch_row_id
  const adminPassword = typeof body.password === 'string' && body.password.length > 0
    ? body.password
    : null
  // An admin-set password implies silent-create (no invite email); the admin
  // is expected to hand the password over out-of-band.
  const skipEmail  = body.skipEmail === true || body.skip_email === true || !!adminPassword

  if (adminPassword && adminPassword.length < 8) {
    return json({ error: 'Initial password must be at least 8 characters.' }, 400)
  }

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return json({ error: 'A valid email is required.' }, 400)
  }
  if (!role || !ALLOWED_ROLES.has(role)) {
    return json({ error: `Role must be one of: ${[...ALLOWED_ROLES].join(', ')}.` }, 400)
  }
  if (!schoolId) {
    return json({ error: 'schoolId is required.' }, 400)
  }

  // --- permission check: admin OR superadmin; superadmin can target any school ---
  const { data: adminProfile, error: profileError } = await supabase
    .from('profiles')
    .select('id, role, school_id')
    .eq('id', authData.user.id)
    .single()

  if (profileError || !adminProfile) {
    return json({ error: 'Could not load caller profile.' }, 403)
  }

  const callerRole = adminProfile.role
  const isSuperadmin = callerRole === 'superadmin'
  const isAdmin = callerRole === 'admin'

  if (!isAdmin && !isSuperadmin) {
    return json({ error: 'Only admins or superadmins can invite users.' }, 403)
  }
  if (isAdmin && adminProfile.school_id !== schoolId) {
    return json({ error: 'Admins can only invite users for their own school.' }, 403)
  }
  if (PRIVILEGED_ROLES.has(role) && !isSuperadmin) {
    return json({ error: 'Only superadmins can create admin or superadmin users.' }, 403)
  }

  // --- batch-row check (used by CSV import flow) ---
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

  // --- create or invite the user ---
  try {
    let userId: string

    if (skipEmail) {
      // Silent create: no invite email. Uses the admin-provided password
      // when set; otherwise a random temp password (admin can then trigger
      // a password reset from the dashboard or via the UI).
      const password = adminPassword ?? (crypto.randomUUID() + '!Aa1')
      const { data: createData, error: createError } = await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true, // mark confirmed so sign-in works immediately
        user_metadata: {
          full_name: fullName,
          role,
          school_id: schoolId,
          silent_create: true,
          admin_set_password: !!adminPassword,
        },
      })
      if (createError) throw createError
      userId = createData.user?.id ?? ''
      if (!userId) throw new Error('Silent create did not return a user id.')
    } else {
      const redirectTo = Deno.env.get('SITE_URL')
        ? `${Deno.env.get('SITE_URL')}/login`
        : undefined

      const { data: inviteData, error: inviteError } = await supabase.auth.admin.inviteUserByEmail(email, {
        data: { full_name: fullName, role, school_id: schoolId },
        redirectTo,
      })
      if (inviteError) throw inviteError
      userId = inviteData.user?.id ?? ''
      if (!userId) throw new Error('Supabase did not return an invited user id.')
    }

    // --- upsert profile so the member shows in the roster immediately ---
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

    // Support both response shapes; clients check user_id (snake) or userId (camel).
    return json({ userId, user_id: userId, skipped_email: skipEmail, ok: true })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Invitation failed.'
    await failRow(supabase, batchRowId, message)
    return json({ error: message }, 400)
  }
})
