/*
 * ─────────────────────────────────────────────────────────────────────────────
 * WoodstockModuleView
 *
 * Production content is loaded from Supabase pd_modules / pd_dimensions.
 * The legacy vocab file is dynamically imported only in MOCK_MODE so local
 * development still works without a Supabase connection.
 * ─────────────────────────────────────────────────────────────────────────────
 */
import { useState, useEffect, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import TopBar from '../components/TopBar'
import ErrorState from '../components/ErrorState'
import { useAuth } from '../context/AuthContext'
import { getDimensions, getModule, getQuizQuestions, upsertCompletion } from '../lib/supabase'
import { woodstockParentTransition as WOODSTOCK_VOCAB_FALLBACK } from '../vocab/woodstock-parent-transition'

const MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL
const FETCH_TIMEOUT_MS = 8000
const WOODSTOCK_DB_ID = 'woodstock-001'

// The bundled vocab is always used as the structural base. Supabase content
// (when present) is merged on top via mergeDeep — so Supabase only needs to
// supply the fields it actually overrides. Anything not present in Supabase
// (e.g. igcseDeepDive / apDeepDive / ibProgramme structural trees) falls
// through to the bundled vocab, preventing runtime crashes when chapter
// components destructure from undefined.
// The bundled vocab is always used as the structural base — every chapter
// renderer (ChapterScenarios, ChapterIGCSE, ChapterIB, etc.) destructures deep
// trees and crashes silently when the field is missing. So instead of starting
// from empty scaffolding that Supabase has to fully overwrite, we start from
// the bundled vocab and let Supabase overrides merge in on top. Supabase only
// needs to carry the fields it wants to change.
const WOODSTOCK_BASE_DATA = {
  ...(WOODSTOCK_VOCAB_FALLBACK ?? {}),
  meta: {
    title: 'The Woodstock Curriculum Transition',
    subtitle: '',
    intro: '',
    ...(WOODSTOCK_VOCAB_FALLBACK?.meta ?? {}),
  },
  feedbackCta: WOODSTOCK_VOCAB_FALLBACK?.feedbackCta ?? {
    text: 'Questions or feedback?',
    email: 'academics@woodstock.ac.in',
    cta: 'Email Woodstock',
  },
}

/* ── Woodstock brand colours ── */
const WS  = '#5B3A8C'   // IB purple / primary
const GN  = '#1D9E75'   // IGCSE green / reassurance
const OG  = '#C45C26'   // AP orange / watch-out

/* ── Grade helpers ── */
const GRADE_TO_COHORT = {
  6: 'grade-6-7', 7: 'grade-6-7',
  8: 'grade-8',
  9: 'grade-9',
  10: 'grade-10',
  11: 'grade-11-12', 12: 'grade-11-12',
}
const isNewPathway = g => g <= 8

/* ── Chapter manifests ── */
const CHAPTERS_NEW = [
  { id: 'pathway',      icon: '🗺️',  label: 'Your Pathway' },
  { id: 'overview',     icon: '📚',  label: "What's Changing" },
  { id: 'igcse',        icon: '📐',  label: 'IGCSE' },
  { id: 'ap',           icon: '🎯',  label: 'AP & WSD' },
  { id: 'universities', icon: '🌍',  label: 'Universities' },
  { id: 'students',     icon: '🏆',  label: 'Student Life' },
  { id: 'scenarios',    icon: '🎭',  label: 'Conversations' },
  { id: 'knowledgecheck', icon: '🧠', label: 'Knowledge Check' },
  { id: 'nextsteps',    icon: '❓',  label: 'Next Steps' },
]
const CHAPTERS_IB = [
  { id: 'pathway',      icon: '🗺️',  label: 'Your Pathway' },
  { id: 'ib',           icon: '📖',  label: 'The IB Programme' },
  { id: 'universities', icon: '🌍',  label: 'Universities' },
  { id: 'scenarios',    icon: '🎭',  label: 'Conversations' },
  { id: 'knowledgecheck', icon: '🧠', label: 'Knowledge Check' },
  { id: 'nextsteps',    icon: '❓',  label: 'Next Steps' },
]

function getNextSteps(data, grade) {
  const all = data.nextSteps
  if (grade <= 7)  return [0, 1, 4, 6].map(i => all[i])
  if (grade === 8) return [0, 1, 2, 3, 4, 6].map(i => all[i])
  if (grade === 9) return [0, 5, 6, 7, 8].map(i => all[i])
  if (grade === 10) return [0, 5, 6, 9].map(i => all[i])
  return [0, 5, 6, 10].map(i => all[i])
}

function isPlainObject(value) {
  return value && typeof value === 'object' && !Array.isArray(value)
}

function mergeArraysById(base = [], override = []) {
  if (!override.length) return base
  if (!base.every(item => item?.id) || !override.every(item => item?.id)) return override

  const byId = new Map(base.map(item => [item.id, item]))
  override.forEach(item => {
    byId.set(item.id, mergeDeep(byId.get(item.id) ?? {}, item))
  })
  return Array.from(byId.values())
}

function mergeDeep(base, override) {
  if (override === undefined || override === null) return base
  if (Array.isArray(base) && Array.isArray(override)) return mergeArraysById(base, override)
  if (isPlainObject(base) && isPlainObject(override)) {
    const next = { ...base }
    Object.entries(override).forEach(([key, value]) => {
      next[key] = mergeDeep(base[key], value)
    })
    return next
  }
  return override
}

function normalizeCards(cards = []) {
  return cards.map(card => {
    if (card.en) return card
    return {
      id: card.id,
      label: card.label,
      en: {
        concept: card.concept,
        concern: card.concern,
        bridge: card.bridge,
        goal: card.goal,
        whatToAsk: card.whatToAsk ?? [],
      },
    }
  })
}

function buildWoodstockDataFromSupabase(moduleData, dimensions, questions) {
  const byDim = {}
  dimensions.forEach(dim => { byDim[dim.dimension_number] = dim.content ?? {} })

  return mergeDeep(WOODSTOCK_BASE_DATA, {
    meta: {
      ...(byDim[1]?.meta ?? {}),
      title: byDim[1]?.meta?.title ?? moduleData?.title,
      subtitle: byDim[1]?.meta?.subtitle ?? moduleData?.tagline,
    },
    directorNote: byDim[1]?.directorNote,
    openingHook: byDim[1]?.openingHook,
    feedbackCta: byDim[1]?.feedbackCta,
    cohortGuide: byDim[2]?.cohortGuide,
    cards: normalizeCards(byDim[3]?.cards ?? []),
    universityGuide: byDim[4]?.universityGuide,
    ibUniversityGuide: byDim[4]?.ibUniversityGuide,
    studentTransition: byDim[5]?.studentTransition,
    scenarios: byDim[6]?.scenarios,
    nextSteps: byDim[6]?.nextSteps,
    dimensions,
    quizQuestions: questions,
  })
}

/* ─────────────────────────────────────────
   Shared micro-components
───────────────────────────────────────── */

function SectionLabel({ children, color = WS }) {
  return (
    <div style={{
      fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700,
      letterSpacing: '0.12em', textTransform: 'uppercase', color, marginBottom: 10,
    }}>
      {children}
    </div>
  )
}

function Callout({ children, color = GN, bg }) {
  return (
    <div style={{
      background: bg ?? color + '14',
      border: `1px solid ${color}33`,
      borderLeft: `3px solid ${color}`,
      borderRadius: 8, padding: '14px 18px',
      fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75,
      marginBottom: 20,
    }}>
      {children}
    </div>
  )
}

function Tag({ children, color = WS }) {
  return (
    <span style={{
      display: 'inline-block',
      fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)',
      color, background: color + '18',
      borderRadius: 4, padding: '2px 8px', marginRight: 6, marginBottom: 6,
    }}>
      {children}
    </span>
  )
}

function CompleteButton({ chapterId, completed, onToggle }) {
  const done = completed.includes(chapterId)
  return (
    <div style={{ textAlign: 'center', padding: '32px 0 8px' }}>
      <button
        onClick={() => onToggle(chapterId)}
        style={{
          background: done ? GN : '#fff',
          color: done ? '#fff' : GN,
          border: `2px solid ${GN}`,
          borderRadius: 8, padding: '10px 28px',
          fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
          cursor: 'pointer', transition: 'all 0.15s',
        }}
      >
        {done ? '✓ Marked complete' : 'Mark this section complete'}
      </button>
    </div>
  )
}

/* ─────────────────────────────────────────
   GradeIntake modal
───────────────────────────────────────── */

function GradeIntake({ onSelect }) {
  const [hover, setHover] = useState(null)
  return (
    <div style={{
      position: 'fixed', inset: 0, zIndex: 200,
      background: 'rgba(0,0,0,0.55)', backdropFilter: 'blur(4px)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: 24,
    }}>
      <div style={{
        background: '#fff', borderRadius: 16, maxWidth: 520, width: '100%',
        padding: '40px 36px', boxShadow: '0 24px 80px rgba(0,0,0,0.18)',
      }}>
        <div style={{
          fontSize: 36, marginBottom: 16, textAlign: 'center',
        }}>🏔️</div>
        <h2 style={{
          fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 800,
          color: WS, textAlign: 'center', marginBottom: 8, letterSpacing: '-0.02em',
        }}>
          Which grade is your child in?
        </h2>
        <p style={{
          fontSize: 13, color: 'var(--cal-muted)', textAlign: 'center',
          lineHeight: 1.6, marginBottom: 28,
        }}>
          Your experience is tailored to your child's cohort. Different grades have different pathways.
        </p>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10, marginBottom: 8 }}>
          {[6, 7, 8, 9, 10, 11, 12].map(g => (
            <button
              key={g}
              onMouseEnter={() => setHover(g)}
              onMouseLeave={() => setHover(null)}
              onClick={() => onSelect(g)}
              style={{
                background: hover === g ? WS : '#F5F0FA',
                color: hover === g ? '#fff' : WS,
                border: `2px solid ${hover === g ? WS : WS + '33'}`,
                borderRadius: 10, padding: '14px 0',
                fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
                cursor: 'pointer', transition: 'all 0.15s',
                gridColumn: g === 12 ? 'span 1' : undefined,
              }}
            >
              {g}
            </button>
          ))}
          {/* padding cell to align 7 items in a 4-col grid */}
          <div />
        </div>
        <p style={{ fontSize: 11, color: 'var(--cal-muted)', textAlign: 'center', marginTop: 12 }}>
          You can change this at any time.
        </p>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────
   ChapterNavStrip
