# Calibrate — 24-Hour Autonomy Plan
_Written: 2026-04-17 | For: Mark Crowell_

This document captures the full state of the project and what should happen next. It is written so that any agent — Codex or otherwise — can pick up and continue without waiting for instructions.

---

## What Was Completed This Session

| Item | Status |
|---|---|
| Certificate link in Progress page expanded view | ✅ Done |
| Indonesia + UAE wired into mockData.js, Dashboard.jsx, ModuleCard.jsx | ✅ Done |
| `indonesia_seed.sql` — 6 dims, 9 quiz, 3 sims (513 lines, validated) | ✅ Done |
| `uae_seed.sql` — 6 dims, 9 quiz, 3 sims (504 lines, validated) | ✅ Done |

### Files Needing DB Execution (Manual — Browser Required)
These SQL files are written and validated. They cannot be run autonomously because they require the Supabase SQL editor at https://supabase.com/dashboard/project/gapmcwpttlramjmdiybu/sql.

Run in this order:
1. `indonesia_seed.sql`
2. `uae_seed.sql`
3. `preamble_migration.sql` (verify `pd_modules.preamble_md` column exists first)

---

## Current Module Inventory

| Slug | DB ID | SQL File | DB Status |
|---|---|---|---|
| ksa-ib | ksa-001 | cal_seed_part1/2/3.sql | ✅ Seeded |
| india-ib | india-001 | india_seed.sql + india_quiz_v2.sql | ✅ Seeded |
| korea-ib | korea-001 | cal_seed_part1/2/3.sql + korea_quiz.sql | ✅ Seeded |
| china-ib | china-001 | cal_seed_part1/2/3.sql + china_quiz.sql | ✅ Seeded |
| vietnam-ib | vietnam-001 | vietnam_seed.sql + vn_*.sql | ✅ Seeded |
| japan-ib | japan-001 | japan_seed.sql | ⏳ Needs browser |
| indonesia-ib | indonesia-001 | indonesia_seed.sql | ⏳ Needs browser |
| uae-ib | uae-001 | uae_seed.sql | ⏳ Needs browser |
| woodstock-transition | woodstock-001 | woodstock_seed.sql | ✅ Seeded |

---

## Architecture Notes for Any Agent

### Tech Stack
- React 18 + Vite 5, plain JSX, no TypeScript
- Supabase backend (project ref: `gapmcwpttlramjmdiybu`)
- `MOCK_MODE = !import.meta.env.VITE_SUPABASE_URL` gates real API calls
- All module metadata lives in `src/data/mockData.js` (MODULE_META export)
- Module cards: `src/components/ModuleCard.jsx`
- Routes: `src/App.jsx`

### Key Data Files
```
src/data/mockData.js        — MODULE_META, MOCK_ASSIGNMENTS, MOCK_COMPLETIONS
src/lib/supabase.js         — all DB functions
src/pages/Dashboard.jsx     — MODULE_LABELS map + dashboard view
src/pages/ModuleView.jsx    — main learning UI (tabs: dimensions, quiz, sims)
src/pages/Progress.jsx      — per-module progress with expandable quiz breakdown
src/pages/CertificatePage.jsx — print-to-PDF certificate
src/components/ModuleCard.jsx — card with Start/Continue/Review state
src/components/SimulationPlayer.jsx — branching simulation engine
```

### SQL Dollar-Quoting Convention
All JSONB content uses named dollar-quote tags to avoid conflicts:
- `$json$...$json$::jsonb` — dimension content
- `$opts$...$opts$::jsonb` — quiz options arrays
- `$chars$...$chars$::jsonb` — simulation persona
- `$nodes$...$nodes$::jsonb` — simulation node tree

### Git Commit Workaround
The filesystem mount blocks `unlink`, so standard `git commit` fails with index.lock errors.
Use this Python plumbing workaround:

```bash
export PATH="/sessions/blissful-youthful-franklin/.npm-global/bin:$PATH"
# 1. Stage with alternate index
GIT_INDEX_FILE=/tmp/git-idx-$$ git -C /sessions/.../mnt/stool-app add calibrate/
# 2. Write tree
TREE=$(GIT_INDEX_FILE=/tmp/git-idx-$$ git -C /sessions/.../mnt/stool-app write-tree)
# 3. Get parent
PARENT=$(cat /sessions/.../mnt/stool-app/.git/refs/heads/main)
# 4. Create commit
COMMIT=$(GIT_INDEX_FILE=/tmp/git-idx-$$ git -C /sessions/.../mnt/stool-app commit-tree $TREE -p $PARENT -m "your message")
# 5. Update ref
echo $COMMIT > /sessions/.../mnt/stool-app/.git/refs/heads/main
```

