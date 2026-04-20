-- Assign India module to Woodstock School teachers

INSERT INTO assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,
  'teacher',
  'india-ib',
  (SELECT id FROM profiles WHERE role = 'admin' ORDER BY created_at LIMIT 1),
  '2026-06-30'
FROM schools s
WHERE s.domain = 'woodstockschool.in'
  AND NOT EXISTS (
    SELECT 1 FROM assignments a
    WHERE a.school_id = s.id AND a.module_slug = 'india-ib'
  );

-- Verify
SELECT a.module_slug, a.role_target, a.due_date, s.name AS school
FROM assignments a
JOIN schools s ON s.id = a.school_id
WHERE s.domain = 'woodstockschool.in'
ORDER BY a.module_slug;
