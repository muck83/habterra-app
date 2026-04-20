# Calibrate + Stool -- SQL File Inventory & Run Order

Last updated: 2026-04-16

SQL files live in three locations. This document is the single source of truth for what exists, what has been applied, and what order to run things in.

**Directory key:**
- **A** = `calibrate/` (project root for Calibrate)
- **B** = `calibrate/supabase/` and `calibrate/supabase/migrations/`
- **C** = `supabase/migrations/` (stool-app root-level Supabase)
- **D** = `stool-app/` and project root (stool-app schema versions)

---

## Complete file inventory

| # | File | Dir | Purpose |
|---|------|-----|---------|
| 1 | `schema.sql` | A | Core Calibrate tables: auth, profiles, schools, assignments, completions, RLS, indexes |
| 2 | `cal_seed_part1.sql` | A | Seeds pd_modules, pd_dimensions, initial scenarios for KSA/China/Korea/India |
| 3 | `cal_seed_part2.sql` | A | Creates pd_quiz_questions table, seeds initial quizzes, creates simulation tables |
| 4 | `cal_seed_part3.sql` | A | Korea dimension patches, China/Korea/KSA simulation content |
| 5 | `woodstock_seed.sql` | A | Woodstock School, test users, module shell, initial dimensions/scenarios, parent assignment |
| 6 | `india_seed.sql` | A | Upgrades India module content with current research backbone |
| 7 | `india_quiz_v2.sql` | A | Replaces India quiz questions, expands final exam to 6 questions |
| 8 | `ksa_quiz.sql` | A | KSA quiz v2: 6 checkpoints + 3 final questions |
| 9 | `korea_quiz.sql` | A | Korea quiz v2: 6 checkpoints + 3 final questions |
| 10 | `china_quiz.sql` | A | China quiz v2: 6 checkpoints + 3 final questions |
| 11 | `woodstock_content_seed.sql` | A | Updates Woodstock module metadata, maps parent-transition content into 6 pd_dimensions rows |
| 12 | `nlis_setup.sql` | A | Creates NLIS Riyadh school row, links Mark's profile, India/KSA assignments for Mark |
| 13 | `woodstock_india_assign.sql` | A | Assigns india-ib to all Woodstock teachers |
| 14 | `woodstock_fix.sql` | A | Ensures woodstock-transition is assigned to Woodstock parents |
| 15 | `woodstock_test_users.sql` | A | Template for adding test users at Woodstock |
| 16 | `phase1_dimension_updates.sql` | A | Research-informed dimension rewrites for KSA/Korea/China |
| 17 | `supabase/quiz_responses_migration.sql` | B | Creates quiz_responses table for real quiz analytics |
| 18 | `supabase/woodstock_user_import.sql` | B | Bulk-import template for Woodstock School users |
| 19 | `supabase/migrations/invite_tracking.sql` | B | Creates invite_batches and invite_batch_rows tables |
| 20 | `supabase/migrations/action_items.sql` | B | Creates admin_action_items table |
| 21 | `20260330_create_pd_layer.sql` | C | PD layer migration: pd_modules, pd_dimensions, pd_scenarios tables |
| 22 | `20260330_create_quiz_questions.sql` | C | Creates pd_quiz_questions table + seeds initial quiz data |
| 23 | `20260330_patch_korea_research.sql` | C | Korea JSTOR research patches (Bong 2008 etc.) |
| 24 | `20260330_china_content_rewrite.sql` | C | China module full content rewrite -- all 6 dimensions + 4 scenarios |
| 25 | `20260330_seed_india_module.sql` | C | India module seed from Codex content package |
| 26 | `20260330_create_simulations.sql` | C | Creates pd_simulations table |
| 27 | `20260330_seed_china_simulation_1.sql` | C | China Sim 1: "The Workbook" |
| 28 | `20260330_seed_ksa_simulation_1.sql` | C | KSA Sim 1: "The English-Only Wall" |
| 29 | `20260330_seed_korea_simulation_1.sql` | C | Korea Sim 1: "The Academy Planner" |
| 30 | `20260330_seed_india_simulation_1.sql` | C | India Sim 1: "The Scorecard" |
| 31 | `20260330_seed_china_simulation_2.sql` | C | China Sim 2: "The Silent Mathematician" |
| 32 | `20260330_seed_china_simulation_3.sql` | C | China Sim 3: "Between Two Worlds" |
| 33 | `20260331_seed_china_simulation_4.sql` | C | China Sim 4: "The Public WeChat Question" |
| 34 | `20260331_seed_india_simulation_2.sql` | C | India Sim 2: "The PTM Follow-Up" |
| 35 | `20260331_seed_korea_simulation_2.sql` | C | Korea Sim 2: "The Reform Petition" |
| 36 | `20260331_seed_ksa_simulation_2.sql` | C | KSA Sim 2: "The Student Voice Week" |
| 37 | `20260331_pd_cultural_feedback.sql` | C | Creates pd_cultural_feedback table for teacher feedback on cultural vocab activities |
| 38 | `20260331_salary_exp_bracket.sql` | C | Adds exp_bracket column to salary_submissions |
| 39 | `20260402_create_feedback.sql` | C | Creates generic feedback table with RLS |
| 40 | `RUN_NEW_SIMS.sql` | `supabase/` | Convenience script -- run order for new simulation migrations |
| 41 | `supabase-schema.sql` | D | Stool core schema v1 |
| 42 | `supabase-schema-v2.sql` | D | Stool schema v2 |
| 43 | `supabase-schema-v3.sql` | D | Stool schema v3 |
| 44 | `supabase-schema-v4.sql` | D | Stool schema v4 |
| 45 | `supabase-schema-v5.sql` | D | Stool schema v5 -- adds email to diagnostic_submissions |

