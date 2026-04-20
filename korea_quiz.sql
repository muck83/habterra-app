-- ============================================================
-- korea_quiz.sql
-- Adds full checkpoint + final quiz coverage for korea-001.
-- Safe to re-run.
-- ============================================================

BEGIN;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, sort_order, prompt, options, dimension_number)
VALUES
  (
    'korea-d1-q1',
    'korea-001',
    'checkpoint',
    1,
    $$A parent expects the homeroom teacher to understand the child's wider learning situation, not just classroom performance. What is the best explanation?$$,
    $$[
      {"id":"korea-d1-q1-a","text":"Korean parents are unusually dependent on school adults.","isCorrect":false,"feedback":"Too crude. The stronger reading is institutional and relational, not a parent deficit.","explanation":"Too crude. The stronger reading is institutional and relational, not a parent deficit."},
      {"id":"korea-d1-q1-b","text":"The homeroom role has historically carried affective care and guidance, not just instruction.","isCorrect":true,"feedback":"Correct. This explains why families may imagine the teacher as a central adult in the child's development.","explanation":"Correct. This explains why families may imagine the teacher as a central adult in the child's development."},
      {"id":"korea-d1-q1-c","text":"The parent wants the teacher to manage the student's academy schedule too.","isCorrect":false,"feedback":"Coordination pressure can exist, but it is not the main explanation of the homeroom expectation.","explanation":"Coordination pressure can exist, but it is not the main explanation of the homeroom expectation."},
      {"id":"korea-d1-q1-d","text":"The parent is trying to make the school replace family responsibility.","isCorrect":false,"feedback":"This misreads a relational expectation as avoidance of responsibility.","explanation":"This misreads a relational expectation as avoidance of responsibility."}
    ]$$::jsonb,
    1
  ),
  (
    'korea-d2-q1',
    'korea-001',
    'checkpoint',
    2,
    $$A parent coalition pushes back when a test week is replaced by a project week. What is the most research-backed first interpretation?$$,
    $$[
      {"id":"korea-d2-q1-a","text":"They are mainly uncomfortable with innovation and need modern pedagogy explained.","isCorrect":false,"feedback":"This is plausible but reductive. The deeper issue may be competitive legibility.","explanation":"This is plausible but reductive. The deeper issue may be competitive legibility."},
      {"id":"korea-d2-q1-b","text":"They may be defending predictable signals of fairness inside a high-stakes system.","isCorrect":true,"feedback":"Yes. The useful first move is to understand what signal the test week was carrying.","explanation":"Yes. The useful first move is to understand what signal the test week was carrying."},
      {"id":"korea-d2-q1-c","text":"They are mostly echoing academy culture rather than expressing a school concern.","isCorrect":false,"feedback":"Shadow education matters, but this answer dismisses the school-based anxiety too quickly.","explanation":"Shadow education matters, but this answer dismisses the school-based anxiety too quickly."},
      {"id":"korea-d2-q1-d","text":"They want teachers to remove all open-ended tasks from the curriculum.","isCorrect":false,"feedback":"The pushback may be about timing, fairness, and evidence, not a total rejection of projects.","explanation":"The pushback may be about timing, fairness, and evidence, not a total rejection of projects."}
    ]$$::jsonb,
    2
  ),
  (
    'korea-d3-q1',
    'korea-001',
    'checkpoint',
    3,
    $$A student consistently waits until she is sure an answer is correct before speaking. What is the strongest interpretation?$$,
    $$[
      {"id":"korea-d3-q1-a","text":"She mainly lacks confidence and needs stronger encouragement.","isCorrect":false,"feedback":"Incomplete. Confidence may matter, but accuracy can also carry social and academic weight.","explanation":"Incomplete. Confidence may matter, but accuracy can also carry social and academic weight."},
      {"id":"korea-d3-q1-b","text":"She may be protecting competence in a setting where public accuracy matters.","isCorrect":true,"feedback":"Correct. This lets the teacher teach risk-taking as an academic skill, not a personality repair.","explanation":"Correct. This lets the teacher teach risk-taking as an academic skill, not a personality repair."},
      {"id":"korea-d3-q1-c","text":"Her family is probably overvaluing marks and causing the pattern.","isCorrect":false,"feedback":"Too binary. The behavior can reflect a wider learning culture, not one family cause.","explanation":"Too binary. The behavior can reflect a wider learning culture, not one family cause."},
      {"id":"korea-d3-q1-d","text":"She is disengaged because she does not volunteer ideas quickly.","isCorrect":false,"feedback":"Silence and engagement are not opposites in this module's interpretive frame.","explanation":"Silence and engagement are not opposites in this module's interpretive frame."}
    ]$$::jsonb,
    3
  ),
  (
    'korea-d4-q1',
    'korea-001',
    'checkpoint',
    4,
    $$A student sleeping in class is also attending late-night academies. What is the strongest ethical first response?$$,
    $$[
      {"id":"korea-d4-q1-a","text":"Treat it primarily as disrespect so expectations stay clear.","isCorrect":false,"feedback":"Expectations matter, but starting with disrespect misses the humane reading of fatigue.","explanation":"Expectations matter, but starting with disrespect misses the humane reading of fatigue."},
      {"id":"korea-d4-q1-b","text":"Assume the family is harming the student and confront the parent.","isCorrect":false,"feedback":"That is too escalated and overpersonalizes a structural pressure pattern.","explanation":"That is too escalated and overpersonalizes a structural pressure pattern."},
      {"id":"korea-d4-q1-c","text":"Read the condition before the behavior, then set sustainable academic expectations.","isCorrect":true,"feedback":"Yes. The ethical tension includes humane care, fairness, and responsibility at once.","explanation":"Yes. The ethical tension includes humane care, fairness, and responsibility at once."},
      {"id":"korea-d4-q1-d","text":"Ignore the sleeping because academy workload is outside the school's control.","isCorrect":false,"feedback":"The school cannot control everything, but it still has a duty to interpret and respond well.","explanation":"The school cannot control everything, but it still has a duty to interpret and respond well."}
    ]$$::jsonb,
    4
  ),
  (
    'korea-d5-q1',
    'korea-001',
    'checkpoint',
    5,
    $$Why can help-seeking avoidance be hard for teachers to see in Korean international-school classrooms?$$,
    $$[
      {"id":"korea-d5-q1-a","text":"Students who do not ask questions usually understand the lesson.","isCorrect":false,"feedback":"That is exactly the risky assumption the module warns against.","explanation":"That is exactly the risky assumption the module warns against."},
      {"id":"korea-d5-q1-b","text":"High-performing students do not need the same support structures as others.","isCorrect":false,"feedback":"Performance can hide struggle, especially when mistakes carry social cost.","explanation":"Performance can hide struggle, especially when mistakes carry social cost."},
      {"id":"korea-d5-q1-c","text":"Students may hide confusion to protect face, accuracy, or performance standing.","isCorrect":true,"feedback":"Correct. Anonymous checks and private channels can reveal needs that public questioning misses.","explanation":"Correct. Anonymous checks and private channels can reveal needs that public questioning misses."},
      {"id":"korea-d5-q1-d","text":"The main issue is that students prefer written work over all discussion.","isCorrect":false,"feedback":"Written channels can help, but the cause is not a universal preference against discussion.","explanation":"Written channels can help, but the cause is not a universal preference against discussion."}
    ]$$::jsonb,
    5
  ),
  (
    'korea-d6-q1',
    'korea-001',
    'checkpoint',
    6,
    $$Across the Korea scenarios, what should teachers diagnose before choosing a response?$$,
    $$[
      {"id":"korea-d6-q1-a","text":"Whether the parent or student accepts progressive learning methods.","isCorrect":false,"feedback":"Too broad. The scenarios are about pressure, signal, authority, fatigue, and fairness.","explanation":"Too broad. The scenarios are about pressure, signal, authority, fatigue, and fairness."},
      {"id":"korea-d6-q1-b","text":"Whether the issue is really caused by private academies.","isCorrect":false,"feedback":"Academies matter, but they are one part of the system, not the only explanation.","explanation":"Academies matter, but they are one part of the system, not the only explanation."},
      {"id":"korea-d6-q1-c","text":"Which pressure system is active: exam signaling, authority norms, fatigue, help-seeking, or parent uncertainty.","isCorrect":true,"feedback":"Yes. Correct diagnosis prevents teachers from moralizing behavior too quickly.","explanation":"Yes. Correct diagnosis prevents teachers from moralizing behavior too quickly."},
      {"id":"korea-d6-q1-d","text":"Whether the family is asking for special treatment.","isCorrect":false,"feedback":"That may happen, but it is not the main diagnostic lens across the module.","explanation":"That may happen, but it is not the main diagnostic lens across the module."}
    ]$$::jsonb,
    6
  ),
  (
    'korea-final-q1',
    'korea-001',
    'final_exam',
    1,
    $$A parent asks for broad unit alignment with an academy. Which response shows the best interpretive stance before boundary-setting?$$,
    $$[
      {"id":"korea-final-q1-a","text":"Assume the parent is trying to secure unfair advantage.","isCorrect":false,"feedback":"This skips over the coordination logic that often drives the request.","explanation":"This skips over the coordination logic that often drives the request."},
      {"id":"korea-final-q1-b","text":"Recognize the request as an attempt to reduce fragmentation, then explain the school's fairness boundary clearly.","isCorrect":true,"feedback":"Correct. This honors the anxiety without surrendering the boundary.","explanation":"Correct. This honors the anxiety without surrendering the boundary."},
      {"id":"korea-final-q1-c","text":"Provide the information casually, then worry about policy later.","isCorrect":false,"feedback":"Short-term helpfulness can create an equity problem once expectations spread.","explanation":"Short-term helpfulness can create an equity problem once expectations spread."},
      {"id":"korea-final-q1-d","text":"Refuse the conversation because academies are outside the school's role.","isCorrect":false,"feedback":"A hard refusal may miss a chance to clarify the school's role and reduce anxiety.","explanation":"A hard refusal may miss a chance to clarify the school's role and reduce anxiety."}
    ]$$::jsonb,
    NULL
  ),
  (
    'korea-final-q2',
    'korea-001',
    'final_exam',
    2,
    $$What is the best school response when a student is accurate but reluctant to risk being wrong in public?$$,
    $$[
      {"id":"korea-final-q2-a","text":"Treat the problem as lack of resilience and confront it directly.","isCorrect":false,"feedback":"That risks moralizing the behavior instead of teaching a new academic skill.","explanation":"That risks moralizing the behavior instead of teaching a new academic skill."},
      {"id":"korea-final-q2-b","text":"Create lower-stakes structures that make exploratory participation feel safer and still rigorous.","isCorrect":true,"feedback":"Yes. This bridges accuracy-oriented seriousness with visible-thinking pedagogy.","explanation":"Yes. This bridges accuracy-oriented seriousness with visible-thinking pedagogy."},
      {"id":"korea-final-q2-c","text":"Ignore it because correctness matters more than process.","isCorrect":false,"feedback":"That leaves an important learning mismatch untouched.","explanation":"That leaves an important learning mismatch untouched."},
      {"id":"korea-final-q2-d","text":"Require spontaneous oral participation as the main grade lever.","isCorrect":false,"feedback":"That raises the stakes in exactly the channel the student finds riskiest.","explanation":"That raises the stakes in exactly the channel the student finds riskiest."}
    ]$$::jsonb,
    NULL
  ),
  (
    'korea-final-q3',
    'korea-001',
    'final_exam',
    3,
    $$What principle best captures this module's approach to parent communication?$$,
    $$[
      {"id":"korea-final-q3-a","text":"More access is always better.","isCorrect":false,"feedback":"More access can create invisible labor and inequity if it is unstructured.","explanation":"More access can create invisible labor and inequity if it is unstructured."},
      {"id":"korea-final-q3-b","text":"Communication should make care and clarity visible without consuming the teacher.","isCorrect":true,"feedback":"Correct. The issue is not whether to communicate, but what channel can carry the relationship sustainably.","explanation":"Correct. The issue is not whether to communicate, but what channel can carry the relationship sustainably."},
      {"id":"korea-final-q3-c","text":"Teachers should avoid parent groups entirely in Korea.","isCorrect":false,"feedback":"The module does not support a universal prohibition; it supports structured clarity.","explanation":"The module does not support a universal prohibition; it supports structured clarity."},
      {"id":"korea-final-q3-d","text":"Parent concern should be redirected to counselors by default.","isCorrect":false,"feedback":"Counselors can help, but routine teacher communication still needs a sustainable design.","explanation":"Counselors can help, but routine teacher communication still needs a sustainable design."}
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
WHERE module_id = 'korea-001'
GROUP BY module_id, quiz_type
ORDER BY quiz_type;

SELECT count(*) AS total_questions
FROM public.pd_quiz_questions
WHERE module_id = 'korea-001';
