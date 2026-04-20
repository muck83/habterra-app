-- ══════════════════════════════════════════════════════════════════════
-- fix_assignments_rls.sql
--
-- Fixes: "new row violates row-level security policy for table
-- assignments" when marktcrowell@gmail.com (role = 'superadmin') tries
-- to assign a module from the Admin dashboard.
--
-- Root cause: the existing `assignments_admin` policy is a strict
--   p.role = 'admin'
-- check. Superadmins are a superset of admins but fail the string
-- comparison, so the INSERT is blocked.
--
-- Fix: (a) widen the policy to accept 'admin' or 'superadmin';
--      (b) add an explicit WITH CHECK clause so INSERT is allowed;
--      (c) add a platform-wide superadmin escape hatch that doesn't
--          require school_id to match (so superadmins can assign
--          across any school).
--
-- Safe to re-run.
-- ══════════════════════════════════════════════════════════════════════

BEGIN;

-- ── 1. Replace the school-admin policy ─────────────────────────────

DROP POLICY IF EXISTS "assignments_admin" ON public.assignments;

CREATE POLICY "assignments_admin" ON public.assignments
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('admin', 'superadmin')
        AND p.school_id = assignments.school_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role IN ('admin', 'superadmin')
        AND p.school_id = assignments.school_id
    )
  );

-- ── 2. Add a platform-wide superadmin bypass ───────────────────────
-- Lets the Calibrate operator assign modules to ANY school, not just
-- the one their profile is linked to.

DROP POLICY IF EXISTS "assignments_superadmin" ON public.assignments;

CREATE POLICY "assignments_superadmin" ON public.assignments
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role = 'superadmin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role = 'superadmin'
    )
  );

-- ── 3. Mirror the fix for module_completions admin reads ───────────
-- The existing completions_admin_read policy also matches on
-- role = 'admin' only; widen it the same way so superadmin can see
-- completion progress across the school.

DROP POLICY IF EXISTS "completions_admin_read" ON public.module_completions;

CREATE POLICY "completions_admin_read" ON public.module_completions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles admin_p
      JOIN public.profiles user_p ON user_p.id = module_completions.user_id
      WHERE admin_p.id = auth.uid()
        AND admin_p.role IN ('admin', 'superadmin')
        AND admin_p.school_id = user_p.school_id
    )
    OR EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND p.role = 'superadmin'
    )
  );

COMMIT;

-- ── Verification ───────────────────────────────────────────────────
-- Should list assignments_admin + assignments_superadmin.
SELECT policyname, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'assignments'
ORDER BY policyname;

-- Confirm your profile is superadmin.
SELECT p.email, p.role, p.school_id
FROM public.profiles p
WHERE p.email = 'marktcrowell@gmail.com';

-- Dry-run the INSERT that the UI was trying to make (as your user).
-- Replace <school_id> with the NLIS Riyadh id if you want a real test.
-- EXPLAIN INSERT INTO public.assignments (school_id, role_target, module_slug, assigned_by, due_date)
-- VALUES ('<school_id>', 'teacher', 'india-ib', auth.uid(), '2026-06-30');
