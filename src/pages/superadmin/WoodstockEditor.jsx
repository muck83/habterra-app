/* ─────────────────────────────────────────────────────────────────────
   WoodstockEditor — schema-aware form editor for the Woodstock module.

   Woodstock content in production lives in six pd_dimensions rows
   (dimension_number 1–6) as a nested JSON `content` blob per row.
   This editor replaces the raw JSON textarea with typed form fields
   matching the specific Woodstock schema so admins can edit prose
   without touching JSON.

   Each dimension has its own Section<N>Editor panel. The top-level
   WoodstockEditor owns a draft `byDim[n]` map, computes per-dimension
   dirty state, and saves via the injected onSaveDimension(id, content)
   callback (which SuperAdminDashboard wires to updateDimension).
   ───────────────────────────────────────────────────────────────────── */

import { useEffect, useMemo, useState } from 'react'

/* ══════════════════════════════════════════════════
   Primitive components
   ══════════════════════════════════════════════════ */

function Field({ label, hint, children }) {
  return (
    <label style={{ display: 'block', marginBottom: 14 }}>
      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.06em',
        textTransform: 'uppercase', color: 'var(--cal-muted)',
        fontFamily: 'var(--font-display)', marginBottom: 4,
      }}>
        {label}
      </div>
      {children}
      {hint && (
        <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginTop: 4, lineHeight: 1.4 }}>
          {hint}
        </div>
      )}
    </label>
  )
}

function TextInput({ value, onChange, placeholder }) {
  return (
    <input
      type="text"
      value={value ?? ''}
      onChange={e => onChange(e.target.value)}
      placeholder={placeholder}
      style={{
        width: '100%', padding: '8px 10px', fontSize: 13,
        border: '1px solid var(--cal-border)', borderRadius: 6,
        fontFamily: 'var(--font-body)', background: '#fff',
        boxSizing: 'border-box',
      }}
    />
  )
}

function TextArea({ value, onChange, rows = 3, placeholder, mono = false }) {
  return (
    <textarea
      value={value ?? ''}
      onChange={e => onChange(e.target.value)}
      rows={rows}
      placeholder={placeholder}
      style={{
        width: '100%', padding: '8px 10px', fontSize: 13,
        border: '1px solid var(--cal-border)', borderRadius: 6,
        fontFamily: mono ? 'ui-monospace, Menlo, monospace' : 'var(--font-body)',
        background: '#fff', lineHeight: 1.5, resize: 'vertical',
        boxSizing: 'border-box',
      }}
    />
  )
}

function StringListEditor({ values, onChange, placeholder = 'Add item...' }) {
  const list = Array.isArray(values) ? values : []
  return (
    <div>
      {list.map((item, i) => (
        <div key={i} style={{ display: 'flex', gap: 6, marginBottom: 6 }}>
          <input
            type="text"
            value={item ?? ''}
            onChange={e => {
              const next = [...list]
              next[i] = e.target.value
              onChange(next)
            }}
            style={{
              flex: 1, padding: '6px 8px', fontSize: 12,
              border: '1px solid var(--cal-border)', borderRadius: 4,
              fontFamily: 'var(--font-body)', background: '#fff',
            }}
          />
          <button
            type="button"
            onClick={() => onChange(list.filter((_, j) => j !== i))}
            style={{
              padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)',
              background: '#fff', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            }}
          >Remove</button>
        </div>
      ))}
      <button
        type="button"
        onClick={() => onChange([...list, ''])}
        style={{
          padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)',
          background: 'transparent', borderRadius: 4, cursor: 'pointer',
          color: 'var(--cal-muted)', fontFamily: 'var(--font-display)',
        }}
      >+ {placeholder}</button>
    </div>
  )
}

function ListTextAreaEditor({ values, onChange, rows = 2, placeholder = 'Add item...' }) {
  const list = Array.isArray(values) ? values : []
  return (
    <div>
      {list.map((item, i) => (
        <div key={i} style={{ display: 'flex', gap: 6, marginBottom: 8, alignItems: 'flex-start' }}>
          <span style={{
            fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)',
            minWidth: 22, paddingTop: 6,
          }}>{i + 1}.</span>
          <textarea
            value={item ?? ''}
            onChange={e => {
              const next = [...list]
              next[i] = e.target.value
              onChange(next)
            }}
            rows={rows}
            style={{
              flex: 1, padding: '6px 8px', fontSize: 12,
              border: '1px solid var(--cal-border)', borderRadius: 4,
              fontFamily: 'var(--font-body)', background: '#fff', lineHeight: 1.5,
              resize: 'vertical',
            }}
          />
          <button
            type="button"
            onClick={() => onChange(list.filter((_, j) => j !== i))}
            style={{
              padding: '4px 8px', fontSize: 11, border: '1px solid var(--cal-border)',
              background: '#fff', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            }}
          >×</button>
        </div>
      ))}
      <button
        type="button"
        onClick={() => onChange([...list, ''])}
        style={{
          padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)',
          background: 'transparent', borderRadius: 4, cursor: 'pointer',
          color: 'var(--cal-muted)', fontFamily: 'var(--font-display)',
        }}
      >+ {placeholder}</button>
    </div>
  )
}

function Subcard({ title, children, tone = 'neutral' }) {
  const borderColor = tone === 'warn' ? '#C45C26' : 'var(--cal-border)'
  const bg          = tone === 'warn' ? '#FFF8F2' : '#fff'
  return (
    <div style={{
      border: `1px solid ${borderColor}`, background: bg, borderRadius: 8,
      padding: 14, marginBottom: 14,
    }}>
      {title && (
        <div style={{
          fontSize: 11, fontWeight: 700, letterSpacing: '0.08em',
          textTransform: 'uppercase', color: 'var(--cal-teal)',
          fontFamily: 'var(--font-display)', marginBottom: 10,
        }}>{title}</div>
      )}
      {children}
    </div>
  )
}

