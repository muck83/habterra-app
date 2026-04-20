# Calibrate — Codex Agent Brief

This document describes the v2 work remaining on **Calibrate**, a professional-development platform for international schools. Read it fully before starting any task.

---

## Project overview

- **Stack**: React 18 + Vite 5, plain JSX (no TypeScript), Supabase (auth + Postgres), vanilla CSS
- **Entry point**: `src/main.jsx` → `src/App.jsx`
- **Routing**: `react-router-dom` v6 with a `<ProtectedRoute>` wrapper in `App.jsx`
- **Auth**: `src/context/AuthContext.jsx` — provides `user`, `profile`, `school`
- **Data layer**: `src/lib/supabase.js` — all DB calls live here; components import named functions
- **Mock mode**: `const MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL` — used in every data-fetching file to gate real API calls during local dev without `.env`
- **No new dependencies** unless absolutely necessary. Prefer vanilla JS / React patterns.

### Key files

| Path | Purpose |
|------|---------|
| `src/pages/ModuleView.jsx` | Renders any PD module: reads, dimensions, quiz (checkpoint + final exam), simulations |
| `src/pages/WoodstockModuleView.jsx` | One-off renderer for the Woodstock parent module — currently reads from hardcoded JS |
| `src/pages/AdminDashboard.jsx` | Admin panel: Overview, Members, Assign, Quiz Analytics, Invite Member |
| `src/pages/Dashboard.jsx` | Teacher/parent dashboard — module cards + progress |
| `src/pages/Progress.jsx` | Per-teacher progress detail |
| `src/lib/supabase.js` | All Supabase helpers. Add new DB functions here, nowhere else. |
| `src/data/mockData.js` | Mock data for MOCK_MODE. Keep in sync with Supabase schema. |
| `src/vocab/woodstock-parent-transition.js` | Hardcoded Woodstock content — to be migrated (Task 3) |
| `supabase/quiz_responses_migration.sql` | Migration for quiz_responses table (already written, apply first) |
| `cal_seed_part1.sql` / `cal_seed_part2.sql` / `cal_seed_part3.sql` | School + module + dimension seeds |
| `RUN_ORDER.md` | SQL execution order and verification queries |

### Module slugs and DB IDs

| Slug | DB ID | Status |
|------|-------|--------|
| `india-ib` | `india-001` | Fully seeded (dims + quiz) |
| `ksa-ib` | `ksa-001` | Dims seeded, **quiz missing** |
| `korea-ib` | `korea-001` | Dims seeded, **quiz missing** |
| `china-ib` | `china-001` | Dims seeded, **quiz missing** |
| `woodstock-transition` | `woodstock-001` | Dims seeded, content is hardcoded JS |

### Supabase table quick reference

```
profiles           — id, email, full_name, role, school_id
schools            — id, name, domain
assignments        — id, school_id, user_id?, role_target?, module_slug, due_date
module_completions — user_id, module_slug, progress_pct, completed_at
pd_modules         — id (text), title, subtitle, intro, flag_emoji, ...
pd_dimensions      — id, module_id, dimension_number, title, body_md, ...
pd_simulations     — id, module_id, title, description, context, characters (jsonb), nodes (jsonb), dimension_tags, status
pd_simulation_responses — id, simulation_id, user_id, node_id, choice_id, response_text, scored_at
pd_quiz_questions  — id (text), module_id, quiz_type, sort_order, prompt, options (jsonb), dimension_number
quiz_responses     — user_id, module_id, question_id, option_id, is_correct, quiz_type, answered_at
```

---

## Tasks

---

### Task 1 — Quiz questions SQL for KSA, Korea, and China

**What**: Write SQL seed files for quiz questions for the three modules that currently have none.

**Files to create**:
- `ksa_quiz.sql`
- `korea_quiz.sql`
- `china_quiz.sql`

**Schema** (matches `pd_quiz_questions`):
```sql
INSERT INTO pd_quiz_questions (id, module_id, quiz_type, sort_order, prompt, options, dimension_number)
VALUES (
  'ksa-d1-q1',          -- id: {slug}-d{n}-q{n} for checkpoints, {slug}-final-q{n} for finals
  'ksa-001',            -- module_id
  'checkpoint',         -- 'checkpoint' | 'final_exam'
  1,                    -- sort_order within quiz_type
  'Prompt text here?',  -- the question
  '[
    {"id": "ksa-d1-q1-a", "text": "Option A", "isCorrect": false, "explanation": "Why A is wrong"},
    {"id": "ksa-d1-q1-b", "text": "Option B", "isCorrect": true,  "explanation": "Why B is correct"},
    {"id": "ksa-d1-q1-c", "text": "Option C", "isCorrect": false, "explanation": "Why C is wrong"},
    {"id": "ksa-d1-q1-d", "text": "Option D", "isCorrect": false, "explanation": "Why D is wrong"}
  ]'::jsonb,
  1                     -- dimension_number (1–6 for checkpoints; NULL for final_exam)
);
```