───────────────────────────────────────── */

function ChapterNavStrip({ chapters, active, completed, onSelect, grade, onGradeChange }) {
  const stripRef   = useRef(null)
  const [open, setOpen] = useState(false)

  useEffect(() => {
    const el = stripRef.current?.querySelector(`[data-id="${active}"]`)
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' })
  }, [active])

  // Close dropdown when clicking outside
  useEffect(() => {
    if (!open) return
    const handler = (e) => {
      if (!e.target.closest('[data-grade-picker]')) setOpen(false)
    }
    document.addEventListener('mousedown', handler)
    return () => document.removeEventListener('mousedown', handler)
  }, [open])

  return (
    <div style={{
      background: '#fff', borderBottom: '1px solid var(--cal-border)',
      display: 'flex', alignItems: 'stretch',
      position: 'sticky', top: 0, zIndex: 50,
    }} ref={stripRef}>

      {/* Scrollable chapter tabs */}
      <div style={{
        flex: 1, overflowX: 'auto', display: 'flex', padding: '0 16px 0 32px',
        scrollbarWidth: 'none',
      }}>
        <style>{`[data-tab-scroll]::-webkit-scrollbar { display: none }`}</style>
        {chapters.map(ch => {
          const isActive = ch.id === active
          const isDone   = completed.includes(ch.id)
          return (
            <button
              key={ch.id}
              data-id={ch.id}
              onClick={() => onSelect(ch.id)}
              style={{
                flexShrink: 0,
                background: 'none', border: 'none', cursor: 'pointer',
                padding: '12px 16px',
                borderBottom: isActive ? `2px solid ${WS}` : '2px solid transparent',
                display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
                transition: 'all 0.15s',
              }}
            >
              <span style={{ fontSize: 18 }}>{ch.icon}</span>
              <span style={{
                fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: isActive ? 700 : 500,
                color: isActive ? WS : 'var(--cal-muted)',
                whiteSpace: 'nowrap',
              }}>
                {ch.label}
              </span>
              {isDone && (
                <span style={{ width: 6, height: 6, borderRadius: '50%', background: GN }} />
              )}
            </button>
          )
        })}
      </div>

      {/* Grade switcher — always visible on the right */}
      <div data-grade-picker style={{
        position: 'relative', flexShrink: 0,
        borderLeft: '1px solid var(--cal-border)',
        display: 'flex', alignItems: 'center', padding: '0 16px',
      }}>
        <button
          onClick={() => setOpen(o => !o)}
          title="Switch student grade"
          style={{
            background: open ? WS : WS + '12',
            color: open ? '#fff' : WS,
            border: `1.5px solid ${WS}44`,
            borderRadius: 8, padding: '6px 12px',
            fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 700,
            cursor: 'pointer', transition: 'all 0.15s',
            display: 'flex', alignItems: 'center', gap: 6,
            whiteSpace: 'nowrap',
          }}
        >
          <span style={{ fontSize: 14 }}>🎓</span>
          Grade {grade}
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none"
            style={{ transform: open ? 'rotate(180deg)' : 'none', transition: 'transform 0.15s', opacity: 0.7 }}>
            <path d="M2 3.5l3 3 3-3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>

        {open && (
          <div data-grade-picker style={{
            position: 'absolute', top: 'calc(100% + 6px)', right: 0,
            background: '#fff', borderRadius: 10,
            boxShadow: '0 8px 32px rgba(0,0,0,0.14)',
            border: '1px solid var(--cal-border)',
            padding: 10, zIndex: 200, minWidth: 180,
          }}>
            <div style={{
              fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700,
              letterSpacing: '0.1em', textTransform: 'uppercase',
              color: 'var(--cal-muted)', padding: '2px 4px 8px',
            }}>
              Switch student
            </div>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 6 }}>
              {[6, 7, 8, 9, 10, 11, 12].map(g => (
                <button
                  key={g}
                  data-grade-picker
                  onClick={() => { onGradeChange(g); setOpen(false) }}
                  style={{
                    background: g === grade ? WS : 'var(--cal-off)',
                    color: g === grade ? '#fff' : 'var(--cal-ink)',
                    border: `1.5px solid ${g === grade ? WS : 'transparent'}`,
                    borderRadius: 7, padding: '8px 4px',
                    fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
                    cursor: g === grade ? 'default' : 'pointer',
                    transition: 'all 0.12s',
                    gridColumn: g === 12 ? 'span 1' : undefined,
                  }}
                >
                  {g}
                </button>
              ))}
              {/* spacer to fill 4th column on last row */}
              <div />
            </div>
            <div style={{
              fontSize: 10, color: 'var(--cal-muted)', padding: '8px 4px 2px',
              lineHeight: 1.5,
            }}>
              Progress is saved per grade.
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Pathway
───────────────────────────────────────── */

function ChapterPathway({ grade, completed, onToggle, data }) {
  const DATA = data
  const cohortId = GRADE_TO_COHORT[grade]
  const cohort   = DATA.cohortGuide.cohorts.find(c => c.id === cohortId)
  if (!cohort) return null

  // Grade-specific extra note
  const extraNote =
    grade >= 11  ? cohort.wsdNote :
    grade === 10 ? cohort.wsdNote :
    grade === 9  ? cohort.grade10Note :
    grade === 8  ? cohort.bridgeNote :
    cohort.currentYear

  return (
    <div>
      <div style={{
        background: WS, color: '#fff', borderRadius: 12,
        padding: '24px 28px', marginBottom: 24,
      }}>
        <SectionLabel color="rgba(255,255,255,0.55)">Your child's cohort</SectionLabel>
        <div style={{ fontSize: 22, fontFamily: 'var(--font-display)', fontWeight: 800, marginBottom: 6 }}>
          {cohort.label}
        </div>
        <div style={{ fontSize: 14, opacity: 0.85, fontStyle: 'italic', marginBottom: 16 }}>
          {cohort.path}
        </div>
        <p style={{ fontSize: 13, lineHeight: 1.75, opacity: 0.9 }}>{cohort.detail}</p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: 24 }}>
        <div style={{ background: 'var(--cal-off)', borderRadius: 10, padding: '18px 20px' }}>
          <SectionLabel color={WS}>Timeline</SectionLabel>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
            {cohort.timeline}
          </p>
        </div>
        <div style={{ background: GN + '12', borderRadius: 10, padding: '18px 20px', border: `1px solid ${GN}33` }}>
          <SectionLabel color={GN}>What to do now</SectionLabel>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
            {cohort.action}
          </p>
        </div>
      </div>

      {extraNote && (
        <div style={{
          background: '#fff', border: '1px solid var(--cal-border)',
          borderRadius: 12, padding: '22px 24px', marginBottom: 24,
          boxShadow: 'var(--shadow-sm)',
        }}>
          <SectionLabel color={OG}>{extraNote.heading}</SectionLabel>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, margin: 0 }}>
            {extraNote.body}
          </p>
          {extraNote.subjectNote && (
            <Callout color={OG} bg={OG + '0D'}>
              <strong>Subject choice:</strong> {extraNote.subjectNote}
            </Callout>
          )}
          {extraNote.whatToWatch && (
            <div style={{ marginTop: 16, paddingTop: 16, borderTop: '1px dashed var(--cal-border)' }}>
              <SectionLabel color={GN}>What to watch for now</SectionLabel>
              <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, margin: 0 }}>
                {extraNote.whatToWatch}
              </p>
            </div>
          )}
        </div>
      )}

      {/* Director note */}
      <blockquote style={{
        background: WS + '0A', border: `1px solid ${WS}22`,
        borderLeft: `4px solid ${WS}`,
        borderRadius: '0 8px 8px 0', padding: '18px 22px', margin: '0 0 24px',
        fontStyle: 'italic', fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8,
      }}>
        "{DATA.directorNote.quote}"
        <div style={{
          fontStyle: 'normal', fontSize: 11, fontWeight: 600, color: WS,
          marginTop: 10, fontFamily: 'var(--font-display)', letterSpacing: '0.05em',
        }}>
          — {DATA.directorNote.attribution}
        </div>
      </blockquote>

      <Callout color={GN}>
        <strong>Protection principle:</strong> {DATA.cohortGuide.protectionCallout}
      </Callout>

      <CompleteButton chapterId="pathway" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Overview (What's Changing)
───────────────────────────────────────── */

function ChapterOverview({ completed, onToggle, data }) {
  const DATA = data
  const [open, setOpen] = useState(null)
  return (
    <div>
      <p style={{
        fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.8,
        marginBottom: 24, fontStyle: 'italic', opacity: 0.8,
      }}>
        {DATA.openingHook.question}
      </p>
      <Callout color={GN}>
        <strong>Short answer:</strong> {DATA.openingHook.directAnswer}
      </Callout>

      <SectionLabel color={WS}>The six things to understand</SectionLabel>

      {DATA.cards.map((card, i) => {
        const isOpen = open === card.id
        return (
          <div key={card.id} style={{
            background: '#fff', borderRadius: 12,
            border: isOpen ? `1px solid ${WS}55` : '1px solid var(--cal-border)',
            marginBottom: 12, overflow: 'hidden', boxShadow: 'var(--shadow-sm)',
          }}>
            <button
              onClick={() => setOpen(isOpen ? null : card.id)}
              style={{
                width: '100%', background: 'none', border: 'none', cursor: 'pointer',
                padding: '16px 20px', textAlign: 'left',
                display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
              }}
            >
              <div>
                <div style={{
                  fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
                  color: 'var(--cal-ink)', marginBottom: 3,
                }}>
                  {card.label}
                </div>
                {!isOpen && (
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.5 }}>
                    {card.en.concept}
                  </div>
                )}
              </div>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                style={{ transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s', flexShrink: 0, opacity: 0.4 }}>
                <path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </button>

            {isOpen && (
              <div style={{ padding: '0 20px 20px', borderTop: '1px solid var(--cal-border)' }}>
                <div style={{
                  background: OG + '0F', border: `1px solid ${OG}2A`,
                  borderRadius: 8, padding: '12px 16px', margin: '16px 0 14px',
                }}>
                  <div style={{ fontSize: 10, fontWeight: 700, letterSpacing: '0.1em', color: OG, fontFamily: 'var(--font-display)', marginBottom: 4 }}>
                    THE CONCERN
                  </div>
                  <div style={{ fontSize: 13, color: 'var(--cal-ink)', fontStyle: 'italic', lineHeight: 1.7 }}>
                    "{card.en.concern}"
                  </div>
                </div>

                <div style={{ marginBottom: 14 }}>
                  <SectionLabel color={GN}>The reality</SectionLabel>
                  <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, margin: 0 }}>
                    {card.en.bridge}
                  </p>
                </div>

                <div style={{ marginBottom: 14 }}>
                  <SectionLabel color={WS}>The outcome</SectionLabel>
                  <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, margin: 0 }}>
                    {card.en.goal}
                  </p>
                </div>

                {card.en.whatToAsk?.length > 0 && (
                  <div style={{
                    background: 'var(--cal-off)', borderRadius: 8, padding: '14px 18px',
                  }}>
                    <SectionLabel>Questions to ask Woodstock</SectionLabel>
                    <ul style={{ margin: 0, padding: 0, listStyle: 'none' }}>
                      {card.en.whatToAsk.map((q, qi) => (
                        <li key={qi} style={{
                          fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.7,
                          paddingLeft: 16, position: 'relative', marginBottom: 8,
                        }}>
                          <span style={{
                            position: 'absolute', left: 0, top: 7,
                            width: 5, height: 5, borderRadius: '50%', background: WS, opacity: 0.5,
                          }} />
                          {q}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}
          </div>
        )
      })}

      <CompleteButton chapterId="overview" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: IGCSE Deep Dive
───────────────────────────────────────── */

function ChapterIGCSE({ completed, onToggle, data }) {
  const DATA = data
  const { gradingScale, woodstockSubjects } = DATA.igcseDeepDive
  return (
    <div>
      <h3 style={{
        fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
        color: WS, marginBottom: 6,
      }}>
        {DATA.igcseDeepDive.headline}
      </h3>

      {/* Grading scale */}
      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        overflow: 'hidden', marginBottom: 24, boxShadow: 'var(--shadow-sm)',
      }}>
        <div style={{ padding: '18px 22px', borderBottom: '1px solid var(--cal-border)' }}>
          <SectionLabel color={WS}>{gradingScale.heading}</SectionLabel>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
            {gradingScale.explanation}
          </p>
        </div>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr style={{ background: 'var(--cal-off)' }}>
              {['Grade', 'Label', 'What it means'].map(h => (
                <th key={h} style={{
                  padding: '10px 14px', textAlign: 'left',
                  fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700,
                  letterSpacing: '0.1em', textTransform: 'uppercase', color: 'var(--cal-muted)',
                  borderBottom: '1px solid var(--cal-border)',
                }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {gradingScale.grades.map((row, i) => (
              <tr key={i} style={{ borderBottom: '1px solid var(--cal-border)' }}>
                <td style={{ padding: '12px 14px' }}>
                  <span style={{
                    fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 800,
                    color: row.color,
                  }}>{row.grade}</span>
                </td>
                <td style={{ padding: '12px 14px' }}>
                  <span style={{
                    fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                    color: row.color,
                  }}>{row.label}</span>
                </td>
                <td style={{ padding: '12px 14px', fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.6 }}>
                  {row.description}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <div style={{ padding: '14px 22px', background: GN + '10', borderTop: '1px solid var(--cal-border)' }}>
          <div style={{ fontSize: 12, color: GN, lineHeight: 1.6 }}>
            🎯 <strong>Target:</strong> {gradingScale.targetNote}
          </div>
        </div>
      </div>

      {/* Woodstock subjects */}
      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        padding: '20px 24px', marginBottom: 24, boxShadow: 'var(--shadow-sm)',
      }}>
        <SectionLabel color={WS}>{woodstockSubjects.heading}</SectionLabel>
        <p style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6, marginBottom: 16 }}>
          {woodstockSubjects.note}
        </p>

        <div style={{ marginBottom: 16 }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: WS, fontFamily: 'var(--font-display)', marginBottom: 8 }}>
            CORE SUBJECTS
          </div>
          <div>
            {woodstockSubjects.core.map(s => <Tag key={s} color={WS}>{s}</Tag>)}
          </div>
        </div>

        <div style={{ marginBottom: 16 }}>
          <div style={{ fontSize: 11, fontWeight: 700, color: GN, fontFamily: 'var(--font-display)', marginBottom: 8 }}>
            ELECTIVES
          </div>
          <div>
            {woodstockSubjects.electives.map(s => <Tag key={s} color={GN}>{s}</Tag>)}
          </div>
        </div>

        <Callout color={OG} bg={OG + '0D'}>
          {woodstockSubjects.choiceNote}
        </Callout>
      </div>

      <CompleteButton chapterId="igcse" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: AP & WSD Deep Dive
───────────────────────────────────────── */

function ChapterAP({ completed, onToggle, data }) {
  const DATA = data
  const { scoringScale, woodstockOfferings, earlyOfferSteps } = DATA.apDeepDive
  return (
    <div>
      <h3 style={{
        fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
        color: OG, marginBottom: 16,
      }}>
        {DATA.apDeepDive.headline}
      </h3>

      {/* AP scoring scale */}
      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        overflow: 'hidden', marginBottom: 24, boxShadow: 'var(--shadow-sm)',
      }}>
        <div style={{ padding: '16px 22px', borderBottom: '1px solid var(--cal-border)' }}>
          <SectionLabel color={OG}>{scoringScale.heading}</SectionLabel>
        </div>
        {scoringScale.scores.map((row, i) => (
          <div key={i} style={{
            display: 'flex', gap: 16, alignItems: 'flex-start',
            padding: '14px 20px',
            borderBottom: i < scoringScale.scores.length - 1 ? '1px solid var(--cal-border)' : 'none',
          }}>
            <div style={{
              width: 36, height: 36, borderRadius: '50%', flexShrink: 0,
              background: row.color + '18', border: `2px solid ${row.color}55`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 800,
              color: row.color,
            }}>
              {row.score}
            </div>
            <div>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 700,
                color: row.color, marginBottom: 4,
              }}>
                {row.label}
              </div>
              <div style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.6 }}>
                {row.description}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* AP offerings */}
      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        padding: '20px 24px', marginBottom: 24, boxShadow: 'var(--shadow-sm)',
      }}>
        <SectionLabel color={OG}>{woodstockOfferings.heading}</SectionLabel>
        <p style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6, marginBottom: 16 }}>
          {woodstockOfferings.note}
        </p>
        {woodstockOfferings.subjects.map(area => (
          <div key={area.area} style={{ marginBottom: 14 }}>
            <div style={{ fontSize: 11, fontWeight: 700, color: OG, fontFamily: 'var(--font-display)', marginBottom: 6 }}>
              {area.area.toUpperCase()}
            </div>
            <div>
              {area.courses.map(c => <Tag key={c} color={OG}>{c}</Tag>)}
            </div>
          </div>
        ))}
      </div>

      {/* Early offer pathway */}
      <div style={{ marginBottom: 24 }}>
        <SectionLabel color={GN}>The early university offer pathway</SectionLabel>
        <div style={{ position: 'relative', paddingLeft: 28 }}>
          <div style={{
            position: 'absolute', left: 11, top: 8, bottom: 8,
            width: 2, background: GN + '44', borderRadius: 2,
          }} />
          {earlyOfferSteps.map((step, i) => (
            <div key={i} style={{ position: 'relative', marginBottom: 20 }}>
              <div style={{
                position: 'absolute', left: -28, top: 2,
                width: 22, height: 22, borderRadius: '50%',
                background: GN, color: '#fff',
                fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {step.step}
              </div>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
                color: 'var(--cal-ink)', marginBottom: 4,
              }}>
                {step.title}
              </div>
              <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                {step.detail}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* WSD quick note */}
      <div style={{
        background: WS + '0A', border: `1px solid ${WS}22`,
        borderRadius: 12, padding: '18px 22px', marginBottom: 24,
      }}>
        <SectionLabel color={WS}>About the Woodstock School Diploma</SectionLabel>
        {DATA.cards.filter(c => c.id === 'wsd').map(card => (
          <div key={card.id}>
            <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, marginBottom: 12 }}>
              {card.en.bridge}
            </p>
            <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, margin: 0 }}>
              {card.en.goal}
            </p>
          </div>
        ))}
      </div>

      <CompleteButton chapterId="ap" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Universities (new pathway)
