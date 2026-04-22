// Pinned to @2.49.8 — needed for ES256 asymmetric-JWT support on projects
// that have rotated to Supabase's new key format. Older bundles threw
// "UNAUTHORIZED_UNSUPPORTED_TOKEN_ALGORITHM" on supabase.auth.getUser().
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.8'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

const ACTION_TYPES = ['invite_failed', 'no_progress', 'stalled', 'overdue', 'quiz_weak']

const MODULE_SLUG_BY_ID: Record<string, string> = {
  'ksa-001': 'ksa-ib',
  'india-001': 'india-ib',
  'korea-001': 'korea-ib',
  'china-001': 'china-ib',
  'woodstock-001': 'woodstock-transition',
}

const json = (body: Record<string, unknown>, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })

const daysAgo = (days: number) => {
  const date = new Date()
  date.setDate(date.getDate() - days)
  return date
}

const toDateOnly = (value: string | null | undefined) => {
  if (!value) return null
  return value.slice(0, 10)
}

const moduleLabel = (slug: string | null | undefined) => {
  const labels: Record<string, string> = {
    'ksa-ib': 'Saudi Arabia module',
    'india-ib': 'India module',
    'korea-ib': 'Korea module',
    'china-ib': 'China module',
    'woodstock-transition': 'Woodstock transition module',
  }
  return slug ? labels[slug] ?? slug : 'assigned module'
}

