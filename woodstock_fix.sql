-- ══════════════════════════════════════════════════════════════════════
-- woodstock_fix.sql
-- Run this in the Supabase SQL Editor to fix two issues:
--   1. school_id not set on Woodstock test user profiles
--   2. woodstock-transition assignment may be missing
-- ══════════════════════════════════════════════════════════════════════

-- ── STEP 1: Verify the school exists ─────────────────────────────────
SELECT id, name, domain FROM schools WHERE domain = 'woodstockschool.in';
-- Expected: 1 row. If 0 rows, run woodstock_seed.sql first.

-- ── STEP 2: Fix school_id on Woodstock profiles ───────────────────────
-- The handle_new_user trigger should have done this, but this makes it
-- explicit for users created via the Supabase Dashboard.

UPDATE profiles
SET school_id = (SELECT id FROM schools WHERE domain = 'woodstockschool.in')
WHERE email IN ('teacher@woodstockschool.in', 'parent@woodstockschool.in')
  AND school_id IS NULL;

-- ── STEP 3: Verify profiles look correct ─────────────────────────────
SELECT p.full_name, p.email, p.role, p.school_id, s.name AS school
FROM profiles p
LEFT JOIN schools s ON s.id = p.school_id
WHERE p.email IN ('teacher@woodstockschool.in', 'parent@woodstockschool.in');
-- Expected: both rows show school_id and school = 'Woodstock School'

-- ── STEP 4: Check if the assignment already exists ────────────────────
SELECT id, school_id, module_slug, role_target, due_date
FROM assignments
WHERE module_slug = 'woodstock-transition';
-- Expected: 1 row. If 0 rows, proceed to STEP 5.

-- ── STEP 5: Insert the assignment if it's missing ────────────────────
-- Only runs if no existing row was found above.

INSERT INTO assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,
  'all',
  'woodstock-transition',
  (SELECT id FROM profiles WHERE role = 'admin' ORDER BY created_at LIMIT 1),
  '2026-06-30'
FROM schools s
WHERE s.domain = 'woodstockschool.in'
  AND NOT EXISTS (
    SELECT 1 FROM assignments a
    WHERE a.school_id = s.id AND a.module_slug = 'woodstock-transition'
  );

-- ── STEP 6: Final verification ─────────────────────────────────────────
-- Confirms the assignment rows match the profiles' school_id.
SELECT
  p.full_name,
  p.email,
  p.role,
  p.school_id,
  a.module_slug,
  a.role_target,
  a.due_date
FROM profiles p
JOIN assignments a ON a.school_id = p.school_id AND a.user_id IS NULL
WHERE p.email IN ('teacher@woodstockschool.in', 'parent@woodstockschool.in')
ORDER BY p.email, a.module_slug;
-- Expected: rows showing woodstock-transition assigned to each user's school.