───────────────────────────────────────── */

function ChapterUniversities({ completed, onToggle, data }) {
  const DATA = data
  const [active, setActive] = useState('uk')
  const { destinations } = DATA.universityGuide

  const dest = destinations.find(d => d.id === active) || destinations[0]

  return (
    <div>
      <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, marginBottom: 20, fontStyle: 'italic', opacity: 0.8 }}>
        {DATA.universityGuide.intro}
      </p>

      {/* Region tabs */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 20, flexWrap: 'wrap' }}>
        {destinations.map(d => (
          <button
            key={d.id}
            onClick={() => setActive(d.id)}
            style={{
              background: active === d.id ? WS : 'var(--cal-off)',
              color: active === d.id ? '#fff' : 'var(--cal-ink)',
              border: `1px solid ${active === d.id ? WS : 'var(--cal-border)'}`,
              borderRadius: 8, padding: '8px 14px', cursor: 'pointer',
              fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
              transition: 'all 0.15s',
            }}
          >
            {d.flag} {d.label}
          </button>
        ))}
      </div>

      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        overflow: 'hidden', boxShadow: 'var(--shadow-sm)', marginBottom: 24,
      }}>
        <div style={{ background: WS, padding: '20px 24px', color: '#fff' }}>
          <div style={{ fontSize: 28, marginBottom: 6 }}>{dest.flag}</div>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700 }}>
            {dest.label}
          </div>
        </div>
        <div style={{ padding: '20px 24px' }}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {[
              { label: 'IGCSE', color: GN, text: dest.howIgcse },
              { label: 'AP',    color: OG, text: dest.howAp },
              { label: 'WSD',   color: WS, text: dest.howWsd },
            ].map(row => (
              <div key={row.label}>
                <Tag color={row.color}>{row.label}</Tag>
                <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: '8px 0 0' }}>
                  {row.text}
                </p>
              </div>
            ))}
          </div>

          <div style={{
            marginTop: 20, paddingTop: 16, borderTop: '1px solid var(--cal-border)',
          }}>
            <Callout color={GN}>
              <strong>Verdict:</strong> {dest.verdict}
            </Callout>
            <div style={{
              background: WS + '0A', borderRadius: 8, padding: '12px 16px',
              fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.7,
            }}>
              💡 <strong>Top tip:</strong> {dest.topTip}
            </div>
            {dest.watchOut && (
              <Callout color={OG} bg={OG + '0D'}>
                ⚠️ <strong>Watch out:</strong> {dest.watchOut}
              </Callout>
            )}
          </div>
        </div>
      </div>

      <CompleteButton chapterId="universities" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Universities (IB pathway)
