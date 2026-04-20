import { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import ErrorState from '../components/ErrorState'
import WoodstockEditor from './superadmin/WoodstockEditor'
import {
  getAllDimensions,
  getAllModules,
  updateDimension,
  updateModule,
  updateModuleStatus,
} from '../lib/supabase'

const WOODSTOCK_MODULE_ID = 'woodstock-001'

const FETCH_TIMEOUT_MS = 8000

const STATUS_STYLE = {
  live: { background: 'var(--cal-teal-lt)', color: 'var(--cal-teal)' },
  draft: { background: 'var(--cal-amber-lt)', color: 'var(--cal-amber-dark)' },
  archived: { background: 'var(--cal-border-lt)', color: 'var(--cal-muted)' },
}

function statusStyle(status) {
  return STATUS_STYLE[status] ?? STATUS_STYLE.archived
}

function prettyJson(value) {
  return JSON.stringify(value ?? {}, null, 2)
}

function hasUnsaved(editor) {
  if (!editor) return false
  return editor.title !== editor.originalTitle || editor.contentText !== editor.originalContentText
}

function moduleDisplayTitle(module) {
  if (!module) return 'Select module'
  return module.title ?? module.id
}

function buildEditors(dimensions) {
  const next = {}
  dimensions.forEach(dim => {
    const contentText = prettyJson(dim.content)
    next[dim.id] = {
      id: dim.id,
      dimension_number: dim.dimension_number,
      research_status: dim.research_status,
      title: dim.title ?? '',
      originalTitle: dim.title ?? '',
      contentText,
      originalContentText: contentText,
      saving: false,
      saved: false,
      error: '',
    }
  })
  return next
}

function DimensionPreview({ dimension }) {
  const content = dimension.content ?? {}
  const sections = content.sections ?? []
  const summary = content.summary ?? content.shortSummary ?? content.overview

  return (
    <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid var(--cal-border-lt)', padding: '22px 24px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
        <div style={{ width: 30, height: 30, borderRadius: '50%', background: 'var(--cal-teal)', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--font-display)', fontSize: 13, fontWeight: 800 }}>
          {dimension.dimension_number}
        </div>
        <div>
          <div style={{ fontFamily: 'var(--font-display)', fontSize: 16, fontWeight: 700, color: 'var(--cal-ink)' }}>{dimension.title}</div>
          <div style={{ marginTop: 3, fontSize: 10, color: 'var(--cal-muted)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>{dimension.research_status}</div>
        </div>
      </div>

      {summary && (
        <p style={{ margin: '0 0 16px', fontSize: 14, color: 'var(--cal-ink)', lineHeight: 1.8, fontStyle: 'italic' }}>{summary}</p>
      )}

      {sections.length > 0 ? sections.map((section, idx) => (
        <div key={idx} style={{ marginTop: 16 }}>
          {section.heading && (
            <div style={{ fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase', color: 'var(--cal-teal)', marginBottom: 8 }}>
              {section.heading}
            </div>
          )}
          <ul style={{ margin: 0, paddingLeft: 18, color: 'var(--cal-ink)', fontSize: 13, lineHeight: 1.8 }}>
            {(section.items ?? section.content ?? []).map((item, itemIdx) => (
              <li key={itemIdx}>{typeof item === 'string' ? item : JSON.stringify(item)}</li>
            ))}
          </ul>
        </div>
      )) : (
        <pre style={{ background: 'var(--cal-surface)', borderRadius: 'var(--r-md)', padding: 14, overflowX: 'auto', fontSize: 11, color: 'var(--cal-muted)', lineHeight: 1.6 }}>
          {prettyJson(content)}
        </pre>
      )}
    </div>
  )
}

export default function SuperAdminDashboard() {
  const navigate = useNavigate()
  const [activeTab, setActiveTab] = useState('modules')
  const [modules, setModules] = useState([])
  const [selectedModuleId, setSelectedModuleId] = useState('')
  const [dimensions, setDimensions] = useState([])
  const [editors, setEditors] = useState({})
  const [modulesLoading, setModulesLoading] = useState(true)
  const [dimensionsLoading, setDimensionsLoading] = useState(false)
  const [modulesError, setModulesError] = useState(null)
  const [dimensionsError, setDimensionsError] = useState(null)
  const [retryCount, setRetryCount] = useState(0)
  const [dimensionRetryCount, setDimensionRetryCount] = useState(0)
  const [statusSavingId, setStatusSavingId] = useState(null)
  const [moduleEditor, setModuleEditor] = useState(null)
  const [woodstockDirty, setWoodstockDirty] = useState(false)

  const selectedModule = modules.find(module => module.id === selectedModuleId) ?? null
  const moduleEditorDirty = !!moduleEditor && (
    (moduleEditor.title       !== moduleEditor.originalTitle) ||
    (moduleEditor.tagline     !== moduleEditor.originalTagline) ||
    (moduleEditor.preamble_md !== moduleEditor.originalPreamble)
  )
  const hasUnsavedChanges = useMemo(
    () => moduleEditorDirty || woodstockDirty || Object.values(editors).some(hasUnsaved),
    [editors, moduleEditorDirty, woodstockDirty],
  )

  useEffect(() => {
    let active = true
    setModulesLoading(true)
    setModulesError(null)

    const timer = setTimeout(() => {
      if (!active) return
      active = false
      setModulesLoading(false)
      setModulesError('timeout')
    }, FETCH_TIMEOUT_MS)

    getAllModules()
      .then(rows => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setModules(rows)
        setSelectedModuleId(current => current || rows[0]?.id || '')
        setModulesLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setModulesError(err?.message ?? 'Could not load modules.')
        setModulesLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [retryCount])

  useEffect(() => {
    if (!selectedModuleId || (activeTab !== 'edit' && activeTab !== 'preview')) return

    let active = true
    setDimensionsLoading(true)
    setDimensionsError(null)

    const timer = setTimeout(() => {
      if (!active) return
      active = false
      setDimensionsLoading(false)
      setDimensionsError('timeout')
    }, FETCH_TIMEOUT_MS)

    getAllDimensions(selectedModuleId)
      .then(rows => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setDimensions(rows)
        setEditors(buildEditors(rows))
        setDimensionsLoading(false)
      })
      .catch(err => {
        clearTimeout(timer)
        if (!active) return
        active = false
        setDimensions([])
        setEditors({})
        setDimensionsError(err?.message ?? 'Could not load dimensions.')
        setDimensionsLoading(false)
      })

    return () => { active = false; clearTimeout(timer) }
  }, [selectedModuleId, activeTab, dimensionRetryCount])

  useEffect(() => {
    if (!selectedModule) {
      setModuleEditor(null)
      return
    }
    setModuleEditor({
      id: selectedModule.id,
      title: selectedModule.title ?? '',
      tagline: selectedModule.tagline ?? '',
      preamble_md: selectedModule.preamble_md ?? '',
      originalTitle: selectedModule.title ?? '',
      originalTagline: selectedModule.tagline ?? '',
      originalPreamble: selectedModule.preamble_md ?? '',
      saving: false,
      saved: false,
      error: '',
    })
  }, [selectedModuleId, selectedModule?.title, selectedModule?.tagline, selectedModule?.preamble_md])

  function updateModuleEditor(patch) {
    setModuleEditor(prev => prev ? { ...prev, ...patch, saved: false, error: patch.error ?? prev.error ?? '' } : prev)
  }

  async function saveModuleEditor() {
    if (!moduleEditor) return
    updateModuleEditor({ saving: true, error: '', saved: false })
    try {
      await updateModule(moduleEditor.id, {
        title: moduleEditor.title,
        tagline: moduleEditor.tagline,
        preamble_md: moduleEditor.preamble_md,
      })
      setModules(prev => prev.map(m => (
        m.id === moduleEditor.id
          ? { ...m, title: moduleEditor.title, tagline: moduleEditor.tagline, preamble_md: moduleEditor.preamble_md }
          : m
      )))
      setModuleEditor(prev => prev && {
        ...prev,
        originalTitle: prev.title,
        originalTagline: prev.tagline,
        originalPreamble: prev.preamble_md,
        saving: false,
        saved: true,
        error: '',
      })
    } catch (err) {
      updateModuleEditor({ saving: false, saved: false, error: err?.message ?? 'Save failed.' })
    }
  }

  function discardModuleEditor() {
    setModuleEditor(prev => prev && {
      ...prev,
      title: prev.originalTitle,
      tagline: prev.originalTagline,
      preamble_md: prev.originalPreamble,
      error: '',
      saved: false,
    })
  }

  function confirmLeaveUnsaved() {
    if (!hasUnsavedChanges) return true
    return window.confirm('You have unsaved changes. Leave?')
  }

  function switchTab(tab) {
    if (tab === activeTab) return
    if (!confirmLeaveUnsaved()) return
    setActiveTab(tab)
  }

  function selectModule(moduleId) {
    if (moduleId === selectedModuleId) return
    if (!confirmLeaveUnsaved()) return
    setSelectedModuleId(moduleId)
  }

  async function handleStatusChange(moduleId, status) {
    setStatusSavingId(moduleId)
    try {
      await updateModuleStatus(moduleId, status)
      const rows = await getAllModules()
      setModules(rows)
    } catch (err) {
      window.alert(err?.message ?? 'Could not update module status.')
    } finally {
      setStatusSavingId(null)
    }
  }

  function updateEditor(dimensionId, patch) {
    setEditors(prev => ({
      ...prev,
      [dimensionId]: { ...prev[dimensionId], ...patch, saved: false, error: patch.error ?? prev[dimensionId]?.error ?? '' },
    }))
  }

  function validateEditor(dimensionId) {
    const editor = editors[dimensionId]
    if (!editor) return null
    try {
      const parsed = JSON.parse(editor.contentText)
      updateEditor(dimensionId, { error: '' })
      return parsed
    } catch {
      updateEditor(dimensionId, { error: 'Invalid JSON - fix before saving.' })
      return null
    }
  }

  async function saveDimension(dim) {
    const editor = editors[dim.id]
    const parsed = validateEditor(dim.id)
    if (!parsed || !editor) return

    updateEditor(dim.id, { saving: true, error: '', saved: false })
    try {
      await updateDimension(dim.id, { title: editor.title, content: parsed })
      const contentText = prettyJson(parsed)
      setEditors(prev => ({
        ...prev,
        [dim.id]: {
          ...prev[dim.id],
          originalTitle: editor.title,
          contentText,
          originalContentText: contentText,
          saving: false,
          saved: true,
          error: '',
        },
      }))
      setDimensions(prev => prev.map(row => (
        row.id === dim.id ? { ...row, title: editor.title, content: parsed } : row
      )))
    } catch (err) {
      updateEditor(dim.id, { saving: false, saved: false, error: err?.message ?? 'Save failed.' })
    }
  }

  function discardDimension(dim) {
    const editor = editors[dim.id]
    if (!editor) return
    setEditors(prev => ({
      ...prev,
      [dim.id]: {
        ...editor,
        title: editor.originalTitle,
        contentText: editor.originalContentText,
        error: '',
        saved: false,
      },
    }))
  }

  const tabs = [
    { key: 'modules', icon: '[]', label: 'Modules' },
    { key: 'edit', icon: 'E', label: 'Edit Content' },
    { key: 'preview', icon: 'P', label: 'Preview' },
  ]

  return (
    <div style={{ display: 'flex', minHeight: '100vh', background: 'var(--cal-off)' }}>
      <aside style={{ width: 220, background: 'var(--cal-teal-dark, #083D4A)', padding: '28px 14px', color: '#fff', flexShrink: 0 }}>
        <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.14em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.38)', marginBottom: 16 }}>
          Superadmin
        </div>
        {tabs.map(tab => (
          <button
            key={tab.key}
            type="button"
            onClick={() => switchTab(tab.key)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 10,
              width: '100%',
              padding: '10px 12px',
              marginBottom: 3,
              borderRadius: 'var(--r-sm)',
              border: 'none',
              cursor: 'pointer',
              background: activeTab === tab.key ? 'rgba(255,255,255,0.12)' : 'transparent',
              color: activeTab === tab.key ? '#fff' : 'rgba(255,255,255,0.6)',
              fontSize: 13,
              textAlign: 'left',
            }}
          >
            <span style={{ width: 16, fontSize: 10, opacity: 0.75 }}>{tab.icon}</span>
            {tab.label}
          </button>
        ))}
        <div style={{ height: 1, background: 'rgba(255,255,255,0.12)', margin: '18px 0' }} />
        <button
          type="button"
          onClick={() => navigate('/dashboard')}
          style={{ background: 'transparent', border: 'none', color: 'rgba(255,255,255,0.45)', cursor: 'pointer', fontSize: 12, padding: '8px 12px' }}
        >
          Back to app
        </button>
      </aside>

      <main style={{ flex: 1, padding: '32px 36px', overflowY: 'auto' }}>
        <header style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 28 }}>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 6 }}>
              <h1 style={{ fontFamily: 'var(--font-display)', fontSize: 24, fontWeight: 800, color: 'var(--cal-ink)', margin: 0 }}>
                Habterra · Content Manager
              </h1>
              <span style={{ background: 'var(--cal-amber-lt)', color: 'var(--cal-amber-dark)', borderRadius: 'var(--r-full)', padding: '4px 9px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase' }}>
                superadmin
              </span>
            </div>
            <p style={{ fontSize: 13, color: 'var(--cal-muted)', margin: 0 }}>
              Manage module status, edit dimension JSON, and preview draft content.
            </p>
          </div>
        </header>

        {activeTab === 'modules' && (
          <>
            {modulesLoading && <div style={{ color: 'var(--cal-muted)', fontSize: 13 }}>Loading modules...</div>}
            {!modulesLoading && modulesError && (
              <ErrorState error={modulesError} context="superadmin modules" onRetry={() => setRetryCount(c => c + 1)} />
            )}
            {!modulesLoading && !modulesError && (
              <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', overflow: 'hidden' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                  <thead>
                    <tr style={{ background: 'var(--cal-surface)' }}>
                      {['Module', 'Country', 'Status', 'Actions'].map(header => (
                        <th key={header} style={{ textAlign: 'left', padding: '12px 18px', fontSize: 10, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase', borderBottom: '1px solid var(--cal-border-lt)' }}>
                          {header}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {modules.map((module, idx) => {
                      const saving = statusSavingId === module.id
                      return (
                        <tr key={module.id} style={{ background: idx % 2 === 0 ? '#fff' : 'var(--cal-surface)' }}>
                          <td style={{ padding: '14px 18px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700, color: 'var(--cal-ink)' }}>{moduleDisplayTitle(module)}</div>
                            <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginTop: 3 }}>{module.tagline ?? module.subtitle ?? module.id}</div>
                          </td>
                          <td style={{ padding: '14px 18px', borderBottom: '1px solid var(--cal-border-lt)', fontSize: 13, color: 'var(--cal-muted)' }}>{module.country_code ?? '-'}</td>
                          <td style={{ padding: '14px 18px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <span style={{ display: 'inline-flex', borderRadius: 'var(--r-full)', padding: '4px 9px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, textTransform: 'uppercase', ...statusStyle(module.status) }}>
                              {saving ? 'saving...' : module.status}
                            </span>
                          </td>
                          <td style={{ padding: '14px 18px', borderBottom: '1px solid var(--cal-border-lt)' }}>
                            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                              <button
                                type="button"
                                className="btn btn-ghost"
                                disabled={saving}
                                onClick={() => handleStatusChange(module.id, module.status === 'live' ? 'draft' : 'live')}
                                style={{ fontSize: 12, padding: '7px 10px' }}
                              >
                                {module.status === 'live' ? 'Set Draft' : 'Set Live'}
                              </button>
                              <button
                                type="button"
                                className="btn btn-primary"
                                onClick={() => {
                                  setSelectedModuleId(module.id)
                                  setActiveTab('edit')
                                }}
                                style={{ fontSize: 12, padding: '7px 10px' }}
                              >
                                Edit Content
                              </button>
                            </div>
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            )}
          </>
        )}

        {(activeTab === 'edit' || activeTab === 'preview') && (
          <>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 22 }}>
              <select
                value={selectedModuleId}
                onChange={e => selectModule(e.target.value)}
                style={{ minWidth: 300, background: '#fff', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '10px 12px', fontSize: 13, color: 'var(--cal-ink)' }}
              >
                {modules.map(module => (
                  <option key={module.id} value={module.id}>{moduleDisplayTitle(module)}</option>
                ))}
              </select>
              {selectedModule && (
                <span style={{ display: 'inline-flex', borderRadius: 'var(--r-full)', padding: '4px 9px', fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, textTransform: 'uppercase', ...statusStyle(selectedModule.status) }}>
                  {selectedModule.status}
                </span>
              )}
            </div>

            {dimensionsLoading && <div style={{ color: 'var(--cal-muted)', fontSize: 13 }}>Loading dimensions...</div>}
            {!dimensionsLoading && dimensionsError && (
              <ErrorState error={dimensionsError} context="module dimensions" onRetry={() => setDimensionRetryCount(c => c + 1)} />
            )}
          </>
        )}

        {activeTab === 'edit' && !dimensionsLoading && !dimensionsError && (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 18, maxWidth: 980 }}>
            {moduleEditor && (
              <div style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid var(--cal-border-lt)', padding: 20 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 14 }}>
                  <div style={{ background: 'var(--cal-amber)', color: '#fff', borderRadius: 'var(--r-md)', padding: '7px 10px', fontFamily: 'var(--font-display)', fontSize: 11, fontWeight: 800, letterSpacing: '0.08em', textTransform: 'uppercase' }}>
                    Module
                  </div>
                  <div style={{ fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 700, color: 'var(--cal-ink)' }}>
                    Module details
                  </div>
                  <div style={{ fontSize: 11, color: 'var(--cal-muted)', marginLeft: 'auto' }}>
                    pd_modules.{selectedModule?.id}
                  </div>
                </div>

                <label style={{ display: 'block', fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
                  Title
                </label>
                <input
                  type="text"
                  value={moduleEditor.title}
                  onChange={e => updateModuleEditor({ title: e.target.value })}
                  style={{ width: '100%', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '10px 12px', fontSize: 14, color: 'var(--cal-ink)', marginBottom: 14 }}
                />

                <label style={{ display: 'block', fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
                  Tagline <span style={{ textTransform: 'none', fontWeight: 400, color: 'var(--cal-muted)' }}>(one-line subtitle shown on module cards)</span>
                </label>
                <textarea
                  value={moduleEditor.tagline}
                  onChange={e => updateModuleEditor({ tagline: e.target.value })}
                  rows={2}
                  style={{ width: '100%', resize: 'vertical', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '10px 12px', fontSize: 13, lineHeight: 1.55, color: 'var(--cal-ink)', marginBottom: 14 }}
                />

                <label style={{ display: 'block', fontSize: 11, color: 'var(--cal-muted)', fontFamily: 'var(--font-display)', fontWeight: 700, letterSpacing: '0.08em', textTransform: 'uppercase', marginBottom: 4 }}>
                  Preamble <span style={{ textTransform: 'none', fontWeight: 400, color: 'var(--cal-muted)' }}>(shown before the user starts the module — Markdown)</span>
                </label>
                <textarea
                  value={moduleEditor.preamble_md}
                  onChange={e => updateModuleEditor({ preamble_md: e.target.value })}
                  rows={6}
                  style={{ width: '100%', resize: 'vertical', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '10px 12px', fontSize: 13, lineHeight: 1.65, color: 'var(--cal-ink)', fontFamily: 'monospace' }}
                />

                <div style={{ minHeight: 24, marginTop: 8, fontSize: 12 }}>
                  {moduleEditor.error && <span style={{ color: '#B3261E' }}>{moduleEditor.error}</span>}
                  {moduleEditor.saved && !moduleEditor.error && <span style={{ color: 'var(--cal-success)' }}>Saved.</span>}
                  {moduleEditorDirty && !moduleEditor.saving && !moduleEditor.error && !moduleEditor.saved && (
                    <span style={{ color: 'var(--cal-muted)' }}>Unsaved changes.</span>
                  )}
                </div>

                <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
                  <button type="button" className="btn btn-ghost" disabled={!moduleEditorDirty} onClick={discardModuleEditor} style={{ fontSize: 12, opacity: moduleEditorDirty ? 1 : 0.5 }}>
                    Discard
                  </button>
                  <button type="button" className="btn btn-primary" disabled={!moduleEditorDirty || moduleEditor.saving} onClick={saveModuleEditor} style={{ fontSize: 12, opacity: (!moduleEditorDirty || moduleEditor.saving) ? 0.6 : 1 }}>
                    {moduleEditor.saving ? 'Saving...' : 'Save module details'}
                  </button>
                </div>
              </div>
            )}
            {selectedModule?.id === WOODSTOCK_MODULE_ID ? (
              <WoodstockEditor
                dimensions={dimensions}
                onDirtyChange={setWoodstockDirty}
                onSaveDimension={async (id, content) => {
                  await updateDimension(id, { content })
                  setDimensions(prev => prev.map(row => (
                    row.id === id ? { ...row, content } : row
                  )))
                }}
              />
            ) : (
              <>
            {dimensions.map(dim => {
              const editor = editors[dim.id]
              if (!editor) return null
              return (
                <div key={dim.id} style={{ background: '#fff', borderRadius: 'var(--r-lg)', boxShadow: 'var(--shadow-sm)', border: '1px solid var(--cal-border-lt)', padding: 20 }}>
                  <div style={{ display: 'grid', gridTemplateColumns: '52px 1fr auto', gap: 12, alignItems: 'center', marginBottom: 14 }}>
                    <div style={{ background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-md)', padding: '9px 0', textAlign: 'center', fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 800 }}>
                      D{dim.dimension_number}
                    </div>
                    <input
                      type="text"
                      value={editor.title}
                      onChange={e => updateEditor(dim.id, { title: e.target.value })}
                      style={{ width: '100%', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: '10px 12px', fontSize: 14, color: 'var(--cal-ink)' }}
                    />
                    <div style={{ fontSize: 11, color: 'var(--cal-muted)' }}>
                      research_status: <strong>{dim.research_status}</strong>
                    </div>
                  </div>

                  <textarea
                    value={editor.contentText}
                    onChange={e => updateEditor(dim.id, { contentText: e.target.value })}
                    onBlur={() => validateEditor(dim.id)}
                    rows={8}
                    style={{ width: '100%', resize: 'vertical', border: '1.5px solid var(--cal-border)', borderRadius: 'var(--r-md)', padding: 12, fontFamily: 'monospace', fontSize: 12, lineHeight: 1.6, color: 'var(--cal-ink)', background: 'var(--cal-surface)' }}
                  />

                  <div style={{ minHeight: 24, marginTop: 8, fontSize: 12 }}>
                    {editor.error && <span style={{ color: '#B3261E' }}>{editor.error}</span>}
                    {editor.saved && !editor.error && <span style={{ color: 'var(--cal-success)' }}>Saved.</span>}
                  </div>

                  <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
                    <button type="button" className="btn btn-ghost" onClick={() => discardDimension(dim)} style={{ fontSize: 12 }}>
                      Discard
                    </button>
                    <button type="button" className="btn btn-primary" disabled={editor.saving} onClick={() => saveDimension(dim)} style={{ fontSize: 12, opacity: editor.saving ? 0.6 : 1 }}>
                      {editor.saving ? 'Saving...' : `Save D${dim.dimension_number}`}
                    </button>
                  </div>
                </div>
              )
            })}
              </>
            )}
          </div>
        )}

        {activeTab === 'preview' && !dimensionsLoading && !dimensionsError && (
          <div style={{ maxWidth: 880 }}>
            <div style={{ background: 'var(--cal-teal)', color: '#fff', borderRadius: 'var(--r-lg)', padding: '28px 32px', marginBottom: 22, position: 'relative', overflow: 'hidden' }}>
              <div style={{ fontSize: 10, fontFamily: 'var(--font-display)', fontWeight: 800, letterSpacing: '0.14em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.6)', marginBottom: 8 }}>
                Preview (as teacher sees it)
              </div>
              <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 28, fontWeight: 800, margin: '0 0 8px' }}>
                {moduleDisplayTitle(selectedModule)}
              </h2>
              <p style={{ margin: 0, fontSize: 14, color: 'rgba(255,255,255,0.76)', lineHeight: 1.7 }}>
                {selectedModule?.tagline ?? selectedModule?.subtitle ?? selectedModule?.id}
              </p>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
              {dimensions.length === 0 ? (
                <div style={{ color: 'var(--cal-muted)', fontSize: 13 }}>No dimensions found for this module.</div>
              ) : dimensions.map(dim => (
                <DimensionPreview key={dim.id} dimension={dim} />
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  )
}
