# Calibrate — Super-Admin Content Layer

Read AGENTS.md fully before starting. This task adds a super-admin role and a
content management interface that lets the platform operator (Mark) edit module
content, manage module status, and preview changes — across all schools and
modules — without touching the Supabase SQL editor.

---

## What to build

Four deliverables, in dependency order:

1. **SQL migration** — `superadmin/superadmin_role.sql`
2. **Supabase helpers** — additions to `src/lib/supabase.js`
3. **Route guard + route** — additions to `src/App.jsx` and `src/context/AuthContext.jsx`
4. **New page** — `src/pages/SuperAdminDashboard.jsx`

---

## 1. SQL migration — `superadmin/superadmin_role.sql`

Create this file. It must be safe to re-run (use `IF NOT EXISTS` / `ON CONFLICT DO NOTHING`).

### 1a. Alter the profiles role constraint

The existing `profiles.role` column has a check constraint that allows
`'teacher' | 'admin' | 'parent'`. Extend it to also allow `'superadmin'`:

```sql
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('teacher', 'admin', 'parent', 'superadmin'));
```

### 1b. RLS policies for superadmin bypass

The existing `pd_modules_public_read` policy gates reads to `status = 'live'`.
Superadmins need to read and write all rows regardless of status.

Add these policies (drop and recreate if they already exist):

```sql
-- pd_modules: superadmin full access
DROP POLICY IF EXISTS "pd_modules_superadmin" ON public.pd_modules;
CREATE POLICY "pd_modules_superadmin" ON public.pd_modules
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );

-- pd_dimensions: superadmin full access
DROP POLICY IF EXISTS "pd_dimensions_superadmin" ON public.pd_dimensions;
CREATE POLICY "pd_dimensions_superadmin" ON public.pd_dimensions
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );

-- pd_simulations: superadmin full access
DROP POLICY IF EXISTS "pd_simulations_superadmin" ON public.pd_simulations;
CREATE POLICY "pd_simulations_superadmin" ON public.pd_simulations
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );
```

### 1c. Verification query (add at bottom of file)

```sql
-- Should return the updated constraint
SELECT pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conname = 'profiles_role_check';

-- Should return 3 rows (one per table)
SELECT policyname, tablename
FROM pg_policies
WHERE policyname LIKE '%superadmin%'
ORDER BY tablename;
```

---

## 2. Supabase helpers — additions to `src/lib/supabase.js`

Add these functions. All follow the existing error-handling pattern in the file.
In MOCK_MODE, return deterministic mock data (see shape notes below).

```js
// ── Super-admin helpers ──────────────────────────────────────────────────────

// Returns all pd_modules rows regardless of status, ordered by country_code
export async function getAllModules() { ... }

// Updates a single pd_modules row's status field
// status must be 'draft' | 'live' | 'archived'
export async function updateModuleStatus(moduleId, status) { ... }

// Returns all pd_dimensions rows for a module, ordered by dimension_number
// Works for draft modules (superadmin policy bypasses the live-only RLS)
export async function getAllDimensions(moduleId) { ... }

// Updates a single pd_dimensions row
// fields: { title?, content? }  — only provided keys are updated
export async function updateDimension(dimensionId, fields) { ... }

// Returns all pd_simulations rows for a module regardless of status
export async function getAllSimulations(moduleId) { ... }
```

**MOCK_MODE shapes:**

`getAllModules()` → array of objects:
```js
{ id, title, tagline, status, country_code }
// At minimum: india-001, ksa-001, korea-001, china-001, woodstock-001
// Mix of statuses: some 'live', one 'draft' so the UI shows both states
```

`getAllDimensions(moduleId)` → array of objects:
```js
{ id, module_id, dimension_number, title, research_status, content }
// 6 rows per module, content is a plain object (not stringified)
```

`updateModuleStatus` and `updateDimension` → in MOCK_MODE, log to console and
return `{ error: null }` after a 300ms delay (simulates a round trip).

---

## 3. Auth context + route guard — `src/context/AuthContext.jsx` and `src/App.jsx`

### AuthContext.jsx

Add `isSuperAdmin` to the context value alongside the existing `isAdmin`:

```js
isSuperAdmin: profile?.role === 'superadmin',
```

Also extend MOCK_MODE mock profiles to include a superadmin option so the role
switcher (if it exists in dev) can test the super-admin view:

```js
// In the MOCK_PROFILES block or equivalent:
{ role: 'superadmin', full_name: 'Super Admin', school_id: null }
```

### App.jsx

Add a `SuperAdminRoute` guard component alongside the existing `AdminRoute`:

```jsx
function SuperAdminRoute({ children }) {
  const { session, loading, isSuperAdmin } = useAuth()
  if (loading) return null
  if (!session) return <Navigate to="/login" replace />
  if (!isSuperAdmin) return <Navigate to="/dashboard" replace />
  return children
}
```

Add the route (import `SuperAdminDashboard` at top of file):

```jsx
<Route
  path="/superadmin"
  element={
    <SuperAdminRoute>
      <SuperAdminDashboard />
    </SuperAdminRoute>
  }
/>
```