───────────────────────────────────────── */

function ChapterIBUniversities({ completed, onToggle, data }) {
  const DATA = data
  const [active, setActive] = useState('uk')
  const { destinations } = DATA.ibUniversityGuide

  const dest = destinations.find(d => d.id === active) || destinations[0]

  return (
    <div>
      <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, marginBottom: 20, fontStyle: 'italic', opacity: 0.8 }}>
        {DATA.ibUniversityGuide.intro}
      </p>

      <div style={{ display: 'flex', gap: 8, marginBottom: 20, flexWrap: 'wrap' }}>
        {destinations.map(d => (
          <button
            key={d.id}
            onClick={() => setActive(d.id)}
            style={{
              background: active === d.id ? WS : 'var(--cal-off)',
              color: active === d.id ? '#fff' : 'var(--cal-ink)',
              border: `1px solid ${active === d.id ? WS : 'var(--cal-border)'}`,
              borderRadius: 8, padding: '8px 14px', cursor: 'pointer',
              fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
              transition: 'all 0.15s',
            }}
          >
            {d.flag} {d.label}
          </button>
        ))}
      </div>

      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        overflow: 'hidden', boxShadow: 'var(--shadow-sm)', marginBottom: 24,
      }}>
        <div style={{ background: WS, padding: '20px 24px', color: '#fff' }}>
          <div style={{ fontSize: 28, marginBottom: 6 }}>{dest.flag}</div>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700 }}>
            {dest.label}
          </div>
        </div>
        <div style={{ padding: '20px 24px' }}>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, marginBottom: 16 }}>
            {dest.detail}
          </p>
          <div style={{
            background: WS + '0A', borderRadius: 8, padding: '12px 16px',
            fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.7,
          }}>
            💡 <strong>Top tip:</strong> {dest.topTip}
          </div>
        </div>
      </div>

      {/* IB scoring benchmarks */}
      <div style={{ marginBottom: 24 }}>
        <SectionLabel color={WS}>IB score benchmarks</SectionLabel>
        <div style={{
          background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
          overflow: 'hidden',
        }}>
          {DATA.ibProgramme.scoring.benchmarks.map((b, i) => (
            <div key={i} style={{
              display: 'flex', gap: 16, padding: '12px 20px',
              borderBottom: i < DATA.ibProgramme.scoring.benchmarks.length - 1 ? '1px solid var(--cal-border)' : 'none',
              alignItems: 'flex-start',
            }}>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 800,
                color: WS, flexShrink: 0, minWidth: 52,
              }}>
                {b.range}
              </div>
              <div>
                <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 2 }}>
                  {b.label}
                </div>
                <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                  {b.detail}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <CompleteButton chapterId="universities" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Student Life (new pathway)
───────────────────────────────────────── */

function ChapterStudents({ completed, onToggle, data }) {
  const DATA = data
  const { wins, studentVoice, headline, intro } = DATA.studentTransition
  return (
    <div>
      <h3 style={{
        fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
        color: WS, marginBottom: 6,
      }}>
        {headline}
      </h3>
      <p style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.7, marginBottom: 24 }}>
        {intro}
      </p>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 14, marginBottom: 28 }}>
        {wins.map(win => (
          <div key={win.id} style={{
            background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
            padding: '18px 20px', display: 'flex', gap: 16, boxShadow: 'var(--shadow-sm)',
          }}>
            <span style={{ fontSize: 28, flexShrink: 0 }}>{win.icon}</span>
            <div>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
                color: WS, marginBottom: 6,
              }}>
                {win.title}
              </div>
              <div style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.7 }}>
                {win.detail}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div style={{
        background: WS + '0A', border: `1px solid ${WS}22`,
        borderRadius: 12, padding: '22px 24px', marginBottom: 24,
      }}>
        <SectionLabel color={WS}>{studentVoice.prompt}</SectionLabel>
        <blockquote style={{
          margin: 0, fontStyle: 'italic', fontSize: 14,
          color: 'var(--cal-ink)', lineHeight: 1.85,
          borderLeft: `3px solid ${WS}55`, paddingLeft: 16,
        }}>
          "{studentVoice.response}"
        </blockquote>
      </div>

      <CompleteButton chapterId="students" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Conversations (scenarios)
───────────────────────────────────────── */

