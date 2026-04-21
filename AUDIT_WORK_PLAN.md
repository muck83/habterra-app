# Habterra audit — new-session prompt

Paste everything below into the first message of a fresh Cowork session (after mounting **only** `C:\Users\markt\Downloads\habterra-app`).

---

## Briefing for Claude

You are starting a new Cowork session against the habterra-app repo. habterra.com is a live, paid product for international schools, and you're going to work through a ten-point code audit in small, shippable bundles. Read this entire brief before touching anything.

### Step 0: Orient yourself (required)

Before any code changes, do these in order:

1. Read `HANDOFF.md` at the repo root — product vision, architecture, current state.
2. Read `AGENTS.md` — the house rules. Note especially the ban on TypeScript.
3. Read `ADMIN_AUDIT.md` — prior audit of admin surfaces; the items overlap with this work in a couple of places.
4. Skim the file tree: `src/pages/`, `src/lib/supabase.js`, `supabase/migrations/`, `vercel.json`, `package.json`.
5. Confirm with Mark that the production Supabase migrations are in the state you expect before proposing schema changes.

### Ground rules

1. **Mount only habterra-app.** Do NOT mount `stool-app` or `stool-app/calibrate`. The prior session was destabilized by a two-folder workflow where bash writes on the Linux sandbox side diverged from what Windows saw on disk, causing silent file truncation. habterra-app is now the single source of truth.
2. **This is a live paid product.** Every push to `main` auto-deploys to habterra.com via Vercel. No experiments on main. Ship small, thematic commits and run `npm run build` before each one.
3. **Respect AGENTS.md.** It explicitly bans TypeScript. Do not propose a TS migration without Mark's explicit say-so. ESLint, Prettier, and CI are fine and encouraged.
4. **Use Read/Edit/Write, not bash heredoc appends, for file edits.** Bash writes can land differently on Windows disk than in the Linux sandbox view. The Edit tool is Windows-authoritative. After any non-trivial edit, Read the file back via its Windows path to confirm.
5. **Use `C:\Users\markt\Downloads\habterra-app\COMMIT_AND_PUSH.ps1` to commit.** It stages everything new, pulls ff-only, prompts for a message, and pushes. One concern per commit.
6. **Ask before architectural bets.** Audit items #4, #5, #7 and #10a need design conversations with Mark first. Don't just do them.

---

## The audit

Habterra audit — ten recommended improvements

I read through the stack (React 18 + Vite + Supabase), config files, auth/data layer, routing, database schema and migrations, the planning docs (AGENTS.md, RUN_ORDER.md, etc.), and spot-inspected the largest components. Here are the ten improvements ranked roughly by impact.

1. **Add an automated test suite (critical).** Zero tests exist — no `*.test.*`, no `vitest.config`, no `__tests__`, nothing in `package.json` scripts. A paid product for international schools with real auth, RLS, and grading logic has no regression net. Start with Vitest + React Testing Library and cover: `AuthContext` role guards, the three `Require*` route wrappers in `App.jsx`, `upsertCompletion`'s "complete at ≥80%" threshold, and quiz answer correctness. Add a Playwright smoke test for login → dashboard → open module → submit checkpoint.

2. **The root `schema.sql` is dangerously out of sync with production.** `schema.sql` defines only `profiles`, `schools`, `assignments`, `module_completions` — and the `role` CHECK is `('teacher','parent','admin')`, so `'superadmin'` (used throughout `AuthContext.jsx` and guarded routes) is not even a legal value in that file. Meanwhile the app reads from `pd_modules`, `pd_dimensions`, `pd_quiz_questions`, `pd_simulations`, `pd_simulation_responses`, `quiz_responses`, `grade_overrides`, `invite_batches`, `invite_batch_rows`, `admin_action_items`, and calls `refresh_admin_action_items` RPC — none of which are in `schema.sql`. A new engineer running `schema.sql` on a fresh Supabase project gets a broken app. Consolidate every migration under `supabase/migrations/` with timestamped filenames, delete the 25+ loose `.sql` files at the repo root (or move them to `supabase/seeds/`), and make `schema.sql` either authoritative or delete it.

3. **Gate `MOCK_MODE` on an explicit flag, not a missing env var.** `const MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL` (in both `lib/supabase.js` and `AuthContext.jsx`) means that if a deploy ever ships without the env var, the live app silently boots into mock mode with `mock-admin` as the default persona. That is a production security footgun. Replace with an explicit `VITE_MOCK_MODE=true` flag and, when `MOCK_MODE` is true in a non-dev build (`import.meta.env.PROD`), throw at startup.

4. **Break up the god components.** `AdminDashboard.jsx` is 3,449 lines with ~400 inline `style={{` blocks; `WoodstockModuleView.jsx` is 2,157 lines. At that size, section-scoped state and handlers get tangled, React re-renders become coarse, and code review is impractical. Extract tab-level children (Overview, Members, Assign, Analytics, Invite) into their own files under `src/pages/admin/`, pull the repeated style objects into `tokens.css` classes, and use `React.lazy` + `Suspense` to route-split — right now the entire admin bundle ships to every teacher who logs in.

