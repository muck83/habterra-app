/**
 * ErrorState — consistent error/timeout UI used across Dashboard, Progress, and ModuleView.
 *
 * Props:
 *   error   — string message or the sentinel 'timeout'
 *   onRetry — optional callback; if absent, no retry button is shown
 *   context — short noun for the timeout message, e.g. 'your modules' or 'module content'
 */
export default function ErrorState({ error, onRetry, context = 'content' }) {
  const isTimeout = error === 'timeout'

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '64px 40px',
      textAlign: 'center',
    }}>
      {/* Icon */}
      <div style={{
        width: 56, height: 56,
        borderRadius: '50%',
        background: isTimeout ? 'var(--cal-amber-lt)' : '#FEF2F2',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 26, marginBottom: 18,
      }}>
        {isTimeout ? '⏱' : '⚠'}
      </div>

      {/* Heading */}
      <div style={{
        fontFamily: 'var(--font-display)',
        fontSize: 16,
        fontWeight: 700,
        color: 'var(--cal-ink)',
        marginBottom: 10,
      }}>
        {isTimeout
          ? `Loading ${context} is taking too long`
          : 'Something went wrong'}
      </div>

      {/* Detail */}
      <div style={{
        fontSize: 13,
        color: 'var(--cal-muted)',
        maxWidth: 360,
        lineHeight: 1.75,
        marginBottom: onRetry ? 24 : 0,
      }}>
        {isTimeout
          ? 'This usually means a slow connection or a brief server hiccup. Check your internet and try again.'
          : (error && error !== 'timeout')
            ? error
            : 'An unexpected error occurred. Please try again.'}
      </div>

      {/* Retry button */}
      {onRetry && (
        <button
          onClick={onRetry}
          className="btn btn-primary"
          style={{ fontSize: 13, padding: '10px 24px' }}
        >
          Try again
        </button>
      )}
    </div>
  )
}