function ChapterScenarios({ grade, completed, onToggle, data }) {
  const DATA = data
  const [active, setActive] = useState(null)
  const scenarios = DATA.scenarios
  return (
    <div>
      <p style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.7, marginBottom: 20 }}>
        Real conversations that happen at Woodstock — and what makes the difference between a moment of panic and a moment of understanding.
      </p>

      {scenarios.map(sc => {
        const isOpen = active === sc.id
        return (
          <div key={sc.id} style={{
            background: '#fff', borderRadius: 12,
            border: isOpen ? `1px solid ${WS}55` : '1px solid var(--cal-border)',
            marginBottom: 12, overflow: 'hidden', boxShadow: 'var(--shadow-sm)',
          }}>
            <button
              onClick={() => setActive(isOpen ? null : sc.id)}
              style={{
                width: '100%', background: 'none', border: 'none', cursor: 'pointer',
                padding: '16px 20px', textAlign: 'left',
                display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12,
              }}
            >
              <div>
                <div style={{
                  fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
                  color: 'var(--cal-ink)', marginBottom: 4,
                }}>
                  {sc.en.title}
                </div>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                  {sc.en.termsInPlay.map(t => (
                    <Tag key={t} color={WS}>{t}</Tag>
                  ))}
                </div>
              </div>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none"
                style={{ transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.2s', flexShrink: 0, opacity: 0.4 }}>
                <path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </button>

            {isOpen && (
              <div style={{ padding: '0 20px 20px', borderTop: '1px solid var(--cal-border)' }}>
                <div style={{
                  background: 'var(--cal-off)', borderRadius: 8, padding: '14px 16px', margin: '16px 0 14px',
                }}>
                  <SectionLabel>The situation</SectionLabel>
                  <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
                    {sc.en.situation}
                  </p>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
                  <div style={{
                    background: GN + '0E', border: `1px solid ${GN}33`,
                    borderRadius: 8, padding: '14px 16px',
                  }}>
                    <div style={{ fontSize: 10, fontWeight: 700, color: GN, fontFamily: 'var(--font-display)', letterSpacing: '0.1em', marginBottom: 8 }}>
                      WITH UNDERSTANDING ✓
                    </div>
                    <p style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
                      {sc.en.withUnderstanding}
                    </p>
                  </div>
                  <div style={{
                    background: OG + '0E', border: `1px solid ${OG}33`,
                    borderRadius: 8, padding: '14px 16px',
                  }}>
                    <div style={{ fontSize: 10, fontWeight: 700, color: OG, fontFamily: 'var(--font-display)', letterSpacing: '0.1em', marginBottom: 8 }}>
                      WITHOUT UNDERSTANDING ✗
                    </div>
                    <p style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
                      {sc.en.withoutUnderstanding}
                    </p>
                  </div>
                </div>
              </div>
            )}
          </div>
        )
      })}

      <CompleteButton chapterId="scenarios" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: IB Programme
───────────────────────────────────────── */

function ChapterIB({ completed, onToggle, data }) {
  const DATA = data
  const { overview, subjectGroups, hlSlNote, core, scoring } = DATA.ibProgramme
  return (
    <div>
      <h3 style={{
        fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
        color: WS, marginBottom: 16,
      }}>
        {DATA.ibProgramme.headline}
      </h3>

      <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, marginBottom: 20, fontStyle: 'italic', opacity: 0.8 }}>
        {DATA.ibProgramme.intro}
      </p>

      {/* Overview */}
      <Callout color={WS}>
        <strong>{overview.heading}</strong><br />
        {overview.body}
      </Callout>

      {/* Subject groups */}
      <SectionLabel color={WS}>The six subject groups</SectionLabel>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 20 }}>
        {subjectGroups.map(g => (
          <div key={g.group} style={{
            background: '#fff', borderRadius: 10, border: '1px solid var(--cal-border)',
            padding: '14px 18px', display: 'flex', gap: 14,
          }}>
            <div style={{
              fontFamily: 'var(--font-display)', fontSize: 10, fontWeight: 700,
              color: WS, flexShrink: 0, marginTop: 2, minWidth: 60,
              letterSpacing: '0.05em',
            }}>
              {g.group}
            </div>
            <div>
              <div style={{ fontWeight: 600, fontSize: 13, color: 'var(--cal-ink)', marginBottom: 2 }}>
                {g.label}
              </div>
              <div style={{ fontSize: 12, color: WS, marginBottom: 4 }}>{g.example}</div>
              <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.6 }}>{g.detail}</div>
            </div>
          </div>
        ))}
      </div>

      <Callout color={OG} bg={OG + '0D'}>
        <strong>HL vs SL:</strong> {hlSlNote}
      </Callout>

      {/* Core components */}
      <SectionLabel color={WS}>The three core requirements</SectionLabel>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 24 }}>
        {core.map(c => (
          <div key={c.title} style={{
            background: '#fff', borderRadius: 10, border: '1px solid var(--cal-border)',
            padding: '16px 20px', boxShadow: 'var(--shadow-sm)',
          }}>
            <div style={{ display: 'flex', gap: 12, marginBottom: 8 }}>
              <span style={{ fontSize: 22 }}>{c.icon}</span>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700,
                color: WS, alignSelf: 'center',
              }}>
                {c.title}
              </div>
            </div>
            <p style={{ fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.7, margin: '0 0 10px' }}>
              {c.detail}
            </p>
            <div style={{
              background: GN + '0E', border: `1px solid ${GN}22`,
              borderRadius: 6, padding: '10px 14px',
              fontSize: 12, color: 'var(--cal-ink)', lineHeight: 1.6,
            }}>
              <strong>For parents:</strong> {c.parentNote}
            </div>
          </div>
        ))}
      </div>

      {/* Scoring */}
      <div style={{
        background: '#fff', borderRadius: 12, border: '1px solid var(--cal-border)',
        overflow: 'hidden', marginBottom: 24,
      }}>
        <div style={{ padding: '16px 22px', borderBottom: '1px solid var(--cal-border)' }}>
          <SectionLabel color={WS}>{scoring.heading}</SectionLabel>
          <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.7, margin: 0 }}>
            {scoring.scale}
          </p>
        </div>
        {scoring.benchmarks.map((b, i) => (
          <div key={i} style={{
            display: 'flex', gap: 16, padding: '12px 20px',
            borderBottom: i < scoring.benchmarks.length - 1 ? '1px solid var(--cal-border)' : 'none',
          }}>
            <div style={{
              fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 13,
              color: WS, flexShrink: 0, minWidth: 56,
            }}>
              {b.range}
            </div>
            <div>
              <span style={{ fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)', marginRight: 8 }}>
                {b.label}
              </span>
              <span style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
                {b.detail}
              </span>
            </div>
          </div>
        ))}
      </div>

      <CompleteButton chapterId="ib" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   CHAPTER: Next Steps
───────────────────────────────────────── */

function ChapterNextSteps({ grade, completed, onToggle, data }) {
  const DATA = data
  const steps = getNextSteps(DATA, grade)
  return (
    <div>
      <SectionLabel color={WS}>Recommended next steps for Grade {grade} families</SectionLabel>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 28 }}>
        {steps.map((step, i) => (
          <div key={i} style={{
            background: '#fff', borderRadius: 10, border: '1px solid var(--cal-border)',
            padding: '16px 20px', display: 'flex', gap: 14,
            boxShadow: 'var(--shadow-sm)',
          }}>
            <div style={{
              width: 28, height: 28, borderRadius: '50%', flexShrink: 0,
              background: WS, color: '#fff',
              fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 700,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              {i + 1}
            </div>
            <p style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.75, margin: 0 }}>
              {step}
            </p>
          </div>
        ))}
      </div>

      <div style={{
        background: WS + '0A', border: `1px solid ${WS}22`,
        borderRadius: 12, padding: '22px 24px', textAlign: 'center',
      }}>
        <div style={{ fontSize: 24, marginBottom: 10 }}>✉️</div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: WS, marginBottom: 6 }}>
          {DATA.feedbackCta.text}
        </div>
        <a
          href={`mailto:${DATA.feedbackCta.email}`}
          style={{
            display: 'inline-block', background: WS, color: '#fff',
            borderRadius: 8, padding: '10px 22px',
            fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600,
            textDecoration: 'none', marginTop: 8,
          }}
        >
          {DATA.feedbackCta.cta}
        </a>
      </div>

      <CompleteButton chapterId="nextsteps" completed={completed} onToggle={onToggle} />
    </div>
  )
}


/* ─────────────────────────────────────────
   CHAPTER: Knowledge Check (final, research-anchored)
───────────────────────────────────────── */

