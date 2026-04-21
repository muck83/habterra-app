# Habterra — Project Handoff

Last updated 2026-04-20. This document is the single source of truth for anyone (Claude or otherwise) picking up Habterra development. Read it end-to-end before touching code.

---

## Quick start for a new Cowork session

When you open a fresh Cowork session, do exactly this:

1. **Mount only `C:\Users\markt\Downloads\habterra-app`.** Do not mount `C:\Users\markt\Downloads\stool-app` or `C:\Users\markt\Downloads\stool-app\calibrate`. Those are legacy; editing them does not deploy to habterra.com and caused repeated file-truncation bugs (see *Lessons learned* below).
2. **Attach this file (`HANDOFF.md`) to the first message** or paste it in. That gets the new session up to speed in one shot.
3. **Tell Claude:** "Habterra is the canonical repo. Never edit stool-app/calibrate. Commits go through `habterra-app\COMMIT_AND_PUSH.ps1`."

---

## Product vision

**Habterra** — tagline *"Find your footing."*

A professional development platform for international-school educators and counselors who work across cultures. The core insight is that teachers trained in one education system (usually Western, IB-style) routinely misread the cultural expectations of families from very different systems — Korean suneung pressure, Indian CBSE/percentage culture, Saudi tawjihiyya, Chinese gaokao collectivism, Japanese gakureki, Vietnamese THPTQG, Indonesian face dynamics with a faith dimension, Emirati wasta — and this misread shows up in predictable, high-stakes moments: parent conferences, grade pushback, curriculum-transition questions, college-advising conversations.

Habterra teaches this cultural fluency through:
- **Country modules** — structured 6-dimension guides grounded in research, each with simulations, quizzes, and a final exam. One module = one cultural lens a teacher will encounter inside their international school.
- **School-specific parent pages** — custom onboarding for parents of specific schools. Woodstock (Mussoorie, India) is the pilot: IGCSE + AP + WSD curriculum-transition explainer.
- **Admin surface** — school admins assign modules to their staff, track completion, manage members, override progress/grades when needed, deactivate users.
- **Superadmin** — Anthropic-style editorial control across all modules and all schools. Lets the platform team edit module prose, dimensions, and quizzes in place.