Note: Files 41-45 also have copies inside `stool-app/stool-app/` (nested directory). The root-level copies are canonical.

---

## Section 1: Already Applied

These files have been run on the production Supabase instance. They are listed for reference so you know what is in the database already. Do NOT re-run unless rebuilding from scratch.

### Stool core schema (run first, in order)

| # | Path | Notes |
|---|------|-------|
| 1 | `supabase-schema.sql` | Stool v1 core tables |
| 2 | `supabase-schema-v2.sql` | v2 additions |
| 3 | `supabase-schema-v3.sql` | v3 additions |
| 4 | `supabase-schema-v4.sql` | v4 additions |
| 5 | `supabase-schema-v5.sql` | v5 -- email on diagnostic_submissions |

### Calibrate core (run after Stool schema)

| # | Path | Notes |
|---|------|-------|
| 6 | `calibrate/schema.sql` | Core Calibrate tables |
| 7 | `calibrate/cal_seed_part1.sql` | Modules, dimensions, scenarios |
| 8 | `calibrate/cal_seed_part2.sql` | Quiz table + seeds, simulation tables |
| 9 | `calibrate/cal_seed_part3.sql` | Korea patches, simulation content |
| 10 | `calibrate/woodstock_seed.sql` | Woodstock school + module + test users |
| 11 | `calibrate/india_seed.sql` | India research backbone upgrade |
| 12 | `calibrate/india_quiz_v2.sql` | India quiz v2 (6 checkpoints + 6 final) |
| 13 | `calibrate/ksa_quiz.sql` | KSA quiz v2 |
| 14 | `calibrate/korea_quiz.sql` | Korea quiz v2 |
| 15 | `calibrate/china_quiz.sql` | China quiz v2 |
| 16 | `calibrate/woodstock_content_seed.sql` | Woodstock dimension content |
| 17 | `calibrate/nlis_setup.sql` | NLIS school + Mark's assignments |
| 18 | `calibrate/woodstock_india_assign.sql` | India-ib assignment for Woodstock teachers |
| 19 | `calibrate/woodstock_fix.sql` | Woodstock parent assignment fix |
| 20 | `calibrate/supabase/quiz_responses_migration.sql` | quiz_responses table |
| 21 | `calibrate/supabase/migrations/invite_tracking.sql` | invite_batches + invite_batch_rows |
| 22 | `calibrate/supabase/migrations/action_items.sql` | admin_action_items table |
| 23 | `calibrate/phase1_dimension_updates.sql` | KSA/Korea/China research-informed dimension rewrites |

