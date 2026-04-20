-- ══════════════════════════════════════════════════════════════════════
-- india_quiz_v2.sql  (v2 — correct answers distributed A/B/C)
-- Safe to re-run (ON CONFLICT DO UPDATE).
-- Correct answer key: D1=A  D2=C  D3=B  D4=A  D5=C  D6=B
--                     FE1=C  FE2=A  FE3=B  FE4=C  FE5=A  FE6=B
-- ══════════════════════════════════════════════════════════════════════

-- ── CHECKPOINT QUESTIONS ─────────────────────────────────────────────

-- D1 · correct = A
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d1-q1', 'india-001', 'checkpoint', 1,
  'After a polished exhibition, a parent asks: "But where does my child actually stand?" What is the best first interpretation?',
  '[
    {"id":"a","text":"She is requesting legible evidence that the school is academically trustworthy.","isCorrect":true,"feedback":"Yes. Trust and legibility sit at the centre of the school-choice research here. Parents who invested fees and reputation need to see the investment is working — and that requires a language they can read.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)"]},
    {"id":"b","text":"She is rejecting holistic education and wants the school to become more traditional.","isCorrect":false,"feedback":"Too fast. The parent may simply be asking whether the school''s claims can be translated into recognizable proof of quality — not rejecting the philosophy entirely.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"c","text":"She wants a private rank because competition is the only thing Indian parents trust.","isCorrect":false,"feedback":"That may happen, but the deeper and more common issue is legibility rather than rank for its own sake. Many parents would accept concrete evidence of growth over a class position if the evidence is clear enough.","research":["Ullah, Mukherjee, and Middendorf (2025)"]}
  ]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- D2 · correct = C
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d2-q1', 'india-001', 'checkpoint', 2,
  'Why do marks stay powerful even in schools that sincerely promote inquiry and narrative feedback?',
  '[
    {"id":"a","text":"Because parents here are generally uncomfortable with progressive pedagogy.","isCorrect":false,"feedback":"The issue is less about disliking innovation and more about the social usefulness of marks as easy, comparable evidence. The same parents may welcome inquiry once they can also see its results legibly.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"b","text":"Because narrative feedback cannot carry useful academic information in this context.","isCorrect":false,"feedback":"Narrative feedback can work well, but it needs anchors and translation into concrete evidence of performance and next steps. The medium is not the problem; the missing translation is.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"c","text":"Because marks are legible, comparable, and widely recognized as signals of seriousness.","isCorrect":true,"feedback":"Yes. That is why removing marks without replacing their legibility creates anxiety. Narrative feedback that has no anchor — no concrete ''here is where she stands and here is what comes next'' — can feel elegant but vague.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)"]}
  ]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- D3 · correct = B
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d3-q1', 'india-001', 'checkpoint', 3,
  'Which PTM outcome is most likely to produce frustration later, even if the meeting felt warm in the moment?',
  '[
    {"id":"a","text":"The teacher is respectful but somewhat formal in tone.","isCorrect":false,"feedback":"Tone matters at the margins, but the stronger finding from the PTM research is about clarity and visible follow-through, not warmth as such.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"b","text":"The parent feels heard politely but sees little concrete action or specificity afterward.","isCorrect":true,"feedback":"Yes. Warmth without follow-through is one of the clearest risk patterns in the study. A parent who leaves feeling reassured but later receives a report comment that contradicts that reassurance experiences a specific kind of trust breakdown.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"c","text":"The teacher uses some educational vocabulary the parent does not fully recognise.","isCorrect":false,"feedback":"Jargon can be a problem, but it is not the main pattern highlighted in this research. The larger issue is whether clarity and follow-through match what was implied in the meeting.","research":["Boruah, Phogat, and Singh (2024)"]}
  ]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- D4 · correct = A
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d4-q1', 'india-001', 'checkpoint', 4,
  'What is the main caution about school language such as "Indian values" in international-school settings?',
  '[
    {"id":"a","text":"It can sound inclusive while actually centering a selective, classed version of belonging.","isCorrect":true,"feedback":"Yes. This is why specificity and plurality matter. A school that uses ''Indian values'' as branding but operationalises it through one regional tradition, class register, or religious norm is misrepresenting the breadth of the claim.","research":["Babu and Mahajan (2021)","Gurney (2017)"]},
    {"id":"b","text":"It is too politically sensitive to use responsibly at all.","isCorrect":false,"feedback":"The issue is not the phrase itself but what version of Indianness it quietly privileges. With enough specificity and plurality, the language can work. Without it, it defaults to one group''s norms presented as universal.","research":["Babu and Mahajan (2021)"]},
    {"id":"c","text":"Parents generally treat this language as branding and focus only on academics.","isCorrect":false,"feedback":"The research suggests values and belonging matter alongside academics, not after them — especially in the fee-paying international-school market where identity fit is part of the school-choice calculus.","research":["Babu and Mahajan (2021)"]}
  ]'::jsonb, 4)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- D5 · correct = C
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d5-q1', 'india-001', 'checkpoint', 5,
  'A high-performing student submits polished work but avoids visible trial-and-error and never volunteers a partial answer. What is the strongest first interpretation?',
  '[
    {"id":"a","text":"The family is clearly pressuring the student, and that is the main issue to address.","isCorrect":false,"feedback":"Pressure may be part of the picture, but diagnosing the family before understanding the student''s own performance logic is a common error. The module warns against this move specifically.","research":["Parikh et al. (2019)","Pienyu, Margaret, and D''Souza (2024)"]},
    {"id":"b","text":"The student is better prepared than classmates, so there is nothing that needs addressing.","isCorrect":false,"feedback":"Strong performance does not eliminate the learning costs of overprotection and avoidance of visible imperfection. The two can coexist, and the module asks teachers to hold both simultaneously.","research":["Parikh et al. (2019)"]},
    {"id":"c","text":"The student may be protecting competence in a context where visible mistakes carry social weight.","isCorrect":true,"feedback":"Yes. That is why the recommended teacher move is to frame risk-taking as an additional academic skill the classroom explicitly teaches — not as lowering standards or solving a parenting problem.","research":["Parikh et al. (2019)","Pienyu, Margaret, and D''Souza (2024)"]}
  ]'::jsonb, 5)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- D6 · correct = B
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d6-q1', 'india-001', 'checkpoint', 6,
  'In this module, what is the most useful way to understand parent WhatsApp groups?',
  '[
    {"id":"a","text":"Mainly a sign that parents have lost confidence in the school.","isCorrect":false,"feedback":"Distrust may grow through these networks, but their core function is often reassurance and shared interpretation — not dissatisfaction. They operate in schools parents love as much as schools they doubt.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"b","text":"Informal infrastructure for comparison, validation, and uncertainty reduction.","isCorrect":true,"feedback":"Yes. That is why the appropriate response is not avoidance but building a more reliable official channel. If families will compare notes regardless, the question is whether the school''s communication is clear enough to be the primary interpreter rather than the rumor chain.","research":["Ullah, Mukherjee, and Middendorf (2025)","Gurney (2017)"]},
    {"id":"c","text":"Mostly gossip channels that schools should avoid dignifying with a response.","isCorrect":false,"feedback":"The research-backed framing is broader. These groups often act as school-navigation infrastructure — a way for families to reduce uncertainty, validate interpretations, and compare notes when the official channel is unclear or slow.","research":["Ullah, Mukherjee, and Middendorf (2025)","Gurney (2017)"]}
  ]'::jsonb, 6)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;


