/* Habterra logo — mark + wordmark */
export default function Logo({ size = 'md', theme = 'light', showTagline = false }) {
  const sizes = {
    sm: { mark: 22, word: 18, tag: 10 },
    md: { mark: 32, word: 26, tag: 12 },
    lg: { mark: 48, word: 40, tag: 14 },
  }
  const s = sizes[size] || sizes.md

  const markColor  = theme === 'light' ? 'var(--cal-teal)'  : 'var(--cal-amber)'
  const wordColor  = theme === 'light' ? 'var(--cal-teal)'  : '#FFFFFF'
  const tagColor   = theme === 'light' ? 'var(--cal-muted)' : 'rgba(255,255,255,0.5)'

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
        {/* Habterra mark — rooted presence on layered ground */}
        <svg
          width={s.mark}
          height={s.mark}
          viewBox="0 0 40 40"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          style={{ flexShrink: 0 }}
        >
          {/* Deeper context layer — the ground beneath the ground */}
          <path
            d="M 4 32 Q 20 23, 36 32"
            stroke={markColor}
            strokeWidth="1.8"
            strokeLinecap="round"
            opacity="0.42"
            fill="none"
          />
          {/* Primary horizon — the ground we stand on */}
          <path
            d="M 4 27 Q 20 15, 36 27"
            stroke={markColor}
            strokeWidth="2.4"
            strokeLinecap="round"
            fill="none"
          />
          {/* Inhabitant — the rooted presence at the apex */}
          <circle cx="20" cy="16" r="5" fill={markColor} />
          {/* Subtle inner highlight — reads as dimension at larger sizes, invisible at favicon */}
          <circle cx="18.6" cy="14.8" r="1.2" fill="var(--cal-white)" opacity="0.22" />
        </svg>

        {/* Wordmark */}
        <span style={{
          fontFamily: 'var(--font-display)',
          fontSize: s.word,
          fontWeight: 700,
          letterSpacing: '-0.02em',
          color: wordColor,
          lineHeight: 1,
        }}>
          Habterra
        </span>
      </div>

      {showTagline && (
        <span style={{
          fontFamily: 'var(--font-body)',
          fontSize: s.tag,
          fontStyle: 'italic',
          fontWeight: 300,
          color: tagColor,
          paddingLeft: s.mark + 10,
          letterSpacing: '0.01em',
        }}>
          Find your footing.
        </span>
      )}
    </div>
  )
}
