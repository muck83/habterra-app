BEGIN;

CREATE TABLE IF NOT EXISTS public.invite_batches (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id   uuid NOT NULL REFERENCES public.schools(id) ON DELETE CASCADE,
  created_by  uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  total_rows  integer NOT NULL DEFAULT 0 CHECK (total_rows >= 0),
  imported    integer NOT NULL DEFAULT 0 CHECK (imported >= 0),
  failed      integer NOT NULL DEFAULT 0 CHECK (failed >= 0),
  status      text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'running', 'completed', 'partial', 'failed'))
);

CREATE TABLE IF NOT EXISTS public.invite_batch_rows (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  batch_id    uuid NOT NULL REFERENCES public.invite_batches(id) ON DELETE CASCADE,
  email       text NOT NULL,
  full_name   text,
  role        text NOT NULL,
  status      text NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'importing', 'success', 'failed')),
  error       text,
  user_id     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_invite_batches_school
  ON public.invite_batches(school_id);

CREATE INDEX IF NOT EXISTS idx_invite_batches_created_by
  ON public.invite_batches(created_by);

CREATE INDEX IF NOT EXISTS idx_invite_batch_rows_batch
  ON public.invite_batch_rows(batch_id);

CREATE INDEX IF NOT EXISTS idx_invite_batch_rows_status
  ON public.invite_batch_rows(status);

ALTER TABLE public.invite_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invite_batch_rows ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can read invite batches for their school"
  ON public.invite_batches;
CREATE POLICY "Admins can read invite batches for their school"
  ON public.invite_batches
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = invite_batches.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can insert invite batches for their school"
  ON public.invite_batches;
CREATE POLICY "Admins can insert invite batches for their school"
  ON public.invite_batches
  FOR INSERT
  TO authenticated
  WITH CHECK (
    created_by = auth.uid()
    AND EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = invite_batches.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can update invite batches for their school"
  ON public.invite_batches;
CREATE POLICY "Admins can update invite batches for their school"
  ON public.invite_batches
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = invite_batches.school_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = invite_batches.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can delete invite batches for their school"
  ON public.invite_batches;
CREATE POLICY "Admins can delete invite batches for their school"
  ON public.invite_batches
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = invite_batches.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can read invite batch rows for their school"
  ON public.invite_batch_rows;
CREATE POLICY "Admins can read invite batch rows for their school"
  ON public.invite_batch_rows
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.invite_batches batch
      JOIN public.profiles admin_profile
        ON admin_profile.school_id = batch.school_id
      WHERE batch.id = invite_batch_rows.batch_id
        AND admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
    )
  );

DROP POLICY IF EXISTS "Admins can insert invite batch rows for their school"
  ON public.invite_batch_rows;
CREATE POLICY "Admins can insert invite batch rows for their school"
  ON public.invite_batch_rows
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.invite_batches batch
      JOIN public.profiles admin_profile
        ON admin_profile.school_id = batch.school_id
      WHERE batch.id = invite_batch_rows.batch_id
        AND admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
    )
  );

DROP POLICY IF EXISTS "Admins can update invite batch rows for their school"
  ON public.invite_batch_rows;
CREATE POLICY "Admins can update invite batch rows for their school"
  ON public.invite_batch_rows
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.invite_batches batch
      JOIN public.profiles admin_profile
        ON admin_profile.school_id = batch.school_id
      WHERE batch.id = invite_batch_rows.batch_id
        AND admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.invite_batches batch
      JOIN public.profiles admin_profile
        ON admin_profile.school_id = batch.school_id
      WHERE batch.id = invite_batch_rows.batch_id
        AND admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
    )
  );

DROP POLICY IF EXISTS "Admins can delete invite batch rows for their school"
  ON public.invite_batch_rows;
CREATE POLICY "Admins can delete invite batch rows for their school"
  ON public.invite_batch_rows
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.invite_batches batch
      JOIN public.profiles admin_profile
        ON admin_profile.school_id = batch.school_id
      WHERE batch.id = invite_batch_rows.batch_id
        AND admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
    )
  );

COMMIT;

-- Verification:
-- SELECT tablename, rowsecurity
-- FROM pg_tables
-- WHERE schemaname = 'public'
--   AND tablename IN ('invite_batches', 'invite_batch_rows');
--
-- SELECT policyname, tablename
-- FROM pg_policies
-- WHERE schemaname = 'public'
--   AND tablename IN ('invite_batches', 'invite_batch_rows')
-- ORDER BY tablename, policyname;
