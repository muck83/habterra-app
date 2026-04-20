-- ============================================================
-- preamble_seed.sql
-- Adds preamble_md column to pd_modules and populates it for
-- all five current modules: India, KSA, Korea, China, Woodstock.
--
-- The preamble renders before D1 in ModuleView.jsx.
-- It frames the inquiry-assessment gap (or curriculum transition
-- for Woodstock) before the dimension content begins.
--
-- Safe to re-run: ALTER uses IF NOT EXISTS, UPDATEs are idempotent.
-- ============================================================

BEGIN;

-- ── 1. Schema migration ───────────────────────────────────────

ALTER TABLE public.pd_modules
  ADD COLUMN IF NOT EXISTS preamble_md text;

-- ── 2. India ─────────────────────────────────────────────────

UPDATE public.pd_modules
SET preamble_md = $$The parents in your classroom arrived at international school through a system built on visible, comparative measurement. Under CBSE — India's national curriculum — a score below 65% signals underperformance. A score above 90% is the threshold for prestige college admission. Marks were not feedback; they were social currency. A high percentage told extended family, caste community, and future employers that this child — and by extension this family — was successful.

IB does not give marks in that sense. It gives portfolios, criterion references, and holistic grade descriptors. For many parents this feels like the school is withholding the information they need to know whether their investment is working.

This module is about the gap between those two systems. You did not create it and the parents in your classroom are not irrational for feeling it. But closing it — or at least bridging it enough for a productive relationship — starts with understanding where the other person is standing. That is what the six dimensions ahead are for.$$
WHERE id = 'india-001';

-- ── 3. KSA ───────────────────────────────────────────────────

UPDATE public.pd_modules
SET preamble_md = $$The families choosing international schools in Saudi Arabia are making a calculated bet. They have selected a curriculum that operates differently from the tawjihiyya — the national leaving examination — and the government schools shaped around it. That choice comes with an ambivalence they may not name directly: they want the global credentials, the English-language access, the university pathways. They are also watching their children spend their days in an environment that does not always reflect the religious, cultural, and linguistic values the family considers non-negotiable.

This is not contradiction. It is the defining feature of the parent you will meet at parents' evening. They chose you. They are also watching you carefully to see what you are doing to their child's identity.

The six dimensions in this module are not a guide to "Saudi culture." They are a guide to the specific dynamics that arise when a family invests in international education from inside a high-context, religious authority structure that is simultaneously being reshaped by Vision 2030. Understanding those dynamics will make you a better teacher and a less frequent cause of formal complaints.$$
WHERE id = 'ksa-001';

-- ── 4. Korea ─────────────────────────────────────────────────

UPDATE public.pd_modules
SET preamble_md = $$Korean parents chose international school with full awareness of what they were opting out of. The Suneung — Korea's university entrance examination — structures an entire society's idea of what a child's future is worth. In a country where most parents have one or two children, every educational decision is an all-in investment. Parents did not send their child to you as a relaxation of that pressure. They sent their child to you as a different strategy for managing it.

The 2023 teacher rights crisis produced the most detailed public dataset yet on what happens when the parent-teacher relationship breaks down in Korea: more than 1,200 accusations against teachers under child welfare legislation, a measurable collapse in teacher willingness to give critical feedback, and a generation of students whose teachers have learned to avoid the interactions that most need to happen.

This module is not about Korean culture as an abstraction. It is about the structural forces — the exam, the legal architecture, the Confucian authority contract under renegotiation — that are operating in the room every time you speak with a Korean parent or student.$$
WHERE id = 'korea-001';

-- ── 5. China ─────────────────────────────────────────────────

UPDATE public.pd_modules
SET preamble_md = $$The families choosing international school in China are not stepping away from the gaokao logic — they are running a parallel investment. The national university entrance examination remains, in the words of the research, "the most important indicator of school quality" and "decides the honor or shame of a family." IB is a bet on a different pathway, not an exit from competitive pressure.

What this means in practice: the parent who chose your school, pays the fees, and thanks you warmly at parents' evening is simultaneously operating inside a framework where marks are the only legible proof that a child is on track. Portfolio assessment, criterion-referenced grading, and process-focused feedback do not fit that framework — not because the parent is unsophisticated, but because they are reading your curriculum through a measurement system you did not build and cannot replace with a single conversation.

The six dimensions ahead give you the structural vocabulary for these moments. Each one names a specific dynamic — assessment friction, face-saving in meetings, the extracurricular calculation — that teachers in Chinese international schools encounter every week without a framework for interpreting it.$$
WHERE id = 'china-001';

-- ── 6. Woodstock ─────────────────────────────────────────────

UPDATE public.pd_modules
SET preamble_md = $$This module is for parents navigating one of the most significant transitions in a child's school career: moving from the International Baccalaureate to the IGCSE, A-Level, AP, and Woodstock School Diploma framework. That transition changes how your child's work is assessed, how progress is reported, and what success looks like at each stage of their secondary education.

The shift is not a downgrade. Each of the qualification pathways in Woodstock's model has its own rigour, its own relationship with university admissions, and its own strengths for different types of learners. But it does require parents to update the mental model they have been using. A grade that looks lower under IGCSE is not a sign that something has gone wrong. A grade that looks higher may be rewarding different things than the IB was rewarding.

This module walks through the six dimensions of that transition: the qualification structure, what each pathway is designed to produce, how assessment works in each, what university admissions offices actually look for, and how to talk with your child about the change in a way that supports rather than undermines their confidence.$$
WHERE id = 'woodstock-001';

COMMIT;

-- ── Verification ─────────────────────────────────────────────

SELECT id, title,
  left(preamble_md, 80) AS preamble_preview,
  length(preamble_md)   AS char_count
FROM public.pd_modules
WHERE id IN ('india-001', 'ksa-001', 'korea-001', 'china-001', 'woodstock-001')
ORDER BY id;

-- Expected: 5 rows, all with char_count > 0
