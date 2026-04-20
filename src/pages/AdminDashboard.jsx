import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import TopBar from '../components/TopBar'
import { useAuth } from '../context/AuthContext'
import {
  createAssignment,
  createInviteBatch,
  createInviteBatchRows,
  deleteAssignment,
  getAdminActionItems,
  getCompletions,
  getGradeOverrides,
  getModuleQuizAnalytics,
  getModuleQuizQuestions,
  getUserModuleScores,
  inviteUser,
  refreshAdminActionItems,
  resolveAdminActionItem,
  updateAssignment,
  updateInviteBatchCounts,
  upsertCompletion,
  upsertGradeOverride,
  getSchoolMembers,
  updateMemberProfile,
  getAllSchools,
} from '../lib/supabase'
import {
  MOCK_USERS, MOCK_ASSIGNMENTS, MODULE_META,
  MOCK_ADMIN_ACTION_ITEMS, MOCK_QUIZ_ANALYTICS,
  getActiveModuleSlugs, getSchoolStats, MOCK_SCHOOL,
} from '../data/mockData'

const MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL

/* ── helpers ── */
const COMPLETION_THRESHOLD = 80

function cellStatus(pct) {
  if (pct >= COMPLETION_THRESHOLD) return 'done'
  if (pct > 0) return 'progress'
  return 'none'
}

function fmtDate(dateStr) {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })
}

function daysUntil(dateStr) {
  if (!dateStr) return null
  const diff = Math.ceil((new Date(dateStr) - new Date()) / 86400000)
  return diff
}

function quizLabel(question) {
  if (question.quiz_type === 'final_exam') return `Final · Q${question.sort_order}`
  return `D${question.dimension_number} · Checkpoint`
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

function splitCsvLine(line) {
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

function normalizeInviteRole(role) {
  return role.trim().toLowerCase()
}

function rowValidationError({ email, role }) {
  if (!email) return 'Email is required.'
  if (!isValidEmail(email)) return 'Invalid email.'
  if (role !== 'teacher' && role !== 'parent') return 'Role must be teacher or parent.'
  return ''
}

function parseInviteCsv(text) {
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

function inviteStatusStyles(status) {
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

function severityStyles(severity) {
  if (severity === 'high') {
    return { background: '#FDEDED', color: '#B3261E', borderColor: '#F4C7C3' }
  }
  if (severity === 'medium') {
    return { background: 'var(--cal-amber-lt)', color: 'var(--cal-amber-dark)', borderColor: 'var(--cal-amber)' }
  }
  return { background: 'var(--cal-teal-lt)', color: 'var(--cal-teal)', borderColor: 'var(--cal-teal)' }
}

function actionTypeLabel(type) {
  const labels = {
    invite_failed: 'Invite failed',
    no_progress: 'No progress',
    stalled: 'Stalled',
    overdue: 'Overdue',
    quiz_weak: 'Quiz weak spot',
  }
  return labels[type] ?? type
}

function modulePillLabel(slug) {
  if (!slug) return null
  const meta = MODULE_META[slug]
  return meta ? `${meta.flag} ${meta.label.replace('Understand ', '')}` : slug
}

function aggregateQuizAnalytics(responses, questions) {
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

/* ── sub-components ── */

function StatCard({ value, label, sub, accent }) {
  return (
    <div style={{
      background: '#fff',
      borderRadius: 'var(--r-lg)',
      padding: '20px 22px',
      boxShadow: 'var(--shadow-sm)',
      borderTop: `3px solid ${accent}`,
      flex: 1,
      minWidth: 0,
    }}>
      <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, fontWeight: 800, color: accent, lineHeight: 1, marginBottom: 6 }}>
        {value}
      </div>
      <div style={{ fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 2 }}>
        {label}
      </div>
      {sub && <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>{sub}</div>}
    </div>
  )
}

function CompletionCell({ pct }) {
  const status = cellStatus(pct ?? -1)

  if (pct === undefined || pct === null || pct === -1) {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <span style={{ color: '#C8C4BE', fontSize: 14 }}>—</span>
      </td>
    )
  }

  if (status === 'done') {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <div style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          width: 28, height: 28, borderRadius: '50%',
          background: 'var(--cal-success-lt)',
        }}>
          <span style={{ fontSize: 13, color: 'var(--cal-success)' }}>✓</span>
        </div>
      </td>
    )
  }

  if (status === 'progress') {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <div style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          width: 28, height: 28, borderRadius: '50%',
          background: 'var(--cal-amber-lt)',
          fontFamily: 'var(--font-display)', fontSize: 9, fontWeight: 700,
          color: 'var(--cal-amber-dark)',
        }}>
          {pct}%
        </div>
      </td>
    )
  }

  return (
    <td style={{ textAlign: 'center', padding: '10px 8px' }}>
      <div style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        width: 28, height: 28, borderRadius: '50%',
        background: 'var(--cal-border-lt)',
        fontSize: 12, color: 'var(--cal-border)',
      }}>
        ○
      </div>
    </td>
  )
}

/* ── Main component ── */

