import { useState, useEffect, useRef } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import TopBar from '../components/TopBar'
import SimulationPlayer from '../components/SimulationPlayer'
import { MODULE_META } from '../data/mockData'
import { getModule, getDimensions, getSimulations, getQuizQuestions, getCompletions, upsertCompletion, upsertQuizResponse } from '../lib/supabase'
import { useAuth } from '../context/AuthContext'
import WoodstockModuleView from './WoodstockModuleView'
import ErrorState from '../components/ErrorState'

const FETCH_TIMEOUT_MS = 8000

/* ── Research status badge ── */
const STATUS_LABEL = {
  fully_sourced: { label: 'Fully sourced', color: '#0B5563', bg: '#E6F2F4' },
  partial:       { label: 'Partially sourced', color: '#7B5EA7', bg: '#EDE7F6' },
  community:     { label: 'Community', color: '#B45309', bg: '#FEF3C7' },
}

/* ── Dimension step view (always expanded, no toggle) ── */
function DimensionStep({ dim }) {
  const content   = dim.content ?? {}
  const sections  = content.sections ?? []
  const citations = content.citations ?? []
  const status    = STATUS_LABEL[dim.research_status] ?? STATUS_LABEL.community

  return (
    <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid rgba(11,85,99,0.15)', overflow: 'hidden', marginBottom: 24 }}>
      {/* Dim header */}
      <div style={{ padding: '20px 24px 16px', borderBottom: '1px solid var(--cal-border)', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
          <div style={{
            width: 30, height: 30, borderRadius: '50%',
            background: 'var(--cal-teal)', color: '#fff',
            fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
            display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
          }}>{dim.dimension_number}</div>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 700, color: 'var(--cal-ink)' }}>
            {dim.title}
          </div>
        </div>
        <span style={{
          fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 600,
          letterSpacing: '0.05em', padding: '3px 8px', borderRadius: 4,
          color: status.color, background: status.bg, flexShrink: 0,
        }}>{status.label}</span>
      </div>

      {/* Body */}
      <div style={{ padding: '20px 24px 24px' }}>
        {content.summary && (
          <p style={{ fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.8, margin: '0 0 20px', fontStyle: 'italic', opacity: 0.85 }}>
            {content.summary}
          </p>
        )}
        {sections.map((sec, i) => (
          <div key={i} style={{ marginBottom: 20 }}>
            {sec.heading && (
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                letterSpacing: '0.1em', textTransform: 'uppercase',
                color: 'var(--cal-teal)', marginBottom: 10,
              }}>{sec.heading}</div>
            )}
            <ul style={{ margin: 0, padding: 0, listStyle: 'none' }}>
              {(sec.items ?? []).map((item, j) => (
                <li key={j} style={{
                  fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, marginBottom: 8,
                  paddingLeft: 14, position: 'relative',
                }}>
                  <span style={{
                    position: 'absolute', left: 0, top: 9,
                    width: 4, height: 4, borderRadius: '50%',
                    background: 'var(--cal-teal)', opacity: 0.6,
                  }} />
                  {item}
                </li>
              ))}
            </ul>
          </div>
        ))}
        {citations.length > 0 && (
          <div style={{ marginTop: 16, paddingTop: 14, borderTop: '1px dashed var(--cal-border)' }}>
            <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.1em', textTransform: 'uppercase', color: 'var(--cal-muted)', marginBottom: 8 }}>
              Sources
            </div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              {citations.map((c, i) => (
                <span key={i} style={{ fontSize: 11, color: 'var(--cal-muted)', background: 'var(--cal-off)', padding: '3px 8px', borderRadius: 4 }}>
                  {c.author} {c.year}{c.doi ? ' ↗' : ''}
                </span>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}


/* ── Quiz question component ── */
function QuizQuestion({ question, answer, onAnswer, dimTitle }) {
  const isAnswered = answer !== undefined

  return (
    <div style={{
      background: '#fff', borderRadius: 'var(--r-lg)',
      border: '1px solid var(--cal-border)', padding: '22px 24px',
      marginBottom: 16, boxShadow: 'var(--shadow-sm)',
    }}>
      {dimTitle && (
        <div style={{
          fontSize: 10, fontWeight: 700, letterSpacing: '0.1em',
          textTransform: 'uppercase', color: 'var(--cal-teal)', marginBottom: 10,
        }}>
          Dimension {question.dimension_number} · {dimTitle}
        </div>
      )}
      <p style={{
        fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.75,
        marginBottom: 18, fontWeight: 500,
      }}>
        {question.prompt}
      </p>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 9 }}>
        {question.options.map(opt => {
          let bg = 'var(--cal-off)'
          let border = '1px solid var(--cal-border)'
          let color = 'var(--cal-ink)'
          let dotBg = 'var(--cal-border)'
          let opacity = 1

          if (isAnswered) {
            if (opt.isCorrect) {
              bg = '#E8F5E9'; border = '1px solid #43A047'; color = '#1B5E20'; dotBg = '#43A047'
            } else if (opt.id === answer) {
              bg = '#FFEBEE'; border = '1px solid #E53935'; color = '#B71C1C'; dotBg = '#E53935'
            } else {
              opacity = 0.45
            }
          }

          return (
            <button
              key={opt.id}
              onClick={() => !isAnswered && onAnswer(question.id, opt.id)}
              style={{
                background: bg, border, color, opacity,
                borderRadius: 'var(--r-sm)', padding: '11px 14px',
                textAlign: 'left', cursor: isAnswered ? 'default' : 'pointer',
                fontSize: 13, lineHeight: 1.55,
                display: 'flex', alignItems: 'flex-start', gap: 10,
                transition: 'all 0.15s', width: '100%',
              }}
            >
              <span style={{
                width: 22, height: 22, borderRadius: '50%', flexShrink: 0,
                background: dotBg, color: '#fff',
                fontSize: 10, fontWeight: 700,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                marginTop: 1,
              }}>
                {opt.id.toUpperCase()}
              </span>
              <span>{opt.text}</span>
            </button>
          )
        })}
      </div>

      {isAnswered && (() => {
        const chosen = question.options.find(o => o.id === answer)
        if (!chosen?.feedback) return null
        return (
          <div style={{
            marginTop: 14, padding: '13px 16px',
            background: chosen.isCorrect ? '#F1F8E9' : '#FFF8E1',
            borderRadius: 'var(--r-sm)', borderLeft: `3px solid ${chosen.isCorrect ? '#43A047' : '#F59E0B'}`,
            fontSize: 12, lineHeight: 1.7,
            color: chosen.isCorrect ? '#33691E' : '#78350F',
          }}>
            <strong>{chosen.isCorrect ? '✓ Correct. ' : '✗ Not quite. '}</strong>
            {chosen.feedback}
            {chosen.research?.length > 0 && (
              <span style={{ opacity: 0.65 }}> ({chosen.research.join('; ')})</span>
            )}
          </div>
        )
      })()}
    </div>
  )
}

/* ── Score pill ── */
function ScorePill({ correct, total }) {
  const pct = total > 0 ? Math.round((correct / total) * 100) : 0
  const color = pct >= 67 ? '#43A047' : pct >= 34 ? '#F59E0B' : '#E53935'
  return (
    <span style={{
      fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
      color, background: `${color}18`, padding: '3px 10px', borderRadius: 999,
    }}>
      {correct}/{total}
    </span>
  )
}

/* ── Main page ── */
export default function ModuleView() {
  const { slug }     = useParams()
  const navigate     = useNavigate()
  const { user }     = useAuth()
  const meta         = MODULE_META[slug]

  if (slug === 'woodstock-transition') return <WoodstockModuleView />

  const [moduleData,  setModuleData]  = useState(null)
  const [dimensions,  setDimensions]  = useState([])
  const [simulations, setSimulations] = useState([])
  const [questions,   setQuestions]   = useState([])
  const [userPct,     setUserPct]     = useState(0)
  const [loading,     setLoading]     = useState(true)
  const [error,       setError]       = useState(null)
  const [retryCount,  setRetryCount]  = useState(0)
  const [activeTab,     setActiveTab]     = useState('dimensions')
  const [currentDim,    setCurrentDim]    = useState(0)
  const [preambleAcked, setPreambleAcked] = useState(false)

  // answers: { [questionId]: optionId }
  const [answers, setAnswers] = useState({})
  const prevPctRef = useRef(0)
  const contentRef = useRef(null)

  useEffect(() => {
    if (!meta?.dbId) return

    setLoading(true)
    setError(null)

    let active = true

    const timer = setTimeout(() => {
      if (active) {
        active = false
        setLoading(false)
        setError('timeout')
      }
    }, FETCH_TIMEOUT_MS)

    Promise.all([
      getModule(meta.dbId),
      getDimensions(meta.dbId),
      getSimulations(meta.dbId),
      getQuizQuestions(meta.dbId),
      user ? getCompletions(user.id) : Promise.resolve([]),
    ])
      .then(([mod, dims, sims, qs, completions]) => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setModuleData(mod)
        setDimensions(dims)
        setSimulations(sims)
        setQuestions(qs)
        const myCompletion = completions.find(c => c.module_slug === slug)
        const pct = myCompletion?.progress_pct ?? 0
        setUserPct(pct)
        prevPctRef.current = pct
        setLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        console.error('Failed to load module:', err)
        setError(err?.message || 'Could not load module content.')
        setLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [meta?.dbId, user?.id, retryCount])

  const preambleText = moduleData?.preamble_md?.trim() || meta?.preamble_md?.trim() || ''

  const checkpoints = questions.filter(q => q.quiz_type === 'checkpoint').sort((a, b) => a.sort_order - b.sort_order)
  const finalExam   = questions.filter(q => q.quiz_type === 'final_exam').sort((a, b) => a.sort_order - b.sort_order)

  const checkpointsAnswered = checkpoints.length > 0 && checkpoints.every(q => answers[q.id] !== undefined)
  const checkpointsCorrect  = checkpoints.filter(q => {
    const opt = q.options.find(o => o.id === answers[q.id])
    return opt?.isCorrect
  }).length

  const finalAnswered = finalExam.length > 0 && finalExam.every(q => answers[q.id] !== undefined)
  const finalCorrect  = finalExam.filter(q => {
    const opt = q.options.find(o => o.id === answers[q.id])
    return opt?.isCorrect
  }).length

  // Sync progress to Supabase when all checkpoints answered
  useEffect(() => {
    if (!user || !slug || finalAnswered) return
    if (checkpointsAnswered) {
      const newPct = 50
      if (newPct > prevPctRef.current) {
        prevPctRef.current = newPct
        setUserPct(newPct)
        upsertCompletion(user.id, slug, newPct).catch(console.error)
      }
    }
  }, [checkpointsAnswered])

  useEffect(() => {
    if (!user || !slug || !finalAnswered) return
    const newPct = finalCorrect >= Math.ceil(finalExam.length * 0.67) ? 100 : 80
    if (newPct > prevPctRef.current) {
      prevPctRef.current = newPct
      setUserPct(newPct)
      upsertCompletion(user.id, slug, newPct).catch(console.error)
    }
  }, [finalAnswered])

  function handleAnswer(questionId, optionId) {
    // Prevent re-answering after first selection
    setAnswers(prev => {
      if (prev[questionId] !== undefined) return prev
      return { ...prev, [questionId]: optionId }
    })

    // Persist to Supabase (fire-and-forget — never blocks the UI)
    if (user && meta?.dbId) {
      const question = questions.find(q => q.id === questionId)
      if (question) {
        const isCorrect = question.options.find(o => o.id === optionId)?.isCorrect ?? false
        upsertQuizResponse({
          userId:          user.id,
          moduleId:        meta.dbId,
          questionId,
          optionId,
          isCorrect,
          quizType:        question.quiz_type,
          dimensionNumber: question.dimension_number ?? null,
        }).catch(err => console.warn('Quiz response save failed (non-blocking):', err))
      }
    }
  }

  if (!meta) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100vh' }}>
        <TopBar />
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection: 'column', gap: 12, color: 'var(--cal-muted)' }}>
          <span style={{ fontSize: 40 }}>🔍</span>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 600, color: 'var(--cal-ink)' }}>Module not found</div>
          <button className="btn btn-ghost" onClick={() => navigate('/dashboard')}>← Back to dashboard</button>
        </div>
      </div>
    )
  }

  const TABS = [
    { key: 'dimensions',  label: 'Dimensions', count: dimensions.length },
    { key: 'simulations', label: 'Scenarios',  count: simulations.length },
    { key: 'final',       label: 'Final Test', count: finalExam.length },
  ]

  function goToNextDim() {
    if (currentDim < dimensions.length - 1) {
      setCurrentDim(d => d + 1)
      contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' })
    } else {
      setActiveTab('simulations')
      contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' })
    }
  }

  const progressLabel = userPct === 0
    ? '0% — not started'
    : userPct === 100
      ? '100% — complete'
      : `${userPct}% complete`

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
      <TopBar />

      <div ref={contentRef} className="module-content-wrap" style={{ flex: 1, overflowY: 'auto' }}>

        {/* Module hero */}
        <div style={{
          background: 'var(--cal-teal)', color: '#fff',
          padding: '40px 48px 36px', position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', right: -80, top: -80, width: 320, height: 320, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.08)' }} />
          <div style={{ position: 'absolute', right: 40,  top: 40,  width: 180, height: 180, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.1)' }} />

          <button
            onClick={() => navigate('/dashboard')}
            style={{ background: 'transparent', border: 'none', color: 'rgba(255,255,255,0.55)', fontSize: 13, cursor: 'pointer', marginBottom: 20, padding: 0, fontFamily: 'var(--font-body)' }}
          >
            ← Back to modules
          </button>

          <div style={{ display: 'flex', alignItems: 'center', gap: 20, marginBottom: 16, position: 'relative', zIndex: 1 }}>
            <span style={{ fontSize: 52 }}>{meta.flag}</span>
            <div>
              <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 600, letterSpacing: '0.16em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.5)', marginBottom: 6 }}>
                IB Teacher Guide · {meta.lang}
              </div>
              <h1 style={{ fontFamily: 'var(--font-display)', fontSize: 32, fontWeight: 800, letterSpacing: '-0.02em', marginBottom: 8 }}>
                {meta.label}
              </h1>
              <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.7)', maxWidth: 520, lineHeight: 1.7 }}>
                {moduleData?.tagline ?? meta.desc}
              </p>
            </div>
          </div>

          <div style={{ position: 'relative', zIndex: 1, marginTop: 24 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: 'rgba(255,255,255,0.5)', marginBottom: 8 }}>
              <span>Your progress</span>
              <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
                <span>{progressLabel}</span>
                {userPct === 100 && (
                  <button
                    onClick={() => navigate(`/certificate/${slug}`)}
                    style={{
                      background: 'rgba(255,255,255,0.15)', border: '1px solid rgba(255,255,255,0.3)',
                      borderRadius: 'var(--r-full)', padding: '3px 12px',
                      color: '#fff', fontSize: 11, fontFamily: 'var(--font-display)', fontWeight: 600,
                      cursor: 'pointer', letterSpacing: '0.04em',
                    }}
                  >
                    🎓 Certificate
                  </button>
                )}
              </div>
            </div>
            <div style={{ height: 5, background: 'rgba(255,255,255,0.15)', borderRadius: 999 }}>
              <div style={{ height: '100%', width: `${userPct}%`, background: userPct === 100 ? '#69F0AE' : 'var(--cal-amber)', borderRadius: 999, transition: 'width 0.6s ease' }} />
            </div>
          </div>
        </div>

        {/* ── Preamble gate ── */}
        {!loading && !error && preambleText && !preambleAcked && (
          <div style={{ display: 'flex', justifyContent: 'center', padding: '64px 48px' }}>
            <div style={{ maxWidth: 580, width: '100%' }}>
              <div style={{
                fontSize: 10, fontWeight: 700, letterSpacing: '0.1em',
                textTransform: 'uppercase', color: 'var(--cal-teal)', marginBottom: 16,
                fontFamily: 'var(--font-display)',
              }}>
                Before you begin
              </div>
              <p style={{ fontSize: 15, lineHeight: 1.85, color: 'var(--cal-ink)', margin: '0 0 36px' }}>
                {preambleText}
              </p>
              <button
                className="btn"
                onClick={() => { setPreambleAcked(true); contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' }) }}
                style={{ background: 'var(--cal-teal)', color: '#fff', padding: '12px 28px', fontSize: 14 }}
              >
                Begin module →
              </button>
            </div>
          </div>
        )}

        {/* Tab bar — hidden until preamble is acknowledged */}
        {(preambleAcked || !preambleText) && <div style={{ background: '#fff', borderBottom: '1px solid var(--cal-border)', padding: '0 48px', display: 'flex', gap: 0 }}>
          {TABS.map(tab => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              style={{
                padding: '14px 20px', border: 'none', cursor: 'pointer',
                borderBottom: activeTab === tab.key ? '2px solid var(--cal-teal)' : '2px solid transparent',
                background: 'transparent',
                fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: activeTab === tab.key ? 600 : 400,
                color: activeTab === tab.key ? 'var(--cal-teal)' : 'var(--cal-muted)',
                display: 'flex', alignItems: 'center', gap: 7,
                transition: 'all 0.15s',
              }}
            >
              {tab.label}
              {tab.count > 0 && (
                <span style={{
                  fontSize: 10, fontWeight: 700, fontFamily: 'var(--font-display)',
                  background: activeTab === tab.key ? 'var(--cal-teal)' : '#F0F4F8',
                  color: activeTab === tab.key ? '#fff' : 'var(--cal-muted)',
                  borderRadius: 999, padding: '1px 6px', transition: 'all 0.15s',
                }}>
                  {tab.count}
                </span>
              )}
            </button>
          ))}
        </div>}

        {/* Content area — hidden until preamble is acknowledged */}
        {(preambleAcked || !preambleText) && <div style={{ padding: '36px 48px', maxWidth: 900, margin: '0 auto' }}>

          {loading && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, color: 'var(--cal-muted)', padding: '40px 0' }}>
              <div style={{ width: 16, height: 16, border: '2px solid var(--cal-border)', borderTopColor: 'var(--cal-teal)', borderRadius: '50%', animation: 'spin 0.8s linear infinite' }} />
              <span style={{ fontSize: 13 }}>Loading content…</span>
              <style>{`@keyframes spin { to { transform: rotate(360deg) } }`}</style>
            </div>
          )}

          {error && (
            <ErrorState
              error={error}
              context="module content"
              onRetry={() => setRetryCount(c => c + 1)}
            />
          )}

          {/* ── DIMENSIONS TAB (step view) ── */}
          {!loading && !error && activeTab === 'dimensions' && (() => {
            const dim = dimensions[currentDim]
            if (!dim) return <div style={{ color: 'var(--cal-muted)', fontSize: 13 }}>No dimensions found.</div>
            const checkpoint = checkpoints.find(q => q.dimension_number === dim.dimension_number)
            const answered   = checkpoint && answers[checkpoint.id] !== undefined
            const isLast     = currentDim === dimensions.length - 1

            return (
              <>
                {/* Step nav bar */}
                <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 24 }}>
                  <button
                    onClick={() => { setCurrentDim(d => Math.max(0, d - 1)); contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' }) }}
                    disabled={currentDim === 0}
                    style={{
                      background: 'none', border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                      padding: '6px 12px', fontSize: 12, cursor: currentDim === 0 ? 'default' : 'pointer',
                      color: currentDim === 0 ? 'var(--cal-border)' : 'var(--cal-ink)', fontFamily: 'var(--font-display)',
                    }}
                  >← Back</button>

                  {/* Step dots */}
                  <div style={{ flex: 1, display: 'flex', alignItems: 'center', gap: 6, justifyContent: 'center' }}>
                    {dimensions.map((d, i) => {
                      const q   = checkpoints.find(q => q.dimension_number === d.dimension_number)
                      const done = q && answers[q.id] !== undefined
                      return (
                        <button
                          key={d.id}
                          onClick={() => { setCurrentDim(i); contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' }) }}
                          title={`D${d.dimension_number}: ${d.title}`}
                          style={{
                            width: i === currentDim ? 24 : 8,
                            height: 8, borderRadius: 999, border: 'none', cursor: 'pointer', padding: 0,
                            background: i === currentDim ? 'var(--cal-teal)' : done ? '#A5D6A7' : 'var(--cal-border)',
                            transition: 'all 0.2s',
                          }}
                        />
                      )
                    })}
                  </div>

                  <span style={{ fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', fontWeight: 600, flexShrink: 0 }}>
                    {currentDim + 1} / {dimensions.length}
                  </span>
                </div>

                {/* Dimension content */}
                <DimensionStep dim={dim} />

                {/* Checkpoint quiz */}
                {checkpoint && (
                  <div style={{ marginBottom: 24 }}>
                    <div style={{
                      fontSize: 10, fontWeight: 700, letterSpacing: '0.12em', textTransform: 'uppercase',
                      color: 'var(--cal-muted)', marginBottom: 12, paddingLeft: 2,
                    }}>
                      Quick check
                    </div>
                    <QuizQuestion
                      question={checkpoint}
                      answer={answers[checkpoint.id]}
                      onAnswer={handleAnswer}
                      dimTitle={null}
                    />
                  </div>
                )}

                {/* Next / Continue button */}
                <div style={{ display: 'flex', justifyContent: 'flex-end', paddingBottom: 8 }}>
                  {!checkpoint || answered ? (
                    <button
                      className="btn"
                      onClick={goToNextDim}
                      style={{ background: 'var(--cal-teal)', color: '#fff', padding: '10px 22px', fontSize: 13 }}
                    >
                      {isLast ? 'Continue to Scenarios →' : `Next: D${dimensions[currentDim + 1]?.dimension_number} →`}
                    </button>
                  ) : (
                    <span style={{ fontSize: 12, color: 'var(--cal-muted)', alignSelf: 'center' }}>
                      Answer the question above to continue
                    </span>
                  )}
                </div>
              </>
            )
          })()}

          {/* ── SIMULATIONS TAB ── */}
          {!loading && !error && activeTab === 'simulations' && (
            <>
              {simulations.length === 0 ? (
                <div style={{ background: 'var(--cal-off)', borderRadius: 'var(--r-lg)', padding: '32px', textAlign: 'center', color: 'var(--cal-muted)', fontSize: 13 }}>
                  <div style={{ fontSize: 32, marginBottom: 12 }}>🎭</div>
                  <div style={{ fontFamily: 'var(--font-display)', fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 6 }}>No simulations yet</div>
                  Simulation content for this module is being written.
                </div>
              ) : (
                <>
                  <p style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.6, marginBottom: 24 }}>
                    Each simulation puts you inside a real parent–teacher friction point. Make choices, see consequences, and read the research behind each dynamic.
                  </p>
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 32 }}>
                    {simulations.map(sim => (
                      <SimulationPlayer key={sim.id} sim={sim} />
                    ))}
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: 24, paddingBottom: 8 }}>
                    <button
                      className="btn"
                      onClick={() => { setActiveTab('final'); contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' }) }}
                      style={{ background: 'var(--cal-teal)', color: '#fff', padding: '10px 22px', fontSize: 13 }}
                    >
                      Continue to Final Test →
                    </button>
                  </div>
                </>
              )}
            </>
          )}


          {/* ── FINAL TEST TAB ── */}
          {!loading && !error && activeTab === 'final' && (
            <>
              {/* Header */}
              <div style={{ marginBottom: 28 }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
                  <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 17, fontWeight: 700, color: 'var(--cal-ink)' }}>
                    Final Test
                  </h2>
                  {finalAnswered && (
                    <ScorePill correct={finalCorrect} total={finalExam.length} />
                  )}
                </div>
                <p style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                  Six cross-dimensional questions. Each draws on the research from multiple dimensions — read carefully.
                  {!checkpointsAnswered && (
                    <span style={{ color: 'var(--cal-amber)', fontWeight: 600 }}>
                      {' '}Tip: complete the Checkpoints first to review the core ideas.
                    </span>
                  )}
                </p>
              </div>

              {finalExam.length === 0 ? (
                <div style={{ color: 'var(--cal-muted)', fontSize: 13, padding: '20px 0' }}>Final test questions coming soon.</div>
              ) : (
                finalExam.map((q, i) => (
                  <QuizQuestion
                    key={q.id}
                    question={{ ...q, dimension_number: null }}
                    answer={answers[q.id]}
                    onAnswer={handleAnswer}
                    dimTitle={null}
                  />
                ))
              )}

              {finalAnswered && (() => {
                const passed = finalCorrect >= Math.ceil(finalExam.length * 0.67)
                const pct    = finalExam.length > 0 ? Math.round((finalCorrect / finalExam.length) * 100) : 0
                return (
                  <div style={{
                    background: passed ? '#E8F5E9' : '#FFF8E1',
                    border: `1px solid ${passed ? '#A5D6A7' : '#FDD835'}`,
                    borderRadius: 'var(--r-lg)', padding: '32px 28px', marginTop: 8,
                  }}>
                    {/* Score display */}
                    <div style={{ textAlign: 'center', marginBottom: 24 }}>
                      <div style={{ fontFamily: 'var(--font-display)', fontSize: 56, fontWeight: 800, lineHeight: 1, color: passed ? '#2E7D32' : '#F59E0B' }}>
                        {finalCorrect}/{finalExam.length}
                      </div>
                      <div style={{ fontSize: 14, color: 'var(--cal-muted)', marginTop: 6 }}>{pct}%</div>
                      <div style={{
                        display: 'inline-block', marginTop: 12,
                        fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700,
                        color: passed ? '#1B5E20' : '#78350F',
                        background: passed ? '#C8E6C9' : '#FDE68A',
                        padding: '5px 14px', borderRadius: 999,
                      }}>
                        {passed ? '🎓 Module complete' : '📖 Keep reviewing'}
                      </div>
                    </div>

                    {/* Per-question breakdown */}
                    <div style={{ borderTop: '1px solid rgba(0,0,0,0.07)', paddingTop: 20, marginBottom: 24 }}>
                      <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.1em', textTransform: 'uppercase', color: 'var(--cal-muted)', marginBottom: 12, fontFamily: 'var(--font-display)' }}>
                        Question breakdown
                      </div>
                      {finalExam.map((q, i) => {
                        const correct = q.options.find(o => o.id === answers[q.id])?.isCorrect ?? false
                        const prompt  = q.prompt.length > 80 ? q.prompt.slice(0, 80) + '…' : q.prompt
                        return (
                          <div key={q.id} style={{
                            display: 'flex', alignItems: 'flex-start', gap: 10,
                            padding: '8px 0', borderBottom: i < finalExam.length - 1 ? '1px solid rgba(0,0,0,0.05)' : 'none',
                          }}>
                            <span style={{ fontSize: 14, flexShrink: 0, color: correct ? '#43A047' : '#E53935', marginTop: 1 }}>
                              {correct ? '✓' : '✗'}
                            </span>
                            <span style={{ fontSize: 11, fontWeight: 700, color: 'var(--cal-muted)', flexShrink: 0, marginTop: 2 }}>Q{i + 1}</span>
                            <span style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.5 }}>{prompt}</span>
                          </div>
                        )
                      })}
                    </div>

                    {/* CTA */}
                    <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                      {passed ? (
                        <>
                          <button
                            className="btn"
                            onClick={() => navigate(`/certificate/${slug}`)}
                            style={{ background: 'var(--cal-teal)', color: '#fff', padding: '9px 20px', fontSize: 13 }}
                          >
                            🎓 Download Certificate
                          </button>
                          <button className="btn btn-ghost" onClick={() => navigate('/dashboard')} style={{ fontSize: 12 }}>
                            ← Back to modules
                          </button>
                        </>
                      ) : (
                        <button className="btn btn-ghost" onClick={() => setActiveTab('dimensions')} style={{ fontSize: 12 }}>
                          ← Review Dimensions
                        </button>
                      )}
                    </div>
                  </div>
                )
              })()}
            </>
          )}

        </div>}
      </div>
    </div>
  )
}
