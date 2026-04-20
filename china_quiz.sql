-- ============================================================
-- china_quiz.sql
-- Adds full checkpoint + final quiz coverage for china-001.
-- Safe to re-run.
-- ============================================================

BEGIN;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, sort_order, prompt, options, dimension_number)
VALUES
  (
    'china-d1-q1',
    'china-001',
    'checkpoint',
    1,
    $$During curriculum night, a parent says, "I can see the concepts, but where is the fluency?" What is the strongest first interpretation?$$,
    $$[
      {"id":"china-d1-q1-a","text":"She is rejecting deep understanding and wants traditional schooling instead.","isCorrect":false,"feedback":"Too narrow. Repetition can be understood as one route to secure mastery, not the opposite of understanding.","explanation":"Too narrow. Repetition can be understood as one route to secure mastery, not the opposite of understanding."},
      {"id":"china-d1-q1-b","text":"She may be trying to protect rigor through a different model of secure learning.","isCorrect":true,"feedback":"Correct. The parent is likely asking how serious learning becomes durable and visible.","explanation":"Correct. The parent is likely asking how serious learning becomes durable and visible."},
      {"id":"china-d1-q1-c","text":"She mostly wants more visible work because busier homework always means better learning.","isCorrect":false,"feedback":"Busyness can become a signal, but the deeper issue is mastery and seriousness.","explanation":"Busyness can become a signal, but the deeper issue is mastery and seriousness."},
      {"id":"china-d1-q1-d","text":"She is asking the teacher to abandon inquiry for memorization only.","isCorrect":false,"feedback":"This creates a false binary. The module asks teachers to bridge models of learning.","explanation":"This creates a false binary. The module asks teachers to bridge models of learning."}
    ]$$::jsonb,
    1
  ),
  (
    'china-d2-q1',
    'china-001',
    'checkpoint',
    2,
    $$A parent studies your unit overview, tabs a workbook to match it, and offers it before school. What is the best default reading?$$,
    $$[
      {"id":"china-d2-q1-a","text":"The parent is trying to co-design your curriculum and should be read mainly as overstepping.","isCorrect":false,"feedback":"That may be how it feels, but the parallel-tracks problem suggests a different partnership model may be active.","explanation":"That may be how it feels, but the parallel-tracks problem suggests a different partnership model may be active."},
      {"id":"china-d2-q1-b","text":"The parent may be trying to collaborate through a different model of school-home support.","isCorrect":true,"feedback":"Yes. The useful move is to clarify boundaries while recognizing the partnership intent.","explanation":"Yes. The useful move is to clarify boundaries while recognizing the partnership intent."},
      {"id":"china-d2-q1-c","text":"The parent has probably given up on the school's approach and will run a separate system.","isCorrect":false,"feedback":"Possible in some cases, but too suspicious as the starting assumption.","explanation":"Possible in some cases, but too suspicious as the starting assumption."},
      {"id":"china-d2-q1-d","text":"The parent is signaling that only textbook learning counts.","isCorrect":false,"feedback":"That misses the relational and practical support pattern in the module.","explanation":"That misses the relational and practical support pattern in the module."}
    ]$$::jsonb,
    2
  ),
  (
    'china-d3-q1',
    'china-001',
    'checkpoint',
    3,
    $$A parent says, "He understands it, but he still needs more practice to be solid." Why can that line feel educationally reasonable in this context?$$,
    $$[
      {"id":"china-d3-q1-a","text":"Because more pages automatically prove the school is better.","isCorrect":false,"feedback":"Volume can act as a signal, but automatic volume is not the deeper claim.","explanation":"Volume can act as a signal, but automatic volume is not the deeper claim."},
      {"id":"china-d3-q1-b","text":"Because practice can signal seriousness and help make mastery more secure and visible.","isCorrect":true,"feedback":"Correct. Practice is tied to a theory of learning, not busyness alone.","explanation":"Correct. Practice is tied to a theory of learning, not busyness alone."},
      {"id":"china-d3-q1-c","text":"Because parents usually see inquiry as unserious compared with traditional learning.","isCorrect":false,"feedback":"Too stereotyped. The stronger point is that rigor must be legible across learning models.","explanation":"Too stereotyped. The stronger point is that rigor must be legible across learning models."},
      {"id":"china-d3-q1-d","text":"Because students cannot understand concepts until they have memorized the textbook.","isCorrect":false,"feedback":"This overstates the module's claim and reduces a bridge into a binary.","explanation":"This overstates the module's claim and reduces a bridge into a binary."}
    ]$$::jsonb,
    3
  ),
  (
    'china-d4-q1',
    'china-001',
    'checkpoint',
    4,
    $$A student reproduces a model answer almost exactly. What is the most culturally careful first response?$$,
    $$[
      {"id":"china-d4-q1-a","text":"Treat it immediately as plagiarism so standards remain clear.","isCorrect":false,"feedback":"Academic honesty matters, but the first diagnostic step should distinguish copying from learned model use.","explanation":"Academic honesty matters, but the first diagnostic step should distinguish copying from learned model use."},
      {"id":"china-d4-q1-b","text":"Praise the student because memorized accuracy is always the goal.","isCorrect":false,"feedback":"This goes too far the other way and avoids the school's authorship standard.","explanation":"This goes too far the other way and avoids the school's authorship standard."},
      {"id":"china-d4-q1-c","text":"Diagnose whether the student is using memorization as preparation, misunderstanding authorship, or intentionally copying.","isCorrect":true,"feedback":"Yes. This keeps standards clear while avoiding a reductive moral judgment.","explanation":"Yes. This keeps standards clear while avoiding a reductive moral judgment."},
      {"id":"china-d4-q1-d","text":"Ignore it unless the parent complains.","isCorrect":false,"feedback":"That fails both the learning need and the integrity standard.","explanation":"That fails both the learning need and the integrity standard."}
    ]$$::jsonb,
    4
  ),
  (
    'china-d5-q1',
    'china-001',
    'checkpoint',
    5,
    $$A quiet student listens carefully, takes strong notes, and rarely volunteers. What is the strongest first interpretation?$$,
    $$[
      {"id":"china-d5-q1-a","text":"The student is disengaged because active learning requires visible talk.","isCorrect":false,"feedback":"This imports one participation norm and treats it as universal.","explanation":"This imports one participation norm and treats it as universal."},
      {"id":"china-d5-q1-b","text":"The student is probably afraid of the parent response to mistakes.","isCorrect":false,"feedback":"Possible, but it overdiagnoses family pressure from a single classroom pattern.","explanation":"Possible, but it overdiagnoses family pressure from a single classroom pattern."},
      {"id":"china-d5-q1-c","text":"The student may be engaged through attentive listening, preparation, and accuracy-oriented participation.","isCorrect":true,"feedback":"Correct. The teacher can expand participation routes without calling quietness a defect.","explanation":"Correct. The teacher can expand participation routes without calling quietness a defect."},
      {"id":"china-d5-q1-d","text":"The student needs to be graded down until speaking increases.","isCorrect":false,"feedback":"That raises the stakes before teaching the desired participation behavior.","explanation":"That raises the stakes before teaching the desired participation behavior."}
    ]$$::jsonb,
    5
  ),
  (
    'china-d6-q1',
    'china-001',
    'checkpoint',
    6,
    $$Across the China scenario bank, what is the most important teacher move?$$,
    $$[
      {"id":"china-d6-q1-a","text":"Convince parents that Western inquiry methods are more advanced.","isCorrect":false,"feedback":"That turns the scenario into a ranking contest instead of a translation task.","explanation":"That turns the scenario into a ranking contest instead of a translation task."},
      {"id":"china-d6-q1-b","text":"Give parents whatever extra practice they request to preserve trust.","isCorrect":false,"feedback":"Accommodation without boundaries can create unsustainable expectations.","explanation":"Accommodation without boundaries can create unsustainable expectations."},
      {"id":"china-d6-q1-c","text":"Translate the school's learning model into concrete evidence while respecting the family's rigor signals.","isCorrect":true,"feedback":"Yes. The central skill is bridging seriousness, evidence, and boundaries.","explanation":"Yes. The central skill is bridging seriousness, evidence, and boundaries."},
      {"id":"china-d6-q1-d","text":"Avoid discussing culture and frame every issue as individual preference.","isCorrect":false,"feedback":"That removes the very pattern recognition the module is designed to teach.","explanation":"That removes the very pattern recognition the module is designed to teach."}
    ]$$::jsonb,
    6
  ),
  (
    'china-final-q1',
    'china-001',
    'final_exam',
    1,
    $$A parent asks publicly in WeChat why your class gives less homework than another class. What is the best first move?$$,
    $$[
      {"id":"china-final-q1-a","text":"Reply sharply so the group sees you are in charge.","isCorrect":false,"feedback":"This may protect authority briefly, but it misses the need for legible standards.","explanation":"This may protect authority briefly, but it misses the need for legible standards."},
      {"id":"china-final-q1-b","text":"Acknowledge the concern briefly, explain the logic of workload, and move the deeper conversation into a structured channel.","isCorrect":true,"feedback":"Correct. This preserves professionalism without treating the parent question as pure defiance.","explanation":"Correct. This preserves professionalism without treating the parent question as pure defiance."},
      {"id":"china-final-q1-c","text":"Ignore it so you do not reward public criticism.","isCorrect":false,"feedback":"Ignoring can push families to rely more on the parent network for interpretation.","explanation":"Ignoring can push families to rely more on the parent network for interpretation."},
      {"id":"china-final-q1-d","text":"Increase homework for everyone immediately to remove the comparison.","isCorrect":false,"feedback":"That lets a public comparison set pedagogy without explaining the learning design.","explanation":"That lets a public comparison set pedagogy without explaining the learning design."}
    ]$$::jsonb,
    NULL
  ),
  (
    'china-final-q2',
    'china-001',
    'final_exam',
    2,
    $$Which statement best captures the "parallel tracks" problem?$$,
    $$[
      {"id":"china-final-q2-a","text":"Parents and teachers want fundamentally different outcomes for the child.","isCorrect":false,"feedback":"Usually not. The misread often happens even when goals overlap.","explanation":"Usually not. The misread often happens even when goals overlap."},
      {"id":"china-final-q2-b","text":"Parents and teachers may pursue the same goal while misreading each other's signs of support and seriousness.","isCorrect":true,"feedback":"Yes. This is the core insight the China module asks teachers to hold.","explanation":"Yes. This is the core insight the China module asks teachers to hold."},
      {"id":"china-final-q2-c","text":"Teachers should always give parents what they ask for to stay relational.","isCorrect":false,"feedback":"The goal is clearer interpretation and cleaner boundaries, not automatic accommodation.","explanation":"The goal is clearer interpretation and cleaner boundaries, not automatic accommodation."},
      {"id":"china-final-q2-d","text":"Parent support is helpful at home but should not shape teacher communication.","isCorrect":false,"feedback":"Communication is where many of the misunderstandings are created or resolved.","explanation":"Communication is where many of the misunderstandings are created or resolved."}
    ]$$::jsonb,
    NULL
  ),
  (
    'china-final-q3',
    'china-001',
    'final_exam',
    3,
    $$A student is quiet but attentive, and the parent says this is respectful listening. A culturally intelligent teacher should:$$,
    $$[
      {"id":"china-final-q3-a","text":"Treat the parent explanation as an excuse and insist on immediate visible participation.","isCorrect":false,"feedback":"That risks turning a participation norm into a character verdict.","explanation":"That risks turning a participation norm into a character verdict."},
      {"id":"china-final-q3-b","text":"Recognize the parent's model, then explain participation as a school-taught skill with support structures.","isCorrect":true,"feedback":"Correct. This bridges models instead of ranking them.","explanation":"Correct. This bridges models instead of ranking them."},
      {"id":"china-final-q3-c","text":"Avoid the topic entirely so the family does not feel criticized.","isCorrect":false,"feedback":"Avoidance often creates a later trust problem when assessments surface the issue.","explanation":"Avoidance often creates a later trust problem when assessments surface the issue."},
      {"id":"china-final-q3-d","text":"Tell the parent that international classrooms require extroversion.","isCorrect":false,"feedback":"This misnames the goal. Participation can be taught without demanding extroversion.","explanation":"This misnames the goal. Participation can be taught without demanding extroversion."}
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
WHERE module_id = 'china-001'
GROUP BY module_id, quiz_type
ORDER BY quiz_type;

SELECT count(*) AS total_questions
FROM public.pd_quiz_questions
WHERE module_id = 'china-001';