export default function AdminDashboard() {
  const navigate = useNavigate()
  const { user, profile, school, isSuperAdmin } = useAuth()
  const schoolName = school?.name ?? MOCK_SCHOOL.name
  const [roleFilter, setRoleFilter]   = useState('all')   // 'all' | 'teacher' | 'parent'
  const [adminView,  setAdminView]    = useState('overview') // 'overview' | 'users' | 'assign'
  const [assignForm, setAssignForm]   = useState({ moduleSlug: '', roleTarget: 'teacher', dueDate: '', selectedUserIds: [] })
  const [assignments, setAssignments] = useState(MOCK_ASSIGNMENTS)
  const [assignSaved, setAssignSaved] = useState(false)
  const [assignError, setAssignError] = useState('')
  const [selectedUser, setSelectedUser] = useState(null)  // for user detail modal

  // Analytics state
  const [analyticsSlug,    setAnalyticsSlug]    = useState('india-ib')
  const [analyticsData,    setAnalyticsData]    = useState(MOCK_MODE ? (MOCK_QUIZ_ANALYTICS['india-ib'] ?? []) : null)
  const [analyticsLoading, setAnalyticsLoading] = useState(false)
  const [analyticsError,   setAnalyticsError]   = useState('')

  // Invite member state
  const [inviteForm,  setInviteForm]  = useState({ email: '', role: 'teacher', fullName: '' })
  const [inviteSaved, setInviteSaved] = useState(false)
  const [inviteError, setInviteError] = useState('')
  const [csvRows, setCsvRows] = useState([])
  const [csvError, setCsvError] = useState('')
  const [csvImporting, setCsvImporting] = useState(false)
  const [csvSummary, setCsvSummary] = useState(null)

  // Action queue state
  const [actionItems, setActionItems] = useState(MOCK_MODE ? MOCK_ADMIN_ACTION_ITEMS : [])
  const [actionLoading, setActionLoading] = useState(false)
  const [actionRefreshing, setActionRefreshing] = useState(false)
  const [actionError, setActionError] = useState('')

  // School members — real profiles in prod, mock roster in mock mode. Used by
  // the Members tab, Assign "Specific users" picker, and per-user lookups.
  const [members, setMembers] = useState(MOCK_MODE ? MOCK_USERS : [])
  const [membersLoading, setMembersLoading] = useState(false)
  const [membersError, setMembersError] = useState('')

  // All schools — populated only for superadmin; used by the edit modal to
  // let superadmins move a member to a different school.
  const [allSchools, setAllSchools] = useState([])

  // Per-user edit state — when non-null, the user detail modal shows a
  // form instead of the read-only profile view.
  const [editMode, setEditMode]   = useState(false)
  const [editForm, setEditForm]   = useState({ fullName: '', role: 'teacher', schoolId: '' })
  const [editSaving, setEditSaving] = useState(false)
  const [editError, setEditError]   = useState('')

  // "Add new member" modal — invite + optional auto-assign modules with due dates.
  const [addMemberOpen, setAddMemberOpen] = useState(false)
  const [addMemberForm, setAddMemberForm] = useState({
    email: '', fullName: '', role: 'teacher',
    selectedModules: {}, // { slug: 'yyyy-mm-dd' } — presence = selected
    welcomeMessage: '',
  })
  const [addMemberSaving, setAddMemberSaving] = useState(false)
  const [addMemberError, setAddMemberError]   = useState('')

  // Per-user edit state: fetched when the detail modal opens.
  // completions: { slug: pct }; scores: { slug: { quiz_type: pct } };
  // overrides: [{ module_slug, quiz_type, override_score, reason, created_at }]
  const [userCompletions, setUserCompletions] = useState({})
  const [userScores,      setUserScores]      = useState({})
  const [userOverrides,   setUserOverrides]   = useState([])
  const [userDetailLoading, setUserDetailLoading] = useState(false)
  const [userDetailRefreshKey, setUserDetailRefreshKey] = useState(0)

  // Inline edit state for a single individual assignment due date.
  const [dueDateEditing, setDueDateEditing] = useState({}) // { [assignmentId]: 'yyyy-mm-dd' }
  const [dueDateSaving,  setDueDateSaving]  = useState(null)

  // 'Add module' picker inside the user modal.
  const [addModuleForm, setAddModuleForm] = useState({ slug: '', dueDate: '' })
  const [addModuleSaving, setAddModuleSaving] = useState(false)
  const [addModuleError,  setAddModuleError]  = useState('')

  // Per-module progress override input.
  const [progressEdit,    setProgressEdit]   = useState({}) // { slug: pct }
  const [progressSaving,  setProgressSaving] = useState(null)

  // Grade override inline form: null when closed.
  const [gradeOverrideForm, setGradeOverrideForm] = useState(null)
  // { slug, quizType, score: '', reason: '' }
  const [gradeOverrideSaving, setGradeOverrideSaving] = useState(false)
  const [gradeOverrideError,  setGradeOverrideError]  = useState('')

  // First-run "what Habterra is (and isn't)" explainer. Dismissal persists per-admin in localStorage.
  const primerKey = `calibrate.adminPrimerDismissed.${user?.id ?? 'anon'}`
  const [primerDismissed, setPrimerDismissed] = useState(() => {
    try { return typeof window !== 'undefined' && window.localStorage.getItem(primerKey) === '1' }
    catch { return false }
  })
  const dismissPrimer = () => {
    setPrimerDismissed(true)
    try { window.localStorage.setItem(primerKey, '1') } catch {}
  }

  const stats      = getSchoolStats()
  const activeSlugs = getActiveModuleSlugs(roleFilter)

  const visibleUsers = members.filter(u =>
    roleFilter === 'all' ? true : u.role === roleFilter
  )
  const csvImportableCount = csvRows.filter(row => row.status === 'pending').length
  const openActionCount = actionItems.length

  useEffect(() => {
    if (MOCK_MODE) {
      setAnalyticsData(MOCK_QUIZ_ANALYTICS[analyticsSlug] ?? [])
      setAnalyticsLoading(false)
      setAnalyticsError('')
      return
    }

    const moduleId = MODULE_META[analyticsSlug]?.dbId
    if (!moduleId) {
      setAnalyticsData([])
      return
    }

    let active = true
    setAnalyticsLoading(true)
    setAnalyticsError('')

    Promise.all([
      getModuleQuizAnalytics(moduleId),
      getModuleQuizQuestions(moduleId),
    ])
      .then(([responses, questions]) => {
        if (!active) return
        setAnalyticsData(aggregateQuizAnalytics(responses, questions))
        setAnalyticsLoading(false)
      })
      .catch(err => {
        if (!active) return
        setAnalyticsError(err?.message || 'Failed to load quiz analytics.')
        setAnalyticsData([])
        setAnalyticsLoading(false)
      })

    return () => { active = false }
  }, [analyticsSlug])

  useEffect(() => {
    if (adminView !== 'actions') return

    if (MOCK_MODE) {
      setActionItems(MOCK_ADMIN_ACTION_ITEMS)
      setActionLoading(false)
      setActionError('')
      return
    }

    const schoolId = profile?.school_id
    if (!schoolId) return

    let active = true
    setActionLoading(true)
    setActionError('')

    getAdminActionItems(schoolId)
      .then(items => {
        if (!active) return
        setActionItems(items)
        setActionLoading(false)
      })
      .catch(err => {
        if (!active) return
        setActionError(err?.message ?? 'Failed to load action items.')
        setActionItems([])
        setActionLoading(false)
      })

    return () => { active = false }
  }, [adminView, profile?.school_id])

  // Load real school members from Supabase. In mock mode the initial state
  // already holds MOCK_USERS; in prod we fetch from `profiles`. We refetch
  // whenever the admin switches school or a save in the edit modal flips
  // `membersRefreshKey`.
  const [membersRefreshKey, setMembersRefreshKey] = useState(0)
  useEffect(() => {
    if (MOCK_MODE) return
    const schoolId = profile?.school_id
    if (!schoolId) return
    let active = true
    setMembersLoading(true)
    setMembersError('')
    getSchoolMembers(schoolId)
      .then(rows => {
        if (!active) return
        setMembers(rows)
        setMembersLoading(false)
      })
      .catch(err => {
        if (!active) return
        setMembersError(err?.message ?? 'Failed to load members.')
        setMembersLoading(false)
      })
    return () => { active = false }
  }, [profile?.school_id, membersRefreshKey])

  // When the detail modal opens (selectedUser set), pull real completions,
  // quiz scores, and any prior grade overrides. MOCK mode short-circuits.
  useEffect(() => {
    if (!selectedUser) {
      setUserCompletions({})
      setUserScores({})
      setUserOverrides([])
      setProgressEdit({})
      setGradeOverrideForm(null)
      setAddModuleForm({ slug: '', dueDate: '' })
      setAddModuleError('')
      setDueDateEditing({})
      return
    }
    if (MOCK_MODE) {
      setUserCompletions({})
      setUserScores({})
      setUserOverrides([])
      return
    }
    let cancelled = false
    setUserDetailLoading(true)
    ;(async () => {
      try {
        const [comp, scores, overrides] = await Promise.all([
          getCompletions(selectedUser.id),
          getUserModuleScores(selectedUser.id),
          getGradeOverrides(selectedUser.id),
        ])
        if (cancelled) return
        const completionsMap = {}
        for (const row of comp ?? []) completionsMap[row.module_slug] = row.progress_pct ?? 0
        // scores are per-module-id; invert via MODULE_META's dbId.
        const moduleIdToSlug = {}
        for (const [slug, m] of Object.entries(MODULE_META)) if (m.dbId) moduleIdToSlug[m.dbId] = slug
        const scoreMap = {}
        for (const row of scores ?? []) {
          const slug = moduleIdToSlug[row.module_id]
          if (!slug) continue
          if (!scoreMap[slug]) scoreMap[slug] = {}
          scoreMap[slug][row.quiz_type] = { pct: row.pct, correct: row.correct, total: row.total }
        }
        setUserCompletions(completionsMap)
        setUserScores(scoreMap)
        setUserOverrides(overrides ?? [])
      } catch (err) {
        console.warn('[user-detail fetch] failed:', err)
      } finally {
        if (!cancelled) setUserDetailLoading(false)
      }
    })()
    return () => { cancelled = true }
  }, [selectedUser?.id, userDetailRefreshKey])

  // Superadmins get the school list so they can move a member between schools.
  useEffect(() => {
    if (MOCK_MODE) { setAllSchools([MOCK_SCHOOL]); return }
    if (!isSuperAdmin) return
    let active = true
    getAllSchools()
      .then(rows => { if (active) setAllSchools(rows) })
      .catch(() => { if (active) setAllSchools([]) })
    return () => { active = false }
  }, [isSuperAdmin])

  // Which slugs each user should have (based on assignments)
  function userSlugs(user) {
    return assignments
      .filter(a => a.role_target === 'all' || a.role_target === user.role)
      .map(a => a.module_slug)
  }

  // Aggregate completion %s across all a user's required modules
  function userOverallPct(user) {
    const slugs = userSlugs(user)
    if (slugs.length === 0) return 0
    const total = slugs.reduce((acc, s) => acc + (user.completions[s] ?? 0), 0)
    return Math.round(total / slugs.length)
  }

  async function handleAssign(e) {
    e.preventDefault()
    if (!assignForm.moduleSlug) return
    setAssignError('')

    // Real school_id is a UUID from the profiles table. In mock mode we can
    // fall through to MOCK_SCHOOL; in prod we refuse rather than insert a
    // bogus id and hit a DB constraint.
    const rawSchoolId = profile?.school_id
    const schoolId = (typeof rawSchoolId === 'string' && rawSchoolId.length > 0)
      ? rawSchoolId
      : (MOCK_MODE ? MOCK_SCHOOL.id : null)
    if (!schoolId) {
      setAssignError("We couldn't find your school on your profile. Refresh the page, or contact support if this persists.")
      return
    }
    const dueDate  = assignForm.dueDate || null

    // Individual-user targeting: one row per selected user.
    if (assignForm.roleTarget === 'users') {
      if (assignForm.selectedUserIds.length === 0) {
        setAssignError('Pick at least one person, or switch to a role bucket.')
        return
      }
      const selected = members.filter(u => assignForm.selectedUserIds.includes(u.id))
      const newRows = selected.map(u => ({
        id:          `a${Date.now()}-${u.id}`,
        school_id:   schoolId,
        user_id:     u.id,
        module_slug: assignForm.moduleSlug,
        role_target: u.role,
        due_date:    dueDate,
        assigned_at: new Date().toISOString(),
      }))
      if (!MOCK_MODE) {
        try {
          for (const u of selected) {
            await createAssignment({
              schoolId,
              userId:     u.id,
              roleTarget: u.role,
              moduleSlug: assignForm.moduleSlug,
              assignedBy: user?.id,
              dueDate,
            })
          }
        } catch (err) {
          setAssignError(err.message ?? 'Failed to save one or more assignments. Please try again.')
          return
        }
      }
      setAssignments(prev => [...prev, ...newRows])
      setAssignForm({ moduleSlug: '', roleTarget: 'teacher', dueDate: '', selectedUserIds: [] })
      setAssignSaved(true)
      setTimeout(() => setAssignSaved(false), 3000)
      return
    }

    // Role-bucket targeting (teacher / parent / all): one row with user_id=null.
    const newAsgn = {
      id: `a${Date.now()}`,
      school_id:   schoolId,
      user_id:     null,
      module_slug: assignForm.moduleSlug,
      role_target: assignForm.roleTarget,
      due_date:    dueDate,
      assigned_at: new Date().toISOString(),
    }
    if (!MOCK_MODE) {
      try {
        await createAssignment({
          schoolId,
          userId:     null,
          roleTarget: assignForm.roleTarget,
          moduleSlug: assignForm.moduleSlug,
          assignedBy: user?.id,
          dueDate,
        })
      } catch (err) {
        setAssignError(err.message ?? 'Failed to save assignment. Please try again.')
        return
      }
    }
    setAssignments(prev => [...prev, newAsgn])
    setAssignForm({ moduleSlug: '', roleTarget: 'teacher', dueDate: '', selectedUserIds: [] })
    setAssignSaved(true)
    setTimeout(() => setAssignSaved(false), 3000)
  }

  // Remove an existing assignment. Optimistic: drops from local state
  // first, rolls back on failure so a tab refresh isn't needed to see
  // the delete. Mock-mode skips the network call entirely.
  async function handleUnassign(assignment) {
    const meta = MODULE_META[assignment.module_slug]
    const label = meta?.label ?? assignment.module_slug
    let audience
    if (assignment.user_id) {
      const targetUser = members.find(u => u.id === assignment.user_id)
      audience = targetUser?.full_name ?? 'this user'
    } else if (assignment.role_target === 'all') {
      audience = 'everyone'
    } else {
      audience = `${assignment.role_target}s`
    }
    if (!window.confirm(`Remove "${label}" from ${audience}?`)) return

    const previous = assignments
    setAssignments(prev => prev.filter(a => a.id !== assignment.id))

    if (!MOCK_MODE) {
      try {
        await deleteAssignment(assignment.id)
      } catch (err) {
        setAssignments(previous)
        window.alert(err.message ?? 'Failed to remove assignment.')
      }
    }
  }

  // Open the edit form inside the user detail modal. Pre-populates from the
  // currently selected user; only superadmin can move members between schools.
  function openEditMode() {
    if (!selectedUser) return
    setEditForm({
      fullName: selectedUser.full_name ?? '',
      role:     selectedUser.role     ?? 'teacher',
      schoolId: selectedUser.school_id ?? profile?.school_id ?? '',
    })
    setEditError('')
    setEditMode(true)
  }

  function cancelEditMode() {
    setEditMode(false)
    setEditError('')
  }

  async function saveMemberEdit() {
    if (!selectedUser) return
    setEditSaving(true)
    setEditError('')
    try {
      if (!MOCK_MODE) {
        await updateMemberProfile({
          userId:   selectedUser.id,
          fullName: editForm.fullName.trim() || null,
          role:     editForm.role,
          // Only submit schoolId when superadmin actually changed it — avoids
          // accidentally re-asserting it on regular admin saves.
          ...(isSuperAdmin && editForm.schoolId && editForm.schoolId !== selectedUser.school_id
            ? { schoolId: editForm.schoolId }
            : {}),
        })
      }
      // Optimistic: update the local roster row in place and refresh list.
      setMembers(prev => prev.map(u => u.id === selectedUser.id ? {
        ...u,
        full_name: editForm.fullName.trim() || null,
        role:      editForm.role,
        school_id: (isSuperAdmin && editForm.schoolId) ? editForm.schoolId : u.school_id,
      } : u))
      setSelectedUser(u => u ? {
        ...u,
        full_name: editForm.fullName.trim() || null,
        role:      editForm.role,
        school_id: (isSuperAdmin && editForm.schoolId) ? editForm.schoolId : u.school_id,
      } : u)
      setMembersRefreshKey(k => k + 1)
      setEditMode(false)
    } catch (err) {
      setEditError(err?.message ?? 'Failed to save. Please try again.')
    } finally {
      setEditSaving(false)
    }
  }

  // "Add new member" modal: open / close / module toggle / submit.
  function openAddMember() {
    setAddMemberForm({
      email: '', fullName: '',
      role: 'teacher',
      selectedModules: {},
      welcomeMessage: '',
    })
    setAddMemberError('')
    setAddMemberOpen(true)
  }

  function closeAddMember() {
    setAddMemberOpen(false)
    setAddMemberError('')
  }

  function toggleAddMemberModule(slug) {
    setAddMemberForm(f => {
      const next = { ...f.selectedModules }
      if (slug in next) delete next[slug]
      else next[slug] = ''
      return { ...f, selectedModules: next }
    })
  }

  function setAddMemberModuleDue(slug, due) {
    setAddMemberForm(f => ({
      ...f,
      selectedModules: { ...f.selectedModules, [slug]: due },
    }))
  }

  async function handleAddMember() {
    const email = addMemberForm.email.trim().toLowerCase()
    const fullName = addMemberForm.fullName.trim()
    const role = addMemberForm.role
    const schoolId = profile?.school_id ?? MOCK_SCHOOL.id
    const moduleEntries = Object.entries(addMemberForm.selectedModules)
    const welcomeMessage = addMemberForm.welcomeMessage.trim()

    setAddMemberError('')

    if (!isValidEmail(email)) {
      setAddMemberError('Please enter a valid email address.')
      return
    }
    if (!fullName) {
      setAddMemberError("Please enter the member's full name.")
      return
    }
    if (!schoolId) {
      setAddMemberError('No school selected. Contact support if this persists.')
      return
    }

    setAddMemberSaving(true)
    try {
      const result = await inviteUser({
        email, fullName, role, schoolId,
        welcomeMessage: welcomeMessage || undefined,
        assignedBy: user?.id,
      })
      const newUserId = result?.user_id ?? result?.userId ?? null

      // In prod, create assignments for each selected module.
      if (!MOCK_MODE && newUserId && moduleEntries.length > 0) {
        for (const [slug, due] of moduleEntries) {
          try {
            await createAssignment({
              schoolId,
              userId: newUserId,
              roleTarget: role,
              moduleSlug: slug,
              assignedBy: user?.id,
              dueDate: due || null,
            })
          } catch (err) {
            // Don't abort: surface in console so partial success is recoverable.
            console.warn(`Failed to assign ${slug} to ${email}:`, err)
          }
        }
      }

      // Optimistic: add the new row so admin sees them immediately, then refresh.
      setMembers(prev => [
        ...prev,
        {
          id: newUserId ?? `pending-${Date.now()}`,
          email, full_name: fullName, role, school_id: schoolId,
          completions: {},
        },
      ])
      setMembersRefreshKey(k => k + 1)
      setAddMemberOpen(false)
    } catch (err) {
      setAddMemberError(err?.message ?? 'Failed to add member. Please try again.')
    } finally {
      setAddMemberSaving(false)
    }
  }

  // ---------- User detail modal: edit handlers ----------

  async function handleSaveDueDate(assignment) {
    const newDate = dueDateEditing[assignment.id]
    if (newDate === undefined) return
    const dueDate = newDate || null
    setDueDateSaving(assignment.id)
    try {
      if (!MOCK_MODE) await updateAssignment(assignment.id, { dueDate })
      setAssignments(prev => prev.map(a => a.id === assignment.id ? { ...a, due_date: dueDate } : a))
      setDueDateEditing(prev => {
        const next = { ...prev }
        delete next[assignment.id]
        return next
      })
    } catch (err) {
      window.alert(err?.message ?? 'Failed to update due date.')
    } finally {
      setDueDateSaving(null)
    }
  }

  async function handleAddModuleToUser() {
    if (!selectedUser || !addModuleForm.slug) return
    const schoolId = profile?.school_id ?? MOCK_SCHOOL.id
    const dueDate = addModuleForm.dueDate || null
    setAddModuleError('')
    setAddModuleSaving(true)
    try {
      let newRow
      if (!MOCK_MODE) {
        const created = await createAssignment({
          schoolId,
          userId: selectedUser.id,
          roleTarget: selectedUser.role,
          moduleSlug: addModuleForm.slug,
          assignedBy: user?.id,
          dueDate,
        })
        // createAssignment returns {id, ...} — build a local row.
        newRow = {
          id: created?.id ?? `tmp-${Date.now()}`,
          school_id: schoolId,
          user_id:   selectedUser.id,
          module_slug: addModuleForm.slug,
          role_target: selectedUser.role,
          due_date:    dueDate,
          assigned_at: new Date().toISOString(),
        }
      } else {
        newRow = {
          id: `a${Date.now()}`,
          school_id: schoolId,
          user_id:   selectedUser.id,
          module_slug: addModuleForm.slug,
          role_target: selectedUser.role,
          due_date:    dueDate,
          assigned_at: new Date().toISOString(),
        }
      }
      setAssignments(prev => [...prev, newRow])
      setAddModuleForm({ slug: '', dueDate: '' })
    } catch (err) {
      setAddModuleError(err?.message ?? 'Failed to add module.')
    } finally {
      setAddModuleSaving(false)
    }
  }

  async function handleSaveProgress(slug) {
    if (!selectedUser) return
    const raw = progressEdit[slug]
    if (raw === undefined) return
    const pct = Math.max(0, Math.min(100, Number(raw) || 0))
    setProgressSaving(slug)
    try {
      if (!MOCK_MODE) await upsertCompletion(selectedUser.id, slug, pct)
      setUserCompletions(prev => ({ ...prev, [slug]: pct }))
      setProgressEdit(prev => {
        const next = { ...prev }
        delete next[slug]
        return next
      })
    } catch (err) {
      window.alert(err?.message ?? 'Failed to save progress.')
    } finally {
      setProgressSaving(null)
    }
  }

  function openGradeOverride(slug, quizType, currentScore) {
    setGradeOverrideForm({
      slug,
      quizType,
      score: currentScore != null ? String(currentScore) : '',
      reason: '',
    })
    setGradeOverrideError('')
  }

  function closeGradeOverride() {
    setGradeOverrideForm(null)
    setGradeOverrideError('')
  }

  async function handleSaveGradeOverride() {
    if (!selectedUser || !gradeOverrideForm) return
    const score = Number(gradeOverrideForm.score)
    if (!Number.isFinite(score) || score < 0 || score > 100) {
      setGradeOverrideError('Score must be a number between 0 and 100.')
      return
    }
    setGradeOverrideSaving(true)
    setGradeOverrideError('')
    try {
      if (!MOCK_MODE) {
        await upsertGradeOverride({
          userId: selectedUser.id,
          moduleSlug: gradeOverrideForm.slug,
          quizType: gradeOverrideForm.quizType,
          overrideScore: score,
          reason: gradeOverrideForm.reason.trim() || null,
          adminId: user?.id,
        })
      }
      // Optimistic: refresh just this user's overrides list.
      setUserOverrides(prev => {
        const without = prev.filter(o => !(o.module_slug === gradeOverrideForm.slug && o.quiz_type === gradeOverrideForm.quizType))
        return [
          {
            id: `opt-${Date.now()}`,
            user_id: selectedUser.id,
            module_slug: gradeOverrideForm.slug,
            quiz_type: gradeOverrideForm.quizType,
            override_score: score,
            reason: gradeOverrideForm.reason.trim() || null,
            created_by: user?.id ?? null,
            created_at: new Date().toISOString(),
          },
          ...without,
        ]
      })
      setGradeOverrideForm(null)
      setUserDetailRefreshKey(k => k + 1)
    } catch (err) {
      setGradeOverrideError(err?.message ?? 'Failed to save override. Check that the grade_overrides table exists.')
    } finally {
      setGradeOverrideSaving(false)
    }
  }

  async function handleSingleInvite(e) {
    e.preventDefault()
    const email = inviteForm.email.trim().toLowerCase()
    const fullName = inviteForm.fullName.trim()
    const role = inviteForm.role
    const validationError = rowValidationError({ email, role })

    setInviteError('')
    setInviteSaved(false)

    if (validationError) {
      setInviteError(validationError)
      return
    }

    try {
      await inviteUser({
        email,
        fullName,
        role,
        schoolId: profile?.school_id ?? MOCK_SCHOOL.id,
        assignedBy: user?.id,
      })
      setInviteSaved(true)
      setInviteForm({ email: '', role: 'teacher', fullName: '' })
      setTimeout(() => setInviteSaved(false), 4000)
    } catch (err) {
      setInviteError(err?.message ?? 'Failed to send invitation.')
    }
  }

  function updateCsvRow(rowId, patch) {
    setCsvRows(prev => prev.map(row => (
      row.id === rowId ? { ...row, ...patch } : row
    )))
  }

  function handleCsvFile(e) {
    const file = e.target.files?.[0]
    setCsvError('')
    setCsvSummary(null)

    if (!file) {
      setCsvRows([])
      return
    }

    const reader = new FileReader()
    reader.onload = event => {
      try {
        const rows = parseInviteCsv(String(event.target?.result ?? ''))
        setCsvRows(rows)
      } catch (err) {
        setCsvRows([])
        setCsvError(err?.message ?? 'Could not parse CSV.')
      }
    }
    reader.onerror = () => {
      setCsvRows([])
      setCsvError('Could not read the selected file.')
    }
    reader.readAsText(file)
  }

  async function handleCsvImport() {
    const schoolId = profile?.school_id ?? MOCK_SCHOOL.id
    const createdBy = user?.id ?? null
    const rowsToRecord = csvRows.map(row => ({
      ...row,
      status: row.status === 'pending' ? 'pending' : 'failed',
      error: row.error || null,
    }))
    const importableRows = csvRows.filter(row => row.status === 'pending')

    if (csvImporting || importableRows.length === 0) return

    setCsvError('')
    setCsvSummary(null)
    setCsvImporting(true)

    let imported = 0
    let failed = csvRows.filter(row => row.status === 'error').length
    let batchId = null

    try {
      const batch = await createInviteBatch({
        schoolId,
        createdBy,
        totalRows: csvRows.length,
      })
      batchId = batch.id

      const batchRows = await createInviteBatchRows({
        batchId,
        rows: rowsToRecord,
      })
      const batchRowByIndex = new Map(batchRows.map((row, idx) => [idx, row]))

      setCsvRows(prev => prev.map((row, idx) => ({
        ...row,
        batchRowId: batchRowByIndex.get(idx)?.id ?? row.batchRowId,
      })))

      await updateInviteBatchCounts(batchId, {
        imported,
        failed,
        status: 'running',
      })

      for (let idx = 0; idx < csvRows.length; idx += 1) {
        const row = csvRows[idx]
        const batchRowId = batchRowByIndex.get(idx)?.id

        if (row.status !== 'pending') continue

        updateCsvRow(row.id, { status: 'importing', error: '' })

        try {
          const result = await inviteUser({
            email: row.email,
            fullName: row.fullName,
            role: row.role,
            schoolId,
            assignedBy: createdBy,
            batchRowId,
          })
          imported += 1
          updateCsvRow(row.id, {
            status: 'success',
            error: '',
            batchRowId,
            userId: result?.userId,
          })
        } catch (err) {
          failed += 1
          updateCsvRow(row.id, {
            status: 'error',
            error: err?.message ?? 'Invitation failed.',
            batchRowId,
          })
        }

        await updateInviteBatchCounts(batchId, {
          imported,
          failed,
          status: 'running',
        })
      }

      const finalStatus = failed === 0 ? 'completed' : imported === 0 ? 'failed' : 'partial'
      await updateInviteBatchCounts(batchId, {
        imported,
        failed,
        status: finalStatus,
      })
      setCsvSummary({ imported, failed })
    } catch (err) {
      setCsvError(err?.message ?? 'CSV import failed.')
      if (batchId) {
        try {
          await updateInviteBatchCounts(batchId, {
            imported,
            failed,
            status: imported > 0 ? 'partial' : 'failed',
          })
        } catch {
          // Keep the original import error visible.
        }
      }
    } finally {
      setCsvImporting(false)
    }
  }

  async function handleActionRefresh() {
    const schoolId = profile?.school_id ?? MOCK_SCHOOL.id
    setActionError('')
    setActionRefreshing(true)

    try {
      if (MOCK_MODE) {
        await new Promise(resolve => setTimeout(resolve, 250))
        setActionItems(MOCK_ADMIN_ACTION_ITEMS)
      } else {
        await refreshAdminActionItems(schoolId)
        const items = await getAdminActionItems(schoolId)
        setActionItems(items)
      }
    } catch (err) {
      setActionError(err?.message ?? 'Failed to refresh action items.')
    } finally {
      setActionRefreshing(false)
    }
  }

  async function handleActionResolve(itemId) {
    setActionError('')
    try {
      if (!MOCK_MODE) {
        await resolveAdminActionItem(itemId)
      }
      setActionItems(prev => prev.filter(item => item.id !== itemId))
    } catch (err) {
      setActionError(err?.message ?? 'Failed to resolve action item.')
    }
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
      <TopBar activePage="admin" />

      <div style={{ display: 'flex', flex: 1, overflow: 'hidden' }}>

        {/* ── Admin sidebar ── */}
        <aside className="admin-sidebar" style={{
          width: 200,
          background: 'var(--cal-teal-dark, #083D4A)',
          display: 'flex',
          flexDirection: 'column',
          padding: '28px 14px',
          flexShrink: 0,
        }}>
          <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 600, letterSpacing: '0.14em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.35)', marginBottom: 12 }}>
            Admin
          </div>
          {[
            { key: 'overview',   icon: '▦', label: 'Overview' },
            { key: 'users',      icon: '⊡', label: 'Members' },
            { key: 'actions',    icon: '!', label: `Action Queue${openActionCount ? ` (${openActionCount})` : ''}` },
            { key: 'assign',     icon: '+', label: 'Assign Modules' },
            { key: 'analytics',  icon: '◈', label: 'Quiz Analytics' },
            { key: 'invite',     icon: '→', label: 'Invite Member' },
          ].map(item => (
            <button
              key={item.key}
              onClick={() => setAdminView(item.key)}
              style={{
                display: 'flex', alignItems: 'center', gap: 10,
                padding: '9px 12px', borderRadius: 'var(--r-sm)',
                border: 'none', cursor: 'pointer',
                background: adminView === item.key ? 'rgba(255,255,255,0.12)' : 'transparent',
                color: adminView === item.key ? '#fff' : 'rgba(255,255,255,0.55)',
                fontFamily: 'var(--font-body)',
                fontSize: 13, fontWeight: adminView === item.key ? 500 : 400,
                textAlign: 'left', width: '100%',
                marginBottom: 2,
                transition: 'background 0.15s, color 0.15s',
              }}
            >
              <span style={{ fontSize: 11, opacity: 0.7 }}>{item.icon}</span>
              {item.label}
            </button>
          ))}

          <div style={{ flex: 1 }} />

          {/* Back to my modules */}
          <button
            onClick={() => navigate('/dashboard')}
            style={{
              display: 'flex', alignItems: 'center', gap: 8,
              padding: '9px 12px', borderRadius: 'var(--r-sm)',
              border: 'none', cursor: 'pointer',
              background: 'transparent',
              color: 'rgba(255,255,255,0.4)',
              fontFamily: 'var(--font-body)', fontSize: 12,
              textAlign: 'left', width: '100%',
            }}
          >
            ← My modules
          </button>
        </aside>

        {/* ── Main content ── */}
        <main style={{ flex: 1, overflowY: 'auto', padding: '32px 36px', background: 'var(--cal-off)' }}>

          {/* ════════════════ OVERVIEW ════════════════ */}
          {adminView === 'overview' && (
            <>
              {/* Header */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 28 }}>
                <div>
                  <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>
                    {MOCK_SCHOOL.name}
                  </h2>
                  <div style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
                    School dashboard · {stats.teacherCount} teachers · {stats.parentCount} parents
                  </div>
                </div>
                <button
                  className="btn btn-primary"
                  onClick={() => setAdminView('assign')}
                  style={{ fontSize: 13, padding: '10px 18px' }}
                >
                  + Assign module
                </button>
              </div>

              {/* First-run primer — what Habterra is and isn't */}
              {!primerDismissed && (
                <div style={{
                  background: 'linear-gradient(135deg, var(--cal-teal-lt) 0%, #fff 70%)',
                  border: '1.5px solid var(--cal-teal)',
                  borderRadius: 'var(--r-lg)',
                  padding: '18px 22px',
                  marginBottom: 24,
                  position: 'relative',
                }}>
                  <button
                    type="button"
                    onClick={dismissPrimer}
                    aria-label="Dismiss"
                    style={{
                      position: 'absolute', top: 10, right: 12,
                      background: 'transparent', border: 'none', cursor: 'pointer',
                      fontSize: 18, color: 'var(--cal-muted)', lineHeight: 1,
                      padding: 4,
                    }}
                  >×</button>
                  <div style={{
                    fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                    letterSpacing: '0.1em', color: 'var(--cal-teal)', marginBottom: 8,
                  }}>
                    HABTERRA IS NOT AN LMS
                  </div>
                  <div style={{ fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.6, marginBottom: 10, maxWidth: 720 }}>
                    Habterra is a <strong>frame-sharpening tool</strong> for parent conversations — not a course library and not a compliance tracker. Each module is 60–90 minutes of short scenarios anchored in research (Hattie, EEF, Schaverien, Kim et al.) that give teachers a shared vocabulary before parent season.
                  </div>
                  <div style={{ fontSize: 13, color: 'var(--cal-ink-soft)', lineHeight: 1.6, maxWidth: 720 }}>
                    Use the <strong>Action Queue</strong> to see where teachers are struggling in real time, and <strong>Quiz Analytics</strong> to pull one insight into your next staff meeting. The rollout script in the module guide handles the T-7 to T+14 sequence so you don't have to invent it.
                  </div>
                  <button
                    type="button"
                    onClick={dismissPrimer}
                    style={{
                      marginTop: 14,
                      fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                      background: 'var(--cal-teal)', color: '#fff', border: 'none',
                      borderRadius: 'var(--r-md)', padding: '8px 16px', cursor: 'pointer',
                    }}
                  >
                    Got it — don't show this again
                  </button>
                </div>
              )}

              {/* Stats row */}
              <div style={{ display: 'flex', gap: 16, marginBottom: 32 }}>
                <StatCard value={stats.teacherCount}    label="Teachers"         sub="enrolled"                           accent="var(--cal-teal)" />
                <StatCard value={stats.parentCount}     label="Parents"          sub="enrolled"                           accent="#7B5EA7" />
                <StatCard value={`${stats.completionRate}%`} label="Completion rate" sub="across all assigned modules"   accent="var(--cal-amber)" />
                <StatCard value={assignments.length}    label="Active modules"   sub="assigned this term"                 accent="#43A047" />
              </div>

              {/* Role filter tabs */}
              <div style={{ display: 'flex', gap: 6, marginBottom: 20 }}>
                {['all', 'teacher', 'parent'].map(f => (
                  <button
                    key={f}
                    onClick={() => setRoleFilter(f)}
                    style={{
                      fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                      padding: '6px 14px', borderRadius: 'var(--r-full)',
                      border: '1.5px solid',
                      borderColor: roleFilter === f ? 'var(--cal-teal)' : 'var(--cal-border)',
                      background: roleFilter === f ? 'var(--cal-teal)' : 'transparent',
                      color: roleFilter === f ? '#fff' : 'var(--cal-muted)',
                      cursor: 'pointer',
                      transition: 'all 0.15s',
                    }}
                  >
                    {f === 'all' ? 'All members' : f === 'teacher' ? 'Teachers' : 'Parents'}
                  </button>
                ))}
              </div>

              {/* Completion matrix */}
              <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden', marginBottom: 28 }}>
                <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--cal-border-lt)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)' }}>
                    Completion matrix
                  </div>
                  <div className="label-caps">
                    {visibleUsers.length} member{visibleUsers.length !== 1 ? 's' : ''}
                  </div>
                </div>

                <div style={{ overflowX: 'auto' }}>
                  <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 500 }}>
                    <thead>
                      <tr style={{ background: 'var(--cal-surface)' }}>
                        <th style={{ textAlign: 'left', padding: '10px 20px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 180 }}>
                          Member
                        </th>
                        <th style={{ textAlign: 'center', padding: '10px 8px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 80 }}>
                          Overall
                        </th>
                        {activeSlugs.map(slug => (
                          <th key={slug} style={{ textAlign: 'center', padding: '10px 8px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 100 }}>
                            {MODULE_META[slug]?.flag} {MODULE_META[slug]?.label?.replace('Understand ', '') ?? slug}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody>
                      {visibleUsers.map((user, i) => {
                        const overallPct = userOverallPct(user)
                        const slugsForUser = userSlugs(user)
                        return (
                          <tr
                            key={user.id}
                            style={{
                              background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)',
                              cursor: 'pointer',
                              transition: 'background 0.1s',
                            }}
                            onMouseEnter={e => e.currentTarget.style.background = 'var(--cal-teal-lt)'}
                            onMouseLeave={e => e.currentTarget.style.background = i % 2 === 0 ? '#fff' : 'var(--cal-surface)'}
                            onClick={() => setSelectedUser(user)}
                          >
                            {/* Name + role */}
                            <td style={{ padding: '10px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                                <div style={{
                                  width: 30, height: 30, borderRadius: '50%', flexShrink: 0,
                                  background: user.role === 'teacher' ? 'var(--cal-teal-lt)' : '#EDE7F6',
                                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                                  fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                                  color: user.role === 'teacher' ? 'var(--cal-teal)' : '#7B5EA7',
                                }}>
                                  {user.full_name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                                </div>
                                <div>
                                  <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)' }}>{user.full_name}</div>
                                  <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>{user.role}</div>
                                </div>
                              </div>
                            </td>

                            {/* Overall % */}
                            <td style={{ textAlign: 'center', padding: '10px 8px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                                <div style={{
                                  fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
                                  color: overallPct >= 80 ? 'var(--cal-success)' : overallPct > 0 ? 'var(--cal-amber-dark)' : 'var(--cal-muted)',
                                }}>
                                  {overallPct}%
                                </div>
                                <div className="progress-track" style={{ width: 40, height: 3 }}>
                                  <div
                                    className={`progress-fill ${overallPct >= 80 ? 'green' : 'amber'}`}
                                    style={{ width: `${overallPct}%` }}
                                  />
                                </div>
                              </div>
                            </td>

                            {/* Per-module cells */}
                            {activeSlugs.map(slug => {
                              const assigned = slugsForUser.includes(slug)
                              return assigned
                                ? <CompletionCell key={slug} pct={user.completions[slug] ?? 0} />
                                : <CompletionCell key={slug} pct={undefined} />
                            })}
                          </tr>
                        )
                      })}
                    </tbody>
                  </table>
                </div>

                {/* Legend */}
                <div style={{ padding: '12px 20px', borderTop: '1px solid var(--cal-border-lt)', display: 'flex', gap: 20, alignItems: 'center' }}>
                  <span className="label-caps">Legend</span>
                  {[
                    { symbol: '✓', bg: 'var(--cal-success-lt)', color: 'var(--cal-success)', label: 'Complete (≥80%)' },
                    { symbol: '%', bg: 'var(--cal-amber-lt)',   color: 'var(--cal-amber-dark)', label: 'In progress' },
                    { symbol: '○', bg: 'var(--cal-border-lt)', color: 'var(--cal-border)', label: 'Not started' },
                    { symbol: '—', bg: 'transparent',          color: '#C8C4BE', label: 'Not assigned' },
                  ].map(l => (
                    <div key={l.label} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11, color: 'var(--cal-muted)' }}>
                      <div style={{ width: 18, height: 18, borderRadius: '50%', background: l.bg, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 9, color: l.color, fontWeight: 700 }}>
                        {l.symbol}
                      </div>
                      {l.label}
                    </div>
                  ))}
                </div>
              </div>

              {/* Assignment schedule */}
              <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden' }}>
                <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)' }}>
                    Current assignments
                  </div>
                </div>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                  <thead>
                    <tr style={{ background: 'var(--cal-surface)' }}>
                      {['Module', 'Assigned to', 'Due date', 'Status'].map(h => (
                        <th key={h} style={{ textAlign: 'left', padding: '9px 20px', fontSize: 10, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.08em', textTransform: 'uppercase', borderBottom: '1px solid var(--cal-border-lt)' }}>
                          {h}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {assignments.map((a, i) => {
                      const meta  = MODULE_META[a.module_slug]
                      const days  = daysUntil(a.due_date)
                      const urgent = days !== null && days <= 7 && days >= 0
                      const overdue = days !== null && days < 0
                      return (
                        <tr key={a.id} style={{ background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)' }}>
                          <td style={{ padding: '12px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <span style={{ marginRight: 8 }}>{meta?.flag}</span>
                            <span style={{ fontWeight: 500 }}>{meta?.label ?? a.module_slug}</span>
                          </td>
                          <td style={{ padding: '12px 20px', fontSize: 13, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)', textTransform: 'capitalize' }}>
                            {a.role_target === 'all' ? 'Everyone' : a.role_target + 's'}
                          </td>
                          <td style={{ padding: '12px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)' }}>
                            {a.due_date ? (
                              <span style={{ color: overdue ? '#C62828' : urgent ? 'var(--cal-amber-dark)' : 'var(--cal-ink)' }}>
                                {fmtDate(a.due_date)}
                                {overdue && <span style={{ marginLeft: 6, fontSize: 10, fontWeight: 600 }}>(overdue)</span>}
                                {urgent  && <span style={{ marginLeft: 6, fontSize: 10, fontWeight: 600 }}>({days}d)</span>}
                              </span>
                            ) : '—'}
                          </td>
                          <td style={{ padding: '12px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <span className={`badge ${overdue ? 'badge-soon' : 'badge-assigned'}`} style={overdue ? { background: '#FFEBEE', color: '#C62828' } : {}}>
                              {overdue ? 'Overdue' : 'Active'}
                            </span>
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {/* ════════════════ MEMBERS ════════════════ */}
          {adminView === 'users' && (
            <>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', gap: 12, marginBottom: 28, flexWrap: 'wrap' }}>
                <div>
                  <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Members</h2>
                  <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
                    {members.length} members enrolled at {schoolName}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={openAddMember}
                  className="btn"
                  style={{ fontSize: 12, fontWeight: 600, padding: '9px 16px', background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-full)' }}
                >
                  + Add new member
                </button>
              </div>

              {/* Role filter */}
              <div style={{ display: 'flex', gap: 6, marginBottom: 20 }}>
                {['all', 'teacher', 'parent'].map(f => (
                  <button
                    key={f}
                    onClick={() => setRoleFilter(f)}
                    style={{
                      fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                      padding: '6px 14px', borderRadius: 'var(--r-full)',
                      border: '1.5px solid',
                      borderColor: roleFilter === f ? 'var(--cal-teal)' : 'var(--cal-border)',
                      background: roleFilter === f ? 'var(--cal-teal)' : 'transparent',
                      color: roleFilter === f ? '#fff' : 'var(--cal-muted)',
                      cursor: 'pointer',
                    }}
                  >
                    {f === 'all' ? 'All' : f === 'teacher' ? 'Teachers' : 'Parents'}
                  </button>
                ))}
              </div>

              <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                  <thead>
                    <tr style={{ background: 'var(--cal-surface)' }}>
                      {['Member', 'Role', 'Modules assigned', 'Complete', 'Progress'].map(h => (
                        <th key={h} style={{ textAlign: 'left', padding: '10px 20px', fontSize: 10, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.08em', textTransform: 'uppercase', borderBottom: '1px solid var(--cal-border-lt)' }}>
                          {h}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {visibleUsers.map((user, i) => {
                      const slugs = userSlugs(user)
                      const doneCount = slugs.filter(s => (user.completions[s] ?? 0) >= 80).length
                      const overallPct = userOverallPct(user)
                      return (
                        <tr key={user.id} style={{ background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)', cursor: 'pointer' }}
                          onMouseEnter={e => e.currentTarget.style.background = 'var(--cal-teal-lt)'}
                          onMouseLeave={e => e.currentTarget.style.background = i % 2 === 0 ? '#fff' : 'var(--cal-surface)'}
                        >
                          <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                              <div style={{
                                width: 32, height: 32, borderRadius: '50%', flexShrink: 0,
                                background: user.role === 'teacher' ? 'var(--cal-teal-lt)' : '#EDE7F6',
                                display: 'flex', alignItems: 'center', justifyContent: 'center',
                                fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                                color: user.role === 'teacher' ? 'var(--cal-teal)' : '#7B5EA7',
                              }}>
                                {user.full_name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                              </div>
                              <div>
                                <div style={{ fontSize: 13, fontWeight: 500 }}>{user.full_name}</div>
                                <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>{user.email}</div>
                              </div>
                            </div>
                          </td>
                          <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <span className={`badge ${user.role === 'teacher' ? 'badge-assigned' : 'badge-progress'}`} style={user.role === 'parent' ? { background: '#EDE7F6', color: '#7B5EA7' } : {}}>
                              {user.role}
                            </span>
                          </td>
                          <td style={{ padding: '13px 20px', fontSize: 13, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)', textAlign: 'center' }}>
                            {slugs.length}
                          </td>
                          <td style={{ padding: '13px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)', textAlign: 'center' }}>
                            <span style={{ color: doneCount === slugs.length && slugs.length > 0 ? 'var(--cal-success)' : 'var(--cal-ink)', fontWeight: 600 }}>
                              {doneCount}/{slugs.length}
                            </span>
                          </td>
                          <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                              <div className="progress-track" style={{ flex: 1, height: 5 }}>
                                <div className={`progress-fill ${overallPct >= 80 ? 'green' : 'amber'}`} style={{ width: `${overallPct}%` }} />
                              </div>
                              <span style={{ fontSize: 11, color: 'var(--cal-muted)', minWidth: 28, textAlign: 'right' }}>{overallPct}%</span>
                            </div>
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {/* ════════════════ ACTION QUEUE ════════════════ */}
          {adminView === 'actions' && (() => {
            const grouped = ['high', 'medium', 'low'].map(severity => ({
              severity,
              items: actionItems.filter(item => item.severity === severity),
            }))

            return (
              <>
                <div style={{ marginBottom: 28, display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 20 }}>
                  <div>
                    <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Action Queue</h2>
                    <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>What needs attention next, generated from invites, progress, deadlines, and quiz responses.</p>
                  </div>
                  <button
                    type="button"
                    className="btn btn-primary"
                    onClick={handleActionRefresh}
                    disabled={actionRefreshing}
                    style={{ fontSize: 13, padding: '10px 18px', opacity: actionRefreshing ? 0.6 : 1 }}
                  >
                    {actionRefreshing ? 'Refreshing...' : 'Refresh'}
                  </button>
                </div>

                {actionError && (
                  <div style={{ background: '#FDEDED', borderRadius: 'var(--r-md)', padding: '14px 18px', marginBottom: 18, fontSize: 13, color: '#B3261E', lineHeight: 1.6 }}>
                    {actionError}
                  </div>
                )}

                {actionLoading && (
                  <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px', fontSize: 13, color: 'var(--cal-muted)' }}>
                    Loading action items...
                  </div>
                )}

                {!actionLoading && actionItems.length === 0 && (
                  <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '34px 30px', maxWidth: 720 }}>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 8 }}>Nothing needs attention right now</div>
                    <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.7 }}>
                      Refresh the queue after new invites, assignments, or quiz responses land.
                    </div>
                  </div>
                )}

                {!actionLoading && actionItems.length > 0 && (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 18, maxWidth: 900 }}>
                    {grouped.map(group => {
                      if (group.items.length === 0) return null
                      const sevStyle = severityStyles(group.severity)

                      return (
                        <section key={group.severity}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                            <span style={{ display: 'inline-flex', alignItems: 'center', border: '1px solid', borderRadius: 'var(--r-full)', padding: '4px 10px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase', ...sevStyle }}>
                              {group.severity}
                            </span>
                            <span style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
                              {group.items.length} item{group.items.length !== 1 ? 's' : ''}
                            </span>
                          </div>

                          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                            {group.items.map(item => {
                              const moduleLabel = modulePillLabel(item.module_slug)
                              const userName = item.user?.full_name
                              const userEmail = item.user?.email ?? item.metadata?.email

                              return (
                                <div key={item.id} style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid var(--cal-border-lt)', padding: '18px 20px' }}>
                                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 18, alignItems: 'flex-start' }}>
                                    <div style={{ flex: 1, minWidth: 0 }}>
                                      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 10 }}>
                                        <span className="badge badge-assigned" style={{ fontSize: 9 }}>{actionTypeLabel(item.action_type)}</span>
                                        {moduleLabel && <span className="badge badge-progress" style={{ fontSize: 9 }}>{moduleLabel}</span>}
                                        {userName && <span className="badge" style={{ fontSize: 9, background: 'var(--cal-border-lt)', color: 'var(--cal-muted)' }}>{userName}</span>}
                                        {item.due_date && <span className="badge badge-soon" style={{ fontSize: 9 }}>Due {fmtDate(item.due_date)}</span>}
                                      </div>
                                      <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 6 }}>
                                        {item.title}
                                      </div>
                                      <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.65 }}>
                                        {item.detail}
                                      </div>
                                      {userEmail && (
                                        <div style={{ marginTop: 8, fontSize: 11, color: 'var(--cal-muted)' }}>
                                          {userEmail}
                                        </div>
                                      )}
                                    </div>

                                    <button
                                      type="button"
                                      className="btn btn-ghost"
                                      onClick={() => handleActionResolve(item.id)}
                                      style={{ flexShrink: 0, fontSize: 12, padding: '8px 12px' }}
                                    >
                                      Resolve
                                    </button>
                                  </div>
                                </div>
                              )
                            })}
                          </div>
                        </section>
                      )
                    })}
                  </div>
                )}
              </>
            )
          })()}

          {/* ════════════════ ASSIGN MODULE ════════════════ */}
          {adminView === 'assign' && (
            <>
              <div style={{ marginBottom: 28 }}>
                <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Assign a module</h2>
                <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
                  Assigned modules appear on every member's dashboard. They'll receive a notification to complete it before the due date.
                </p>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24, maxWidth: 860 }}>

                {/* Assignment form */}
                <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 22 }}>
                    New assignment
                  </div>

                  <form onSubmit={handleAssign} style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>

                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                        Module
                      </label>
                      <select
                        value={assignForm.moduleSlug}
                        onChange={e => setAssignForm(f => ({ ...f, moduleSlug: e.target.value }))}
                        required
                        style={{
                          width: '100%', fontFamily: 'var(--font-body)', fontSize: 14,
                          color: 'var(--cal-ink)', background: '#fff',
                          border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)',
                          padding: '11px 14px', outline: 'none', cursor: 'pointer',
                        }}
                      >
                        <option value="">Select a module…</option>
                        {Object.values(MODULE_META).filter(m => !m.inDev).map(m => (
                          <option key={m.slug} value={m.slug}>
                            {m.flag} {m.label}
                          </option>
                        ))}
                        {Object.values(MODULE_META).some(m => m.inDev) && (
                          <optgroup label="In development (not assignable)">
                            {Object.values(MODULE_META).filter(m => m.inDev).map(m => (
                              <option key={m.slug} value={m.slug} disabled>
                                {m.flag} {m.label} — in development
                              </option>
                            ))}
                          </optgroup>
                        )}
                      </select>
                      {Object.values(MODULE_META).some(m => m.inDev) && (
                        <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginTop: 6, lineHeight: 1.4 }}>
                          Country modules marked <em>in development</em> are on the roadmap but not yet ready to assign. Only modules with complete content and quiz banks are assignable.
                        </div>
                      )}
                    </div>

                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                        Assign to
                      </label>
                      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                        {[
                          { val: 'teacher', label: 'Teachers only' },
                          { val: 'parent',  label: 'Parents only' },
                          { val: 'all',     label: 'Everyone' },
                          { val: 'users',   label: 'Specific users' },
                        ].map(opt => (
                          <button
                            key={opt.val}
                            type="button"
                            onClick={() => setAssignForm(f => ({ ...f, roleTarget: opt.val }))}
                            style={{
                              padding: '10px 8px', border: '1.5px solid',
                              borderRadius: 'var(--r-md)', cursor: 'pointer', fontSize: 12,
                              fontFamily: 'var(--font-display)', fontWeight: 600,
                              borderColor: assignForm.roleTarget === opt.val ? 'var(--cal-teal)' : 'var(--cal-border)',
                              background: assignForm.roleTarget === opt.val ? 'var(--cal-teal-lt)' : 'transparent',
                              color: assignForm.roleTarget === opt.val ? 'var(--cal-teal)' : 'var(--cal-muted)',
                            }}
                          >
                            {opt.label}
                          </button>
                        ))}
                      </div>

                      {assignForm.roleTarget === 'users' && (
                        <div style={{ marginTop: 12 }}>
                          <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginBottom: 8, display: 'flex', justifyContent: 'space-between' }}>
                            <span>
                              {assignForm.selectedUserIds.length === 0
                                ? 'Pick one or more members to assign this module to.'
                                : `${assignForm.selectedUserIds.length} selected`}
                            </span>
                            {assignForm.selectedUserIds.length > 0 && (
                              <button
                                type="button"
                                onClick={() => setAssignForm(f => ({ ...f, selectedUserIds: [] }))}
                                style={{
                                  background: 'transparent', border: 'none', padding: 0,
                                  color: 'var(--cal-teal)', cursor: 'pointer', fontSize: 11,
                                  fontFamily: 'var(--font-body)', fontWeight: 500,
                                }}
                              >
                                Clear
                              </button>
                            )}
                          </div>
                          <div style={{
                            maxHeight: 200, overflowY: 'auto',
                            border: '1px solid var(--cal-border)', borderRadius: 'var(--r-md)',
                            background: '#fff',
                          }}>
                            {members.map((u, i) => {
                              const checked = assignForm.selectedUserIds.includes(u.id)
                              return (
                                <label
                                  key={u.id}
                                  style={{
                                    display: 'flex', alignItems: 'center', gap: 10,
                                    padding: '8px 12px',
                                    borderBottom: i < members.length - 1 ? '1px solid var(--cal-border-lt)' : 'none',
                                    cursor: 'pointer',
                                    background: checked ? 'var(--cal-teal-lt)' : 'transparent',
                                  }}
                                >
                                  <input
                                    type="checkbox"
                                    checked={checked}
                                    onChange={e => {
                                      setAssignForm(f => ({
                                        ...f,
                                        selectedUserIds: e.target.checked
                                          ? [...f.selectedUserIds, u.id]
                                          : f.selectedUserIds.filter(id => id !== u.id),
                                      }))
                                    }}
                                    style={{ cursor: 'pointer' }}
                                  />
                                  <div style={{ flex: 1, minWidth: 0 }}>
                                    <div style={{ fontSize: 13, color: 'var(--cal-ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                                      {u.full_name}
                                    </div>
                                    <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>
                                      {u.role} · {u.email}
                                    </div>
                                  </div>
                                </label>
                              )
                            })}
                          </div>
                        </div>
                      )}
                    </div>

                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                        Due date <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>(optional)</span>
                      </label>
                      <input
                        className="input"
                        type="date"
                        value={assignForm.dueDate}
                        onChange={e => setAssignForm(f => ({ ...f, dueDate: e.target.value }))}
                        min={new Date().toISOString().split('T')[0]}
                      />
                    </div>

                    {assignSaved && (
                      <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: 'var(--cal-success)', fontWeight: 500 }}>
                        ✓ Module assigned successfully
                      </div>
                    )}
                    {assignError && (
                      <div style={{ background: '#FFEBEE', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: '#C62828', lineHeight: 1.5 }}>
                        {assignError}
                      </div>
                    )}

                    <button type="submit" className="btn btn-primary btn-full" style={{ marginTop: 4, padding: '13px', fontSize: 14 }}>
                      Assign module →
                    </button>
                  </form>
                </div>

                {/* Current assignments list */}
                <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 20 }}>
                    Currently active
                  </div>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                    {assignments.map(a => {
                      const meta = MODULE_META[a.module_slug]
                      const days = daysUntil(a.due_date)
                      const targetUser = a.user_id ? members.find(u => u.id === a.user_id) : null
                      const audienceLabel = targetUser
                        ? `→ ${targetUser.full_name}`
                        : (a.role_target === 'all' ? 'Everyone' : a.role_target + 's')
                      return (
                        <div key={a.id} style={{
                          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                          padding: '12px 14px', borderRadius: 'var(--r-md)',
                          background: 'var(--cal-surface)',
                          border: '1px solid var(--cal-border-lt)',
                        }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                            <span style={{ fontSize: 20 }}>{meta?.flag ?? '🌏'}</span>
                            <div>
                              <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)' }}>
                                {meta?.label ?? a.module_slug}
                              </div>
                              <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: targetUser ? 'none' : 'capitalize' }}>
                                {audienceLabel}
                                {a.due_date && ` · Due ${fmtDate(a.due_date)}`}
                              </div>
                            </div>
                          </div>
                          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                            <span className={`badge ${days !== null && days < 0 ? '' : 'badge-done'}`}
                              style={days !== null && days < 0 ? { background: '#FFEBEE', color: '#C62828' } : {}}
                            >
                              {days !== null && days < 0 ? 'Overdue' : 'Active'}
                            </span>
                            <button
                              type="button"
                              onClick={() => handleUnassign(a)}
                              title="Remove assignment"
                              aria-label={`Remove ${meta?.label ?? a.module_slug} assignment`}
                              style={{
                                width: 24, height: 24,
                                display: 'flex', alignItems: 'center', justifyContent: 'center',
                                border: '1px solid var(--cal-border-lt)',
                                borderRadius: 'var(--r-sm)',
                                background: '#fff',
                                color: 'var(--cal-muted)',
                                cursor: 'pointer',
                                fontSize: 14, lineHeight: 1,
                                padding: 0,
                                transition: 'color 0.15s, border-color 0.15s, background 0.15s',
                              }}
                              onMouseEnter={e => {
                                e.currentTarget.style.color = '#C62828'
                                e.currentTarget.style.borderColor = '#C62828'
                                e.currentTarget.style.background = '#FFEBEE'
                              }}
                              onMouseLeave={e => {
                                e.currentTarget.style.color = 'var(--cal-muted)'
                                e.currentTarget.style.borderColor = 'var(--cal-border-lt)'
                                e.currentTarget.style.background = '#fff'
                              }}
                            >×</button>
                          </div>
                        </div>
                      )
                    })}
                    {assignments.length === 0 && (
                      <div style={{ fontSize: 13, color: 'var(--cal-muted)', padding: '12px 14px' }}>
                        No active assignments yet.
                      </div>
                    )}
                  </div>
                </div>

              </div>
            </>
          )}
          {/* ════════════════ QUIZ ANALYTICS ════════════════ */}
          {adminView === 'analytics' && (() => {
            const rows = (analyticsData ?? [])
              .slice()
              .sort((a, b) => (a.correct / Math.max(a.n, 1)) - (b.correct / Math.max(b.n, 1)))  // hardest first
            const belowThreshold = rows.filter(r => (r.correct / r.n) < 0.6).length
            return (
              <>
                <div style={{ marginBottom: 28, display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                  <div>
                    <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Quiz Analytics</h2>
                    <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>Where teachers are struggling — sorted by difficulty (hardest first).</p>
                  </div>
                  <select
                    value={analyticsSlug}
                    onChange={e => setAnalyticsSlug(e.target.value)}
                    style={{ fontFamily: 'var(--font-body)', fontSize: 13, color: 'var(--cal-ink)', background: '#fff', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '8px 12px', outline: 'none', cursor: 'pointer' }}
                  >
                    {Object.entries(MODULE_META).filter(([s]) => s !== 'woodstock-transition').map(([slug, m]) => (
                      <option key={slug} value={slug}>{m.flag} {m.label}</option>
                    ))}
                  </select>
                </div>

                {analyticsLoading && (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--cal-muted)', padding: '36px 0' }}>
                    <div style={{ width: 16, height: 16, border: '2px solid var(--cal-border)', borderTopColor: 'var(--cal-teal)', borderRadius: '50%', animation: 'spin 0.8s linear infinite' }} />
                    <span style={{ fontSize: 13 }}>Loading quiz analytics...</span>
                    <style>{`@keyframes spin { to { transform: rotate(360deg) } }`}</style>
                  </div>
                )}

                {!analyticsLoading && analyticsError && (
                  <div style={{ background: '#FFEBEE', borderRadius: 'var(--r-md)', padding: '14px 18px', marginBottom: 20, fontSize: 13, color: '#C62828', lineHeight: 1.6 }}>
                    {analyticsError}
                  </div>
                )}

                {!analyticsLoading && !analyticsError && belowThreshold > 0 && (
                  <div style={{ background: 'var(--cal-amber-lt)', borderRadius: 'var(--r-md)', padding: '14px 18px', marginBottom: 20, display: 'flex', alignItems: 'center', gap: 12, border: '1px solid rgba(232,150,30,0.3)' }}>
                    <span style={{ fontSize: 20 }}>⚠️</span>
                    <div style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.6 }}>
                      <strong style={{ fontFamily: 'var(--font-display)' }}>{belowThreshold} question{belowThreshold > 1 ? 's' : ''} below 60% correct.</strong>
                      {' '}Consider a targeted follow-up in your next staff meeting.
                    </div>
                  </div>
                )}

                {!analyticsLoading && !analyticsError && rows.length === 0 && (
                  <div style={{ textAlign: 'center', padding: '60px 40px', color: 'var(--cal-muted)' }}>
                    <div style={{ fontSize: 32, marginBottom: 12 }}>📊</div>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 8 }}>No responses yet</div>
                    <div style={{ fontSize: 13 }}>No quiz responses yet for this module.</div>
                  </div>
                )}

                <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                  {!analyticsLoading && !analyticsError && rows.map(row => {
                    const pct     = Math.round((row.correct / row.n) * 100)
                    const color   = pct < 60 ? '#C62828' : pct < 75 ? 'var(--cal-amber-dark)' : 'var(--cal-success)'
                    const bgColor = pct < 60 ? '#FEF2F2' : pct < 75 ? 'var(--cal-amber-lt)' : 'var(--cal-success-lt)'
                    return (
                      <div key={row.id} style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '18px 22px', borderLeft: `4px solid ${color}` }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 16, marginBottom: 10 }}>
                          <div style={{ flex: 1, minWidth: 0 }}>
                            <span className="badge badge-assigned" style={{ fontSize: 9, marginBottom: 8, display: 'inline-flex' }}>{row.label}</span>
                            <div style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.5, fontWeight: 500 }}>
                              {row.prompt.length > 120 ? row.prompt.slice(0, 120) + '…' : row.prompt}
                            </div>
                          </div>
                          <div style={{ flexShrink: 0, textAlign: 'center', background: bgColor, borderRadius: 'var(--r-md)', padding: '10px 16px', minWidth: 72 }}>
                            <div style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 800, color, lineHeight: 1 }}>{pct}%</div>
                            <div style={{ fontSize: 9, color: 'var(--cal-muted)', marginTop: 3, fontFamily: 'var(--font-display)', fontWeight: 600 }}>{row.correct}/{row.n}</div>
                          </div>
                        </div>
                        <div className="progress-track" style={{ marginBottom: pct < 75 ? 10 : 0 }}>
                          <div className="progress-fill" style={{ width: `${pct}%`, background: color }} />
                        </div>
                        {pct < 75 && (
                          <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                            <strong style={{ fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)' }}>Most common wrong answer:</strong>{' '}{row.topWrong ?? 'No common wrong answer yet.'}
                          </div>
                        )}
                      </div>
                    )
                  })}
                </div>

                {MOCK_MODE && rows.length > 0 && (
                  <div style={{ marginTop: 20, padding: '12px 16px', background: 'var(--cal-border-lt)', borderRadius: 'var(--r-md)', fontSize: 11, color: 'var(--cal-muted)' }}>
                    Demo data shown above. Live analytics populate from quiz_responses table as teachers complete modules.
                  </div>
                )}
              </>
            )
          })()}

          {/* ════════════════ INVITE MEMBER ════════════════ */}
          {adminView === 'invite' && (
            <>
              <div style={{ marginBottom: 28 }}>
                <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Invite a member</h2>
                <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>Send an invitation to a new teacher or parent. They'll receive a link to set their password.</p>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24, maxWidth: 860 }}>
                {/* Invite form */}
                <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 22 }}>New invitation</div>
                  <form
                    onSubmit={handleSingleInvite}
                    style={{ display: 'flex', flexDirection: 'column', gap: 18 }}
                  >
                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>Email address</label>
                      <input className="input" type="email" placeholder="teacher@woodstockschool.in" value={inviteForm.email} onChange={e => setInviteForm(f => ({ ...f, email: e.target.value }))} required />
                    </div>
                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                        Full name <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>(optional)</span>
                      </label>
                      <input className="input" type="text" placeholder="Jane Smith" value={inviteForm.fullName} onChange={e => setInviteForm(f => ({ ...f, fullName: e.target.value }))} />
                    </div>
                    <div>
                      <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>Role</label>
                      <div style={{ display: 'flex', gap: 8 }}>
                        {[{ val: 'teacher', label: 'Teacher' }, { val: 'parent', label: 'Parent' }].map(opt => (
                          <button key={opt.val} type="button" onClick={() => setInviteForm(f => ({ ...f, role: opt.val }))} style={{ flex: 1, padding: '10px 8px', border: '1.5px solid', borderRadius: 'var(--r-md)', cursor: 'pointer', fontSize: 13, fontFamily: 'var(--font-display)', fontWeight: 600, borderColor: inviteForm.role === opt.val ? 'var(--cal-teal)' : 'var(--cal-border)', background: inviteForm.role === opt.val ? 'var(--cal-teal-lt)' : 'transparent', color: inviteForm.role === opt.val ? 'var(--cal-teal)' : 'var(--cal-muted)' }}>{opt.label}</button>
                        ))}
                      </div>
                    </div>
                    {inviteSaved && (
                      <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: 'var(--cal-success)', fontWeight: 500 }}>
                        ✓ Invitation sent{MOCK_MODE ? <span style={{ fontWeight: 400, opacity: 0.8 }}> (demo — no email sent)</span> : ''}
                      </div>
                    )}
                    {inviteError && (
                      <div style={{ background: '#FDEDED', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: '#B3261E', fontWeight: 500 }}>
                        {inviteError}
                      </div>
                    )}
                    <button type="submit" className="btn btn-primary btn-full" style={{ marginTop: 4, padding: '13px', fontSize: 14 }}>Send invitation →</button>
                  </form>
                </div>

                {/* Bulk CSV import */}
                <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 14 }}>Bulk import</div>
                  <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.75, marginBottom: 14 }}>
                    Upload a CSV of teachers and parents. Habterra validates the file, imports valid rows one at a time, and records the batch for follow-up.
                  </div>

                  <div className="label-caps" style={{ marginBottom: 8 }}>Expected format</div>
                  <div style={{ background: 'var(--cal-surface)', borderRadius: 'var(--r-md)', padding: '12px 14px', fontSize: 11, fontFamily: 'monospace', color: 'var(--cal-ink-soft)', lineHeight: 1.7, marginBottom: 16, border: '1px solid var(--cal-border)', whiteSpace: 'pre-wrap' }}>
                    {'email,full_name,role\nteacher.one@school.com,Teacher One,teacher\nparent.one@gmail.com,Parent One,parent'}
                  </div>

                  <input
                    type="file"
                    accept=".csv,text/csv"
                    disabled={csvImporting}
                    onChange={handleCsvFile}
                    style={{
                      display: 'block',
                      width: '100%',
                      fontSize: 12,
                      color: 'var(--cal-muted)',
                      marginBottom: 14,
                    }}
                  />

                  {csvError && (
                    <div style={{ background: '#FDEDED', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 12, color: '#B3261E', lineHeight: 1.5, marginBottom: 14 }}>
                      {csvError}
                    </div>
                  )}

                  {csvRows.length > 0 && (
                    <>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                        <div className="label-caps">Preview</div>
                        <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>
                          {csvRows.length} row{csvRows.length !== 1 ? 's' : ''} loaded
                        </div>
                      </div>

                      <div style={{ maxHeight: 312, overflowY: 'auto', border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-md)', marginBottom: 14 }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 520 }}>
                          <thead>
                            <tr style={{ background: 'var(--cal-surface)' }}>
                              {['Email', 'Name', 'Role', 'Status'].map(label => (
                                <th key={label} style={{ textAlign: 'left', padding: '9px 10px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)' }}>
                                  {label}
                                </th>
                              ))}
                            </tr>
                          </thead>
                          <tbody>
                            {csvRows.map((row, idx) => {
                              const statusStyle = inviteStatusStyles(row.status)
                              return (
                                <tr key={row.id} style={{ background: idx % 2 === 0 ? '#fff' : 'var(--cal-surface)' }}>
                                  <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-ink)' }}>{row.email || '-'}</td>
                                  <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-muted)' }}>{row.fullName || '-'}</td>
                                  <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>{row.role || '-'}</td>
                                  <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11 }}>
                                    <span style={{ display: 'inline-flex', alignItems: 'center', borderRadius: 'var(--r-full)', padding: '3px 8px', fontWeight: 700, textTransform: 'capitalize', ...statusStyle }}>
                                      {row.status}
                                    </span>
                                    {row.error && (
                                      <div style={{ marginTop: 4, color: '#B3261E', lineHeight: 1.4 }}>
                                        {row.error}
                                      </div>
                                    )}
                                  </td>
                                </tr>
                              )
                            })}
                          </tbody>
                        </table>
                      </div>

                      {csvSummary && (
                        <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 12, color: 'var(--cal-success)', fontWeight: 700, marginBottom: 14 }}>
                          {csvSummary.imported} imported &middot; {csvSummary.failed} failed
                        </div>
                      )}

                      <button
                        type="button"
                        className="btn btn-primary btn-full"
                        disabled={csvImporting || csvImportableCount === 0}
                        onClick={handleCsvImport}
                        style={{ padding: '13px', fontSize: 14, opacity: csvImporting || csvImportableCount === 0 ? 0.55 : 1 }}
                      >
                        {csvImporting ? 'Importing...' : `Import ${csvImportableCount} user${csvImportableCount !== 1 ? 's' : ''}`}
                      </button>
                    </>
                  )}

                  {false && (
                    <>
                  <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.75, marginBottom: 18 }}>
                    For onboarding larger groups — 80 teachers and 400 parents — use the SQL seed template to import all users in one step directly in the Supabase dashboard.
                  </div>
                  <div style={{ background: 'var(--cal-surface)', borderRadius: 'var(--r-md)', padding: '12px 14px', fontSize: 11, fontFamily: 'monospace', color: 'var(--cal-ink-soft)', lineHeight: 1.7, marginBottom: 16, border: '1px solid var(--cal-border)' }}>
                    {'-- woodstock_user_import.sql\n-- 1. Insert into auth.users\n-- 2. Insert into public.profiles\n-- 3. Run woodstock_india_assign.sql'}
                  </div>
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                    See <strong style={{ color: 'var(--cal-teal)' }}>woodstock_user_import.sql</strong> in the project root for the full template.
                  </div>
                  <div style={{ marginTop: 20, borderTop: '1px solid var(--cal-border-lt)', paddingTop: 18 }}>
                    <div className="label-caps" style={{ marginBottom: 8 }}>CSV import — v2</div>
                    <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.7 }}>
                      Upload a CSV with email, name, role, and grade (for parents). Habterra will create accounts and send invitations automatically.
                    </div>
                  </div>
                    </>
                  )}
                </div>
              </div>
            </>
          )}

        </main>
      </div>

      {/* ── User detail modal ── */}
      {selectedUser && (
        <div
          onClick={() => setSelectedUser(null)}
          style={{
            position: 'fixed', inset: 0,
            background: 'rgba(10,30,35,0.45)',
            zIndex: 200,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <div
            onClick={e => e.stopPropagation()}
            style={{
              background: '#fff',
              borderRadius: 'var(--r-lg)',
              boxShadow: 'var(--shadow-lg)',
              width: '100%',
              maxWidth: 520,
              margin: '20px',
              overflow: 'hidden',
            }}
          >
            {/* Modal header */}
            <div style={{
              background: 'var(--cal-teal)',
              padding: '22px 26px',
              display: 'flex',
              alignItems: 'center',
              gap: 14,
            }}>
              <div style={{
                width: 44, height: 44, borderRadius: '50%', flexShrink: 0,
                background: 'rgba(255,255,255,0.22)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16, color: '#fff',
              }}>
                {(selectedUser.full_name || selectedUser.email || '?').slice(0, 1).toUpperCase()}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 700, color: '#fff', marginBottom: 2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {selectedUser.full_name || selectedUser.email}
                </div>
                <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.75)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {selectedUser.email} · {selectedUser.role}
                </div>
              </div>
              {!editMode && (
                <button
                  type="button"
                  onClick={openEditMode}
                  style={{
                    background: 'rgba(255,255,255,0.18)', color: '#fff',
                    border: '1px solid rgba(255,255,255,0.3)',
                    borderRadius: 'var(--r-sm)', padding: '6px 12px',
                    fontSize: 12, fontFamily: 'var(--font-display)', fontWeight: 600,
                    cursor: 'pointer', marginRight: 8,
                  }}
                >Edit</button>
              )}
              <button
                type="button"
                onClick={() => { setEditMode(false); setSelectedUser(null) }}
                aria-label="Close"
                style={{
                  background: 'transparent', border: 'none', color: '#fff',
                  fontSize: 22, cursor: 'pointer', padding: 4, lineHeight: 1,
                }}
              >×</button>
            </div>

            {/* Modal body */}
            <div style={{ padding: '22px 26px' }}>

              {editMode && (
                <div style={{
                  background: 'var(--cal-surface)', borderRadius: 'var(--r-md)',
                  padding: 18, marginBottom: 20,
                  border: '1px solid var(--cal-border-lt)',
                }}>
                  <div className="label-caps" style={{ marginBottom: 12 }}>Edit member</div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                    <div>
                      <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                        Full name
                      </label>
                      <input
                        className="input"
                        type="text"
                        value={editForm.fullName}
                        onChange={e => setEditForm(f => ({ ...f, fullName: e.target.value }))}
                        placeholder="e.g. Eric Schoonard"
                        style={{ width: '100%' }}
                      />
                    </div>

                    <div>
                      <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                        Email
                      </label>
                      <input
                        type="email"
                        value={selectedUser.email ?? ''}
                        disabled
                        style={{
                          width: '100%', padding: '9px 12px', fontSize: 13,
                          background: '#F5F5F5', color: 'var(--cal-muted)',
                          border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-sm)',
                        }}
                      />
                      <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
                        Email is tied to the sign-in and can't be changed from this screen.
                      </div>
                    </div>

                    <div>
                      <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                        Role
                      </label>
                      <select
                        value={editForm.role}
                        onChange={e => setEditForm(f => ({ ...f, role: e.target.value }))}
                        style={{
                          width: '100%', padding: '9px 12px', fontSize: 13,
                          border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                          background: '#fff', cursor: 'pointer',
                        }}
                      >
                        <option value="teacher">Teacher</option>
                        <option value="parent">Parent</option>
                        <option value="admin">Admin</option>
                        {isSuperAdmin && <option value="superadmin">Superadmin</option>}
                      </select>
                    </div>

                    {isSuperAdmin && (
                      <div>
                        <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                          School
                        </label>
                        <select
                          value={editForm.schoolId}
                          onChange={e => setEditForm(f => ({ ...f, schoolId: e.target.value }))}
                          style={{
                            width: '100%', padding: '9px 12px', fontSize: 13,
                            border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                            background: '#fff', cursor: 'pointer',
                          }}
                        >
                          <option value="">— select school —</option>
                          {allSchools.map(s => (
                            <option key={s.id} value={s.id}>{s.name}</option>
                          ))}
                        </select>
                        <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
                          Superadmin only. Moving a member to another school updates their roster and assignments on next sign-in.
                        </div>
                      </div>
                    )}

                    {editError && (
                      <div style={{ background: '#FFEBEE', color: '#C62828', padding: '8px 12px', borderRadius: 'var(--r-sm)', fontSize: 12 }}>
                        {editError}
                      </div>
                    )}

                    <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end', marginTop: 4 }}>
                      <button
                        type="button"
                        onClick={cancelEditMode}
                        disabled={editSaving}
                        className="btn"
                        style={{ fontSize: 12, padding: '8px 14px', background: 'transparent', border: '1px solid var(--cal-border)', color: 'var(--cal-ink)' }}
                      >Cancel</button>
                      <button
                        type="button"
                        onClick={saveMemberEdit}
                        disabled={editSaving || !editForm.fullName.trim()}
                        className="btn"
                        style={{ fontSize: 12, padding: '8px 14px', background: 'var(--cal-teal)', color: '#fff' }}
                      >{editSaving ? 'Saving…' : 'Save changes'}</button>
                    </div>
                  </div>
                </div>
              )}

              {/* Assignments: individual (removable) + inherited from role buckets */}
              <div className="label-caps" style={{ marginBottom: 12 }}>Assignments</div>
              {(() => {
                const individual = assignments.filter(a => a.user_id === selectedUser.id)
                const inherited  = assignments.filter(a =>
                  !a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)
                )
                if (individual.length === 0 && inherited.length === 0) {
                  return (
                    <div style={{ fontSize: 13, color: 'var(--cal-muted)', marginBottom: 22 }}>
                      No assignments yet.
                    </div>
                  )
                }
                return (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 22 }}>
                    {individual.map(a => {
                      const meta = MODULE_META[a.module_slug]
                      return (
                        <div key={a.id} style={{
                          display: 'flex', alignItems: 'center', gap: 10,
                          padding: '10px 12px', borderRadius: 'var(--r-md)',
                          background: 'var(--cal-surface)',
                          border: '1px solid var(--cal-border-lt)',
                        }}>
                          <span style={{ fontSize: 18 }}>{meta?.flag ?? '🌏'}</span>
                          <div style={{ flex: 1, minWidth: 0 }}>
                            <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                              {meta?.label ?? a.module_slug}
                            </div>
                            <div style={{ fontSize: 10, color: 'var(--cal-muted)', display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                              <span>Individual ·</span>
                              <input
                                type="date"
                                value={dueDateEditing[a.id] !== undefined ? dueDateEditing[a.id] : (a.due_date ?? '')}
                                onChange={e => setDueDateEditing(prev => ({ ...prev, [a.id]: e.target.value }))}
                                style={{ fontSize: 10, padding: '2px 4px', border: '1px solid var(--cal-border-lt)', borderRadius: 3 }}
                              />
                              {dueDateEditing[a.id] !== undefined && dueDateEditing[a.id] !== (a.due_date ?? '') && (
                                <button
                                  type="button"
                                  onClick={() => handleSaveDueDate(a)}
                                  disabled={dueDateSaving === a.id}
                                  style={{ fontSize: 10, padding: '2px 8px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}
                                >{dueDateSaving === a.id ? '…' : 'Save'}</button>
                              )}
                            </div>
                          </div>
                          <button
                            type="button"
                            onClick={() => handleUnassign(a)}
                            title="Remove assignment"
                            aria-label={`Remove ${meta?.label ?? a.module_slug} assignment`}
                            style={{
                              width: 24, height: 24,
                              display: 'flex', alignItems: 'center', justifyContent: 'center',
                              border: '1px solid var(--cal-border-lt)',
                              borderRadius: 'var(--r-sm)',
                              background: '#fff',
                              color: 'var(--cal-muted)',
                              cursor: 'pointer',
                              fontSize: 14, lineHeight: 1,
                              padding: 0,
                            }}
                            onMouseEnter={e => {
                              e.currentTarget.style.color = '#C62828'
                              e.currentTarget.style.borderColor = '#C62828'
                              e.currentTarget.style.background = '#FFEBEE'
                            }}
                            onMouseLeave={e => {
                              e.currentTarget.style.color = 'var(--cal-muted)'
                              e.currentTarget.style.borderColor = 'var(--cal-border-lt)'
                              e.currentTarget.style.background = '#fff'
                            }}
                          >×</button>
                        </div>
                      )
                    })}
                    {inherited.map(a => {
                      const meta = MODULE_META[a.module_slug]
                      const via = a.role_target === 'all' ? 'Everyone' : `${a.role_target}s`
                      return (
                        <div key={a.id} style={{
                          display: 'flex', alignItems: 'center', gap: 10,
                          padding: '10px 12px', borderRadius: 'var(--r-md)',
                          background: 'transparent',
                          border: '1px dashed var(--cal-border-lt)',
                        }}>
                          <span style={{ fontSize: 18, opacity: 0.75 }}>{meta?.flag ?? '🌏'}</span>
                          <div style={{ flex: 1, minWidth: 0 }}>
                            <div style={{ fontSize: 13, color: 'var(--cal-ink-soft)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                              {meta?.label ?? a.module_slug}
                            </div>
                            <div style={{ fontSize: 10, color: 'var(--cal-muted)' }}>
                              via {via}{a.due_date && ` · Due ${fmtDate(a.due_date)}`}
                            </div>
                          </div>
                          <span style={{
                            fontFamily: 'var(--font-display)', fontSize: 9, fontWeight: 600,
                            letterSpacing: '0.06em', textTransform: 'uppercase',
                            color: 'var(--cal-muted)',
                            padding: '3px 7px', borderRadius: 'var(--r-sm)',
                            border: '1px solid var(--cal-border-lt)',
                          }}>Inherited</span>
                        </div>
                      )
                    })}
                  </div>
                )
              })()}

              {/* Add module assignment */}
              <div style={{
                background: 'var(--cal-surface)', borderRadius: 'var(--r-md)',
                padding: 12, marginBottom: 22,
                border: '1px dashed var(--cal-border-lt)',
              }}>
                <div className="label-caps" style={{ marginBottom: 8 }}>Add module to this user</div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, alignItems: 'center' }}>
                  <select
                    value={addModuleForm.slug}
                    onChange={e => setAddModuleForm(f => ({ ...f, slug: e.target.value }))}
                    style={{
                      flex: 1, minWidth: 180,
                      padding: '7px 10px', fontSize: 12,
                      border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                      background: '#fff', cursor: 'pointer',
                    }}
                  >
                    <option value="">— pick a module —</option>
                    {Object.entries(MODULE_META).filter(([, m]) => !m.inDev).map(([slug, m]) => {
                      const alreadyAssigned = assignments.some(a => a.user_id === selectedUser.id && a.module_slug === slug)
                      return (
                        <option key={slug} value={slug} disabled={alreadyAssigned}>
                          {m.flag} {m.label?.replace('Understand ', '') ?? slug}{alreadyAssigned ? ' (already assigned)' : ''}
                        </option>
                      )
                    })}
                  </select>
                  <input
                    type="date"
                    value={addModuleForm.dueDate}
                    onChange={e => setAddModuleForm(f => ({ ...f, dueDate: e.target.value }))}
                    title="Due date (optional)"
                    style={{ fontSize: 12, padding: '6px 8px', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)' }}
                  />
                  <button
                    type="button"
                    onClick={handleAddModuleToUser}
                    disabled={!addModuleForm.slug || addModuleSaving}
                    className="btn"
                    style={{ fontSize: 12, padding: '7px 14px', background: 'var(--cal-teal)', color: '#fff' }}
                  >{addModuleSaving ? 'Adding…' : 'Add'}</button>
                </div>
                {addModuleError && (
                  <div style={{ marginTop: 8, fontSize: 11, color: '#C62828' }}>{addModuleError}</div>
                )}
              </div>

              {/* Module progress */}
              <div className="label-caps" style={{ marginBottom: 12 }}>Module progress</div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
                {(() => {
                  const userAssignmentSlugs = new Set(
                    assignments
                      .filter(a => a.user_id === selectedUser.id || (!a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)))
                      .map(a => a.module_slug)
                  )
                  const slugs = Array.from(userAssignmentSlugs)
                  if (slugs.length === 0) {
                    return (
                      <div style={{ fontSize: 12, color: 'var(--cal-muted)', fontStyle: 'italic' }}>
                        No modules assigned yet.
                      </div>
                    )
                  }
                  return slugs.map(slug => {
                    const meta = MODULE_META[slug]
                    const realPct = Math.max(0, Math.min(100, Math.round(userCompletions[slug] ?? 0)))
                    const editing = progressEdit[slug] !== undefined
                    const displayPct = editing ? Math.max(0, Math.min(100, Number(progressEdit[slug]) || 0)) : realPct
                    return (
                      <div key={slug} style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
                        <span style={{
                          fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                          letterSpacing: '0.06em', color: 'var(--cal-teal)',
                          background: 'var(--cal-surface)', padding: '3px 7px',
                          borderRadius: 'var(--r-sm)', border: '1px solid var(--cal-border)',
                        }}>{meta?.flag ?? slug}</span>
                        <div style={{ flex: 1, minWidth: 120 }}>
                          <div style={{ fontSize: 13, color: 'var(--cal-ink)', marginBottom: 4, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                            {meta?.label ?? slug}
                          </div>
                          <div className="progress-track" style={{ height: 4 }}>
                            <div className={`progress-fill ${cellStatus(displayPct) === 'done' ? 'green' : cellStatus(displayPct) === 'progress' ? 'amber' : ''}`} style={{ width: `${displayPct}%` }} />
                          </div>
                        </div>
                        <input
                          type="number"
                          min={0}
                          max={100}
                          value={editing ? progressEdit[slug] : realPct}
                          onChange={e => setProgressEdit(prev => ({ ...prev, [slug]: e.target.value }))}
                          style={{
                            width: 60, fontSize: 12, padding: '4px 6px',
                            border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                            textAlign: 'right',
                          }}
                          title="Override progress %"
                        />
                        <span style={{ fontSize: 11, color: 'var(--cal-muted)' }}>%</span>
                        {editing && Number(progressEdit[slug]) !== realPct && (
                          <button
                            type="button"
                            onClick={() => handleSaveProgress(slug)}
                            disabled={progressSaving === slug}
                            style={{ fontSize: 11, padding: '3px 10px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}
                          >{progressSaving === slug ? '…' : 'Save'}</button>
                        )}
                      </div>
                    )
                  })
                })()}
              </div>

              {/* Grades (quiz + final exam) */}
              <div className="label-caps" style={{ marginBottom: 12 }}>Grades</div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
                {(() => {
                  const userAssignmentSlugs = new Set(
                    assignments
                      .filter(a => a.user_id === selectedUser.id || (!a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)))
                      .map(a => a.module_slug)
                  )
                  const slugs = Array.from(userAssignmentSlugs)
                  if (slugs.length === 0) {
                    return (
                      <div style={{ fontSize: 12, color: 'var(--cal-muted)', fontStyle: 'italic' }}>
                        No modules assigned yet.
                      </div>
                    )
                  }
                  const QUIZ_TYPES = [
                    { key: 'checkpoint', label: 'Checkpoints' },
                    { key: 'final_exam', label: 'Final exam' },
                  ]
                  return slugs.map(slug => {
                    const meta = MODULE_META[slug]
                    const scoreByType = userScores[slug] ?? {}
                    return (
                      <div key={slug} style={{
                        padding: '10px 12px', borderRadius: 'var(--r-md)',
                        background: 'var(--cal-surface)',
                        border: '1px solid var(--cal-border-lt)',
                      }}>
                        <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)', marginBottom: 6 }}>
                          {meta?.flag ?? '🌏'} {meta?.label ?? slug}
                        </div>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
                          {QUIZ_TYPES.map(qt => {
                            const baseScore = scoreByType[qt.key]
                            const override = userOverrides.find(o => o.module_slug === slug && o.quiz_type === qt.key)
                            const hasData = baseScore || override
                            return (
                              <div key={qt.key} style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap', fontSize: 11 }}>
                                <span style={{ minWidth: 90, color: 'var(--cal-muted)' }}>{qt.label}</span>
                                {hasData ? (
                                  <>
                                    {override ? (
                                      <span style={{ fontWeight: 600, color: 'var(--cal-ink)' }}>
                                        {override.override_score}%
                                        <span style={{ marginLeft: 6, fontSize: 9, fontWeight: 500, color: '#8e5400', background: '#FFF3E0', padding: '1px 5px', borderRadius: 3 }}>OVERRIDE</span>
                                        {baseScore && (
                                          <span style={{ marginLeft: 6, color: 'var(--cal-muted)', textDecoration: 'line-through' }}>{baseScore.pct}%</span>
                                        )}
                                      </span>
                                    ) : (
                                      <span style={{ fontWeight: 600, color: 'var(--cal-ink)' }}>
                                        {baseScore.pct}% <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>({baseScore.correct}/{baseScore.total})</span>
                                      </span>
                                    )}
                                  </>
                                ) : (
                                  <span style={{ color: 'var(--cal-muted)', fontStyle: 'italic' }}>—</span>
                                )}
                                <button
                                  type="button"
                                  onClick={() => openGradeOverride(slug, qt.key, override?.override_score ?? baseScore?.pct)}
                                  style={{ marginLeft: 'auto', fontSize: 10, padding: '2px 8px', background: 'transparent', border: '1px solid var(--cal-border)', borderRadius: 3, color: 'var(--cal-ink)', cursor: 'pointer' }}
                                >{override ? 'Change' : 'Override'}</button>
                              </div>
                            )
                          })}
                          {gradeOverrideForm && gradeOverrideForm.slug === slug && (
                            <div style={{
                              marginTop: 8, padding: 10,
                              background: '#fff', borderRadius: 'var(--r-sm)',
                              border: '1.5px solid var(--cal-teal)',
                              display: 'flex', flexDirection: 'column', gap: 6,
                            }}>
                              <div style={{ fontSize: 10, fontWeight: 600, color: 'var(--cal-ink-soft)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', textTransform: 'uppercase' }}>
                                Override {gradeOverrideForm.quizType === 'final_exam' ? 'final exam' : 'checkpoints'}
                              </div>
                              <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                                <input
                                  type="number" min={0} max={100}
                                  value={gradeOverrideForm.score}
                                  onChange={e => setGradeOverrideForm(f => ({ ...f, score: e.target.value }))}
                                  placeholder="Score"
                                  style={{ width: 80, fontSize: 12, padding: '5px 8px', border: '1px solid var(--cal-border)', borderRadius: 3 }}
                                />
                                <span style={{ fontSize: 11, color: 'var(--cal-muted)' }}>%</span>
                              </div>
                              <textarea
                                value={gradeOverrideForm.reason}
                                onChange={e => setGradeOverrideForm(f => ({ ...f, reason: e.target.value }))}
                                placeholder="Reason for override (required for audit)"
                                rows={2}
                                style={{ fontSize: 11, padding: '5px 8px', border: '1px solid var(--cal-border)', borderRadius: 3, fontFamily: 'inherit', resize: 'vertical' }}
                              />
                              {gradeOverrideError && (
                                <div style={{ fontSize: 10, color: '#C62828' }}>{gradeOverrideError}</div>
                              )}
                              <div style={{ display: 'flex', gap: 6, justifyContent: 'flex-end' }}>
                                <button type="button" onClick={closeGradeOverride} disabled={gradeOverrideSaving}
                                  style={{ fontSize: 11, padding: '4px 10px', background: 'transparent', border: '1px solid var(--cal-border)', borderRadius: 3, cursor: 'pointer' }}>Cancel</button>
                                <button type="button" onClick={handleSaveGradeOverride} disabled={gradeOverrideSaving || !gradeOverrideForm.score}
                                  style={{ fontSize: 11, padding: '4px 10px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}>
                                  {gradeOverrideSaving ? 'Saving…' : 'Save override'}</button>
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    )
                  })
                })()}
              </div>

              <div style={{ marginTop: 18, display: 'flex', justifyContent: 'flex-end' }}>
                <button
                  type="button"
                  onClick={() => setSelectedUser(null)}
                  className="btn"
                  style={{ fontSize: 13, padding: '9px 18px', background: 'var(--cal-teal)', color: '#fff' }}
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ════════════════ ADD NEW MEMBER MODAL ════════════════ */}
      {addMemberOpen && (
        <div
          onClick={closeAddMember}
          style={{
            position: 'fixed', inset: 0,
            background: 'rgba(0,0,0,0.45)',
            display: 'flex', alignItems: 'flex-start', justifyContent: 'center',
            padding: '60px 20px 20px', zIndex: 1000, overflowY: 'auto',
          }}
        >
          <div
            onClick={e => e.stopPropagation()}
            style={{
              background: '#fff', borderRadius: 'var(--r-lg)',
              maxWidth: 560, width: '100%',
              boxShadow: 'var(--shadow-lg)',
              padding: 28,
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 18 }}>
              <div>
                <h3 style={{ fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>
                  Add new member
                </h3>
                <p style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
                  Invite a teacher, parent, or admin and optionally pre-assign modules.
                </p>
              </div>
              <button
                type="button"
                onClick={closeAddMember}
                aria-label="Close"
                style={{ border: 'none', background: 'transparent', fontSize: 22, color: 'var(--cal-muted)', cursor: 'pointer', lineHeight: 1 }}
              >×</button>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                  Full name
                </label>
                <input
                  className="input"
                  type="text"
                  value={addMemberForm.fullName}
                  onChange={e => setAddMemberForm(f => ({ ...f, fullName: e.target.value }))}
                  placeholder="e.g. Eric Schoonard"
                  style={{ width: '100%' }}
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                  Email
                </label>
                <input
                  className="input"
                  type="email"
                  value={addMemberForm.email}
                  onChange={e => setAddMemberForm(f => ({ ...f, email: e.target.value }))}
                  placeholder="name@school.org"
                  style={{ width: '100%' }}
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                  Role
                </label>
                <select
                  value={addMemberForm.role}
                  onChange={e => setAddMemberForm(f => ({ ...f, role: e.target.value }))}
                  style={{
                    width: '100%', padding: '9px 12px', fontSize: 13,
                    border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                    background: '#fff', cursor: 'pointer',
                  }}
                >
                  <option value="teacher">Teacher</option>
                  <option value="parent">Parent</option>
                  <option value="admin">Admin</option>
                  {isSuperAdmin && <option value="superadmin">Superadmin</option>}
                </select>
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 8 }}>
                  Modules to auto-assign <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
                </label>
                <div style={{
                  border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-sm)',
                  maxHeight: 200, overflowY: 'auto',
                }}>
                  {Object.entries(MODULE_META).filter(([, m]) => !m.inDev).map(([slug, m], i, arr) => {
                    const checked = slug in addMemberForm.selectedModules
                    return (
                      <div key={slug} style={{
                        display: 'flex', alignItems: 'center', gap: 10,
                        padding: '8px 12px',
                        borderBottom: i < arr.length - 1 ? '1px solid var(--cal-border-lt)' : 'none',
                        background: checked ? 'var(--cal-teal-lt)' : 'transparent',
                      }}>
                        <input
                          type="checkbox"
                          checked={checked}
                          onChange={() => toggleAddMemberModule(slug)}
                          style={{ cursor: 'pointer' }}
                        />
                        <div style={{ flex: 1, fontSize: 12 }}>
                          <span>{m.flag} {m.label?.replace('Understand ', '') ?? slug}</span>
                        </div>
                        {checked && (
                          <input
                            type="date"
                            value={addMemberForm.selectedModules[slug] ?? ''}
                            onChange={e => setAddMemberModuleDue(slug, e.target.value)}
                            style={{
                              fontSize: 11, padding: '4px 6px',
                              border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                            }}
                            title="Due date (optional)"
                          />
                        )}
                      </div>
                    )
                  })}
                </div>
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                  Welcome message <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
                </label>
                <textarea
                  value={addMemberForm.welcomeMessage}
                  onChange={e => setAddMemberForm(f => ({ ...f, welcomeMessage: e.target.value }))}
                  placeholder="Short note that goes out with the invite email."
                  rows={3}
                  style={{
                    width: '100%', padding: '9px 12px', fontSize: 13,
                    border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                    fontFamily: 'inherit', resize: 'vertical',
                  }}
                />
                <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
                  Passed to the invite edge function as <code>welcome_message</code>; ignored until the backend surfaces it.
                </div>
              </div>

              {addMemberError && (
                <div style={{ background: '#FFEBEE', color: '#C62828', padding: '8px 12px', borderRadius: 'var(--r-sm)', fontSize: 12 }}>
                  {addMemberError}
                </div>
              )}

              <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end', marginTop: 6 }}>
                <button
                  type="button"
                  onClick={closeAddMember}
                  disabled={addMemberSaving}
                  className="btn"
                  style={{ fontSize: 12, padding: '8px 14px', background: 'transparent', border: '1px solid var(--cal-border)', color: 'var(--cal-ink)' }}
                >Cancel</button>
                <button
                  type="button"
                  onClick={handleAddMember}
                  disabled={addMemberSaving || !addMemberForm.email.trim() || !addMemberForm.fullName.trim()}
                  className="btn"
                  style={{ fontSize: 12, padding: '8px 14px', background: 'var(--cal-teal)', color: '#fff' }}
                >{addMemberSaving ? 'Adding…' : 'Send invite & add'}</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
