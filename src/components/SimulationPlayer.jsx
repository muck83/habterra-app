import { useState, useRef } from 'react'
import { saveSimulationResponse } from '../lib/supabase'

function uid() {
  return Math.random().toString(36).slice(2) + Date.now().toString(36)
}

const NODE_STYLE = {
  consequence: { bg: '#FFF8E1', border: '#FDD835', label: 'What happened',     labelColor: '#92400E' },
  perspective:  { bg: '#E6F2F4', border: '#4DB6AC', label: 'Their perspective', labelColor: '#0B5563' },
  reflection:   { bg: '#F3E5F5', border: '#AB47BC', label: 'Reflection',        labelColor: '#6A1B9A' },
}

function Prose({ lines }) {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
      {(lines ?? []).map((line, i) => (
        <p key={i} style={{ margin: 0, fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.8 }}>{line}</p>
      ))}
    </div>
  )
}

function SectionLabel({ text, color }) {
  return (
    <div style={{
      fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700,
      letterSpacing: '0.12em', textTransform: 'uppercase',
      color: color, marginBottom: 12,
    }}>
      {text}
    </div>
  )
}

function ContinueBtn({ onClick }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: 20 }}>
      <button
        className="btn"
        onClick={onClick}
        style={{ background: 'var(--cal-teal)', color: '#fff', padding: '10px 22px', fontSize: 13 }}
      >
        Continue
      </button>
    </div>
  )
}

/* ── Intro ── */
function SimulationIntro({ sim, onBegin }) {
  const chars = sim.characters ?? []
  return (
    <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', border: '1px solid var(--cal-border)', overflow: 'hidden', boxShadow: 'var(--shadow-sm)' }}>
      <div style={{ background: 'var(--cal-teal)', padding: '24px 28px', color: '#fff' }}>
        <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.14em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.55)', marginBottom: 8 }}>
          Simulation &middot; {sim.estimated_minutes ?? 20} min
        </div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 700, marginBottom: 8 }}>{sim.title}</div>
        <div style={{ fontSize: 13, color: 'rgba(255,255,255,0.75)', lineHeight: 1.65 }}>{sim.description}</div>
      </div>

      <div style={{ padding: '24px 28px', display: 'flex', flexDirection: 'column', gap: 24 }}>
        {chars.length > 0 && (
          <div>
            <SectionLabel text="Characters" color="var(--cal-muted)" />
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {chars.map((c, i) => (
                <div key={i} style={{ background: 'var(--cal-off)', borderRadius: 'var(--r-sm)', padding: '12px 16px' }}>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 2 }}>{c.name}</div>
                  <div style={{ fontSize: 11, color: 'var(--cal-teal)', fontWeight: 600, marginBottom: 6 }}>{c.role}</div>
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.65 }}>{c.description}</div>
                </div>
              ))}
            </div>
          </div>
        )}

        {sim.context && (
          <div>
            <SectionLabel text="The situation" color="var(--cal-muted)" />
            <div style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8, background: 'var(--cal-off)', borderRadius: 'var(--r-sm)', padding: '14px 16px' }}>
              {sim.context}
            </div>
          </div>
        )}

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <button
            className="btn"
            onClick={onBegin}
            style={{ background: 'var(--cal-teal)', color: '#fff', padding: '11px 26px', fontSize: 13 }}
          >
            Begin simulation
          </button>
        </div>
      </div>
    </div>
  )
}

/* ── Choice button ── */
function ChoiceButton({ choice, selected, onSelect }) {
  const isSelected = selected === choice.id
  return (
    <button
      onClick={() => !selected && onSelect(choice.id)}
      style={{
        width: '100%', textAlign: 'left', border: 'none',
        cursor: selected ? 'default' : 'pointer',
        background: isSelected ? '#E6F2F4' : 'var(--cal-off)',
        borderRadius: 'var(--r-sm)', padding: '14px 16px',
        borderLeft: isSelected ? '3px solid var(--cal-teal)' : '3px solid transparent',
        opacity: selected && !isSelected ? 0.4 : 1,
        transition: 'all 0.15s',
        display: 'flex', alignItems: 'flex-start', gap: 12,
      }}
    >
      <div style={{
        width: 24, height: 24, borderRadius: '50%', flexShrink: 0,
        background: isSelected ? 'var(--cal-teal)' : 'var(--cal-border)',
        color: '#fff', fontSize: 11, fontWeight: 700,
        fontFamily: 'var(--font-display)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        marginTop: 1,
      }}>
        {isSelected ? '✓' : '→'}
      </div>
      <div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 4 }}>
          {choice.label}
        </div>
        <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.65 }}>
          {choice.text}
        </div>
      </div>
    </button>
  )
}