function Section({ title, sub, children, dimNumber, dirty, saving, saved, error, onSave, onDiscard }) {
  return (
    <section style={{
      background: '#fff', border: '1px solid var(--cal-border)',
      borderRadius: 10, padding: 20, marginBottom: 20,
    }}>
      <div style={{
        display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        borderBottom: '1px solid var(--cal-border)', paddingBottom: 10, marginBottom: 14,
      }}>
        <div>
          <div style={{
            fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
            letterSpacing: '0.08em', textTransform: 'uppercase', color: 'var(--cal-muted)',
          }}>
            Dimension {dimNumber}
          </div>
          <div style={{
            fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700,
            color: 'var(--cal-teal)', marginTop: 2,
          }}>
            {title}
          </div>
          {sub && (
            <div style={{ fontSize: 12, color: 'var(--cal-muted)', marginTop: 4 }}>{sub}</div>
          )}
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, fontSize: 12 }}>
          {error && <span style={{ color: '#B3261E' }}>{error}</span>}
          {saved && !error && <span style={{ color: 'var(--cal-success)' }}>Saved.</span>}
          {dirty && !saving && !error && !saved && (
            <span style={{ color: 'var(--cal-amber)' }}>Unsaved changes</span>
          )}
          <button
            type="button"
            onClick={onDiscard}
            disabled={!dirty || saving}
            style={{
              padding: '6px 12px', fontSize: 12, border: '1px solid var(--cal-border)',
              background: '#fff', borderRadius: 6, cursor: (!dirty || saving) ? 'not-allowed' : 'pointer',
              opacity: (!dirty || saving) ? 0.5 : 1, fontFamily: 'var(--font-display)',
            }}
          >Discard</button>
          <button
            type="button"
            onClick={onSave}
            disabled={!dirty || saving}
            style={{
              padding: '6px 14px', fontSize: 12, border: 'none',
              background: 'var(--cal-teal)', color: '#fff', borderRadius: 6,
              cursor: (!dirty || saving) ? 'not-allowed' : 'pointer',
              opacity: (!dirty || saving) ? 0.6 : 1, fontFamily: 'var(--font-display)', fontWeight: 600,
            }}
          >{saving ? 'Saving...' : 'Save'}</button>
        </div>
      </div>
      {children}
    </section>
  )
}

/* ══════════════════════════════════════════════════
   Dim 1 — Meta / Director / Hook / CTA
   ══════════════════════════════════════════════════ */

function Dim1Body({ content, patch }) {
  const meta          = content?.meta          ?? {}
  const directorNote  = content?.directorNote  ?? {}
  const openingHook   = content?.openingHook   ?? {}
  const feedbackCta   = content?.feedbackCta   ?? {}

  const setMeta         = obj => patch({ meta:         { ...meta,         ...obj } })
  const setDirectorNote = obj => patch({ directorNote: { ...directorNote, ...obj } })
  const setOpeningHook  = obj => patch({ openingHook:  { ...openingHook,  ...obj } })
  const setFeedbackCta  = obj => patch({ feedbackCta:  { ...feedbackCta,  ...obj } })

  return (
    <div>
      <Subcard title="Meta (title / subtitle / intro)">
        <Field label="Title">
          <TextInput value={meta.title} onChange={v => setMeta({ title: v })} />
        </Field>
        <Field label="Subtitle">
          <TextInput value={meta.subtitle} onChange={v => setMeta({ subtitle: v })} />
        </Field>
        <Field label="Intro paragraph" hint="Shown on the module landing screen under the title.">
          <TextArea value={meta.intro} onChange={v => setMeta({ intro: v })} rows={4} />
        </Field>
      </Subcard>

      <Subcard title="Director's note">
        <Field label="Quote">
          <TextArea value={directorNote.quote} onChange={v => setDirectorNote({ quote: v })} rows={3} />
        </Field>
        <Field label="Attribution">
          <TextInput value={directorNote.attribution} onChange={v => setDirectorNote({ attribution: v })} />
        </Field>
      </Subcard>

      <Subcard title="Opening hook">
        <Field label="Question">
          <TextInput value={openingHook.question} onChange={v => setOpeningHook({ question: v })} />
        </Field>
        <Field label="Direct answer">
          <TextArea value={openingHook.directAnswer} onChange={v => setOpeningHook({ directAnswer: v })} rows={4} />
        </Field>
      </Subcard>

      <Subcard title="Feedback CTA (bottom of module)">
        <Field label="Prompt text">
          <TextInput value={feedbackCta.text} onChange={v => setFeedbackCta({ text: v })} />
        </Field>
        <Field label="Email address">
          <TextInput value={feedbackCta.email} onChange={v => setFeedbackCta({ email: v })} />
        </Field>
        <Field label="Button CTA">
          <TextInput value={feedbackCta.cta} onChange={v => setFeedbackCta({ cta: v })} />
        </Field>
      </Subcard>
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Dim 2 — Cohort Guide (5 cohorts)
   ══════════════════════════════════════════════════ */

function CohortEditor({ cohort, onChange, onRemove }) {
  const setField  = (k, v) => onChange({ ...cohort, [k]: v })
  const setNested = (nestedKey, fields) => onChange({
    ...cohort,
    [nestedKey]: { ...(cohort[nestedKey] ?? {}), ...fields },
  })
  const clearNested = key => {
    const next = { ...cohort }
    delete next[key]
    onChange(next)
  }

  return (
    <Subcard title={cohort.label || cohort.id || 'Cohort'}>
      <Field label="ID (slug)">
        <TextInput value={cohort.id} onChange={v => setField('id', v)} />
      </Field>
      <Field label="Label (displayed to parents)">
        <TextInput value={cohort.label} onChange={v => setField('label', v)} />
      </Field>
      <Field label="Pathway summary (one line)">
        <TextInput value={cohort.path} onChange={v => setField('path', v)} />
      </Field>
      <Field label="Detail paragraph">
        <TextArea value={cohort.detail} onChange={v => setField('detail', v)} rows={4} />
      </Field>
      <Field label="Timeline">
        <TextArea value={cohort.timeline} onChange={v => setField('timeline', v)} rows={2} />
      </Field>
      <Field label="Action (what the parent should do)">
        <TextArea value={cohort.action} onChange={v => setField('action', v)} rows={3} />
      </Field>

      {/* Optional sub-notes — conditionally rendered with add/remove */}
      {['wsdNote', 'grade10Note'].map(key => {
        const value = cohort[key]
        const labelMap = { wsdNote: 'WSD note', grade10Note: 'Grade 10 note' }
        return (
          <div key={key} style={{ marginBottom: 10 }}>
            {value ? (
              <Subcard title={labelMap[key]}>
                <Field label="Heading">
                  <TextInput value={value.heading} onChange={v => setNested(key, { heading: v })} />
                </Field>
                <Field label="Body">
                  <TextArea value={value.body} onChange={v => setNested(key, { body: v })} rows={4} />
                </Field>
                <button
                  type="button"
                  onClick={() => clearNested(key)}
                  style={{
                    padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)',
                    background: '#fff', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
                  }}
                >Remove {labelMap[key]}</button>
              </Subcard>
            ) : (
              <button
                type="button"
                onClick={() => setNested(key, { heading: '', body: '' })}
                style={{
                  padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)',
                  background: 'transparent', borderRadius: 4, cursor: 'pointer',
                  color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 8,
                }}
              >+ Add {labelMap[key]}</button>
            )}
          </div>
        )
      })}

      {/* bridgeNote has extra subjectNote field */}
      {cohort.bridgeNote ? (
        <Subcard title="Bridge note (typically Grade 8)">
          <Field label="Heading">
            <TextInput value={cohort.bridgeNote.heading} onChange={v => setNested('bridgeNote', { heading: v })} />
          </Field>
          <Field label="Body">
            <TextArea value={cohort.bridgeNote.body} onChange={v => setNested('bridgeNote', { body: v })} rows={4} />
          </Field>
          <Field label="Subject note">
            <TextArea value={cohort.bridgeNote.subjectNote} onChange={v => setNested('bridgeNote', { subjectNote: v })} rows={3} />
          </Field>
          <button
            type="button"
            onClick={() => clearNested('bridgeNote')}
            style={{
              padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)',
              background: '#fff', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            }}
          >Remove Bridge note</button>
        </Subcard>
      ) : (
        <button
          type="button"
          onClick={() => setNested('bridgeNote', { heading: '', body: '', subjectNote: '' })}
          style={{
            padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)',
            background: 'transparent', borderRadius: 4, cursor: 'pointer',
            color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 8,
            marginRight: 8,
          }}
        >+ Add Bridge note</button>
      )}

      {/* currentYear has extra whatToWatch field */}
      {cohort.currentYear ? (
        <Subcard title="Current year (typically Grade 6-7)">
          <Field label="Heading">
            <TextInput value={cohort.currentYear.heading} onChange={v => setNested('currentYear', { heading: v })} />
          </Field>
          <Field label="Body">
            <TextArea value={cohort.currentYear.body} onChange={v => setNested('currentYear', { body: v })} rows={5} />
          </Field>
          <Field label="What to watch for">
            <TextArea value={cohort.currentYear.whatToWatch} onChange={v => setNested('currentYear', { whatToWatch: v })} rows={3} />
          </Field>
          <button
            type="button"
            onClick={() => clearNested('currentYear')}
            style={{
              padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)',
              background: '#fff', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            }}
          >Remove Current year</button>
        </Subcard>
      ) : (
        <button
          type="button"
          onClick={() => setNested('currentYear', { heading: '', body: '', whatToWatch: '' })}
          style={{
            padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)',
            background: 'transparent', borderRadius: 4, cursor: 'pointer',
            color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 8,
          }}
        >+ Add Current year</button>
      )}

      <div style={{ textAlign: 'right', marginTop: 12 }}>
        <button
          type="button"
          onClick={onRemove}
          style={{
            padding: '6px 12px', fontSize: 11, border: '1px solid #B3262633',
            background: '#fff5f5', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            fontFamily: 'var(--font-display)',
          }}
        >Remove cohort</button>
      </div>
    </Subcard>
  )
}

