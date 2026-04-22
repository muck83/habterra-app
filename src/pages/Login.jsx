import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { signIn, resetPasswordForEmail, updateMyPassword, supabase } from '../lib/supabase'
import Logo from '../components/Logo'

export default function Login() {
  const navigate              = useNavigate()
  const [email, setEmail]     = useState('')
  const [pass,  setPass]      = useState('')
  const [error, setError]     = useState('')
  const [loading, setLoading] = useState(false)
  const [forgotMode, setForgotMode]     = useState(false)
  const [resetSent,  setResetSent]      = useState(false)

  // Recovery mode — shown when the user lands on /login from a password-reset
  // or invite email. Supabase-js parses the #access_token=…&type=recovery hash
  // from the URL and fires the PASSWORD_RECOVERY event; we also fall back to
  // ?recovery=1 and the hash itself so a returning user can't get stranded on
  // the normal sign-in form.
  const [recoveryMode,  setRecoveryMode]  = useState(false)
  const [newPass,       setNewPass]       = useState('')
  const [newPass2,      setNewPass2]      = useState('')
  const [recoverySaved, setRecoverySaved] = useState(false)

  useEffect(() => {
    // Heuristic triggers — either the URL has recovery=1 or the hash carries
    // an access_token + type=recovery / type=invite / type=signup.
    const hash   = typeof window !== 'undefined' ? window.location.hash  : ''
    const search = typeof window !== 'undefined' ? window.location.search : ''
    const hashLooksLikeRecovery =
      hash.includes('type=recovery') ||
      hash.includes('type=invite')   ||
      hash.includes('type=signup')   ||
      hash.includes('access_token=')
    if (search.includes('recovery=1') || hashLooksLikeRecovery) {
      setRecoveryMode(true)
    }

    // Authoritative trigger: Supabase fires PASSWORD_RECOVERY after it parses
    // the hash and establishes the recovery session. Listening for it covers
    // the invite/reset flows regardless of which query/hash shape landed us
    // here.
    const { data: sub } = supabase.auth.onAuthStateChange((event) => {
      if (event === 'PASSWORD_RECOVERY') {
        setRecoveryMode(true)
      }
    })
    return () => { sub?.subscription?.unsubscribe?.() }
  }, [])

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      // Normalise email to lowercase — auth.users stores emails lowercase,
      // and some gotrue builds do a case-sensitive match at sign-in. Typing
      // "MarkWindsor@…" against a stored "markwindsor@…" would otherwise
      // fail with a generic "Invalid login credentials" error.
      await signIn(email.trim().toLowerCase(), pass)
      navigate('/dashboard')
    } catch (err) {
      setError(err.message ?? 'Sign-in failed. Please check your credentials.')
    } finally {
      setLoading(false)
    }
  }

  async function handleForgotPassword(e) {
    e.preventDefault()
    setError('')
    setLoading(true)
    try {
      await resetPasswordForEmail(email.trim().toLowerCase())
      setResetSent(true)
    } catch (err) {
      setError(err.message ?? 'Could not send reset email. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  async function handleSetNewPassword(e) {
    e.preventDefault()
    setError('')
    if (newPass.length < 8) {
      setError('Password must be at least 8 characters.')
      return
    }
    if (newPass !== newPass2) {
      setError('The two passwords don\'t match.')
      return
    }
    setLoading(true)
    try {
      await updateMyPassword(newPass)
      setRecoverySaved(true)
      // Clean the hash/query so a refresh doesn't re-trigger recovery mode,
      // then send the user into the app — they're already signed in on the
      // recovery session.
      if (typeof window !== 'undefined') {
        window.history.replaceState(null, '', window.location.pathname)
      }
      setTimeout(() => navigate('/dashboard'), 1200)
    } catch (err) {
      setError(err.message ?? 'Could not save new password. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-split" style={{ display: 'flex', height: '100vh', overflow: 'hidden' }}>

      {/* ── Left panel: brand ── */}
      <div className="login-brand" style={{
        width: '42%',
        background: 'var(--cal-teal)',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between',
        padding: '48px 52px',
        position: 'relative',
        overflow: 'hidden',
        flexShrink: 0,
      }}>
        {/* Decorative rings */}
        <div style={{ position: 'absolute', right: -100, top: -100, width: 420, height: 420, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.07)' }} />
        <div style={{ position: 'absolute', right: -30,  top: -30,  width: 260, height: 260, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.1)'  }} />
        <div style={{ position: 'absolute', left: -80, bottom: -80, width: 340, height: 340, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.06)' }} />

        {/* Logo */}
        <Logo size="lg" theme="dark" />

        {/* Centre copy */}
        <div style={{ position: 'relative', zIndex: 1 }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 36, fontWeight: 700, color: '#fff', lineHeight: 1.15, letterSpacing: '-0.02em', marginBottom: 16 }}>
            Before you<br />walk in.
          </div>
          <div style={{ fontSize: 14, color: 'rgba(255,255,255,0.62)', lineHeight: 1.75, maxWidth: 320 }}>
            Cultural readiness training for international schools — assigned by your school, delivered in the parent's language, tracked to completion.
          </div>
        </div>

        {/* Testimonial */}
        <div style={{ position: 'relative', zIndex: 1 }}>
          <div style={{
            borderLeft: '3px solid var(--cal-amber)',
            paddingLeft: 16,
            marginBottom: 16,
          }}>
            <div style={{ fontSize: 13, fontStyle: 'italic', color: 'rgba(255,255,255,0.78)', lineHeight: 1.7, marginBottom: 8 }}>
              "The Saudi Arabia module changed the way I open every parent meeting. I finally understood what they were expecting from me."
            </div>
            <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.45)', fontFamily: 'var(--font-display)', fontWeight: 500 }}>
              Secondary teacher · NLIS Riyadh
            </div>
          </div>
          <div style={{ fontSize: 10, color: 'rgba(255,255,255,0.25)', letterSpacing: '0.12em', textTransform: 'uppercase', fontFamily: 'var(--font-display)', fontWeight: 600 }}>
            Habterra · habterra.com
          </div>
        </div>
      </div>

      {/* ── Right panel: form ── */}
      <div style={{
        flex: 1,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: '48px 60px',
        background: 'var(--cal-off)',
      }}>
        <div style={{ width: '100%', maxWidth: 380 }}>

          {/* Heading */}
          <h1 style={{ fontFamily: 'var(--font-display)', fontSize: 26, fontWeight: 700, color: 'var(--cal-ink)', letterSpacing: '-0.02em', marginBottom: 6 }}>
            {recoveryMode ? 'Set your password' : forgotMode ? 'Reset your password' : 'Sign in to Habterra'}
          </h1>
          <p style={{ fontSize: 14, color: 'var(--cal-muted)', marginBottom: 36, lineHeight: 1.6 }}>
            {recoveryMode
              ? 'Choose a password you\'ll use to sign in to Habterra from now on.'
              : forgotMode
                ? 'Enter your school email and we\'ll send you a link to reset your password.'
                : 'Enter your school email address to access your assigned modules.'}
          </p>

          {/* Recovery / invite: set new password */}
          {recoveryMode && !recoverySaved && (
            <form onSubmit={handleSetNewPassword} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 500, color: 'var(--cal-ink-soft)', marginBottom: 6, fontFamily: 'var(--font-display)' }}>
                  New password
                </label>
                <input
                  className="input"
                  type="password"
                  placeholder="At least 8 characters"
                  value={newPass}
                  onChange={e => setNewPass(e.target.value)}
                  required
                  autoFocus
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 500, color: 'var(--cal-ink-soft)', marginBottom: 6, fontFamily: 'var(--font-display)' }}>
                  Confirm new password
                </label>
                <input
                  className="input"
                  type="password"
                  placeholder="Re-enter the password above"
                  value={newPass2}
                  onChange={e => setNewPass2(e.target.value)}
                  required
                />
              </div>

              {error && (
                <div style={{ fontSize: 13, color: '#C62828', background: '#FFEBEE', borderRadius: 'var(--r-sm)', padding: '10px 14px', lineHeight: 1.5 }}>
                  {error}
                </div>
              )}

              <button
                type="submit"
                className="btn btn-primary btn-full"
                disabled={loading}
                style={{ marginTop: 8, padding: '13px 20px', fontSize: 15, opacity: loading ? 0.7 : 1 }}
              >
                {loading ? 'Saving…' : 'Save password and continue'}
              </button>
            </form>
          )}

          {/* Recovery success */}
          {recoveryMode && recoverySaved && (
            <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-md)', padding: '14px 16px', fontSize: 13, color: 'var(--cal-success)', lineHeight: 1.6, marginBottom: 20 }}>
              ✓ Password saved. Taking you to your dashboard…
            </div>
          )}

          {/* Forgot password success */}
          {!recoveryMode && resetSent && (
            <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-md)', padding: '14px 16px', fontSize: 13, color: 'var(--cal-success)', lineHeight: 1.6, marginBottom: 20 }}>
              ✓ Check your inbox — we've sent a reset link to <strong>{email}</strong>.
              <div style={{ marginTop: 8 }}>
                <button
                  onClick={() => { setForgotMode(false); setResetSent(false) }}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 12, color: 'var(--cal-teal)', fontWeight: 600, padding: 0 }}
                >
                  ← Back to sign in
                </button>
              </div>
            </div>
          )}

          {/* Sign-in form */}
          {!recoveryMode && !forgotMode && !resetSent && (
            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 500, color: 'var(--cal-ink-soft)', marginBottom: 6, fontFamily: 'var(--font-display)' }}>
                  School email
                </label>
                <input
                  className="input"
                  type="email"
                  placeholder="you@school.edu"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  required
                  autoFocus
                />
              </div>

              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 500, color: 'var(--cal-ink-soft)', marginBottom: 6, fontFamily: 'var(--font-display)' }}>
                  Password
                </label>
                <input
                  className="input"
                  type="password"
                  placeholder="••••••••"
                  value={pass}
                  onChange={e => setPass(e.target.value)}
                  required
                />
              </div>

              {error && (
                <div style={{ fontSize: 13, color: '#C62828', background: '#FFEBEE', borderRadius: 'var(--r-sm)', padding: '10px 14px', lineHeight: 1.5 }}>
                  {error}
                </div>
              )}

              <button
                type="submit"
                className="btn btn-primary btn-full"
                disabled={loading}
                style={{ marginTop: 8, padding: '13px 20px', fontSize: 15, opacity: loading ? 0.7 : 1 }}
              >
                {loading ? 'Signing in…' : 'Sign in'}
              </button>

              <div style={{ textAlign: 'center', marginTop: 4 }}>
                <button
                  type="button"
                  onClick={() => { setForgotMode(true); setError('') }}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 12, color: 'var(--cal-muted)' }}
                >
                  Forgot password?
                </button>
              </div>
            </form>
          )}

          {/* Forgot password form */}
          {!recoveryMode && forgotMode && !resetSent && (
            <form onSubmit={handleForgotPassword} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div>
                <label style={{ display: 'block', fontSize: 12, fontWeight: 500, color: 'var(--cal-ink-soft)', marginBottom: 6, fontFamily: 'var(--font-display)' }}>
                  School email
                </label>
                <input
                  className="input"
                  type="email"
                  placeholder="you@school.edu"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  required
                  autoFocus
                />
              </div>

              {error && (
                <div style={{ fontSize: 13, color: '#C62828', background: '#FFEBEE', borderRadius: 'var(--r-sm)', padding: '10px 14px', lineHeight: 1.5 }}>
                  {error}
                </div>
              )}

              <button
                type="submit"
                className="btn btn-primary btn-full"
                disabled={loading}
                style={{ marginTop: 8, padding: '13px 20px', fontSize: 15, opacity: loading ? 0.7 : 1 }}
              >
                {loading ? 'Sending…' : 'Send reset link'}
              </button>

              <div style={{ textAlign: 'center', marginTop: 4 }}>
                <button
                  type="button"
                  onClick={() => { setForgotMode(false); setError('') }}
                  style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 12, color: 'var(--cal-muted)' }}
                >
                  ← Back to sign in
                </button>
              </div>
            </form>
          )}

          {/* Footer note */}
          <div style={{ marginTop: 48, padding: '16px 0', borderTop: '1px solid var(--cal-border)', fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
            Access is set up by your school. If you don't have an account yet, contact your professional development coordinator.
          </div>
        </div>
      </div>

    </div>
  )
}
