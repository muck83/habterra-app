import { MOCK_MODE, inviteStatusStyles } from '../utils'

/* Admin → Invite tab.
   Left column: single-invite form. Right column: CSV bulk import
   with row-by-row preview and per-row status. The `{false && ...}`
   block is dead-coded legacy copy kept intentionally for now. */
export default function InviteView({
  handleSingleInvite,
  inviteForm,
  setInviteForm,
  inviteSaved,
  inviteError,
  csvImporting,
  handleCsvFile,
  csvError,
  csvRows,
  csvSummary,
  csvImportableCount,
  handleCsvImport,
}) {
  return (
    <>
      <div style={{ marginBottom: 28 }}>
        <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 22, fontWeight: 700, color: 'var(--cal-ink)', marginBottom: 4 }}>Invite a member</h2>
        <p style={{ fontSize: 13, color: 'var(--cal-muted)' }}>Send an invitation to a new teacher or parent. They'll receive a link to set their password.</p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24, maxWidth: 860 }}>
        {/* Invite form */}
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 22 }}>New invitation</div>
          <form
            onSubmit={handleSingleInvite}
            style={{ display: 'flex', flexDirection: 'column', gap: 18 }}
          >
            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>Email address</label>
              <input className="input" type="email" placeholder="teacher@woodstockschool.in" value={inviteForm.email} onChange={e => setInviteForm(f => ({ ...f, email: e.target.value }))} required />
            </div>
            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>
                Full name <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>(optional)</span>
              </label>
              <input className="input" type="text" placeholder="Jane Smith" value={inviteForm.fullName} onChange={e => setInviteForm(f => ({ ...f, fullName: e.target.value }))} />
            </div>
            <div>
              <label style={{ display: 'block', fontSize: 12, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 7 }}>Role</label>
              <div style={{ display: 'flex', gap: 8 }}>
                {[{ val: 'teacher', label: 'Teacher' }, { val: 'parent', label: 'Parent' }].map(opt => (
                  <button key={opt.val} type="button" onClick={() => setInviteForm(f => ({ ...f, role: opt.val }))} style={{ flex: 1, padding: '10px 8px', border: '1.5px solid', borderRadius: 'var(--r-md)', cursor: 'pointer', fontSize: 13, fontFamily: 'var(--font-display)', fontWeight: 600, borderColor: inviteForm.role === opt.val ? 'var(--cal-teal)' : 'var(--cal-border)', background: inviteForm.role === opt.val ? 'var(--cal-teal-lt)' : 'transparent', color: inviteForm.role === opt.val ? 'var(--cal-teal)' : 'var(--cal-muted)' }}>{opt.label}</button>
                ))}
              </div>
            </div>
            {inviteSaved && (
              <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: 'var(--cal-success)', fontWeight: 500 }}>
                ✓ Invitation sent{MOCK_MODE ? <span style={{ fontWeight: 400, opacity: 0.8 }}> (demo — no email sent)</span> : ''}
              </div>
            )}
            {inviteError && (
              <div style={{ background: '#FDEDED', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 13, color: '#B3261E', fontWeight: 500 }}>
                {inviteError}
              </div>
            )}
            <button type="submit" className="btn btn-primary btn-full" style={{ marginTop: 4, padding: '13px', fontSize: 14 }}>Send invitation →</button>
          </form>
        </div>

        {/* Bulk CSV import */}
        <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', padding: '28px 28px' }}>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 15, fontWeight: 600, color: 'var(--cal-ink)', marginBottom: 14 }}>Bulk import</div>
          <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.75, marginBottom: 14 }}>
            Upload a CSV of teachers and parents. Habterra validates the file, imports valid rows one at a time, and records the batch for follow-up.
          </div>

          <div className="label-caps" style={{ marginBottom: 8 }}>Expected format</div>
          <div style={{ background: 'var(--cal-surface)', borderRadius: 'var(--r-md)', padding: '12px 14px', fontSize: 11, fontFamily: 'monospace', color: 'var(--cal-ink-soft)', lineHeight: 1.7, marginBottom: 16, border: '1px solid var(--cal-border)', whiteSpace: 'pre-wrap' }}>
            {'email,full_name,role\nteacher.one@school.com,Teacher One,teacher\nparent.one@gmail.com,Parent One,parent'}
          </div>

          <input
            type="file"
            accept=".csv,text/csv"
            disabled={csvImporting}
            onChange={handleCsvFile}
            style={{
              display: 'block',
              width: '100%',
              fontSize: 12,
              color: 'var(--cal-muted)',
              marginBottom: 14,
            }}
          />

          {csvError && (
            <div style={{ background: '#FDEDED', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 12, color: '#B3261E', lineHeight: 1.5, marginBottom: 14 }}>
              {csvError}
            </div>
          )}

          {csvRows.length > 0 && (
            <>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                <div className="label-caps">Preview</div>
                <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>
                  {csvRows.length} row{csvRows.length !== 1 ? 's' : ''} loaded
                </div>
              </div>

              <div style={{ maxHeight: 312, overflowY: 'auto', border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-md)', marginBottom: 14 }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', minWidth: 520 }}>
                  <thead>
                    <tr style={{ background: 'var(--cal-surface)' }}>
                      {['Email', 'Name', 'Role', 'Status'].map(label => (
                        <th key={label} style={{ textAlign: 'left', padding: '9px 10px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700, color: 'var(--cal-muted)', borderBottom: '1px solid var(--cal-border-lt)' }}>
                          {label}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {csvRows.map((row, idx) => {
                      const statusStyle = inviteStatusStyles(row.status)
                      return (
                        <tr key={row.id} style={{ background: idx % 2 === 0 ? '#fff' : 'var(--cal-surface)' }}>
                          <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-ink)' }}>{row.email || '-'}</td>
                          <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-muted)' }}>{row.fullName || '-'}</td>
                          <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11, color: 'var(--cal-muted)', textTransform: 'capitalize' }}>{row.role || '-'}</td>
                          <td style={{ padding: '9px 10px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 11 }}>
                            <span style={{ display: 'inline-flex', alignItems: 'center', borderRadius: 'var(--r-full)', padding: '3px 8px', fontWeight: 700, textTransform: 'capitalize', ...statusStyle }}>
                              {row.status}
                            </span>
                            {row.error && (
                              <div style={{ marginTop: 4, color: '#B3261E', lineHeight: 1.4 }}>
                                {row.error}
                              </div>
                            )}
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>

              {csvSummary && (
                <div style={{ background: 'var(--cal-success-lt)', borderRadius: 'var(--r-sm)', padding: '10px 14px', fontSize: 12, color: 'var(--cal-success)', fontWeight: 700, marginBottom: 14 }}>
                  {csvSummary.imported} imported &middot; {csvSummary.failed} failed
                </div>
              )}

              <button
                type="button"
                className="btn btn-primary btn-full"
                disabled={csvImporting || csvImportableCount === 0}
                onClick={handleCsvImport}
                style={{ padding: '13px', fontSize: 14, opacity: csvImporting || csvImportableCount === 0 ? 0.55 : 1 }}
              >
                {csvImporting ? 'Importing...' : `Import ${csvImportableCount} user${csvImportableCount !== 1 ? 's' : ''}`}
              </button>
            </>
          )}

          {false && (
            <>
          <div style={{ fontSize: 13, color: 'var(--cal-muted)', lineHeight: 1.75, marginBottom: 18 }}>
            For onboarding larger groups — 80 teachers and 400 parents — use the SQL seed template to import all users in one step directly in the Supabase dashboard.
          </div>
          <div style={{ background: 'var(--cal-surface)', borderRadius: 'var(--r-md)', padding: '12px 14px', fontSize: 11, fontFamily: 'monospace', color: 'var(--cal-ink-soft)', lineHeight: 1.7, marginBottom: 16, border: '1px solid var(--cal-border)' }}>
            {'-- woodstock_user_import.sql\n-- 1. Insert into auth.users\n-- 2. Insert into public.profiles\n-- 3. Run woodstock_india_assign.sql'}
          </div>
          <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
            See <strong style={{ color: 'var(--cal-teal)' }}>woodstock_user_import.sql</strong> in the project root for the full template.
          </div>
          <div style={{ marginTop: 20, borderTop: '1px solid var(--cal-border-lt)', paddingTop: 18 }}>
            <div className="label-caps" style={{ marginBottom: 8 }}>CSV import — v2</div>
            <div style={{ fontSize: 12, color: 'var(--cal-muted)', lineHeight: 1.7 }}>
              Upload a CSV with email, name, role, and grade (for parents). Habterra will create accounts and send invitations automatically.
            </div>
          </div>
            </>
          )}
        </div>
      </div>
    </>
  )
}