**Content requirements per module**:
- **6 checkpoint questions** (one per dimension, `dimension_number` 1–6, `quiz_type = 'checkpoint'`)
- **3 final exam questions** (`quiz_type = 'final_exam'`, `dimension_number = NULL`, `sort_order` 1–3)
- Each question must have exactly 4 options, exactly 1 correct
- Questions should probe *cultural misreading* — the most common wrong answer should be a plausible but reductive interpretation
- Write questions thematically consistent with the module's existing dimension titles in `pd_dimensions`

**Acceptance criteria**:
```sql
-- Each of these should return 9 rows (6 checkpoint + 3 final)
SELECT count(*) FROM pd_quiz_questions WHERE module_id = 'ksa-001';
SELECT count(*) FROM pd_quiz_questions WHERE module_id = 'korea-001';
SELECT count(*) FROM pd_quiz_questions WHERE module_id = 'china-001';
```

**Also add to `mockData.js`**:
Add `MOCK_QUIZ_ANALYTICS` entries for `ksa-ib`, `korea-ib`, `china-ib` following the existing `india-ib` pattern (n, correct, topWrong per question). These are used in the admin analytics view when `MOCK_MODE` is true.

---

### Task 2 — Real quiz analytics aggregation in AdminDashboard

**What**: Replace the `MOCK_QUIZ_ANALYTICS` fallback in `AdminDashboard.jsx` with real aggregation from `quiz_responses`.

**Current state**: `AdminDashboard.jsx` calls `getModuleQuizAnalytics(moduleId)` which returns raw rows like:
```js
{ question_id, option_id, is_correct, quiz_type, dimension_number }
```
But then falls back to `MOCK_QUIZ_ANALYTICS[analyticsSlug]` instead of aggregating.

**What to build**:

1. **In `src/lib/supabase.js`** — add a helper that fetches question metadata alongside responses:
```js
export async function getModuleQuizQuestions(moduleId) {
  // Returns pd_quiz_questions rows for a module
  // Fields needed: id, prompt, quiz_type, sort_order, dimension_number, options (jsonb)
}
```

2. **In `AdminDashboard.jsx`** — after fetching both raw responses AND questions, aggregate client-side:
```js
// For each question:
// n         = number of distinct users who answered this question
// correct   = number who got it right
// topWrong  = text of the most-selected incorrect option (for questions where correct < 75%)
```

The aggregated shape must match the existing render logic:
```js
{ id, label, prompt, n, correct, topWrong }
// label = e.g. "D1 · Checkpoint" or "Final · Q2"
// topWrong = option text string or null
```

3. **Keep MOCK_MODE working**: when `MOCK_MODE` is true, keep using `MOCK_QUIZ_ANALYTICS`. Only call Supabase when `MOCK_MODE` is false.

**Acceptance criteria**:
- Admin analytics view shows real data when connected to Supabase (not mock)
- If no responses exist yet for a module, shows empty state: "No quiz responses yet for this module."
- `MOCK_MODE` still works for local dev with no `.env`

---

### Task 3 — Woodstock content migration to Supabase

**What**: Move the hardcoded content in `src/vocab/woodstock-parent-transition.js` into Supabase and update `WoodstockModuleView.jsx` to fetch it from there.

**Current state**: `WoodstockModuleView.jsx` imports `woodstockParentTransition` directly from the vocab file and renders it. There's a large `/* NOTE — v2 MIGRATION REQUIRED */` comment at the top of the file explaining what needs to change.

**Step 1 — SQL seed file** (`woodstock_content_seed.sql`):

Map the vocab structure into the existing DB tables:

| Vocab field | DB destination |
|-------------|----------------|
| `meta.title/subtitle/intro` | `pd_modules` row for `woodstock-001` (UPDATE) |
| `directorNote` | New column on `pd_modules` OR serialize into a `pd_dimensions` row with `dimension_number = 0` |
| `openingHook` | `pd_modules.intro` extension or `dimension_number = 0` row |
| `cohortGuide.cohorts[]` | One `pd_dimensions` row per cohort — `dimension_number` 1–5, `title` = cohort label, `body_md` = serialized markdown |
| `faqSections[]` | Additional `pd_dimensions` rows after cohorts, or a new `pd_faqs` table if structure demands it |
| `quizSection` | `pd_quiz_questions` rows using the existing schema |

