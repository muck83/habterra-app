import { useNavigate } from 'react-router-dom'

const MODULE_META = {
  'india-ib':             { flag: 'IN', label: 'Understand India',                   lang: 'EN / HI',      desc: 'CBSE, board exams, and percentage culture - what IB looks like from a family inside that world.' },
  'korea-ib':             { flag: 'KR', label: 'Understand Korea',                   lang: 'EN / KO',      desc: 'Suneung pressure, class rankings, and what a Korean parent expects from a teacher relationship.', inDev: true },
  'ksa-ib':               { flag: 'SA', label: 'Understand Saudi Arabia',            lang: 'EN / AR',      desc: 'Tawjihiyya, family expectations, and navigating IB in a Gulf context.', inDev: true },
  'china-ib':             { flag: 'CN', label: 'Understand China',                   lang: 'EN / ZH',      desc: 'Gaokao culture, collective family ambition, and what "no ranking" means to a Chinese parent.', inDev: true },
  'vietnam-ib':           { flag: 'VN', label: 'Understand Vietnam',                 lang: 'EN / VI',      desc: "THPTQG culture and the Vietnamese parent's relationship with academic achievement.", inDev: true },
  'japan-ib':             { flag: 'JP', label: 'Understand Japan',                   lang: 'EN / JA',      desc: 'Gakureki society, juku culture, and the Japanese parent inside an international curriculum.', inDev: true },
  'woodstock-transition': { flag: 'WS', label: 'Woodstock Curriculum Transition',    lang: 'EN',           desc: 'IGCSE, AP, and WSD - what the transition means for every cohort, and how to talk about it.', isParent: true },
  'indonesia-ib':         { flag: 'ID', label: 'Understand Indonesia',               lang: 'EN / ID',      desc: "UTBK pressure, face dynamics, and the faith dimension in one of the world's most diverse school communities.", inDev: true },
  'uae-ib':               { flag: 'AE', label: 'Understand UAE',                     lang: 'EN / AR',      desc: 'Wasta, school choice as social capital, and the Emirati family inside a global curriculum.', inDev: true },
}

export default function ModuleCard({ assignment, completion, onRemove = null }) {
  const navigate = useNavigate()
  const meta     = MODULE_META[assignment.module_slug] ?? {
    flag: '--', label: assignment.module_slug, lang: 'EN', desc: '',
  }
  const pct     = completion?.progress_pct ?? 0
  const done    = !!completion?.completed_at
  const started = pct > 0

  let statusLabel, statusClass, fillClass, btnLabel, btnBg
  if (done) {
    statusLabel = 'Complete';    statusClass = 'badge-done';     fillClass = 'green'; btnLabel = 'Review';   btnBg = '#43A047'
  } else if (started) {
    statusLabel = 'In progress'; statusClass = 'badge-progress'; fillClass = 'amber'; btnLabel = 'Continue'; btnBg = 'var(--cal-amber)'
  } else {
    statusLabel = 'Assigned';    statusClass = 'badge-assigned'; fillClass = '';      btnLabel = 'Start';    btnBg = 'var(--cal-teal)'
  }

  const dueStr = assignment.due_date
    ? new Date(assignment.due_date).toLocaleDateString('en-GB', { day: 'numeric', month: 'short' })
    : null

  const handleOpen = () => {
    navigate(`/module/${assignment.module_slug}`)
  }

  return (
    <div className="card" style={{ padding: 20, display: 'flex', flexDirection: 'column', gap: 0, position: 'relative' }}>
      {onRemove && (
        <button
          type="button"
          onClick={e => { e.stopPropagation(); onRemove() }}
          aria-label="Remove this assignment"
          title="Remove this assignment"
          style={{
            position: 'absolute', top: 8, right: 8,
            width: 22, height: 22, borderRadius: '50%',
            border: '1px solid var(--cal-border)',
            background: '#fff', color: 'var(--cal-muted)',
            fontSize: 13, lineHeight: 1,
            cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            padding: 0,
            zIndex: 2,
          }}
        >×</button>
      )}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
        <span style={{
          fontFamily: 'var(--font-display)',
          fontSize: 12,
          fontWeight: 700,
          letterSpacing: '0.08em',
          color: 'var(--cal-teal)',
          background: 'var(--cal-surface)',
          padding: '4px 8px',
          borderRadius: 'var(--r-sm)',
          border: '1px solid var(--cal-border)',
        }}>{meta.flag}</span>
        <span className={`badge ${statusClass}`} style={{ marginRight: onRemove ? 28 : 0 }}>{statusLabel}</span>
      </div>

      <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-teal)', marginBottom: 2 }}>
        {meta.label}
      </div>
      <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginBottom: 10 }}>
        {meta.isParent ? 'Parent Guide' : 'IB Guide'} - {meta.lang}
      </div>

      <div style={{ fontSize: 12, color: 'var(--cal-ink-soft)', lineHeight: 1.55, marginBottom: 14, flexGrow: 1 }}>
        {meta.desc}
      </div>

      <div className="progress-track" style={{ marginBottom: 8 }}>
        <div className={`progress-fill ${fillClass}`} style={{ width: `${pct}%` }} />
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', fontSize: 10, color: 'var(--cal-muted)' }}>
        <span>{done ? 'Complete' : `${pct}% complete`}</span>
        {dueStr && <span>Due {dueStr}</span>}
      </div>

      <button
        className="btn"
        onClick={handleOpen}
        style={{ marginTop: 14, background: btnBg, color: '#fff', padding: '9px 16px', fontSize: 12 }}
      >
        {btnLabel}
      </button>
    </div>
  )
}
