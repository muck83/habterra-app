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

  // --- look up any existing auth row for this email so we can reactivate
  // soft-deleted members instead of failing with "already registered". We
  // page through auth.admin.listUsers because Supabase has no direct
  // "get by email" admin endpoint. Typical schools have < 200 users so
  // one or two pages is usually enough.
  async function findExistingAuthUser(target: string): Promise<{ id: string } | null> {
    for (let page = 1; page <= 20; page++) {
      const { data, error } = await supabase.auth.admin.listUsers({ page, perPage: 200 })
      if (error) throw error
      const hit = data?.users?.find(u => (u.email ?? '').toLowerCase() === target)
      if (hit) return { id: hit.id }
      if (!data || data.users.length < 200) return null
    }
    return null
  }

  // --- create or invite the user ---
  try {
    let userId: string
    let reactivated = false
    const existing = await findExistingAuthUser(email)

    if (existing) {
      // Reactivation path — auth row survived a soft-delete. Update the
      // auth row (password + email_confirm if the admin set a password)
      // and upsert the profile to is_active=true with the new role /
      // school / name. This lets admins re-onboard a former member with
      // one click instead of getting stuck on "already registered".
      userId = existing.id
      reactivated = true

      if (adminPassword) {
        const { error: updateAuthError } = await supabase.auth.admin.updateUserById(userId, {
          password: adminPassword,
          email_confirm: true,
          user_metadata: {
            full_name: fullName,
            role,
            school_id: schoolId,
            admin_set_password: true,
            reactivated: true,
          },
        })
        if (updateAuthError) throw updateAuthError
      } else if (!skipEmail) {
        // No password provided and admin wants an email — send a
        // password-reset so the returning user can set a fresh password.
        const redirectTo = Deno.env.get('SITE_URL')
          ? `${Deno.env.get('SITE_URL')}/login?recovery=1`
          : undefined
        const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
          redirectTo,
        })
        // Non-fatal: even if the email fails we still reactivate the
        // profile. Admin can re-trigger reset from the dashboard.
        if (resetError) console.warn('resetPasswordForEmail on reactivate failed:', resetError.message)
      }
    } else if (skipEmail) {
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
    // Also clear is_active / deactivated_* on reactivation so the soft-
    // deleted row flips back to active. We try the full column set first
    // and fall back to the minimal set if the deactivation migration
    // hasn't been applied in this project (PostgREST returns 42703 for
    // missing columns).
    const fullProfile = {
      id: userId,
      email,
      full_name: fullName,
      role,
      school_id: schoolId,
      is_active: true,
      deactivated_at: null,
      deactivated_by: null,
    }
    let { error: upsertError } = await supabase
      .from('profiles')
      .upsert(fullProfile, { onConflict: 'id' })

    if (upsertError && /column .*(is_active|deactivated).* does not exist/i.test(upsertError.message ?? '')) {
      // Migration not applied — fall back to the legacy column set.
      const legacy = { id: userId, email, full_name: fullName, role, school_id: schoolId }
      const retry = await supabase.from('profiles').upsert(legacy, { onConflict: 'id' })
      upsertError = retry.error
    }
    if (upsertError) throw upsertError

    if (batchRowId) {
      const { error: rowError } = await supabase
        .from('invite_batch_rows')
        .update({ status: 'success', error: null, user_id: userId })
        .eq('id', batchRowId)

      if (rowError) throw rowError
    }

    // Support both response shapes; clients check user_id (snake) or userId (camel).
    return json({ userId, user_id: userId, skipped_email: skipEmail, reactivated, ok: true })
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Invitation failed.'
    await failRow(supabase, batchRowId, message)
    return json({ error: message }, 400)
  }
})