-- ── FINAL EXAM QUESTIONS ──────────────────────────────────────────────

-- FE1 · correct = C
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q1', 'india-001', 'final_exam', NULL,
  'A parent asks for a concrete academic scorecard after a project exhibition. What is the most research-aligned response?',
  '[
    {"id":"a","text":"Explain that marks are an outdated measure and should not matter in an inquiry school.","isCorrect":false,"feedback":"This dismisses the parent''s need for trust signals and legibility entirely, which typically pushes families toward building their own parallel benchmark system outside school.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"b","text":"Offer a private benchmark comparison to preserve the relationship, even if school policy discourages it.","isCorrect":false,"feedback":"That solves the immediate discomfort while quietly rebuilding a rank culture through unofficial channels — the opposite of what the school''s assessment philosophy is trying to achieve.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"c","text":"Refuse ranking but translate the school''s assessment model into concrete evidence of current performance, specific strengths, and next steps.","isCorrect":true,"feedback":"Yes. This is the clearest bridge between school philosophy and parent trust. The goal is not to give a rank but to ensure the parent leaves knowing something specific and actionable about where the child stands.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)"]}
  ]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- FE2 · correct = A
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q2', 'india-001', 'final_exam', NULL,
  'What is the best interpretation when a parent asks whether "Indian Values Week" will include regional and family differences rather than one polished version of tradition?',
  '[
    {"id":"a","text":"The parent is testing whether the school''s version of Indianness is genuinely plural or selectively presented.","isCorrect":true,"feedback":"Yes. A parent who raises this is not derailing the event — they are asking whether the school''s idea of India has room for them specifically, or whether it centres a different group''s norms as universal.","research":["Babu and Mahajan (2021)","Gurney (2017)"]},
    {"id":"b","text":"The parent is derailing a celebration with unnecessary politics.","isCorrect":false,"feedback":"That reading misses the legitimate question about belonging and representation that the research identifies as structurally endemic to Indian international schools.","research":["Babu and Mahajan (2021)"]},
    {"id":"c","text":"The parent probably just wants more logistical details about the event.","isCorrect":false,"feedback":"Logistics may be part of it, but this answer misses the identity and belonging layer that the research identifies as the more important dynamic.","research":["Babu and Mahajan (2021)"]}
  ]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- FE3 · correct = B
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q3', 'india-001', 'final_exam', NULL,
  'Several parents want a WhatsApp group for class logistics. What is the most important guiding principle?',
  '[
    {"id":"a","text":"Refuse any group because parent networks are inherently a discipline problem.","isCorrect":false,"feedback":"That treats a structural navigation tool as if it were purely a behavioural problem. Refusing without offering an alternative typically strengthens the informal network rather than weakening it.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"b","text":"Build a sustainable official clarification channel so the parent network is not the only place where school gets interpreted.","isCorrect":true,"feedback":"Yes. The question is not whether parents will share information — they will. It is whether the official channel is clear and reliable enough to keep rumour from becoming the primary interpreter.","research":["Boruah, Phogat, and Singh (2024)","Ullah, Mukherjee, and Middendorf (2025)"]},
    {"id":"c","text":"Join a small group privately and keep it flexible to maintain the relationship.","isCorrect":false,"feedback":"This may improve short-term responsiveness but weakens equity, sustainability, and sets an expectation that is difficult to walk back.","research":["Boruah, Phogat, and Singh (2024)"]}
  ]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- FE4 · correct = C
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q4', 'india-001', 'final_exam', NULL,
  'At a PTM you say: "Aditya is doing well overall — there are a few small things I''m monitoring in writing." One week later his parent emails to complain you never mentioned any writing concern. What is most likely happening?',
  '[
    {"id":"a","text":"The parent misunderstood and was not listening carefully.","isCorrect":false,"feedback":"This mislocates the failure in the parent. The research identifies the pattern as a communication structure problem, not a listening problem.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"b","text":"Written PTM summaries should always replace verbal conversation to prevent this.","isCorrect":false,"feedback":"Written summaries can help, but they are not the core recommendation. The issue is the clarity of what is communicated, not the medium it is communicated through.","research":["Boruah, Phogat, and Singh (2024)"]},
    {"id":"c","text":"Your softened language was received as overall reassurance — the parent left with a different understanding of what was communicated.","isCorrect":true,"feedback":"Yes. ''A few small things I''m monitoring'' is simultaneously true and deniable as a concern. The parent heard the frame (doing well overall) rather than the caveat. The fix is to name the concern separately and specifically.","research":["Boruah, Phogat, and Singh (2024)"]}
  ]'::jsonb, 4)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- FE5 · correct = A
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q5', 'india-001', 'final_exam', NULL,
  'Pienyu, Margaret, and D''Souza (2024) and Parikh et al. (2019) both document high levels of academic stress among urban Indian school-going adolescents. What is the most useful classroom implication?',
  '[
    {"id":"a","text":"Do not romanticise perfectionist discipline while also avoiding diagnosing every cautious student as a victim of family pressure.","isCorrect":true,"feedback":"Yes. The stress data is real and matters — but it does not licence a binary reading of every polished, cautious student as harmed. Teachers who frame the concern as shared pedagogy rather than family pathology are more likely to build a productive relationship with both student and parent.","research":["Pienyu, Margaret, and D''Souza (2024)","Parikh et al. (2019)","Kumar, Pandita, and Singh (2024)"]},
    {"id":"b","text":"Reduce homework and assessment frequency to protect student wellbeing.","isCorrect":false,"feedback":"Oversimplification. Stress is real but does not reduce neatly to workload. The module asks for a more nuanced position, not a blanket reduction.","research":["Pienyu, Margaret, and D''Souza (2024)","Parikh et al. (2019)"]},
    {"id":"c","text":"Recommend external counselling to families who appear achievement-oriented.","isCorrect":false,"feedback":"This overindividualises the issue and misses the classroom design implication entirely. The first move is pedagogical — create structures that make visible thinking feel safe — not a referral.","research":["Parikh et al. (2019)"]}
  ]'::jsonb, 5)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

