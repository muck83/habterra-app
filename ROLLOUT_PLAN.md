# Calibrate — Rollout Plan (4 Steps)

Each step has a clear scope, expected outputs, and a briefing block to paste
into a new Claude / Codex session to start that step.

---

## Step 1 — Data foundation (SQL)

**What it covers**
- Write `ksa_quiz.sql`, `korea_quiz.sql`, `china_quiz.sql` — 6 checkpoint + 3 final
  questions per module, matching the `pd_quiz_questions` schema in `AGENTS.md`
- Write `woodstock_content_seed.sql` — maps `src/vocab/woodstock-parent-transition.js`
  into `pd_modules` / `pd_dimensions` rows (and a migration if any new columns are needed)
- Update `RUN_ORDER.md` with the new files and their verification queries

**Expected outputs**
- `ksa_quiz.sql`
- `korea_quiz.sql`
- `china_quiz.sql`
- `woodstock_content_seed.sql`
- Updated `RUN_ORDER.md`

**No React changes in this step.**

**When done, run the verification queries at the bottom of each SQL file in Supabase
to confirm row counts, then paste the block below to start Step 2.**

---

### ▶ Paste to Claude to start Step 2

```
Step 1 SQL is applied and verified. KSA, Korea, and China each have 9 quiz questions
in pd_quiz_questions. Woodstock content is seeded into pd_modules / pd_dimensions.

Now do Step 2 from ROLLOUT_PLAN.md: update the React frontend to consume the new data.
The repo is at C:\Users\markt\Downloads\stool-app\calibrate — read AGENTS.md for
conventions and file locations before starting.
```

---

## Step 2 — Frontend: Woodstock + analytics

**What it covers**
- `WoodstockModuleView.jsx` — remove the hardcoded vocab import; fetch from Supabase
  using existing helpers (`getModule`, `getDimensions`, `getQuizQuestions`); add the
  standard 8s timeout / ErrorState / retry pattern; keep MOCK_MODE fallback using the
  vocab file
- `src/lib/supabase.js` — add `getModuleQuizQuestions(moduleId)` that returns question
  rows including `prompt`, `options`, `quiz_type`, `dimension_number`
- `AdminDashboard.jsx` analytics view — replace `MOCK_QUIZ_ANALYTICS` fallback with
  real client-side aggregation of `quiz_responses` rows joined to question metadata;
  show "No responses yet" empty state; keep MOCK_MODE using `MOCK_QUIZ_ANALYTICS`
- `src/data/mockData.js` — add `MOCK_QUIZ_ANALYTICS` entries for `ksa-ib`, `korea-ib`,
  `china-ib` following the existing `india-ib` shape

**Expected outputs**
- Updated `WoodstockModuleView.jsx`
- Updated `src/lib/supabase.js`
- Updated `AdminDashboard.jsx`
- Updated `src/data/mockData.js`

**When done, verify locally in MOCK_MODE (Woodstock module renders, all three new
modules show mock analytics) then paste the block below to start Step 3.**

---

### ▶ Paste to Claude to start Step 3

```
Step 2 is done and verified locally. WoodstockModuleView reads from Supabase,
quiz analytics shows real data when connected and mock data in MOCK_MODE.

Now do Step 3 from ROLLOUT_PLAN.md: the CSV invite pipeline.
The repo is at C:\Users\markt\Downloads\stool-app\calibrate — read AGENTS.md for
conventions and file locations before starting.
```

---

## Step 3 — CSV invite pipeline

**What it covers**
- `supabase/migrations/invite_tracking.sql` — create two tables:
  - `invite_batches(id, school_id, created_by, created_at, total_rows, imported, failed, status)`
  - `invite_batch_rows(id, batch_id, email, full_name, role, status, error, user_id, created_at)`
  - RLS: admins read/write rows for their own school; non-admins blocked
- `supabase/functions/invite-user/index.ts` — Deno Edge Function; accepts
  `{ email, fullName, role, schoolId, batchRowId }`; calls
  `supabase.auth.admin.inviteUserByEmail`, upserts `profiles`, updates the
  `invite_batch_rows` row status; returns `{ userId }` or `{ error }`
