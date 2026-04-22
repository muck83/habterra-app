import { MODULE_META } from '../../../data/mockData'
import { adminSendPasswordReset } from '../../../lib/supabase'
import { cellStatus, fmtDate } from '../utils'

/* Member detail modal (click-to-open from Members table).
   Shows identity, edit form, assignments (individual + inherited),
   add-module form, module progress override, grade overrides, and
   a soft-delete "Deactivate" action. All state + handlers are owned
   by the shell and injected as props so this stays presentational. */
export default function UserDetailModal({
  // identity / close
  selectedUser,
  setSelectedUser,
  profile,
  isSuperAdmin,
  allSchools,
  school,
  // edit mode
  editMode,
  setEditMode,
  editForm,
  setEditForm,
  editError,
  editSaving,
  openEditMode,
  cancelEditMode,
  saveMemberEdit,
  // password reset banner
  resetStatus,
  setResetStatus,
  // deactivate
  deactivateError,
  deactivateSaving,
  handleDeactivateUser,
  // assignments
  assignments,
  exclusions,
  dueDateEditing,
  setDueDateEditing,
  dueDateSaving,
  handleSaveDueDate,
  handleUnassign,
  handleExcludeFromInherited,
  handleUndoExclusion,
  // add module
  addModuleForm,
  setAddModuleForm,
  addModuleSaving,
  addModuleError,
  handleAddModuleToUser,
  // progress
  userCompletions,
  progressEdit,
  setProgressEdit,
  progressSaving,
  handleSaveProgress,
  // grades
  userScores,
  userOverrides,
  gradeOverrideForm,
  setGradeOverrideForm,
  gradeOverrideError,
  gradeOverrideSaving,
  openGradeOverride,
  closeGradeOverride,
  handleSaveGradeOverride,
}) {
  if (!selectedUser) return null

  return (
    <div
      onClick={() => setSelectedUser(null)}
      style={{
        position: 'fixed', inset: 0,
        background: 'rgba(10,30,35,0.45)',
        zIndex: 200,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <div
        onClick={e => e.stopPropagation()}
        style={{
          background: '#fff',
          borderRadius: 'var(--r-lg)',
          boxShadow: 'var(--shadow-lg)',
          width: '100%',
          maxWidth: 520,
          margin: '20px',
          // Cap at viewport height and scroll the body instead of letting
          // the modal grow past the fold. The header stays pinned so the
          // user always sees who they're editing.
          maxHeight: 'calc(100vh - 40px)',
          display: 'flex',
          flexDirection: 'column',
          overflow: 'hidden',
        }}
      >
        {/* Modal header */}
        <div style={{
          background: 'var(--cal-teal)',
          padding: '22px 26px',
          display: 'flex',
          alignItems: 'center',
          gap: 14,
          flexShrink: 0,
        }}>
          <div style={{
            width: 44, height: 44, borderRadius: '50%', flexShrink: 0,
            background: 'rgba(255,255,255,0.22)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16, color: '#fff',
          }}>
            {(selectedUser.full_name || selectedUser.email || '?').slice(0, 1).toUpperCase()}
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 700, color: '#fff', marginBottom: 2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {selectedUser.full_name || selectedUser.email}
            </div>
            <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.75)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {selectedUser.email} · {selectedUser.role}
            </div>
          </div>
          {!editMode && (
            <>
              <button
                type="button"
                onClick={async () => {
                  if (!selectedUser?.email) return
                  if (resetStatus.status === 'sending') return
                  setResetStatus({ status: 'sending' })
                  try {
                    await adminSendPasswordReset(selectedUser.email)
                    setResetStatus({ status: 'sent', message: `Reset link sent to ${selectedUser.email}` })
                  } catch (err) {
                    setResetStatus({ status: 'error', message: err?.message ?? 'Failed to send reset link.' })
                  }
                }}
                disabled={resetStatus.status === 'sending'}
                title="Send a password reset email to this member"
                style={{
                  background: 'rgba(255,255,255,0.18)', color: '#fff',
                  border: '1px solid rgba(255,255,255,0.3)',
                  borderRadius: 'var(--r-sm)', padding: '6px 12px',
                  fontSize: 12, fontFamily: 'var(--font-display)', fontWeight: 600,
                  cursor: resetStatus.status === 'sending' ? 'wait' : 'pointer',
                  marginRight: 8,
                }}
              >
                {resetStatus.status === 'sending' ? 'Sending…' : 'Send reset link'}
              </button>
              <button
                type="button"
                onClick={openEditMode}
                style={{
                  background: 'rgba(255,255,255,0.18)', color: '#fff',
                  border: '1px solid rgba(255,255,255,0.3)',
                  borderRadius: 'var(--r-sm)', padding: '6px 12px',
                  fontSize: 12, fontFamily: 'var(--font-display)', fontWeight: 600,
                  cursor: 'pointer', marginRight: 8,
                }}
              >Edit</button>
            </>
          )}
          <button
            type="button"
            onClick={() => { setEditMode(false); setSelectedUser(null); setResetStatus({ status: 'idle' }) }}
            aria-label="Close"
            style={{
              background: 'transparent', border: 'none', color: '#fff',
              fontSize: 22, cursor: 'pointer', padding: 4, lineHeight: 1,
            }}
          >×</button>
        </div>

        {/* Modal body */}
        <div style={{ padding: '22px 26px', overflowY: 'auto', flex: 1 }}>

          {resetStatus.status !== 'idle' && resetStatus.status !== 'sending' && (
            <div style={{
              marginBottom: 14,
              padding: '10px 14px',
              borderRadius: 'var(--r-sm)',
              fontSize: 12,
              background: resetStatus.status === 'sent' ? 'var(--cal-success-lt)' : '#FFEBEE',
              color: resetStatus.status === 'sent' ? 'var(--cal-success)' : '#C62828',
              display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 8,
            }}>
              <span>
                {resetStatus.status === 'sent' ? '\u2713 ' : ''}
                {resetStatus.message}
              </span>
              <button
                type="button"
                onClick={() => setResetStatus({ status: 'idle' })}
                style={{ background: 'transparent', border: 'none', cursor: 'pointer', color: 'inherit', fontSize: 14, padding: 0 }}
                aria-label="Dismiss"
              >\u00d7</button>
            </div>
          )}

          {editMode && (
            <div style={{
              background: 'var(--cal-surface)', borderRadius: 'var(--r-md)',
              padding: 18, marginBottom: 20,
              border: '1px solid var(--cal-border-lt)',
            }}>
              <div className="label-caps" style={{ marginBottom: 12 }}>Edit member</div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                <div>
                  <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                    Full name
                  </label>
                  <input
                    className="input"
                    type="text"
                    value={editForm.fullName}
                    onChange={e => setEditForm(f => ({ ...f, fullName: e.target.value }))}
                    placeholder="e.g. Eric Schoonard"
                    style={{ width: '100%' }}
                  />
                </div>

                <div>
                  <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                    Email
                  </label>
                  <input
                    type="email"
                    value={selectedUser.email ?? ''}
                    disabled
                    style={{
                      width: '100%', padding: '9px 12px', fontSize: 13,
                      background: '#F5F5F5', color: 'var(--cal-muted)',
                      border: '1px solid var(--cal-border-lt)', borderRadius: 'var(--r-sm)',
                    }}
                  />
                  <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
                    Email is tied to the sign-in and can't be changed from this screen.
                  </div>
                </div>

                <div>
                  <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                    Role
                  </label>
                  <select
                    value={editForm.role}
                    onChange={e => setEditForm(f => ({ ...f, role: e.target.value }))}
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

                {(isSuperAdmin || (profile && selectedUser && selectedUser.id === profile.id)) && (
                  <div>
                    <label style={{ display: 'block', fontSize: 11, fontWeight: 600, fontFamily: 'var(--font-display)', color: 'var(--cal-ink-soft)', marginBottom: 5 }}>
                      School
                    </label>
                    <select
                      value={editForm.schoolId}
                      onChange={e => setEditForm(f => ({ ...f, schoolId: e.target.value }))}
                      style={{
                        width: '100%', padding: '9px 12px', fontSize: 13,
                        border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                        background: '#fff', cursor: 'pointer',
                      }}
                    >
                      <option value="">— select school —</option>
                      {allSchools.map(s => (
                        <option key={s.id} value={s.id}>{s.name}</option>
                      ))}
                      {/* Fall back to caller's current school so it stays selectable
                          even when `getAllSchools()` is gated to superadmin. */}
                      {!isSuperAdmin && selectedUser?.school_id && !allSchools.some(s => s.id === selectedUser.school_id) && (
                        <option value={selectedUser.school_id}>
                          {school?.name ?? 'Current school'}
                        </option>
                      )}
                    </select>
                    <div style={{ fontSize: 10, color: 'var(--cal-muted)', marginTop: 4 }}>
                      {isSuperAdmin
                        ? 'Superadmin only. Moving a member to another school updates their roster and assignments on next sign-in.'
                        : 'Changing your own school updates your roster on next sign-in. Contact a superadmin if the right school isn\u2019t listed.'}
                    </div>
                  </div>
                )}

                {editError && (
                  <div style={{ background: '#FFEBEE', color: '#C62828', padding: '8px 12px', borderRadius: 'var(--r-sm)', fontSize: 12 }}>
                    {editError}
                  </div>
                )}

                <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end', marginTop: 4 }}>
                  <button
                    type="button"
                    onClick={cancelEditMode}
                    disabled={editSaving}
                    className="btn"
                    style={{ fontSize: 12, padding: '8px 14px', background: 'transparent', border: '1px solid var(--cal-border)', color: 'var(--cal-ink)' }}
                  >Cancel</button>
                  <button
                    type="button"
                    onClick={saveMemberEdit}
                    disabled={editSaving || !editForm.fullName.trim()}
                    className="btn"
                    style={{ fontSize: 12, padding: '8px 14px', background: 'var(--cal-teal)', color: '#fff' }}
                  >{editSaving ? 'Saving…' : 'Save changes'}</button>
                </div>

                {/* Danger zone — soft-delete. Hidden for self so Mark */}
                {/* can't accidentally deactivate his own account.     */}
                {profile && selectedUser && selectedUser.id !== profile.id && (
                  <div style={{
                    marginTop: 18, padding: 14,
                    border: '1px solid #F5C2C2', borderRadius: 'var(--r-md)',
                    background: '#FFF7F7',
                  }}>
                    <div style={{
                      fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                      letterSpacing: '0.08em', color: '#8B1F1F', textTransform: 'uppercase',
                      marginBottom: 6,
                    }}>Danger zone</div>
                    <div style={{ fontSize: 12, color: '#6B2323', lineHeight: 1.5, marginBottom: 10 }}>
                      Deactivating hides this user from the members list, revokes their login, and clears all their assignments and module progress. Use this for test accounts or users who should no longer have access. A superadmin can reactivate them later in Supabase by flipping <code>profiles.is_active</code> back to <code>true</code>.
                    </div>
                    {deactivateError && (
                      <div style={{ background: '#FFEBEE', color: '#C62828', padding: '8px 12px', borderRadius: 'var(--r-sm)', fontSize: 12, marginBottom: 10 }}>
                        {deactivateError}
                      </div>
                    )}
                    <button
                      type="button"
                      onClick={handleDeactivateUser}
                      disabled={deactivateSaving || editSaving}
                      className="btn"
                      style={{
                        fontSize: 12, padding: '8px 14px',
                        background: '#fff', color: '#C62828',
                        border: '1.5px solid #C62828',
                        cursor: deactivateSaving ? 'wait' : 'pointer',
                      }}
                    >{deactivateSaving ? 'Deactivating…' : 'Deactivate user'}</button>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Assignments: individual (removable) + inherited from role buckets.
              Inherited rows can be excluded per-user via assignment_exclusions. */}
          <div className="label-caps" style={{ marginBottom: 12 }}>Assignments</div>
          {(() => {
            const individual = assignments.filter(a => a.user_id === selectedUser.id)
            const inheritedAll = assignments.filter(a =>
              !a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)
            )
            // Index exclusions by assignment_id for this user.
            const exclusionByAssignment = new Map(
              (exclusions ?? [])
                .filter(e => e.user_id === selectedUser.id)
                .map(e => [e.assignment_id, e])
            )
            const inherited = inheritedAll.filter(a => !exclusionByAssignment.has(a.id))
            const excluded  = inheritedAll.filter(a =>  exclusionByAssignment.has(a.id))
            if (individual.length === 0 && inherited.length === 0 && excluded.length === 0) {
              return (
                <div style={{ fontSize: 13, color: 'var(--cal-muted)', marginBottom: 22 }}>
                  No assignments yet.
                </div>
              )
            }
            return (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 22 }}>
                {individual.map(a => {
                  const meta = MODULE_META[a.module_slug]
                  return (
                    <div key={a.id} style={{
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '10px 12px', borderRadius: 'var(--r-md)',
                      background: 'var(--cal-surface)',
                      border: '1px solid var(--cal-border-lt)',
                    }}>
                      <span style={{ fontSize: 18 }}>{meta?.flag ?? '🌏'}</span>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {meta?.label ?? a.module_slug}
                        </div>
                        <div style={{ fontSize: 10, color: 'var(--cal-muted)', display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                          <span>Individual ·</span>
                          <input
                            type="date"
                            value={dueDateEditing[a.id] !== undefined ? dueDateEditing[a.id] : (a.due_date ?? '')}
                            onChange={e => setDueDateEditing(prev => ({ ...prev, [a.id]: e.target.value }))}
                            style={{ fontSize: 10, padding: '2px 4px', border: '1px solid var(--cal-border-lt)', borderRadius: 3 }}
                          />
                          {dueDateEditing[a.id] !== undefined && dueDateEditing[a.id] !== (a.due_date ?? '') && (
                            <button
                              type="button"
                              onClick={() => handleSaveDueDate(a)}
                              disabled={dueDateSaving === a.id}
                              style={{ fontSize: 10, padding: '2px 8px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}
                            >{dueDateSaving === a.id ? '…' : 'Save'}</button>
                          )}
                        </div>
                      </div>
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
                  )
                })}
                {inherited.map(a => {
                  const meta = MODULE_META[a.module_slug]
                  const via = a.role_target === 'all' ? 'Everyone' : `${a.role_target}s`
                  return (
                    <div key={a.id} style={{
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '10px 12px', borderRadius: 'var(--r-md)',
                      background: 'transparent',
                      border: '1px dashed var(--cal-border-lt)',
                    }}>
                      <span style={{ fontSize: 18, opacity: 0.75 }}>{meta?.flag ?? '🌏'}</span>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ fontSize: 13, color: 'var(--cal-ink-soft)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {meta?.label ?? a.module_slug}
                        </div>
                        <div style={{ fontSize: 10, color: 'var(--cal-muted)' }}>
                          via {via}{a.due_date && ` · Due ${fmtDate(a.due_date)}`}
                        </div>
                      </div>
                      <span style={{
                        fontFamily: 'var(--font-display)', fontSize: 9, fontWeight: 600,
                        letterSpacing: '0.06em', textTransform: 'uppercase',
                        color: 'var(--cal-muted)',
                        padding: '3px 7px', borderRadius: 'var(--r-sm)',
                        border: '1px solid var(--cal-border-lt)',
                      }}>Inherited</span>
                      {handleExcludeFromInherited && (
                        <button
                          type="button"
                          onClick={() => handleExcludeFromInherited(a, selectedUser)}
                          title={`Remove ${meta?.label ?? a.module_slug} just for this user`}
                          aria-label={`Remove ${meta?.label ?? a.module_slug} just for this user`}
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
                      )}
                    </div>
                  )
                })}
                {excluded.map(a => {
                  const meta = MODULE_META[a.module_slug]
                  const exclusion = exclusionByAssignment.get(a.id)
                  return (
                    <div key={`excluded-${a.id}`} style={{
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '10px 12px', borderRadius: 'var(--r-md)',
                      background: 'transparent',
                      border: '1px dashed #F5C2C2',
                      opacity: 0.85,
                    }}>
                      <span style={{ fontSize: 18, opacity: 0.5, textDecoration: 'line-through' }}>
                        {meta?.flag ?? '🌏'}
                      </span>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ fontSize: 13, color: 'var(--cal-muted)', textDecoration: 'line-through', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                          {meta?.label ?? a.module_slug}
                        </div>
                        <div style={{ fontSize: 10, color: '#B3261E' }}>
                          Excluded for this user
                        </div>
                      </div>
                      {handleUndoExclusion && (
                        <button
                          type="button"
                          onClick={() => handleUndoExclusion(exclusion)}
                          title="Restore this inherited assignment"
                          style={{
                            fontFamily: 'var(--font-display)',
                            fontSize: 10, fontWeight: 600, letterSpacing: '0.04em',
                            textTransform: 'uppercase',
                            padding: '4px 10px', borderRadius: 'var(--r-sm)',
                            border: '1px solid var(--cal-border)',
                            background: '#fff',
                            color: 'var(--cal-ink-soft)',
                            cursor: 'pointer',
                          }}
                        >Restore</button>
                      )}
                    </div>
                  )
                })}
              </div>
            )
          })()}

          {/* Add module assignment */}
          <div style={{
            background: 'var(--cal-surface)', borderRadius: 'var(--r-md)',
            padding: 12, marginBottom: 22,
            border: '1px dashed var(--cal-border-lt)',
          }}>
            <div className="label-caps" style={{ marginBottom: 8 }}>Add module to this user</div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, alignItems: 'center' }}>
              <select
                value={addModuleForm.slug}
                onChange={e => setAddModuleForm(f => ({ ...f, slug: e.target.value }))}
                style={{
                  flex: 1, minWidth: 180,
                  padding: '7px 10px', fontSize: 12,
                  border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                  background: '#fff', cursor: 'pointer',
                }}
              >
                <option value="">— pick a module —</option>
                {Object.entries(MODULE_META).map(([slug, m]) => {
                  const alreadyAssigned = assignments.some(a => a.user_id === selectedUser.id && a.module_slug === slug)
                  return (
                    <option key={slug} value={slug} disabled={alreadyAssigned}>
                      {m.flag} {m.label?.replace('Understand ', '') ?? slug}{alreadyAssigned ? ' (already assigned)' : ''}
                    </option>
                  )
                })}
              </select>
              <input
                type="date"
                value={addModuleForm.dueDate}
                onChange={e => setAddModuleForm(f => ({ ...f, dueDate: e.target.value }))}
                title="Due date (optional)"
                style={{ fontSize: 12, padding: '6px 8px', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-sm)' }}
              />
              <button
                type="button"
                onClick={handleAddModuleToUser}
                disabled={!addModuleForm.slug || addModuleSaving}
                className="btn"
                style={{ fontSize: 12, padding: '7px 14px', background: 'var(--cal-teal)', color: '#fff' }}
              >{addModuleSaving ? 'Adding…' : 'Add'}</button>
            </div>
            {addModuleError && (
              <div style={{ marginTop: 8, fontSize: 11, color: '#C62828' }}>{addModuleError}</div>
            )}
          </div>

          {/* Module progress */}
          <div className="label-caps" style={{ marginBottom: 12 }}>Module progress</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
            {(() => {
              // Excluded assignment IDs for this user (role-level rows the
              // admin explicitly removed via assignment_exclusions).
              const excludedIds = new Set(
                (exclusions ?? [])
                  .filter(e => e.user_id === selectedUser.id)
                  .map(e => e.assignment_id)
              )
              const userAssignmentSlugs = new Set(
                assignments
                  .filter(a =>
                    (a.user_id === selectedUser.id
                      || (!a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)))
                    && !excludedIds.has(a.id)
                  )
                  .map(a => a.module_slug)
              )
              const slugs = Array.from(userAssignmentSlugs)
              if (slugs.length === 0) {
                return (
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)', fontStyle: 'italic' }}>
                    No modules assigned yet.
                  </div>
                )
              }
              return slugs.map(slug => {
                const meta = MODULE_META[slug]
                const realPct = Math.max(0, Math.min(100, Math.round(userCompletions[slug] ?? 0)))
                const editing = progressEdit[slug] !== undefined
                const displayPct = editing ? Math.max(0, Math.min(100, Number(progressEdit[slug]) || 0)) : realPct
                return (
                  <div key={slug} style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
                    <span style={{
                      fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 700,
                      letterSpacing: '0.06em', color: 'var(--cal-teal)',
                      background: 'var(--cal-surface)', padding: '3px 7px',
                      borderRadius: 'var(--r-sm)', border: '1px solid var(--cal-border)',
                    }}>{meta?.flag ?? slug}</span>
                    <div style={{ flex: 1, minWidth: 120 }}>
                      <div style={{ fontSize: 13, color: 'var(--cal-ink)', marginBottom: 4, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                        {meta?.label ?? slug}
                      </div>
                      <div className="progress-track" style={{ height: 4 }}>
                        <div className={`progress-fill ${cellStatus(displayPct) === 'done' ? 'green' : cellStatus(displayPct) === 'progress' ? 'amber' : ''}`} style={{ width: `${displayPct}%` }} />
                      </div>
                    </div>
                    <input
                      type="number"
                      min={0}
                      max={100}
                      value={editing ? progressEdit[slug] : realPct}
                      onChange={e => setProgressEdit(prev => ({ ...prev, [slug]: e.target.value }))}
                      style={{
                        width: 60, fontSize: 12, padding: '4px 6px',
                        border: '1px solid var(--cal-border)', borderRadius: 'var(--r-sm)',
                        textAlign: 'right',
                      }}
                      title="Override progress %"
                    />
                    <span style={{ fontSize: 11, color: 'var(--cal-muted)' }}>%</span>
                    {editing && Number(progressEdit[slug]) !== realPct && (
                      <button
                        type="button"
                        onClick={() => handleSaveProgress(slug)}
                        disabled={progressSaving === slug}
                        style={{ fontSize: 11, padding: '3px 10px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}
                      >{progressSaving === slug ? '…' : 'Save'}</button>
                    )}
                  </div>
                )
              })
            })()}
          </div>

          {/* Grades (quiz + final exam) */}
          <div className="label-caps" style={{ marginBottom: 12 }}>Grades</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
            {(() => {
              // Excluded assignment IDs for this user (role-level rows the
              // admin explicitly removed via assignment_exclusions).
              const excludedIds = new Set(
                (exclusions ?? [])
                  .filter(e => e.user_id === selectedUser.id)
                  .map(e => e.assignment_id)
              )
              const userAssignmentSlugs = new Set(
                assignments
                  .filter(a =>
                    (a.user_id === selectedUser.id
                      || (!a.user_id && (a.role_target === 'all' || a.role_target === selectedUser.role)))
                    && !excludedIds.has(a.id)
                  )
                  .map(a => a.module_slug)
              )
              const slugs = Array.from(userAssignmentSlugs)
              if (slugs.length === 0) {
                return (
                  <div style={{ fontSize: 12, color: 'var(--cal-muted)', fontStyle: 'italic' }}>
                    No modules assigned yet.
                  </div>
                )
              }
              const QUIZ_TYPES = [
                { key: 'checkpoint', label: 'Checkpoints' },
                { key: 'final_exam', label: 'Final exam' },
              ]
              return slugs.map(slug => {
                const meta = MODULE_META[slug]
                const scoreByType = userScores[slug] ?? {}
                return (
                  <div key={slug} style={{
                    padding: '10px 12px', borderRadius: 'var(--r-md)',
                    background: 'var(--cal-surface)',
                    border: '1px solid var(--cal-border-lt)',
                  }}>
                    <div style={{ fontSize: 13, fontWeight: 500, color: 'var(--cal-ink)', marginBottom: 6 }}>
                      {meta?.flag ?? '🌏'} {meta?.label ?? slug}
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
                      {QUIZ_TYPES.map(qt => {
                        const baseScore = scoreByType[qt.key]
                        const override = userOverrides.find(o => o.module_slug === slug && o.quiz_type === qt.key)
                        const hasData = baseScore || override
                        return (
                          <div key={qt.key} style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap', fontSize: 11 }}>
                            <span style={{ minWidth: 90, color: 'var(--cal-muted)' }}>{qt.label}</span>
                            {hasData ? (
                              <>
                                {override ? (
                                  <span style={{ fontWeight: 600, color: 'var(--cal-ink)' }}>
                                    {override.override_score}%
                                    <span style={{ marginLeft: 6, fontSize: 9, fontWeight: 500, color: '#8e5400', background: '#FFF3E0', padding: '1px 5px', borderRadius: 3 }}>OVERRIDE</span>
                                    {baseScore && (
                                      <span style={{ marginLeft: 6, color: 'var(--cal-muted)', textDecoration: 'line-through' }}>{baseScore.pct}%</span>
                                    )}
                                  </span>
                                ) : (
                                  <span style={{ fontWeight: 600, color: 'var(--cal-ink)' }}>
                                    {baseScore.pct}% <span style={{ fontWeight: 400, color: 'var(--cal-muted)' }}>({baseScore.correct}/{baseScore.total})</span>
                                  </span>
                                )}
                              </>
                            ) : (
                              <span style={{ color: 'var(--cal-muted)', fontStyle: 'italic' }}>—</span>
                            )}
                            <button
                              type="button"
                              onClick={() => openGradeOverride(slug, qt.key, override?.override_score ?? baseScore?.pct)}
                              style={{ marginLeft: 'auto', fontSize: 10, padding: '2px 8px', background: 'transparent', border: '1px solid var(--cal-border)', borderRadius: 3, color: 'var(--cal-ink)', cursor: 'pointer' }}
                            >{override ? 'Change' : 'Override'}</button>
                          </div>
                        )
                      })}
                      {gradeOverrideForm && gradeOverrideForm.slug === slug && (
                        <div style={{
                          marginTop: 8, padding: 10,
                          background: '#fff', borderRadius: 'var(--r-sm)',
                          border: '1.5px solid var(--cal-teal)',
                          display: 'flex', flexDirection: 'column', gap: 6,
                        }}>
                          <div style={{ fontSize: 10, fontWeight: 600, color: 'var(--cal-ink-soft)', fontFamily: 'var(--font-display)', letterSpacing: '0.06em', textTransform: 'uppercase' }}>
                            Override {gradeOverrideForm.quizType === 'final_exam' ? 'final exam' : 'checkpoints'}
                          </div>
                          <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                            <input
                              type="number" min={0} max={100}
                              value={gradeOverrideForm.score}
                              onChange={e => setGradeOverrideForm(f => ({ ...f, score: e.target.value }))}
                              placeholder="Score"
                              style={{ width: 80, fontSize: 12, padding: '5px 8px', border: '1px solid var(--cal-border)', borderRadius: 3 }}
                            />
                            <span style={{ fontSize: 11, color: 'var(--cal-muted)' }}>%</span>
                          </div>
                          <textarea
                            value={gradeOverrideForm.reason}
                            onChange={e => setGradeOverrideForm(f => ({ ...f, reason: e.target.value }))}
                            placeholder="Reason for override (required for audit)"
                            rows={2}
                            style={{ fontSize: 11, padding: '5px 8px', border: '1px solid var(--cal-border)', borderRadius: 3, fontFamily: 'inherit', resize: 'vertical' }}
                          />
                          {gradeOverrideError && (
                            <div style={{ fontSize: 10, color: '#C62828' }}>{gradeOverrideError}</div>
                          )}
                          <div style={{ display: 'flex', gap: 6, justifyContent: 'flex-end' }}>
                            <button type="button" onClick={closeGradeOverride} disabled={gradeOverrideSaving}
                              style={{ fontSize: 11, padding: '4px 10px', background: 'transparent', border: '1px solid var(--cal-border)', borderRadius: 3, cursor: 'pointer' }}>Cancel</button>
                            <button type="button" onClick={handleSaveGradeOverride} disabled={gradeOverrideSaving || !gradeOverrideForm.score}
                              style={{ fontSize: 11, padding: '4px 10px', background: 'var(--cal-teal)', color: '#fff', border: 'none', borderRadius: 3, cursor: 'pointer' }}>
                              {gradeOverrideSaving ? 'Saving…' : 'Save override'}</button>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                )
              })
            })()}
          </div>

          <div style={{ marginTop: 18, display: 'flex', justifyContent: 'flex-end' }}>
            <button
              type="button"
              onClick={() => setSelectedUser(null)}
              className="btn"
              style={{ fontSize: 13, padding: '9px 18px', background: 'var(--cal-teal)', color: '#fff' }}
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
