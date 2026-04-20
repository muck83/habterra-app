-- PD Layer migration — learn.mystool.org
-- Run this in the Supabase SQL editor.
-- After running, execute: UPDATE public.pd_scenarios SET status = 'live';

begin;

create extension if not exists pgcrypto;

-- ─── Tables ───

create table if not exists public.pd_modules (
  id text primary key,
  country_code char(2) not null unique,
  title text not null,
  tagline text,
  research_backbone jsonb not null default '[]'::jsonb,
  hofstede_data jsonb not null default '{}'::jsonb,
  completion_threshold integer not null default 80 check (completion_threshold between 1 and 100),
  unlock_reward text,
  status text not null default 'draft' check (status in ('draft', 'live', 'archived')),
  created_at timestamptz not null default now()
);

create table if not exists public.pd_dimensions (
  id uuid primary key default gen_random_uuid(),
  module_id text not null references public.pd_modules(id) on delete cascade,
  dimension_number integer not null check (dimension_number between 1 and 6),
  title text not null,
  research_status text not null check (research_status in ('fully_sourced', 'partial', 'community')),
  content jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique (module_id, dimension_number)
);

create table if not exists public.pd_scenarios (
  id uuid primary key default gen_random_uuid(),
  module_id text not null references public.pd_modules(id) on delete cascade,
  title text not null,
  setup text not null,
  common_misread text,
  actual_dynamic text,
  response_framework jsonb not null default '[]'::jsonb,
  dimension_tags integer[] not null default '{}'::integer[],
  source_type text not null check (source_type in ('academic', 'practitioner', 'community_submitted')),
  contributor_id uuid references auth.users(id) on delete set null,
  status text not null default 'draft' check (status in ('draft', 'live', 'archived')),
  created_at timestamptz not null default now(),
  unique (module_id, title)
);

create table if not exists public.pd_completions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  module_id text not null references public.pd_modules(id) on delete cascade,
  dimension_id uuid not null references public.pd_dimensions(id) on delete cascade,
  completed_at timestamptz not null default now(),
  unique (user_id, module_id, dimension_id)
);

create table if not exists public.pd_badges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  module_id text not null references public.pd_modules(id) on delete cascade,
  awarded_at timestamptz not null default now(),
  unique (user_id, module_id)
);

-- ─── Indexes ───

create index if not exists pd_modules_status_idx on public.pd_modules(status);
create index if not exists pd_modules_country_code_idx on public.pd_modules(country_code);
create index if not exists pd_dimensions_module_id_idx on public.pd_dimensions(module_id);
create index if not exists pd_scenarios_module_id_idx on public.pd_scenarios(module_id);
create index if not exists pd_scenarios_status_idx on public.pd_scenarios(status);
create index if not exists pd_completions_user_module_idx on public.pd_completions(user_id, module_id);
create index if not exists pd_badges_user_module_idx on public.pd_badges(user_id, module_id);

-- ─── RLS ───

alter table public.pd_modules enable row level security;
alter table public.pd_dimensions enable row level security;
alter table public.pd_scenarios enable row level security;
alter table public.pd_completions enable row level security;
alter table public.pd_badges enable row level security;

-- Public read for live modules, dimensions, scenarios
drop policy if exists "pd_modules_public_read" on public.pd_modules;
create policy "pd_modules_public_read" on public.pd_modules for select using (status = 'live');

drop policy if exists "pd_dimensions_public_read" on public.pd_dimensions;
create policy "pd_dimensions_public_read" on public.pd_dimensions for select
  using (exists (select 1 from public.pd_modules where pd_modules.id = pd_dimensions.module_id and pd_modules.status = 'live'));

drop policy if exists "pd_scenarios_public_read" on public.pd_scenarios;
create policy "pd_scenarios_public_read" on public.pd_scenarios for select
  using (status = 'live' and exists (select 1 from public.pd_modules where pd_modules.id = pd_scenarios.module_id and pd_modules.status = 'live'));

-- Authenticated users: own completions and badges
drop policy if exists "pd_completions_select_own" on public.pd_completions;
create policy "pd_completions_select_own" on public.pd_completions for select to authenticated using (auth.uid() = user_id);

drop policy if exists "pd_completions_insert_own" on public.pd_completions;
create policy "pd_completions_insert_own" on public.pd_completions for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "pd_badges_select_own" on public.pd_badges;
create policy "pd_badges_select_own" on public.pd_badges for select to authenticated using (auth.uid() = user_id);

drop policy if exists "pd_badges_insert_own" on public.pd_badges;
create policy "pd_badges_insert_own" on public.pd_badges for insert to authenticated with check (auth.uid() = user_id);

-- ─── Seed: Modules ───

insert into public.pd_modules (id, country_code, title, tagline, research_backbone, hofstede_data, completion_threshold, unlock_reward, status)
values
  ('ksa-001', 'SA', 'Saudi Arabia', 'The politics of institutional dissonance',
    $$[{"author":"Hammad","year":2018,"title":"Dissonance Between the International and the Conservative National","doi":"10.1177/0013161X18785864"},{"author":"Eisenbeiss","year":2012,"title":"Re-thinking ethical leadership","doi":"10.1016/j.leaqua.2011.11.003"}]$$::jsonb,
    '{"PDI":72,"IDV":48,"MAS":43,"UAI":64,"LTO":27,"IND":14}'::jsonb, 80, 'Unlock full salary data for Saudi Arabia schools', 'live'),
  ('china-001', 'CN', 'China', 'The philosophy of learning itself',
    $$[{"author":"Li","year":2005,"title":"Mind or virtue: Western and Chinese beliefs about learning","doi":"10.1007/s11406-005-1433-6"},{"author":"Ran","year":2001,"title":"Understanding Chinese parents educational values","doi":null}]$$::jsonb,
    '{"PDI":80,"IDV":20,"MAS":66,"UAI":30,"LTO":87,"IND":24}'::jsonb, 80, 'Unlock full salary data for China schools', 'live'),
  ('korea-001', 'KR', 'South Korea', 'Confucian foundations in a hyper-competitive state',
    $$[{"author":"Ferguson","year":2001,"title":"The Effect of Korean Cultural Assumptions on Teaching and Learning","doi":null},{"author":"Kim","year":2002,"title":"We Talk Therefore We Think","doi":"10.1037//0022-3514.83.4.828"}]$$::jsonb,
    '{"PDI":60,"IDV":58,"MAS":39,"UAI":85,"LTO":86,"IND":29}'::jsonb, 80, 'Unlock full salary data for South Korea schools', 'live')
