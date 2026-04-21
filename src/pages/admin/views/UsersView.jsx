/* Admin → Members tab.
   Filterable, searchable member table. Row click opens the detail
   modal (state owned by shell via setSelectedUser). "Edit my account"
   button opens the caller's own record. */
export default function UsersView({
  members,
  schoolName,
  profile,
  setSelectedUser,
  openAddMember,
  roleFilter,
  setRoleFilter,
  memberSearch,
  setMemberSearch,
  visibleUsers,
  userSlugs,
  userOverallPct,
}) {
  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', gap: 12, marginBottom: 28, flexWrap: 'wrap' }}>
        <div>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Members</h2>
          <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>
            {members.length} members enrolled at {schoolName}
          </p>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          {profile && (
            <button
              type="button"
              onClick={() => {
                // Open the detail modal with the caller's own record so they can edit
                // their school, role, assignments, and grades.
                const mine = members.find(m => m.id === profile.id)
                setSelectedUser(mine ?? {
                  id: profile.id,
                  email: profile.email,
                  full_name: profile.full_name ?? '',
                  role: profile.role,
                  school_id: profile.school_id,
                  completions: {},
                })
              }}
              className="btn"
              style={{ fontSize: 12, fontWeight: 600, padding: '9px 16px', background: 'transparent', color: 'var(--cal-ink)', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-full)' }}
            >
              Edit my account
            </button>
          )}
          <button
            type="button"
            onClick={openAddMember}
            className="btn"
            style={{ fontSize: 12, fontWeight: 600, padding: '9px 16px', background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-full)' }}
          >
            + Add new member
          </button>
        </div>
      </div>

      {/* Role filter + search */}
      <div style={{ display: 'flex', gap: 10, marginBottom: 20, alignItems: 'center', flexWrap: 'wrap' }}>
        <div style={{ display: 'flex', gap: 6 }}>
          {['all', 'teacher', 'parent', 'admin', 'superadmin'].map(f => (
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
              }}
            >
              {f === 'all' ? 'All'
                : f === 'teacher' ? 'Teachers'
                : f === 'parent' ? 'Parents'
                : f === 'admin' ? 'Admins'
                : 'Superadmins'}
            </button>
          ))}
        </div>
        <input
          type="text"
          value={memberSearch}
          onChange={e => setMemberSearch(e.target.value)}
          placeholder="Search by name or email…"
          style={{
            flex: '1 1 240px', minWidth: 220, maxWidth: 360,
            padding: '7px 12px', fontSize: 13,
            border: '1.5px solid var(--cal-border)',
            borderRadius: 'var(--r-full)',
            background: '#fff',
            fontFamily: 'var(--font-body)',
            outline: 'none',
          }}
        />
        <span style={{ fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)' }}>
          {visibleUsers.length} of {members.length}
        </span>
      </div>

      <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden' }}>
        <table style={{ width: '100%', borderCollapse: 'collapse' }}>
          <thead>
            <tr style={{ background: 'var(--cal-surface)' }}>
              {['Member', 'Role', 'Modules assigned', 'Complete', 'Progress'].map(h => (
                <th key={h} style={{ textAlign: 'left', padding: '10px 20px', fontSize: 10, fontWeight: 600, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', letterSpacing: '0.08em', textTransform: 'uppercase', borderBottom: '1px solid var(--cal-border-lt)' }}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {visibleUsers.map((user, i) => {
              const slugs = userSlugs(user)
              const doneCount = slugs.filter(s => (user.completions[s] ?? 0) >= 80).length
              const overallPct = userOverallPct(user)
              const isSelf = profile && user.id === profile.id
              return (
                <tr key={user.id} style={{ background: i % 2 === 0 ? '#fff' : 'var(--cal-surface)', cursor: 'pointer' }}
                  onMouseEnter={e => e.currentTarget.style.background = 'var(--cal-teal-lt)'}
                  onMouseLeave={e => e.currentTarget.style.background = i % 2 === 0 ? '#fff' : 'var(--cal-surface)'}
                  onClick={() => setSelectedUser(user)}
                >
                  <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <div style={{
                        width: 32, height: 32, borderRadius: '50%', flexShrink: 0,
                        background: user.role === 'teacher' ? 'var(--cal-teal-lt)' : '#EDE7F6',
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                        fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                        color: user.role === 'teacher' ? 'var(--cal-teal)' : '#7B5EA7',
                      }}>
                        {user.full_name.split(' ').map(n => n[0]).join('').slice(0, 2)}
                      </div>
                      <div>
                        <div style={{ fontSize: 13, fontWeight: 500, display: 'flex', alignItems: 'center', gap: 8 }}>
                          {user.full_name}
                          {isSelf && (
                            <span style={{
                              fontSize: 9, fontWeight: 700, letterSpacing: '0.08em',
                              padding: '2px 7px', borderRadius: 'var(--r-full)',
                              background: 'var(--cal-teal)', color: '#fff',
                              textTransform: 'uppercase',
                            }}>You</span>
                          )}
                        </div>
                        <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>{user.email}</div>
                      </div>
                    </div>
                  </td>
                  <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                    <span className={`badge ${user.role === 'teacher' ? 'badge-assigned' : 'badge-progress'}`} style={user.role === 'parent' ? { background: '#EDE7F6', color: '#7B5EA7' } : {}}>
                      {user.role}
                    </span>
                  </td>
                  <td style={{ padding: '13px 20px', fontSize: 13, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)', textAlign: 'center' }}>
                    {slugs.length}
                  </td>
                  <td style={{ padding: '13px 20px', fontSize: 13, borderBottom: '1px solid var(--cal-border-lt)', textAlign: 'center' }}>
                    <span style={{ color: doneCount === slugs.length && slugs.length > 0 ? 'var(--cal-success)' : 'var(--cal-ink)', fontWeight: 600 }}>
                      {doneCount}/{slugs.length}
                    </span>
                  </td>
                  <td style={{ padding: '13px 20px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <div className="progress-track" style={{ flex: 1, height: 5 }}>
                        <div className={`progress-fill ${overallPct >= 80 ? 'green' : 'amber'}`} style={{ width: `${overallPct}%` }} />
                      </div>
                      <span style={{ fontSize: 11, color: 'var(--cal-muted)', minWidth: 28, textAlign: 'right' }}>{overallPct}%</span>
                    </div>
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
