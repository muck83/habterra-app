-- ============================================================
-- woodstock_leadership_demo_accounts.sql
--
-- Creates three PARENT-role accounts so Woodstock leadership can
-- log into habterra.com and walk through the parent guide before
-- any broader rollout.
--
-- Accounts use their real @woodstock.ac.in emails (school convention
-- is CamelCase FirstnameLastname, e.g. MarkWindsor@woodstock.ac.in).
-- Stored lowercase here because Supabase Auth normalises login
-- addresses to lowercase — a CamelCase row in auth.users would fail
-- to match at sign-in. The email draft can still show the CamelCase
-- form since delivery is case-insensitive.
--
-- Since the SQL sets email_confirmed_at at creation, no invite email
-- is sent — they just sign in with the shared password below.
--
-- HOW TO USE
-- ──────────
-- 1. Make sure supabase/woodstock_user_import.sql has already been
--    run at least once — it defines create_calibrate_user() and
--    requires the Woodstock School row to exist.
-- 2. Open Supabase Dashboard → SQL Editor.
-- 3. Paste this file and run.
-- 4. Verify with the SELECT at the bottom.
-- ============================================================

-- Three Woodstock leadership demo accounts — all parent role.
SELECT create_calibrate_user('markwindsor@woodstock.ac.in',   'Mark Windsor',   'parent', 'WoodstockDemo2026!');
SELECT create_calibrate_user('chelseakorth@woodstock.ac.in',  'Chelsea Korth',  'parent', 'WoodstockDemo2026!');
SELECT create_calibrate_user('eldrimeintjes@woodstock.ac.in', 'Eldri Meintjes', 'parent', 'WoodstockDemo2026!');

-- Force-reset the password for all three — create_calibrate_user only
-- sets the password when inserting a NEW auth.users row, so if any of
-- these three already existed (from a prior seed or a real signup)
-- their password would otherwise stay whatever it was. This UPDATE
-- makes the script idempotent: re-running always pins the password
-- to WoodstockDemo2026! and confirms the email so sign-in works.
UPDATE auth.users
SET encrypted_password  = crypt('WoodstockDemo2026!', gen_salt('bf')),
    email_confirmed_at  = COALESCE(email_confirmed_at, now()),
    updated_at          = now()
WHERE email IN (
  'markwindsor@woodstock.ac.in',
  'chelseakorth@woodstock.ac.in',
  'eldrimeintjes@woodstock.ac.in'
);

-- Verification — confirm the three accounts landed under Woodstock.
SELECT p.email, p.full_name, p.role
FROM public.profiles p
JOIN public.schools s ON s.id = p.school_id
WHERE s.name = 'Woodstock School'
  AND p.email IN (
    'markwindsor@woodstock.ac.in',
    'chelseakorth@woodstock.ac.in',
    'eldrimeintjes@woodstock.ac.in'
  )
ORDER BY p.full_name;
-- Expected: 3 rows, each with role = 'parent'.