### Codex Path Requirement
Always set PATH before Codex commands:
```bash
export PATH="/sessions/blissful-youthful-franklin/.npm-global/bin:$PATH"
```

### Codex Task Sizing Limits
- **Do not** ask Codex to generate SQL files > 300 lines in one pass (stalls at ~25min, hits context ceiling)
- **Do** give Codex single-file frontend tasks under ~200 lines output — these work reliably
- **Do not** use subagent-spawned Codex jobs (they return phantom job IDs). Use the companion script directly:
  ```bash
  node /sessions/blissful-youthful-franklin/mnt/.remote-plugins/plugin_01VSn5bSPAmcNvFtCF7QanVf/scripts/codex-companion.mjs
  ```

---

## Remaining Development Tasks (Priority Order)

### High Priority — Frontend (Codex-appropriate, single file, < 200 lines)

**1. AdminDashboard — Verify Assignment Flow**
File: `src/pages/AdminDashboard.jsx`
Task: Read the current assignment creation UI. Verify that:
- Module slug is written correctly to `assignments` table
- The slug list includes all 8 modules (ksa-ib, india-ib, korea-ib, china-ib, vietnam-ib, japan-ib, indonesia-ib, uae-ib)
- Due date and role_target fields are populated correctly
- Fix any issues found.
Codex instruction: "Read AdminDashboard.jsx. Verify the assignment creation form sends the correct module_slug for all modules including japan-ib, indonesia-ib, and uae-ib. Update the module dropdown options if any are missing."

**2. SuperAdminDashboard — School Management**
File: `src/pages/SuperAdminDashboard.jsx`
Task: Check whether the school management view allows adding new schools with a `domain` field. This is needed for multi-tenant onboarding.
Codex instruction: "Read SuperAdminDashboard.jsx. Check whether the school creation form includes a domain field and that it maps to the schools table's domain column. Add the domain field if missing."

**3. ModuleView — Japan/Indonesia/UAE preamble_md display**
File: `src/pages/ModuleView.jsx`
Task: Verify that the `preamble_md` field in MODULE_META for japan-ib, indonesia-ib, and uae-ib actually renders in the preamble gate screen. The gate screen reads `MODULE_META[slug]?.preamble_md` — confirm this path is correct after the last session's edits.
Codex instruction: "Read ModuleView.jsx. Confirm that the preambleText variable is populated from MODULE_META[slug]?.preamble_md for all slugs including japan-ib, indonesia-ib, uae-ib. Add a console.log if needed to debug, then remove it."

### Medium Priority — SQL (Manual, browser-executed)

**4. japan_seed.sql → Run in Supabase SQL editor**
This file exists and is validated. Navigate to https://supabase.com/dashboard/project/gapmcwpttlramjmdiybu/sql and paste the file contents.

**5. indonesia_seed.sql → Run in Supabase SQL editor**
Same as above.

**6. uae_seed.sql → Run in Supabase SQL editor**
Same as above.

**7. preamble_migration.sql → Verify and run**
Check the `pd_modules` table has a `preamble_md` text column. If not, `preamble_migration.sql` adds it.

### Lower Priority — New Content

**8. Nigeria module seed SQL**
Next cultural module for the roadmap. Nigerian families at international schools (typically Lagos or Abuja). Key dimensions: WAEC vs IB cultural logic, parental investment and expectation, community status signalling, religious diversity (Christian/Muslim split), homework and tutor culture.
Slug: `nigeria-ib` | DB ID: `nigeria-001`
Use the same SQL pattern as `indonesia_seed.sql`.

**9. Brazil module seed SQL**
For schools in São Paulo or Rio. Key dimensions: vestibular and ENEM culture, carinho (warmth) norms in school relationships, social class and school prestige signalling, father involvement patterns, WhatsApp parent culture.
Slug: `brazil-ib` | DB ID: `brazil-001`

### Done — Do Not Redo

- ModuleCard.jsx (Start/Continue/Review states — already implemented)
- Certificate page (CertificatePage.jsx — complete)
- Certificate link in Progress page — added this session
- Vietnam module (all SQL seeded)
- Japan seed SQL (written, validated — needs browser to run)

---

## Quick Dev Commands

```bash
# Start dev server
cd /sessions/blissful-youthful-franklin/mnt/stool-app/calibrate
npm run dev

# Validate a SQL file
python3 -c "
import re
from collections import Counter
with open('FILE.sql') as f: c = f.read()
print('null bytes:', '\x00' in c)
tags = re.findall(r'\$(json|opts|chars|nodes)\$', c)
print(Counter(tags))
print('BEGIN:', c.count('BEGIN;'), 'COMMIT:', c.count('COMMIT;'))
"
```

---

_Last updated: 2026-04-17 by Claude (Cowork session)_
