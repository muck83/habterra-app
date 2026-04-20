-- ============================================================
-- woodstock_user_import.sql
-- Bulk-import template for Woodstock School
--
-- HOW TO USE
-- ──────────
-- 1. Open Supabase Dashboard → SQL Editor
-- 2. Copy this file into the editor
-- 3. Replace the placeholder rows in Section 2 with the real
--    teacher / parent data (one row per user)
-- 4. Run the script
-- 5. Email users their temporary password and tell them to
--    reset it at first login (or use the Invite Member form
--    in Calibrate Admin → Invite Member to trigger Supabase
--    magic-link invitations instead)
--
-- PREREQUISITES
-- ─────────────
-- • cal_seed_part1.sql must already be applied
--   (creates the Woodstock school row and the admin profile)
-- • Note the Woodstock school_id from profiles or schools table:
--     SELECT id, name FROM public.schools WHERE name = 'Woodstock School';
--
-- SECURITY NOTE
-- ─────────────
-- This script inserts directly into auth.users, which requires
-- the service_role key (not the anon key). Only run this from
-- the Supabase SQL Editor — never expose service_role in client
-- code.
-- ============================================================


-- ── 0. Capture Woodstock's school_id ────────────────────────
-- Update this value after running the SELECT above.

DO $$
DECLARE
  woodstock_id uuid;
BEGIN
  SELECT id INTO woodstock_id
  FROM public.schools
  WHERE name = 'Woodstock School'
  LIMIT 1;

  IF woodstock_id IS NULL THEN
    RAISE EXCEPTION 'Woodstock School not found — run cal_seed_part1.sql first.';
  END IF;

  RAISE NOTICE 'Woodstock school_id: %', woodstock_id;
END $$;


-- ── 1. Helper function (run once, idempotent) ────────────────
-- Creates or updates a user + profile in one call.
-- Call: SELECT create_calibrate_user('email', 'Full Name', 'teacher'|'parent', 'TempPass123!');

CREATE OR REPLACE FUNCTION create_calibrate_user(
  p_email      text,
  p_full_name  text,
  p_role       text,          -- 'teacher' or 'parent'
  p_password   text           -- temporary password; user should reset
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id    uuid;
  v_school_id  uuid;
BEGIN
  -- Look up Woodstock school_id
  SELECT id INTO v_school_id
  FROM public.schools
  WHERE name = 'Woodstock School'
  LIMIT 1;

  IF v_school_id IS NULL THEN
    RAISE EXCEPTION 'Woodstock School not found';
  END IF;

  -- Check if user already exists
  SELECT id INTO v_user_id
  FROM auth.users
  WHERE email = p_email;

  IF v_user_id IS NULL THEN
    -- Create new auth user
    INSERT INTO auth.users (
      id,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_app_meta_data,
      raw_user_meta_data,
      created_at,
      updated_at,
      role,
      aud
    ) VALUES (
      gen_random_uuid(),
      p_email,
      crypt(p_password, gen_salt('bf')),
      now(),                          -- mark email as confirmed
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('full_name', p_full_name),
      now(),
      now(),
      'authenticated',
      'authenticated'
    )
    RETURNING id INTO v_user_id;
  END IF;

  -- Upsert profile (safe to re-run)
  INSERT INTO public.profiles (id, email, full_name, role, school_id, created_at)
  VALUES (v_user_id, p_email, p_full_name, p_role, v_school_id, now())
  ON CONFLICT (id) DO UPDATE
    SET full_name  = EXCLUDED.full_name,
        role       = EXCLUDED.role,
        school_id  = EXCLUDED.school_id;

  RETURN v_user_id;
END;
$$;


-- ── 2a. Teachers (replace with real data) ────────────────────
-- Format: SELECT create_calibrate_user('email', 'Full Name', 'teacher', 'TempPass123!');
-- Temporary passwords must be at least 8 chars; Supabase enforces this.

SELECT create_calibrate_user('teacher.one@woodstockschool.in',   'Teacher One',   'teacher', 'WS-2026-Temp!');
SELECT create_calibrate_user('teacher.two@woodstockschool.in',   'Teacher Two',   'teacher', 'WS-2026-Temp!');
SELECT create_calibrate_user('teacher.three@woodstockschool.in', 'Teacher Three', 'teacher', 'WS-2026-Temp!');
-- ... add all 80 teachers following the same pattern ...


-- ── 2b. Parents (replace with real data) ─────────────────────
-- Parents see the Woodstock Curriculum Transition module only.

SELECT create_calibrate_user('parent.one@example.com',   'Parent One',   'parent', 'WS-2026-Temp!');
SELECT create_calibrate_user('parent.two@example.com',   'Parent Two',   'parent', 'WS-2026-Temp!');
SELECT create_calibrate_user('parent.three@example.com', 'Parent Three', 'parent', 'WS-2026-Temp!');
-- ... add all 400 parents following the same pattern ...


-- ── 3. Assign modules (run after Section 2) ──────────────────
-- Assign 'woodstock-transition' to all teachers and parents at Woodstock.
-- This creates one school-wide assignment (user_id IS NULL = assigned to all).

-- NOTE: The assignments table has a check constraint (assignment_target) that
-- requires either user_id OR role_target to be non-null.
-- We insert two rows — one for each role — to cover both teachers and parents.

INSERT INTO public.assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,                     -- school-wide (not per-user)
  r.role_target,
  'woodstock-transition',
  (SELECT id FROM public.profiles
   WHERE school_id = s.id AND role = 'admin'
   LIMIT 1),               -- assigned by the Woodstock admin
  '2026-06-01'::date        -- adjust due date as needed
FROM public.schools s
CROSS JOIN (VALUES ('teacher'), ('parent')) AS r(role_target)
WHERE s.name = 'Woodstock School'
ON CONFLICT DO NOTHING;     -- safe to re-run


-- ── 4. Verification ──────────────────────────────────────────
-- Run these after the import to confirm everything looks right:

-- Count teachers and parents
SELECT role, count(*)
FROM public.profiles
WHERE school_id = (SELECT id FROM public.schools WHERE name = 'Woodstock School')
GROUP BY role;
-- Expected: teacher → 80, parent → 400, admin → 1 (or however many)

-- Confirm assignment exists
SELECT module_slug, user_id, role_target, due_date
FROM public.assignments
WHERE school_id = (SELECT id FROM public.schools WHERE name = 'Woodstock School');
-- Expected: woodstock-transition row with user_id IS NULL

-- List first 10 users as a spot-check
SELECT p.email, p.full_name, p.role
FROM public.profiles p
JOIN public.schools s ON s.id = p.school_id
WHERE s.name = 'Woodstock School'
ORDER BY p.role, p.full_name
LIMIT 10;


-- ── 5. Clean up helper function (optional) ───────────────────
-- After the import is complete, you can drop the helper function
-- if you don't want it persisting in your database:
--
--   DROP FUNCTION IF EXISTS create_calibrate_user(text, text, text, text);
