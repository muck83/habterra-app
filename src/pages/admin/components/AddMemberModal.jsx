import { MODULE_META } from '../../../data/mockData'

/* Add-member modal: invite + optional auto-assign modules with due dates.
   All handlers owned by AdminDashboard shell; this is a pure render layer. */
export default function AddMemberModal({
  addMemberForm,
  setAddMemberForm,
  addMemberSaving,
  addMemberError,
  closeAddMember,
  toggleAddMemberModule,
  setAddMemberModuleDue,
  handleAddMember,
  isSuperAdmin,
}) {
  return (
    <div
      onClick={closeAddMember}
      style={{
        position: 'fixed', inset: 0,
        background: 'rgba(0,0,0,0.45)',
        display: 'flex', alignItems: 'flex-start', justifyContent: 'center',
        padding: '60px 20px 20px', zIndex: 1000, overflowY: 'auto',
      }}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          background: '#fff', borderRadius: 'var(--r-lg)',
          maxWidth: 560, width: '100%',
          boxShadow: 'var(--shadow-lg)',
          padding: 28,
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 18 }}>
          <div>
            <h3 style={{ fontFamily: 'var(--font-display)', fontSize: 20, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>
              Add new member
            </h3>
            <p style={{ fontSize: 12, color: 'var(--cal-muted)' }}>
              Invite a teacher, parent, or admin and optionally pre-assign modules.
            </p>
          </div>
          <button
            type="button"
            onClick={closeAddMember}
            aria-label="Close"
            style={{ border: 'none', background: 'transparent', fontSize: 22, color: 'var(--cal-muted)', cursor: 'pointer', lineHeight: 1 }}
          >×</button>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
              Full name
            </label>
            <input
              className="input"
              type="text"
              value={addMemberForm.fullName}
              onChange={e => setAddMemberForm(f => ({ ...f, fullName: e.target.value }))}
              placeholder="e.g. Eric Schoonard"
              style={{ width: '100%' }}
            />
          </div>

          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
              Email
            </label>
            <input
              className="input"
              type="email"
              value={addMemberForm.email}
              onChange={e => setAddMemberForm(f => ({ ...f, email: e.target.value }))}
              placeholder="name@school.org"
              style={{ width: '100%' }}
            />
          </div>

          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
              Role
            </label>
            <select
              value={addMemberForm.role}
              onChange={e => setAddMemberForm(f => ({ ...f, role: e.target.value }))}
              style={{
                width: '100%', padding: '9px 12px', fontSize: 13,
                border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                background: '#fff', cursor: 'pointer',
              }}
            >
              <option value="teacher">Teacher</option>
              <option value="parent">Parent</option>
              <option value="admin">Admin</option>
              {isSuperAdmin && <option value="superadmin">Superadmin</option>}
            </select>
          </div>

          {/* Admin-set initial password (optional). Setting one skips the
              invite email — the admin hands the password over out-of-band. */}
          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
              Initial password <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
            </label>
            <input
              className="input"
              type="text"
              autoComplete="new-password"
              value={addMemberForm.initialPassword}
              onChange={e => setAddMemberForm(f => ({ ...f, initialPassword: e.target.value }))}
              placeholder="Leave blank to send an invite email"
              style={{ width: '100%' }}
            />
            <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4, lineHeight: 1.5 }}>
              Set a password to create the account silently (no invite email). Min 8 chars.
              The user can sign in immediately and change it later from their profile,
              or you can trigger a reset link from their detail panel.
            </div>
          </div>

          {/* Send-invite toggle. Forced off when an initial password is set. */}
          <div>
            <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12, color: 'var(--cal-ink)', cursor: addMemberForm.initialPassword ? 'not-allowed' : 'pointer' }}>
              <input
                type="checkbox"
                checked={!addMemberForm.initialPassword && addMemberForm.sendEmail !== false}
                onChange={e => setAddMemberForm(f => ({ ...f, sendEmail: e.target.checked }))}
                disabled={!!addMemberForm.initialPassword}
                style={{ cursor: addMemberForm.initialPassword ? 'not-allowed' : 'pointer' }}
              />
              <span>Send Supabase invite email</span>
            </label>
            <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4, marginLeft: 24 }}>
              {addMemberForm.initialPassword
                ? 'Disabled — silent create (password above) skips the email.'
                : 'Uncheck to create the account without emailing the user.'}
            </div>
          </div>

          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 8 }}>
              Modules to auto-assign <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
            </label>
            <div style={{
              border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-sm)',
              maxHeight: 200, overflowY: 'auto',
            }}>
              {Object.entries(MODULE_META).map(([slug, m], i, arr) => {
                const checked = slug in addMemberForm.selectedModules
                return (
                  <div key={slug} style={{
                    display: 'flex', alignItems: 'center', gap: 10,
                    padding: '8px 12px',
                    borderBottom: i < arr.length - 1 ? '1px solid var(--cal-border-lt)' : 'none',
                    background: checked ? 'var(--cal-teal-lt)' : 'transparent',
                  }}>
                    <input
                      type="checkbox"
                      checked={checked}
                      onChange={() => toggleAddMemberModule(slug)}
                      style={{ cursor: 'pointer' }}
                    />
                    <div style={{ flex: 1, fontSize: 12 }}>
                      <span>{m.flag} {m.label?.replace('Understand ', '') ?? slug}</span>
                    </div>
                    {checked && (
                      <input
                        type="date"
                        value={addMemberForm.selectedModules[slug] ?? ''}
                        onChange={e => setAddMemberModuleDue(slug, e.target.value)}
                        style={{
                          fontSize: 11, padding: '4px 6px',
                          border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                        }}
                        title="Due date (optional)"
                      />
                    )}
                  </div>
                )
              })}
            </div>
          </div>

          <div>
            <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
              Welcome message <span style={{ color: 'var(--cal-muted)', fontWeight: 500 }}>(optional)</span>
            </label>
            <textarea
              value={addMemberForm.welcomeMessage}
              onChange={e => setAddMemberForm(f => ({ ...f, welcomeMessage: e.target.value }))}
              placeholder="Short note that goes out with the invite email."
              rows={3}
              style={{
                width: '100%', padding: '9px 12px', fontSize: 13,
                border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                fontFamily: 'inherit', resize: 'vertical',
              }}
            />
            <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
              Passed to the invite edge function as <code>welcome_message</code>; ignored until the backend surfaces it.
            </div>
          </div>

          {addMemberError && (
            <div style={{
              padding: '9px 12px',
              background: '#FFF4E5',
              border: '1px solid #F5C27A',
              borderRadius: 'var(--r-sm)',
              fontSize: 12,
              color: '#8A5A14',
            }}>
              {addMemberError}
            </div>
          )}

          <div style={{ display: 'flex', gap: 10, justifyContent: 'flex-end', paddingTop: 6 }}>
            <button
              type="button"
              onClick={closeAddMember}
              className="btn btn-ghost"
              disabled={addMemberSaving}
              style={{ fontSize: 13, padding: '9px 18px' }}
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={handleAddMember}
              className="btn"
              disabled={addMemberSaving}
              style={{
                fontSize: 13, padding: '9px 20px',
                background: 'var(--cal-teal)', color: '#fff',
                opacity: addMemberSaving ? 0.7 : 1,
              }}
            >
              {addMemberSaving ? 'Adding…' : 'Add member'}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
