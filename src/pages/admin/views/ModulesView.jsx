import { MODULE_META } from '../../../data/mockData'

/* Admin → Modules tab.
   Per-module card grid: preview, assign, (superadmin) edit content,
   and remove-from-school. Pure presentational — the remove handler
   lives in the shell and is injected via onRemoveFromSchool. */
export default function ModulesView({
  navigate,
  schoolName,
  isSuperAdmin,
  assignments,
  setAssignForm,
  setAdminView,
  onRemoveFromSchool,
}) {
  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', gap: 12, marginBottom: 20, flexWrap: 'wrap' }}>
        <div>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Modules</h2>
          <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
            Preview each module as a learner sees it, edit its content, and add or remove it from {schoolName}.
          </p>
        </div>
        {isSuperAdmin && (
          <button
            type="button"
            onClick={() => navigate('/superadmin')}
            className="btn"
            style={{ fontSize: 12, fontWeight: 600, padding: '9px 16px', background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-full)' }}
          >
            Open module editor →
          </button>
        )}
      </div>

      <div style={{
        background: '#FFF8E1', border: '1px solid #FFE082', color: '#7C5A00',
        borderRadius: 'var(--r-sm)', padding: '10px 14px', marginBottom: 20,
        fontSize: 12, lineHeight: 1.55,
      }}>
        <strong>Heads up:</strong> Module content is defined in code. Editing prose and structure is a superadmin task in the <em>module editor</em>.
        Admins can preview, assign, and remove modules for their school here. To request a brand-new module, reach out to the Habterra team.
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: 16 }}>
        {Object.entries(MODULE_META).map(([slug, meta]) => {
          const schoolAssignments = assignments.filter(a => a.module_slug === slug)
          const isActive = schoolAssignments.length > 0
          return (
            <div key={slug} style={{
              background: '#fff', borderRadius: 'var(--r-lg)',
              border: '1px solid var(--cal-border-lt)', boxShadow: 'var(--shadow-sm)',
              padding: 18, display: 'flex', flexDirection: 'column', gap: 12,
            }}>
              <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 10 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{ fontSize: 28 }}>{meta.flag}</span>
                  <div>
                    <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 700, color: 'var(--cal-ink)' }}>
                      {meta.label}
                    </div>
                    <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>{meta.lang} · {slug}</div>
                  </div>
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 4, alignItems: 'flex-end' }}>
                  <span style={{
                    fontSize: 9, fontWeight: 700, letterSpacing: '0.08em',
                    padding: '2px 7px', borderRadius: 'var(--r-full)',
                    background: isActive ? 'var(--cal-success-lt)' : 'var(--cal-surface)',
                    color: isActive ? 'var(--cal-success)' : 'var(--cal-muted)',
                    textTransform: 'uppercase',
                  }}>
                    {isActive ? `${schoolAssignments.length} assigned` : 'Not assigned'}
                  </span>
                </div>
              </div>
              {meta.desc && (
                <div style={{ fontSize: 12, color: 'var(--cal-ink-soft)', lineHeight: 1.5 }}>
                  {meta.desc}
                </div>
              )}
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 'auto' }}>
                <button
                  type="button"
                  onClick={() => window.open(`/module/${slug}`, '_blank', 'noopener')}
                  className="btn"
                  style={{ fontSize: 11, padding: '6px 10px', background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-sm)' }}
                  title="Open the learner view for this module in a new tab"
                >
                  Preview
                </button>
                <button
                  type="button"
                  onClick={() => {
                    setAssignForm(f => ({ ...f, moduleSlug: slug }))
                    setAdminView('assign')
                  }}
                  className="btn"
                  style={{ fontSize: 11, padding: '6px 10px', background: 'transparent', color: 'var(--cal-ink)', border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)' }}
                >
                  Assign
                </button>
                {isSuperAdmin && (
                  <button
                    type="button"
                    onClick={() => navigate(`/superadmin?module=${encodeURIComponent(meta.dbId ?? slug)}`)}
                    className="btn"
                    style={{ fontSize: 11, padding: '6px 10px', background: 'transparent', color: 'var(--cal-ink)', border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)' }}
                    title="Edit module title, tagline, preamble, and structured content"
                  >
                    Edit content
                  </button>
                )}
                {isActive && (
                  <button
                    type="button"
                    onClick={() => onRemoveFromSchool(slug, meta, schoolAssignments)}
                    className="btn"
                    style={{ fontSize: 11, padding: '6px 10px', background: 'transparent', color: '#C62828', border: '1px solid #F5C2C7', borderRadius: 'var(--r-sm)' }}
                  >
                    Remove from school
                  </button>
                )}
              </div>
            </div>
          )
        })}
      </div>
    </>
  )
}
