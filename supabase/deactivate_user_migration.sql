-- ══════════════════════════════════════════════════
-- Habterra — Soft-delete (deactivate) users
-- Run this ONCE in the Supabase SQL editor for your project.
-- Safe to re-run (uses IF NOT EXISTS).
-- ══════════════════════════════════════════════════

-- 1. Add is_active flag to profiles. Existing users default to active.
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT true;

-- 2. Track when/who deactivated. Nullable — only populated on deactivation.
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS deactivated_at timestamptz;

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS deactivated_by uuid REFERENCES auth.users(id) ON DELETE SET NULL;

-- 3. Index so member-list queries stay fast when the table grows.
CREATE INDEX IF NOT EXISTS idx_profiles_is_active ON profiles(is_active)
  WHERE is_active = false;

-- 4. (Optional) Cascade: when a user is deactivated, drop their pending
-- role-target assignments so they don't count toward school progress.
-- The app also does this client-side in setUserActive().
-- If you'd rather do it purely at the DB layer, uncomment this trigger:
--
-- CREATE OR REPLACE FUNCTION handle_profile_deactivation()
-- RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
-- BEGIN
--   IF NEW.is_active = false AND (OLD.is_active IS DISTINCT FROM NEW.is_active) THEN
--     DELETE FROM assignments WHERE user_id = NEW.id;
--     DELETE FROM module_completions WHERE user_id = NEW.id;
--   END IF;
--   RETURN NEW;
-- END $$;
--
-- DROP TRIGGER IF EXISTS trg_profile_deactivation ON profiles;
-- CREATE TRIGGER trg_profile_deactivation
--   AFTER UPDATE ON profiles
--   FOR EACH ROW EXECUTE FUNCTION handle_profile_deactivation();

-- 5. RLS: deactivated users shouldn't be able to fetch their own profile
-- (they'll bounce to /signin with "account disabled"). Adjust the names
-- below if your profile-read policy is called something different.
--
-- You can verify the current policy names with:
--   SELECT polname FROM pg_policy
--   WHERE polrelid = 'profiles'::regclass;
--
-- If the existing SELECT policy for the owner is named "profile_own_read",
-- this replaces it with a copy that also checks is_active:
--
-- DROP POLICY IF EXISTS profile_own_read ON profiles;
-- CREATE POLICY profile_own_read ON profiles
--   FOR SELECT USING (auth.uid() = id AND is_active = true);

-- Done. After running, the admin UI's Deactivate-user button will work,
-- and getSchoolMembers() will hide rows where is_active = false.