const WOODSTOCK_KNOWLEDGE_CHECK = [
  {
    id: 'ws-kc-q1',
    prompt: 'An Indian parent asks whether Cambridge IGCSE is "easier" than CBSE Class 10. What is the most accurate answer the module supports?',
    research_anchor: 'Association of Indian Universities (AIU) — IGCSE recognized as equivalent to Indian Class 10; Cambridge equivalency studies',
    options: [
      { id: 'a', text: 'Yes, IGCSE is simpler because the grading is A*–G instead of percentages.',                                        isCorrect: false, feedback: 'Different grading is not lesser rigour. The AIU explicitly recognizes IGCSE as equivalent to Class 10.' },
      { id: 'b', text: 'No — IGCSE is differently rigorous: deeper subject mastery and formal external exams, and is formally recognized by AIU as equivalent to Class 10.', isCorrect: true,  feedback: 'Correct. This is the module\'s anchor answer — it reframes "easier" as "orientationally different" and cites the AIU equivalence.' },
      { id: 'c', text: 'It depends entirely on which tutor the child has.',                                                                  isCorrect: false, feedback: 'This sidesteps the question and leaves parents without a clear frame.' },
      { id: 'd', text: 'IGCSE is harder than CBSE and parents should expect a drop in marks.',                                               isCorrect: false, feedback: 'Overcorrects. The module avoids making IGCSE sound like a threat.' },
    ],
  },
  {
    id: 'ws-kc-q2',
    prompt: 'A Grade 11 family worries: "Is our daughter going to be cut off mid-IB?" The module\'s direct answer is:',
    research_anchor: 'Woodstock transition protection policy — Grades 9–12 complete IB as originally planned',
    options: [
      { id: 'a', text: 'No — students already in Grades 9–12 complete the IB Diploma exactly as originally planned. Zero change.',           isCorrect: true,  feedback: 'Correct. The protection of mid-programme students is the module\'s single most important reassurance point.' },
      { id: 'b', text: 'Yes — they will switch to IGCSE + AP in January.',                                                                   isCorrect: false, feedback: 'This is the rumor the module is designed to correct.' },
      { id: 'c', text: 'They will receive a hybrid credential that is half IB, half AP.',                                                    isCorrect: false, feedback: 'Hybrid credentialling is not what Woodstock is doing.' },
      { id: 'd', text: 'It depends on whether the family pays a transition fee.',                                                            isCorrect: false, feedback: 'False. Woodstock does not make curriculum continuation contingent on fees.' },
    ],
  },
  {
    id: 'ws-kc-q3',
    prompt: 'A parent asks: "Is the Woodstock School Diploma extra work on top of IB or AP?" The module\'s answer is:',
    research_anchor: 'Middle States Association (MSA) accreditation — holistic diploma frameworks as co-located with academic coursework',
    options: [
      { id: 'a', text: 'Yes, it is a separate parallel programme that adds hours to the week.',                                              isCorrect: false, feedback: 'This is the main parent fear the module addresses. The WSD is not a parallel track.' },
      { id: 'b', text: 'No — WSD credits are earned through coursework the student is already doing (e.g. CAS, Extended Essay, residential and outdoor life).', isCorrect: true,  feedback: 'Correct. The WSD is a recognition framework, not a second curriculum.' },
      { id: 'c', text: 'Only students in the boarding house earn the WSD.',                                                                  isCorrect: false, feedback: 'WSD is for all enrolled graduates, not boarding-only.' },
      { id: 'd', text: 'It is optional and most families opt out.',                                                                          isCorrect: false, feedback: 'WSD is part of the Woodstock graduation framework, not an add-on.' },
    ],
  },
  {
    id: 'ws-kc-q4',
    prompt: 'A parent asks whether AP courses in Grades 11–12 are "less demanding" than IB Diploma subjects. The module\'s framing is:',
    research_anchor: 'College Board AP — research showing AP scores 3+ broadly equivalent to first-year US university coursework; Geiser & Santelices',
    options: [
      { id: 'a', text: 'AP is easier because each course is one year instead of two.',                                                       isCorrect: false, feedback: 'Duration is a structural difference, not a rigour difference.' },
      { id: 'b', text: 'AP is first-year-university-level coursework per subject; a strong AP transcript with 4s and 5s is treated comparably to IB Higher Level passes at most universities.', isCorrect: true,  feedback: 'Correct. This is the frame research on university outcomes supports, and the one Woodstock uses with families.' },
      { id: 'c', text: 'AP is only accepted in the United States.',                                                                          isCorrect: false, feedback: 'AP is accepted globally — UK, Canada, Australia, India, and beyond.' },
      { id: 'd', text: 'AP is harder than IB and the school is hiding it.',                                                                  isCorrect: false, feedback: 'Overcorrects. The module does not argue AP is universally harder.' },
    ],
  },
  {
    id: 'ws-kc-q5',
    prompt: 'What does the MYP Personal Project in Grade 10 accomplish, per the module?',
    research_anchor: 'IB MYP research — sustained independent project work as preparation for IB Extended Essay / AP capstones; Hattie on project-based inquiry',
    options: [
      { id: 'a', text: 'It fills a gap year before IB starts.',                                                                              isCorrect: false, feedback: 'The module explicitly rejects the "gap year" reading.' },
      { id: 'b', text: 'It is a self-directed investigation that is the strongest preparation for the IB Extended Essay and sustained academic work.', isCorrect: true,  feedback: 'Correct. The module positions it as the runway into Diploma-level research.' },
      { id: 'c', text: 'It is a group project required for MYP graduation only.',                                                            isCorrect: false, feedback: 'The Personal Project is individually authored.' },
      { id: 'd', text: 'It replaces the MYP final subject assessments.',                                                                     isCorrect: false, feedback: 'Both the Personal Project and subject assessments run in MYP Year 5.' },
    ],
  },
  {
    id: 'ws-kc-q6',
    prompt: 'A parent asks: "Will my child have fewer university options on the new pathway?" The module\'s evidence-anchored answer:',
    research_anchor: 'College Board / UCAS / AIU admissions data — IGCSE+AP transcripts accepted at all Ivy+, Russell Group, Canadian, Australian, and Indian private universities',
    options: [
      { id: 'a', text: 'Yes — Ivy League and Oxbridge prefer IB.',                                                                           isCorrect: false, feedback: 'Both Ivies and Oxbridge explicitly accept AP transcripts. The module is built to dispel this myth.' },
      { id: 'b', text: 'No — IGCSE + AP transcripts are accepted at every major university system (US, UK, Canada, Australia, India) and are the standard for American international schools.', isCorrect: true,  feedback: 'Correct. University recognition parity is the module\'s core reassurance point.' },
      { id: 'c', text: 'Only Indian private universities accept the new pathway.',                                                           isCorrect: false, feedback: 'The pathway is globally recognized.' },
      { id: 'd', text: 'University acceptance depends entirely on the counsellor\'s reputation.',                                            isCorrect: false, feedback: 'Counsellors matter, but recognition of IGCSE + AP is structural, not counsellor-dependent.' },
    ],
  },
  {
    id: 'ws-kc-q7',
    prompt: 'When did Woodstock first begin offering Advanced Placement (AP), according to the module?',
    research_anchor: 'Woodstock School institutional history — AP programme operation since 1961; used to anchor credibility of the "new" pathway',
    options: [
      { id: 'a', text: '2024 — with this transition announcement.',                                                                          isCorrect: false, feedback: 'AP is not new to Woodstock; the module makes this point explicitly.' },
      { id: 'b', text: '1961 — AP has been part of Woodstock\'s offering for more than sixty years.',                                        isCorrect: true,  feedback: 'Correct. Naming this history is one of the module\'s strongest credibility moves.' },
      { id: 'c', text: '2005 — when IB Diploma was introduced.',                                                                             isCorrect: false, feedback: 'IB and AP were co-existing at Woodstock for many years.' },
      { id: 'd', text: '1854 — when the school was founded.',                                                                                isCorrect: false, feedback: 'The school predates AP — AP itself was created in the 1950s.' },
    ],
  },
  {
    id: 'ws-kc-q8',
    prompt: 'A Grade 8 parent asks: "What should we do now to prepare?" The module\'s single most concrete recommendation is:',
    research_anchor: 'EEF Parental Engagement Toolkit — structured conversations about subject choice outperform general encouragement',
    options: [
      { id: 'a', text: 'Buy an IGCSE workbook and begin home revision immediately.',                                                         isCorrect: false, feedback: 'Unnecessary and often counter-productive at Grade 8.' },
      { id: 'b', text: 'Have the conversation about IGCSE subject selection — which 5–7 subjects and why — because these choices shape which APs are available in Grades 11–12.', isCorrect: true,  feedback: 'Correct. The module frames Grade 8 subject choice as the single most consequential parent conversation in the transition.' },
      { id: 'c', text: 'Switch tutors to a CBSE-trained one.',                                                                                isCorrect: false, feedback: 'Unrelated to the Woodstock pathway and can create confusion.' },
      { id: 'd', text: 'Nothing — wait until Grade 11.',                                                                                     isCorrect: false, feedback: 'Grade 8 subject choice has real downstream effects; waiting is passive.' },
    ],
  },
  {
    id: 'ws-kc-q9',
    prompt: 'Which of the following is the most common parent misconception about the transition, per the module?',
    research_anchor: 'Woodstock transition parent-survey patterns — "new curriculum" read as "unproven" rather than "established combination"',
    options: [
      { id: 'a', text: 'That the change is experimental and unproven.',                                                                      isCorrect: true,  feedback: 'Correct. This is the main misread: IGCSE, AP, and WSD are each long-established programmes — the combination is what is new to Woodstock, not the components.' },
      { id: 'b', text: 'That the change is a cost-cutting measure.',                                                                         isCorrect: false, feedback: 'Some parents raise this but it is not the module\'s single most common misconception.' },
      { id: 'c', text: 'That the change is only for international students.',                                                                 isCorrect: false, feedback: 'The change applies to all enrolled students regardless of nationality.' },
      { id: 'd', text: 'That the change is permanent.',                                                                                      isCorrect: false, feedback: 'It is permanent, and the module communicates that clearly.' },
    ],
  },
  {
    id: 'ws-kc-q10',
    prompt: 'Which single sentence best captures the module\'s core stance toward the curriculum transition?',
    research_anchor: 'Module synthesis — established-components frame + cohort protection + recognition parity',
    options: [
      { id: 'a', text: '"Woodstock is replacing IB because IB is outdated."',                                                                isCorrect: false, feedback: 'The module never makes this claim and treats IB with respect throughout.' },
      { id: 'b', text: '"The new pathway is a combination of established programmes (IGCSE, AP, WSD) with recognition parity to IB, and every cohort already mid-IB completes IB as planned."', isCorrect: true,  feedback: 'Correct. This is the module\'s thesis: continuity for current IB students + parity for future cohorts + established, not experimental, components.' },
      { id: 'c', text: '"The transition is experimental and parents should consider transferring."',                                         isCorrect: false, feedback: 'The module is structured to rule this reading out.' },
      { id: 'd', text: '"The change is mainly a branding exercise."',                                                                        isCorrect: false, feedback: 'The module describes concrete programme changes, not branding.' },
    ],
  },
]

function ChapterKnowledgeCheck({ grade, completed, onToggle, data: _data }) {
  const storageKey = `cal_ws_kc_${grade}`
  const [answers, setAnswers] = useState(() => {
    try { return JSON.parse(localStorage.getItem(storageKey) ?? '{}') }
    catch { return {} }
  })

  function pick(qid, optId) {
    if (answers[qid]) return
    const next = { ...answers, [qid]: optId }
    setAnswers(next)
    try { localStorage.setItem(storageKey, JSON.stringify(next)) } catch {}
  }

  function resetAll() {
    setAnswers({})
    try { localStorage.removeItem(storageKey) } catch {}
  }

  const total     = WOODSTOCK_KNOWLEDGE_CHECK.length
  const answered  = Object.keys(answers).length
  const correct   = WOODSTOCK_KNOWLEDGE_CHECK.reduce((n, q) => {
    const chosen = q.options.find(o => o.id === answers[q.id])
    return n + (chosen?.isCorrect ? 1 : 0)
  }, 0)
  const allAnswered = answered === total
  const passed      = allAnswered && correct >= 7

  return (
    <div>
      <SectionLabel color={WS}>Final knowledge check</SectionLabel>

      <Callout color={WS}>
        Ten questions on the Woodstock curriculum transition, each tagged with the research or institutional source behind it.
        This is not a scored exam — it is a frame-sharpening tool. Seven correct answers out of ten is the recommended pass mark
        to mark this module complete.
      </Callout>

      <div style={{ display: 'flex', flexDirection: 'column', gap: 16, marginBottom: 20 }}>
        {WOODSTOCK_KNOWLEDGE_CHECK.map((q, qi) => {
          const chosenId  = answers[q.id]
          const chosenOpt = q.options.find(o => o.id === chosenId)
          const locked    = !!chosenId
          return (
            <div key={q.id} style={{
              background: '#fff', border: '1px solid var(--cal-border)', borderRadius: 10,
              padding: '18px 20px', boxShadow: 'var(--shadow-sm)',
            }}>
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                letterSpacing: '0.08em', color: WS, marginBottom: 6, textTransform: 'uppercase',
              }}>
                Question {qi + 1} of {total}
              </div>
              <div style={{ fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.6, marginBottom: 12, fontWeight: 500 }}>
                {q.prompt}
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                {q.options.map(opt => {
                  const isChosen = chosenId === opt.id
                  const showRight = locked && opt.isCorrect
                  const showWrong = locked && isChosen && !opt.isCorrect
                  const borderColor = showRight ? GN : showWrong ? OG : 'var(--cal-border)'
                  const bg          = showRight ? GN + '12' : showWrong ? OG + '12' : isChosen ? WS + '10' : '#fff'
                  return (
                    <button
                      key={opt.id}
                      onClick={() => pick(q.id, opt.id)}
                      disabled={locked}
                      style={{
                        textAlign: 'left', cursor: locked ? 'default' : 'pointer',
                        background: bg, border: `1px solid ${borderColor}`,
                        borderRadius: 8, padding: '10px 14px',
                        fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.55,
                      }}
                    >
                      <strong style={{ marginRight: 8, color: showRight ? GN : showWrong ? OG : WS }}>{opt.id.toUpperCase()}.</strong>
                      {opt.text}
                    </button>
                  )
                })}
              </div>
              {locked && chosenOpt && (
                <div style={{
                  marginTop: 10, padding: '10px 14px', borderRadius: 8,
                  background: chosenOpt.isCorrect ? GN + '0E' : OG + '0E',
                  border: `1px solid ${chosenOpt.isCorrect ? GN : OG}33`,
                  fontSize: 12, color: 'var(--cal-ink-soft)', lineHeight: 1.65,
                }}>
                  <div style={{ fontWeight: 600, color: chosenOpt.isCorrect ? GN : OG, marginBottom: 4 }}>
                    {chosenOpt.isCorrect ? '✓ Correct' : '× Not quite'}
                  </div>
                  {chosenOpt.feedback}
                  <div style={{ marginTop: 6, fontSize: 11, fontStyle: 'italic', color: 'var(--cal-muted)' }}>
                    Source: {q.research_anchor}
                  </div>
                </div>
              )}
            </div>
          )
        })}
      </div>

      <div style={{
        background: WS + '0A', border: `1px solid ${WS}22`,
        borderRadius: 10, padding: '16px 20px', marginBottom: 20,
        display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12,
      }}>
        <div style={{ fontSize: 13, color: 'var(--cal-ink)' }}>
          Answered <strong>{answered}</strong> of {total} — correct so far: <strong>{correct}</strong>
          {allAnswered && (
            <span style={{ marginLeft: 8, color: passed ? GN : OG, fontWeight: 600 }}>
              {passed ? '· Passed' : '· Below 7/10 — review and retry'}
            </span>
          )}
        </div>
        {answered > 0 && (
          <button
            onClick={resetAll}
            style={{
              background: 'transparent', border: `1px solid ${WS}44`,
              color: WS, borderRadius: 6, padding: '6px 14px',
              fontSize: 12, cursor: 'pointer',
            }}
          >
            Reset answers
          </button>
        )}
      </div>

      <CompleteButton chapterId="knowledgecheck" completed={completed} onToggle={onToggle} />
    </div>
  )
}