### Stool-app PD layer + simulations

| # | Path | Notes |
|---|------|-------|
| 24 | `supabase/migrations/20260330_create_pd_layer.sql` | pd_modules, pd_dimensions, pd_scenarios |
| 25 | `supabase/migrations/20260330_create_quiz_questions.sql` | pd_quiz_questions table + seeds |
| 26 | `supabase/migrations/20260330_patch_korea_research.sql` | Korea JSTOR research patches |
| 27 | `supabase/migrations/20260330_china_content_rewrite.sql` | China full content rewrite |
| 28 | `supabase/migrations/20260330_seed_india_module.sql` | India module from Codex package |
| 29 | `supabase/migrations/20260330_create_simulations.sql` | pd_simulations table |
| 30 | `supabase/migrations/20260330_seed_china_simulation_1.sql` | China: "The Workbook" |
| 31 | `supabase/migrations/20260330_seed_china_simulation_2.sql` | China: "The Silent Mathematician" |
| 32 | `supabase/migrations/20260330_seed_china_simulation_3.sql` | China: "Between Two Worlds" |
| 33 | `supabase/migrations/20260330_seed_ksa_simulation_1.sql` | KSA: "The English-Only Wall" |
| 34 | `supabase/migrations/20260330_seed_korea_simulation_1.sql` | Korea: "The Academy Planner" |
| 35 | `supabase/migrations/20260330_seed_india_simulation_1.sql` | India: "The Scorecard" |
| 36 | `supabase/migrations/20260331_seed_china_simulation_4.sql` | China: "The Public WeChat Question" |
| 37 | `supabase/migrations/20260331_seed_india_simulation_2.sql` | India: "The PTM Follow-Up" |
| 38 | `supabase/migrations/20260331_seed_korea_simulation_2.sql` | Korea: "The Reform Petition" |
| 39 | `supabase/migrations/20260331_seed_ksa_simulation_2.sql` | KSA: "The Student Voice Week" |
| 40 | `supabase/migrations/20260331_pd_cultural_feedback.sql` | pd_cultural_feedback table |
| 41 | `supabase/migrations/20260331_salary_exp_bracket.sql` | exp_bracket column on salary_submissions |
| 42 | `supabase/migrations/20260402_create_feedback.sql` | Generic feedback table |

---

## Section 2: Needs to Be Applied (in order)

No unapplied migrations at this time. When new SQL files are added, list them here with their run order and dependencies.

Template for future entries:

| # | Path | Depends on | What it does |
|---|------|------------|--------------|
| - | `<path>` | `<prerequisite>` | Description |

After running each file, execute its verification query (see Section 4).

---

## Section 3: Reference Only

These files are templates or convenience scripts. Do NOT run them as part of a migration sequence.

| File | Path | Purpose |
|------|------|---------|
| `woodstock_test_users.sql` | `calibrate/woodstock_test_users.sql` | Template for adding individual test users at Woodstock. Copy and modify per user. |
| `woodstock_user_import.sql` | `calibrate/supabase/woodstock_user_import.sql` | Bulk-import template for Woodstock teachers/parents. Fill in real data before running. |
| `RUN_NEW_SIMS.sql` | `supabase/RUN_NEW_SIMS.sql` | Convenience doc listing the order for simulation seeds. Not executable on its own. |
| `supabase-schema*.sql` (in `stool-app/stool-app/`) | `stool-app/stool-app/supabase-schema*.sql` | Duplicate copies of root-level schema files. Ignore these -- use root copies. |

---