on conflict (id) do update set
  country_code = excluded.country_code, title = excluded.title, tagline = excluded.tagline,
  research_backbone = excluded.research_backbone, hofstede_data = excluded.hofstede_data,
  completion_threshold = excluded.completion_threshold, unlock_reward = excluded.unlock_reward, status = excluded.status;

-- ─── Seed: Dimensions ───

insert into public.pd_dimensions (module_id, dimension_number, title, research_status, content) values
  -- Saudi Arabia
  ('ksa-001', 1, 'Learning philosophy orientation', 'community',
    $${"summary":"Saudi learning philosophy remains less directly sourced than China and Korea, but the working classroom model is authority-heavy, exam-oriented, and shaped by religious framing.","sections":[{"heading":"Current working model","items":["Authority orientation is likely higher than in a Western classroom.","Rote and examination habits remain strong in the national system.","Religious framing can shape responses to science, history, and social-studies content."]},{"heading":"Editorial note","items":["Treat this dimension as community-supported until more classroom-level Saudi evidence is added."]}]}$$::jsonb),
  ('ksa-001', 2, 'Parent communication dynamics', 'partial',
    $${"summary":"Saudi parent communication in international schools is partially sourced through Hammad and Shah's leadership-level evidence.","sections":[{"heading":"Known dynamics","items":["Parents can want Western credentials and conservative cultural protection at the same time.","Returning Saudi and expatriate families can want more liberal international-school norms than local conservative families.","Leadership often uses explanation, compliance, and circumvention rather than open policy challenge."]},{"heading":"Open question","items":["Classroom-level parent-meeting mechanics still need more direct teacher evidence."]}]}$$::jsonb),
  ('ksa-001', 3, 'Institutional and political context', 'fully_sourced',
    $${"summary":"Hammad and Shah (2018) identify three structural pressures that define daily reality in Saudi international schools.","sections":[{"heading":"Sex segregation","items":["Mandated in all international schools.","Requires separate buildings or sections.","Requires same-sex teachers and complicates activities and staff communication."]},{"heading":"Saudization","items":["10:1 expatriate-to-Saudi ratio mandate.","Ghost worker practice documented in the paper.","Creates staffing resentment and workload distortion."]},{"heading":"Parental expectations","items":["Conservative religious parents fear cultural contamination.","Returning Saudi and expatriate parents often expect liberal international-school norms.","Compliance and circumvention are documented coping strategies."]}],"citations":[{"author":"Hammad","year":2018,"doi":"10.1177/0013161X18785864"}]}$$::jsonb),
  ('ksa-001', 4, 'Ethical leadership tensions', 'fully_sourced',
    $${"summary":"Eisenbeiss's four ethical orientations map cleanly onto the Saudi context and explain why many conflicts have no fully clean exit.","sections":[{"heading":"Humane","items":["Cancelled or restricted activities can disadvantage specific students even when leaders want inclusion."]},{"heading":"Justice","items":["The Indian history textbook incident shows how no decision can satisfy every family equally under the policy environment."]},{"heading":"Responsibility","items":["Leaders constantly trade long-term cultural preservation against short-term compliance and pedagogical continuity."]},{"heading":"Moderation","items":["Moderation is the primary operative orientation in KSA.","Compliance and circumvention are moderation in practice."]}],"citations":[{"author":"Eisenbeiss","year":2012,"doi":"10.1016/j.leaqua.2011.11.003"},{"author":"Hammad","year":2018,"doi":"10.1177/0013161X18785864"}]}$$::jsonb),
  ('ksa-001', 5, 'Student behavior patterns', 'community',
    $${"summary":"Student behavior in Saudi international schools still needs more field evidence, but the current editorial model centers authority orientation, questioning restraint, and a performance-versus-inquiry split.","sections":[{"heading":"Working patterns","items":["Whole-class lecture expectations can land differently from one-to-one work.","Questioning and open disagreement are likely more constrained than in Western classrooms.","Gender-segregated schooling shapes behavior expectations and management patterns."]}]}$$::jsonb),
  ('ksa-001', 6, 'Practical scenarios', 'partial',
    $${"summary":"Saudi scenarios are ready for MVP use because the institutional context is already well defined even where classroom evidence is still growing.","sections":[{"heading":"Current scenario bank","items":["The cancelled graduation","The parent who reads the textbook","The Saudization team dynamic"]},{"heading":"Usage note","items":["Scenarios should teach teachers to diagnose structural rather than purely personal conflict."]}]}$$::jsonb),

  -- China
  ('china-001', 1, 'Learning philosophy orientation', 'fully_sourced',
    $${"summary":"Li (2005) distinguishes Western mind orientation from Chinese virtue orientation.","sections":[{"heading":"Mind orientation","items":["Curiosity, inquiry, self-expression, and process."]},{"heading":"Virtue orientation","items":["Moral self-perfection through diligence, perseverance, and endurance.","Effort is moral rather than merely instrumental."]},{"heading":"Key data","items":["79% of Chinese students defined knowledge as self-perfection or spiritual wealth.","96% of Western students defined it as facts or understanding of the world.","Failure is shame because it reflects on character and those who nurtured the student."]}],"citations":[{"author":"Li","year":2005,"doi":"10.1007/s11406-005-1433-6"}]}$$::jsonb),
  ('china-001', 2, 'Parent communication dynamics', 'fully_sourced',
    $${"summary":"Ran (2001) documents five parallel-track misunderstandings between Chinese parents and Western teachers.","sections":[{"heading":"Micro vs macro focus","items":["Parents seek precise error correction; teachers default to developmental narrative."]},{"heading":"Praise as problem","items":["Praise can sound like weakness avoidance."]},{"heading":"Extra homework as care","items":["Additional work is a support model, not automatically punishment."]},{"heading":"Assessment mismatch","items":["Perfect scores are possible in China; an 80% A-grade system confuses parents."]},{"heading":"Textbook expectation","items":["Parents want a curriculum map or common text so home support can be focused."]}],"citations":[{"author":"Ran","year":2001,"doi":null}]}$$::jsonb),
  ('china-001', 3, 'Institutional and political context', 'partial',
    $${"summary":"China's institutional context is shaped by the 2021 double-reduction reforms and by different regulatory rules for expatriate schools versus Chinese-foreign schools.","sections":[{"heading":"Double reduction","items":["Reduced the formal role of tutoring.","Shifted some pressure back onto schools and families.","Changed the mix of extracurricular demand."]},{"heading":"Track differentiation","items":["Expat-only schools and Chinese-foreign schools operate under different regulatory expectations.","Compulsory-stage foreign-curriculum autonomy is more limited than many teachers expect."]}]}$$::jsonb),
  ('china-001', 4, 'Ethical leadership tensions', 'partial',
    $${"summary":"Chinese context generates distinctive tensions around memorization, praise, suffering, and fairness.","sections":[{"heading":"Humane vs justice","items":["Memorized model answers can look like copying without actually being cheating in the virtue-orientation model."]},{"heading":"Responsibility","items":["Teachers may soften criticism to protect a child from suffering at home, but that can obscure the real learning need."]},{"heading":"Moderation","items":["Teachers need to adjust communication enough to be legible to Chinese parents without distorting the child's situation."]}]}$$::jsonb),
  ('china-001', 5, 'Student behavior patterns', 'fully_sourced',
    $${"summary":"Chinese student behavior is well explained by Li, Ran, and adjacent CHC literature.","sections":[{"heading":"Patterns","items":["Quietness does not equal disengagement.","Memorization often precedes understanding.","Perfectionism can produce drafting paralysis.","Participation needs to be redefined beyond public speaking."]}]}$$::jsonb),
  ('china-001', 6, 'Practical scenarios', 'partial',
    $${"summary":"China's scenario bank is ready for content build because the virtue-orientation and parent-communication models are already clear.","sections":[{"heading":"Current scenario bank","items":["The unsatisfied parent","The copying suspicion","The extra homework request","The 80% grade confusion","The silent achiever"]}]}$$::jsonb),

  -- South Korea (enriched from KOREA_MODULE_CONTENT.md + Ferguson 2001)
  ('korea-001', 1, 'Learning philosophy orientation', 'partial',
    $${"summary":"Korea shares the CHC backbone with China but layers stronger competition and exam intensity on top. Effort is moral, authority is baseline, and silence often signals concentration rather than passivity.","sections":[{"heading":"Shared Confucian backbone","items":["Effort, persistence, and endurance are read as signs of character, not just study technique.","A student who works hard without visible enthusiasm is still behaving in a culturally legible way.","Ferguson (2001) shows how Korean assumptions travel into Western-style schools."]},{"heading":"Korean divergence: competition layered onto virtue","items":["University entry is filtered through the CSAT/Suneung system and rank-sensitive academic sorting.","Students learn early that performance has long-range consequences.","Even ordinary classroom work can carry more weight than a Western teacher expects."]},{"heading":"The speaking-thinking split","items":["Kim (2002) shows that talking can interfere with reasoning for learners shaped by East Asian communication norms.","Silence should not be read automatically as confusion or low preparation.","Choi (2015): Korean students may speak very little in discussion while becoming much more active in written or online formats."]},{"heading":"What this means for teachers","items":["Reframe silence as a possible sign of cognitive engagement, face-management, or respect.","Reframe endurance as culturally meaningful.","Reframe authority-following as learned social literacy.","When you want exploratory talk, name the expectation, model it, and provide low-risk ways into it."]}],"citations":[{"author":"Ferguson","year":2001,"doi":null},{"author":"Kim","year":2002,"doi":"10.1037//0022-3514.83.4.828"},{"author":"Choi","year":2015,"doi":null}]}$$::jsonb),
  ('korea-001', 2, 'Parent communication dynamics', 'partial',
    $${"summary":"Korean parent communication is best understood as part of a high-monitoring, high-investment academic management system. Parents coordinate school, private tutoring, and pathway anxiety simultaneously.","sections":[{"heading":"High-monitoring, high-investment parent profile","items":["Park, Byun, and Kim (2011): parental involvement often takes the form of selecting and monitoring private tutoring.","Byun, Schofer, and Kim (2012): educational investment operates as a competitive strategy inside a state exam system.","The school teacher is rarely the sole academic adult in the picture."]},{"heading":"Help-seeking is harder than it looks","items":["Bong (2008): parental performance-goal pressure makes students more likely to avoid asking teachers for help.","Teachers can mistake quiet compliance for understanding.","A parent may arrive highly concerned about a student who rarely signaled trouble in class."]},{"heading":"What drives parents to make contact","items":["Kim and Chin (2016): contact is driven by underinformation and uncertainty about the child's ability.","More educated and affluent mothers were especially likely to communicate when feeling underinformed.","Contact is often a symptom of information anxiety, not dissatisfaction."]},{"heading":"What this means for teachers","items":["Proactive information-sharing reduces anxiety-driven contact.","Explain the grading architecture early.","Make help visible without making struggle public.","Treat parent questions as attempts to reduce uncertainty before you treat them as criticism."]}],"citations":[{"author":"Kim & Chin","year":2016,"doi":null},{"author":"Park, Byun & Kim","year":2011,"doi":null},{"author":"Bong","year":2008,"doi":null}]}$$::jsonb),
  ('korea-001', 3, 'Institutional and political context', 'partial',
    $${"summary":"Korea's institutional context combines bounded curricular autonomy, foreign-school legal complexity, national identity politics, and the parallel hagwon system.","sections":[{"heading":"Legal categories matter before pedagogy","items":["Yoo (2016): foreign schools, foreign educational institutions, and international schools are not interchangeable categories.","Curriculum freedom and enrollment rules differ by legal category.","Teachers need to know which category their school falls into."]},{"heading":"History curriculum remains politically sensitive","items":["Kim and Kim (2019): history education is tightly tied to national identity formation.","Japan-Korea history sits inside an active national debate about memory and legitimacy.","International school teachers are not exempt from this context."]},{"heading":"Foreign curricula are politically negotiated","items":["Kang and Shin (2020): the Korean-language IB rollout generated concerns about tutoring expansion and governance conflict.","Foreign frameworks are not adopted on educational merit alone; they are culturally negotiated."]},{"heading":"CSAT concentration changes the school year","items":["Pressure intensifies in October and November.","Schools operate inside a culture saturated by CSAT even when students are not directly sitting it."]}],"citations":[{"author":"Yoo","year":2016,"doi":null},{"author":"Kim & Kim","year":2019,"doi":null},{"author":"Hong & Youngs","year":2016,"doi":null},{"author":"Kang & Shin","year":2020,"doi":null}]}$$::jsonb),
  ('korea-001', 4, 'Ethical leadership tensions', 'partial',
    $${"summary":"Korean educational culture creates ethical tensions that are structural rather than personal. The teacher works inside a system where tutoring inequity, exhaustion, grade pressure, and help-seeking avoidance pull against one another.","sections":[{"heading":"Justice: the hagwon advantage","items":["Students who attend strong hagwon programs arrive with more preparation than those who cannot afford them.","This is a classroom equity problem the teacher did not create and cannot fully correct."]},{"heading":"Humane: the exhausted student","items":["A student sleeping in class may be exhausted rather than disrespectful.","The humane response is to read the condition before the behavior."]},{"heading":"Responsibility: grade pressure is structural","items":["Grades are pathway signals, not just feedback.","Holding to standards can carry real social cost for the student."]},{"heading":"Moderation: workload is calibrated differently","items":["What feels like a reasonable workload in a Western school can be read in Korea as low seriousness.","A teacher who assigns less to protect wellbeing may be acting humanely, but may be misread."]}],"citations":[{"author":"Ju et al.","year":2016,"doi":null},{"author":"Bong","year":2008,"doi":null}]}$$::jsonb),
  ('korea-001', 5, 'Student behavior patterns', 'fully_sourced',
    $${"summary":"Korean classroom behavior is easy to misread if a teacher treats verbal confidence, spontaneous disagreement, and visible help-seeking as universal norms. The evidence points to silence, authority-following, script dependence, hidden anxiety, and fatigue coexisting with high effort and serious academic intent.","sections":[{"heading":"Classroom silence","items":["Kim (2002): talking can disrupt reasoning for East Asian learners.","Choi (2015): silence can be driven by English limits, face-saving, and Korean classroom mannerisms.","Ferguson (2001): Western-style schools often misread low spontaneous talk as low engagement.","Build written response, think-pair-share, and digital participation routes into the lesson."]},{"heading":"Authority orientation","items":["Park, Lee, and Yun (2009): teacher decision authority is a baseline expectation in Korea.","Chae and Cho (2021): family and classroom authority structures are continuous.","Expect students to wait for permission before challenging or speculating."]},{"heading":"Open-ended task difficulty","items":["Ju et al. (2016): real difficulties with ambiguity and discursive demands in Korean PBL settings.","Yang et al. (2017): recurring confusion about what counts as evidence among Korean middle schoolers.","Script-following is the known-safe response when the task frame is culturally unfamiliar.","Give worked examples before fully open tasks."]},{"heading":"Performance-goal anxiety and help-seeking avoidance","items":["Bong (2008): parental pressure correlates with students avoiding asking teachers for help.","Teachers may not know who is struggling because those students are motivated to hide it.","Use anonymous digital tools and private question channels."]},{"heading":"Hagwon fatigue","items":["Late-night hagwon schedules mean fatigue is predictable, especially Years 11-12.","Morning disengagement does not predict overall disengagement.","Check timing before interpretation; distinguish exhaustion from disrespect."]}],"citations":[{"author":"Ferguson","year":2001,"doi":null},{"author":"Kim","year":2002,"doi":"10.1037//0022-3514.83.4.828"},{"author":"Ju et al.","year":2016,"doi":null},{"author":"Bong","year":2008,"doi":null},{"author":"Yang et al.","year":2017,"doi":null}]}$$::jsonb),
  ('korea-001', 6, 'Practical scenarios', 'partial',
    $${"summary":"Korea scenarios train teachers to read pressure correctly. The challenge is the interaction between authority, fatigue, high-stakes pathways, and a wider academic management system.","sections":[{"heading":"Current scenario bank","items":["The sleeping student","The parent who contacts at 10pm","The silent class","The grade appeal","The Suneung preparation withdrawal"]}]}$$::jsonb)