function Dim2Body({ content, patch }) {
  const cohortGuide = content?.cohortGuide ?? {}
  const cohorts     = Array.isArray(cohortGuide.cohorts) ? cohortGuide.cohorts : []

  const setGuide    = fields => patch({ cohortGuide: { ...cohortGuide, ...fields } })
  const setCohorts  = next   => setGuide({ cohorts: next })

  return (
    <div>
      <Subcard title="Overview">
        <Field label="Intro line">
          <TextInput value={cohortGuide.intro} onChange={v => setGuide({ intro: v })} />
        </Field>
        <Field label="Protection callout" hint="Shown as the big coloured callout at the top of the cohort list.">
          <TextArea value={cohortGuide.protectionCallout} onChange={v => setGuide({ protectionCallout: v })} rows={3} />
        </Field>
      </Subcard>

      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.08em',
        textTransform: 'uppercase', color: 'var(--cal-muted)',
        fontFamily: 'var(--font-display)', margin: '20px 0 10px',
      }}>
        Cohorts ({cohorts.length})
      </div>

      {cohorts.map((c, i) => (
        <CohortEditor
          key={c.id ?? i}
          cohort={c}
          onChange={next => {
            const copy = [...cohorts]
            copy[i] = next
            setCohorts(copy)
          }}
          onRemove={() => setCohorts(cohorts.filter((_, j) => j !== i))}
        />
      ))}

      <button
        type="button"
        onClick={() => setCohorts([...cohorts, { id: '', label: '', path: '', detail: '', timeline: '', action: '' }])}
        style={{
          padding: '8px 14px', fontSize: 12, border: '1px dashed var(--cal-border)',
          background: 'transparent', borderRadius: 6, cursor: 'pointer',
          color: 'var(--cal-muted)', fontFamily: 'var(--font-display)',
        }}
      >+ Add cohort</button>
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Dim 3 — Cards + deep dives
   ══════════════════════════════════════════════════ */

function CardEditor({ card, onChange, onRemove }) {
  const en = card.en ?? {}
  const setField = (k, v) => onChange({ ...card, [k]: v })
  const setEn    = fields => onChange({ ...card, en: { ...en, ...fields } })

  return (
    <Subcard title={card.label || card.id || 'Card'}>
      <Field label="ID (slug)">
        <TextInput value={card.id} onChange={v => setField('id', v)} />
      </Field>
      <Field label="Label">
        <TextInput value={card.label} onChange={v => setField('label', v)} />
      </Field>
      <Field label="Concept (the headline question)">
        <TextInput value={en.concept} onChange={v => setEn({ concept: v })} />
      </Field>
      <Field label="Concern (the parent's anxiety)">
        <TextArea value={en.concern} onChange={v => setEn({ concern: v })} rows={3} />
      </Field>
      <Field label="Bridge (the reframing / data-anchored answer)">
        <TextArea value={en.bridge} onChange={v => setEn({ bridge: v })} rows={6} />
      </Field>
      <Field label="Goal (where the parent lands)">
        <TextArea value={en.goal} onChange={v => setEn({ goal: v })} rows={3} />
      </Field>
      <Field label="What to ask (questions the parent can take away)">
        <ListTextAreaEditor
          values={en.whatToAsk}
          onChange={v => setEn({ whatToAsk: v })}
          placeholder="Add a question"
          rows={2}
        />
      </Field>
      <div style={{ textAlign: 'right', marginTop: 12 }}>
        <button
          type="button"
          onClick={onRemove}
          style={{
            padding: '6px 12px', fontSize: 11, border: '1px solid #B3262633',
            background: '#fff5f5', borderRadius: 4, cursor: 'pointer', color: '#B3261E',
            fontFamily: 'var(--font-display)',
          }}
        >Remove card</button>
      </div>
    </Subcard>
  )
}

