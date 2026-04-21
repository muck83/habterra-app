import { Link } from 'react-router-dom'
import Logo from '../components/Logo'
import { MODULE_META } from '../data/mockData'

/* ─────────────────────────────────────────────────────────────
   Public marketing landing page for habterra.com.
   Routes:
     /        → this page (unauthed)
     /login   → the sign-in form
   Unauthed visitors hitting the root see this; authed users are
   redirected to /dashboard by RedirectIfAuthed in App.jsx.
   ───────────────────────────────────────────────────────────── */

// Demo inquiry inbox — currently routed to Mark's personal email.
// TODO: move to a branded hello@habterra.com once the MX record is set up.
const DEMO_EMAIL = 'marktcrowell@gmail.com'

// Regional-indicator flag emoji from ISO-3166 alpha-2 country code.
// e.g. 'SA' → 🇸🇦. Non-country codes (e.g. 'WS' for Woodstock) get no flag.
function flagEmoji(code) {
  if (!code || code.length !== 2) return ''
  const A = 0x1F1E6
  const base = 'A'.charCodeAt(0)
  return String.fromCodePoint(A + (code.charCodeAt(0) - base)) +
         String.fromCodePoint(A + (code.charCodeAt(1) - base))
}

// Only show country modules on the public landing page — the Woodstock
// curriculum-transition module is school-specific and not a useful proof
// point for prospective international schools.
const COUNTRY_SLUGS = [
  'ksa-ib', 'india-ib', 'korea-ib', 'china-ib',
  'vietnam-ib', 'japan-ib', 'indonesia-ib', 'uae-ib',
]

