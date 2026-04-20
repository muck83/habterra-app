import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { getAssignments, getCompletions, getUserQuizResponses } from '../lib/supabase'
import { MODULE_META } from '../data/mockData'
import TopBar from '../components/TopBar'
import ErrorState from '../components/ErrorState'

const FETCH_TIMEOUT_MS = 8000

function buildQuizIndex(responses) {
  const idx = {}
  responses.forEach(r => {
    if (!idx[r.module_id]) idx[r.module_id] = { checkpoints: {}, finalExam: [] }
    if (r.quiz_type === 'checkpoint' && r.dimension_number != null) {
      if (!idx[r.module_id].checkpoints[r.dimension_number]) {
        idx[r.module_id].checkpoints[r.dimension_number] = {
          is_correct:  r.is_correct,
          answered_at: r.answered_at,
        }
      }
    } else if (r.quiz_type === 'final_exam') {
      idx[r.module_id].finalExam.push(r)
    }
  })
  return idx
}

export default function Progress() {
  const { user, profile } = useAuth()
  const navigate = useNavigate()
  const [assignments,    setAssignments]    = useState([])
  const [completions,    setCompletions]    = useState({})
  const [quizIndex,      setQuizIndex]      = useState({})
  const [loading,        setLoading]        = useState(true)
  const [loadError,      setLoadError]      = useState(null)
  const [retryCount,     setRetryCount]     = useState(0)
  const [expandedModule, setExpandedModule] = useState(null)

  useEffect(() => {
    if (!user || !profile) return
    setLoading(true)
    setLoadError(null)
    let active = true
    const timer = setTimeout(() => {
      if (active) { active = false; setLoading(false); setLoadError('timeout') }
    }, FETCH_TIMEOUT_MS)

    Promise.all([
      getAssignments(user.id, profile.school_id),
      getCompletions(user.id),
      getUserQuizResponses(user.id),
    ])
      .then(([asgn, comp, quizResponses]) => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setAssignments(asgn)
        const idx = {}
        comp.forEach(c => { idx[c.module_slug] = c })
        setCompletions(idx)
        setQuizIndex(buildQuizIndex(quizResponses))
        setLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setLoadError(err?.message || 'Failed to load your progress.')
        setLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [user?.id, profile?.school_id, retryCount])

  const firstName = profile?.full_name?.split(' ')[0] ?? 'there'

  const modules = assignments.map(a => {
    const meta = MODULE_META[a.module_slug] ?? {
      slug: a.module_slug, flag: '', label: a.module_slug, lang: 'EN', desc: '',
    }
    const pct  = completions[a.module_slug]?.progress_pct ?? 0
    const done = !!completions[a.module_slug]?.completed_at
    return { ...meta, ...a, pct, done }
  })

  const totalPct  = modules.length
    ? Math.round(modules.reduce((s, m) => s + m.pct, 0) / modules.length)
    : 0
  const doneCount = modules.filter(m => m.done).length

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
      <TopBar activePage="progress" />
      <div style={{ flex: 1, overflowY: 'auto', padding: '36px 48px', maxWidth: 860, margin: '0 auto', width: '100%' }}>

        <div style={{ marginBottom: 32 }}>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>
            Your progress{firstName !== 'there' ? `, ${firstName}` : ''}
          </h2>
          {!loading && (
            <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
              {doneCount} of {modules.length} module{modules.length !== 1 ? 's' : ''} complete
            </p>
          )}
        </div>

        {loading && (
          <div style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--cal-muted)', padding: '40px 0' }}>
            <div style={{ width: 16, height: 16, border: '2px solid var(--cal-border)', borderTopColor: 'var(--cal-teal)', borderRadius: '50%', animation: 'spin 0.8s linear infinite' }} />
            <span style={{ fontSize: 13 }}>Loading your progress...</span>
            <style>{`@keyframes spin { to { transform: rotate(360deg) } }`}</style>
          </div>
        )}

        {!loading && loadError && (
          <ErrorState error={loadError} context="your progress" onRetry={() => setRetryCount(c => c + 1)} />
        )}

        {!loading && !loadError && modules.length === 0 && (
          <div style={{ textAlign: 'center', padding: '80px 40px', color: 'var(--cal-muted)' }}>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 8 }}>
              No modules assigned yet
            </div>
            <div style={{ fontSize: 14, maxWidth: 340, margin: '0 auto', lineHeight: 1.7 }}>
              Your school administrator will assign modules before parent season starts.
            </div>
          </div>
        )}

        {!loading && !loadError && modules.length > 0 && (
          <>
            <div style={{
              background: '#fff', borderRadius: 'var(--r-xl)',
              padding: '28px 32px', marginBottom: 28,
              boxShadow: 'var(--shadow-sm)',
              display: 'flex', alignItems: 'center', gap: 32,
            }}>
              <RingChart pct={totalPct} />
              <div>
                <div style={{ fontFamily: 'var(--font-display)', fontSize: 28, fontWeight: 800, color: 'var(--cal-teal)', marginBottom: 4 }}>
                  {totalPct}%
                </div>
                <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 6 }}>
                  Overall completion
                </div>
                <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.6, maxWidth: 340 }}>
                  {totalPct < 30  && "You're just getting started. Work through one module before parent meetings begin."}
                  {totalPct >= 30 && totalPct < 80 && 'Good momentum. Keep going - completing all modules takes about 90 minutes total.'}
                  {totalPct >= 80 && "Excellent. You're well prepared for parent season."}
                </div>
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              {modules.map(m => {
                const qData   = quizIndex[m.dbId ?? m.module_slug] ?? { checkpoints: {}, finalExam: [] }
                const cpKeys  = Object.keys(qData.checkpoints).map(Number).sort((a,b) => a-b)
                const hasActivity = m.pct > 0 || cpKeys.length > 0 || qData.finalExam.length > 0
                const isExpanded  = expandedModule === (m.id ?? m.slug)
                const feAnswered  = qData.finalExam.length
                const feCorrect   = qData.finalExam.filter(r => r.is_correct).length
                const totalDims   = 6

                return (
                  <div key={m.id ?? m.slug} style={{
                    background: '#fff', borderRadius: 'var(--r-lg)',
                    boxShadow: 'var(--shadow-sm)',
                    borderLeft: `4px solid ${m.done ? '#43A047' : m.pct > 0 ? 'var(--cal-amber)' : 'var(--cal-border)'}`,
                    overflow: 'hidden',
                  }}>
                    <div
                      style={{ padding: '20px 24px', display: 'grid', gridTemplateColumns: '40px 1fr auto', gap: '0 16px', alignItems: 'center', cursor: 'pointer' }}
                      onClick={() => setExpandedModule(isExpanded ? null : (m.id ?? m.slug))}
                    >
                      <span style={{ fontSize: 28, lineHeight: 1 }}>{m.flag}</span>
                      <div>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 6 }}>
                          <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)' }}>
                            {m.label}
                          </div>
                          <div style={{
                            fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
                            color: m.done ? '#43A047' : m.pct > 0 ? 'var(--cal-amber-dark)' : 'var(--cal-muted)',
                            marginLeft: 12,
                          }}>
                            {m.done ? 'Complete' : `${m.pct}%`}
                          </div>
                        </div>
                        <div className="progress-track" style={{ marginBottom: 6 }}>
                          <div className={`progress-fill ${m.done ? 'green' : 'amber'}`} style={{ width: `${m.pct}%` }} />
                        </div>
                        <div style={{ fontSize: 11, color: 'var(--cal-muted)', display: 'flex', alignItems: 'center', gap: 12 }}>
                          <span>{m.lang}</span>
                          {m.due_date && (
                            <span>Due {new Date(m.due_date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })}</span>
                          )}
                          {hasActivity && (
                            <span style={{ color: 'var(--cal-teal)', fontWeight: 600 }}>
                              {cpKeys.length}/{totalDims} checkpoints - {isExpanded ? 'Hide detail' : 'Show detail'}
                            </span>
                          )}
                          {!hasActivity && (
                            <span style={{ color: 'var(--cal-muted)', opacity: 0.7 }}>Not started</span>
                          )}
                        </div>
                      </div>
                      <span className={`badge ${m.done ? 'badge-done' : m.pct > 0 ? 'badge-progress' : 'badge-assigned'}`}>
                        {m.done ? 'Done' : m.pct > 0 ? 'In progress' : 'Not started'}
                      </span>
                    </div>

                    {isExpanded && (
                      <div style={{ borderTop: '1px solid var(--cal-border)', padding: '16px 24px 20px', background: 'var(--cal-off)' }}>
                        <div style={{ marginBottom: feAnswered > 0 ? 16 : 0 }}>
                          <div style={{
                            fontSize: 10, fontWeight: 700, letterSpacing: '0.1em',
                            textTransform: 'uppercase', color: 'var(--cal-muted)',
                            fontFamily: 'var(--font-display)', marginBottom: 10,
                          }}>
                            Dimension checkpoints
                          </div>
                          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                            {Array.from({ length: totalDims }, (_, i) => i + 1).map(dimN => {
                              const resp = qData.checkpoints[dimN]
                              const state = !resp ? 'pending' : resp.is_correct ? 'correct' : 'incorrect'
                              return (
                                <div key={dimN} style={{
                                  display: 'flex', alignItems: 'center', gap: 5,
                                  background: state === 'correct' ? '#E8F5E9' : state === 'incorrect' ? '#FFEBEE' : '#fff',
                                  border: `1px solid ${state === 'correct' ? '#A5D6A7' : state === 'incorrect' ? '#FFCDD2' : 'var(--cal-border)'}`,
                                  borderRadius: 'var(--r-sm)', padding: '5px 10px',
                                  minWidth: 52,
                                }}>
                                  <span style={{
                                    fontSize: 12, fontWeight: 700,
                                    fontFamily: 'var(--font-display)',
                                    color: state === 'correct' ? '#2E7D32' : state === 'incorrect' ? '#B71C1C' : 'var(--cal-muted)',
                                  }}>
                                    D{dimN}
                                  </span>
                                  <span style={{ fontSize: 13 }}>
                                    {state === 'correct' ? 'Y' : state === 'incorrect' ? 'N' : 'o'}
                                  </span>
                                </div>
                              )
                            })}
                          </div>
                        </div>

                        {feAnswered > 0 && (
                          <div style={{ marginBottom: 16 }}>
                            <div style={{
                              fontSize: 10, fontWeight: 700, letterSpacing: '0.1em',
                              textTransform: 'uppercase', color: 'var(--cal-muted)',
                              fontFamily: 'var(--font-display)', marginBottom: 10,
                            }}>
                              Final exam
                            </div>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                              <div style={{ display: 'flex', gap: 5 }}>
                                {qData.finalExam.map((r, i) => (
                                  <span key={i} style={{
                                    width: 24, height: 24, borderRadius: '50%',
                                    background: r.is_correct ? '#43A047' : '#E53935',
                                    color: '#fff', fontSize: 11, fontWeight: 700,
                                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                                  }}>
                                    {r.is_correct ? 'Y' : 'N'}
                                  </span>
                                ))}
                              </div>
                              <span style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
                                {feCorrect} of {feAnswered} correct
                                {feAnswered >= 3 && feCorrect / feAnswered >= 0.67
                                  ? ' - Passed'
                                  : feAnswered >= 3
                                    ? ' - Not passed yet'
                                    : ''}
                              </span>
                            </div>
                          </div>
                        )}

                        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                          <button
                            className="btn"
                            onClick={e => { e.stopPropagation(); navigate(`/module/${m.module_slug}`) }}
                            style={{
                              background: m.done ? 'var(--cal-border)' : 'var(--cal-teal)',
                              color: m.done ? 'var(--cal-muted)' : '#fff',
                              padding: '8px 18px', fontSize: 12,
                            }}
                          >
                            {m.done ? 'Review module' : m.pct > 0 ? 'Continue' : 'Start module'}
                          </button>
                          {m.done && (
                            <button
                              className="btn"
                              onClick={e => { e.stopPropagation(); navigate(`/certificate/${m.module_slug}`) }}
                              style={{
                                background: '#43A047', color: '#fff',
                                padding: '8px 18px', fontSize: 12,
                              }}
                            >
                              Certificate
                            </button>
                          )}
                        </div>
                      </div>
                    )}
                  </div>
                )
              })}
            </div>

            {doneCount === modules.length && (
              <div style={{
                marginTop: 28, background: '#E8F5E9',
                borderRadius: 'var(--r-lg)', padding: '20px 24px',
                display: 'flex', alignItems: 'center', gap: 16,
              }}>
                <div>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 700, color: '#2E7D32', marginBottom: 4 }}>
                    All modules complete
                  </div>
                  <div style={{ fontSize: 13, color: '#388E3C', lineHeight: 1.6 }}>
                    Your school administrator has been notified. You're fully calibrated for parent season.
                  </div>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}

function RingChart({ pct }) {
  const r    = 42
  const circ = 2 * Math.PI * r
  const fill = (pct / 100) * circ

  return (
    <svg width={110} height={110} style={{ flexShrink: 0 }}>
      <circle cx={55} cy={55} r={r} fill="none" stroke="var(--cal-border-lt)" strokeWidth={9} />
      <circle
        cx={55} cy={55} r={r} fill="none"
        stroke={pct >= 80 ? '#43A047' : pct > 0 ? 'var(--cal-amber)' : 'var(--cal-border)'}
        strokeWidth={9}
        strokeLinecap="round"
        strokeDasharray={`${fill} ${circ - fill}`}
        strokeDashoffset={circ / 4}
        style={{ transition: 'stroke-dasharray 0.6s ease' }}
      />
      <text x={55} y={50} textAnchor="middle" fill="var(--cal-ink)"
        style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700 }}>
        {pct}%
      </text>
      <text x={55} y={66} textAnchor="middle" fill="var(--cal-muted)"
        style={{ fontFamily: 'var(--font-body)', fontSize: 9, fontWeight: 600 }}>
        complete
      </text>
    </svg>
  )
}
