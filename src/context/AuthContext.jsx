import { createContext, useContext, useEffect, useState } from 'react'
import { supabase, getProfile } from '../lib/supabase'

/* ─────────────────────────────────────────────────────────────
   Mock session — used when VITE_MOCK_MODE=true. Lets the whole
   UI run without any credentials.
   This used to be inferred from a missing VITE_SUPABASE_URL, but
   that meant a deploy that forgot the env var would silently boot
   into mock mode with mock-admin as the default persona. The flag
   is now explicit and a prod-build guard (main.jsx) throws if it
   is ever true in a production build.
   ───────────────────────────────────────────────────────────── */
const MOCK_MODE = import.meta.env.VITE_MOCK_MODE === 'true'

const MOCK_PROFILES = {
  teacher: {
    id: 'mock-teacher',
    email: 'schen@nlis.edu.sa',
    full_name: 'Sarah Chen',
    role: 'teacher',
    school_id: 'school-nlis',
    school: { id: 'school-nlis', name: 'NLIS Riyadh', domain: 'nlis.edu.sa' },
  },
  admin: {
    id: 'mock-admin',
    email: 'admin@nlis.edu.sa',
    full_name: 'PD Coordinator',
    role: 'admin',
    school_id: 'school-nlis',
    school: { id: 'school-nlis', name: 'NLIS Riyadh', domain: 'nlis.edu.sa' },
  },
  parent: {
    id: 'mock-parent',
    email: 'liwei@nlis.edu.sa',
    full_name: 'Li Wei',
    role: 'parent',
    school_id: 'school-nlis',
    school: { id: 'school-nlis', name: 'NLIS Riyadh', domain: 'nlis.edu.sa' },
  },
  superadmin: {
    id: 'mock-superadmin',
    email: 'mark@calibrate.local',
    full_name: 'Super Admin',
    role: 'superadmin',
    school_id: null,
    school: null,
  },
}

const MOCK_SESSION = {
  user: { id: 'mock-admin', email: 'admin@nlis.edu.sa' },
}

/* ─────────────────────────────────────────────────────────────
   Context
   ───────────────────────────────────────────────────────────── */
const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [session, setSession]   = useState(MOCK_MODE ? undefined : undefined)
  const [profile, setProfile]   = useState(null)
  const [loading, setLoading]   = useState(true)
  // In mock mode, allow switching persona for development
  const [mockRole, setMockRole] = useState('admin')

  useEffect(() => {
    if (MOCK_MODE) {
      // Simulate a brief auth check delay
      const t = setTimeout(() => {
        setSession(MOCK_SESSION)
        setProfile(MOCK_PROFILES[mockRole])
        setLoading(false)
      }, 300)
      return () => clearTimeout(t)
    }

    // Real Supabase auth
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      if (session) loadProfile(session.user.id)
      else setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
      if (session) loadProfile(session.user.id)
      else { setProfile(null); setLoading(false) }
    })

    return () => subscription.unsubscribe()
  }, [mockRole])

  async function loadProfile(userId) {
    try {
      const p = await getProfile(userId)
      setProfile(p)
    } catch (err) {
      console.error('Failed to load profile:', err)
    } finally {
      setLoading(false)
    }
  }

  const value = {
    session,
    profile,
    loading,
    user:        session?.user ?? null,
    role:        profile?.role ?? null,
    school:      profile?.school ?? null,
    // Superadmin is a strict superset of admin — if we did not widen this check,
    // promoting marktcrowell@gmail.com to 'superadmin' would silently strip
    // /admin access. Keep both flags explicit so guards stay readable.
    isAdmin:      profile?.role === 'admin' || profile?.role === 'superadmin',
    isSuperAdmin: profile?.role === 'superadmin',
    isMockMode:   MOCK_MODE,
    // Dev helper — only available in mock mode
    switchMockRole: MOCK_MODE ? (role) => { setMockRole(role); setProfile(null); setLoading(true) } : undefined,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider')
  return ctx
}