export default function Landing() {
  return (
    <div style={{ background: 'var(--cal-off)', minHeight: '100vh', color: 'var(--cal-ink)' }}>

      {/* ── Top nav ── */}
      <header style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '24px 48px',
        maxWidth: 1200,
        margin: '0 auto',
      }}>
        <Logo size="md" theme="light" />
        <nav style={{ display: 'flex', alignItems: 'center', gap: 28 }}>
          <a href="#modules" style={navLinkStyle}>Modules</a>
          <a href="#approach" style={navLinkStyle}>Approach</a>
          <Link to="/login" style={navLinkStyle}>Sign in</Link>
          <a
            href={`mailto:${DEMO_EMAIL}?subject=Habterra%20demo%20request`}
            className="btn btn-primary"
            style={{ padding: '10px 18px', fontSize: 14 }}
          >
            Request a demo
          </a>
        </nav>
      </header>

      {/* ── Hero ── */}
      <section style={{
        maxWidth: 1000,
        margin: '0 auto',
        padding: '80px 48px 60px',
        textAlign: 'center',
      }}>
        {/* Big mark */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 32 }}>
          <Logo size="xl" theme="light" showTagline={true} />
        </div>

        <h1 style={{
          fontFamily: 'var(--font-display)',
          fontSize: 56,
          fontWeight: 700,
          lineHeight: 1.08,
          letterSpacing: '-0.025em',
          color: 'var(--cal-ink)',
          maxWidth: 820,
          margin: '24px auto 20px',
        }}>
          Cultural readiness for international schools — <span style={{ color: 'var(--cal-teal)' }}>before</span> the first parent meeting.
        </h1>

        <p style={{
          fontSize: 18,
          lineHeight: 1.65,
          color: 'var(--cal-muted)',
          maxWidth: 640,
          margin: '0 auto 40px',
        }}>
          Habterra gives teachers the context families don't arrive with in English — the exam cultures,
          family expectations, and unspoken rules behind every parent conversation.
        </p>

        <div style={{ display: 'flex', gap: 14, justifyContent: 'center', flexWrap: 'wrap' }}>
          <a
            href={`mailto:${DEMO_EMAIL}?subject=Habterra%20demo%20request`}
            className="btn btn-primary"
            style={{ padding: '14px 26px', fontSize: 15 }}
          >
            Request a demo
          </a>
          <Link
            to="/login"
            className="btn btn-ghost"
            style={{ padding: '14px 26px', fontSize: 15 }}
          >
            Teacher sign-in →
          </Link>
        </div>
      </section>

      {/* ── What it is ── */}
      <section id="approach" style={{
        maxWidth: 1000,
        margin: '0 auto',
        padding: '60px 48px',
      }}>
        <div style={{
          background: '#fff',
          borderRadius: 'var(--r-lg)',
          padding: '56px 56px',
          boxShadow: 'var(--shadow-sm)',
          border: '1px solid var(--cal-border)',
        }}>
          <div className="label-caps" style={{ color: 'var(--cal-amber)', fontSize: 11, letterSpacing: '0.14em', marginBottom: 14 }}>
            What Habterra is
          </div>
          <h2 style={{
            fontFamily: 'var(--font-display)',
            fontSize: 32,
            fontWeight: 700,
            letterSpacing: '-0.02em',
            color: 'var(--cal-ink)',
            marginBottom: 20,
            lineHeight: 1.2,
          }}>
            A professional development platform for schools with culturally diverse families.
          </h2>
          <div style={{
            fontSize: 16,
            lineHeight: 1.75,
            color: 'var(--cal-ink-soft)',
            display: 'flex',
            flexDirection: 'column',
            gap: 16,
            maxWidth: 720,
          }}>
            <p>
              Your teachers work across eight curricula and twenty nationalities. Your parents bring
              the expectations of the school systems that raised them — <em>gaokao</em>, CBSE,
              <em> suneung</em>, <em> tawjihiyya</em> — and the norms around teacher authority,
              family honour, and what "feedback" means.
            </p>
            <p>
              Habterra gives each teacher a short, country-specific module for the families in their
              classroom: what those parents grew up believing about school, what they actually want
              from the parent-teacher meeting, and where the cultural mismatches quietly happen.
            </p>
            <p>
              Admins assign modules, track completion, and see where teacher understanding is weak
              before it shows up as a parent complaint.
            </p>
          </div>
        </div>
      </section>

      {/* ── Country modules grid ── */}
      <section id="modules" style={{
        maxWidth: 1100,
        margin: '0 auto',
        padding: '40px 48px 80px',
      }}>
        <div style={{ textAlign: 'center', marginBottom: 48 }}>
          <div className="label-caps" style={{ color: 'var(--cal-amber)', fontSize: 11, letterSpacing: '0.14em', marginBottom: 14 }}>
            Country modules
          </div>
          <h2 style={{
            fontFamily: 'var(--font-display)',
            fontSize: 32,
            fontWeight: 700,
            letterSpacing: '-0.02em',
            color: 'var(--cal-ink)',
            marginBottom: 14,
            lineHeight: 1.2,
          }}>
            Built for the families on your roster.
          </h2>
          <p style={{ fontSize: 15, color: 'var(--cal-muted)', maxWidth: 560, margin: '0 auto', lineHeight: 1.6 }}>
            Each module is delivered in English and the parent's language, so a teacher and parent
            can cover the same ground.
          </p>
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
          gap: 16,
        }}>
          {COUNTRY_SLUGS.map(slug => {
            const m = MODULE_META[slug]
            if (!m) return null
            return (
              <div
                key={slug}
                style={{
                  background: '#fff',
                  border: '1px solid var(--cal-border)',
                  borderRadius: 'var(--r-md)',
                  padding: '22px 22px 20px',
                  display: 'flex',
                  flexDirection: 'column',
                  gap: 10,
                  transition: 'transform 120ms ease, box-shadow 120ms ease, border-color 120ms ease',
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{ fontSize: 28, lineHeight: 1 }}>{flagEmoji(m.flag)}</span>
                  <span style={{
                    fontFamily: 'var(--font-display)',
                    fontSize: 10,
                    fontWeight: 600,
                    letterSpacing: '0.1em',
                    textTransform: 'uppercase',
                    color: 'var(--cal-muted)',
                    marginLeft: 'auto',
                  }}>
                    {m.lang}
                  </span>
                </div>
                <div style={{
                  fontFamily: 'var(--font-display)',
                  fontSize: 17,
                  fontWeight: 700,
                  color: 'var(--cal-ink)',
                  lineHeight: 1.25,
                  letterSpacing: '-0.01em',
                }}>
                  {m.label}
                </div>
                <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.55 }}>
                  {m.desc}
                </div>
              </div>
            )
          })}
        </div>
      </section>

      {/* ── Testimonial ── */}
      <section style={{
        background: 'var(--cal-teal)',
        padding: '80px 48px',
        position: 'relative',
        overflow: 'hidden',
      }}>
        {/* Decorative rings */}
        <div style={{ position: 'absolute', right: -120, top: -120, width: 420, height: 420, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.06)' }} />
        <div style={{ position: 'absolute', left: -80, bottom: -80, width: 320, height: 320, borderRadius: '50%', border: '1.5px solid rgba(255,255,255,0.06)' }} />

        <div style={{ maxWidth: 820, margin: '0 auto', position: 'relative', zIndex: 1, textAlign: 'center' }}>
          <div style={{ fontSize: 48, color: 'var(--cal-amber)', lineHeight: 1, marginBottom: 20, fontFamily: 'var(--font-display)' }}>
            "
          </div>
          <blockquote style={{
            fontFamily: 'var(--font-display)',
            fontSize: 24,
            fontStyle: 'italic',
            fontWeight: 400,
            color: '#fff',
            lineHeight: 1.55,
            margin: 0,
            letterSpacing: '-0.005em',
          }}>
            The Saudi Arabia module changed the way I open every parent meeting. I finally understood
            what they were expecting from me.
          </blockquote>
          <div style={{
            marginTop: 28,
            fontSize: 12,
            color: 'rgba(255,255,255,0.55)',
            letterSpacing: '0.14em',
            textTransform: 'uppercase',
            fontFamily: 'var(--font-display)',
            fontWeight: 600,
          }}>
            Secondary teacher · NLIS Riyadh
          </div>
        </div>
      </section>

      {/* ── CTA band ── */}
      <section style={{
        maxWidth: 900,
        margin: '0 auto',
        padding: '80px 48px',
        textAlign: 'center',
      }}>
        <h2 style={{
          fontFamily: 'var(--font-display)',
          fontSize: 36,
          fontWeight: 700,
          letterSpacing: '-0.02em',
          color: 'var(--cal-ink)',
          marginBottom: 16,
          lineHeight: 1.2,
        }}>
          See Habterra in your school.
        </h2>
        <p style={{ fontSize: 17, color: 'var(--cal-muted)', maxWidth: 560, margin: '0 auto 32px', lineHeight: 1.6 }}>
          A 30-minute walkthrough with your PD coordinator. We'll map the modules to the families
          on your roster and set up a pilot cohort.
        </p>
        <a
          href={`mailto:${DEMO_EMAIL}?subject=Habterra%20demo%20request&body=Hi%20%E2%80%94%20I%27d%20like%20to%20see%20Habterra%20for%20our%20school.%0A%0ASchool%3A%20%0ARole%3A%20%0ANumber%20of%20teachers%3A%20%0A`}
          className="btn btn-amber"
          style={{ padding: '14px 30px', fontSize: 15 }}
        >
          Request a demo
        </a>
      </section>

      {/* ── Footer ── */}
      <footer style={{
        borderTop: '1px solid var(--cal-border)',
        padding: '32px 48px',
        maxWidth: 1200,
        margin: '0 auto',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        flexWrap: 'wrap',
        gap: 16,
      }}>
        <Logo size="sm" theme="light" />
        <div style={{ display: 'flex', alignItems: 'center', gap: 24, fontSize: 13, color: 'var(--cal-muted)' }}>
          <span>© 2026 Habterra</span>
          <a href={`mailto:${DEMO_EMAIL}`} style={{ color: 'var(--cal-muted)', textDecoration: 'none' }}>Contact</a>
          <Link to="/login" style={{ color: 'var(--cal-muted)', textDecoration: 'none' }}>Sign in</Link>
        </div>
      </footer>
    </div>
  )
}

const navLinkStyle = {
  fontFamily: 'var(--font-display)',
  fontSize: 14,
  fontWeight: 500,
  color: 'var(--cal-ink-soft)',
  textDecoration: 'none',
}