on conflict (module_id, dimension_number) do update set
  title = excluded.title, research_status = excluded.research_status, content = excluded.content;

-- ─── Seed: Scenarios ───

insert into public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, dimension_tags, source_type, status) values
  -- Saudi Arabia
  ('ksa-001', 'The cancelled graduation',
    'A KG graduation is cancelled because fathers cannot observe the female section.',
    'Local administrative failure or disorganisation.',
    'Systemic MOE segregation mandate. This is structural, not local.',
    '["Understand the constraint is MOE-level before the parent call","Prepare a written explanation citing the regulation, not the school''s preference","Offer an alternative celebration format within the rules","Recognise your leader is navigating more than they can show"]'::jsonb,
    '{3}'::integer[], 'academic', 'draft'),
  ('ksa-001', 'The parent who reads the textbook',
    'A Muslim parent contacts a teacher about content in a history or biology unit they consider haram.',
    'Overreach; defend academic freedom.',
    'Justice-moderation tension. Academic freedom has no legal standing in KSA and the issue must be handled inside institutional constraints.',
    '["Know the MOE curriculum constraints before any parent meeting","Do not frame this as academic freedom vs religion","Escalate to leadership immediately - this is institutional, not pedagogical","Document the concern in writing"]'::jsonb,
    '{3,4}'::integer[], 'academic', 'draft'),
  ('ksa-001', 'The Saudization team dynamic',
    'A Saudization-mandated teacher is routinely absent. The expatriate team carries the load.',
    'Personnel problem to be managed.',
    'Structural MOE requirement. Raising it with leadership puts the leader in a difficult position because the issue is compliance-bound, not merely managerial.',
    '["Understand this is a compliance cost, not a management failure","Do not raise it in team settings - speak to your leader privately","Frame any concerns around student impact, not colleague behaviour","Recognise your leader has limited options within the regulatory framework"]'::jsonb,
    '{3,4}'::integer[], 'academic', 'draft'),

  -- China
  ('china-001', 'The unsatisfied parent',
    'A Chinese parent attends a progress meeting. The teacher gives what they consider an excellent report, but the parent leaves dissatisfied and asks for more exercises.',
    'The parent is impossible to please or does not value encouragement.',
    'Parallel tracks dynamic. The teacher is offering reassurance while the parent is listening for weaknesses that need correction.',
    '["Open with one concrete improvement target before strengths","Translate praise into next-step language","Offer one focused exercise or resource for home support","Explain how the child is progressing using both targets and strengths"]'::jsonb,
    '{2,6}'::integer[], 'academic', 'draft'),
  ('china-001', 'The copying suspicion',
    'A teacher suspects a student has memorized and reproduced a model essay rather than writing independently.',
    'The student is cheating or lacks original thought.',
    'Virtue-orientation learning model. Memorization can be phase one of learning rather than evidence of dishonesty.',
    '["Check whether the student can adapt the model in a new context","Use transfer tasks before labelling the work as cheating","Teach explicitly when imitation becomes independent application","Give feedback on application quality, not only originality"]'::jsonb,
    '{1,5,6}'::integer[], 'academic', 'draft'),
  ('china-001', 'The extra homework request',
    'A Chinese parent asks the teacher to send home additional exercises targeting a specific weakness.',
    'The parent is helicoptering or creating unhealthy pressure.',
    'Virtue-orientation support model. The parent is often trying to show care by identifying and correcting weakness.',
    '["Treat the request as support, not hostility","Send a bounded set of targeted materials","Explain how the exercises connect to class goals","Clarify the difference between extra practice and punishment"]'::jsonb,
    '{2,6}'::integer[], 'academic', 'draft'),
  ('china-001', 'The 80% grade confusion',
    'A student scores 80% and the teacher assigns an A. The parents contact the teacher asking what went wrong.',
    'The parents are unreasonable or fixated on perfection.',
    'Assessment system mismatch. Parents may be reading the percentage directly rather than through the grading architecture of the school.',
    '["Explain the grade band before discussing the individual mark","Show the rubric or grading scale visually","Separate percentage from letter-grade meaning","Offer one concrete area for growth so the meeting still feels diagnostic"]'::jsonb,
    '{2,6}'::integer[], 'academic', 'draft'),
  ('china-001', 'The silent achiever',
    'A high-performing Chinese student rarely speaks in discussion. The teacher marks them down for participation and the parents are confused.',
    'Silence means disengagement or weak understanding.',
    'Speaking-thinking conflict. Quietness can coexist with strong cognitive processing, especially when public speech feels less necessary for thinking.',
    '["Offer written and pair-based participation routes","Tell students explicitly when verbal contribution is being assessed","Use think-pair-share before whole-class discussion","Differentiate cognitive engagement from public speaking frequency"]'::jsonb,
    '{1,5,6}'::integer[], 'academic', 'draft'),

  -- South Korea (from KOREA_MODULE_CONTENT.md)
  ('korea-001', 'The sleeping student',
    'A student in an early-morning class is visibly fighting sleep, misses a prompt, and puts their head down during independent work. Their written work from the previous week was strong, and they are fully awake again in an afternoon lesson.',
    'The student is rude, bored, or disengaged from your subject.',
    'Hagwon fatigue is often the better first explanation. In Korea, visible tiredness can coexist with high effort and serious academic commitment, especially when late-night study is normal.',
    '["Check timing before judgment and compare behavior across different periods of the day","Speak to the student privately before using a public disciplinary response","Ask about workload and outside study schedule in neutral language","Adjust the immediate support plan without assuming the student lacks motivation"]'::jsonb,
    '{4,5}'::integer[], 'academic', 'draft'),
  ('korea-001', 'The parent who contacts at 10pm',
    'A parent sends a detailed evening message asking about their child''s latest mark, homework load, and what should be improved before the next assessment. The tone is urgent but not hostile.',
    'The parent is intrusive and does not respect professional boundaries.',
    'In Korea, after-hours contact can reflect normal academic monitoring rather than deliberate boundary violation. The parent is often trying to reduce uncertainty inside a high-pressure pathway system.',
    '["Reply within school policy rather than making it a personal boundary dispute","Give one clear academic answer and one clear next step","State the communication channel and response window you will use going forward","Share the same policy with all parents so the boundary is framed as school practice"]'::jsonb,
    '{2,4}'::integer[], 'academic', 'draft'),
  ('korea-001', 'The silent class',
    'You ask an open question, wait, and get no hands, no objections, and almost no eye contact. Written exit tickets later show that many students understood the material and had opinions they never voiced out loud.',
    'The class is unprepared, passive, or uninterested in discussion.',
    'Authority orientation, face-management, and English performance anxiety can all suppress live verbal participation even when thinking is active. In this setting, silence is often a communication mode, not proof of disengagement.',
    '["Give explicit permission to disagree, speculate, or offer a partial answer","Use anonymous digital polling or written responses before whole-class discussion","Build pair talk before public talk so students can rehearse the idea safely","Assess understanding through more than spontaneous public speaking"]'::jsonb,
    '{1,5}'::integer[], 'academic', 'draft'),
  ('korea-001', 'The grade appeal',
    'A student receives a lower grade than expected on an essay or project, and a parent requests a meeting with marked work, external tutoring feedback, and questions about why the grade was not higher.',
    'The family wants special treatment or is refusing to accept academic standards.',
    'Grade pressure is structural in Korea, and parents often approach marks as pathway signals rather than just feedback. The appeal is frequently an attempt to reduce risk and uncertainty, not simply overturn a decision.',
    '["Walk through the rubric line by line instead of defending the mark in general terms","Separate the student''s strengths from the exact criteria that limited the grade","Show what improvement would need to look like on the next task","Keep the discussion on standards and evidence, not on whether the family is being reasonable"]'::jsonb,
    '{2,4}'::integer[], 'academic', 'draft'),
  ('korea-001', 'The Suneung preparation withdrawal',
    'In the final term, Year 12 students are physically present but mentally elsewhere, and parent messages increasingly focus on past papers, ranking, and exam relevance. Even students not directly sitting CSAT seem affected by the surrounding mood.',
    'Students have checked out and parents are overreacting for no reason.',
    'CSAT saturation changes the whole educational environment in Korea. International schools are not outside that culture, even when their formal qualification pathway is different.',
    '["Name the pressure explicitly instead of pretending the wider exam culture is irrelevant","Explain how your qualification pathway connects to university outcomes in concrete terms","Clarify what is and is not being assessed in your course during this period","Keep communication calm, specific, and future-oriented so uncertainty does not fill the gap"]'::jsonb,
    '{3,4}'::integer[], 'academic', 'draft')
