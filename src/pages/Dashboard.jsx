import { useEffect, useState } from 'react'
import { useAuth } from '../context/AuthContext'
import { getAssignments, getCompletions, deleteAssignment } from '../lib/supabase'
import TopBar from '../components/TopBar'
import ModuleCard from '../components/ModuleCard'
import ErrorState from '../components/ErrorState'

const FETCH_TIMEOUT_MS = 8000

const MODULE_LABELS = {
  'india-ib':             'Understand India',
  'korea-ib':             'Understand Korea',
  'ksa-ib':               'Understand Saudi Arabia',
  'china-ib':             'Understand China',
  'vietnam-ib':           'Understand Vietnam',
  'japan-ib':             'Understand Japan',
  'woodstock-transition': 'Curriculum Transition',
  'indonesia-ib':         'Understand Indonesia',
  'uae-ib':               'Understand UAE',
}

export default function Dashboard() {
  const { user, profile, school }       = useAuth()
  const [assignments, setAssignments]   = useState([])
  const [completions, setCompletions]   = useState({})
  const [loading,     setLoading]       = useState(true)
  const [loadError,   setLoadError]     = useState(null)
  const [retryCount,  setRetryCount]    = useState(0)
  const [bannerDismissed, setBannerDismissed] = useState(false)

  useEffect(() => {
    if (!user || !profile) return
    setLoading(true)
    setLoadError(null)
    let active = true
    const timer = setTimeout(() => {
      if (active) {
        active = false
        setLoading(false)
        setLoadError('timeout')
      }
    }, FETCH_TIMEOUT_MS)

    Promise.all([
      getAssignments(user.id, profile.school_id),
      getCompletions(user.id),
    ])
      .then(([asgn, comp]) => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setAssignments(asgn)
        const idx = {}
        comp.forEach(c => { idx[c.module_slug] = c })
        setCompletions(idx)
        setLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setLoadError(err?.message || 'Failed to load your modules.')
        setLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [user?.id, profile?.school_id, retryCount])

  // Admins/superadmins can unassign a module from themselves directly from
  // My Modules — handy for clearing duplicates from testing. Non-admin users
  // see no remove button; they can still ask their admin via the user detail
  // modal in AdminDashboard.
  const canRemove = profile?.role === 'admin' || profile?.role === 'superadmin'
  async function handleRemove(assignment) {
    const label = MODULE_LABELS[assignment.module_slug] ?? assignment.module_slug
    const dueStr = assignment.due_date
      ? new Date(assignment.due_date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })
      : 'no due date'
    if (!window.confirm(`Remove "${label}" (${dueStr}) from your assignments?`)) return
    const previous = assignments
    setAssignments(prev => prev.filter(a => a.id !== assignment.id))
    try {
      await deleteAssignment(assignment.id)
    } catch (err) {
      setAssignments(previous)
      window.alert(err?.message ?? 'Failed to remove this assignment.')
    }
  }

  const greeting = greetingWord()
  const firstName = profile?.full_name?.split(' ')[0] ?? profile?.email?.split('@')[0] ?? 'there'

  const total     = assignments.length
  const completed = assignments.filter(a => completions[a.module_slug]?.completed_at).length
  const inProg    = assignments.filter(a => {
    const c = completions[a.module_slug]
    return c && c.progress_pct > 0 && !c.completed_at
  }).length

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
      <TopBar activePage="modules" />
      <div style={{ display: 'flex', flex: 1, overflow: 'hidden' }}>
        <aside className="app-sidebar" style={{
          width: 'var(--sidebar-w)',
          background: 'var(--cal-surface)',
          borderRight: '1px solid var(--cal-border)',
          display: 'flex',
          flexDirection: 'column',
          padding: '24px 16px',
          flexShrink: 0,
          overflowY: 'auto',
        }}>
          <div className="label-caps" style={{ marginBottom: 10 }}>Assigned to you</div>
          {assignments.length === 0 && !loading && (
            <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
              No modules assigned yet. Check back after your school administrator has set up your training.
            </div>
          )}
          {assignments.map(a => {
            const comp = completions[a.module_slug]
            const done = !!comp?.completed_at
            const started = comp?.progress_pct > 0
            return (
              <div key={a.id} style={{
                display: 'flex', alignItems: 'center', gap: 8,
                padding: '7px 10px', borderRadius: 'var(--r-sm)',
                fontSize: 12, fontWeight: 500,
                color: 'var(--cal-ink-soft)',
                marginBottom: 2,
              }}>
                <div style={{
                  width: 7, height: 7, borderRadius: '50%', flexShrink: 0,
                  background: done ? '#43A047' : started ? 'var(--cal-amber)' : 'var(--cal-border)',
                }} />
                <span style={{ lineHeight: 1.3 }}>
                  {MODULE_LABELS[a.module_slug] ?? a.module_slug}
                </span>
              </div>
            )
          })}
          {school && (
            <>
              <div style={{ borderTop: '1px solid var(--cal-border)', margin: '20px 0 14px' }} />
              <div className="label-caps" style={{ marginBottom: 8 }}>School</div>
              <div style={{ fontSize: 12, color: 'var(--cal-muted)', fontWeight: 500 }}>{school.name}</div>
            </>
          )}
        </aside>

        <main style={{ flex: 1, overflowY: 'auto', padding: '32px 36px' }}>
          {!bannerDismissed && !loading && (() => {
            const DAYS = 7
            const cutoff = new Date(Date.now() - DAYS * 86400000)
            const newAsgns = assignments.filter(a =>
              a.assigned_at && new Date(a.assigned_at) >= cutoff
            )
            if (newAsgns.length === 0) return null
            const latest = newAsgns.sort((a, b) => new Date(b.assigned_at) - new Date(a.assigned_at))[0]
            const label  = MODULE_LABELS[latest.module_slug] ?? latest.module_slug
            const due    = latest.due_date
              ? ` - Due ${new Date(latest.due_date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })}`
              : ''
            return (
              <div style={{
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                background: 'var(--cal-teal)', color: '#fff',
                borderRadius: 'var(--r-md)', padding: '12px 18px',
                marginBottom: 20, gap: 12,
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, fontSize: 13 }}>
                  <span style={{ fontSize: 16 }}>N</span>
                  <span>
                    <strong style={{ fontFamily: 'var(--font-display)' }}>New assignment</strong>
                    {' - '}{label}{due}
                  </span>
                  {newAsgns.length > 1 && (
                    <span style={{ background: 'rgba(255,255,255,0.2)', borderRadius: 'var(--r-full)', padding: '2px 8px', fontSize: 11, fontWeight: 600 }}>
                      +{newAsgns.length - 1} more
                    </span>
                  )}
                </div>
                <button
                  onClick={() => setBannerDismissed(true)}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'rgba(255,255,255,0.7)', fontSize: 18, lineHeight: 1, padding: '0 2px' }}
                  aria-label="Dismiss"
                >x</button>
              </div>
            )
          })()}

          <div style={{ marginBottom: 28 }}>
            <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 4 }}>
              {greeting}, {firstName}.
            </h2>
            <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
              {total === 0
                ? 'No modules assigned yet.'
                : completed === total
                  ? `You've completed all ${total} module${total > 1 ? 's' : ''}. Well done.`
                  : `${completed} of ${total} module${total > 1 ? 's' : ''} complete${inProg > 0 ? ` - ${inProg} in progress` : ''}.`
              }
            </p>
          </div>

          {total > 0 && (
            <div style={{
              background: 'var(--cal-white)',
              borderRadius: 'var(--r-lg)',
              padding: '16px 20px',
              marginBottom: 28,
              boxShadow: 'var(--shadow-sm)',
              display: 'flex',
              alignItems: 'center',
              gap: 20,
            }}>
              <div style={{ flex: 1 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: 'var(--cal-muted)', marginBottom: 6 }}>
                  <span>Overall progress</span>
                  <span>{completed}/{total} complete</span>
                </div>
                <div className="progress-track" style={{ height: 6 }}>
                  <div className="progress-fill green" style={{ width: `${total > 0 ? (completed / total) * 100 : 0}%` }} />
                </div>
              </div>
              <div style={{ display: 'flex', gap: 20, flexShrink: 0 }}>
                {[
                  { n: completed, label: 'Done',        color: '#43A047' },
                  { n: inProg,    label: 'In progress', color: 'var(--cal-amber)' },
                  { n: total - completed - inProg, label: 'Not started', color: 'var(--cal-border)' },
                ].map(s => (
                  <div key={s.label} style={{ textAlign: 'center' }}>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 700, color: s.color }}>{s.n}</div>
                    <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 2 }}>{s.label}</div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {loading && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--cal-muted)', padding: '40px 0' }}>
              <div style={{
                width: 16, height: 16,
                border: '2px solid var(--cal-border)',
                borderTopColor: 'var(--cal-teal)',
                borderRadius: '50%',
                animation: 'spin 0.8s linear infinite',
              }} />
              <span style={{ fontSize: 13 }}>Loading your modules...</span>
              <style>{`@keyframes spin { to { transform: rotate(360deg) } }`}</style>
            </div>
          )}

          {!loading && loadError && (
            <ErrorState
              error={loadError}
              context="your modules"
              onRetry={() => setRetryCount(c => c + 1)}
            />
          )}

          {!loading && !loadError && assignments.length > 0 && (
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
              gap: 18,
            }}>
              {assignments.map(a => (
                <ModuleCard
                  key={a.id}
                  assignment={a}
                  completion={completions[a.module_slug] ?? null}
                  onRemove={canRemove ? () => handleRemove(a) : null}
                />
              ))}
            </div>
          )}

          {!loading && !loadError && assignments.length === 0 && (
            <div style={{
              textAlign: 'center',
              padding: '80px 40px',
              color: 'var(--cal-muted)',
            }}>
              <div style={{ fontSize: 40, marginBottom: 16 }}>*</div>
              <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 8 }}>
                No modules assigned yet
              </div>
              <div style={{ fontSize: 14, maxWidth: 340, margin: '0 auto', lineHeight: 1.7 }}>
                Your school administrator will assign modules to you before parent season starts. Check back soon.
              </div>
            </div>
          )}
        </main>
      </div>
    </div>
  )
}

function greetingWord() {
  const h = new Date().getHours()
  if (h < 5)  return 'Good evening'
  if (h < 12) return 'Good morning'
  if (h < 17) return 'Good afternoon'
  return 'Good evening'
}