## Section 4: Verification Queries

Run these after a fresh build or after applying new migrations.

### 4a. Core module check

```sql
-- All modules should appear with status = 'live'
SELECT id, title, status
FROM public.pd_modules
ORDER BY id;
```

### 4b. Dimension counts per module

```sql
-- Expected: 6 dimensions per module
SELECT module_id, count(*) AS dims
FROM public.pd_dimensions
GROUP BY module_id
ORDER BY module_id;
```

### 4c. Quiz question counts

```sql
-- Breakdown by module and quiz type
SELECT module_id, quiz_type, count(*) AS n
FROM public.pd_quiz_questions
GROUP BY module_id, quiz_type
ORDER BY module_id, quiz_type;
```

### 4d. Simulation counts

```sql
-- Expected: China 4, India 2, Korea 2, KSA 2
SELECT module_id, count(*) AS sims
FROM public.pd_simulations
GROUP BY module_id
ORDER BY module_id;
```

### 4e. Woodstock content mapping

```sql
SELECT dimension_number, title, content->>'sourceKey' AS source_key
FROM public.pd_dimensions
WHERE module_id = 'woodstock-001'
ORDER BY dimension_number;
```

### 4f. School assignments

```sql
-- Woodstock assignments
SELECT a.module_slug, a.role_target, a.due_date, s.name AS school
FROM public.assignments a
JOIN public.schools s ON s.id = a.school_id
WHERE s.domain = 'woodstockschool.in'
ORDER BY a.module_slug;

-- NLIS assignments
SELECT a.module_slug, a.role_target, a.due_date, s.name AS school
FROM public.assignments a
JOIN public.schools s ON s.id = a.school_id
WHERE s.domain = 'nlis.edu.sa'
ORDER BY a.module_slug;
```

### 4g. Invite tracking tables exist

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('invite_batches', 'invite_batch_rows', 'admin_action_items',
                     'quiz_responses', 'pd_cultural_feedback', 'feedback');
```

### 4h. Salary experience bracket column exists

```sql
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'salary_submissions'
  AND column_name = 'exp_bracket';
```

---

## Expected quiz/dimension results

| module_id | dims | checkpoints | final_exam | simulations |
|-----------|------|-------------|------------|-------------|
| china-001 | 6 | 6 | 3 | 4 |
| india-001 | 6 | 6 | 6 | 2 |
| korea-001 | 6 | 6 | 3 | 2 |
| ksa-001 | 6 | 6 | 3 | 2 |
| woodstock-001 | 6 | 0 | 0 | 0 |

---

## Dependency notes

**India module content**
- `cal_seed_part1.sql` seeds India with the older research backbone.
- `india_seed.sql` overwrites India with the current research backbone.
- `20260330_seed_india_module.sql` (in supabase/migrations) is the Codex-produced version.
- Run `india_seed.sql` after `cal_seed_part1.sql`.

**India quiz questions**
- `cal_seed_part2.sql` seeds India with 6 checkpoints + 3 final questions.
- `india_quiz_v2.sql` overwrites the 6 checkpoints and adds final questions 4-6.
- Final result: 6 checkpoint questions + 6 final exam questions.

**China, Korea, KSA quiz coverage**
- `ksa_quiz.sql`, `korea_quiz.sql`, and `china_quiz.sql` upgrade each module to the v2 quiz standard.
- Final result for each: 6 checkpoint questions + 3 final exam questions.
- Each question has exactly 4 options and exactly 1 correct answer.

**China content rewrite**
- `20260330_china_content_rewrite.sql` replaces all 6 dimensions + adds 4 scenarios.
- Sources: Li (2005), Ran (2001), Dahlin & Watkins (2000), Jin & Cortazzi (1998).

**Korea research patches**
- `20260330_patch_korea_research.sql` adds Bong (2008) to D2 and D5, removes Takayama (2009) from D3.

**Woodstock content**
- `woodstock_seed.sql` creates the Woodstock module shell and initial dimensions.
- `woodstock_content_seed.sql` updates those six dimensions with content mapped from `src/vocab/woodstock-parent-transition.js`.

**Simulations**
- `20260330_create_simulations.sql` must run before any seed_*_simulation_*.sql file.
- `20260330_seed_india_simulation_1.sql` also requires `20260330_seed_india_module.sql`.

**Phase 1 dimension updates**
- `phase1_dimension_updates.sql` requires cal_seed_part1 through cal_seed_part3 first.
- Research-informed rewrites for KSA, Korea, and China dimensions.

---

## Fresh build run order (complete)

If rebuilding the database from scratch, run in this exact order:

```
 1. supabase-schema.sql                                    (Stool v1)
 2. supabase-schema-v2.sql                                 (Stool v2)
 3. supabase-schema-v3.sql                                 (Stool v3)
 4. supabase-schema-v4.sql                                 (Stool v4)
 5. supabase-schema-v5.sql                                 (Stool v5)
 6. calibrate/schema.sql                                   (Calibrate core)
 7. calibrate/cal_seed_part1.sql                           (Modules + dimensions + scenarios)
 8. calibrate/cal_seed_part2.sql                           (Quiz table + seeds + sim tables)
 9. calibrate/cal_seed_part3.sql                           (Korea patches + sim content)
