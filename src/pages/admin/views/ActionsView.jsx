import { severityStyles, modulePillLabel, actionTypeLabel, fmtDate } from '../utils'

/* Admin → Actions tab.
   Severity-grouped queue of things needing attention: overdue invites,
   stalled progress, upcoming deadlines, failed quizzes. Pure view —
   the refresh/resolve handlers live in the shell. */
export default function ActionsView({
  actionItems,
  actionError,
  actionLoading,
  actionRefreshing,
  handleActionRefresh,
  handleActionResolve,
}) {
  const grouped = ['high', 'medium', 'low'].map(severity => ({
    severity,
    items: actionItems.filter(item => item.severity === severity),
  }))

  return (
    <>
      <div style={{ marginBottom: 28, display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 20 }}>
        <div>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Action Queue</h2>
          <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>What needs attention next, generated from invites, progress, deadlines, and quiz responses.</p>
        </div>
        <button
          type="button"
          className="btn btn-primary"
          onClick={handleActionRefresh}
          disabled={actionRefreshing}
          style={{ fontSize: 13, padding: '10px 18px', opacity: actionRefreshing ? 0.6 : 1 }}
        >
          {actionRefreshing ? 'Refreshing...' : 'Refresh'}
        </button>
      </div>

      {actionError && (
        <div style={{ background: '#FDEDED', borderRadius: 'var(--r-md)', padding: '14px 18px', marginBottom: 18, fontSize: 13, color: '#B3261E', lineHeight: 1.6 }}>
          {actionError}
        </div>
      )}

      {actionLoading && (
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px', fontSize: 13, color: 'var(--cal-muted)' }}>
          Loading action items...
        </div>
      )}

      {!actionLoading && actionItems.length === 0 && (
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '34px 30px', maxWidth: 720 }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 18, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 8 }}>Nothing needs attention right now</div>
          <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.7 }}>
            Refresh the queue after new invites, assignments, or quiz responses land.
          </div>
        </div>
      )}

      {!actionLoading && actionItems.length > 0 && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 18, maxWidth: 900 }}>
          {grouped.map(group => {
            if (group.items.length === 0) return null
            const sevStyle = severityStyles(group.severity)

            return (
              <section key={group.severity}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                  <span style={{ display: 'inline-flex', alignItems: 'center', border: '1px solid', borderRadius: 'var(--r-full)', padding: '4px 10px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase', ...sevStyle }}>
                    {group.severity}
                  </span>
                  <span style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
                    {group.items.length} item{group.items.length !== 1 ? 's' : ''}
                  </span>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                  {group.items.map(item => {
                    const moduleLabel = modulePillLabel(item.module_slug)
                    const userName = item.user?.full_name
                    const userEmail = item.user?.email ?? item.metadata?.email

                    return (
                      <div key={item.id} style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid var(--cal-border-lt)', padding: '18px 20px' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 18, alignItems: 'flex-start' }}>
                          <div style={{ flex: 1, minWidth: 0 }}>
                            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 10 }}>
                              <span className="badge badge-assigned" style={{ fontSize: 9 }}>{actionTypeLabel(item.action_type)}</span>
                              {moduleLabel && <span className="badge badge-progress" style={{ fontSize: 9 }}>{moduleLabel}</span>}
                              {userName && <span className="badge" style={{ fontSize: 9, background: 'var(--cal-border-lt)', color: 'var(--cal-muted)' }}>{userName}</span>}
                              {item.due_date && <span className="badge badge-soon" style={{ fontSize: 9 }}>Due {fmtDate(item.due_date)}</span>}
                            </div>
                            <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 6 }}>
                              {item.title}
                            </div>
                            <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.65 }}>
                              {item.detail}
                            </div>
                            {userEmail && (
                              <div style={{ marginTop: 8, fontSize: 11, color: 'var(--cal-muted)' }}>
                                {userEmail}
                              </div>
                            )}
                          </div>

                          <button
                            type="button"
                            className="btn btn-ghost"
                            onClick={() => handleActionResolve(item.id)}
                            style={{ flexShrink: 0, fontSize: 12, padding: '8px 12px' }}
                          >
                            Resolve
                          </button>
                        </div>
                      </div>
                    )
                  })}
                </div>
              </section>
            )
          })}
        </div>
      )}
    </>
  )
}
