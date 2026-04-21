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
  setUserActive,
  getAllSchools,
} from '../lib/supabase'
import {
  MOCK_USERS, MOCK_ASSIGNMENTS, MODULE_META,
  MOCK_ADMIN_ACTION_ITEMS, MOCK_QUIZ_ANALYTICS,
  getActiveModuleSlugs, getSchoolStats, MOCK_SCHOOL,
} from '../data/mockData'
import ModulesView   from './admin/views/ModulesView'
import AnalyticsView from './admin/views/AnalyticsView'
import ActionsView   from './admin/views/ActionsView'
import UsersView     from './admin/views/UsersView'
import AssignView    from './admin/views/AssignView'
import InviteView    from './admin/views/InviteView'
import UserDetailModal from './admin/components/UserDetailModal'

import {
  MOCK_MODE,
  fmtDate,
  daysUntil,
  isValidEmail,
  rowValidationError,
  parseInviteCsv,
  aggregateQuizAnalytics,
} from './admin/utils'
import StatCard       from './admin/components/StatCard'
import CompletionCell from './admin/components/CompletionCell'

/* ── Main component ── */

export default function AdminDashboard() {
  const navigate = useNavigate()
  const { user, profile, school, isSuperAdmin } = useAuth()
  const schoolName = school?.name ?? MOCK_SCHOOL.name
  const [roleFilter, setRoleFilter]   = useState('all')   // 'all' | 'teacher' | 'parent' | 'admin' | 'superadmin'
  const [memberSearch, setMemberSearch] = useState('')
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
  // Soft-delete state — separate from editSaving so the two buttons don't
  // block each other and the error message has its own space.
  const [deactivateSaving, setDeactivateSaving] = useState(false)
  const [deactivateError,  setDeactivateError]  = useState('')

  // "Add new member" modal — invite + optional auto-assign modules with due dates.
  const [addMemberOpen, setAddMemberOpen] = useState(false)
  const [addMemberForm, setAddMemberForm] = useState({
    email: '', fullName: '', role: 'teacher',
    selectedModules: {}, // { slug: 'yyyy-mm-dd' } — presence = selected
    welcomeMessage: '',
    sendEmail: true,
    initialPassword: '', // empty = no pre-set password (normal invite flow)
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

  // Admin-triggered password reset: { status: 'idle'|'sending'|'sent'|'error', message?: string }
  const [resetStatus, setResetStatus] = useState({ status: 'idle' })

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

  const visibleUsers = members.filter(u => {
    if (roleFilter !== 'all' && u.role !== roleFilter) return false
    const q = memberSearch.trim().toLowerCase()
    if (!q) return true
    const name  = (u.full_name ?? '').toLowerCase()
    const email = (u.email     ?? '').toLowerCase()
    return name.includes(q) || email.includes(q)
  })
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

  // Fetch the full school list so both superadmins (who can move any member)
  // and regular users (who may need to fix their own school_id) get a picker.
  // If RLS blocks the read, we fall back to an empty list — the edit modal
  // injects the caller's current school as a selectable option anyway.
  useEffect(() => {
    if (MOCK_MODE) { setAllSchools([MOCK_SCHOOL]); return }
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

  // Remove every assignment for one module slug at this school. Called from the
  // Modules tab when an admin clicks "Remove from school" on a module card.
  // Progress rows survive (learners keep history); only the assignments go.
  async function handleRemoveModuleFromSchool(slug, meta, schoolAssignments) {
    const count = schoolAssignments.length
    const hasIndividual = schoolAssignments.some(a => !!a.user_id)
    const hasRole = schoolAssignments.some(a => !a.user_id)
    const detail = hasIndividual && hasRole
      ? 'individual and role-level'
      : hasIndividual ? 'individual' : 'role-level'
    const ok = window.confirm(
      `Remove ${meta.label} from ${schoolName}?\n\n` +
      `This deletes ${count} ${detail} assignment${count === 1 ? '' : 's'}. ` +
      `Learners keep their existing progress, but the module will no longer appear on their dashboards.`
    )
    if (!ok) return
    try {
      for (const a of schoolAssignments) {
        // eslint-disable-next-line no-await-in-loop
        if (!MOCK_MODE) await deleteAssignment(a.id)
      }
      setAssignments(prev => prev.filter(a => a.module_slug !== slug))
    } catch (err) {
      window.alert(`Failed to remove: ${err?.message ?? 'unknown error'}`)
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
    setDeactivateError('')
    setEditMode(true)
  }

  function cancelEditMode() {
    setEditMode(false)
    setEditError('')
    setDeactivateError('')
  }

  async function saveMemberEdit() {
    if (!selectedUser) return
    setEditSaving(true)
    setEditError('')
    try {
      // Superadmins can move any member; non-superadmins can only change the
      // school on their own record (self-service fix for a bad school_id).
      const canEditSchool = isSuperAdmin || (profile && selectedUser.id === profile.id)
      const schoolIdChanging = canEditSchool
        && editForm.schoolId
        && editForm.schoolId !== selectedUser.school_id
      if (!MOCK_MODE) {
        await updateMemberProfile({
          userId:   selectedUser.id,
          fullName: editForm.fullName.trim() || null,
          role:     editForm.role,
          ...(schoolIdChanging ? { schoolId: editForm.schoolId } : {}),
        })
      }
      // Optimistic: update the local roster row in place and refresh list.
      setMembers(prev => prev.map(u => u.id === selectedUser.id ? {
        ...u,
        full_name: editForm.fullName.trim() || null,
        role:      editForm.role,
        school_id: schoolIdChanging ? editForm.schoolId : u.school_id,
      } : u))
      setSelectedUser(u => u ? {
        ...u,
        full_name: editForm.fullName.trim() || null,
        role:      editForm.role,
        school_id: schoolIdChanging ? editForm.schoolId : u.school_id,
      } : u)
      setMembersRefreshKey(k => k + 1)
      setEditMode(false)
    } catch (err) {
      setEditError(err?.message ?? 'Failed to save. Please try again.')
    } finally {
      setEditSaving(false)
    }
  }

  // Soft-delete (deactivate) the currently-open user. Drops their assignments
  // and completions, flips is_active=false, removes them from the members list.
  // Self-deactivation is blocked — Mark can't accidentally lock himself out.
  async function handleDeactivateUser() {
    if (!selectedUser) return
    if (profile && selectedUser.id === profile.id) {
      setDeactivateError('You cannot deactivate your own account.')
      return
    }
    const label = selectedUser.full_name || selectedUser.email || 'this user'
    const ok = window.confirm(
      `Deactivate ${label}?\n\n` +
      `They'll be hidden from the members list and won't be able to log in. ` +
      `All of their open assignments and module progress will be cleared. ` +
      `A superadmin can reactivate them later from Supabase.\n\n` +
      `This is the right choice for dummy/test users.`
    )
    if (!ok) return
    setDeactivateSaving(true)
    setDeactivateError('')
    try {
      await setUserActive(selectedUser.id, false, { actingUserId: profile?.id })
      // Remove from the members list and close the modal.
      setMembers(prev => prev.filter(u => u.id !== selectedUser.id))
      setMembersRefreshKey(k => k + 1)
      setEditMode(false)
      setSelectedUser(null)
    } catch (err) {
      setDeactivateError(err?.message ?? 'Failed to deactivate this user.')
    } finally {
      setDeactivateSaving(false)
    }
  }

  // "Add new member" modal: open / close / module toggle / submit.
  function openAddMember() {
    setAddMemberForm({
      email: '', fullName: '',
      role: 'teacher',
      selectedModules: {},
      welcomeMessage: '',
      sendEmail: true,
      initialPassword: '',
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
    const initialPassword = (addMemberForm.initialPassword ?? '').trim()

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
    if (initialPassword && initialPassword.length < 8) {
      setAddMemberError('Initial password must be at least 8 characters.')
      return
    }

    setAddMemberSaving(true)
    try {
      // When an initial password is set we skip the invite email — the admin
      // is expected to hand the password over out-of-band. Otherwise honor
      // the admin's `sendEmail` toggle.
      const sendEmail = initialPassword ? false : (addMemberForm.sendEmail !== false)
      const result = await inviteUser({
        email, fullName, role, schoolId,
        welcomeMessage: welcomeMessage || undefined,
        sendEmail,
        password: initialPassword || undefined,
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
            { key: 'modules',    icon: '▲', label: 'Modules' },
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
            <UsersView
              members={members}
              schoolName={schoolName}
              profile={profile}
              setSelectedUser={setSelectedUser}
              openAddMember={openAddMember}
              roleFilter={roleFilter}
              setRoleFilter={setRoleFilter}
              memberSearch={memberSearch}
              setMemberSearch={setMemberSearch}
              visibleUsers={visibleUsers}
              userSlugs={userSlugs}
              userOverallPct={userOverallPct}
            />
          )}

          {/* ════════════════ ACTION QUEUE ════════════════ */}
          {adminView === 'actions' && (
            <ActionsView
              actionItems={actionItems}
              actionError={actionError}
              actionLoading={actionLoading}
              actionRefreshing={actionRefreshing}
              handleActionRefresh={handleActionRefresh}
              handleActionResolve={handleActionResolve}
            />
          )}

          {/* ════════════════ MODULES ════════════════ */}
          {adminView === 'modules' && (
            <ModulesView
              navigate={navigate}
              schoolName={schoolName}
              isSuperAdmin={isSuperAdmin}
              assignments={assignments}
              setAssignForm={setAssignForm}
              setAdminView={setAdminView}
              onRemoveFromSchool={handleRemoveModuleFromSchool}
            />
          )}

          {/* ════════════════ ASSIGN MODULE ════════════════ */}
          {adminView === 'assign' && (
            <AssignView
              handleAssign={handleAssign}
              assignForm={assignForm}
              setAssignForm={setAssignForm}
              members={members}
              assignments={assignments}
              assignSaved={assignSaved}
              assignError={assignError}
              handleUnassign={handleUnassign}
            />
          )}
          {/* ════════════════ QUIZ ANALYTICS ════════════════ */}
          {adminView === 'analytics' && (
            <AnalyticsView
              analyticsSlug={analyticsSlug}
              setAnalyticsSlug={setAnalyticsSlug}
              analyticsData={analyticsData}
              analyticsLoading={analyticsLoading}
              analyticsError={analyticsError}
            />
          )}

          {/* ════════════════ INVITE MEMBER ════════════════ */}
          {adminView === 'invite' && (
            <InviteView
              handleSingleInvite={handleSingleInvite}
              inviteForm={inviteForm}
              setInviteForm={setInviteForm}
              inviteSaved={inviteSaved}
              inviteError={inviteError}
              csvImporting={csvImporting}
              handleCsvFile={handleCsvFile}
              csvError={csvError}
              csvRows={csvRows}
              csvSummary={csvSummary}
              csvImportableCount={csvImportableCount}
              handleCsvImport={handleCsvImport}
            />
          )}

        </main>
      </div>

      {/* ── User detail modal ── */}
      {selectedUser && (
        <UserDetailModal
          selectedUser={selectedUser}
          setSelectedUser={setSelectedUser}
          profile={profile}
          isSuperAdmin={isSuperAdmin}
          allSchools={allSchools}
          school={school}
          editMode={editMode}
          setEditMode={setEditMode}
          editForm={editForm}
          setEditForm={setEditForm}
          editError={editError}
          editSaving={editSaving}
          openEditMode={openEditMode}
          cancelEditMode={cancelEditMode}
          saveMemberEdit={saveMemberEdit}
          resetStatus={resetStatus}
          setResetStatus={setResetStatus}
          deactivateError={deactivateError}
          deactivateSaving={deactivateSaving}
          handleDeactivateUser={handleDeactivateUser}
          assignments={assignments}
          dueDateEditing={dueDateEditing}
          setDueDateEditing={setDueDateEditing}
          dueDateSaving={dueDateSaving}
          handleSaveDueDate={handleSaveDueDate}
          handleUnassign={handleUnassign}
          addModuleForm={addModuleForm}
          setAddModuleForm={setAddModuleForm}
          addModuleSaving={addModuleSaving}
          addModuleError={addModuleError}
          handleAddModuleToUser={handleAddModuleToUser}
          userCompletions={userCompletions}
          progressEdit={progressEdit}
          setProgressEdit={setProgressEdit}
          progressSaving={progressSaving}
          handleSaveProgress={handleSaveProgress}
          userScores={userScores}
          userOverrides={userOverrides}
          gradeOverrideForm={gradeOverrideForm}
          setGradeOverrideForm={setGradeOverrideForm}
          gradeOverrideError={gradeOverrideError}
          gradeOverrideSaving={gradeOverrideSaving}
          openGradeOverride={openGradeOverride}
          closeGradeOverride={closeGradeOverride}
          handleSaveGradeOverride={handleSaveGradeOverride}
        />
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

              {/* Admin-set initial password (optional). Setting one skips the
                  invite email — the admin hands the password over out-of-band. */}
              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                  Initial password <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
                </label>
                <input
                  className="input"
                  type="text"
                  autoComplete="new-password"
                  value={addMemberForm.initialPassword}
                  onChange={e => setAddMemberForm(f => ({ ...f, initialPassword: e.target.value }))}
                  placeholder="Leave blank to send an invite email"
                  style={{ width: '100%' }}
                />
                <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4, lineHeight: 1.5 }}>
                  Set a password to create the account silently (no invite email). Min 8 chars.
                  The user can sign in immediately and change it later from their profile,
                  or you can trigger a reset link from their detail panel.
                </div>
              </div>

              {/* Send-invite toggle. Forced off when an initial password is set. */}
              <div>
                <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12, color: 'var(--cal-ink)', cursor: addMemberForm.initialPassword ? 'not-allowed' : 'pointer' }}>
                  <input
                    type="checkbox"
                    checked={!addMemberForm.initialPassword && addMemberForm.sendEmail !== false}
                    onChange={e => setAddMemberForm(f => ({ ...f, sendEmail: e.target.checked }))}
                    disabled={!!addMemberForm.initialPassword}
                    style={{ cursor: addMemberForm.initialPassword ? 'not-allowed' : 'pointer' }}
                  />
                  <span>Send Supabase invite email</span>
                </label>
                <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4, marginLeft: 24 }}>
                  {addMemberForm.initialPassword
                    ? 'Disabled — silent create (password above) skips the email.'
                    : 'Uncheck to create the account without emailing the user.'}
                </div>
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 8 }}>
                  Modules to auto-assign <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
                </label>
                <div style={{
                  border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-sm)',
                  maxHeight: 200, overflowY: 'auto',
                }}>
                  {Object.entries(MODULE_META).map(([slug, m], i, arr) => {
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
                <div style={{
                  padding: '9px 12px',
                  background: '#FFF4E5',
                  border: '1px solid #F5C27A',
                  borderRadius: 'var(--r-sm)',
                  fontSize: 12,
                  color: '#8A5A14',
                }}>
                  {addMemberError}
                </div>
              )}

              <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end', paddingTop: 6 }}>
                <button
                  type="button"
                  onClick={closeAddMember}
                  className="btn btn-ghost"
                  disabled={addMemberSaving}
                  style={{ fontSize: 13, padding: '9px 18px' }}
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleAddMember}
                  className="btn"
                  disabled={addMemberSaving}
                  style={{
                    fontSize: 13, padding: '9px 20px',
                    background: 'var(--cal-teal)', color: '#fff',
                    opacity: addMemberSaving ? 0.7 : 1,
                  }}
                >
                  {addMemberSaving ? 'Adding…' : 'Add member'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