on conflict (module_id, title) do update set
  setup = excluded.setup, common_misread = excluded.common_misread,
  actual_dynamic = excluded.actual_dynamic, response_framework = excluded.response_framework,
  dimension_tags = excluded.dimension_tags, source_type = excluded.source_type, status = excluded.status;

commit;

-- After running this migration, set scenarios live:
-- UPDATE public.pd_scenarios SET status = 'live';
-- India module seed
-- Source: india-module-live-seed.json (Codex content package)
-- Run AFTER 20260330_create_pd_layer.sql

-- ── Module ────────────────────────────────────────────────────────────────────

INSERT INTO public.pd_modules (
  id, country_code, title, tagline,
  research_backbone, hofstede_data,
  completion_threshold, unlock_reward, status
) VALUES (
  'india-001', 'IN', 'India',
  'How aspiration, visible rigor, English, and parent networks shape everyday school-home friction.',
  '[
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "title": "School preferences of middle-class Indians", "doi": "10.1007/s44217-025-00617-0"},
    {"author": "Boruah, Phogat, and Singh", "year": 2024, "title": "A qualitative exploration of parent-teacher meetings in Indian schools", "doi": "10.1080/03004279.2024.2424260"},
    {"author": "Babu and Mahajan", "year": 2021, "title": "Branding an Inter-national school: Fusing Indian values with a global diploma", "doi": "10.1080/09620214.2020.1853589"},
    {"author": "Gilla, Narwana, and Gupta", "year": 2025, "title": "Investigating the determinants of private school choice", "doi": "10.1080/03057925.2024.2393129"},
    {"author": "Gurney", "year": 2017, "title": "Choosing schools, choosing selves", "doi": "10.1080/09620214.2017.1279560"},
    {"author": "Kumar, Pandita, and Singh", "year": 2024, "title": "To be on the seventh sky: shadow education in India", "doi": "10.1080/03004279.2024.2412993"},
    {"author": "Pienyu, Margaret, and D''Souza", "year": 2024, "title": "Academic stress and parental pressure among adolescents in Karnataka", "doi": "10.4103/jehp.jehp_2094_23"},
    {"author": "Parikh et al.", "year": 2019, "title": "It is like a mind attack: stress and coping among urban school-going adolescents in India", "doi": "10.1186/s40359-019-0306-z"}
  ]',
  '{"PDI": 77, "IDV": 48, "MAS": 56, "UAI": 40, "LTO": 51, "IND": 26}',
  80, 'Salary data unlocked', 'live'
)
ON CONFLICT (id) DO UPDATE SET
  title              = EXCLUDED.title,
  tagline            = EXCLUDED.tagline,
  research_backbone  = EXCLUDED.research_backbone,
  hofstede_data      = EXCLUDED.hofstede_data,
  status             = EXCLUDED.status;