/* ─────────────────────────────────────────
   Chapter dispatcher
───────────────────────────────────────── */

function ChapterContent({ chapterId, grade, completed, onToggle, data }) {
  const props = { grade, completed, onToggle, data }
  if (isNewPathway(grade)) {
    switch (chapterId) {
      case 'pathway':      return <ChapterPathway {...props} />
      case 'overview':     return <ChapterOverview {...props} />
      case 'igcse':        return <ChapterIGCSE {...props} />
      case 'ap':           return <ChapterAP {...props} />
      case 'universities': return <ChapterUniversities {...props} />
      case 'students':     return <ChapterStudents {...props} />
      case 'scenarios':    return <ChapterScenarios {...props} />
      case 'knowledgecheck': return <ChapterKnowledgeCheck {...props} />
      case 'nextsteps':    return <ChapterNextSteps {...props} />
      default:             return null
    }
  } else {
    switch (chapterId) {
      case 'pathway':      return <ChapterPathway {...props} />
      case 'ib':           return <ChapterIB {...props} />
      case 'universities': return <ChapterIBUniversities {...props} />
      case 'scenarios':    return <ChapterScenarios {...props} />
      case 'knowledgecheck': return <ChapterKnowledgeCheck {...props} />
      case 'nextsteps':    return <ChapterNextSteps {...props} />
      default:             return null
    }
  }
}

/* ─────────────────────────────────────────
   Main component
───────────────────────────────────────── */

