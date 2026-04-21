import { MODULE_META } from '../../../data/mockData'
import { MOCK_MODE } from '../utils'

/* Admin → Analytics tab. Quiz analytics sorted hardest-first, with a
   warning banner when too many questions are below the 60% threshold. */
export default function AnalyticsView({
  analyticsSlug,
  setAnalyticsSlug,
  analyticsData,
  analyticsLoading,
  analyticsError,
}) {
  const rows = (analyticsData ?? [])
    .slice()
    .sort((a, b) => (a.correct / Math.max(a.n, 1)) - (b.correct / Math.max(b.n, 1))) // hardest first
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
}
