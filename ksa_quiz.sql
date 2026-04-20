-- ============================================================
-- ksa_quiz.sql
-- Adds full checkpoint + final quiz coverage for ksa-001.
-- Safe to re-run.
-- ============================================================

BEGIN;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, sort_order, prompt, options, dimension_number)
VALUES
  (
    'ksa-d1-q1',
    'ksa-001',
    'checkpoint',
    1,
    $$A parent asks whether a "student voice" activity teaches children to challenge adults. What is the strongest first interpretation?$$,
    $$[
      {"id":"ksa-d1-q1-a","text":"The parent is rejecting inquiry and prefers unquestioned obedience.","isCorrect":false,"feedback":"Too reductive. The question may be about how participation fits local expectations around respect and authority.","explanation":"Too reductive. The question may be about how participation fits local expectations around respect and authority."},
      {"id":"ksa-d1-q1-b","text":"The parent may be testing how an international-school routine fits local moral and relational expectations.","isCorrect":true,"feedback":"Yes. The useful move is to translate the practice concretely, not treat the concern as anti-modern.","explanation":"Yes. The useful move is to translate the practice concretely, not treat the concern as anti-modern."},
      {"id":"ksa-d1-q1-c","text":"The parent mostly needs the English terminology simplified.","isCorrect":false,"feedback":"Language clarity helps, but the deeper issue is cultural interpretation, not vocabulary alone.","explanation":"Language clarity helps, but the deeper issue is cultural interpretation, not vocabulary alone."},
      {"id":"ksa-d1-q1-d","text":"The parent is asking for a traditional lecture model in every subject.","isCorrect":false,"feedback":"The concern is narrower and more relational than a blanket request for lecture-based schooling.","explanation":"The concern is narrower and more relational than a blanket request for lecture-based schooling."}
    ]$$::jsonb,
    1
  ),
  (
    'ksa-d2-q1',
    'ksa-001',
    'checkpoint',
    2,
    $$Why can routine parent questions in a Saudi international school carry more weight than they first appear to?$$,
    $$[
      {"id":"ksa-d2-q1-a","text":"Families are usually asking for faster updates and tighter logistics.","isCorrect":false,"feedback":"Updates may matter, but this reduces interpretive work to administration.","explanation":"Updates may matter, but this reduces interpretive work to administration."},
      {"id":"ksa-d2-q1-b","text":"Communication often has to explain what the school means culturally, not only what it is doing operationally.","isCorrect":true,"feedback":"Correct. Small questions can carry large anxieties about identity, legitimacy, and fit.","explanation":"Correct. Small questions can carry large anxieties about identity, legitimacy, and fit."},
      {"id":"ksa-d2-q1-c","text":"The main problem is usually choosing the wrong app or communication channel.","isCorrect":false,"feedback":"The medium matters less than the meaning families are trying to read through it.","explanation":"The medium matters less than the meaning families are trying to read through it."},
      {"id":"ksa-d2-q1-d","text":"Parents are mostly trying to compare the school with overseas competitors.","isCorrect":false,"feedback":"School comparison exists, but the module foregrounds cultural fit and institutional dissonance.","explanation":"School comparison exists, but the module foregrounds cultural fit and institutional dissonance."}
    ]$$::jsonb,
    2
  ),
  (
    'ksa-d3-q1',
    'ksa-001',
    'checkpoint',
    3,
    $$Why can an English-first school routine become more than a language policy in this context?$$,
    $$[
      {"id":"ksa-d3-q1-a","text":"Students often overreact emotionally to otherwise neutral language routines.","isCorrect":false,"feedback":"This blames students and misses the social meaning of language hierarchy.","explanation":"This blames students and misses the social meaning of language hierarchy."},
      {"id":"ksa-d3-q1-b","text":"It can quietly attach prestige, intelligence, or institutional belonging to English over Arabic.","isCorrect":true,"feedback":"Yes. English can be valuable while still producing a hidden hierarchy if not handled carefully.","explanation":"Yes. English can be valuable while still producing a hidden hierarchy if not handled carefully."},
      {"id":"ksa-d3-q1-c","text":"Families in this context usually oppose strong English instruction on principle.","isCorrect":false,"feedback":"Too broad. Many families value English while still caring deeply about Arabic and identity.","explanation":"Too broad. Many families value English while still caring deeply about Arabic and identity."},
      {"id":"ksa-d3-q1-d","text":"English-first policies mainly affect admissions marketing, not classroom belonging.","isCorrect":false,"feedback":"The classroom experience is exactly where language status becomes visible to students.","explanation":"The classroom experience is exactly where language status becomes visible to students."}
    ]$$::jsonb,
    3
  ),
  (
    'ksa-d4-q1',
    'ksa-001',
    'checkpoint',
    4,
    $$A leader quietly adjusts an activity so it can continue inside local constraints. What is the best ethical reading?$$,
    $$[
      {"id":"ksa-d4-q1-a","text":"The leader is avoiding a principled stand and should be more confrontational.","isCorrect":false,"feedback":"This assumes open confrontation is always the ethical route. The module frames moderation as a real ethical orientation in constrained settings.","explanation":"This assumes open confrontation is always the ethical route. The module frames moderation as a real ethical orientation in constrained settings."},
      {"id":"ksa-d4-q1-b","text":"The leader may be balancing humane, justice, responsibility, and moderation concerns with no perfectly clean option.","isCorrect":true,"feedback":"Correct. The ethical tension is structural, not simply a matter of courage or weakness.","explanation":"Correct. The ethical tension is structural, not simply a matter of courage or weakness."},
      {"id":"ksa-d4-q1-c","text":"The leader is proving that international-school values do not matter locally.","isCorrect":false,"feedback":"The adjustment may be an attempt to preserve as much learning as possible under constraint.","explanation":"The adjustment may be an attempt to preserve as much learning as possible under constraint."},
      {"id":"ksa-d4-q1-d","text":"The leader should always prioritize parent satisfaction over institutional policy.","isCorrect":false,"feedback":"The module asks for principled navigation, not automatic parent appeasement.","explanation":"The module asks for principled navigation, not automatic parent appeasement."}
    ]$$::jsonb,
    4
  ),
  (
    'ksa-d5-q1',
    'ksa-001',
    'checkpoint',
    5,
    $$A student gives polished answers privately but avoids public disagreement or open-ended challenge. What is the strongest first interpretation?$$,
    $$[
      {"id":"ksa-d5-q1-a","text":"The student lacks independent thinking and needs to be pushed harder.","isCorrect":false,"feedback":"Too quick. Avoiding public challenge can reflect learned respect, face-management, or classroom expectations.","explanation":"Too quick. Avoiding public challenge can reflect learned respect, face-management, or classroom expectations."},
      {"id":"ksa-d5-q1-b","text":"The family is probably suppressing the student's voice at home.","isCorrect":false,"feedback":"That overdiagnoses the family from one classroom behavior.","explanation":"That overdiagnoses the family from one classroom behavior."},
      {"id":"ksa-d5-q1-c","text":"The student may be navigating authority and respect norms while still thinking seriously.","isCorrect":true,"feedback":"Yes. Teach the participation norm explicitly instead of treating restraint as low ability.","explanation":"Yes. Teach the participation norm explicitly instead of treating restraint as low ability."},
      {"id":"ksa-d5-q1-d","text":"The student is signaling that inquiry tasks are too easy.","isCorrect":false,"feedback":"There is not enough evidence for that. The cultural reading is stronger.","explanation":"There is not enough evidence for that. The cultural reading is stronger."}
    ]$$::jsonb,
    5
  ),
  (
    'ksa-d6-q1',
    'ksa-001',
    'checkpoint',
    6,
    $$In the Saudi scenario bank, what is the main diagnostic habit teachers should practice?$$,
    $$[
      {"id":"ksa-d6-q1-a","text":"Find the individual person who is being unreasonable and de-escalate them.","isCorrect":false,"feedback":"That misses the pattern. Many scenarios are structural before they are personal.","explanation":"That misses the pattern. Many scenarios are structural before they are personal."},
      {"id":"ksa-d6-q1-b","text":"Separate structural constraint, parent concern, and classroom choice before responding.","isCorrect":true,"feedback":"Correct. This prevents teachers from misreading policy pressure as personality conflict.","explanation":"Correct. This prevents teachers from misreading policy pressure as personality conflict."},
      {"id":"ksa-d6-q1-c","text":"Treat every scenario as a compliance problem for senior leadership.","isCorrect":false,"feedback":"Some issues need escalation, but teachers still need interpretive skill at the first point of contact.","explanation":"Some issues need escalation, but teachers still need interpretive skill at the first point of contact."},
      {"id":"ksa-d6-q1-d","text":"Avoid naming culture so conversations stay neutral.","isCorrect":false,"feedback":"Neutrality can become vagueness. The goal is careful cultural interpretation, not avoidance.","explanation":"Neutrality can become vagueness. The goal is careful cultural interpretation, not avoidance."}
    ]$$::jsonb,
    6
  ),
  (
    'ksa-final-q1',
    'ksa-001',
    'final_exam',
    1,
    $$A parent asks whether a "student voice" activity teaches children to challenge adults more broadly. What is the best first move?$$,
    $$[
      {"id":"ksa-final-q1-a","text":"Defend the practice as internationally normal and move on.","isCorrect":false,"feedback":"That ignores the local interpretive concern and can sound dismissive.","explanation":"That ignores the local interpretive concern and can sound dismissive."},
      {"id":"ksa-final-q1-b","text":"Explain concretely what the activity asks students to do and what kind of respect it preserves.","isCorrect":true,"feedback":"Yes. Concrete translation is stronger than abstract reassurance.","explanation":"Yes. Concrete translation is stronger than abstract reassurance."},
      {"id":"ksa-final-q1-c","text":"Assure the parent that children will not be allowed to question adults at all.","isCorrect":false,"feedback":"This overcorrects and misrepresents the educational aim.","explanation":"This overcorrects and misrepresents the educational aim."},
      {"id":"ksa-final-q1-d","text":"Send the concern directly to leadership without discussing the activity.","isCorrect":false,"feedback":"Escalation may help later, but the teacher can first clarify the concrete practice.","explanation":"Escalation may help later, but the teacher can first clarify the concrete practice."}
    ]$$::jsonb,
    NULL
  ),
  (
    'ksa-final-q2',
    'ksa-001',
    'final_exam',
    2,
    $$A child begins treating English as the language of status. What is the strongest explanation?$$,
    $$[
      {"id":"ksa-final-q2-a","text":"The family must be discouraging Arabic at home.","isCorrect":false,"feedback":"This overlocates the cause in the family and misses the school's hidden curriculum.","explanation":"This overlocates the cause in the family and misses the school's hidden curriculum."},
      {"id":"ksa-final-q2-b","text":"The school environment may be teaching a hierarchy of linguistic belonging alongside English growth.","isCorrect":true,"feedback":"Correct. The response is to design for bilingual dignity, not reduce English ambition.","explanation":"Correct. The response is to design for bilingual dignity, not reduce English ambition."},
      {"id":"ksa-final-q2-c","text":"This is unavoidable in any international school.","isCorrect":false,"feedback":"Common is not inevitable. Design and messaging choices matter.","explanation":"Common is not inevitable. Design and messaging choices matter."},
      {"id":"ksa-final-q2-d","text":"The student is simply becoming more globally minded.","isCorrect":false,"feedback":"Global orientation and local-language devaluation are different outcomes.","explanation":"Global orientation and local-language devaluation are different outcomes."}
    ]$$::jsonb,
    NULL
  ),
  (
    'ksa-final-q3',
    'ksa-001',
    'final_exam',
    3,
    $$What does the Saudi school-choice research suggest about many families in this sector?$$,
    $$[
      {"id":"ksa-final-q3-a","text":"They are trying to combine opportunity, English, and pedagogy with cultural and moral fit.","isCorrect":true,"feedback":"Yes. The key is both/and, not a simple trade away from local continuity.","explanation":"Yes. The key is both/and, not a simple trade away from local continuity."},
      {"id":"ksa-final-q3-b","text":"They are trading away local continuity for future opportunity.","isCorrect":false,"feedback":"That is the wrong binary. Many families are trying to preserve both.","explanation":"That is the wrong binary. Many families are trying to preserve both."},
      {"id":"ksa-final-q3-c","text":"They mainly choose on prestige and facilities.","isCorrect":false,"feedback":"Prestige may matter, but it is not the full interpretive frame in this module.","explanation":"Prestige may matter, but it is not the full interpretive frame in this module."},
      {"id":"ksa-final-q3-d","text":"They usually want an overseas school culture with minimal local adaptation.","isCorrect":false,"feedback":"Too reductive. The module emphasizes dissonance and negotiation, not one-way replacement.","explanation":"Too reductive. The module emphasizes dissonance and negotiation, not one-way replacement."}
    ]$$::jsonb,
    NULL
  )
ON CONFLICT (id) DO UPDATE SET
  module_id = EXCLUDED.module_id,
  quiz_type = EXCLUDED.quiz_type,
  sort_order = EXCLUDED.sort_order,
  prompt = EXCLUDED.prompt,
  options = EXCLUDED.options,
  dimension_number = EXCLUDED.dimension_number;

COMMIT;

-- Verification
SELECT module_id, quiz_type, count(*) AS question_count
FROM public.pd_quiz_questions
WHERE module_id = 'ksa-001'
GROUP BY module_id, quiz_type
ORDER BY quiz_type;

SELECT count(*) AS total_questions
FROM public.pd_quiz_questions
WHERE module_id = 'ksa-001';