/* ── Reflection option ── */
function ReflectionOption({ text, selected, onSelect }) {
  const isSelected = selected === text
  return (
    <button
      onClick={() => !selected && onSelect(text)}
      style={{
        width: '100%', textAlign: 'left',
        border: isSelected ? '1px solid #AB47BC' : '1px solid var(--cal-border)',
        cursor: selected ? 'default' : 'pointer',
        background: isSelected ? '#F3E5F5' : '#fff',
        borderRadius: 'var(--r-sm)', padding: '11px 14px',
        fontSize: 13, color: isSelected ? '#6A1B9A' : 'var(--cal-ink)',
        opacity: selected && !isSelected ? 0.4 : 1,
        transition: 'all 0.15s', lineHeight: 1.6,
      }}
    >
      {isSelected ? '✓  ' : ''}{text}
    </button>
  )
}

/* ── Progress indicator ── */
function SimProgress({ nodes, history }) {
  const dilemmas = Object.values(nodes).filter(n => n.type === 'dilemma')
  const total = dilemmas.length
  const done  = dilemmas.filter(n => history.includes(n.id)).length
  if (total === 0) return null
  return (
    <div style={{ marginBottom: 20 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 6 }}>
        <span>Simulation progress</span>
        <span>{done} of {total} dilemmas</span>
      </div>
      <div style={{ height: 4, background: 'var(--cal-border)', borderRadius: 999 }}>
        <div style={{ height: '100%', width: `${total > 0 ? (done / total) * 100 : 0}%`, background: 'var(--cal-teal)', borderRadius: 999, transition: 'width 0.4s ease' }} />
      </div>
    </div>
  )
}

/* ── Debrief ── */
function DebriefScreen({ node, choicesMade, nodes, onCommit }) {
  const [commitment, setCommitment] = useState('')
  const [committed,  setCommitted]  = useState(false)

  const dilemmaNodes = Object.values(nodes)
    .filter(n => n.type === 'dilemma')
    .sort((a, b) => {
      const numA = parseInt((a.id.match(/\d+/) ?? ['0'])[0])
      const numB = parseInt((b.id.match(/\d+/) ?? ['0'])[0])
      return numA - numB
    })

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>

      {/* Path summary */}
      <div style={{ background: '#F1F8E9', borderRadius: 'var(--r-lg)', border: '1px solid #A5D6A7', padding: '20px 24px' }}>
        <SectionLabel text="Your path through this simulation" color="#2E7D32" />
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {dilemmaNodes.map((d, i) => {
            const made = choicesMade[d.id]
            return (
              <div key={d.id} style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                <div style={{
                  width: 24, height: 24, borderRadius: '50%', flexShrink: 0,
                  background: made ? '#43A047' : 'var(--cal-border)',
                  color: '#fff', fontSize: 11, fontWeight: 700,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  marginTop: 1,
                }}>
                  {i + 1}
                </div>
                <div>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600, color: '#2E7D32', marginBottom: 2 }}>
                    {d.title}
                  </div>
                  <div style={{ fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.6 }}>
                    {made ? made.label : '—'}
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </div>

      {/* Debrief sections */}
      {(node.sections ?? []).map((sec, i) => (
        <div key={i}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 10 }}>
            {sec.title}
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {(sec.content ?? []).map((line, j) => (
              <p key={j} style={{ margin: 0, fontSize: 13, color: 'var(--cal-ink)', lineHeight: 1.8 }}>{line}</p>
            ))}
          </div>
        </div>
      ))}

      {/* Final prompt */}
      {node.finalPrompt && (
        <div style={{ background: 'var(--cal-off)', borderRadius: 'var(--r-lg)', padding: '20px 24px', borderLeft: '3px solid var(--cal-teal)' }}>
          <SectionLabel text="Final reflection" color="var(--cal-teal)" />
          <p style={{ margin: 0, fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.8, fontStyle: 'italic' }}>
            {node.finalPrompt}
          </p>
        </div>
      )}

      {/* Commitment field */}
      <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', border: '2px solid var(--cal-teal)', padding: '20px 24px' }}>
        <SectionLabel text="One thing I will do differently" color="var(--cal-teal)" />
        {committed ? (
          <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
            <span style={{ color: '#43A047', fontSize: 18, marginTop: 2 }}>✓</span>
            <p style={{ margin: 0, fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.75, fontStyle: 'italic' }}>
              {commitment}
            </p>
          </div>
        ) : (
          <div>
            <p style={{ margin: '0 0 14px', fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.65 }}>
              Not a reflection — a specific action. What will you do differently in your next parent interaction?
            </p>
            <textarea
              value={commitment}
              onChange={e => setCommitment(e.target.value)}
              placeholder="e.g. When a parent asks how their child is ranked, I will name what I can offer — specific growth evidence — before explaining what we don't do."
              rows={3}
              style={{
                width: '100%', boxSizing: 'border-box',
                border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                padding: '10px 12px', fontSize: 13, color: 'var(--cal-ink)',
                lineHeight: 1.7, resize: 'vertical', fontFamily: 'var(--font-body)',
                outline: 'none', display: 'block',
              }}
            />
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: 12 }}>
              <button
                className="btn"
                disabled={commitment.trim().length < 10}
                onClick={() => { setCommitted(true); onCommit?.(commitment.trim()) }}
                style={{
                  background: commitment.trim().length >= 10 ? 'var(--cal-teal)' : 'var(--cal-border)',
                  color: '#fff', padding: '9px 20px', fontSize: 13,
                  cursor: commitment.trim().length >= 10 ? 'pointer' : 'default',
                  transition: 'background 0.2s',
                }}
              >
                Commit
              </button>
            </div>
          </div>
        )}
      </div>

    </div>
  )
}