Use whatever mapping keeps `WoodstockModuleView.jsx` the simplest. If the existing tables can hold the data cleanly, use them. If the Woodstock structure is genuinely incompatible (e.g., the nested `wsdNote` blocks), add a `body_json jsonb` column to `pd_dimensions` via a migration rather than contorting the data.

**Step 2 — Update `WoodstockModuleView.jsx`**:
- Remove the import of `woodstock-parent-transition.js`
- Add data fetching using existing `supabase.js` helpers (`getModule`, `getDimensions`, `getQuizQuestions`) — same pattern as `ModuleView.jsx`
- Preserve the existing render logic as much as possible — just change the data source
- Add the standard timeout/error/retry pattern (8s timeout, `ErrorState` component, `retryCount` state) — copy from `Dashboard.jsx`
- In `MOCK_MODE`, construct mock data from `woodstockParentTransition` import so local dev still works

**Step 3**: Once `WoodstockModuleView.jsx` no longer imports the vocab file in production paths, add a deprecation comment to `woodstock-parent-transition.js` but do not delete it yet (it's still used in MOCK_MODE).

**Acceptance criteria**:
- `WoodstockModuleView.jsx` renders correctly from Supabase data
- `MOCK_MODE` still renders the same content as before using the vocab file
- No visible regression in the rendered module

---

### Task 4 — CSV bulk import UI in AdminDashboard

**What**: Replace the static code-snippet panel in Admin → Invite Member with a functional CSV upload form.

**Current state**: The Invite Member view has a "Bulk import" info panel that shows a SQL snippet and a note saying "v2: CSV import coming soon".

**What to build**:

**UI** (in `AdminDashboard.jsx`, inside the existing `inviteView` section):

1. A file input that accepts `.csv` files
2. Expected CSV format (show as example in the UI):
   ```
   email,full_name,role
   teacher.one@school.com,Teacher One,teacher
   parent.one@gmail.com,Parent One,parent
   ```
3. On file select: parse CSV client-side (no library — use `FileReader` + `split('\n')`)
4. Show a preview table: email, full name, role, status (pending/success/error) — max 10 rows visible with scroll
5. "Import N users" button — on click, call `createCalibrateUser` for each row sequentially (not parallel, to avoid rate limits)
6. Per-row status updates as imports proceed
7. Final summary: "X imported, Y failed"

**New Supabase helper** in `src/lib/supabase.js`:
```js
export async function inviteUser({ email, fullName, role, schoolId, assignedBy }) {
  // Uses supabase.auth.admin.inviteUserByEmail() to send a magic-link invite
  // Then upserts the profile row
  // NOTE: inviteUserByEmail requires service role — in client context, use
  // supabase.auth.signUp() with a random temp password and email_confirm = true
  // OR call a Supabase Edge Function. Document whichever path you choose.
}
```

If `inviteUserByEmail` is not available client-side (it requires service role), implement as a **Supabase Edge Function** stub (`supabase/functions/invite-user/index.ts`) that the client POSTs to. Add a comment in the code explaining the deployment step.

**MOCK_MODE**: simulate success with a 500ms delay per row, no real API calls.

**Acceptance criteria**:
- CSV with 5 rows parses and shows preview correctly
- Import runs row-by-row with live status updates
- Errors on individual rows don't stop the rest of the import
- `MOCK_MODE` simulates the whole flow without hitting Supabase

---

## Coding conventions

- **No TypeScript** — plain `.jsx` and `.js` only
- **No new CSS frameworks** — use inline styles and the existing CSS custom properties in `src/styles/tokens.css`
- **CSS variables in use**: `--cal-teal`, `--cal-amber`, `--cal-ink`, `--cal-muted`, `--cal-border`, `--cal-surface`, `--cal-white`, `--r-sm`, `--r-md`, `--r-lg`, `--shadow-sm`, `--font-display`
- **Error handling pattern**: async fetches use `active` flag + `setTimeout(FETCH_TIMEOUT_MS)` + `.catch(setLoadError)`. See `Dashboard.jsx` for the canonical example.
- **Supabase upserts**: always include `onConflict` key. Never silently swallow errors from write operations.
- **Component style**: functional components, hooks only — no class components
- **File naming**: `PascalCase` for components/pages, `camelCase` for utilities and data files

## SQL conventions

- All IDs are `text` (not uuid) for module/dimension/question rows — matches existing seeds
- Use `ON CONFLICT DO NOTHING` or `ON CONFLICT (...) DO UPDATE` — all seed files must be safe to re-run
- Always add a verification `SELECT` at the bottom of each SQL file
- RLS: all new tables need `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` and at minimum a self-read policy

---

## Out of scope for this brief

- Email delivery (Supabase handles this via magic links / SMTP — no custom email templating needed)
- New modules beyond the five listed
- The parent-facing Campfire app (separate codebase)
- Any mobile-native work
