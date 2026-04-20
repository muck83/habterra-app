-- ============================================================
-- superadmin_role.sql
-- Adds the Calibrate platform-operator role and content-table
-- RLS bypass policies for trusted superadmins.
-- Safe to re-run.
-- ============================================================

BEGIN;

ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_role_check
  CHECK (role IN ('teacher', 'admin', 'parent', 'superadmin'));

-- pd_modules: superadmin full access
DROP POLICY IF EXISTS "pd_modules_superadmin" ON public.pd_modules;
CREATE POLICY "pd_modules_superadmin" ON public.pd_modules
  FOR ALL
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );

-- pd_dimensions: superadmin full access
DROP POLICY IF EXISTS "pd_dimensions_superadmin" ON public.pd_dimensions;
CREATE POLICY "pd_dimensions_superadmin" ON public.pd_dimensions
  FOR ALL
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );

-- pd_simulations: superadmin full access
DROP POLICY IF EXISTS "pd_simulations_superadmin" ON public.pd_simulations;
CREATE POLICY "pd_simulations_superadmin" ON public.pd_simulations
  FOR ALL
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'superadmin'
    )
  );

COMMIT;

-- Verification:
-- Should return the updated constraint.
SELECT pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conname = 'profiles_role_check';

-- Should return 3 rows (one per table).
SELECT policyname, tablename
FROM pg_policies
WHERE policyname LIKE '%superadmin%'
ORDER BY tablename;
