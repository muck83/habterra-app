/* Dev persona switcher — only renders in mock mode, never in production */
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

export default function DevBar() {
  const { isMockMode, switchMockRole, profile } = useAuth()
  const navigate = useNavigate()

  if (!isMockMode) return null

  return (
    <div style={{
      position: 'fixed', bottom: 16, right: 16, zIndex: 9999,
      background: '#1A1C1E', borderRadius: 10, padding: '10px 14px',
      display: 'flex', alignItems: 'center', gap: 10,
      boxShadow: '0 4px 20px rgba(0,0,0,0.3)',
      fontFamily: 'var(--font-display)', fontSize: 11,
    }}>
      <span style={{ color: 'var(--cal-amber)', fontWeight: 700, letterSpacing: '0.1em' }}>
        DEV
      </span>
      <span style={{ color: 'rgba(255,255,255,0.4)' }}>|</span>
      <span style={{ color: 'rgba(255,255,255,0.5)', marginRight: 4 }}>
        Viewing as:
      </span>
      {['admin', 'superadmin', 'teacher', 'parent'].map(role => (
        <button
          key={role}
          onClick={() => {
            switchMockRole(role)
            navigate(role === 'admin' ? '/admin' : role === 'superadmin' ? '/superadmin' : '/dashboard')
          }}
          style={{
            padding: '4px 10px', borderRadius: 6, border: 'none', cursor: 'pointer',
            fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 600,
            background: profile?.role === role ? 'var(--cal-teal)' : 'rgba(255,255,255,0.1)',
            color: profile?.role === role ? '#fff' : 'rgba(255,255,255,0.6)',
            transition: 'all 0.15s', textTransform: 'capitalize',
          }}
        >
          {role}
        </button>
      ))}
    </div>
  )
}