-- ── Dimensions ────────────────────────────────────────────────────────────────

INSERT INTO public.pd_dimensions (module_id, dimension_number, title, research_status, content)
VALUES

('india-001', 1, 'School Choice, English, and Trust Signals', 'fully_sourced', '{
  "summary": "In many Indian private and international-school contexts, school choice is not only about pedagogy. Families often read English-medium instruction, school reputation, discipline, teacher attention, and peer recommendations as trust signals for mobility, status, and future security.",
  "sections": [
    {
      "heading": "What parents may be optimizing for",
      "items": [
        "Parents are often making a high-stakes decision under conditions of uncertainty. Fees, school brand, board affiliation, English-medium instruction, and visible seriousness can all stand in for trust.",
        "Choice is social as well as academic. Parents may be choosing not only a curriculum, but also a peer group, a class identity, and a future biography for the child."
      ]
    },
    {
      "heading": "Why English matters so much",
      "items": [
        "English often carries more than linguistic value. It is linked to service-sector mobility, prestige, and the ability to move comfortably through elite or global spaces.",
        "A request for stronger English, clearer benchmarks, or a more formal academic signal is often about opportunity and legibility, not just preference."
      ]
    },
    {
      "heading": "What teachers can miss",
      "items": [
        "A parent who asks where the child stands may not be rejecting holistic learning. They may be testing whether the school''s claims can be translated into recognizable proof.",
        "If the school explains philosophy but never translates it into concrete evidence, parents may build a parallel system of tutoring, comparisons, or informal benchmarking."
      ]
    }
  ],
  "citations": [
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "doi": "10.1007/s44217-025-00617-0"},
    {"author": "Gilla, Narwana, and Gupta", "year": 2025, "doi": "10.1080/03057925.2024.2393129"},
    {"author": "Gurney", "year": 2017, "doi": "10.1080/09620214.2017.1279560"}
  ]
}'),