---

## 4. New page — `src/pages/SuperAdminDashboard.jsx`

### Layout

Full-page layout matching the style of `AdminDashboard.jsx`. Use the same CSS
variables (`--cal-teal`, `--cal-ink`, `--cal-surface`, etc.) and inline-style
approach. No new CSS files.

Header: "Calibrate · Content Manager" with a small "superadmin" badge in
`--cal-amber`.

Three tabs, implemented as a sidebar nav (same pattern as AdminDashboard):

| Icon | Tab label | Purpose |
|------|-----------|---------|
| 📦 | Modules | List all modules, toggle status |
| ✏️ | Edit Content | Dimension editor for a selected module |
| 👁 | Preview | Read-only render of the selected module |

---

### Tab 1 — Modules

Fetch `getAllModules()` on mount. Show a table with columns:

| Module | Country | Status | Actions |
|--------|---------|--------|---------|
| title  | country_code | status badge | status buttons |

**Status badge colours:**
- `live` → green (`--cal-teal`)
- `draft` → amber (`--cal-amber`)
- `archived` → grey (`--cal-muted`)

**Actions per row:**
- If `status !== 'live'` → "Set Live" button
- If `status === 'live'` → "Set Draft" button
- "Edit Content" link → switches to the Edit Content tab with this module selected

Status changes call `updateModuleStatus(moduleId, newStatus)` and refresh the
list. Show a brief inline spinner on the row while the call is in flight.

---

### Tab 2 — Edit Content

**Module selector**: dropdown at top — lists all modules by title. Selecting
one fetches `getAllDimensions(moduleId)`.

**Dimension cards**: render one card per dimension (6 total), ordered by
`dimension_number`. Each card shows:

```
[ D1 ]  [ title input — single line ]     research_status: fully_sourced
─────────────────────────────────────────────────────────────────────────
[ content textarea — 8 rows, monospace, shows JSON pretty-printed ]

                                          [ Save D1 ]  [ Discard ]
```

**Editing behaviour:**
- Title input is a plain `<input type="text">`.
- Content field is a `<textarea>` that shows `JSON.stringify(dimension.content, null, 2)`.
- On blur or on "Save", validate that the content field is valid JSON
  (`JSON.parse` in a try/catch). If invalid, show an inline error:
  "Invalid JSON — fix before saving."
- "Save D1" calls `updateDimension(dimension.id, { title, content: parsedJson })`.
- Show a per-card saved/error state (not a page-level toast).
- "Discard" resets the card to the last fetched values.

**Unsaved changes guard:** if the user switches modules or tabs while any card
has unsaved changes, show a `window.confirm("You have unsaved changes. Leave?")`.

---

### Tab 3 — Preview

Module selector (same as Tab 2, shares state — selecting a module in either
tab updates both).

Render the module content as a teacher would see it, using the **same
component logic as `ModuleView.jsx`** — but fed with the superadmin-fetched
data (which includes draft modules) rather than going through the normal
module loader.

Implementation approach: extract the dimension-rendering section of
`ModuleView.jsx` into a shared component `src/components/DimensionList.jsx`
that accepts `{ dimensions }` as a prop, then use it in both `ModuleView.jsx`
and the Preview tab here.

If extracting is too invasive to `ModuleView.jsx`, an acceptable alternative is
to render a simplified preview directly in the tab: module title + tagline,
then each dimension as a card showing title and the `content.summary` field
(from the jsonb).

Label the preview tab clearly: "Preview (as teacher sees it)" and include a
status pill showing the module's current status at the top.

---

## Coding conventions reminder

- Plain `.jsx` and `.js` only — no TypeScript
- No new dependencies
- All DB calls go in `src/lib/supabase.js`
- MOCK_MODE must work for every data path
- Follow the 8s timeout + error/retry pattern for all fetches
  (copy from `Dashboard.jsx`)
- Use `onConflict` on all upserts

---

## Acceptance criteria

```
[ ] superadmin/superadmin_role.sql runs without errors and is safe to re-run
[ ] profiles table accepts role = 'superadmin'
[ ] RLS policies exist for pd_modules, pd_dimensions, pd_simulations
[ ] AuthContext exposes isSuperAdmin
[ ] /superadmin route exists and redirects non-superadmins to /dashboard
[ ] Modules tab lists all modules including draft ones
[ ] Status toggle updates module and refreshes list
[ ] Edit Content tab loads all 6 dimensions for a selected module
[ ] Title and content fields are editable and save correctly
[ ] Invalid JSON shows an inline error, does not call Supabase
[ ] Unsaved changes guard fires on tab/module switch
[ ] Preview tab renders module content in a teacher-readable format
[ ] MOCK_MODE works for all three tabs with no .env file
[ ] npm run build passes with no errors
```

---

## What to report back

When done, say:
- Which files you created or modified
- Whether `npm run build` passed
- The exact SQL to run in Supabase (or confirm `superadmin_role.sql` is the complete runnable file)
- Any decisions you made where the spec left room (e.g. the Preview implementation approach)
