import { MODULE_META, MOCK_SCHOOL } from '../../../data/mockData'
import StatCard from '../components/StatCard'
import CompletionCell from '../components/CompletionCell'
import { fmtDate, daysUntil, computeUserSlugs, computeUserOverallPct } from '../utils'

/* ═══════════════════════════════════════════════════════════════════════
   Overview view — school stats + completion matrix + assignment schedule.
   State owned by AdminDashboard shell; this component is render-only.
   ═══════════════════════════════════════════════════════════════════════ */
export default function OverviewView({
  stats,
  activeSlugs,
  visibleUsers,
  assignments,
  exclusions,
  roleFilter,
  setRoleFilter,
  setAdminView,
  setSelectedUser,
  primerDismissed,
  dismissPrimer,
}) {
  const userSlugs = (u) => computeUserSlugs(u, assignments, exclusions)
  const userOverallPct = (u) => computeUserOverallPct(u, assignments, exclusions)

  return (
    <>
      {/* Header */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 28 }}>
        <div>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>
            {MOCK_SCHOOL.name}
          </h2>
          <div style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
            School dashboard · {stats.teacherCount} teachers · {stats.parentCount} parents
          </div>
        </div>
        <button
          className="btn btn-primary"
          onClick={() => setAdminView('assign')}
          style={{ fontSize: 13, padding: '10px 18px' }}
        >
          + Assign module
        </button>
      </div>

      {/* First-run primer — what Habterra is and isn't */}
      {!primerDismissed && (
        <div style={{
          background: 'linear-gradient(135deg, var(--cal-teal-lt) 0%, #fff 70%)',
          border: '1.5px solid var(--cal-teal)',
          borderRadius: 'var(--r-lg)',
          padding: '18px 22px',
          marginBottom: 24,
          position: 'relative',
        }}>
          <button
            type="button"
            onClick={dismissPrimer}
            aria-label="Dismiss"
            style={{
              position: 'absolute', top: 10, right: 12,
              background: 'transparent', border: 'none', cursor: 'pointer',
              fontSize: 18, color: 'var(--cal-muted)', lineHeight: 1,
              padding: 4,
            }}
          >×</button>
          <div style={{
            fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
            letterSpacing: '0.1em', color: 'var(--cal-teal)', marginBottom: 8,
          }}>
            HABTERRA IS NOT AN LMS
          </div>
          <div style={{ fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.6, marginBottom: 10, maxWidth: 720 }}>
            Habterra is a <strong>frame-sharpening tool</strong> for parent conversations — not a course library and not a compliance tracker. Each module is 60–90 minutes of short scenarios anchored in research (Hattie, EEF, Schaverien, Kim et al.) that give teachers a shared vocabulary before parent season.
          </div>
          <div style={{ fontSize: 13, color: 'var(--cal-ink-soft)', lineHeight: 1.6, maxWidth: 720 }}>
            Use the <strong>Action Queue</strong> to see where teachers are struggling in real time, and <strong>Quiz Analytics</strong> to pull one insight into your next staff meeting. The rollout script in the module guide handles the T-7 to T+14 sequence so you don't have to invent it.
          </div>
          <button
            type="button"
            onClick={dismissPrimer}
            style={{
              marginTop: 14,
              fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
              background: 'var(--cal-teal)', color: '#fff', border: 'none',
              borderRadius: 'var(--r-md)', padding: '8px 16px', cursor: 'pointer',
            }}
          >
            Got it — don't show this again
          </button>
        </div>
      )}

      {/* Stats row */}
      <div style={{ display: 'flex', gap: 16, marginBottom: 32 }}>
        <StatCard value={stats.teacherCount}    label="Teachers"         sub="enrolled"                           accent="var(--cal-teal)" />
        <StatCard value={stats.parentCount}     label="Parents"          sub="enrolled"                           accent="#7B5EA7" />
        <StatCard value={`${stats.completionRate}%`} label="Completion rate" sub="across all assigned modules"   accent="var(--cal-amber)" />
        <StatCard value={assignments.length}    label="Active modules"   sub="assigned this term"                 accent="#43A047" />
      </div>

      {/* Role filter tabs */}
      <div style={{ display: 'flex', gap: 6, marginBottom: 20 }}>
        {['all', 'teacher', 'parent'].map(f => (
          <button
            key={f}
            onClick={() => setRoleFilter(f)}
            style={{
              fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
              padding: '6px 14px', borderRadius: 'var(--r-full)',
              border: '1.5px solid',
              borderColor: roleFilter === f ? 'var(--cal-teal)' : 'var(--cal-border)',
              background: roleFilter === f ? 'var(--cal-teal)' : 'transparent',
              color: roleFilter === f ? '#fff' : 'var(--cal-muted)',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
          >
            {f === 'all' ? 'All members' : f === 'teacher' ? 'Teachers' : 'Parents'}
          </button>
        ))}
      </div>

      {/* Completion matrix */}
      <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden', marginBottom: 28 }}>
        <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--cal-border-lt)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)' }}>
            Completion matrix
          </div>
          <div className="label-caps">
            {visibleUsers.length} member{visibleUsers.length !== 1 ? 's' : ''}
          </div>
        </div>

        <div style={{ overflowX: 'auto' }}>
          <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 500 }}>
            <thead>
              <tr style={{ background: 'var(--cal-surface)' }}>
                <th style={{ textAlign: 'left', padding: '10px 20px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 180 }}>
                  Member
                </th>
                <th style={{ textAlign: 'center', padding: '10px 8px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 80 }}>
                  Overall
                </th>
                {activeSlugs.map(slug => (
                  <th key={slug} style={{ textAlign: 'center', padding: '10px 8px', fontSize: 11, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', borderBottom: '1px solid var(--cal-border-lt)', minWidth: 100 }}>
                    {MODULE_META[slug]?.flag} {MODULE_META[slug]?.label?.replace('Understand ', '') ?? slug}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {visibleUsers.map((user, i) => {
                const overallPct = userOverallPct(user)
                const slugsForUser = userSlugs(user)
                return (
                  <tr
                    key={user.id}
                    style={{
                      background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)',
                      cursor: 'pointer',
                      transition: 'background 0.1s',
                    }}
                    onMouseEnter={e => e.currentTarget.style.background = 'var(--cal-teal-lt)'}
                    onMouseLeave={e => e.currentTarget.style.background = i % 2 === 0 ? '#fff' : 'var(--cal-surface)'}
                    onClick={() => setSelectedUser(user)}
                  >
                    {/* Name + role */}
                    <td style={{ padding: '10px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                        <div style={{
                          width: 30, height: 30, borderRadius: '50%', flexShrink: 0,
                          background: user.role === 'teacher' ? 'var(--cal-teal-lt)' : '#EDE7F6',
                          display: 'flex', alignItems: 'center', justifyContent: 'center',
                          fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                          color: user.role === 'teacher' ? 'var(--cal-teal)' : '#7B5EA7',
                        }}>
                          {user.full_name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                        </div>
                        <div>
                          <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)' }}>{user.full_name}</div>
                          <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>{user.role}</div>
                        </div>
                      </div>
                    </td>

                    {/* Overall % */}
                    <td style={{ textAlign: 'center', padding: '10px 8px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                        <div style={{
                          fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 700,
                          color: overallPct >= 80 ? 'var(--cal-success)' : overallPct > 0 ? 'var(--cal-amber-dark)' : 'var(--cal-muted)',
                        }}>
                          {overallPct}%
                        </div>
                        <div className="progress-track" style={{ width: 40, height: 3 }}>
                          <div
                            className={`progress-fill ${overallPct >= 80 ? 'green' : 'amber'}`}
                            style={{ width: `${overallPct}%` }}
                          />
                        </div>
                      </div>
                    </td>

                    {/* Per-module cells */}
                    {activeSlugs.map(slug => {
                      const assigned = slugsForUser.includes(slug)
                      return assigned
                        ? <CompletionCell key={slug} pct={user.completions?.[slug] ?? 0} />
                        : <CompletionCell key={slug} pct={undefined} />
                    })}
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>

        {/* Legend */}
        <div style={{ padding: '12px 20px', borderTop: '1px solid var(--cal-border-lt)', display: 'flex', gap: 20, alignItems: 'center' }}>
          <span className="label-caps">Legend</span>
          {[
            { symbol: '✓', bg: 'var(--cal-success-lt)', color: 'var(--cal-success)', label: 'Complete (≥80%)' },
            { symbol: '%', bg: 'var(--cal-amber-lt)',   color: 'var(--cal-amber-dark)', label: 'In progress' },
            { symbol: '○', bg: 'var(--cal-border-lt)', color: 'var(--cal-border)', label: 'Not started' },
            { symbol: '—', bg: 'transparent',          color: '#C8C4BE', label: 'Not assigned' },
          ].map(l => (
            <div key={l.label} style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 11, color: 'var(--cal-muted)' }}>
              <div style={{ width: 18, height: 18, borderRadius: '50%', background: l.bg, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 9, color: l.color, fontWeight: 700 }}>
                {l.symbol}
              </div>
              {l.label}
            </div>
          ))}
        </div>
      </div>

      {/* Assignment schedule */}
      <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden' }}>
        <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600, color: 'var(--cal-ink)' }}>
            Current assignments
          </div>
        </div>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr style={{ background: 'var(--cal-surface)' }}>
              {['Module', 'Assigned to', 'Due date', 'Status'].map(h => (
                <th key={h} style={{ textAlign: 'left', padding: '9px 20px', fontSize: 10, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.08em', textTransform: 'uppercase', borderBottom: '1px solid var(--cal-border-lt)' }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {assignments.map((a, i) => {
              const meta  = MODULE_META[a.module_slug]
              const days  = daysUntil(a.due_date)
              const urgent = days !== null && days <= 7 && days >= 0
              const overdue = days !== null && days < 0
              return (
                <tr key={a.id} style={{ background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)' }}>
                  <td style={{ padding: '12px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)' }}>
                    <span style={{ marginRight: 8 }}>{meta?.flag}</span>
                    <span style={{ fontWeight: 500 }}>{meta?.label ?? a.module_slug}</span>
                  </td>
                  <td style={{ padding: '12px 20px', fontSize: 13, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)', textTransform: 'capitalize' }}>
                    {a.role_target === 'all' ? 'Everyone' : a.role_target + 's'}
                  </td>
                  <td style={{ padding: '12px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)' }}>
                    {a.due_date ? (
                      <span style={{ color: overdue ? '#C62828' : urgent ? 'var(--cal-amber-dark)' : 'var(--cal-ink)' }}>
                        {fmtDate(a.due_date)}
                        {overdue && <span style={{ marginLeft: 6, fontSize: 10, fontWeight: 600 }}>(overdue)</span>}
                        {urgent  && <span style={{ marginLeft: 6, fontSize: 10, fontWeight: 600 }}>({days}d)</span>}
                      </span>
                    ) : '—'}
                  </td>
                  <td style={{ padding: '12px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                    <span className={`badge ${overdue ? 'badge-soon' : 'badge-assigned'}`} style={overdue ? { background: '#FFEBEE', color: '#C62828' } : {}}>
                      {overdue ? 'Overdue' : 'Active'}
                    </span>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </>
  )
}
