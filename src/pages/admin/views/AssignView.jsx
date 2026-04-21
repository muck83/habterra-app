import { MODULE_META } from '../../../data/mockData'
import { daysUntil, fmtDate } from '../utils'

/* Admin → Assign tab.
   Two-column layout: new-assignment form on the left, active-assignments
   list on the right. Supports role-targeted assignments ("teachers",
   "parents", "all") and specific-user targeting via checkbox list. */
export default function AssignView({
  handleAssign,
  assignForm,
  setAssignForm,
  members,
  assignments,
  assignSaved,
  assignError,
  handleUnassign,
}) {
  return (
    <>
      <div style={{ marginBottom: 28 }}>
        <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Assign a module</h2>
        <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
          Assigned modules appear on every member's dashboard. They'll receive a notification to complete it before the due date.
        </p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24, maxWidth: 860 }}>

        {/* Assignment form */}
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 22 }}>
            New assignment
          </div>

          <form onSubmit={handleAssign} style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>

            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                Module
              </label>
              <select
                value={assignForm.moduleSlug}
                onChange={e => setAssignForm(f => ({ ...f, moduleSlug: e.target.value }))}
                required
                style={{
                  width: '100%', fontFamily: 'var(--font-body)', fontSize: 14,
                  color: 'var(--cal-ink)', background: '#fff',
                  border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)',
                  padding: '11px 14px', outline: 'none', cursor: 'pointer',
                }}
              >
                <option value="">Select a module…</option>
                {Object.values(MODULE_META).map(m => (
                  <option key={m.slug} value={m.slug}>
                    {m.flag} {m.label}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                Assign to
              </label>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
                {[
                  { val: 'teacher', label: 'Teachers only' },
                  { val: 'parent',  label: 'Parents only' },
                  { val: 'all',     label: 'Everyone' },
                  { val: 'users',   label: 'Specific users' },
                ].map(opt => (
                  <button
                    key={opt.val}
                    type="button"
                    onClick={() => setAssignForm(f => ({ ...f, roleTarget: opt.val }))}
                    style={{
                      padding: '10px 8px', border: '1.5px solid',
                      borderRadius: 'var(--r-md)', cursor: 'pointer', fontSize: 12,
                      fontFamily: 'var(--font-display)', fontWeight: 600,
                      borderColor: assignForm.roleTarget === opt.val ? 'var(--cal-teal)' : 'var(--cal-border)',
                      background: assignForm.roleTarget === opt.val ? 'var(--cal-teal-lt)' : 'transparent',
                      color: assignForm.roleTarget === opt.val ? 'var(--cal-teal)' : 'var(--cal-muted)',
                    }}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>

              {assignForm.roleTarget === 'users' && (
                <div style={{ marginTop: 12 }}>
                  <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginBottom: 8, display: 'flex', justifyContent: 'space-between' }}>
                    <span>
                      {assignForm.selectedUserIds.length === 0
                        ? 'Pick one or more members to assign this module to.'
                        : `${assignForm.selectedUserIds.length} selected`}
                    </span>
                    {assignForm.selectedUserIds.length > 0 && (
                      <button
                        type="button"
                        onClick={() => setAssignForm(f => ({ ...f, selectedUserIds: [] }))}
                        style={{
                          background: 'transparent', border: 'none', padding: 0,
                          color: 'var(--cal-teal)', cursor: 'pointer', fontSize: 11,
                          fontFamily: 'var(--font-body)', fontWeight: 500,
                        }}
                      >
                        Clear
                      </button>
                    )}
                  </div>
                  <div style={{
                    maxHeight: 200, overflowY: 'auto',
                    border: '1px solid var(--cal-border)', borderRadius: 'var(--r-md)',
                    background: '#fff',
                  }}>
                    {members.map((u, i) => {
                      const checked = assignForm.selectedUserIds.includes(u.id)
                      return (
                        <label
                          key={u.id}
                          style={{
                            display: 'flex', alignItems: 'center', gap: 10,
                            padding: '8px 12px',
                            borderBottom: i < members.length - 1 ? '1px solid var(--cal-border-lt)' : 'none',
                            cursor: 'pointer',
                            background: checked ? 'var(--cal-teal-lt)' : 'transparent',
                          }}
                        >
                          <input
                            type="checkbox"
                            checked={checked}
                            onChange={e => {
                              setAssignForm(f => ({
                                ...f,
                                selectedUserIds: e.target.checked
                                  ? [...f.selectedUserIds, u.id]
                                  : f.selectedUserIds.filter(id => id !== u.id),
                              }))
                            }}
                            style={{ cursor: 'pointer' }}
                          />
                          <div style={{ flex: 1, minWidth: 0 }}>
                            <div style={{ fontSize: 13, color: 'var(--cal-ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                              {u.full_name}
                            </div>
                            <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>
                              {u.role} · {u.email}
                            </div>
                          </div>
                        </label>
                      )
                    })}
                  </div>
                </div>
              )}
            </div>

            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                Due date <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>(optional)</span>
              </label>
              <input
                className="input"
                type="date"
                value={assignForm.dueDate}
                onChange={e => setAssignForm(f => ({ ...f, dueDate: e.target.value }))}
                min={new Date().toISOString().split('T')[0]}
              />
            </div>

            {assignSaved && (
              <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: 'var(--cal-success)', fontWeight: 500 }}>
                ✓ Module assigned successfully
              </div>
            )}
            {assignError && (
              <div style={{ background: '#FFEBEE', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: '#C62828', lineHeight: 1.5 }}>
                {assignError}
              </div>
            )}

            <button type="submit" className="btn btn-primary btn-full" style={{ marginTop: 4, padding: '13px', fontSize: 14 }}>
              Assign module →
            </button>
          </form>
        </div>

        {/* Current assignments list */}
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 20 }}>
            Currently active
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {assignments.map(a => {
              const meta = MODULE_META[a.module_slug]
              const days = daysUntil(a.due_date)
              const targetUser = a.user_id ? members.find(u => u.id === a.user_id) : null
              const audienceLabel = targetUser
                ? `→ ${targetUser.full_name}`
                : (a.role_target === 'all' ? 'Everyone' : a.role_target + 's')
              return (
                <div key={a.id} style={{
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                  padding: '12px 14px', borderRadius: 'var(--r-md)',
                  background: 'var(--cal-surface)',
                  border: '1px solid var(--cal-border-lt)',
                }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <span style={{ fontSize: 20 }}>{meta?.flag ?? '🌏'}</span>
                    <div>
                      <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)' }}>
                        {meta?.label ?? a.module_slug}
                      </div>
                      <div style={{ fontSize: 10, color: 'var(--cal-muted)', textTransform: targetUser ? 'none' : 'capitalize' }}>
                        {audienceLabel}
                        {a.due_date && ` · Due ${fmtDate(a.due_date)}`}
                      </div>
                    </div>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <span className={`badge ${days !== null && days < 0 ? '' : 'badge-done'}`}
                      style={days !== null && days < 0 ? { background: '#FFEBEE', color: '#C62828' } : {}}
                    >
                      {days !== null && days < 0 ? 'Overdue' : 'Active'}
                    </span>
                    <button
                      type="button"
                      onClick={() => handleUnassign(a)}
                      title="Remove assignment"
                      aria-label={`Remove ${meta?.label ?? a.module_slug} assignment`}
                      style={{
                        width: 24, height: 24,
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                        border: '1px solid var(--cal-border-lt)',
                        borderRadius: 'var(--r-sm)',
                        background: '#fff',
                        color: 'var(--cal-muted)',
                        cursor: 'pointer',
                        fontSize: 14, lineHeight: 1,
                        padding: 0,
                        transition: 'color 0.15s, border-color 0.15s, background 0.15s',
                      }}
                      onMouseEnter={e => {
                        e.currentTarget.style.color = '#C62828'
                        e.currentTarget.style.borderColor = '#C62828'
                        e.currentTarget.style.background = '#FFEBEE'
                      }}
                      onMouseLeave={e => {
                        e.currentTarget.style.color = 'var(--cal-muted)'
                        e.currentTarget.style.borderColor = 'var(--cal-border-lt)'
                        e.currentTarget.style.background = '#fff'
                      }}
                    >×</button>
                  </div>
                </div>
              )
            })}
            {assignments.length === 0 && (
              <div style={{ fontSize: 13, color: 'var(--cal-muted)', padding: '12px 14px' }}>
                No active assignments yet.
              </div>
            )}
          </div>
        </div>

      </div>
    </>
  )
}
