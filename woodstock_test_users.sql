-- ══════════════════════════════════════════════════════════════════════
-- Woodstock Test Users — Calibrate
-- Creates one teacher and one parent login for woodstockschool.in
-- Password for both: WoodstockTest2026
-- ══════════════════════════════════════════════════════════════════════

-- pgcrypto must be enabled (already done by cal_seed_part1.sql)

DO $$
DECLARE
  v_teacher_id uuid := gen_random_uuid();
  v_parent_id  uuid := gen_random_uuid();
BEGIN

  -- ── Teacher ────────────────────────────────────────────────────────
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'teacher@woodstockschool.in') THEN
    INSERT INTO auth.users (
      id, instance_id, aud, role,
      email, encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      v_teacher_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated', 'authenticated',
      'teacher@woodstockschool.in',
      crypt('WoodstockTest2026', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Asha Menon"}'::jsonb
    );
  END IF;

  -- ── Parent ─────────────────────────────────────────────────────────
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent@woodstockschool.in') THEN
    INSERT INTO auth.users (
      id, instance_id, aud, role,
      email, encrypted_password, email_confirmed_at,
      created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data
    ) VALUES (
      v_parent_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated', 'authenticated',
      'parent@woodstockschool.in',
      crypt('WoodstockTest2026', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Rajan Mehta"}'::jsonb
    );
  END IF;

END $$;

-- ── Fix names and roles ────────────────────────────────────────────────
-- The handle_new_user trigger auto-creates profiles, but role defaults to
-- 'teacher' and full_name is blank. Fix both:

UPDATE profiles
SET full_name = 'Asha Menon', role = 'teacher'
WHERE email = 'teacher@woodstockschool.in';

UPDATE profiles
SET full_name = 'Rajan Mehta', role = 'parent'
WHERE email = 'parent@woodstockschool.in';

-- ── Verify ────────────────────────────────────────────────────────────
SELECT p.full_name, p.email, p.role, s.name AS school
FROM profiles p
LEFT JOIN schools s ON s.id = p.school_id
WHERE p.email IN ('teacher@woodstockschool.in', 'parent@woodstockschool.in');