('india-001', 2, 'Visible Rigor, Marks, and Assessment Legibility', 'fully_sourced', '{
  "summary": "Many families in India do not separate good teaching from visible proof of rigor. Marks, tests, corrected notebooks, homework volume, and comparative clarity can function as signals that the school is serious enough to justify the investment.",
  "sections": [
    {
      "heading": "Why marks stay powerful",
      "items": [
        "Marks are easy to read, easy to compare, and widely recognized across school systems. Even families who like inquiry-based learning may still want familiar evidence that standards are high.",
        "In fee-paying contexts, narrative feedback without anchors can feel elegant but vague."
      ]
    },
    {
      "heading": "What holistic can sound like to parents",
      "items": [
        "If teachers talk only about growth, voice, reflection, or confidence, some parents may worry the school is softening accountability rather than broadening learning.",
        "Requests for rank, tests, or a more concrete academic snapshot often reflect a search for legibility, not a complete rejection of broader goals."
      ]
    },
    {
      "heading": "What usually helps",
      "items": [
        "Translate the school''s model into observable evidence: what the child can now do, what comes next, and how the school knows.",
        "It is possible to refuse private ranking while still offering concrete, consistent academic clarity."
      ]
    }
  ],
  "citations": [
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "doi": "10.1007/s44217-025-00617-0"},
    {"author": "Boruah, Phogat, and Singh", "year": 2024, "doi": "10.1080/03004279.2024.2424260"},
    {"author": "Babu and Mahajan", "year": 2021, "doi": "10.1080/09620214.2020.1853589"}
  ]
}'),

