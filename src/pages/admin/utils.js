/* ═════════════════════════════════════════════════════════════════════════
   Admin console — pure helpers + constants.
   Extracted from AdminDashboard.jsx during the 2026-04 split. These are
   all pure (no closed-over React state) so view components can import them
   directly instead of receiving them as props.
   ═════════════════════════════════════════════════════════════════════════ */

import { MODULE_META } from '../../data/mockData'

/* ─── Constants ───────────────────────────────────────────────────────── */

// NOTE: this file previously inferred MOCK_MODE from the absence of
// VITE_SUPABASE_URL. That was out of sync with src/lib/supabase.js and
// src/context/AuthContext.jsx, which already switched to the explicit flag.
// Keep this import surface consistent so a missing env var can't silently
// flip the admin console into mock mode.
export const MOCK_MODE = import.meta.env.VITE_MOCK_MODE === 'true'

export const COMPLETION_THRESHOLD = 80

/* ─── Completion / date helpers ───────────────────────────────────────── */

export function cellStatus(pct) {
  if (pct >= COMPLETION_THRESHOLD) return 'done'
  if (pct > 0) return 'progress'
  return 'none'
}

export function fmtDate(dateStr) {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })
}

export function daysUntil(dateStr) {
  if (!dateStr) return null
  const diff = Math.ceil((new Date(dateStr) - new Date()) / 86400000)
  return diff
}

/* ─── Per-user derived values ─────────────────────────────────────────── */

// Which module slugs apply to a given user, based on the school's
// assignment rows. `assignments` is the shell's state.
export function computeUserSlugs(user, assignments) {
  return assignments
    .filter(a => a.role_target === 'all' || a.role_target === user.role)
    .map(a => a.module_slug)
}

// Aggregate completion % across a user's required modules.
// Reads `user.completions[slug]` — a field present on the mock user
// records and on the rows returned by our members fetch.
export function computeUserOverallPct(user, assignments) {
  const slugs = computeUserSlugs(user, assignments)
  if (slugs.length === 0) return 0
  const total = slugs.reduce((acc, s) => acc + (user.completions?.[s] ?? 0), 0)
  return Math.round(total / slugs.length)
}

/* ─── Quiz analytics ──────────────────────────────────────────────────── */

export function quizLabel(question) {
  if (question.quiz_type === 'final_exam') return `Final · Q${question.sort_order}`
  return `D${question.dimension_number} · Checkpoint`
}

export function aggregateQuizAnalytics(responses, questions) {
  if (!responses.length) return []

  return questions
    .map(question => {
      const latestByUser = new Map()
      responses
        .filter(row => row.question_id === question.id)
        .forEach((row, idx) => {
          latestByUser.set(row.user_id ?? `row-${idx}`, row)
        })

      const answers = Array.from(latestByUser.values())
      const n = answers.length
      if (n === 0) return null

      const correct = answers.filter(row => row.is_correct).length
      const wrongCounts = new Map()
      answers
        .filter(row => !row.is_correct)
        .forEach(row => {
          wrongCounts.set(row.option_id, (wrongCounts.get(row.option_id) ?? 0) + 1)
        })

      let topWrong = null
      if (correct / n < 0.75 && wrongCounts.size > 0) {
        const [optionId] = Array.from(wrongCounts.entries()).sort((a, b) => b[1] - a[1])[0]
        const opt = question.options?.find(o => o.id === optionId)
        topWrong = opt?.text ?? optionId
      }

      return {
        id: question.id,
        label: quizLabel(question),
        prompt: question.prompt,
        n,
        correct,
        topWrong,
      }
    })
    .filter(Boolean)
}

/* ─── Invite / CSV ────────────────────────────────────────────────────── */

export function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

export function splitCsvLine(line) {
  const cells = []
  let current = ''
  let inQuotes = false

  for (let i = 0; i < line.length; i += 1) {
    const char = line[i]
    const next = line[i + 1]

    if (char === '"' && next === '"') {
      current += '"'
      i += 1
    } else if (char === '"') {
      inQuotes = !inQuotes
    } else if (char === ',' && !inQuotes) {
      cells.push(current.trim())
      current = ''
    } else {
      current += char
    }
  }

  cells.push(current.trim())
  return cells
}

export function normalizeInviteRole(role) {
  return role.trim().toLowerCase()
}

export function rowValidationError({ email, role }) {
  if (!email) return 'Email is required.'
  if (!isValidEmail(email)) return 'Invalid email.'
  if (role !== 'teacher' && role !== 'parent') return 'Role must be teacher or parent.'
  return ''
}

export function parseInviteCsv(text) {
  const lines = text
    .replace(/^\uFEFF/, '')
    .split(/\r?\n/)
    .map(line => line.trim())
    .filter(Boolean)

  if (lines.length < 2) {
    throw new Error('CSV needs a header row and at least one user row.')
  }

  const headers = splitCsvLine(lines[0]).map(header => header.toLowerCase())
  const emailIdx = headers.indexOf('email')
  const nameIdx = headers.indexOf('full_name')
  const roleIdx = headers.indexOf('role')

  if (emailIdx === -1 || nameIdx === -1 || roleIdx === -1) {
    throw new Error('CSV header must include email, full_name, and role.')
  }

  return lines.slice(1).map((line, idx) => {
    const cells = splitCsvLine(line)
    const email = (cells[emailIdx] ?? '').trim().toLowerCase()
    const fullName = (cells[nameIdx] ?? '').trim()
    const role = normalizeInviteRole(cells[roleIdx] ?? '')
    const error = rowValidationError({ email, role })

    return {
      id: `csv-${Date.now()}-${idx}`,
      email,
      fullName,
      role,
      status: error ? 'error' : 'pending',
      error,
      batchRowId: null,
    }
  })
}

/* ─── Status / severity / label helpers ───────────────────────────────── */

export function inviteStatusStyles(status) {
  if (status === 'success') {
    return { background: 'var(--cal-success-lt)', color: 'var(--cal-success)' }
  }
  if (status === 'error') {
    return { background: '#FDEDED', color: '#B3261E' }
  }
  if (status === 'importing') {
    return { background: 'var(--cal-amber-lt)', color: 'var(--cal-amber-dark)' }
  }
  return { background: 'var(--cal-border-lt)', color: 'var(--cal-muted)' }
}

export function severityStyles(severity) {
  if (severity === 'high') {
    return { background: '#FDEDED', color: '#B3261E', borderColor: '#F4C7C3' }
  }
  if (severity === 'medium') {
    return { background: 'var(--cal-amber-lt)', color: 'var(--cal-amber-dark)', borderColor: 'var(--cal-amber)' }
  }
  return { background: 'var(--cal-teal-lt)', color: 'var(--cal-teal)', borderColor: 'var(--cal-teal)' }
}

export function actionTypeLabel(type) {
  const labels = {
    invite_failed: 'Invite failed',
    no_progress: 'No progress',
    stalled: 'Stalled',
    overdue: 'Overdue',
    quiz_weak: 'Quiz weak spot',
  }
  return labels[type] ?? type
}

export function modulePillLabel(slug) {
  if (!slug) return null
  const meta = MODULE_META[slug]
  return meta ? `${meta.flag} ${meta.label.replace('Understand ', '')}` : slug
}