export default function WoodstockModuleView() {
  const navigate    = useNavigate()
  const { user }    = useAuth()
  const [moduleData, setModuleData] = useState(null)
  const [loading,    setLoading]    = useState(true)
  const [loadError,  setLoadError]  = useState(null)
  const [retryCount, setRetryCount] = useState(0)

  const [grade,     setGrade]     = useState(() => {
    const saved = localStorage.getItem('cal_ws_grade')
    return saved ? parseInt(saved, 10) : null
  })
  const [completed, setCompleted] = useState(() => {
    if (!grade) return []
    try { return JSON.parse(localStorage.getItem(`cal_ws_completed_${grade}`) ?? '[]') }
    catch { return [] }
  })
  // Chapters a parent has marked "not applicable to me" (e.g. pure-WSD family skipping the AP chapter).
  // Skipped chapters are removed from the completion denominator so the progress bar doesn't penalize them.
  const [skipped, setSkipped] = useState(() => {
    if (!grade) return []
    try { return JSON.parse(localStorage.getItem(`cal_ws_skipped_${grade}`) ?? '[]') }
    catch { return [] }
  })
  const [activeChapter, setActiveChapter] = useState('pathway')
  const contentRef = useRef(null)

  const chapters = grade ? (isNewPathway(grade) ? CHAPTERS_NEW : CHAPTERS_IB) : []
  const totalChapters = chapters.length
  const completedInChapters = completed.filter(id => chapters.some(c => c.id === id)).length
  const skippedInChapters   = skipped.filter(id => chapters.some(c => c.id === id)).length
  const effectiveDenominator = Math.max(totalChapters - skippedInChapters, 0)
  const pct = effectiveDenominator > 0
    ? Math.min(100, Math.round((completedInChapters / effectiveDenominator) * 100))
    : (totalChapters > 0 ? 100 : 0)

  useEffect(() => {
    if (MOCK_MODE) {
      setLoadError(null)
      setLoading(true)
      let active = true
      import('../vocab/woodstock-parent-transition')
        .then(mod => {
          if (!active) return
          setModuleData(mod.woodstockParentTransition)
          setLoading(false)
        })
        .catch(err => {
          if (!active) return
          setLoadError(err?.message || 'Could not load mock Woodstock content.')
          setLoading(false)
        })
      return () => { active = false }
    }

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
      getModule(WOODSTOCK_DB_ID),
      getDimensions(WOODSTOCK_DB_ID),
      getQuizQuestions(WOODSTOCK_DB_ID),
    ])
      .then(([mod, dims, questions]) => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setModuleData(buildWoodstockDataFromSupabase(mod, dims, questions))
        setLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setLoadError(err?.message || 'Could not load Woodstock module content.')
        setLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [retryCount])

  // Persist grade
  useEffect(() => {
    if (grade !== null) localStorage.setItem('cal_ws_grade', String(grade))
  }, [grade])

  // Persist completions to localStorage (keyed by grade so each child's progress is independent)
  useEffect(() => {
    if (!grade) return
    localStorage.setItem(`cal_ws_completed_${grade}`, JSON.stringify(completed))
  }, [completed, grade])

  // Persist skipped chapters alongside completions
  useEffect(() => {
    if (!grade) return
    localStorage.setItem(`cal_ws_skipped_${grade}`, JSON.stringify(skipped))
  }, [skipped, grade])

  // Sync progress to Supabase so Progress page stays accurate.
  // Skipped chapters are subtracted from the denominator so an IGCSE-only parent
  // who skips the AP chapter still reaches 100%.
  useEffect(() => {
    if (!user || !grade) return
    const chaps = isNewPathway(grade) ? CHAPTERS_NEW : CHAPTERS_IB
    const total = chaps.length
    if (!total) return
    const done    = completed.filter(id => chaps.some(c => c.id === id)).length
    const skippedCount = skipped.filter(id => chaps.some(c => c.id === id)).length
    const denom   = Math.max(total - skippedCount, 0)
    const pct     = denom > 0 ? Math.min(100, Math.round((done / denom) * 100)) : 100
    upsertCompletion(user.id, 'woodstock-transition', pct).catch(console.error)
  }, [completed, skipped, grade, user])

  // Switch grade — restore that grade's saved progress
  const handleGradeSelect = (g) => {
    setGrade(g)
    setActiveChapter('pathway')
    try {
      const saved = JSON.parse(localStorage.getItem(`cal_ws_completed_${g}`) ?? '[]')
      setCompleted(saved)
    } catch {
      setCompleted([])
    }
    try {
      const savedSkip = JSON.parse(localStorage.getItem(`cal_ws_skipped_${g}`) ?? '[]')
      setSkipped(savedSkip)
    } catch {
      setSkipped([])
    }
  }

  const handleToggleComplete = (chapterId) => {
    setCompleted(prev =>
      prev.includes(chapterId)
        ? prev.filter(id => id !== chapterId)
        : [...prev, chapterId]
    )
    // Marking a chapter complete unskips it (the two are mutually exclusive)
    setSkipped(prev => prev.filter(id => id !== chapterId))
  }

  // Toggle "Not applicable to me" on a chapter. Skipping also clears any complete flag.
  const handleToggleSkip = (chapterId) => {
    setSkipped(prev =>
      prev.includes(chapterId)
        ? prev.filter(id => id !== chapterId)
        : [...prev, chapterId]
    )
    setCompleted(prev => prev.filter(id => id !== chapterId))
  }

  // Pathway and Next Steps chapters can't be skipped — they aren't optional content.
  const SKIPPABLE_CHAPTERS = new Set(['overview', 'igcse', 'ap', 'universities', 'students', 'scenarios', 'ib'])
  const canSkipChapter = (id) => SKIPPABLE_CHAPTERS.has(id)

  // Privacy disclosure for parents — dismissible per-user. Establishes the data boundary
  // between what the school sees and what stays on the parent's device.
  const privacyKey = `cal_ws_privacy_ack_${user?.id ?? 'anon'}`
  const [privacyAcked, setPrivacyAcked] = useState(() => {
    try { return typeof window !== 'undefined' && window.localStorage.getItem(privacyKey) === '1' }
    catch { return false }
  })
  const ackPrivacy = () => {
    setPrivacyAcked(true)
    try { window.localStorage.setItem(privacyKey, '1') } catch {}
  }

  const handleSelectChapter = (id) => {
    setActiveChapter(id)
    contentRef.current?.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const activeChapterMeta = chapters.find(c => c.id === activeChapter) || chapters[0]

  if (loading) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
        <TopBar />
        <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10, color: 'var(--cal-muted)' }}>
          <div style={{ width: 16, height: 16, border: '2px solid var(--cal-border)', borderTopColor: WS, borderRadius: '50%', animation: 'spin 0.8s linear infinite' }} />
          <span style={{ fontSize: 13 }}>Loading Woodstock content...</span>
          <style>{`@keyframes spin { to { transform: rotate(360deg) } }`}</style>
        </div>
      </div>
    )
  }

  if (loadError || !moduleData) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
        <TopBar />
        <div style={{ flex: 1, overflowY: 'auto', padding: '48px', maxWidth: 760, margin: '0 auto', width: '100%' }}>
          <ErrorState
            error={loadError || 'Could not load Woodstock module content.'}
            context="Woodstock module content"
            onRetry={() => setRetryCount(c => c + 1)}
          />
        </div>
      </div>
    )
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh', overflow: 'hidden' }}>
      <TopBar />

      {/* Grade intake modal */}
      {grade === null && <GradeIntake onSelect={handleGradeSelect} />}

      <div style={{ flex: 1, overflowY: 'auto' }} ref={contentRef}>

        {/* Hero banner */}
        <div style={{
          background: `linear-gradient(135deg, ${WS} 0%, #3D2470 100%)`,
          color: '#fff', padding: '36px 48px 30px',
          position: 'relative', overflow: 'hidden',
        }}>
          {/* decorative circles */}
          <div style={{ position: 'absolute', right: -60, top: -60, width: 280, height: 280, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.08)' }} />
          <div style={{ position: 'absolute', right: 60, top: 60, width: 140, height: 140, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.1)' }} />

          <button
            onClick={() => navigate('/dashboard')}
            style={{ background: 'transparent', border: 'none', color: 'rgba(255,255,255,0.55)', fontSize: 13, cursor: 'pointer', marginBottom: 16, padding: 0 }}
          >
            ← Back to modules
          </button>

          <div style={{ display: 'flex', alignItems: 'flex-start', gap: 20, position: 'relative', zIndex: 1 }}>
            <span style={{ fontSize: 48 }}>🏔️</span>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 600, letterSpacing: '0.16em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.45)', marginBottom: 6 }}>
                Woodstock School · Parent Guide
              </div>
              <h1 style={{ fontFamily: 'var(--font-display)', fontSize: 26, fontWeight: 800, letterSpacing: '-0.02em', marginBottom: 6, lineHeight: 1.25 }}>
                {moduleData.meta.title}
              </h1>
              <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.7)', maxWidth: 520, lineHeight: 1.7, margin: 0 }}>
                {moduleData.meta.subtitle}
              </p>
            </div>

            {/* Grade badge — switching is now in the sticky nav strip */}
            {grade && (
              <div style={{
                background: 'rgba(255,255,255,0.15)', borderRadius: 12,
                padding: '12px 20px', flexShrink: 0, textAlign: 'center',
              }}>
                <div style={{ fontSize: 10, color: 'rgba(255,255,255,0.55)', fontFamily: 'var(--font-display)', marginBottom: 4 }}>YOUR CHILD</div>
                <div style={{ fontSize: 28, fontWeight: 800, fontFamily: 'var(--font-display)' }}>Gr {grade}</div>
              </div>
            )}
          </div>

          {/* Progress */}
          {grade && (
            <div style={{ position: 'relative', zIndex: 1, marginTop: 20 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: 'rgba(255,255,255,0.45)', marginBottom: 6 }}>
                <span>Your progress</span>
                <span>
                  {pct}% — {completedInChapters} of {effectiveDenominator} sections
                  {skippedInChapters > 0 && ` (${skippedInChapters} skipped)`}
                </span>
              </div>
              <div style={{ height: 4, background: 'rgba(255,255,255,0.15)', borderRadius: 999 }}>
                <div style={{
                  height: '100%', width: `${pct}%`, background: GN,
                  borderRadius: 999, transition: 'width 0.4s ease',
                }} />
              </div>
            </div>
          )}
        </div>

        {/* Chapter nav strip */}
        {grade && (
          <ChapterNavStrip
            chapters={chapters}
            active={activeChapter}
            completed={completed}
            onSelect={handleSelectChapter}
            grade={grade}
            onGradeChange={handleGradeSelect}
          />
        )}

        {/* Chapter content */}

        {/* Chapter content */}
        {grade && (
          <div style={{ padding: '36px 48px', maxWidth: 860, margin: '0 auto' }}>

            {/* Privacy disclosure — shown until the parent acknowledges */}
            {!privacyAcked && (
              <div style={{
                background: '#F5F1FA',
                border: `1.5px solid ${WS}40`,
                borderRadius: 'var(--r-lg)',
                padding: '18px 22px',
                marginBottom: 24,
              }}>
                <div style={{
                  fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                  letterSpacing: '0.1em', color: WS, marginBottom: 10,
                }}>
                  A QUICK NOTE ON PRIVACY
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 18, marginBottom: 14 }}>
                  <div>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 6 }}>
                      What the school sees
                    </div>
                    <div style={{ fontSize: 12, color: 'var(--cal-ink-soft)', lineHeight: 1.6 }}>
                      Your overall completion percentage, which chapters you've finished, and anonymized quiz-answer aggregates if you take one. The school never sees which specific chapter you're reading or how long you spend on a page.
                    </div>
                  </div>
                  <div>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 6 }}>
                      What stays on your device
                    </div>
                    <div style={{ fontSize: 12, color: 'var(--cal-ink-soft)', lineHeight: 1.6 }}>
                      Your child's grade selection, chapters you mark as "not applicable", reading path through the module, and any notes you take. None of that is sent to the school.
                    </div>
                  </div>
                </div>
                <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.55, marginBottom: 12 }}>
                  If you'd rather not share completion data with the school, you can still read the guide — but we won't be able to mark this module done on your behalf. Questions? Contact your parent coordinator.
                </div>
                <button
                  type="button"
                  onClick={ackPrivacy}
                  style={{
                    fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                    background: WS, color: '#fff', border: 'none',
                    borderRadius: 'var(--r-md)', padding: '8px 16px', cursor: 'pointer',
                  }}
                >
                  Got it — continue
                </button>
              </div>
            )}

            {/* Chapter heading */}
            <div style={{ marginBottom: 28, paddingBottom: 20, borderBottom: '1px solid var(--cal-border)' }}>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <span style={{ fontSize: 32 }}>{activeChapterMeta?.icon}</span>
                  <h2 style={{
                    fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 700,
                    color: WS, margin: 0,
                  }}>
                    {activeChapterMeta?.label}
                  </h2>
                </div>
                {canSkipChapter(activeChapter) && (
                  <button
                    type="button"
                    onClick={() => handleToggleSkip(activeChapter)}
                    style={{
                      fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 600,
                      letterSpacing: '0.04em',
                      padding: '6px 12px', borderRadius: 999, cursor: 'pointer',
                      border: `1px solid ${skipped.includes(activeChapter) ? WS : 'var(--cal-border)'}`,
                      background: skipped.includes(activeChapter) ? `${WS}14` : 'transparent',
                      color: skipped.includes(activeChapter) ? WS : 'var(--cal-muted)',
                    }}
                    title={skipped.includes(activeChapter)
                      ? 'Include this chapter in your progress again'
                      : "Skip this chapter — it won't count against your completion"}
                  >
                    {skipped.includes(activeChapter) ? '✓ Skipped — include again' : 'Not applicable to me'}
                  </button>
                )}
              </div>
              {skipped.includes(activeChapter) && (
                <div style={{
                  marginTop: 12, fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.55,
                  background: 'var(--cal-surface)', padding: '10px 14px', borderRadius: 'var(--r-sm)',
                  border: '1px solid var(--cal-border-lt)',
                }}>
                  You've marked this chapter as not applicable — it's been removed from your progress total. You can still read it; nothing is locked.
                </div>
              )}
            </div>

            <ChapterContent
              chapterId={activeChapter}
              grade={grade}
              completed={completed}
              onToggle={handleToggleComplete}
              data={moduleData}
            />

            {/* Prev / Next chapter nav */}
            <div style={{
              display: 'flex', justifyContent: 'space-between',
              marginTop: 32, paddingTop: 20, borderTop: '1px solid var(--cal-border)',
            }}>
              {(() => {
                const idx = chapters.findIndex(c => c.id === activeChapter)
                const prev = chapters[idx - 1]
                const next = chapters[idx + 1]
                return (
                  <>
                    {prev ? (
                      <button
                        onClick={() => handleSelectChapter(prev.id)}
                        style={{
                          background: 'none', border: `1px solid ${WS}55`,
                          borderRadius: 8, padding: '10px 18px', cursor: 'pointer',
                          fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                          color: WS, display: 'flex', alignItems: 'center', gap: 6,
                        }}
                      >
                        ← {prev.label}
                      </button>
                    ) : <div />}
                    {next ? (
                      <button
                        onClick={() => handleSelectChapter(next.id)}
                        style={{
                          background: WS, border: 'none',
                          borderRadius: 8, padding: '10px 18px', cursor: 'pointer',
                          fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
                          color: '#fff', display: 'flex', alignItems: 'center', gap: 6,
                        }}
                      >
                        {next.label} →
                      </button>
                    ) : <div />}
                  </>
                )
              })()}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
