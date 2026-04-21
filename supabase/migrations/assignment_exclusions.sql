-- assignment_exclusions.sql
--
-- Per-user exclusions on role-level assignments.
--
-- Problem: `assignments` supports (a) individual per-user rows and
-- (b) role-level rows (role_target IN 'teacher','parent','all') that
-- apply to every current and future member of that role at the
-- school. There is no way to say "everyone except Parent One."
--
-- Solution: a sidecar table that names the users who should be
-- excluded from a given role-level assignment. Application code filters
-- out assignments present in this table when computing the user's
-- module list, progress, and grades.
--
-- Safe to re-run.
-- ══════════════════════════════════════════════════════════════════════

BEGIN;

-- ── 1. Table ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.assignment_exclusions (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  assignment_id uuid        NOT NULL REFERENCES public.assignments(id) ON DELETE CASCADE,
  user_id       uuid        NOT NULL REFERENCES public.profiles(id)    ON DELETE CASCADE,
  excluded_by   uuid                 REFERENCES public.profiles(id),
  excluded_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT assignment_exclusions_unique UNIQUE (assignment_id, user_id)
);

-- Lookups: "what's excluded for me" (learner side) and "who's excluded
-- from this assignment" (admin side).
CREATE INDEX IF NOT EXISTS assignment_exclusions_user_idx
  ON public.assignment_exclusions (user_id);

CREATE INDEX IF NOT EXISTS assignment_exclusions_assignment_idx
  ON public.assignment_exclusions (assignment_id);

-- ── 2. RLS ─────────────────────────────────────────────────────────

ALTER TABLE public.assignment_exclusions ENABLE ROW LEVEL SECURITY;

-- Learners: see your own exclusions so the client can filter modules.
DROP POLICY IF EXISTS "assignment_exclusions_self_read" ON public.assignment_exclusions;
CREATE POLICY "assignment_exclusions_self_read" ON public.assignment_exclusions
  FOR SELECT
  USING (user_id = auth.uid());

-- Admins (and superadmins) of the excluded user's school can read+write
-- exclusions. Mirrors the `assignments_admin` policy shape.
DROP POLICY IF EXISTS "assignment_exclusions_admin" ON public.assignment_exclusions;
CREATE POLICY "assignment_exclusions_admin" ON public.assignment_exclusions
  FOR ALL
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_p
      JOIN public.profiles target_p
        ON target_p.id = assignment_exclusions.user_id
      WHERE admin_p.id = auth.uid()
        AND admin_p.role IN ('admin', 'superadmin')
        AND admin_p.school_id = target_p.school_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_p
      JOIN public.profiles target_p
        ON target_p.id = assignment_exclusions.user_id
      WHERE admin_p.id = auth.uid()
        AND admin_p.role IN ('admin', 'superadmin')
        AND admin_p.school_id = target_p.school_id
    )
  );

-- Platform-wide superadmin bypass: can exclude across any school.
DROP POLICY IF EXISTS "assignment_exclusions_superadmin" ON public.assignment_exclusions;
CREATE POLICY "assignment_exclusions_superadmin" ON public.assignment_exclusions
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

COMMIT;