/* ── Main player ── */
export default function SimulationPlayer({ sim }) {
  const nodes = sim.nodes ?? {}

  const [phase,            setPhase]            = useState('intro')
  const [nodeId,           setNodeId]           = useState('setup')
  const [history,          setHistory]          = useState([])
  const [choices,          setChoices]          = useState({})
  const [reflections,      setReflections]      = useState({})
  const [debriefCommitted, setDebriefCommitted] = useState(false)
  const [sessionId]                             = useState(uid)
  const scrollRef = useRef(null)

  const node = nodes[nodeId]
  const ns   = NODE_STYLE[node ? node.type : ''] ?? {}

  function advance(nextId) {
    if (!nextId || !nodes[nextId]) { setPhase('complete'); return }
    setHistory(h => [...h, nodeId])
    setNodeId(nextId)
    if (scrollRef.current) scrollRef.current.scrollTo({ top: 0, behavior: 'smooth' })
  }

  function handleChoice(choiceId) {
    if (choices[nodeId]) return
    const choice = (node.choices ?? []).find(c => c.id === choiceId)
    if (!choice) return
    setChoices(prev => ({ ...prev, [nodeId]: { choiceId, label: choice.label } }))
    saveSimulationResponse({ sessionId, simulationId: sim.id, nodeId, choiceId }).catch(() => {})
    advance(choice.next)
  }

  function handleReflection(text) {
    if (reflections[nodeId]) return
    setReflections(prev => ({ ...prev, [nodeId]: text }))
    saveSimulationResponse({ sessionId, simulationId: sim.id, nodeId, reflectionText: text }).catch(() => {})
  }

  function handleBegin() {
    setPhase('playing')
    setNodeId('setup')
    setHistory([])
    setChoices({})
    setReflections({})
  }

  function handleRestart() {
    setPhase('intro')
    setNodeId('setup')
    setHistory([])
    setChoices({})
    setReflections({})
    setDebriefCommitted(false)
  }

  if (phase === 'intro') {
    return <SimulationIntro sim={sim} onBegin={handleBegin} />
  }

  if (phase === 'complete' || !node) {
    return (
      <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', border: '1px solid var(--cal-border)', padding: '28px', textAlign: 'center' }}>
        <div style={{ fontSize: 36, marginBottom: 12 }}>🎭</div>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 6 }}>Simulation complete</div>
        <div style={{ fontSize: 13, color: 'var(--cal-muted)', marginBottom: 20 }}>Your responses have been recorded.</div>
        <button className="btn btn-ghost" onClick={handleRestart} style={{ fontSize: 12 }}>Run again</button>
      </div>
    )
  }

  return (
    <div ref={scrollRef} style={{ background: '#fff', borderRadius: 'var(--r-lg)', border: '1px solid var(--cal-border)', overflow: 'hidden', boxShadow: 'var(--shadow-sm)' }}>

      {/* Top bar */}
      <div style={{ background: 'var(--cal-off)', borderBottom: '1px solid var(--cal-border)', padding: '12px 24px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 700, color: 'var(--cal-ink)' }}>
          🎭 {sim.title}
        </div>
        <button onClick={handleRestart} style={{ background: 'none', border: 'none', fontSize: 11, color: 'var(--cal-muted)', cursor: 'pointer', fontFamily: 'var(--font-display)' }}>
          Restart
        </button>
      </div>

      <div style={{ padding: '24px 28px' }}>
        <SimProgress nodes={nodes} history={history} />

        {/* SETUP */}
        {node.type === 'setup' && (
          <div>
            <Prose lines={node.content} />
            <ContinueBtn onClick={() => advance(node.next)} />
          </div>
        )}

        {/* DILEMMA */}
        {node.type === 'dilemma' && (
          <div>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 12 }}>
              {node.title}
            </div>
            <Prose lines={node.content} />
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginTop: 20 }}>
              {(node.choices ?? []).map(choice => (
                <ChoiceButton
                  key={choice.id}
                  choice={choice}
                  selected={choices[nodeId] ? choices[nodeId].choiceId : null}
                  onSelect={handleChoice}
                />
              ))}
            </div>
            {!choices[nodeId] && (
              <div style={{ marginTop: 12, fontSize: 12, color: 'var(--cal-muted)', textAlign: 'center' }}>
                Choose a response to continue
              </div>
            )}
          </div>
        )}

        {/* CONSEQUENCE */}
        {node.type === 'consequence' && (
          <div style={{ background: ns.bg, borderRadius: 'var(--r-lg)', padding: '20px 22px', borderLeft: `3px solid ${ns.border}` }}>
            <SectionLabel text={ns.label} color={ns.labelColor} />
            <Prose lines={node.content} />
            <ContinueBtn onClick={() => advance(node.next)} />
          </div>
        )}

        {/* PERSPECTIVE */}
        {node.type === 'perspective' && (
          <div style={{ background: ns.bg, borderRadius: 'var(--r-lg)', padding: '20px 22px', borderLeft: `3px solid ${ns.border}` }}>
            <SectionLabel text={ns.label} color={ns.labelColor} />
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 12 }}>
              {node.title}
            </div>
            <Prose lines={node.content} />
            <ContinueBtn onClick={() => advance(node.next)} />
          </div>
        )}

        {/* REFLECTION */}
        {node.type === 'reflection' && (
          <div style={{ background: ns.bg, borderRadius: 'var(--r-lg)', padding: '20px 22px', borderLeft: `3px solid ${ns.border}` }}>
            <SectionLabel text={ns.label} color={ns.labelColor} />
            <p style={{ margin: '0 0 16px', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)', lineHeight: 1.7 }}>
              {node.prompt}
            </p>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {(node.options ?? []).map((opt, i) => (
                <ReflectionOption
                  key={i}
                  text={opt}
                  selected={reflections[nodeId] ?? null}
                  onSelect={handleReflection}
                />
              ))}
            </div>
            {reflections[nodeId] && (
              <ContinueBtn onClick={() => advance(node.next)} />
            )}
          </div>
        )}

        {/* DEBRIEF */}
        {node.type === 'debrief' && (
          <div>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 17, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 20 }}>
              Debrief
            </div>
            <DebriefScreen
              node={node}
              choicesMade={choices}
              nodes={nodes}
              onCommit={(text) => {
                setDebriefCommitted(true)
                saveSimulationResponse({
                  sessionId, simulationId: sim.id,
                  nodeId, reflectionText: `[COMMITMENT] ${text}`,
                }).catch(() => {})
              }}
            />
            {debriefCommitted && (
              <div style={{
                background: '#E8F5E9', border: '1px solid #A5D6A7',
                borderRadius: 'var(--r-md)', padding: '16px 20px', marginTop: 20,
                display: 'flex', alignItems: 'flex-start', gap: 12,
              }}>
                <span style={{ fontSize: 18, lineHeight: 1 }}>OK</span>
                <div>
                  <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 14, color: '#1B5E20', marginBottom: 4 }}>
                    Scenario complete
                  </div>
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
                    Your commitment and responses have been recorded.
                  </div>
                </div>
              </div>
            )}
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: 24 }}>
              <button className="btn btn-ghost" onClick={handleRestart} style={{ fontSize: 12 }}>Run again</button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