5. **Remove content from the data layer.** `src/lib/supabase.js` holds ~200 lines of hardcoded India final-exam questions inside `MOCK_FINAL_EXAMS`, plus `MOCK_PD_MODULES`, plus mock dimension factories. Mock content doesn't belong next to your Supabase client. Move all mock content into `src/data/` (where `mockData.js` already lives) and keep `lib/supabase.js` to the client, auth helpers, and typed query functions. Same issue in reverse: `mockData.js`, `lib/supabase.js`, and `AuthContext.jsx` each define overlapping mock profile/module objects — consolidate to one source of truth.

6. **Delete the leftover `.new` and `.tmp` backup files.** `src/pages/ModuleView.jsx.new` (762 lines, identical to `ModuleView.jsx`) and `src/components/SimulationPlayer.tmp` (484 lines) are stale copies. `.gitignore` ignores `*.new`/`*.tmp`, so they're workspace-only — but they still confuse search/replace and grep. Delete them. While you're there, the `superadmin/WoodstockEditor.jsx` is 1,317 lines — worth extracting subcomponents too.

7. **Add lint, format, typecheck, and a CI pipeline.** No ESLint, no Prettier, no TypeScript, no GitHub Actions workflow, no pre-commit hooks. Given the size of the codebase, at minimum add ESLint with `eslint-plugin-react`, `react-hooks`, and `jsx-a11y`; Prettier with a shared config; and a GitHub Actions workflow that runs `npm run lint && npm run build && npm test` on PRs. Optionally, migrate to TypeScript — the `AGENTS.md` explicitly bans it, but with ~10k lines of JSX and heavy Supabase row shapes flying around, this is the single highest-leverage investment for reliability (e.g., `getSchoolMembers` juggling `is_active` column-exists fallbacks would be caught by types).

8. **Fix accessibility gaps before you ship to schools.** International schools in the US, UK, and EU often have procurement requirements around WCAG 2.1 AA. Current gaps: no buttons have `aria-label`s despite heavy emoji/icon-only usage; `window.confirm(...)` is used for destructive actions in `Dashboard.jsx`, `AdminDashboard.jsx`, and `SuperAdminDashboard.jsx` — native `confirm` is screen-reader hostile and not stylable, so replace with a proper modal; step/dimension navigator dots aren't keyboard-reachable. Add `eslint-plugin-jsx-a11y` (it'll find most of these automatically) and run axe-core in a Playwright test.