('india-001', 3, 'Parent-Teacher Communication and Follow-Through', 'fully_sourced', '{
  "summary": "Recent research on parent-teacher meetings in India suggests that relationship quality depends less on friendliness alone and more on receptivity, clarity, and visible follow-through. Parents often react strongly when reassurance in the moment is not matched by later action or consistent feedback.",
  "sections": [
    {
      "heading": "What parents often expect",
      "items": [
        "Parents often come to meetings expecting usable information: what the concern is, how serious it is, and what the school plans to do next.",
        "Vague comfort can feel respectful in the moment but evasive afterward, especially when report comments later introduce a concern that was never discussed directly."
      ]
    },
    {
      "heading": "Where breakdowns happen",
      "items": [
        "Teachers may soften the message to preserve the relationship. Parents may hear the same softening as a promise or as evidence that no issue exists.",
        "When teachers explain a philosophy without translating it into next steps, parents often fill the gap with private tutoring, repeated follow-up, or informal comparison."
      ]
    },
    {
      "heading": "A useful working principle",
      "items": [
        "Relationship preservation is not the same as clarity. The most durable conversations often combine warmth with specific evidence and a concrete plan.",
        "If you cannot do something, say so clearly. If you will do something, name exactly what and when."
      ]
    }
  ],
  "citations": [
    {"author": "Boruah, Phogat, and Singh", "year": 2024, "doi": "10.1080/03004279.2024.2424260"},
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "doi": "10.1007/s44217-025-00617-0"},
    {"author": "Gurney", "year": 2017, "doi": "10.1080/09620214.2017.1279560"}
  ]
}'),

('india-001', 4, 'Global Exposure and Appropriately Indian Schooling', 'fully_sourced', '{
  "summary": "International schools in India often market themselves as both globally oriented and rooted in Indian values. Research suggests that this fusion is powerful for families, but also unstable: what counts as Indian inside the school may be narrower, more classed, or more culturally selective than the marketing language implies.",
  "sections": [
    {
      "heading": "Why the fusion works",
      "items": [
        "Many families are not choosing between global and Indian. They want both: strong English, confidence, and global mobility, alongside cultural rootedness and moral fit.",
        "This is especially true in schools that sell prestige through international credentials while also promising recognizably Indian values."
      ]
    },
    {
      "heading": "Why this can become friction",
      "items": [
        "A school''s version of Indian values is never neutral. It may privilege some languages, traditions, classed behaviors, or religious-coded norms more than others while presenting them as universal.",
        "Parents who ask for clarity about heritage events, values language, or belonging may be asking how plural the school''s idea of India really is."
      ]
    },
    {
      "heading": "What helps",
      "items": [
        "Replace vague civilizational language with specific, plural invitations. Tell families what an event means in practice and what kinds of participation count.",
        "Treat cultural fit as something to clarify, not something families should simply infer."
      ]
    }
  ],
  "citations": [
    {"author": "Babu and Mahajan", "year": 2021, "doi": "10.1080/09620214.2020.1853589"},
    {"author": "Gurney", "year": 2017, "doi": "10.1080/09620214.2017.1279560"},
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "doi": "10.1007/s44217-025-00617-0"}
  ]
}'),

('india-001', 5, 'Pressure, Perfection, and Academic Risk-Taking', 'fully_sourced', '{
  "summary": "In many Indian school contexts, seriousness about academics is experienced as care. At the same time, newer research continues to show high levels of academic stress and parental pressure among students. Teachers in inquiry-oriented schools often meet this tension when students become highly polished but reluctant to think aloud, draft publicly, or risk being wrong.",
  "sections": [
    {
      "heading": "Why caution can be misread",
      "items": [
        "A student who waits to speak until an answer is polished may not be disengaged. They may be protecting competence in a context where mistakes carry social weight.",
        "Families may understand polish, discipline, and correctness as evidence of responsibility, not evidence of damage."
      ]
    },
    {
      "heading": "What the stress research adds",
      "items": [
        "Recent Indian studies continue to show that parental pressure, examination anxiety, and academic competition shape student well-being.",
        "This means teachers should not romanticize perfectionism, but they also should not frame every performance-oriented habit as parental failure."
      ]
    },
    {
      "heading": "What teachers can do",
      "items": [
        "Frame risk-taking as an additional academic skill, not as a lowering of standards.",
        "Use low-stakes rehearsal, thinking partners, and concrete prompts that make exploratory work feel structured rather than exposed."
      ]
    }
  ],
  "citations": [
    {"author": "Pienyu, Margaret, and D''Souza", "year": 2024, "doi": "10.4103/jehp.jehp_2094_23"},
    {"author": "Parikh et al.", "year": 2019, "doi": "10.1186/s40359-019-0306-z"},
    {"author": "Kumar, Pandita, and Singh", "year": 2024, "doi": "10.1080/03004279.2024.2412993"}
  ]
}'),

