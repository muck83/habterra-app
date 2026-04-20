BEGIN;

CREATE TABLE IF NOT EXISTS public.admin_action_items (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id   uuid NOT NULL REFERENCES public.schools(id) ON DELETE CASCADE,
  user_id     uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
  module_slug text,
  action_type text NOT NULL
    CHECK (action_type IN ('invite_failed', 'no_progress', 'stalled', 'overdue', 'quiz_weak')),
  severity    text NOT NULL DEFAULT 'medium'
    CHECK (severity IN ('high', 'medium', 'low')),
  status      text NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'resolved')),
  title       text NOT NULL,
  detail      text,
  due_date    date,
  metadata    jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at  timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);

CREATE INDEX IF NOT EXISTS idx_admin_action_items_school_status
  ON public.admin_action_items(school_id, status);

CREATE INDEX IF NOT EXISTS idx_admin_action_items_type
  ON public.admin_action_items(action_type);

CREATE INDEX IF NOT EXISTS idx_admin_action_items_user
  ON public.admin_action_items(user_id);

ALTER TABLE public.admin_action_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins can read action items for their school"
  ON public.admin_action_items;
CREATE POLICY "Admins can read action items for their school"
  ON public.admin_action_items
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = admin_action_items.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can insert action items for their school"
  ON public.admin_action_items;
CREATE POLICY "Admins can insert action items for their school"
  ON public.admin_action_items
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = admin_action_items.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can update action items for their school"
  ON public.admin_action_items;
CREATE POLICY "Admins can update action items for their school"
  ON public.admin_action_items
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = admin_action_items.school_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = admin_action_items.school_id
    )
  );

DROP POLICY IF EXISTS "Admins can delete action items for their school"
  ON public.admin_action_items;
CREATE POLICY "Admins can delete action items for their school"
  ON public.admin_action_items
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      WHERE admin_profile.id = auth.uid()
        AND admin_profile.role = 'admin'
        AND admin_profile.school_id = admin_action_items.school_id
    )
  );

COMMIT;

-- Verification:
-- SELECT tablename, rowsecurity
-- FROM pg_tables
-- WHERE schemaname = 'public'
--   AND tablename = 'admin_action_items';
--
-- SELECT policyname, tablename
-- FROM pg_policies
-- WHERE schemaname = 'public'
--   AND tablename = 'admin_action_items'
-- ORDER BY policyname;