// Deploy after applying supabase/migrations/action_items.sql:
//   supabase functions deploy refresh-action-items
// The function uses the service-role key for cross-table queue generation, then
// verifies the caller is an admin for the requested school before doing work.
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
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '')
  if (!token) {
    return json({ error: 'Missing authorization token.' }, 401)
  }

  const { data: authData, error: authError } = await supabase.auth.getUser(token)
  if (authError || !authData.user) {
    return json({ error: 'Invalid authorization token.' }, 401)
  }

  let schoolId = ''
  try {
    const body = await req.json()
    schoolId = body.schoolId
  } catch {
    return json({ error: 'Invalid JSON body.' }, 400)
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
    return json({ error: 'Only school admins can refresh action items for their school.' }, 403)
  }

  const items: Array<Record<string, unknown>> = []

  const { data: batches } = await supabase
    .from('invite_batches')
    .select('id')
    .eq('school_id', schoolId)

  const batchIds = (batches ?? []).map(batch => batch.id)
  if (batchIds.length > 0) {
    const { data: failedRows } = await supabase
      .from('invite_batch_rows')
      .select('id, email, full_name, role, error, created_at')
      .in('batch_id', batchIds)
      .eq('status', 'failed')

    for (const row of failedRows ?? []) {
      items.push({
        school_id: schoolId,
        action_type: 'invite_failed',
        severity: 'high',
        status: 'open',
        title: `Invite failed for ${row.full_name || row.email}`,
        detail: row.error || 'The invitation could not be sent. Review the address and try again.',
        metadata: { invite_batch_row_id: row.id, email: row.email, role: row.role },
      })
    }
  }

  const [{ data: profiles }, { data: assignments }, { data: completions }] = await Promise.all([
    supabase
      .from('profiles')
      .select('id, full_name, email, role')
      .eq('school_id', schoolId)
      .neq('role', 'admin'),
    supabase
      .from('assignments')
      .select('id, user_id, role_target, module_slug, assigned_at, due_date')
      .eq('school_id', schoolId),
    supabase
      .from('module_completions')
      .select('user_id, module_slug, progress_pct, completed_at, last_updated'),
  ])

  const users = profiles ?? []
  const completionByUserModule = new Map<string, Record<string, unknown>>()
  for (const completion of completions ?? []) {
    completionByUserModule.set(`${completion.user_id}:${completion.module_slug}`, completion)
  }

  const now = new Date()
  const noProgressCutoff = daysAgo(7)
  const stalledCutoff = daysAgo(14)

  for (const assignment of assignments ?? []) {
    const assignedUsers = users.filter(user => {
      if (assignment.user_id) return user.id === assignment.user_id
      if (!assignment.role_target || assignment.role_target === 'all') return true
      return user.role === assignment.role_target
    })

    for (const assignedUser of assignedUsers) {
      const completion = completionByUserModule.get(`${assignedUser.id}:${assignment.module_slug}`)
      const assignedAt = assignment.assigned_at ? new Date(assignment.assigned_at) : now
      const dueDate = assignment.due_date ? new Date(`${assignment.due_date}T23:59:59Z`) : null
      const progressPct = Number(completion?.progress_pct ?? 0)
      const completedAt = completion?.completed_at as string | null | undefined
      const lastUpdated = completion?.last_updated ? new Date(completion.last_updated as string) : null
      const userName = assignedUser.full_name || assignedUser.email

      if (!completion && assignedAt <= noProgressCutoff) {
        items.push({
          school_id: schoolId,
          user_id: assignedUser.id,
          module_slug: assignment.module_slug,
          action_type: 'no_progress',
          severity: 'medium',
          status: 'open',
          title: `${userName} has not started ${moduleLabel(assignment.module_slug)}`,
          detail: 'This assignment is more than 7 days old with no recorded progress.',
          due_date: toDateOnly(assignment.due_date),
          metadata: { assignment_id: assignment.id, email: assignedUser.email },
        })
      }

      if (progressPct > 0 && progressPct < 80 && lastUpdated && lastUpdated <= stalledCutoff) {
        items.push({
          school_id: schoolId,
          user_id: assignedUser.id,
          module_slug: assignment.module_slug,
          action_type: 'stalled',
          severity: 'medium',
          status: 'open',
          title: `${userName} is stalled at ${progressPct}%`,
          detail: `No progress update has been recorded in 14 days for ${moduleLabel(assignment.module_slug)}.`,
          due_date: toDateOnly(assignment.due_date),
          metadata: { assignment_id: assignment.id, progress_pct: progressPct, email: assignedUser.email },
        })
      }

      if (dueDate && dueDate < now && !completedAt) {
        items.push({
          school_id: schoolId,
          user_id: assignedUser.id,
          module_slug: assignment.module_slug,
          action_type: 'overdue',
          severity: 'high',
          status: 'open',
          title: `${userName} is overdue for ${moduleLabel(assignment.module_slug)}`,
          detail: `The assignment was due on ${assignment.due_date} and is not complete.`,
          due_date: toDateOnly(assignment.due_date),
          metadata: { assignment_id: assignment.id, progress_pct: progressPct, email: assignedUser.email },
        })
      }
    }
  }

  if (users.length > 0) {
    const userIds = users.map(user => user.id)
    const { data: responses } = await supabase
      .from('quiz_responses')
      .select('module_id, question_id, option_id, is_correct')
      .in('user_id', userIds)

    const byQuestion = new Map<string, { moduleId: string; questionId: string; total: number; correct: number }>()
    for (const response of responses ?? []) {
      const key = `${response.module_id}:${response.question_id}`
      const current = byQuestion.get(key) ?? {
        moduleId: response.module_id,
        questionId: response.question_id,
        total: 0,
        correct: 0,
      }
      current.total += 1
      if (response.is_correct) current.correct += 1
      byQuestion.set(key, current)
    }

    const weakQuestions = Array.from(byQuestion.values())
      .filter(question => question.total >= 3 && question.correct / question.total < 0.6)

    if (weakQuestions.length > 0) {
      const questionIds = weakQuestions.map(question => question.questionId)
      const { data: questionRows } = await supabase
        .from('pd_quiz_questions')
        .select('id, prompt, module_id, quiz_type, dimension_number, sort_order')
        .in('id', questionIds)

      const questionById = new Map((questionRows ?? []).map(question => [question.id, question]))

      for (const weak of weakQuestions) {
        const question = questionById.get(weak.questionId)
        const percent = Math.round((weak.correct / weak.total) * 100)
        const moduleSlug = MODULE_SLUG_BY_ID[weak.moduleId] ?? weak.moduleId

        items.push({
          school_id: schoolId,
          module_slug: moduleSlug,
          action_type: 'quiz_weak',
          severity: percent < 40 ? 'high' : 'low',
          status: 'open',
          title: `Quiz weak spot: ${moduleLabel(moduleSlug)}`,
          detail: `${percent}% correct across ${weak.total} responses. ${question?.prompt ?? weak.questionId}`,
          metadata: {
            module_id: weak.moduleId,
            question_id: weak.questionId,
            correct: weak.correct,
            total: weak.total,
            quiz_type: question?.quiz_type,
            dimension_number: question?.dimension_number,
            sort_order: question?.sort_order,
          },
        })
      }
    }
  }

  await supabase
    .from('admin_action_items')
    .delete()
    .eq('school_id', schoolId)
    .eq('status', 'open')
    .in('action_type', ACTION_TYPES)

  if (items.length > 0) {
    const { error: insertError } = await supabase
      .from('admin_action_items')
      .insert(items)

    if (insertError) {
      return json({ error: insertError.message }, 400)
    }
  }

  return json({ count: items.length })
})
