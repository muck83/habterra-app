import { cellStatus } from '../utils'

/* One cell in the completion matrix. Shows ✓ / % / ○ / — based on pct. */
export default function CompletionCell({ pct }) {
  const status = cellStatus(pct ?? -1)

  if (pct === undefined || pct === null || pct === -1) {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <span style={{ color: '#C8C4BE', fontSize: 14 }}>—</span>
      </td>
    )
  }

  if (status === 'done') {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <div style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          width: 28, height: 28, borderRadius: '50%',
          background: 'var(--cal-success-lt)',
        }}>
          <span style={{ fontSize: 13, color: 'var(--cal-success)' }}>✓</span>
        </div>
      </td>
    )
  }

  if (status === 'progress') {
    return (
      <td style={{ textAlign: 'center', padding: '10px 8px' }}>
        <div style={{
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          width: 28, height: 28, borderRadius: '50%',
          background: 'var(--cal-amber-lt)',
          fontFamily: 'var(--font-display)', fontSize: 9, fontWeight: 700,
          color: 'var(--cal-amber-dark)',
        }}>
          {pct}%
        </div>
      </td>
    )
  }

  return (
    <td style={{ textAlign: 'center', padding: '10px 8px' }}>
      <div style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        width: 28, height: 28, borderRadius: '50%',
        background: 'var(--cal-border-lt)',
        fontSize: 12, color: 'var(--cal-border)',
      }}>
        ○
      </div>
    </td>
  )
}
