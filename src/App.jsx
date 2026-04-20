import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
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
        {/* Animated reticle */}
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
          {/* Public */}
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
          {/* Fallback */}
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
        <DevBar />
      </BrowserRouter>
    </AuthProvider>
  )
}
