-- ════════════════════════════════════════════════════════════════════
-- Habterra: admin-side grade override table
-- Run in Supabase SQL editor. Adds the table + RLS the new
-- "Grades" section in the admin user-detail modal writes to.
-- ════════════════════════════════════════════════════════════════════

create table if not exists public.grade_overrides (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles(id) on delete cascade,
  module_slug     text not null,
  quiz_type       text not null check (quiz_type in ('checkpoint', 'final_exam')),
  override_score  integer not null check (override_score between 0 and 100),
  reason          text,
  created_by      uuid references public.profiles(id),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (user_id, module_slug, quiz_type)
);

-- Keep updated_at fresh on upsert.
create or replace function public.touch_grade_override()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_touch_grade_override on public.grade_overrides;
create trigger trg_touch_grade_override
  before update on public.grade_overrides
  for each row execute function public.touch_grade_override();

-- Index for the user-detail modal's read path.
create index if not exists idx_grade_overrides_user
  on public.grade_overrides (user_id);

-- ────────────────── RLS ──────────────────
alter table public.grade_overrides enable row level security;

-- Everyone authenticated can read their own overrides.
drop policy if exists "read own overrides" on public.grade_overrides;
create policy "read own overrides"
  on public.grade_overrides
  for select
  using (auth.uid() = user_id);

-- School admins/superadmins can read + write overrides for members of their school.
-- Uses the security-definer helpers from the earlier member-fetch migration.
drop policy if exists "admin read overrides" on public.grade_overrides;
create policy "admin read overrides"
  on public.grade_overrides
  for select
  using (
    public.current_user_role() in ('admin', 'superadmin')
    and (
      public.current_user_role() = 'superadmin'
      or exists (
        select 1 from public.profiles p
        where p.id = grade_overrides.user_id
          and p.school_id = public.current_user_school_id()
      )
    )
  );

drop policy if exists "admin upsert overrides" on public.grade_overrides;
create policy "admin upsert overrides"
  on public.grade_overrides
  for insert
  with check (
    public.current_user_role() in ('admin', 'superadmin')
    and (
      public.current_user_role() = 'superadmin'
      or exists (
        select 1 from public.profiles p
        where p.id = grade_overrides.user_id
          and p.school_id = public.current_user_school_id()
      )
    )
  );

drop policy if exists "admin update overrides" on public.grade_overrides;
create policy "admin update overrides"
  on public.grade_overrides
  for update
  using (
    public.current_user_role() in ('admin', 'superadmin')
    and (
      public.current_user_role() = 'superadmin'
      or exists (
        select 1 from public.profiles p
        where p.id = grade_overrides.user_id
          and p.school_id = public.current_user_school_id()
      )
    )
  );
