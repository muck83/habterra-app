-- ============================================================
-- quiz_responses_migration.sql
-- Run this in the Supabase SQL Editor (Dashboard → SQL Editor)
-- Prerequisite: cal_seed_part1.sql and cal_seed_part2.sql must
--               already be applied.
-- ============================================================

-- ── 1. Create table ─────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.quiz_responses (
  id               uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  module_id        text        NOT NULL,   -- e.g. 'india-001', 'ksa-001'
  question_id      text        NOT NULL,   -- e.g. 'india-d1-q1'
  option_id        text        NOT NULL,   -- e.g. 'india-d1-q1-a'
  is_correct       boolean     NOT NULL,
  quiz_type        text        NOT NULL CHECK (quiz_type IN ('checkpoint', 'final_exam')),
  dimension_number integer,                -- 1–6; NULL for cross-dimension finals
  answered_at      timestamptz NOT NULL DEFAULT now()
);

-- ── 2. Indexes ──────────────────────────────────────────────

-- Unique: one answer per user per question (latest answer wins on upsert)
CREATE UNIQUE INDEX IF NOT EXISTS idx_quiz_resp_user_question
  ON public.quiz_responses (user_id, question_id);

-- Fast analytics queries by module
CREATE INDEX IF NOT EXISTS idx_quiz_resp_module
  ON public.quiz_responses (module_id);

-- Fast user-level progress queries
CREATE INDEX IF NOT EXISTS idx_quiz_resp_user
  ON public.quiz_responses (user_id);

-- ── 3. Row Level Security ────────────────────────────────────

ALTER TABLE public.quiz_responses ENABLE ROW LEVEL SECURITY;

-- Users can read and write their own responses
CREATE POLICY "Users can insert own quiz responses"
  ON public.quiz_responses
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own quiz responses"
  ON public.quiz_responses
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can read own quiz responses"
  ON public.quiz_responses
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Admins can read all responses for users in their school
-- (Joins through profiles to verify school membership)
CREATE POLICY "Admins can read school quiz responses"
  ON public.quiz_responses
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.profiles admin_profile
      JOIN public.profiles student_profile
        ON student_profile.id = quiz_responses.user_id
      WHERE admin_profile.id        = auth.uid()
        AND admin_profile.role      = 'admin'
        AND admin_profile.school_id = student_profile.school_id
    )
  );

-- ── 4. Verification ──────────────────────────────────────────
-- Run these after applying the migration to confirm it worked:
--
--   SELECT count(*) FROM public.quiz_responses;
--   -- Expected: 0 (table is empty until teachers answer questions)
--
--   SELECT tablename, rowsecurity
--   FROM pg_tables
--   WHERE schemaname = 'public' AND tablename = 'quiz_responses';
--   -- Expected: quiz_responses | t
--
--   SELECT indexname FROM pg_indexes
--   WHERE tablename = 'quiz_responses';
--   -- Expected: idx_quiz_resp_user_question, idx_quiz_resp_module, idx_quiz_resp_user
