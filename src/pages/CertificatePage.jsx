import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { getCompletions } from '../lib/supabase'
import { MODULE_META } from '../data/mockData'

/* ── Deterministic short cert ID ── */
function certId(userId, slug, completedAt) {
  const str   = `${userId}-${slug}-${completedAt}`
  let   hash  = 0
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash) + str.charCodeAt(i)
    hash |= 0
  }
  const hex = Math.abs(hash).toString(16).toUpperCase().padStart(8, '0')
  return `${slug.split('-')[0].toUpperCase()}-${hex.slice(0, 4)}-${hex.slice(4, 8)}`
}

export default function CertificatePage() {
  const { slug }   = useParams()
  const navigate   = useNavigate()
  const { user, profile } = useAuth()
  const meta       = MODULE_META[slug]

  const [completedAt, setCompletedAt] = useState(null)
  const [loading,     setLoading]     = useState(true)

  useEffect(() => {
    if (!user) return
    getCompletions(user.id)
      .then(comps => {
        const c = comps.find(x => x.module_slug === slug)
        setCompletedAt(c?.completed_at ?? null)
        setLoading(false)
      })
      .catch(() => setLoading(false))
  }, [user?.id, slug])

  const name      = profile?.full_name ?? profile?.email ?? 'Teacher'
  const certDate  = completedAt
    ? new Date(completedAt).toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' })
    : new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' })
  const certNo    = !loading ? certId(user?.id ?? 'demo', slug, completedAt ?? 'demo') : '—'

  if (!meta) {
    return (
      <div style={{ height: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ textAlign: 'center', color: 'var(--cal-muted)' }}>
          <div style={{ fontSize: 40, marginBottom: 12 }}>🔍</div>
          <div>Module not found.</div>
          <button className="btn btn-ghost" onClick={() => navigate('/dashboard')} style={{ marginTop: 16, fontSize: 12 }}>
            ← Back to dashboard
          </button>
        </div>
      </div>
    )
  }

  return (
    <>
      {/* ── Print CSS ── */}
      <style>{`
        @media print {
          .cert-ui { display: none !important; }
          .cert-wrap { margin: 0 !important; padding: 0 !important; }
          body { background: #fff !important; }
        }
        @page {
          size: A4 landscape;
          margin: 0;
        }
      `}</style>

      {/* ── UI chrome (hidden on print) ── */}
      <div className="cert-ui" style={{
        background: 'var(--cal-off)', borderBottom: '1px solid var(--cal-border)',
        padding: '12px 32px', display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <button
          className="btn btn-ghost"
          onClick={() => navigate(`/module/${slug}`)}
          style={{ fontSize: 12 }}
        >
          ← Back to module
        </button>
        <div style={{ display: 'flex', gap: 10 }}>
          <button
            className="btn"
            onClick={() => window.print()}
            style={{ background: 'var(--cal-teal)', color: '#fff', padding: '8px 20px', fontSize: 13 }}
          >
            ⬇ Save as PDF
          </button>
        </div>
      </div>

      {/* ── Certificate ── */}
      <div className="cert-wrap" style={{
        minHeight: 'calc(100vh - 53px)',
        background: 'var(--cal-off)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '40px 24px',
      }}>
        <div style={{
          /* A4 landscape proportions at screen size */
          width: '100%', maxWidth: 960,
          aspectRatio: '297 / 210',
          background: '#fff',
          borderRadius: 4,
          boxShadow: '0 4px 40px rgba(0,0,0,0.12)',
          position: 'relative',
          overflow: 'hidden',
          display: 'flex',
          flexDirection: 'column',
        }}>

          {/* Top teal bar */}
          <div style={{
            background: 'var(--cal-teal)',
            height: '11%',
            display: 'flex', alignItems: 'center',
            padding: '0 48px',
            justifyContent: 'space-between',
            flexShrink: 0,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              {/* Habterra wordmark */}
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                <circle cx="12" cy="12" r="10" stroke="rgba(255,255,255,0.6)" strokeWidth="1.5"/>
                <circle cx="12" cy="12" r="5"  stroke="rgba(255,255,255,0.9)" strokeWidth="1.5"/>
                <line x1="12" y1="2"  x2="12" y2="7"  stroke="rgba(255,255,255,0.9)" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="12" y1="17" x2="12" y2="22" stroke="rgba(255,255,255,0.9)" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="2"  y1="12" x2="7"  y2="12" stroke="rgba(255,255,255,0.9)" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="17" y1="12" x2="22" y2="12" stroke="rgba(255,255,255,0.9)" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
              <span style={{
                fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 800,
                color: '#fff', letterSpacing: '-0.02em',
              }}>
                Habterra
              </span>
            </div>
            <span style={{
              fontFamily: 'var(--font-display)', fontSize: 10, fontWeight: 600,
              color: 'rgba(255,255,255,0.6)', letterSpacing: '0.14em', textTransform: 'uppercase',
            }}>
              Professional Development · International Schools
            </span>
          </div>

          {/* Body */}
          <div style={{ flex: 1, display: 'flex', alignItems: 'stretch' }}>

            {/* Left accent column */}
            <div style={{
              width: '7%', background: 'var(--cal-teal)', opacity: 0.08,
              flexShrink: 0,
            }} />

            {/* Main content */}
            <div style={{
              flex: 1, display: 'flex', flexDirection: 'column',
              alignItems: 'center', justifyContent: 'center',
              padding: '0 60px', textAlign: 'center',
              position: 'relative',
            }}>

              {/* Decorative ring behind flag */}
              <div style={{
                position: 'absolute', top: '50%', left: '50%',
                transform: 'translate(-50%, -50%)',
                width: 180, height: 180, borderRadius: '50%',
                border: '1px solid rgba(11,85,99,0.06)',
                pointerEvents: 'none',
              }} />
              <div style={{
                position: 'absolute', top: '50%', left: '50%',
                transform: 'translate(-50%, -50%)',
                width: 220, height: 220, borderRadius: '50%',
                border: '1px solid rgba(11,85,99,0.04)',
                pointerEvents: 'none',
              }} />

              {/* Certificate of completion label */}
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 10, fontWeight: 700,
                letterSpacing: '0.2em', textTransform: 'uppercase',
                color: 'var(--cal-teal)', marginBottom: 10,
              }}>
                Certificate of Completion
              </div>

              {/* Module flag */}
              <div style={{ fontSize: 44, marginBottom: 8, lineHeight: 1 }}>
                {meta.flag}
              </div>

              {/* Module name */}
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 800,
                color: 'var(--cal-ink)', letterSpacing: '-0.02em', marginBottom: 20,
              }}>
                {meta.label}
              </div>

              {/* Divider */}
              <div style={{ width: 60, height: 2, background: 'var(--cal-teal)', borderRadius: 1, marginBottom: 20, opacity: 0.5 }} />

              {/* Body text */}
              <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.7, marginBottom: 14, maxWidth: 460 }}>
                This is to certify that
              </div>

              {/* Name */}
              <div style={{
                fontFamily: 'var(--font-display)', fontSize: 28, fontWeight: 800,
                color: 'var(--cal-ink)', letterSpacing: '-0.02em', marginBottom: 14,
                borderBottom: '2px solid var(--cal-teal)',
                paddingBottom: 8, minWidth: 280, textAlign: 'center',
              }}>
                {name}
              </div>

              <div style={{ fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.8, maxWidth: 440, marginBottom: 20 }}>
                has successfully completed the Habterra professional development module
                and demonstrated cultural literacy for parent engagement in international school settings.
              </div>

              {/* Date + cert no */}
              <div style={{ display: 'flex', gap: 40, justifyContent: 'center' }}>
                <div style={{ textAlign: 'center' }}>
                  <div style={{
                    fontSize: 9, fontFamily: 'var(--font-display)', fontWeight: 700,
                    letterSpacing: '0.12em', textTransform: 'uppercase',
                    color: 'var(--cal-muted)', marginBottom: 3,
                  }}>Issued</div>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)' }}>
                    {certDate}
                  </div>
                </div>
                <div style={{ textAlign: 'center' }}>
                  <div style={{
                    fontSize: 9, fontFamily: 'var(--font-display)', fontWeight: 700,
                    letterSpacing: '0.12em', textTransform: 'uppercase',
                    color: 'var(--cal-muted)', marginBottom: 3,
                  }}>Certificate no.</div>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600, color: 'var(--cal-ink)', letterSpacing: '0.05em' }}>
                    {certNo}
                  </div>
                </div>
              </div>
            </div>

            {/* Right accent column */}
            <div style={{
              width: '7%', background: 'var(--cal-teal)', opacity: 0.08,
              flexShrink: 0,
            }} />
          </div>

          {/* Bottom bar */}
          <div style={{
            height: '7%',
            borderTop: '1px solid rgba(11,85,99,0.08)',
            display: 'flex', alignItems: 'center',
            padding: '0 48px',
            justifyContent: 'space-between',
            flexShrink: 0,
          }}>
            <span style={{ fontSize: 9, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em' }}>
              habterra.com
            </span>
            <span style={{ fontSize: 9, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em' }}>
              Habterra · International Teacher Professional Development
            </span>
          </div>

          {/* Corner accents */}
          <div style={{
            position: 'absolute', top: '11%', left: '7%',
            width: 28, height: 28,
            borderTop: '2px solid rgba(11,85,99,0.15)',
            borderLeft: '2px solid rgba(11,85,99,0.15)',
          }} />
          <div style={{
            position: 'absolute', top: '11%', right: '7%',
            width: 28, height: 28,
            borderTop: '2px solid rgba(11,85,99,0.15)',
            borderRight: '2px solid rgba(11,85,99,0.15)',
          }} />
          <div style={{
            position: 'absolute', bottom: '7%', left: '7%',
            width: 28, height: 28,
            borderBottom: '2px solid rgba(11,85,99,0.15)',
            borderLeft: '2px solid rgba(11,85,99,0.15)',
          }} />
          <div style={{
            position: 'absolute', bottom: '7%', right: '7%',
            width: 28, height: 28,
            borderBottom: '2px solid rgba(11,85,99,0.15)',
            borderRight: '2px solid rgba(11,85,99,0.15)',
          }} />
        </div>
      </div>
    </>
  )
}