**Name rationale:** Habitus (Bourdieu's sociological concept — the internalized dispositions that make a culture feel "natural") + terra (ground, place). The product helps an educator stand on newly understood ground.

**Logo:** filled circle resting at the apex of two stacked horizon arcs — "rooted presence on layered ground." The fainter lower arc is the deeper cultural context beneath the visible one. Light theme uses teal; dark theme uses amber. See `src/components/Logo.jsx`. Do not revert to the old "Calibrate" reticle/crosshair design.

**Typography:** Fraunces (display serif, variable opsz 9-144, wght 300-800) for headings + Inter (body sans, 300-700) for text. Both via Google Fonts in `index.html`. Tokens `--font-display` and `--font-body` in `src/styles/tokens.css`.

**Brand palette** (internal CSS custom properties intentionally still named `--cal-*` from the pre-rebrand era — do not churn these to `--hab-*` unless explicitly asked):
- Teal `#0B5563` — primary
- Amber `#E8961E` — accent / in-progress
- Off-white `#F7F4EF` — surface
- Deeper ink and muted grays in the same token file

---

## Where we are (2026-04-20)

**Live:**
- `habterra.com` deploys from `github.com/muck83/habterra-app` via Vercel (project name: `habterra-app`). SSL green, DNS via Namecheap, auth URLs configured in Supabase for habterra.com.
- Admins and superadmins can sign in, assign modules, manage members, view progress.
- 9 country modules listed in the admin dropdown (all assignable as of 2026-04-20): India, Korea, Saudi Arabia, China, Vietnam, Japan, Indonesia, UAE, and the Woodstock School diploma-transition guide. The `inDev` gating was removed.
- Soft-delete (deactivate user) is wired in the AdminDashboard Danger Zone. Requires the `deactivate_user_migration.sql` to have been run in Supabase first.

**Users in the production DB:**
- `marktcrowell@gmail.com` — superadmin
- `eschoonard@gmail.com` — superadmin
- Three dummy parent accounts (`parent.one@example.com`, `parent.two@example.com`, `parent.three@example.com`) seeded during development. These should be deactivated via the new Deactivate button.

**Vercel Supabase environment:**
- Single Supabase project backs both habterra.com and any local dev. The `.env` file in habterra-app carries the anon key.
- RLS is the enforcement layer — never assume admin/superadmin power without a profile check.

---

## Architecture

**Stack:**
- React 18.3 + React Router 6.26
- Vite 5.4 build tooling
- Supabase (Postgres + Auth + Edge Functions + RLS)
- Tailwind-via-tokens (no Tailwind; custom CSS variables in `src/styles/`)
- Deployed on Vercel with SPA routing configured in `vercel.json`

**Supabase tables (roughly):**
- `profiles` — user rows, 1:1 with auth.users. Carries `role` (admin | superadmin | teacher | parent), `school_id`, `full_name`, `email`, `is_active` (since 2026-04-20 migration), `deactivated_at`, `deactivated_by`
- `schools` — one row per customer school
- `assignments` — user × module assignments
- `module_completions` — user × module progress + grade overrides
- `pd_modules`, `pd_dimensions`, `pd_quiz_questions`, `pd_simulations` — the module editorial surface
- `admin_action_items` — queue of admin-facing nags
- `invite_batches`, `invite_batch_rows` — bulk CSV invite trail

**Edge functions:**
- `invite-user` — creates auth users with admin-set password or a random temp, optionally skips email, writes to `invite_batches`. Silent-create toggle is wired.
- `refresh-action-items` — recomputes the admin nag queue.

**Frontend entry points:**
- `/signin`, `/signup`
- `/dashboard` — member's own dashboard, module cards
- `/module/:slug` — country module view (6 dimensions + quiz + final)
- `/woodstock` — Woodstock-specific module renderer (separate because it's a WSD curriculum explainer, not a cultural lens)
- `/parent/woodstock` — custom Woodstock parent onboarding page (Start Here, Core Concepts, Grades Decoded IGCSE+AP, WSD, University Pathways, Next Steps)
- `/progress` — per-dimension checkpoint + final exam status
- `/admin` — school admin surface (Members, Assignments, Add member, user detail drawer with per-user unassign / progress override / grade override / deactivate)
- `/superadmin` — cross-school editorial (WoodstockEditor, module prose, status toggles)
- `/cert/:moduleSlug` — completion certificate

**Key files (habterra-app tree, flat):**
- `src/pages/AdminDashboard.jsx` — the big one (~3.4k lines). All admin UI lives here, including the new Deactivate Danger Zone.
- `src/pages/SuperAdminDashboard.jsx` — superadmin home
- `src/pages/superadmin/WoodstockEditor.jsx` — 6-dimension schema editor
- `src/lib/supabase.js` — all Supabase calls. Includes `getSchoolMembers` with pre-migration fallback and `setUserActive`.
- `src/data/mockData.js` — module catalog + dummy data for MOCK_MODE
- `src/components/ModuleCard.jsx` — module cards used in Dashboard
- `src/components/TopBar.jsx`, `Logo.jsx` — global chrome
- `src/vocab/woodstock-parent-transition.js` — Woodstock parent guide content
- `supabase/deactivate_user_migration.sql` — soft-delete migration, idempotent, must be run once in Supabase SQL editor before the Deactivate button works
- `supabase/woodstock_user_import.sql` — seeded the three dummy parents; these should be soft-deleted now
- `supabase/functions/invite-user/index.ts` — the bulk invite edge function

---

## Workflow (deploy, commit, migrate)

**Code changes:**
1. Edit files in `C:\Users\markt\Downloads\habterra-app\` directly.
2. Run `C:\Users\markt\Downloads\habterra-app\COMMIT_AND_PUSH.ps1` — it pulls latest, stages everything (tracked + any new files in src/ / supabase/ / public/), prompts for a commit message, pushes to `origin/main`.
3. Vercel picks up the push and rebuilds habterra.com within ~30s. Watch at `https://vercel.com/muck83/habterra-app`.

**Supabase schema changes:**
1. Write the migration as an idempotent SQL file into `habterra-app/supabase/*.sql`.
2. Open the Supabase SQL editor for the project and paste + run.
3. Commit the SQL file so anyone re-provisioning has it.

**Don't:**
- Edit `stool-app/calibrate/`. That tree is deprecated. Its `COMMIT_AND_PUSH.ps1` and `PORT_TO_HABTERRA.ps1` now show a red DEPRECATED banner.
- Mix repos in one session.

---

## Recent shipped work (for quick context)

Last 10 commits reverse-chronological:
- `06537f7` admin: deactivate-user control, unlock all country modules + soft-delete migration
- `0be7677` admin: superadmin search, self-remove modules, truncation repairs
- `f34b1b8` admin: add-member flow, silent-create toggle, full user edit (modules/progress/grades)
- `b0c275f` admin: edit modules, override progress %, override grades
- `14e445b` admin: add new member modal (invite + module assign + welcome msg)
- `6bebee8` admin: fetch real school members, add per-user edit (name/role/school)
- `8e7b69c` admin: superadmin nav, unassign button, specific-users targeting, user detail drawer, school_id guard
- `04cdf36` initial: habterra split from stool-app

In the last session specifically: made all 9 country modules assignable (removed `inDev` gating), added a soft-delete (deactivate) user flow in AdminDashboard with a red Danger Zone and self-deactivation guard, wrote the idempotent `deactivate_user_migration.sql`, and retired the dual-repo port workflow.

---

## Pending work / backlog

1. **Run `deactivate_user_migration.sql` in Supabase SQL editor** — required before the Deactivate button will work. Not yet done in production as of this writing.
2. **Deactivate the three dummy parent accounts** (`parent.one@example.com`, `parent.two@example.com`, `parent.three@example.com`) via the new admin UI once the migration is applied.
3. **Delete the `/calibrate/` subdir from the stool-app repo.** Stool-app's local folder is locked on Windows (cowork mount holds file handles). Workaround: `git rm -r --cached calibrate` in the stool-app repo to untrack it without needing to touch the local folder.
4. **Bundle-size follow-up.** Vite warns at 700 kB gzipped. Consider dynamic imports or `build.rollupOptions.output.manualChunks` when there's time. Not urgent.
5. **Cert page footer** still references `learn.mystool.org` in at least one place (leftover from pre-rebrand). Sweep when you have a moment.
6. **Module content fill-in.** Only some modules have rich final exams wired. Korea/KSA/China/Vietnam/Japan/Indonesia/UAE may still have scaffolded-but-not-research-anchored content. Needs an audit pass.
7. **Documentation consolidation.** The habterra-app root has many legacy planning .md files (CODEX_AUTONOMY_PLAN, RESEARCH_BRIEF, CONTENT_PLAN, etc.) from the stool-app era. Worth a triage.

---

## Lessons learned — the crossover issue

Between April 17 and April 20 we ran a two-repo workflow: edits happened in `stool-app/calibrate/`, a PowerShell script copied the changed files into `habterra-app/`, then each repo was committed and pushed separately. This caused a tight loop of subtle production bugs:

- The cowork Linux sandbox and the Windows disk did not always agree on file contents after bash writes. A bash heredoc that appended content would appear clean in the Linux mount (correct line count, correct EOF) but show up on the Windows side with duplicated/orphaned content sitting after the intended EOF.
- Two concrete failures: `AdminDashboard.jsx` ended up with 62 orphan JSX lines *after* its closing `}`; `supabase.js` ended up with 83 orphan lines of duplicated exports *after* its last function. Both passed `vite build` in the sandbox but failed on Vercel.
- Because the port script copied from the Windows disk, the broken version faithfully propagated into habterra-app. Every "fix" from the sandbox had to be committed, ported, re-verified on Vercel, and re-fixed Windows-side with the Edit tool (which writes through the Windows path directly and does match what actually lands on disk).
- The fix: stop editing two trees. Edit habterra-app directly. The Edit tool in Cowork is Windows-view-authoritative; bash is a faster scratchpad but any repair that needs to be committed should be verified through a Read of the same Windows path before pushing.

**Rule of thumb for Claude in any future session:**
When repairing a file that got truncated or that has suspected content corruption, always Read through the Windows path (`C:\Users\markt\Downloads\...`) to confirm state before committing. Do not trust bash `wc -l` alone.

---

## How to verify you have a working session (smoke test)

From a new Cowork session with only habterra-app mounted:

1. `ls C:\Users\markt\Downloads\habterra-app\src\pages\AdminDashboard.jsx` should exist and be around 3448 lines.
2. In PowerShell: `cd C:\Users\markt\Downloads\habterra-app; npx vite build --outDir dist_smoke --emptyOutDir` should complete in ~3s with a ~700 kB bundle and no errors.
3. `habterra.com` should load, show the Habterra logo (rooted horizon), and let `marktcrowell@gmail.com` sign in and reach `/admin`.

If any of those fail, something drifted — check Vercel's latest deploy status and `git log -1` in habterra-app.

---

## Contacts and external references

- GitHub repo: `github.com/muck83/habterra-app`
- Vercel project dashboard: `https://vercel.com/muck83/habterra-app`
- Supabase project: check `.env` for the project URL
- DNS: Namecheap, configured for habterra.com + www
- Primary humans: Mark Crowell (marktcrowell@gmail.com), Eric Schoonard (eschoonard@gmail.com)

---

*This handoff was generated 2026-04-20 at the end of a Cowork session that retired the dual-repo workflow. If anything in here is out of date, `git log --oneline -20` in habterra-app is the authoritative changelog, and the live app at habterra.com is the authoritative behavior.*