9. **Add an `ErrorBoundary` and proper logging.** `App.jsx` has no error boundary — a render throw in any page crashes the whole app to a blank screen. `ErrorState.jsx` exists but only handles data-fetch errors. Wrap `<Routes>` in an `<ErrorBoundary>` that logs to a real sink (Sentry's free tier is fine). Right now ten `console.error`/`console.warn` calls are scattered across the codebase and no one will ever see them in production.

10. **Harden quiz response history and Vercel headers.** Two smaller items worth bundling. First: `upsertQuizResponse` uses `onConflict: 'user_id,question_id'`, which means retaking a quiz silently overwrites the prior attempt — there is no attempt history for learners or the analytics view (see how `getModuleQuizAnalytics` returns just the latest per user). If the product story is "learners can retry and the admin sees improvement," store per-attempt rows and compute latest/best in aggregation. Second: `vercel.json` sets cache headers but no security headers. Add `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy`, and a minimal CSP (at least `frame-ancestors 'none'` to prevent clickjacking of the admin UI).

**Honorable mentions:** the superadmin role isn't declared in the `profiles.role` CHECK constraint (so inserts referencing it will fail on a clean DB); the proliferation of "column doesn't exist yet" graceful-degradation fallbacks in `lib/supabase.js` suggests schema drift that the migrations consolidation in #2 would resolve; and the `.env` file holds a real anon key — that's fine for Supabase anon keys by design, but ensure `.env` is actually untracked (`.gitignore` lists it, so you're safe unless it was committed historically — worth a `git log --all -- .env` to confirm).

---

## How to work through it

Don't do the audit top-to-bottom. Work in the four phases below. Each phase ends with a green Vercel deploy and a smoke test.

### Phase 1 — Ship today (~30 min, high safety-ROI, low risk)

Low-risk, high-value fixes. One commit each.

- **#3 MOCK_MODE.** Replace `const MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL` in both `lib/supabase.js` and `AuthContext.jsx` with `const MOCK_MODE = import.meta.env.VITE_MOCK_MODE === 'true'`. Add a startup guard: `if (MOCK_MODE && import.meta.env.PROD) throw new Error('MOCK_MODE must not run in production')`. Update `.env.example`. **Verify:** build succeeds; running locally without the flag hits real Supabase.
- **#10b Vercel headers.** In `vercel.json`, add `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, a minimal `Permissions-Policy` (camera/mic/geolocation off), and `Content-Security-Policy: frame-ancestors 'none'`. Do NOT attempt a full CSP — it's a bigger project. **Verify:** after deploy, `curl -I https://habterra.com` shows the new headers.
- **#6 Delete backup files.** Remove `src/pages/ModuleView.jsx.new` and `src/components/SimulationPlayer.tmp`. Workspace-only cleanup; no commit needed if they're already gitignored, but confirm with `git status`.
- **Honorable mention — `.env` history check.** Run `git log --all -- .env` in habterra-app. If it returns any commits, surface the finding to Mark — do NOT attempt history rewrite unilaterally. If empty, report "clean."

Push, wait for Vercel green, smoke-test (login → dashboard → open module).

### Phase 2 — This week (medium lift, prevents future pain)

- **#2 Schema consolidation.** The highest-leverage item in the audit. Work in this order:
  1. Inventory: list every `.sql` file at repo root and every file under `supabase/` with a one-line description of what it does.
  2. Classify each as (a) schema migration, (b) seed/content, or (c) obsolete.
  3. Propose the new structure (likely: `supabase/migrations/NNNN_description.sql` with sequential numbering, `supabase/seeds/` for content, delete obsolete).
  4. Get Mark's sign-off on the plan BEFORE moving files.
  5. Execute: move files, update `schema.sql` to be either authoritative or deleted, add `superadmin` to the `profiles.role` CHECK constraint.
  6. Once schema is trustworthy, remove the "column does not exist yet" graceful-degradation try/catches in `lib/supabase.js`.

- **#9 ErrorBoundary.** Add `src/components/ErrorBoundary.jsx` (class component, `componentDidCatch` logs to `console.error` with a structured payload). Wrap `<Routes>` in `App.jsx`. Fallback UI should be on-brand with a "reload" button and a short sorry message. Sentry is a follow-up — ask Mark for an account first.

### Phase 3 — This month (bigger, but orderable)

Do these in order; earlier items make later ones easier.

- **#1 Test suite — after #2.** Do NOT write tests before schema consolidation or you'll write them against shapes that are about to change. Start with Vitest + React Testing Library. First tests: `AuthContext` role guards (`isAdmin`, `isSuperAdmin`, `isParent`), the `Require*` route wrappers in `App.jsx`, `upsertCompletion`'s ≥80% threshold, quiz correctness. Playwright smoke last: login → dashboard → module → checkpoint.
- **#7 Lint/format/CI.** ESLint with `eslint-plugin-react`, `react-hooks`, `jsx-a11y`. Prettier with committed `.prettierrc`. GH Actions on PRs: `npm ci && npm run lint && npm run build` (add `npm test` after #1). **Do not add TypeScript** unless Mark explicitly lifts the AGENTS.md ban.
- **#8 Accessibility.** The `jsx-a11y` lint from #7 catches most missing aria-labels. The `window.confirm` → custom modal swap is a bigger lift: build a reusable `ConfirmDialog` component and update the three call sites in `Dashboard.jsx`, `AdminDashboard.jsx`, `SuperAdminDashboard.jsx`. Ship lint fixes with #7; ship ConfirmDialog as its own PR.

### Phase 4 — Ask before starting (architecture / product bets)

Do not start any of these without a design discussion with Mark.

- **#4 God component split.** Correct instinct, but AdminDashboard at 3,449 lines got there organically. Write a design doc proposing the `src/pages/admin/` file layout, identify shared state and handlers, and get sign-off. `React.lazy` + `Suspense` for route-splitting is a smaller adjacent win that can ship first and independently.
- **#5 Mock content extraction.** Low user impact. Bundle with or after #4.
- **#10a Quiz attempt history.** This is a product decision. Ask Mark: "Do learners retry? Should admins see improvement over time?" If yes → per-attempt rows + aggregation view. If no → leave `onConflict` as is.

---

## Questions to confirm with Mark before Phase 2

1. Is the production Supabase schema actually what `supabase/migrations/*.sql` + the loose root SQL files describe? (Needed before consolidating.)
2. OK to move loose root `.sql` files into `supabase/seeds/` vs. deleting them?
3. Sentry account available for #9?
4. Is the AGENTS.md TypeScript ban still firm, or negotiable?
5. Product call on quiz retry history (#10a)?
6. Any live school rollouts planned this week that should gate riskier Phase 2 work?

## Per-commit checklist

Before each push:

- `npm run build` passes locally
- `git status` shows only the intended files
- Commit message is one concern, imperative ("add", "remove", "fix", "refactor")
- After `git push`, watch `https://vercel.com/muck83/habterra-app` for green
- If the change touches user-facing code, smoke-test habterra.com after deploy

## Out of scope for this pass

- Superadmin content-editor overhaul (covered in `ADMIN_AUDIT.md` §3 — separate effort)
- Per-school module access control (punt until a customer asks)
- TypeScript migration (banned per AGENTS.md)
- Mobile responsive admin layout
- The `deactivate_user_migration.sql` + dummy-parent cleanup (operational, not in this audit — Mark to run in Supabase)

Start with Step 0. Do not skip it.
