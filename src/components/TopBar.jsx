import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { signOut } from '../lib/supabase'
import { useAuth } from '../context/AuthContext'
import Logo from './Logo'

export default function TopBar({ activePage = 'modules' }) {
  const { profile, school, isAdmin, isSuperAdmin } = useAuth()
  const navigate = useNavigate()
  const [menuOpen, setMenuOpen] = useState(false)

  const initials = profile?.full_name
    ? profile.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : profile?.email?.[0]?.toUpperCase() ?? '?'

  async function handleSignOut() {
    await signOut()
    navigate('/login')
  }

  return (
    <header style={{
      background: 'var(--cal-teal)',
      height: 'var(--topbar-h)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 24px',
      flexShrink: 0,
      position: 'relative',
      zIndex: 10,
    }}>
      <Logo size="sm" theme="dark" />

      <nav style={{ display: 'flex', gap: 4 }}>
        {[
          { key: 'modules',  label: 'My Modules', path: '/dashboard' },
          { key: 'progress', label: 'Progress',    path: '/progress' },
          ...(isAdmin      ? [{ key: 'admin',      label: 'Admin',      path: '/admin'      }] : []),
          ...(isSuperAdmin ? [{ key: 'superadmin', label: 'Superadmin', path: '/superadmin' }] : []),
        ].map(item => (
          <button
            key={item.key}
            onClick={() => navigate(item.path)}
            style={{
              fontFamily: 'var(--font-display)',
              fontSize: 12,
              fontWeight: 500,
              color: activePage === item.key ? '#fff' : 'rgba(255,255,255,0.58)',
              background: activePage === item.key ? 'rgba(255,255,255,0.12)' : 'transparent',
              border: 'none',
              borderRadius: 'var(--r-sm)',
              padding: '6px 13px',
              cursor: 'pointer',
              transition: 'background 0.15s, color 0.15s',
            }}
          >
            {item.label}
          </button>
        ))}
      </nav>

      <div style={{ display: 'flex', alignItems: 'center', gap: 10, position: 'relative' }}>
        {school && (
          <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.55)' }}>
            {school.name}
          </span>
        )}
        <button
          onClick={() => setMenuOpen(o => !o)}
          style={{
            width: 30, height: 30,
            borderRadius: '50%',
            background: 'var(--cal-amber)',
            border: 'none',
            cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--font-display)',
            fontSize: 11, fontWeight: 700,
            color: '#fff',
          }}
        >
          {initials}
        </button>

        {menuOpen && (
          <div style={{
            position: 'absolute',
            top: '100%',
            right: 0,
            marginTop: 8,
            background: '#fff',
            borderRadius: 'var(--r-md)',
            boxShadow: 'var(--shadow-lg)',
            minWidth: 180,
            overflow: 'hidden',
            zIndex: 100,
          }}>
            <div style={{ padding: '12px 16px', borderBottom: '1px solid var(--cal-border-lt)' }}>
              <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)' }}>
                {profile?.full_name || profile?.email}
              </div>
              <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginTop: 2 }}>
                {profile?.role}
              </div>
            </div>
            <button
              onClick={handleSignOut}
              style={{
                width: '100%',
                padding: '11px 16px',
                textAlign: 'left',
                background: 'transparent',
                border: 'none',
                cursor: 'pointer',
                fontSize: 13,
                color: 'var(--cal-ink)',
                fontFamily: 'var(--font-body)',
              }}
            >
              Sign out
            </button>
          </div>
        )}
      </div>
    </header>
  )
}
