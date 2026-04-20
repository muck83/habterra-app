-- ══════════════════════════════════════════════════
-- Calibrate — Supabase Schema
-- Run this in the Supabase SQL editor for your project
-- ══════════════════════════════════════════════════

-- 1. Schools
CREATE TABLE IF NOT EXISTS schools (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  domain     text NOT NULL UNIQUE,   -- e.g. 'nlis.edu.sa'
  created_at timestamptz DEFAULT now()
);

-- 2. Profiles (one per auth user)
CREATE TABLE IF NOT EXISTS profiles (
  id         uuid PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  email      text NOT NULL,
  full_name  text,
  school_id  uuid REFERENCES schools(id),
  role       text NOT NULL DEFAULT 'teacher'
               CHECK (role IN ('teacher', 'parent', 'admin')),
  created_at timestamptz DEFAULT now()
);

-- Auto-create a profile row on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_school_id uuid;
  v_domain    text;
BEGIN
  -- Extract domain from email
  v_domain := split_part(NEW.email, '@', 2);

  -- Try to match to a registered school
  SELECT id INTO v_school_id
  FROM schools
  WHERE domain = v_domain
  LIMIT 1;

  INSERT INTO profiles (id, email, school_id)
  VALUES (NEW.id, NEW.email, v_school_id);

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 3. Module assignments
--    Either targeted at a specific user (user_id set)
--    or broadcast to a role group (role_target set, user_id null)
CREATE TABLE IF NOT EXISTS assignments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id   uuid NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
  user_id     uuid REFERENCES profiles(id) ON DELETE CASCADE,
  role_target text CHECK (role_target IN ('teacher', 'parent', 'all')),
  module_slug text NOT NULL,           -- e.g. 'india-ib', 'korea-ib'
  assigned_by uuid REFERENCES profiles(id),
  due_date    date,
  assigned_at timestamptz DEFAULT now(),
  CONSTRAINT assignment_target CHECK (
    user_id IS NOT NULL OR role_target IS NOT NULL
  )
);

-- 4. Completion tracking
CREATE TABLE IF NOT EXISTS module_completions (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  module_slug  text NOT NULL,
  progress_pct integer NOT NULL DEFAULT 0 CHECK (progress_pct BETWEEN 0 AND 100),
  completed_at timestamptz,           -- set when progress_pct >= 80
  last_updated timestamptz DEFAULT now(),
  UNIQUE (user_id, module_slug)
);

-- ── Row Level Security ──────────────────────────────

ALTER TABLE profiles           ENABLE ROW LEVEL SECURITY;
ALTER TABLE schools            ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE module_completions ENABLE ROW LEVEL SECURITY;

-- Profiles: users see their own; admins see their whole school
CREATE POLICY "profiles_self" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles_school_admin" ON profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid()
        AND p.role = 'admin'
        AND p.school_id = profiles.school_id
    )
  );

-- Schools: visible to members
CREATE POLICY "schools_member" ON schools
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.school_id = schools.id
    )
  );

-- Assignments: see your own or your role-group
CREATE POLICY "assignments_self" ON assignments
  FOR SELECT USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid()
        AND p.school_id = assignments.school_id
        AND (assignments.role_target = 'all' OR assignments.role_target = p.role)
        AND assignments.user_id IS NULL
    )
  );

-- Admins can manage assignments for their school
CREATE POLICY "assignments_admin" ON assignments
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid()
        AND p.role = 'admin'
        AND p.school_id = assignments.school_id
    )
  );

-- Completions: own only
CREATE POLICY "completions_self" ON module_completions
  FOR ALL USING (user_id = auth.uid());

CREATE POLICY "completions_admin_read" ON module_completions
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM profiles admin_p
      JOIN profiles user_p ON user_p.id = module_completions.user_id
      WHERE admin_p.id = auth.uid()
        AND admin_p.role = 'admin'
        AND admin_p.school_id = user_p.school_id
    )
  );

-- ── Seed data (example school) ──────────────────────
-- INSERT INTO schools (name, domain) VALUES ('NLIS Riyadh', 'nlis.edu.sa');
