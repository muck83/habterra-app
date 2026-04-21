/* Small KPI tile used across the Overview header. */
export default function StatCard({ value, label, sub, accent }) {
  return (
    <div style={{
      background: '#fff',
      borderRadius: 'var(--r-lg)',
      padding: '20px 22px',
      boxShadow: 'var(--shadow-sm)',
      borderTop: `3px solid ${accent}`,
      flex: 1,
      minWidth: 0,
    }}>
      <div style={{ fontFamily: 'var(--font-display)', fontSize: 32, fontWeight: 800, color: accent, lineHeight: 1, marginBottom: 6 }}>
        {value}
      </div>
      <div style={{ fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 2 }}>
        {label}
      </div>
      {sub && <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>{sub}</div>}
    </div>
  )
}