('india-001', 6, 'Parent Networks, WhatsApp, and School Navigation', 'fully_sourced', '{
  "summary": "In Indian school markets, families rarely navigate school life alone. Parent networks, relatives, neighborhood referrals, and WhatsApp groups often function as infrastructure for comparison, reassurance, and interpretation.",
  "sections": [
    {
      "heading": "What the network is doing",
      "items": [
        "Informal networks help parents compare schools, validate interpretations, and decide which concerns are worth escalating.",
        "This is especially powerful in fee-paying school markets where parents feel pressure to make a good choice and avoid hidden mistakes."
      ]
    },
    {
      "heading": "What teachers tend to feel",
      "items": [
        "From the teacher side, these same networks can feel like a parallel system that amplifies anxiety, speeds escalation, and creates after-hours interpretation work.",
        "A request for a small WhatsApp group may therefore be about clarity and reassurance, not only access."
      ]
    },
    {
      "heading": "What schools can do",
      "items": [
        "If families will compare notes anyway, give them a healthier official structure: predictable FAQ rhythms, visible clarifications, and clear boundaries.",
        "The goal is not to eliminate the grapevine. It is to keep the official channel more reliable than the rumor chain."
      ]
    }
  ],
  "citations": [
    {"author": "Ullah, Mukherjee, and Middendorf", "year": 2025, "doi": "10.1007/s44217-025-00617-0"},
    {"author": "Gurney", "year": 2017, "doi": "10.1080/09620214.2017.1279560"},
    {"author": "Boruah, Phogat, and Singh", "year": 2024, "doi": "10.1080/03004279.2024.2424260"}
  ]
}')

ON CONFLICT (module_id, dimension_number) DO UPDATE SET
  title             = EXCLUDED.title,
  research_status   = EXCLUDED.research_status,
  content           = EXCLUDED.content;

-- ── Scenarios ─────────────────────────────────────────────────────────────────

INSERT INTO public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, source_type, dimension_tags, status)
VALUES

('india-001',
 'The Scorecard',
 'After a polished student exhibition, a parent asks how she is supposed to know where her daughter actually stands if the school avoids frequent marks, rank, and comparison sheets. The child is doing well, but the parent''s real concern is whether the school''s version of rigor is legible enough to trust.',
 'This parent only cares about marks and is rejecting holistic learning.',
 'The parent may be asking for trust signals, not only marks. In many Indian private and international-school contexts, families read visible rigor as proof that the fee-paying investment is academically serious. If the school refuses ranking but also refuses concrete translation, parents often build their own parallel benchmark system.',
 '["Name the evidence the school does use: samples, rubrics, writing, discussion, transfer, and next-step patterns.", "Translate philosophy into concrete language: what the child can now do, what remains insecure, and how you know.", "Be explicit about the boundary: no private rank or unofficial comparison, but yes to clear academic information.", "Offer a predictable follow-up so the parent does not need to chase clarity through private messages."]',
 'academic', ARRAY[1,2], 'live'),

('india-001',
 'The Rough Draft',
 'At conference time, you want to raise a concern about a high-performing student who refuses to share rough thinking, waits until an answer feels safe, and treats every task as something to perfect before showing. The family is deeply invested in the child''s education and praises discipline and correctness at home.',
 'The family is overpressuring the child, and the main job is to tell them to relax.',
 'Seriousness, polish, and caution often function as signs of care in Indian schooling contexts. That does not mean the pattern is harmless, but if the teacher frames the issue only as family pressure, the parent may hear accusation rather than partnership. The more productive move is to frame risk-taking as another academic skill the school explicitly teaches.',
 '["Lead with strengths the family already values: discipline, commitment, and academic seriousness.", "Describe the concern behaviorally, not morally: reluctance to test ideas aloud, not lack of creativity.", "Explain why your classroom treats drafting, trial, and partial answers as part of learning rather than signs of weakness.", "Agree on one low-stakes support at school and one at home so the child is not simply told to be more confident."]',
 'academic', ARRAY[3,5], 'live'),

('india-001',
 'The WhatsApp Chain',
 'A few parents ask whether you will join a small WhatsApp group for quick clarifications about assessment terms, costume details, competition deadlines, and school jargon. The school app exists, but families are already comparing notes elsewhere.',
 'These parents want special access and are building a pressure group.',
 'Informal parent networks in India often function as school-navigation infrastructure. The request may be less about influence than about uncertainty reduction, validation, and speed. The real challenge is not whether parents will talk. It is whether the official school channel is clear and reliable enough to keep rumor from becoming the main interpreter.',
 '["Decide first what you can realistically sustain: no channel, a time-boxed whole-class channel, or a visible FAQ rhythm.", "If you decline a small group, offer a clear alternative rather than only saying no.", "Keep key clarifications public whenever possible so one family''s answer does not become everyone else''s rumor.", "Separate urgent student-specific issues from general class logistics to protect both equity and your time."]',
 'academic', ARRAY[3,6], 'live'),

('india-001',
 'The Heritage Day Note',
 'Your school sends a cheerful message about Indian Values Week and asks students to bring an item or reflection that represents Indian culture. A parent replies politely: what exactly counts as Indian here, and will the school make room for regional, linguistic, and family differences rather than one polished version of tradition?',
 'The parent is overcomplicating a simple cultural event.',
 'In Indian international-school contexts, language like Indian values can sound inclusive while still centering a selective version of Indianness. A parent asking for clarity may not be resisting culture. They may be testing whether the school''s version of belonging is genuinely plural or simply assumed.',
 '["Replace vague values language with concrete prompts and examples that allow multiple regional, linguistic, and family traditions.", "Check whether the school is presenting one social group''s norms as if they are universally Indian.", "Explain the educational purpose of the activity in plain language rather than relying on branding language.", "Invite questions early so families do not have to infer what kind of Indianness the school rewards."]',
 'academic', ARRAY[4,6], 'live')

ON CONFLICT (module_id, title) DO UPDATE SET
  setup             = EXCLUDED.setup,
  common_misread    = EXCLUDED.common_misread,
  actual_dynamic    = EXCLUDED.actual_dynamic,
  response_framework = EXCLUDED.response_framework,
  status            = EXCLUDED.status;