-- FE6 · correct = B
INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q6', 'india-001', 'final_exam', NULL,
  'A high-investment Indian family is warm, attends every event, emails regularly, and asks detailed PTM questions about grades, future outcomes, and next steps. Which starting frame does this module''s research base most support?',
  '[
    {"id":"a","text":"This is normal parental pressure — maintain professional distance and clear boundaries.","isCorrect":false,"feedback":"Boundaries matter, but ''professional distance'' as the primary frame misses the trust and investment logic entirely. A teacher who responds to engagement with distance tends to push the family toward the parent network for interpretation instead.","research":["Ullah, Mukherjee, and Middendorf (2025)","Gurney (2017)"]},
    {"id":"b","text":"The engagement reflects a high-stakes investment logic where fees, attention, and outcomes are seen as tightly linked — respond with clarity, evidence, and follow-through rather than warmth alone.","isCorrect":true,"feedback":"Yes. High-investment families need legibility — evidence that the investment is working and that the school can be trusted to tell them clearly when it is not. Warmth without clarity produces exactly the follow-up pressure it is trying to avoid.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)","Gurney (2017)"]},
    {"id":"c","text":"High engagement from fee-paying Indian families typically signals underlying dissatisfaction with the school.","isCorrect":false,"feedback":"Engagement and dissatisfaction are not the same thing. High involvement is normal in the high-investment school-choice context the module describes.","research":["Ullah, Mukherjee, and Middendorf (2025)"]}
  ]'::jsonb, 6)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;


-- ── VERIFICATION ──────────────────────────────────────────────────────
-- SELECT id, quiz_type, sort_order,
--   (SELECT opt->>'id' FROM jsonb_array_elements(options) opt WHERE (opt->>'isCorrect')::boolean LIMIT 1) AS correct_option
-- FROM pd_quiz_questions
-- WHERE module_id = 'india-001'
-- ORDER BY quiz_type DESC, sort_order;
-- Expected: checkpoints A,C,B,A,C,B — final_exam C,A,B,C,A,B
