-- ══════════════════════════════════════════════════════════════════════
-- nlis_setup.sql
-- Run this ONCE in the Supabase SQL Editor.
-- Creates the NLIS Riyadh school, links Mark's profile, assigns India module.
-- ══════════════════════════════════════════════════════════════════════

-- ── STEP 1: Create NLIS Riyadh school ────────────────────────────────

INSERT INTO schools (name, domain)
VALUES ('NLIS Riyadh', 'nlis.edu.sa')
ON CONFLICT (domain) DO NOTHING;

-- ── STEP 2: Link Mark's profile to NLIS Riyadh ───────────────────────

UPDATE profiles
SET school_id = (SELECT id FROM schools WHERE domain = 'nlis.edu.sa'),
    role      = 'admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'marktcrowell@gmail.com');

-- ── STEP 3: Verify ───────────────────────────────────────────────────

SELECT p.full_name, p.email, p.role, p.school_id, s.name AS school
FROM profiles p
LEFT JOIN schools s ON s.id = p.school_id
WHERE p.id = (SELECT id FROM auth.users WHERE email = 'marktcrowell@gmail.com');
-- Expected: role = admin, school = NLIS Riyadh

-- ── STEP 4: Assign India module to NLIS Riyadh ───────────────────────

INSERT INTO assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,
  'teacher',
  'india-ib',
  (SELECT id FROM profiles WHERE email = 'marktcrowell@gmail.com' LIMIT 1),
  '2026-06-30'
FROM schools s
WHERE s.domain = 'nlis.edu.sa'
  AND NOT EXISTS (
    SELECT 1 FROM assignments a
    WHERE a.school_id = s.id AND a.module_slug = 'india-ib'
  );

-- Also assign KSA module if not already assigned
INSERT INTO assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,
  'teacher',
  'ksa-ib',
  (SELECT id FROM profiles WHERE email = 'marktcrowell@gmail.com' LIMIT 1),
  '2026-06-30'
FROM schools s
WHERE s.domain = 'nlis.edu.sa'
  AND NOT EXISTS (
    SELECT 1 FROM assignments a
    WHERE a.school_id = s.id AND a.module_slug = 'ksa-ib'
  );

-- ── STEP 5: Final verification ───────────────────────────────────────

SELECT a.module_slug, a.role_target, a.due_date
FROM assignments a
JOIN schools s ON s.id = a.school_id
WHERE s.domain = 'nlis.edu.sa'
ORDER BY a.module_slug;
-- Expected: rows for india-ib and ksa-ib