- `src/lib/supabase.js` — add helpers:
  - `createInviteBatch({ schoolId, createdBy, totalRows })`
  - `updateInviteBatchRow(rowId, { status, error, userId })`
  - `inviteUser({ email, fullName, role, schoolId, batchRowId })` — calls the
    Edge Function in prod, simulates with 500ms delay in MOCK_MODE
- `AdminDashboard.jsx` Invite Member view — replace the static SQL snippet panel with:
  - CSV file input (plain `FileReader` + `split('\n')` — no library)
  - Preview table: email / name / role / status (max 10 rows, scrollable)
  - "Import N users" button — sequential row-by-row import with live status updates
  - Batch summary on completion: "X imported · Y failed"
  - MOCK_MODE simulates the full flow without Supabase calls

**Expected outputs**
- `supabase/migrations/invite_tracking.sql`
- `supabase/functions/invite-user/index.ts`
- Updated `src/lib/supabase.js`
- Updated `AdminDashboard.jsx`

**When done, test in MOCK_MODE with a 5-row CSV (include one bad email row to confirm
error handling), then paste the block below to start Step 4.**

---

### ▶ Paste to Claude to start Step 4

```
Step 3 is done. CSV import works in MOCK_MODE — valid rows import sequentially,
bad rows show errors without blocking the rest, batch summary shows at the end.

Now do Step 4 from ROLLOUT_PLAN.md: the admin action queue.
The repo is at C:\Users\markt\Downloads\stool-app\calibrate — read AGENTS.md for
conventions and file locations before starting.
```

---

## Step 4 — Admin action queue

**What it covers**
- `supabase/migrations/action_items.sql` — create one table:
  - `admin_action_items(id, school_id, user_id?, module_slug?, action_type, severity,
    status, title, detail, due_date, metadata jsonb, created_at, resolved_at)`
  - `action_type` values: `invite_failed` | `no_progress` | `stalled` | `overdue` | `quiz_weak`
  - `severity` values: `high` | `medium` | `low`
  - RLS: admins read/write for their school; others blocked
- `supabase/functions/refresh-action-items/index.ts` — Edge Function that queries
  relevant tables and upserts action items for a school:
  - `invite_failed`: `invite_batch_rows` where `status = 'failed'`
  - `no_progress`: assigned users with zero `module_completions` rows after 7 days
  - `stalled`: `progress_pct > 0` and `progress_pct < 80` with no update in 14 days
  - `overdue`: `assignments.due_date` passed and `completed_at` is null
  - `quiz_weak`: `quiz_responses` aggregated correctness below 60% for a question
- `src/lib/supabase.js` — add helpers:
  - `getAdminActionItems(schoolId)` — returns open items ordered by severity then due_date
  - `resolveAdminActionItem(id)` — sets `status = 'resolved'`, `resolved_at = now()`
  - `refreshAdminActionItems(schoolId)` — calls the Edge Function
- `AdminDashboard.jsx` — add a new "Action Queue" sidebar tab (⚡) between Members
  and Assign Modules:
  - Grouped by severity (high → medium → low)
  - Each item shows title, detail, optional user/module pill, due date
  - "Resolve" button per item
  - "Refresh" button calls `refreshAdminActionItems`
  - MOCK_MODE shows deterministic mock items (one per action_type)

**Expected outputs**
- `supabase/migrations/action_items.sql`
- `supabase/functions/refresh-action-items/index.ts`
- Updated `src/lib/supabase.js`
- Updated `AdminDashboard.jsx`

**When done, test in MOCK_MODE — all five action types appear, Resolve clears the item,
Refresh repopulates the mock list.**

---

## Sequencing summary

| Step | What ships | Unlocks |
|------|-----------|---------|
| 1 | Quiz SQL + Woodstock content SQL | Supabase has complete content |
| 2 | WoodstockModuleView + real analytics | App reads live content, admins see real quiz data |
| 3 | CSV import + invite tracking | Woodstock can onboard 480 users |
| 4 | Action queue | Admin knows exactly who needs follow-up |

Steps 1–3 are the Woodstock launch requirements. Step 4 can follow once the cohort is live.