10. calibrate/woodstock_seed.sql                           (Woodstock school + module)
11. calibrate/india_seed.sql                               (India research upgrade)
12. calibrate/india_quiz_v2.sql                            (India quiz v2)
13. calibrate/ksa_quiz.sql                                 (KSA quiz v2)
14. calibrate/korea_quiz.sql                               (Korea quiz v2)
15. calibrate/china_quiz.sql                               (China quiz v2)
16. calibrate/woodstock_content_seed.sql                   (Woodstock dimension content)
17. calibrate/nlis_setup.sql                               (NLIS school + assignments)
18. calibrate/woodstock_india_assign.sql                   (India assignment for Woodstock)
19. calibrate/woodstock_fix.sql                            (Woodstock parent assignment fix)
20. calibrate/phase1_dimension_updates.sql                 (KSA/Korea/China dimension rewrites)
21. calibrate/supabase/quiz_responses_migration.sql        (quiz_responses table)
22. calibrate/supabase/migrations/invite_tracking.sql      (invite_batches + rows)
23. calibrate/supabase/migrations/action_items.sql         (admin_action_items)
24. supabase/migrations/20260330_create_pd_layer.sql       (PD layer tables)
25. supabase/migrations/20260330_create_quiz_questions.sql  (Quiz questions table)
26. supabase/migrations/20260330_patch_korea_research.sql   (Korea JSTOR patches)
27. supabase/migrations/20260330_china_content_rewrite.sql  (China full rewrite)
28. supabase/migrations/20260330_seed_india_module.sql      (India Codex seed)
29. supabase/migrations/20260330_create_simulations.sql     (pd_simulations table)
30. supabase/migrations/20260330_seed_china_simulation_1.sql
31. supabase/migrations/20260330_seed_china_simulation_2.sql
32. supabase/migrations/20260330_seed_china_simulation_3.sql
33. supabase/migrations/20260330_seed_ksa_simulation_1.sql
34. supabase/migrations/20260330_seed_korea_simulation_1.sql
35. supabase/migrations/20260330_seed_india_simulation_1.sql
36. supabase/migrations/20260331_seed_china_simulation_4.sql
37. supabase/migrations/20260331_seed_india_simulation_2.sql
38. supabase/migrations/20260331_seed_korea_simulation_2.sql
39. supabase/migrations/20260331_seed_ksa_simulation_2.sql
40. supabase/migrations/20260331_pd_cultural_feedback.sql   (Cultural feedback table)
41. supabase/migrations/20260331_salary_exp_bracket.sql     (Salary exp_bracket column)
42. supabase/migrations/20260402_create_feedback.sql        (Generic feedback table)
```