function IgcseDeepDiveEditor({ value, onChange }) {
  const dd = value ?? {}
  const grading  = dd.gradingScale ?? {}
  const subjects = dd.woodstockSubjects ?? {}
  const set        = fields => onChange({ ...dd, ...fields })
  const setGrading = fields => onChange({ ...dd, gradingScale: { ...grading, ...fields } })
  const setSubjects= fields => onChange({ ...dd, woodstockSubjects: { ...subjects, ...fields } })

  const grades = Array.isArray(grading.grades) ? grading.grades : []
  const setGrades = next => setGrading({ grades: next })

  return (
    <Subcard title="IGCSE deep dive">
      <Field label="Headline">
        <TextInput value={dd.headline} onChange={v => set({ headline: v })} />
      </Field>

      <Subcard title="Grading scale">
        <Field label="Heading">
          <TextInput value={grading.heading} onChange={v => setGrading({ heading: v })} />
        </Field>
        <Field label="Explanation">
          <TextArea value={grading.explanation} onChange={v => setGrading({ explanation: v })} rows={3} />
        </Field>
        <Field label="Target note">
          <TextArea value={grading.targetNote} onChange={v => setGrading({ targetNote: v })} rows={2} />
        </Field>
        <div style={{
          fontSize: 10, fontWeight: 700, letterSpacing: '0.08em',
          textTransform: 'uppercase', color: 'var(--cal-muted)',
          fontFamily: 'var(--font-display)', margin: '6px 0 6px',
        }}>Grade rows ({grades.length})</div>
        {grades.map((g, i) => (
          <div key={i} style={{
            display: 'grid', gridTemplateColumns: '80px 120px 1fr 80px auto', gap: 6,
            alignItems: 'start', marginBottom: 6,
          }}>
            <input value={g.grade ?? ''} placeholder="Grade"
              onChange={e => { const n = [...grades]; n[i] = { ...g, grade: e.target.value }; setGrades(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <input value={g.label ?? ''} placeholder="Label"
              onChange={e => { const n = [...grades]; n[i] = { ...g, label: e.target.value }; setGrades(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <textarea value={g.description ?? ''} placeholder="Description" rows={2}
              onChange={e => { const n = [...grades]; n[i] = { ...g, description: e.target.value }; setGrades(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4, fontFamily: 'var(--font-body)', resize: 'vertical' }} />
            <input value={g.color ?? ''} placeholder="#hex"
              onChange={e => { const n = [...grades]; n[i] = { ...g, color: e.target.value }; setGrades(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <button type="button"
              onClick={() => setGrades(grades.filter((_, j) => j !== i))}
              style={{ padding: '4px 8px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>×</button>
          </div>
        ))}
        <button type="button"
          onClick={() => setGrades([...grades, { grade: '', label: '', description: '', color: '#999' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add grade row</button>
      </Subcard>

      <Subcard title="Woodstock subjects">
        <Field label="Heading">
          <TextInput value={subjects.heading} onChange={v => setSubjects({ heading: v })} />
        </Field>
        <Field label="Note">
          <TextArea value={subjects.note} onChange={v => setSubjects({ note: v })} rows={2} />
        </Field>
        <Field label="Core subjects">
          <StringListEditor values={subjects.core} onChange={v => setSubjects({ core: v })} placeholder="Add core subject" />
        </Field>
        <Field label="Electives">
          <StringListEditor values={subjects.electives} onChange={v => setSubjects({ electives: v })} placeholder="Add elective" />
        </Field>
        <Field label="Choice note">
          <TextArea value={subjects.choiceNote} onChange={v => setSubjects({ choiceNote: v })} rows={2} />
        </Field>
      </Subcard>
    </Subcard>
  )
}

function ApDeepDiveEditor({ value, onChange }) {
  const dd = value ?? {}
  const scoring   = dd.scoringScale ?? {}
  const offerings = dd.woodstockOfferings ?? {}
  const steps     = Array.isArray(dd.earlyOfferSteps) ? dd.earlyOfferSteps : []
  const set         = fields => onChange({ ...dd, ...fields })
  const setScoring  = fields => onChange({ ...dd, scoringScale:       { ...scoring,   ...fields } })
  const setOffer    = fields => onChange({ ...dd, woodstockOfferings: { ...offerings, ...fields } })
  const setSteps    = next   => onChange({ ...dd, earlyOfferSteps: next })

  const scores = Array.isArray(scoring.scores) ? scoring.scores : []
  const setScores = next => setScoring({ scores: next })

  const subjectAreas = Array.isArray(offerings.subjects) ? offerings.subjects : []
  const setSubjectAreas = next => setOffer({ subjects: next })

  return (
    <Subcard title="AP deep dive">
      <Field label="Headline">
        <TextInput value={dd.headline} onChange={v => set({ headline: v })} />
      </Field>

      <Subcard title="Scoring scale">
        <Field label="Heading">
          <TextInput value={scoring.heading} onChange={v => setScoring({ heading: v })} />
        </Field>
        {scores.map((s, i) => (
          <div key={i} style={{
            display: 'grid', gridTemplateColumns: '60px 180px 1fr 80px auto', gap: 6,
            alignItems: 'start', marginBottom: 6,
          }}>
            <input value={s.score ?? ''} placeholder="Score"
              onChange={e => { const n = [...scores]; n[i] = { ...s, score: e.target.value === '' ? '' : Number(e.target.value) || e.target.value }; setScores(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <input value={s.label ?? ''} placeholder="Label"
              onChange={e => { const n = [...scores]; n[i] = { ...s, label: e.target.value }; setScores(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <textarea value={s.description ?? ''} placeholder="Description" rows={2}
              onChange={e => { const n = [...scores]; n[i] = { ...s, description: e.target.value }; setScores(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4, fontFamily: 'var(--font-body)', resize: 'vertical' }} />
            <input value={s.color ?? ''} placeholder="#hex"
              onChange={e => { const n = [...scores]; n[i] = { ...s, color: e.target.value }; setScores(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <button type="button"
              onClick={() => setScores(scores.filter((_, j) => j !== i))}
              style={{ padding: '4px 8px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>×</button>
          </div>
        ))}
        <button type="button"
          onClick={() => setScores([...scores, { score: '', label: '', description: '', color: '#999' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add score row</button>
      </Subcard>

      <Subcard title="Woodstock AP offerings">
        <Field label="Heading">
          <TextInput value={offerings.heading} onChange={v => setOffer({ heading: v })} />
        </Field>
        <Field label="Note">
          <TextArea value={offerings.note} onChange={v => setOffer({ note: v })} rows={2} />
        </Field>
        {subjectAreas.map((area, i) => (
          <Subcard key={i} title={area.area || `Area ${i + 1}`}>
            <Field label="Area name">
              <TextInput value={area.area}
                onChange={v => { const n = [...subjectAreas]; n[i] = { ...area, area: v }; setSubjectAreas(n) }} />
            </Field>
            <Field label="Courses">
              <StringListEditor
                values={area.courses}
                onChange={v => { const n = [...subjectAreas]; n[i] = { ...area, courses: v }; setSubjectAreas(n) }}
                placeholder="Add course"
              />
            </Field>
            <button type="button"
              onClick={() => setSubjectAreas(subjectAreas.filter((_, j) => j !== i))}
              style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>Remove area</button>
          </Subcard>
        ))}
        <button type="button"
          onClick={() => setSubjectAreas([...subjectAreas, { area: '', courses: [] }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add subject area</button>
      </Subcard>

      <Subcard title="Early-offer steps">
        {steps.map((s, i) => (
          <div key={i} style={{
            display: 'grid', gridTemplateColumns: '60px 200px 1fr auto', gap: 6,
            alignItems: 'start', marginBottom: 6,
          }}>
            <input value={s.step ?? ''} placeholder="Step#"
              onChange={e => { const n = [...steps]; n[i] = { ...s, step: e.target.value === '' ? '' : Number(e.target.value) || e.target.value }; setSteps(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <input value={s.title ?? ''} placeholder="Title"
              onChange={e => { const n = [...steps]; n[i] = { ...s, title: e.target.value }; setSteps(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <textarea value={s.detail ?? ''} placeholder="Detail" rows={2}
              onChange={e => { const n = [...steps]; n[i] = { ...s, detail: e.target.value }; setSteps(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4, fontFamily: 'var(--font-body)', resize: 'vertical' }} />
            <button type="button"
              onClick={() => setSteps(steps.filter((_, j) => j !== i))}
              style={{ padding: '4px 8px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>×</button>
          </div>
        ))}
        <button type="button"
          onClick={() => setSteps([...steps, { step: steps.length + 1, title: '', detail: '' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add step</button>
      </Subcard>
    </Subcard>
  )
}

function Dim3Body({ content, patch }) {
  const cards = Array.isArray(content?.cards) ? content.cards : []
  const setCards = next => patch({ cards: next })

  return (
    <div>
      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.08em',
        textTransform: 'uppercase', color: 'var(--cal-muted)',
        fontFamily: 'var(--font-display)', marginBottom: 10,
      }}>
        Cards ({cards.length})
      </div>
      {cards.map((c, i) => (
        <CardEditor
          key={c.id ?? i}
          card={c}
          onChange={next => { const n = [...cards]; n[i] = next; setCards(n) }}
          onRemove={() => setCards(cards.filter((_, j) => j !== i))}
        />
      ))}
      <button
        type="button"
        onClick={() => setCards([...cards, { id: '', label: '', en: { concept: '', concern: '', bridge: '', goal: '', whatToAsk: [] } }])}
        style={{
          padding: '8px 14px', fontSize: 12, border: '1px dashed var(--cal-border)',
          background: 'transparent', borderRadius: 6, cursor: 'pointer',
          color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 20,
        }}
      >+ Add card</button>

      <IgcseDeepDiveEditor
        value={content?.igcseDeepDive}
        onChange={v => patch({ igcseDeepDive: v })}
      />
      <ApDeepDiveEditor
        value={content?.apDeepDive}
        onChange={v => patch({ apDeepDive: v })}
      />
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Dim 4 — University Guides + IB Programme
   ══════════════════════════════════════════════════ */

function UniversityDestinationEditor({ dest, onChange, onRemove, kind }) {
  const set = (k, v) => onChange({ ...dest, [k]: v })
  return (
    <Subcard title={`${dest.flag ?? ''} ${dest.label || dest.id || 'Destination'}`}>
      <Field label="ID (slug)">
        <TextInput value={dest.id} onChange={v => set('id', v)} />
      </Field>
      <Field label="Label">
        <TextInput value={dest.label} onChange={v => set('label', v)} />
      </Field>
      <Field label="Flag (emoji)">
        <TextInput value={dest.flag} onChange={v => set('flag', v)} />
      </Field>

      {kind === 'new' ? (
        <>
          <Field label="How IGCSE lands">
            <TextArea value={dest.howIgcse} onChange={v => set('howIgcse', v)} rows={4} />
          </Field>
          <Field label="How AP lands">
            <TextArea value={dest.howAp} onChange={v => set('howAp', v)} rows={4} />
          </Field>
          <Field label="How WSD lands">
            <TextArea value={dest.howWsd} onChange={v => set('howWsd', v)} rows={4} />
          </Field>
          <Field label="Verdict">
            <TextArea value={dest.verdict} onChange={v => set('verdict', v)} rows={2} />
          </Field>
          <Field label="Top tip">
            <TextArea value={dest.topTip} onChange={v => set('topTip', v)} rows={3} />
          </Field>
          <Field label="Watch out (optional)">
            <TextArea value={dest.watchOut ?? ''} onChange={v => set('watchOut', v)} rows={3} />
          </Field>
        </>
      ) : (
        <>
          <Field label="Detail">
            <TextArea value={dest.detail} onChange={v => set('detail', v)} rows={5} />
          </Field>
          <Field label="Top tip">
            <TextArea value={dest.topTip} onChange={v => set('topTip', v)} rows={3} />
          </Field>
        </>
      )}

      <div style={{ textAlign: 'right', marginTop: 12 }}>
        <button type="button" onClick={onRemove}
          style={{ padding: '6px 12px', fontSize: 11, border: '1px solid #B3262633', background: '#fff5f5', borderRadius: 4, cursor: 'pointer', color: '#B3261E', fontFamily: 'var(--font-display)' }}>
          Remove destination
        </button>
      </div>
    </Subcard>
  )
}

function IbProgrammeEditor({ value, onChange }) {
  const ib = value ?? {}
  const overview = ib.overview ?? {}
  const scoring  = ib.scoring ?? {}
  const groups   = Array.isArray(ib.subjectGroups) ? ib.subjectGroups : []
  const core     = Array.isArray(ib.core)          ? ib.core          : []
  const benchmarks = Array.isArray(scoring.benchmarks) ? scoring.benchmarks : []
  const set         = fields => onChange({ ...ib, ...fields })
  const setOverview = fields => onChange({ ...ib, overview: { ...overview, ...fields } })
  const setScoring  = fields => onChange({ ...ib, scoring:  { ...scoring,  ...fields } })
  const setGroups   = next   => onChange({ ...ib, subjectGroups: next })
  const setCore     = next   => onChange({ ...ib, core: next })
  const setBenchmarks = next => setScoring({ benchmarks: next })

  return (
    <Subcard title="IB Programme reference">
      <Field label="Headline">
        <TextInput value={ib.headline} onChange={v => set({ headline: v })} />
      </Field>
      <Field label="Intro">
        <TextArea value={ib.intro} onChange={v => set({ intro: v })} rows={4} />
      </Field>
      <Field label="HL/SL note">
        <TextArea value={ib.hlSlNote} onChange={v => set({ hlSlNote: v })} rows={3} />
      </Field>

      <Subcard title="Overview">
        <Field label="Heading"><TextInput value={overview.heading} onChange={v => setOverview({ heading: v })} /></Field>
        <Field label="Body"><TextArea value={overview.body} onChange={v => setOverview({ body: v })} rows={5} /></Field>
      </Subcard>

      <Subcard title="Subject groups">
        {groups.map((g, i) => (
          <Subcard key={i} title={g.group || `Group ${i + 1}`}>
            <Field label="Group ID"><TextInput value={g.group} onChange={v => { const n = [...groups]; n[i] = { ...g, group: v }; setGroups(n) }} /></Field>
            <Field label="Label"><TextInput value={g.label} onChange={v => { const n = [...groups]; n[i] = { ...g, label: v }; setGroups(n) }} /></Field>
            <Field label="Example"><TextInput value={g.example} onChange={v => { const n = [...groups]; n[i] = { ...g, example: v }; setGroups(n) }} /></Field>
            <Field label="Detail"><TextArea value={g.detail} onChange={v => { const n = [...groups]; n[i] = { ...g, detail: v }; setGroups(n) }} rows={3} /></Field>
            <button type="button" onClick={() => setGroups(groups.filter((_, j) => j !== i))}
              style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>Remove group</button>
          </Subcard>
        ))}
        <button type="button" onClick={() => setGroups([...groups, { group: '', label: '', example: '', detail: '' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add group</button>
      </Subcard>

      <Subcard title="Core (EE / TOK / CAS)">
        {core.map((c, i) => (
          <Subcard key={i} title={c.title || `Item ${i + 1}`}>
            <Field label="Title"><TextInput value={c.title} onChange={v => { const n = [...core]; n[i] = { ...c, title: v }; setCore(n) }} /></Field>
            <Field label="Icon (emoji)"><TextInput value={c.icon} onChange={v => { const n = [...core]; n[i] = { ...c, icon: v }; setCore(n) }} /></Field>
            <Field label="Detail"><TextArea value={c.detail} onChange={v => { const n = [...core]; n[i] = { ...c, detail: v }; setCore(n) }} rows={4} /></Field>
            <Field label="Parent note"><TextArea value={c.parentNote} onChange={v => { const n = [...core]; n[i] = { ...c, parentNote: v }; setCore(n) }} rows={3} /></Field>
            <button type="button" onClick={() => setCore(core.filter((_, j) => j !== i))}
              style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>Remove core item</button>
          </Subcard>
        ))}
        <button type="button" onClick={() => setCore([...core, { title: '', icon: '', detail: '', parentNote: '' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add core item</button>
      </Subcard>

      <Subcard title="Scoring">
        <Field label="Heading"><TextInput value={scoring.heading} onChange={v => setScoring({ heading: v })} /></Field>
        <Field label="Scale description"><TextArea value={scoring.scale} onChange={v => setScoring({ scale: v })} rows={3} /></Field>
        <div style={{
          fontSize: 10, fontWeight: 700, letterSpacing: '0.08em',
          textTransform: 'uppercase', color: 'var(--cal-muted)',
          fontFamily: 'var(--font-display)', margin: '6px 0',
        }}>Benchmarks ({benchmarks.length})</div>
        {benchmarks.map((b, i) => (
          <div key={i} style={{
            display: 'grid', gridTemplateColumns: '100px 160px 1fr auto', gap: 6,
            alignItems: 'start', marginBottom: 6,
          }}>
            <input value={b.range ?? ''} placeholder="Range"
              onChange={e => { const n = [...benchmarks]; n[i] = { ...b, range: e.target.value }; setBenchmarks(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <input value={b.label ?? ''} placeholder="Label"
              onChange={e => { const n = [...benchmarks]; n[i] = { ...b, label: e.target.value }; setBenchmarks(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4 }} />
            <textarea value={b.detail ?? ''} placeholder="Detail" rows={2}
              onChange={e => { const n = [...benchmarks]; n[i] = { ...b, detail: e.target.value }; setBenchmarks(n) }}
              style={{ padding: '6px 8px', fontSize: 12, border: '1px solid var(--cal-border)', borderRadius: 4, fontFamily: 'var(--font-body)', resize: 'vertical' }} />
            <button type="button"
              onClick={() => setBenchmarks(benchmarks.filter((_, j) => j !== i))}
              style={{ padding: '4px 8px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>×</button>
          </div>
        ))}
        <button type="button"
          onClick={() => setBenchmarks([...benchmarks, { range: '', label: '', detail: '' }])}
          style={{ padding: '4px 10px', fontSize: 11, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 4, cursor: 'pointer', color: 'var(--cal-muted)' }}>+ Add benchmark</button>
      </Subcard>
    </Subcard>
  )
}

function Dim4Body({ content, patch }) {
  const ug  = content?.universityGuide   ?? {}
  const iug = content?.ibUniversityGuide ?? {}
  const ugDests  = Array.isArray(ug.destinations)  ? ug.destinations  : []
  const iugDests = Array.isArray(iug.destinations) ? iug.destinations : []

  const setUg  = fields => patch({ universityGuide:   { ...ug,  ...fields } })
  const setIug = fields => patch({ ibUniversityGuide: { ...iug, ...fields } })
  const setUgDests  = next => setUg({ destinations: next })
  const setIugDests = next => setIug({ destinations: next })

  return (
    <div>
      <Subcard title="New pathway University Guide (IGCSE / AP / WSD)">
        <Field label="Intro">
          <TextArea value={ug.intro} onChange={v => setUg({ intro: v })} rows={3} />
        </Field>
        {ugDests.map((d, i) => (
          <UniversityDestinationEditor
            key={d.id ?? i}
            dest={d}
            kind="new"
            onChange={next => { const n = [...ugDests]; n[i] = next; setUgDests(n) }}
            onRemove={() => setUgDests(ugDests.filter((_, j) => j !== i))}
          />
        ))}
        <button type="button"
          onClick={() => setUgDests([...ugDests, { id: '', label: '', flag: '', howIgcse: '', howAp: '', howWsd: '', verdict: '', topTip: '' }])}
          style={{ padding: '6px 12px', fontSize: 12, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 6, cursor: 'pointer', color: 'var(--cal-muted)', fontFamily: 'var(--font-display)' }}>
          + Add destination
        </button>
      </Subcard>

      <Subcard title="IB Diploma University Guide (for current IB cohorts)">
        <Field label="Intro">
          <TextArea value={iug.intro} onChange={v => setIug({ intro: v })} rows={3} />
        </Field>
        {iugDests.map((d, i) => (
          <UniversityDestinationEditor
            key={d.id ?? i}
            dest={d}
            kind="ib"
            onChange={next => { const n = [...iugDests]; n[i] = next; setIugDests(n) }}
            onRemove={() => setIugDests(iugDests.filter((_, j) => j !== i))}
          />
        ))}
        <button type="button"
          onClick={() => setIugDests([...iugDests, { id: '', label: '', flag: '', detail: '', topTip: '' }])}
          style={{ padding: '6px 12px', fontSize: 12, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 6, cursor: 'pointer', color: 'var(--cal-muted)', fontFamily: 'var(--font-display)' }}>
          + Add destination
        </button>
      </Subcard>

      <IbProgrammeEditor
        value={content?.ibProgramme}
        onChange={v => patch({ ibProgramme: v })}
      />
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Dim 5 — Student Transition (wins + studentVoice)
   ══════════════════════════════════════════════════ */

function Dim5Body({ content, patch }) {
  const st = content?.studentTransition ?? {}
  const wins = Array.isArray(st.wins) ? st.wins : []
  const voice = st.studentVoice ?? {}

  const set      = fields => patch({ studentTransition: { ...st, ...fields } })
  const setWins  = next   => set({ wins: next })
  const setVoice = fields => set({ studentVoice: { ...voice, ...fields } })

  return (
    <div>
      <Subcard title="Headline + intro">
        <Field label="Headline">
          <TextInput value={st.headline} onChange={v => set({ headline: v })} />
        </Field>
        <Field label="Intro">
          <TextArea value={st.intro} onChange={v => set({ intro: v })} rows={3} />
        </Field>
      </Subcard>

      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.08em',
        textTransform: 'uppercase', color: 'var(--cal-muted)',
        fontFamily: 'var(--font-display)', marginBottom: 10,
      }}>
        Wins ({wins.length})
      </div>
      {wins.map((w, i) => (
        <Subcard key={w.id ?? i} title={w.title || `Win ${i + 1}`}>
          <Field label="ID"><TextInput value={w.id} onChange={v => { const n = [...wins]; n[i] = { ...w, id: v }; setWins(n) }} /></Field>
          <Field label="Title"><TextInput value={w.title} onChange={v => { const n = [...wins]; n[i] = { ...w, title: v }; setWins(n) }} /></Field>
          <Field label="Icon (emoji)"><TextInput value={w.icon} onChange={v => { const n = [...wins]; n[i] = { ...w, icon: v }; setWins(n) }} /></Field>
          <Field label="Detail"><TextArea value={w.detail} onChange={v => { const n = [...wins]; n[i] = { ...w, detail: v }; setWins(n) }} rows={4} /></Field>
          <button type="button" onClick={() => setWins(wins.filter((_, j) => j !== i))}
            style={{ padding: '4px 10px', fontSize: 11, border: '1px solid var(--cal-border)', background: '#fff', borderRadius: 4, color: '#B3261E', cursor: 'pointer' }}>Remove win</button>
        </Subcard>
      ))}
      <button type="button"
        onClick={() => setWins([...wins, { id: '', title: '', icon: '', detail: '' }])}
        style={{ padding: '8px 14px', fontSize: 12, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 6, cursor: 'pointer', color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 20 }}>
        + Add win
      </button>

      <Subcard title="Student voice">
        <Field label="Prompt"><TextInput value={voice.prompt} onChange={v => setVoice({ prompt: v })} /></Field>
        <Field label="Response"><TextArea value={voice.response} onChange={v => setVoice({ response: v })} rows={5} /></Field>
      </Subcard>
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Dim 6 — Scenarios + Next Steps
   ══════════════════════════════════════════════════ */

function ScenarioEditor({ scenario, onChange, onRemove }) {
  const en = scenario.en ?? {}
  const set   = (k, v) => onChange({ ...scenario, [k]: v })
  const setEn = fields => onChange({ ...scenario, en: { ...en, ...fields } })

  return (
    <Subcard title={en.title || scenario.id || 'Scenario'}>
      <Field label="ID (slug)"><TextInput value={scenario.id} onChange={v => set('id', v)} /></Field>
      <Field label="Title"><TextInput value={en.title} onChange={v => setEn({ title: v })} /></Field>
      <Field label="Terms in play">
        <StringListEditor values={en.termsInPlay} onChange={v => setEn({ termsInPlay: v })} placeholder="Add term" />
      </Field>
      <Field label="Situation"><TextArea value={en.situation} onChange={v => setEn({ situation: v })} rows={4} /></Field>
      <Field label="With understanding"><TextArea value={en.withUnderstanding} onChange={v => setEn({ withUnderstanding: v })} rows={4} /></Field>
      <Field label="Without understanding"><TextArea value={en.withoutUnderstanding} onChange={v => setEn({ withoutUnderstanding: v })} rows={4} /></Field>

      <div style={{ textAlign: 'right', marginTop: 12 }}>
        <button type="button" onClick={onRemove}
          style={{ padding: '6px 12px', fontSize: 11, border: '1px solid #B3262633', background: '#fff5f5', borderRadius: 4, cursor: 'pointer', color: '#B3261E', fontFamily: 'var(--font-display)' }}>
          Remove scenario
        </button>
      </div>
    </Subcard>
  )
}

function Dim6Body({ content, patch }) {
  const scenarios = Array.isArray(content?.scenarios) ? content.scenarios : []
  const nextSteps = Array.isArray(content?.nextSteps) ? content.nextSteps : []
  const setScenarios = next => patch({ scenarios: next })
  const setNextSteps = next => patch({ nextSteps: next })

  return (
    <div>
      <div style={{
        fontSize: 11, fontWeight: 700, letterSpacing: '0.08em',
        textTransform: 'uppercase', color: 'var(--cal-muted)',
        fontFamily: 'var(--font-display)', marginBottom: 10,
      }}>
        Scenarios ({scenarios.length})
      </div>
      {scenarios.map((s, i) => (
        <ScenarioEditor
          key={s.id ?? i}
          scenario={s}
          onChange={next => { const n = [...scenarios]; n[i] = next; setScenarios(n) }}
          onRemove={() => setScenarios(scenarios.filter((_, j) => j !== i))}
        />
      ))}
      <button type="button"
        onClick={() => setScenarios([...scenarios, { id: '', en: { title: '', termsInPlay: [], situation: '', withUnderstanding: '', withoutUnderstanding: '' } }])}
        style={{ padding: '8px 14px', fontSize: 12, border: '1px dashed var(--cal-border)', background: 'transparent', borderRadius: 6, cursor: 'pointer', color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', marginBottom: 20 }}>
        + Add scenario
      </button>

      <Subcard title="Next steps (paragraphs shown in Next Steps chapter)">
        <ListTextAreaEditor
          values={nextSteps}
          onChange={setNextSteps}
          rows={3}
          placeholder="Add next step"
        />
      </Subcard>
    </div>
  )
}

/* ══════════════════════════════════════════════════
   Top-level component
   ══════════════════════════════════════════════════ */

const DIM_META = {
  1: { title: 'Framing',          sub: 'Meta, director\'s note, opening hook, feedback CTA' },
  2: { title: 'Cohort Guide',     sub: 'The 5 grade cohorts and what changes for each' },
  3: { title: 'Curriculum Cards', sub: 'IGCSE, AP, WSD cards + IGCSE and AP deep dives' },
  4: { title: 'University Guides',sub: 'New pathway + IB Diploma destination guides + IB programme reference' },
  5: { title: 'Student Transition', sub: 'Wins + student voice' },
  6: { title: 'Scenarios + Next Steps', sub: 'Parent scenarios (situation / with / without) + next-step paragraphs' },
}

const DIM_BODIES = {
  1: Dim1Body,
  2: Dim2Body,
  3: Dim3Body,
  4: Dim4Body,
  5: Dim5Body,
  6: Dim6Body,
}

function deepEqual(a, b) {
  if (a === b) return true
  if (typeof a !== typeof b) return false
  if (a === null || b === null) return a === b
  if (typeof a !== 'object') return false
  if (Array.isArray(a) !== Array.isArray(b)) return false
  const ak = Object.keys(a), bk = Object.keys(b)
  if (ak.length !== bk.length) return false
  for (const k of ak) {
    if (!deepEqual(a[k], b[k])) return false
  }
  return true
}

export default function WoodstockEditor({ dimensions, onSaveDimension, onDirtyChange }) {
  // For each dimension we hold {original, draft, saving, saved, error}
  const [state, setState] = useState({})

  // Seed state when the dimensions list changes
  useEffect(() => {
    const seeded = {}
    for (const dim of dimensions ?? []) {
      const content = dim.content ?? {}
      seeded[dim.id] = {
        dimensionNumber: dim.dimension_number,
        original: content,
        draft: content,
        saving: false,
        saved: false,
        error: '',
      }
    }
    setState(seeded)
  }, [dimensions])

  const dirtyMap = useMemo(() => {
    const m = {}
    for (const id of Object.keys(state)) {
      m[id] = !deepEqual(state[id].draft, state[id].original)
    }
    return m
  }, [state])

  const anyDirty = useMemo(() => Object.values(dirtyMap).some(Boolean), [dirtyMap])

  useEffect(() => {
    if (typeof onDirtyChange === 'function') onDirtyChange(anyDirty)
  }, [anyDirty, onDirtyChange])

  const patchDim = (id, fields) => {
    setState(prev => {
      const cur = prev[id]
      if (!cur) return prev
      return {
        ...prev,
        [id]: { ...cur, draft: { ...cur.draft, ...fields }, saved: false, error: '' },
      }
    })
  }

  const discardDim = id => {
    setState(prev => {
      const cur = prev[id]
      if (!cur) return prev
      return {
        ...prev,
        [id]: { ...cur, draft: cur.original, saved: false, error: '' },
      }
    })
  }

  const saveDim = async id => {
    const cur = state[id]
    if (!cur) return
    setState(prev => ({ ...prev, [id]: { ...prev[id], saving: true, error: '', saved: false } }))
    try {
      await onSaveDimension(id, cur.draft)
      setState(prev => ({
        ...prev,
        [id]: { ...prev[id], original: cur.draft, saving: false, saved: true, error: '' },
      }))
    } catch (err) {
      setState(prev => ({
        ...prev,
        [id]: { ...prev[id], saving: false, error: err?.message ?? 'Save failed.' },
      }))
    }
  }

  // Render dimensions in numerical order
  const orderedIds = [...(dimensions ?? [])]
    .sort((a, b) => (a.dimension_number ?? 0) - (b.dimension_number ?? 0))
    .map(d => d.id)

  return (
    <div>
      <div style={{
        background: '#F6F2EC', border: '1px solid var(--cal-border)',
        borderRadius: 10, padding: 14, marginBottom: 20, fontSize: 12,
        color: 'var(--cal-ink-soft)', lineHeight: 1.6,
      }}>
        <strong style={{ fontFamily: 'var(--font-display)', color: 'var(--cal-teal)' }}>
          Woodstock schema editor.
        </strong>{' '}
        Each section below is one pd_dimensions row (dimension_number 1–6). Fields are typed per
        Woodstock's schema — no JSON editing required. Each section saves independently.
      </div>

      {orderedIds.map(id => {
        const s = state[id]
        if (!s) return null
        const Body = DIM_BODIES[s.dimensionNumber]
        const meta = DIM_META[s.dimensionNumber]
        if (!Body || !meta) {
          return (
            <Section
              key={id}
              dimNumber={s.dimensionNumber ?? '?'}
              title={`Dimension ${s.dimensionNumber ?? '?'} (no form)`}
              sub="No Woodstock form defined for this dimension — edit via dimension JSON if needed."
              dirty={false}
            />
          )
        }
        return (
          <Section
            key={id}
            dimNumber={s.dimensionNumber}
            title={meta.title}
            sub={meta.sub}
            dirty={dirtyMap[id]}
            saving={s.saving}
            saved={s.saved}
            error={s.error}
            onSave={() => saveDim(id)}
            onDiscard={() => discardDim(id)}
          >
            <Body
              content={s.draft}
              patch={fields => patchDim(id, fields)}
            />
          </Section>
        )
      })}
    </div>
  )
}
