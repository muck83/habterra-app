import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import Landing        from './pages/Landing'
import Login          from './pages/Login'
import Dashboard      from './pages/Dashboard'
import AdminDashboard from './pages/AdminDashboard'
import SuperAdminDashboard from './pages/SuperAdminDashboard'
import Progress       from './pages/Progress'
import ModuleView     from './pages/ModuleView'
import CertificatePage from './pages/CertificatePage'
import DevBar         from './components/DevBar'

/* ── Route guards ── */

function RequireAuth({ children }) {
  const { session, loading } = useAuth()
  if (loading)  return <LoadingScreen />
  if (!session) return <Navigate to="/login" replace />
  return children
}

function RequireAdmin({ children }) {
  const { session, loading, isAdmin } = useAuth()
  if (loading)   return <LoadingScreen />
  if (!session)  return <Navigate to="/login"     replace />
  if (!isAdmin)  return <Navigate to="/dashboard" replace />
  return children
}

function SuperAdminRoute({ children }) {
  const { session, loading, isSuperAdmin } = useAuth()
  if (loading)       return <LoadingScreen />
  if (!session)      return <Navigate to="/login"     replace />
  if (!isSuperAdmin) return <Navigate to="/dashboard" replace />
  return children
}

function RedirectIfAuthed({ children }) {
  const { session, loading } = useAuth()
  if (loading)  return <LoadingScreen />
  // Exception: don't redirect when /login is handling a password-recovery
  // or invite callback — Supabase-js creates a session from the hash, and
  // if we bounce on session-present the user never sees the "set your
  // password" form. Login.jsx's recovery mode owns these URLs.
  if (session && typeof window !== 'undefined') {
    const hash   = window.location.hash
    const search = window.location.search
    const isRecoveryCallback =
      hash.includes('type=recovery') ||
      hash.includes('type=invite')   ||
      hash.includes('type=signup')   ||
      hash.includes('access_token=') ||
      search.includes('recovery=1')
    if (isRecoveryCallback) return children
  }
  if (session)  return <Navigate to="/dashboard" replace />
  return children
}

function LoadingScreen() {
  return (
    <div style={{
      height: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'var(--cal-off)',
    }}>
      <div style={{ textAlign: 'center' }}>
        <svg width="40" height="40" viewBox="0 0 40 40" fill="none" style={{ marginBottom: 16, opacity: 0.4, animation: 'spin 2s linear infinite' }}>
          <circle cx="20" cy="20" r="17" stroke="var(--cal-teal)" strokeWidth="2" />
          <line x1="20" y1="4"  x2="20" y2="11" stroke="var(--cal-teal)" strokeWidth="2" strokeLinecap="round" />
          <line x1="20" y1="29" x2="20" y2="36" stroke="var(--cal-teal)" strokeWidth="2" strokeLinecap="round" />
          <line x1="4"  y1="20" x2="11" y2="20" stroke="var(--cal-teal)" strokeWidth="2" strokeLinecap="round" />
          <line x1="29" y1="20" x2="36" y2="20" stroke="var(--cal-teal)" strokeWidth="2" strokeLinecap="round" />
          <circle cx="20" cy="20" r="3" fill="var(--cal-teal)" />
        </svg>
        <div style={{ fontFamily: 'var(--font-display)', fontSize: 13, color: 'var(--cal-muted)' }}>
          Loading…
        </div>
      </div>
      <style>{`@keyframes spin { from { transform: rotate(0deg) } to { transform: rotate(360deg) } }`}</style>
    </div>
  )
}

/* ── App ── */

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Public — marketing landing page. Authed users get bounced
              to /dashboard so a returning teacher never lands on the
              marketing site. */}
          <Route
            path="/"
            element={
              <RedirectIfAuthed>
                <Landing />
              </RedirectIfAuthed>
            }
          />
          <Route
            path="/login"
            element={
              <RedirectIfAuthed>
                <Login />
              </RedirectIfAuthed>
            }
          />

          {/* Protected — all authenticated users */}
          <Route
            path="/dashboard"
            element={
              <RequireAuth>
                <Dashboard />
              </RequireAuth>
            }
          />
          <Route
            path="/progress"
            element={
              <RequireAuth>
                <Progress />
              </RequireAuth>
            }
          />
          <Route
            path="/module/:slug"
            element={
              <RequireAuth>
                <ModuleView />
              </RequireAuth>
            }
          />

          <Route
            path="/certificate/:slug"
            element={
              <RequireAuth>
                <CertificatePage />
              </RequireAuth>
            }
          />

          {/* Protected — admin only */}
          <Route
            path="/admin"
            element={
              <RequireAdmin>
                <AdminDashboard />
              </RequireAdmin>
            }
          />

          {/* Protected — superadmin only */}
          <Route
            path="/superadmin"
            element={
              <SuperAdminRoute>
                <SuperAdminDashboard />
              </SuperAdminRoute>
            }
          />
          {/* Fallback — send unknown paths back to the landing page.
              RedirectIfAuthed there handles the authed case by bouncing
              to /dashboard, so both audiences land somewhere sensible. */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
        <DevBar />
      </BrowserRouter>
    </AuthProvider>
  )
}
