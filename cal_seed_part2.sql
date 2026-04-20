-- Phase 1 quiz tables and seed
-- Run AFTER 20260330_create_pd_layer.sql

-- ── Table ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.pd_quiz_questions (
  id               text PRIMARY KEY,
  module_id        text NOT NULL,
  quiz_type        text NOT NULL CHECK (quiz_type IN ('checkpoint', 'final_exam')),
  dimension_number integer,
  prompt           text NOT NULL,
  options          jsonb NOT NULL,
  sort_order       integer DEFAULT 0
);

ALTER TABLE public.pd_quiz_questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon read quiz questions" ON public.pd_quiz_questions;
CREATE POLICY "anon read quiz questions" ON public.pd_quiz_questions
  FOR SELECT USING (true);

-- ── Seed ──────────────────────────────────────────────────────────────────

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-d1-q1', 'china-001', 'checkpoint', 1, 'During curriculum night, a parent says, "I can see the concepts, but where is the fluency?" In this module, what is the strongest first interpretation?', '[{"id":"a","text":"She is rejecting deep understanding and wants a traditional classroom instead.","isCorrect":false,"feedback":"Too narrow. Li''s work suggests repetition and diligence may be understood as one route to secure mastery, not as the opposite of understanding.","research":["Li (2005)"]},{"id":"b","text":"She may be trying to protect rigor through a different model of what secure learning looks like.","isCorrect":true,"feedback":"Yes. The most useful reading is that the parent is operating with a different theory of how serious learning is built and recognized.","research":["Li (2005)"]},{"id":"c","text":"She mostly wants more visible work because busier homework always means better learning.","isCorrect":false,"feedback":"Distrust can appear, but that is not the strongest first interpretation from the research base.","research":["Li (2005)","Ran (2001)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-d2-q1', 'china-001', 'checkpoint', 2, 'A parent has studied your unit overview, tabbed a supplemental workbook to match it, and offers it to you before school. What is the best default reading?', '[{"id":"a","text":"The parent is trying to become a co-designer of your curriculum and should be read mainly as overstepping.","isCorrect":false,"feedback":"That may be how it feels, but Ran''s ''parallel tracks'' framing suggests the parent may instead be offering what they understand as partnership.","research":["Ran (2001)"]},{"id":"b","text":"The parent may be trying to collaborate through a different model of school-home partnership.","isCorrect":true,"feedback":"Yes. This is the core interpretive move in the China module.","research":["Ran (2001)"]},{"id":"c","text":"The parent is signaling that she has already given up on the school''s approach and will run a separate system at home.","isCorrect":false,"feedback":"Possible, but less research-grounded as the starting assumption here.","research":["Ran (2001)","Guo, Wu, and Liu (2019)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-d3-q1', 'china-001', 'checkpoint', 3, 'A parent says, "He understands it, but he still needs more practice to be solid." Why can that line feel educationally reasonable in this context?', '[{"id":"a","text":"Because more pages automatically prove the school is better.","isCorrect":false,"feedback":"Volume can act as a signal, but the deeper issue is visible seriousness and secure mastery.","research":["Li (2005)"]},{"id":"b","text":"Because practice can signal seriousness and help make mastery feel more secure and visible.","isCorrect":true,"feedback":"Yes. This links homework to a theory of learning rather than to busyness alone.","research":["Li (2005)","Ran (2001)"]},{"id":"c","text":"Because parents in this context usually see inquiry as unserious compared with traditional learning.","isCorrect":false,"feedback":"Too broad and stereotyped. The stronger research claim is about different assumptions of rigor.","research":["Li (2005)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-final-q1', 'china-001', 'final_exam', NULL, 'A parent asks publicly in WeChat why your class gives less homework than another class. What is the best first move?', '[{"id":"a","text":"Reply sharply so the group sees you are in charge.","isCorrect":false,"feedback":"This protects face but usually misses the real issue: parents are testing whether standards are legible and trustworthy.","research":["Guo, Wu, and Liu (2019)"]},{"id":"b","text":"Acknowledge the concern briefly, explain the logic of workload, and move the deeper conversation into a structured channel.","isCorrect":true,"feedback":"Yes. This preserves professionalism without treating the parent question as pure defiance.","research":["Guo, Wu, and Liu (2019)","Ran (2001)"]},{"id":"c","text":"Ignore it so you do not reward public criticism.","isCorrect":false,"feedback":"Ignoring it can push families to rely even more on the parent network for interpretation.","research":["Guo, Wu, and Liu (2019)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-final-q2', 'china-001', 'final_exam', NULL, 'Which statement best captures the ''parallel tracks'' problem?', '[{"id":"a","text":"Parents and teachers want different outcomes for the child.","isCorrect":false,"feedback":"Not usually. Ran''s point is that they may want the same outcome while misreading each other''s signals.","research":["Ran (2001)"]},{"id":"b","text":"Parents and teachers may pursue the same goal while misreading each other''s signs of support and seriousness.","isCorrect":true,"feedback":"Yes. That is the core insight of the China module.","research":["Ran (2001)"]},{"id":"c","text":"Teachers should always give parents what they ask for to stay relational.","isCorrect":false,"feedback":"The goal is not automatic accommodation. It is clearer interpretation and cleaner boundaries.","research":["Ran (2001)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('china-final-q3', 'china-001', 'final_exam', NULL, 'A student is quiet but attentive, and the parent says this is respectful listening. A culturally intelligent teacher should:', '[{"id":"a","text":"Treat the parent explanation as an excuse and insist the child participate more immediately.","isCorrect":false,"feedback":"That risks turning a participation norm into a character verdict.","research":["Li (2005)"]},{"id":"b","text":"Recognize the parent''s model, then explain participation as a school-taught skill with support structures.","isCorrect":true,"feedback":"Yes. This bridges models instead of ranking them.","research":["Li (2005)"]},{"id":"c","text":"Avoid the topic entirely so the family does not feel criticized.","isCorrect":false,"feedback":"Avoidance often creates a later trust problem when report comments or assessments surface the issue anyway.","research":["Ran (2001)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-d1-q1', 'korea-001', 'checkpoint', 1, 'A parent expects the homeroom teacher to understand the child''s wider learning situation, not just classroom performance. What is the best explanation?', '[{"id":"a","text":"Because Korean parents are unusually dependent on school adults.","isCorrect":false,"feedback":"Too crude. The stronger explanation is institutional: the homeroom role has historically carried relational and moral weight.","research":["Jung (2014)"]},{"id":"b","text":"Because the homeroom role has historically involved affective care and guidance, not just instruction.","isCorrect":true,"feedback":"Yes. This helps explain why families may imagine the homeroom teacher as a central adult in the child''s development.","research":["Jung (2014)"]},{"id":"c","text":"Because once a child has academy support, the school teacher is naturally expected to manage that whole system too.","isCorrect":false,"feedback":"Some parents may hope for coordination, but that is not the primary explanation of the homeroom role itself.","research":["Jung (2014)","Howard (2021)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-d2-q1', 'korea-001', 'checkpoint', 2, 'A parent coalition pushes back when a test week is replaced by a project week. What is the most research-backed first interpretation?', '[{"id":"a","text":"They are mainly uncomfortable with innovation and need more modern pedagogy explained to them.","isCorrect":false,"feedback":"That misses the meritocratic logic Jang describes. Parent activism can reflect a defense of legible signals and fair positioning.","research":["Jang (2024)"]},{"id":"b","text":"They may be defending competitive legibility and predictability inside a high-stakes system.","isCorrect":true,"feedback":"Yes. This is the strongest interpretive starting point.","research":["Jang (2024)"]},{"id":"c","text":"They are mostly echoing academy culture rather than expressing a school-based concern of their own.","isCorrect":false,"feedback":"Shadow education matters, but this is too reductive to explain parent activism well.","research":["Jang (2024)","Howard (2021)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-d3-q1', 'korea-001', 'checkpoint', 3, 'A student consistently waits until she is sure an answer is correct before speaking. What is the strongest interpretation?', '[{"id":"a","text":"She mainly lacks confidence and needs stronger encouragement to speak up.","isCorrect":false,"feedback":"Incomplete. Her caution may also be tied to norms of seriousness, exposure, and correctness.","research":["Lee and Kim (2019)"]},{"id":"b","text":"She may be protecting competence in a setting where accuracy carries social and educational weight.","isCorrect":true,"feedback":"Yes. This lets the teacher frame risk-taking as an additional academic skill rather than as a defect.","research":["Lee and Kim (2019)","Howard (2021)"]},{"id":"c","text":"Her family is probably overvaluing marks and causing the whole pattern.","isCorrect":false,"feedback":"Too binary. The student may be navigating systems with different definitions of serious learning.","research":["Lee and Kim (2019)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-final-q1', 'korea-001', 'final_exam', NULL, 'A parent asks for broad unit alignment with an academy. Which response shows the best interpretive stance before boundary-setting?', '[{"id":"a","text":"Assume the parent is trying to secure unfair advantage.","isCorrect":false,"feedback":"This skips over the coordination logic that often drives such requests.","research":["Howard (2021)"]},{"id":"b","text":"Recognize the request as an attempt to reduce fragmentation, then explain the school''s fairness boundary clearly.","isCorrect":true,"feedback":"Yes. This is the key move the module is trying to teach.","research":["Howard (2021)"]},{"id":"c","text":"Provide the information casually, then worry about policy later.","isCorrect":false,"feedback":"Short-term helpfulness can create a bigger fairness problem once expectations are established.","research":["Howard (2021)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-final-q2', 'korea-001', 'final_exam', NULL, 'What is the best school response when a student is accurate but reluctant to risk being wrong in public?', '[{"id":"a","text":"Treat the problem as lack of resilience and confront it directly.","isCorrect":false,"feedback":"That risks moralizing the behavior instead of teaching a new academic skill.","research":["Lee and Kim (2019)"]},{"id":"b","text":"Create lower-stakes structures that make exploratory participation feel safer and still rigorous.","isCorrect":true,"feedback":"Yes. This is a better bridge between accuracy-oriented seriousness and visible-thinking pedagogy.","research":["Lee and Kim (2019)"]},{"id":"c","text":"Ignore it because correctness matters more than process.","isCorrect":false,"feedback":"That leaves an important learning mismatch untouched.","research":["Lee and Kim (2019)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('korea-final-q3', 'korea-001', 'final_exam', NULL, 'What principle best captures this module''s approach to parent communication?', '[{"id":"a","text":"More access is always better.","isCorrect":false,"feedback":"Not if it creates invisible labor and inequity.","research":["Jang (2024)"]},{"id":"b","text":"Communication should be structured so that care and clarity are visible without consuming the teacher.","isCorrect":true,"feedback":"Yes. The issue is not whether to communicate, but what channel can carry the relationship sustainably.","research":["Jung (2014)","Jang (2024)"]},{"id":"c","text":"Teachers should avoid parent groups entirely in Korea.","isCorrect":false,"feedback":"The research does not support a universal prohibition.","research":["Jang (2024)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-d1-q1', 'ksa-001', 'checkpoint', 1, 'A parent asks what a ''student voice'' activity will actually teach children to do. What is the strongest first interpretation?', '[{"id":"a","text":"The parent is against critical thinking and modern pedagogy.","isCorrect":false,"feedback":"That misses the core dynamic. The parent may be trying to interpret how the school''s international ethos fits local expectations.","research":["Hammad and Shah (2018)"]},{"id":"b","text":"The parent may be testing how the school''s international ethos fits with local moral and cultural expectations.","isCorrect":true,"feedback":"Yes. This is the dissonance at the center of the KSA module.","research":["Hammad and Shah (2018)"]},{"id":"c","text":"The parent mostly needs the English terminology simplified.","isCorrect":false,"feedback":"Language matters, but the deeper issue is interpretation, not vocabulary alone.","research":["Hammad and Shah (2018)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-d2-q1', 'ksa-001', 'checkpoint', 2, 'In this module, why do routine parent questions sometimes feel larger than they first appear?', '[{"id":"a","text":"Because families are mostly asking for faster updates and tighter logistics.","isCorrect":false,"feedback":"Updates matter, but the research here shows communication is also interpretive work.","research":["Hammad and Shah (2018)"]},{"id":"b","text":"Because communication is often doing interpretive work about what the school means, not just what it is doing.","isCorrect":true,"feedback":"Yes. That is why small questions can carry more weight than they first appear to.","research":["Hammad and Shah (2018)"]},{"id":"c","text":"Because the real problem is usually choosing the wrong communication platform.","isCorrect":false,"feedback":"The medium matters less than the interpretive burden the medium creates.","research":["Hammad and Shah (2018)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-d3-q1', 'ksa-001', 'checkpoint', 3, 'Why can an English-first routine become more than a language policy in this setting?', '[{"id":"a","text":"Because students often overreact emotionally to otherwise neutral school routines.","isCorrect":false,"feedback":"This underestimates the social meaning of language hierarchies.","research":["Alsaawi and Almulhim (2024)"]},{"id":"b","text":"Because it can quietly attach prestige, intelligence, or legitimacy to English over Arabic.","isCorrect":true,"feedback":"Yes. That is the central risk the module asks teachers to notice.","research":["Alsaawi and Almulhim (2024)"]},{"id":"c","text":"Because families in this context usually oppose strong English instruction on principle.","isCorrect":false,"feedback":"The evidence points the other way: many families actively value English while still caring deeply about Arabic and identity.","research":["Alothman et al. (2024)","Alsaawi and Almulhim (2024)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-final-q1', 'ksa-001', 'final_exam', NULL, 'A parent asks whether a ''student voice'' activity teaches children to challenge adults more broadly. What is the best first move?', '[{"id":"a","text":"Assume the parent is opposed to agency and defend the school firmly.","isCorrect":false,"feedback":"That turns an interpretive question into a values battle too quickly.","research":["Hammad and Shah (2018)"]},{"id":"b","text":"Explain what the activity concretely involves and what kind of participation it does and does not ask for.","isCorrect":true,"feedback":"Yes. Concrete translation is often better than abstract reassurance.","research":["Hammad and Shah (2018)"]},{"id":"c","text":"Say the school should not have to justify internationally normal practices.","isCorrect":false,"feedback":"That ignores the dissonance the research identifies as endemic to this setting.","research":["Hammad and Shah (2018)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-final-q2', 'ksa-001', 'final_exam', NULL, 'A child begins treating English as the language of status. What is the strongest explanation?', '[{"id":"a","text":"The family must be discouraging Arabic at home.","isCorrect":false,"feedback":"That overlocates the cause in the family and misses the school''s hidden curriculum.","research":["Alsaawi and Almulhim (2024)"]},{"id":"b","text":"The school environment may be teaching a hierarchy of linguistic belonging alongside English growth.","isCorrect":true,"feedback":"Yes. That is the key issue to name and address.","research":["Alsaawi and Almulhim (2024)"]},{"id":"c","text":"This is unavoidable in any international school.","isCorrect":false,"feedback":"It may be common, but it is not inevitable. Design and messaging choices matter.","research":["Alsaawi and Almulhim (2024)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('ksa-final-q3', 'ksa-001', 'final_exam', NULL, 'What does the Saudi school-choice research suggest about many families in this sector?', '[{"id":"a","text":"They are trying to combine opportunity, English, and pedagogy with cultural and moral fit.","isCorrect":true,"feedback":"Yes. That is the most faithful summary of the research base.","research":["Alothman et al. (2024)","Hammad and Shah (2018)"]},{"id":"b","text":"They are trading away local continuity for future opportunity.","isCorrect":false,"feedback":"That is the wrong binary. Many are actively trying to preserve both.","research":["Alothman et al. (2024)"]},{"id":"c","text":"They mainly choose on prestige and facilities.","isCorrect":false,"feedback":"Those may matter, but they are not the full explanation in this module''s research base.","research":["Alothman et al. (2024)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d1-q1', 'india-001', 'checkpoint', 1, 'After a polished exhibition, a parent asks, "But where does my child actually stand?" What is the best first interpretation?', '[{"id":"a","text":"Rejecting holistic education and wanting the school to become more traditional.","isCorrect":false,"feedback":"Too fast. The parent may be asking whether the school''s claims can be translated into recognizable proof.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},{"id":"b","text":"Requesting legible evidence that the school is academically trustworthy.","isCorrect":true,"feedback":"Yes. Trust and legibility are central to the school-choice research in this module.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)"]},{"id":"c","text":"Trying to pressure the teacher into producing rank because competition is the only thing parents trust.","isCorrect":false,"feedback":"That may happen, but the deeper and more common issue is legibility rather than rank for its own sake.","research":["Ullah, Mukherjee, and Middendorf (2025)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d2-q1', 'india-001', 'checkpoint', 2, 'Why do marks remain powerful even in schools that sincerely promote inquiry and narrative feedback?', '[{"id":"a","text":"Because parents are uncomfortable with progressive methods in general.","isCorrect":false,"feedback":"The issue is less dislike of innovation and more the social usefulness of marks as easy, comparable evidence.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},{"id":"b","text":"Because marks are legible, comparable, and widely recognized as signals of seriousness.","isCorrect":true,"feedback":"Yes. That is why removing marks without replacing their legibility creates anxiety.","research":["Ullah, Mukherjee, and Middendorf (2025)","Narwana (2018)"]},{"id":"c","text":"Because narrative feedback cannot carry useful academic information in this context.","isCorrect":false,"feedback":"Narrative feedback can work, but it needs anchors and translation into concrete evidence.","research":["Boruah, Phogat, and Singh (2024)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d3-q1', 'india-001', 'checkpoint', 3, 'Which PTM outcome is most likely to produce frustration later, even if the meeting felt warm in the moment?', '[{"id":"a","text":"The teacher is respectful but somewhat formal.","isCorrect":false,"feedback":"Tone matters, but the stronger finding is about clarity and visible follow-through.","research":["Boruah, Phogat, and Singh (2024)"]},{"id":"b","text":"They feel heard politely but see little concrete action or specificity afterward.","isCorrect":true,"feedback":"Yes. Warmth without follow-through is one of the clearest risks named in the study.","research":["Boruah, Phogat, and Singh (2024)"]},{"id":"c","text":"The teacher uses some educational vocabulary the parent does not fully recognize.","isCorrect":false,"feedback":"Jargon can be a problem, but it is not the main pattern highlighted in the PTM research.","research":["Boruah, Phogat, and Singh (2024)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d4-q1', 'india-001', 'checkpoint', 4, 'What is the main caution about school language such as ''Indian values'' in international-school settings?', '[{"id":"a","text":"They are too politically sensitive to use responsibly at all.","isCorrect":false,"feedback":"The issue is not the phrase alone, but what version of Indianness it quietly privileges.","research":["Babu and Mahajan (2021)"]},{"id":"b","text":"They can sound inclusive while actually centering a selective, classed version of belonging.","isCorrect":true,"feedback":"Yes. This is why specificity and plurality matter in how schools operationalize these values claims.","research":["Babu and Mahajan (2021)","Gurney (2017)"]},{"id":"c","text":"Parents generally treat this language as branding and focus on academics instead.","isCorrect":false,"feedback":"The research suggests values and belonging matter alongside academics, not after them.","research":["Babu and Mahajan (2021)"]}]'::jsonb, 4)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d5-q1', 'india-001', 'checkpoint', 5, 'A high-performing student submits polished work but avoids visible trial-and-error. What is the strongest first interpretation?', '[{"id":"a","text":"The family is clearly pressuring the student too much, and that is the main issue.","isCorrect":false,"feedback":"Pressure may be part of the picture, but the module warns against overdiagnosing the family before understanding the student''s performance logic.","research":["Parikh et al. (2019)","Pienyu, Margaret, and D''Souza (2024)"]},{"id":"b","text":"Potentially protecting competence in a context where mistakes carry weight.","isCorrect":true,"feedback":"Yes. That is why the recommended teacher move is to frame risk-taking as another academic skill, not as a lowering of standards.","research":["Parikh et al. (2019)","Pienyu, Margaret, and D''Souza (2024)"]},{"id":"c","text":"The student is simply better prepared than classmates, so there is no real issue to address.","isCorrect":false,"feedback":"Strong performance does not eliminate the learning costs of overprotection and fear of visible imperfection.","research":["Parikh et al. (2019)"]}]'::jsonb, 5)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-d6-q1', 'india-001', 'checkpoint', 6, 'In this module, what is the most useful way to understand parent WhatsApp groups?', '[{"id":"a","text":"Mostly gossip channels that schools should avoid dignifying.","isCorrect":false,"feedback":"The research-backed framing is broader: these groups often act as school-navigation infrastructure.","research":["Ullah, Mukherjee, and Middendorf (2025)","Gurney (2017)"]},{"id":"b","text":"Informal infrastructure for comparison, validation, and uncertainty reduction.","isCorrect":true,"feedback":"Yes. That is why schools need better official clarity rather than pretending the network does not matter.","research":["Ullah, Mukherjee, and Middendorf (2025)","Gurney (2017)"]},{"id":"c","text":"Mainly a sign that parents no longer trust teachers or schools.","isCorrect":false,"feedback":"Distrust may grow through these networks, but their core function is often reassurance and shared interpretation.","research":["Ullah, Mukherjee, and Middendorf (2025)"]}]'::jsonb, 6)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q1', 'india-001', 'final_exam', NULL, 'A parent asks for a concrete scorecard after a project exhibition. What is the most research-aligned response?', '[{"id":"a","text":"Explain that marks are outdated and should not matter anymore.","isCorrect":false,"feedback":"This dismisses the parent''s need for trust signals and legibility.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},{"id":"b","text":"Refuse ranking but translate the school''s assessment model into concrete evidence of current performance and next steps.","isCorrect":true,"feedback":"Yes. This is the clearest bridge between school philosophy and parent trust.","research":["Ullah, Mukherjee, and Middendorf (2025)","Boruah, Phogat, and Singh (2024)"]},{"id":"c","text":"Offer a private benchmark only to preserve the relationship.","isCorrect":false,"feedback":"That solves the immediate discomfort while rebuilding a rank culture privately.","research":["Boruah, Phogat, and Singh (2024)"]}]'::jsonb, 1)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q2', 'india-001', 'final_exam', NULL, 'What is the best interpretation when a parent asks whether ''Indian Values Week'' includes regional and family differences?', '[{"id":"a","text":"The parent is testing whether the school''s version of Indianness is genuinely plural or selectively polished.","isCorrect":true,"feedback":"Yes. That is exactly the interpretive task behind the question.","research":["Babu and Mahajan (2021)","Gurney (2017)"]},{"id":"b","text":"The parent is derailing a celebration with politics.","isCorrect":false,"feedback":"That misses the legitimate question about belonging and representation.","research":["Babu and Mahajan (2021)"]},{"id":"c","text":"The parent probably just wants more event details.","isCorrect":false,"feedback":"Logistics may be part of it, but this answer misses the values layer.","research":["Babu and Mahajan (2021)"]}]'::jsonb, 2)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;

INSERT INTO public.pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES ('india-final-q3', 'india-001', 'final_exam', NULL, 'A few parents want a WhatsApp group for clarifications. What is the best guiding principle?', '[{"id":"a","text":"Create a sustainable official clarification structure so the parent network is not the only place where school gets interpreted.","isCorrect":true,"feedback":"Yes. This is the strongest practical lesson from the module''s communication and network dimensions.","research":["Boruah, Phogat, and Singh (2024)","Ullah, Mukherjee, and Middendorf (2025)"]},{"id":"b","text":"Refuse because parent groups are inherently toxic.","isCorrect":false,"feedback":"That treats a structural navigation tool as if it were only a behavioral problem.","research":["Ullah, Mukherjee, and Middendorf (2025)"]},{"id":"c","text":"Join the small group privately and keep things flexible.","isCorrect":false,"feedback":"That may improve short-term responsiveness while weakening equity and sustainability.","research":["Boruah, Phogat, and Singh (2024)"]}]'::jsonb, 3)
ON CONFLICT (id) DO UPDATE SET prompt = EXCLUDED.prompt, options = EXCLUDED.options;-- Create pd_simulations table
CREATE TABLE public.pd_simulations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id text REFERENCES public.pd_modules(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  context text NOT NULL,
  characters jsonb NOT NULL,
  nodes jsonb NOT NULL,
  dimension_tags integer[],
  estimated_minutes integer DEFAULT 20,
  sort_order integer DEFAULT 0,
  status text DEFAULT 'draft' CHECK (status IN ('draft','live','archived')),
  created_at timestamptz DEFAULT now()
);

-- Create pd_simulation_responses table
CREATE TABLE public.pd_simulation_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id text NOT NULL,
  simulation_id uuid REFERENCES public.pd_simulations(id) ON DELETE CASCADE,
  node_id text NOT NULL,
  choice_id text,
  reflection_text text,
  created_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_sim_responses_session
  ON public.pd_simulation_responses(session_id, simulation_id, created_at);

-- RLS Policies
ALTER TABLE public.pd_simulations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pd_simulation_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read live simulations"
  ON public.pd_simulations FOR SELECT
  USING (status = 'live');

CREATE POLICY "Public insert responses"
  ON public.pd_simulation_responses FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users read own responses"
  ON public.pd_simulation_responses FOR SELECT
  USING (true);
-- Seed China Simulation 1: "The Workbook"
-- Source: Codex-produced content package (china-the-workbook.json)
-- Run AFTER 20260330_create_simulations.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'a1b2c3d4-0001-0001-0001-000000000001',
  'china-001',
  'The Workbook',
  'A parent arrives at your classroom with a thick supplementary workbook and a request. What looks like overreach might be something else entirely.',
  'It''s October at Maple Leaf International School, Shanghai. You''ve been Haoyu''s homeroom teacher for six weeks. This morning, his mother is waiting outside your classroom before school with a paper bag.',
  '[
    {
      "name": "You",
      "role": "2nd-year homeroom teacher, Maple Leaf International School, Shanghai",
      "description": "You trained in the UK, US, or Australia. You teach Year 4. You care about your students and want good relationships with parents, but you are still figuring out the norms here."
    },
    {
      "name": "Mrs. Zhang",
      "role": "Mother of Haoyu",
      "description": "She was a middle-school math teacher in Nanjing for 12 years before her husband''s job moved the family to Shanghai. She left teaching to focus on Haoyu''s education. She communicates primarily through WeChat, is warm but formal, and sees herself as your educational partner, not your client."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A classroom. Morning. Coats on hooks, math journals stacked on desks. Your WeChat notification count reads 14.",
        "It''s October at Maple Leaf International School. You''ve been Haoyu''s homeroom teacher for six weeks. He''s a quiet, diligent student. He always finishes his work early, keeps everything neat, and rarely raises his hand unless called on. His English is strong. He has a small, tight friend group.",
        "You''ve met Mrs. Zhang once, briefly, at the welcome night. She was polite, asked detailed questions about your math curriculum, and left you with the impression that education is the center of her world.",
        "This morning, she is waiting outside your classroom before school. She''s holding a large paper bag.",
        "\"Good morning, Teacher. I brought something for Haoyu''s learning. May I show you?\"",
        "She pulls out a thick, spiral-bound workbook, a Chinese math supplement organized by topic and filled with worked examples and practice problems. Some pages are already tabbed with colored sticky notes.",
        "\"These match what you are teaching now,\" she says. \"I marked the sections. Maybe you can give some of these as extra practice? Haoyu needs more repetition to be solid.\"",
        "Your school has a clear homework policy: teachers design all homework, no outside materials are assigned, and total homework time for Year 4 should not exceed 30 minutes per night."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Workbook",
      "content": ["What do you do?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Decline politely",
          "text": "\"Thank you so much for thinking of this, Mrs. Zhang. I really appreciate it. At our school, we have a policy that all homework materials come from the curriculum team, so I''m not able to assign outside workbooks. But I''ll make sure Haoyu gets the practice he needs through our regular homework.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Accept and shelve",
          "text": "\"Thank you, Mrs. Zhang, this looks really thorough. Let me take it and have a look through. I''ll see if there''s anything I can incorporate.\" You plan to flip through it politely and then set it aside.",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Accept and use some of it",
          "text": "\"Thank you. This actually looks really well organized. I''ll go through it and pull out some problems that fit what we''re doing this unit.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Zhang nods. \"I understand,\" she says. Her tone is even, but something shifts, a slight formality that wasn''t there a moment ago.",
        "Over the next two weeks, small things change. She stops adding the friendly emoji reactions to your WeChat class updates. When you send a message about Haoyu''s excellent work on a group project, she replies with a single \"Thank you.\" She does not ask any follow-up questions.",
        "At pickup, she greets you with a smile, but the conversations do not go past \"How was today?\" She stops volunteering to help with class events.",
        "You notice Haoyu''s homework has started including extra practice problems on the back, problems that are not from your assignments. When you ask him about it, he says, \"My mom says I should do more.\"",
        "Nothing is wrong, exactly. But the channel has narrowed."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Zhang beams. \"Thank you, Teacher. I highlighted the best sections. If you need more, I can bring the next volume.\"",
        "Two weeks pass. You flip through the workbook. It is actually quite good, but it does not align with your unit''s inquiry-based approach. You set it on your bookshelf and continue with your own materials.",
        "Then Haoyu says something in class: \"My mom asked if you''ve gotten to the fractions part yet. She said those problems are really important.\"",
        "You realize Mrs. Zhang has been tracking which sections you''ve used. She expected this to be a collaborative tool, not a courtesy gift. She interpreted your \"let me have a look\" as a commitment.",
        "That evening, she sends you a WeChat message: \"Teacher, I noticed the homework this week doesn''t include the workbook problems. Should Haoyu do those separately at home?\"",
        "You are now in a harder position than if you had simply declined."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Mrs. Zhang is visibly pleased. \"I knew these would be useful. I can bring the next volume when you''re ready.\"",
        "You pull four problems from the workbook and include them in that week''s homework. They are solid, well-scaffolded, procedurally rigorous. Several students struggle with them, though, because they assume a level of prior drill that your class has not done.",
        "Your curriculum coordinator, Sam, stops by your desk. \"Hey, a parent in your class posted a photo of last night''s homework to the Year 4 WeChat group. A couple of those problems don''t look like they''re from our materials. Are you supplementing?\"",
        "Sam is not angry, but he is clear. \"We spent a long time calibrating the homework load. If parents see outside materials going home, it creates pressure for the other families. Can you keep it in-house?\"",
        "You now need to tell Mrs. Zhang you cannot continue using her workbook after you already started."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective 1: Mrs. Zhang''s View",
      "content": [
        "Mrs. Zhang did not bring the workbook to challenge your authority. She brought it because that is what a good parent does.",
        "In her experience, the parent-teacher relationship is built on a shared mission. The teacher leads in the classroom; the parent reinforces at home. Providing supplementary materials is not overstepping. It is contributing. When her own students'' parents brought her worksheets they had found, she took it as a sign of engagement.",
        "From her perspective, the workbook was a professional offering from one educator to another. She tabbed specific sections because she had studied your curriculum handout and tried to align the problems with your scope and sequence. This took her an evening of work.",
        "She is also navigating her own anxiety. Haoyu is in an international school because she and her husband believe it offers a better path than the gaokao track, but she worries that inquiry-based learning does not always build the foundational fluency her son needs. The workbook is her way of ensuring rigor without rejecting your approach.",
        "When the workbook is declined or ignored, she may not read it as a policy issue first. She may read it as a signal that her expertise and investment are not especially welcome. She pulls back, not necessarily out of anger, but out of self-protection.",
        "The cultural dynamic here is not that one side values learning more than the other. It is that school and home may be trying to support the same child through different assumptions about what partnership should look like."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "Look back at your choice. What assumption about the parent-teacher relationship was driving it?",
      "options": [
        "Parents should support at home but not shape what happens in the classroom.",
        "Accepting the workbook would set a precedent that other parents would expect.",
        "I was trying to protect Mrs. Zhang''s feelings by not refusing directly.",
        "I thought the workbook was a gift, not a professional collaboration offer.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Conference",
      "content": [
        "Three weeks later, it is parent-teacher conference week. You have 15 minutes with Mrs. Zhang and her husband.",
        "Haoyu is performing well academically. His math scores are consistently strong, his writing is improving, and he is kind to his classmates. But there is one area you have been thinking about: he almost never participates in class discussions. When you ask open-ended questions, he waits. When you invite small-group sharing, he lets others go first. He will answer if called on, and his answers are usually good, but he never initiates.",
        "Your school values student voice, collaborative inquiry, and visible thinking. Participation is part of your assessment framework.",
        "How do you approach the conference?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Lead with the participation concern",
          "text": "\"Haoyu is doing really well academically. The one area I''d love to see growth is classroom participation. He has great ideas, but he rarely shares them with the group. I think if he spoke up more, he''d really thrive.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Lead with strengths, then frame participation as one growth area",
          "text": "\"Let me start by saying how much I enjoy having Haoyu in my class. His work ethic is remarkable, his math reasoning is strong, and he''s a really thoughtful friend to his classmates. For next steps, I''m working with him on elaborating his written responses, and I''d also love to gently encourage more sharing in group discussions, which is one of our learning goals this term.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Focus on academics and relationships; do not raise participation",
          "text": "\"Haoyu is doing great. His math is a real strength, his writing is improving every week, and he''s well-liked by his classmates. He''s exactly where I''d want him to be at this point in the year.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Zhang listens carefully. Her husband takes notes. When you finish, there is a pause.",
        "\"He doesn''t participate?\" Mrs. Zhang says. \"He tells us he always listens carefully in class.\"",
        "\"He does listen,\" you say. \"Absolutely. I just think he has a lot to offer and I''d love to hear his voice more.\"",
        "Mr. Zhang speaks for the first time. \"We will talk to him. He should be more active if the teacher asks.\"",
        "You leave the conference feeling like the message landed. But over the next two weeks, something changes. Haoyu starts raising his hand a lot. His contributions are brief, sometimes tangential, sometimes just repeating what another student said. It feels forced.",
        "At home, his parents have clearly told him that the teacher says he must speak more in class. Haoyu is now performing participation. He is not more engaged. He is more anxious."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Mrs. Zhang smiles throughout the strengths portion. She nods vigorously at work ethic and thoughtful friend. When you mention participation as a growth area alongside writing elaboration, she asks, \"What do you mean by participation? He says he always pays attention.\"",
        "You explain the school''s model: sharing thinking aloud, contributing to group discussions, explaining reasoning. \"It''s less about attention. He''s very attentive. It''s more about making his thinking visible to others.\"",
        "Mrs. Zhang considers this. \"In his old school, the teacher talks and the students listen. That is how you show respect. Maybe he needs time to learn this new way.\"",
        "This opens a genuine conversation. You learn that Haoyu practiced oral presentations at home before starting at Maple Leaf. She is not opposed to classroom participation; she just did not know it was valued as assessment, not just as personality.",
        "You and Mrs. Zhang agree on a small plan: you will give Haoyu a thinking partner for discussions, and she will practice sharing your idea at dinner."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "The conference goes smoothly. Mrs. Zhang and her husband leave happy. You feel good about it.",
        "Two months later, report cards go out. Haoyu''s approaches-to-learning section includes a note: \"Haoyu is encouraged to share his thinking more actively in class discussions and collaborative tasks.\"",
        "Mrs. Zhang messages you that evening. \"Teacher, we are confused. At the conference you said Haoyu was doing well. Now the report says he needs to participate more. We feel this was not communicated to us. If there was a concern, why didn''t you tell us when we met?\"",
        "She is right. You avoided the conversation and the report card raised it anyway. The trust cost of deferring was higher than the discomfort of raising it would have been."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective 2: Mrs. Zhang''s View",
      "content": [
        "For Mrs. Zhang, a parent-teacher conference is a status report on a shared project. She comes prepared. She expects the teacher to be direct about problems and specific about next steps.",
        "The word participation does not map neatly to her experience. In the school culture she knows best, a good student is one who listens attentively, completes all assignments thoroughly, and performs well on assessments. Speaking up in class may be something confident students do, but it is not automatically treated as a measure of learning.",
        "She is not resistant to participation as a goal. But she needs to understand it as a skill to be taught, not as something her son is failing to do naturally. When the feedback comes mainly as a concern, it can feel like a character judgment. When it comes as a learning objective with a plan, it feels like partnership.",
        "The cultural dynamic here is about competing models of what learning looks like in public. In one model, articulation is part of learning itself. In another, deep understanding may come before expression. A child in an international school may be living between those models."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "Think about how you framed your feedback. What were you optimizing for?",
      "options": [
        "I wanted to be honest and make sure the parents heard my concern clearly.",
        "I was trying to balance honesty with relationship preservation.",
        "I was worried about how the feedback would be received, so I chose the safest option.",
        "I was trying to respect a different learning culture by not pathologizing quiet students.",
        "Write your own."
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "Dilemma 3: The WeChat Group",
      "content": [
        "December. Your relationship with Mrs. Zhang has settled into a rhythm, though the tone depends on your earlier choices.",
        "She sends you a WeChat message: \"Teacher, some parents and I were talking. We would like to make a small WeChat group, just you and the 5 Chinese parents in our class. We can share information, ask questions about homework, and help with translations when other parents need it. It would be easier than emailing the whole class. What do you think?\"",
        "Your school does not have a policy against teacher-parent WeChat groups, but you know they can become consuming. Some teachers are in many parent groups and answer questions until late at night. Others refuse all groups and communicate only through the school portal.",
        "How do you respond?"
      ],
      "choices": [
        {
          "id": "choice_3a",
          "label": "Decline the group",
          "text": "\"Thank you for thinking of this, Mrs. Zhang. I really appreciate the offer. I think the best way for me to communicate with all families is through our class newsletter and the school portal, that way everyone gets the same information. But please always feel free to message me directly if you have a question about Haoyu.\"",
          "next": "consequence_3a"
        },
        {
          "id": "choice_3b",
          "label": "Accept the group",
          "text": "\"That sounds like a great idea. I''d love to be more connected with Haoyu''s family and the other Chinese families. Let''s set it up. I''ll do my best to check in regularly.\"",
          "next": "consequence_3b"
        },
        {
          "id": "choice_3c",
          "label": "Counter-propose",
          "text": "\"I love the idea of a smoother channel, and I want to be accessible. What if we made it a group for all the class parents, not just the Chinese families? That way it becomes the class communication channel, and bilingual parents can help bridge when needed. I''d also suggest a check-in window so it doesn''t become overwhelming for anyone.\"",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Consequence 3A",
      "content": [
        "Mrs. Zhang replies with a polite thumbs-up emoji. That is it.",
        "The Chinese parents create a group without you. You hear about it secondhand. You have maintained your boundaries, but you have also missed an opportunity.",
        "The Chinese parents now coordinate their concerns among themselves and bring them to you collectively, which sometimes feels like a united front rather than individual questions.",
        "In January, you learn that Mrs. Zhang organized a group purchase of supplementary workbooks for the Chinese students. She did not bring you one this time."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Consequence 3B",
      "content": [
        "The group starts well. Parents share photos of student work, ask about field trip logistics, and help each other translate the weekly newsletter. Mrs. Zhang becomes the informal moderator, and she is good at it.",
        "By week three, the messages are constant. Questions come in at 9 p.m., 10 p.m., 11 p.m. You are spending 30 to 40 minutes per night on the group. You start dreading the notification sound.",
        "But the relationships are undeniably better. When you need parent volunteers, the Chinese families sign up first. When there is a curriculum change, you can explain it once in the group and Mrs. Zhang helps translate for the parents whose English is weaker.",
        "You are more connected and more exhausted."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Consequence 3C",
      "content": [
        "Mrs. Zhang pauses before replying. \"A whole-class group? I think that could work. But some of the Chinese parents are shy about their English.\"",
        "You suggest that the group can be bilingual, English and Chinese both welcome, and that bilingual parents could help bridge. She likes this idea. You set up the group with a clear description and a check-in window.",
        "The first week, most families join. The Chinese parents are the most active. A few Western parents post occasionally. It is not perfectly balanced, but it is functional.",
        "The key moment comes when a non-Chinese parent asks a question about the math homework, and Mrs. Zhang answers it before you do, accurately, and with a helpful example. You have created a space where her expertise has value.",
        "It is not perfect. You still need to manage boundaries around timing and scope. But the channel is working."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Perspective 3: Mrs. Zhang''s View",
      "content": [
        "In many urban Chinese school contexts, parent messaging groups on WeChat function as ordinary school-home coordination. Parents use them for reminders, homework clarifications, photos, and quick questions. A group channel can therefore feel less like special access and more like the normal structure of responsible involvement.",
        "When Mrs. Zhang proposes a smaller group, she is not necessarily trying to exclude other families. More likely, she is starting from the parents she already knows well, the ones who share a language and are most likely to participate actively. From her perspective, a smaller channel may feel practical rather than political.",
        "At the same time, a teacher in an international school has reasonable concerns: equity, workload, inconsistent messaging, and the possibility that one communication channel quietly becomes the real classroom infrastructure.",
        "The tension is not really about WeChat itself. It is about what school-home partnership is supposed to look like, how visible that partnership should be, and who bears the cost of keeping it running."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection 3",
      "prompt": "What were you protecting when you made your choice?",
      "options": [
        "My personal time and boundaries.",
        "Equity. I did not want a subset of parents to have special access.",
        "The relationship with Mrs. Zhang and the Chinese families.",
        "My school''s communication norms and expectations.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Display the learner''s three choices in sequence.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised three cultural dimensions that shape many parent-teacher interactions in a Chinese international-school context.",
            "Learning Philosophy: Mrs. Zhang is operating from a model of learning that treats effort, diligence, and secure mastery as central. Your school likely operates from a model that emphasizes inquiry, articulation, and visible thinking. These are not mutually exclusive values, but they can produce friction when they are not made explicit.",
            "Parent-Teacher Communication: Research on Chinese parents in British schools found a recurring pattern where parents offered partnership through detailed curriculum engagement and teachers sometimes interpreted the same moves as pressure or interference. The result was not necessarily open conflict, but parallel tracks.",
            "Homework and Praise: The workbook represents a specific belief that fluency comes from practice, and practice often means sustained repetition. In many Chinese educational contexts, repetition is not understood as the opposite of understanding. It is one route toward secure mastery. The emphasis on understanding over drilling can therefore read, to some parents, as insufficiently serious unless the school explains how understanding is built and checked."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Ran, A. (2001). Travelling on parallel tracks: Chinese parents and English teachers.",
            "Li, J. (2005). Mind or virtue: Western and Chinese beliefs about learning.",
            "Jin, L., and Cortazzi, M. (1998). Dimensions of dialogue: Large classes in China."
          ]
        }
      ],
      "finalPrompt": "If you could go back to the first moment, Mrs. Zhang standing outside your classroom with a paper bag, what would you say now, and why?"
    }
  }',
  ARRAY[1, 2, 5],
  20,
  1,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;

-- Make the simulation live immediately
UPDATE public.pd_simulations
SET status = 'live'
WHERE id = 'a1b2c3d4-0001-0001-0001-000000000001';
-- Seed China Simulation 2: "The Silent Mathematician"
-- Source: CHINA_SIM2_THE_SILENT_MATHEMATICIAN.md
-- Dimensions: D1 (Learning Philosophy), D3 (Exam Culture), D4 (Classroom Dynamics)
-- Run AFTER 20260330_create_simulations.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'a1b2c3d4-0001-0002-0001-000000000001',
  'china-001',
  'The Silent Mathematician',
  'A student solves every problem correctly but refuses to explain his thinking. What looks like evasion might be something else entirely.',
  'It''s May at your international school in Shanghai. You''ve been teaching an inquiry-based unit on fractions for three weeks. Your goal is conceptual flexibility — you want students to see fractions, not just memorize procedures. Wei finishes the problem in two minutes.',
  '[
    {
      "name": "You",
      "role": "5th-grade math teacher, international school, Shanghai",
      "description": "You trained in a Western inquiry-based tradition. You believe math is about understanding how to think, not just getting the right answer. You''re invested in your students'' conceptual development and frustrated when correct answers arrive without explanation."
    },
    {
      "name": "Wei",
      "role": "Student, 5th grade, age 10",
      "description": "Quiet in whole-class settings but animated with close friends. He''s not shy — he''s strategic. He solves problems with methods you didn''t teach, gets them right, but refuses to explain his thinking. His parents hired a tutor who coaches him ahead of the curriculum. Wei understands that staying quiet is safer than drawing attention to the gap between his home learning and his classroom learning."
    },
    {
      "name": "Mr. Liu",
      "role": "Father of Wei, software engineer",
      "description": "He measures success by marks and test performance. He sees education as a race with visible standings. He hired the tutor not to supplement school but to ensure competitive advantage. His communication with teachers is formal and infrequent."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A classroom, late morning. Twelve students bent over a worksheet. The problem: ''How many different ways can you make the fraction 3/5 using two different fractions? Show your thinking.''",
        "It''s May. You''ve been working on this unit for three weeks — starting with area models, moving to number lines, now asking students to decompose fractions in multiple ways. The goal is conceptual flexibility. You want them to see fractions, not just memorize the procedure.",
        "Most students are using the strategies you''ve taught: drawing models, finding equivalent fractions systematically. Slow, visible, debuggable thinking.",
        "Wei is done in two minutes. He''s written four correct decompositions. The last one is elegant: 1/3 + 4/15. It uses a least common denominator your class hasn''t discussed yet.",
        "You walk over. ''Wei, these are all correct. How did you figure out that last one?'' Wei looks up, then looks down. ''I just... knew it.'' His tone isn''t defiant. It''s cautious. He''s clearly done the math, but he''s not going to walk you through it.",
        "Later, you ask him to share with the class. ''Pick your favorite one and explain how you thought about it.'' Wei shakes his head. ''I don''t want to.'' Other students raise their hands, excited to share. You move on. But you keep thinking about that decomposition.",
        "After school, you check his file. His previous math teachers noted the same pattern: ''Completes work accurately. Rarely explains his reasoning. Quiet in discussions.''",
        "That evening, you message Mr. Liu through WeChat asking if anything at home is helping Wei with math. Mr. Liu''s reply comes the next morning: ''Thank you, teacher. Wei is working with a tutor twice a week. He needs extra support to stay ahead.''",
        "You read between the lines. The tutor isn''t filling a gap — he''s drilling ahead. Wei is learning methods before he''s supposed to learn them. And he''s staying quiet in class because drawing attention to his knowledge would expose the gap between his home learning and his classroom learning."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Decomposition",
      "content": ["What do you do about Wei''s refusal to explain his last decomposition?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Press him to explain",
          "text": "You ask Wei again, this time more firmly but kindly. ''Wei, I know you can do it. Walk me through your thinking about that 1/3 + 4/15. Just tell me how you decided on those numbers. The class will learn from it.''",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Let it go",
          "text": "You move on. Wei completes his work accurately. He''s learning, even if he''s not sharing. You focus your classroom inquiry time on students who are willing to think aloud.",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Turn it into a class inquiry",
          "text": "You take Wei''s decomposition and turn it into a teaching moment for the whole class. ''Someone found that 3/5 can be made with 1/3 and 4/15. Can the class figure out how this works?'' You invite discovery, not confession.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Wei stares at his paper. His jaw tightens slightly. ''I don''t know,'' he says quietly. ''I just saw it.''",
        "You''re now in front of the class, and Wei is becoming visibly uncomfortable. A few students are watching. You drop it, but the moment has shifted. Wei has drawn attention to himself — exactly what he was avoiding.",
        "For the rest of the week, Wei is noticeably more withdrawn. He finishes his work but doesn''t raise his hand. When you call on him directly, he gives minimal responses. He''s protecting himself by becoming smaller.",
        "At recess, you overhear him with his friends. He''s joking, confident, animated. But in your classroom, he''s folded inward.",
        "That evening, you get a message from Mr. Liu: ''Wei mentioned that you asked him to explain something in front of the class and he was not comfortable. Can he just focus on doing the work instead of talking?''"
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "You continue the unit. Wei does all the worksheets, gets high scores on quizzes, completes the unit assessment with a solid A. He''s learning — but silently, and at his own pace.",
        "By the end of the unit, you''ve mostly stopped noticing his clever solutions. He''s just one more high-performing quiet student. You have 28 students; the ones who are struggling or disruptive take your attention.",
        "Three weeks later, it''s time for parent-teacher conferences. Mr. Liu opens with: ''Wei''s tutor says he''s ready for algebra. Is this class moving too slowly?''",
        "You''re taken aback. Your unit has been rigorous. But you realize you actually don''t know what Wei can do, because you''ve never asked him to explain, justify, or reason through ambiguity out loud. He''s just a high-performing silent student in your record book.",
        "You''re now defending the pace of your curriculum to a parent who thinks his child is bored, and you don''t have much evidence that Wei is actually engaged or challenged."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "You write Wei''s decomposition on the board the next day: ''3/5 = 1/3 + 4/15.'' ''This is interesting,'' you say. ''Someone figured out that you can make three-fifths using one-third and four-fifteenths. Our other ways used fifths or tenths. This one jumps to different denominators. Why might that work?''",
        "The class sits with it. A few students pull out their number lines. Someone asks, ''What''s the same about 3, 5, and 15?'' Another: ''Is it about the times table? Like, 5 times 3 is 15?''",
        "You''re guiding them toward discovering why common denominators matter, using Wei''s elegant solution as the hook. Wei hasn''t had to explain. The class has done the reasoning. And Wei''s thinking has become classroom knowledge.",
        "At the end of class, Wei lingers. ''That was... how I thought about it,'' he says quietly. ''I know,'' you say. ''That''s why I used it. Your thinking helped everyone understand something deeper.''",
        "He nods. Something has shifted — you''ve validated his math without requiring public performance."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective 1: Wei''s Point of View",
      "content": [
        "Wei is not refusing to explain out of defiance or shyness. He''s doing something much more sophisticated: managing two different math universes, and staying quiet to keep them separate.",
        "At the tutor''s place — twice a week, Monday and Thursday — he learns algebra, advanced fraction decomposition, and competition math strategies. His tutor drills him with methods and answer keys. Wei''s job is to understand the methods and execute them accurately.",
        "At school, the unit is about discovery. You''re asking students to invent strategies, to try things that might not work, to explain their thinking. This is genuinely different from what Wei experiences at the tutor''s place.",
        "Wei understands, intuitively, that explaining his tutor-taught method in class would signal that he''s ahead. It would make him visible in a way that feels risky. Standing out as someone with unauthorized knowledge feels like breaking a rule he''s not sure about.",
        "Also, Wei genuinely prefers being quiet. He''s not broken — he''s just different. He likes thinking alone. Forcing explanation feels like a personality change, not a learning move.",
        "The cultural dynamic: Ran (2001) documents how Chinese educational culture emphasizes procedural mastery first, conceptual understanding second. The tutor operates in this model — drill, master, understand. Your inquiry-based unit inverts this: conceptual first, then procedures. Wei is living in both worlds simultaneously, and he''s chosen to keep them separate.",
        "Li (2005) argues that in Chinese learning culture, the learner''s effort and diligence are valued more than the learner''s voice. You''re asking Wei to perform his thinking. In his home culture, demonstrating mastery is more respected — and less risky — than demonstrating process."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "Why do you think Wei refused to explain his thinking?",
      "options": [
        "He was being difficult or evasive.",
        "He didn''t want to stand out or draw attention.",
        "He genuinely didn''t know how to explain it, even though he got the answer.",
        "He was protecting something — maybe his relationship with his parents or his tutor.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Tutoring Discovery",
      "content": [
        "A week later, at a professional learning community meeting, another teacher mentions that several families in your cluster are using the same tutor — a college student who specializes in ''curriculum acceleration.''",
        "Wei isn''t the only student being coached ahead. But Wei is the only one you''re noticing, because his silence contrasts so sharply with your unit''s inquiry goals.",
        "What do you do?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Raise it with Mr. Liu",
          "text": "You email Mr. Liu. ''I appreciate your investment in Wei''s math education. I''ve learned that Wei is working with a tutor, and I wanted to understand how that fits with our classroom unit. It might help if we coordinated on timing and approach so the learning builds coherently. Could we discuss?''",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Tell Wei to stop",
          "text": "You pull Wei aside privately. ''I know you''re working with a tutor ahead of our unit. I understand your parents want you to get ahead, but it''s making it harder for you to engage in class the way I''m asking. Could you talk to your parents about pausing the tutor until we finish this unit?''",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Adapt your teaching",
          "text": "You don''t address the tutoring directly. Instead, you redesign your approach: problems with multiple valid strategies, more choice and differentiation, and more opportunities for students to work at their own level. You stop insisting on explanation; you value it when it happens, but don''t require it.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mr. Liu responds the same day: ''Thank you for your communication. Wei''s tutor is his private education. It does not affect his school work. His tutor helps him prepare for advanced math. This is what we want for his future. I don''t see a problem.''",
        "The subtext is clear: This is not negotiable. My son''s education is my business. Stay in your lane.",
        "You''ve raised the issue and been shut down. The relationship with Mr. Liu has shifted. He''s not hostile, but he''s firm. He''s also unlikely to tell you anything else about Wei''s out-of-school learning.",
        "In the classroom, nothing changes. But you''re more aware of the tension, and it''s harder to teach the unit the way you designed it when you know that half your accelerated students are being prepped by the same tutor.",
        "You find yourself lowering the cognitive demand of your activities slightly — because the gap between what you''re teaching and what the tutored students already know feels too wide."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Wei nods when you explain. He doesn''t argue. He just says, ''Okay.''",
        "That evening, his father sends you an email: ''Wei told me you asked him to stop his tutor. We hired the tutor because we believe he needs more support in math. Stopping the tutor would be a mistake for his learning. I do not understand why the school would discourage this. Can we discuss at conference?''",
        "Now you''re in a conflict with the parent over a boundary the child isn''t even responsible for negotiating. You''ve asked Wei to manage his parents, and he''s not equipped to do that.",
        "Moreover, the tutor continued. Mr. Liu simply didn''t stop the sessions. Wei now knows that you and his father are not aligned, and he''s caught in the middle. He becomes even quieter in class."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "You redesign the unit. Instead of a single sequence of activities, you build in choice and differentiation. You offer multiple pathways to the same learning goals.",
        "For fractions, you offer: a discovery path (find all the ways to make 3/5 using two fractions), a design path (create a fraction story problem that requires decomposing 3/5), and an analysis path (here are five decompositions of 3/5 — which is most efficient? Why?).",
        "Wei chooses the analysis path — it lets him work with mathematical ideas without explaining his thinking aloud. Other students find their own entry points.",
        "By the end of the unit, you''ve learned that Wei can decompose fractions in multiple ways, compare strategies, and analyze efficiency. He hasn''t explained his process, but you''ve found other ways to assess understanding.",
        "Mr. Liu''s email at conference time is neutral: ''Wei did well in this unit. Thank you.'' You haven''t addressed the tutoring directly, but you''ve changed the ecology so that tutored and non-tutored students can coexist without the tutoring becoming a pressure point."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective 2: Mr. Liu''s Point of View",
      "content": [
        "Mr. Liu is not paranoid or Tiger-parenting out of aggression. He''s doing what he believes is responsible parenting in a high-stakes educational environment.",
        "He watched the gaokao system evolve. He knows the data: students who have tutoring during elementary school are significantly more likely to perform well on competitive exams later. In Shanghai, roughly 75% of primary students have after-school tutoring. Not having it is the outlier.",
        "He also knows that international school offers something different from the gaokao track — but he doesn''t believe the alternative is lower rigor. International school with strong math preparation. Not just learning, but advantage.",
        "The tutor isn''t meant to replace your classroom. She''s insurance. She''s a way to ensure Wei has options later — gaokao path if needed, but also advanced placement in any school, competition math if he shows interest, or simply being the strongest student in his year.",
        "From Mr. Liu''s perspective, when you raise the tutoring as a ''coordination'' issue, you''re implicitly asking him to slow down his son''s learning to match classroom pace. You''re asking him to optimize for your inquiry unit rather than for Wei''s long-term trajectory.",
        "The cultural dynamic: Ran (2001) describes how Chinese parents see education as a long-term competition with visible standings. The gaokao isn''t a test that happens at age 18 — it''s a destination that shapes every decision from age 6. The concept of 补习班 (buxiban — cram school/tutoring class) is so normalized that not tutoring a high-performing child is considered neglectful. Mr. Liu isn''t anxious; he''s being responsible by his culture''s definition."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "When Mr. Liu said the tutor was Wei''s ''private education,'' what did he mean?",
      "options": [
        "He was asserting that his parenting choices are beyond the school''s business.",
        "He was implying that what happens outside school shouldn''t affect what happens inside school.",
        "He was defending an investment he''s made in his son''s future.",
        "All of the above.",
        "Write your own."
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "Dilemma 3: The Grade and the Pushback",
      "content": [
        "Unit assessment day. The assessment includes three parts: (1) procedural problems (solve and explain), (2) a decomposition task, and (3) a reflection question.",
        "Wei''s scores: Part 1: 18/20 (all problems correct, explanations are brief). Part 2: 15/15 (elegant solutions, no explanation of thinking). Part 3: 5/8 (his reflection is surface: ''It helps me solve problems faster.'') Total: 38/50. That''s a B+, 76%.",
        "He got the math right. The explanations and reflection are where he lost points.",
        "Two days after grades go home, Mr. Liu sends you an email: ''Wei got a B+ on the math unit. I do not understand this grade. Wei solved every problem correctly. His math is excellent. Why is he marked down? He knows all the answers. This grade does not reflect his learning.''",
        "He''s right that Wei solved the math correctly. But for you, showing your thinking IS the learning. How do you reply?"
      ],
      "choices": [
        {
          "id": "choice_3a",
          "label": "Defend your grading",
          "text": "''Thank you for your email. Wei''s math accuracy is excellent, and that''s reflected in his problem-solving score. However, the unit assesses three things: accuracy, reasoning, and mathematical reflection. In an inquiry-based program, students must be able to explain and justify their thinking — that''s a core learning goal, not extra credit. Wei''s explanations are minimal, which is why his overall grade is a B+.''",
          "next": "consequence_3a"
        },
        {
          "id": "choice_3b",
          "label": "Offer additional context",
          "text": "''Thank you for writing. You''re right that Wei solved the problems correctly — his accuracy is excellent. In this unit, we''ve been working on helping students explain their mathematical thinking. That''s part of learning to think mathematically, not just get right answers. Would it help if we set up a plan for him to practice explaining in smaller, lower-pressure settings? I''d also love to hear more about how the tutoring is going — we might be able to coordinate.''",
          "next": "consequence_3b"
        },
        {
          "id": "choice_3c",
          "label": "Reframe the conversation",
          "text": "''Thank you for your email. Let me be direct about something: I think we might be measuring different things. You''re looking at what Wei knows. I''m assessing what he can communicate. Both matter. A B+ means Wei is a strong mathematician, but he''s still building the skill of explaining his reasoning. This isn''t a weakness — it''s the next frontier for him. Can we talk about what success looks like for the rest of the year?''",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Consequence 3A",
      "content": [
        "Mr. Liu doesn''t reply. Silence.",
        "Three weeks later, it''s parent-teacher conference time. He arrives with a very different energy — polite, but formal. He says he''s hired a new tutor who specializes in ''writing and explaining in English,'' because he believes that''s where Wei is being marked unfairly.",
        "You realize your email, intended as an explanation, was received as a judgment. You''re now in a position where Mr. Liu is allocating more tutoring resources to address a ''deficit'' that you''ve highlighted — except the deficit is something you value (explaining thinking) and he doesn''t think should be a grade-determining factor.",
        "The relationship with this parent is now transactional, not collaborative."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Consequence 3B",
      "content": [
        "Mr. Liu replies: ''I appreciate your willingness to work together. However, I do not think tutoring should be coordinated with school. The tutor is helping Wei prepare for his future. The school is helping him with the international curriculum. They are separate.''",
        "You''ve tried to build a bridge and been politely refused. But the tone is less hostile than if you''d defended the grade. You''ve acknowledged his investment and his perspective, even though you haven''t changed your grading.",
        "He accepts the B+ as final. But he maintains the boundary: the tutoring stays separate, and he''s not interested in how your unit and his tutoring might reinforce each other.",
        "You end the year with Wei still quiet in class, still producing accurate work, still not explaining. His father has Wei''s trajectory mapped out on a different timeline. Your inquiry unit is one point on a longer arc."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Consequence 3C",
      "content": [
        "Mr. Liu reads this and pauses. He writes back: ''You say Wei knows the math but needs to communicate better. I think this is reasonable. At home, we will also encourage him to explain his thinking. This is good for his future, especially if he goes to a university outside China.''",
        "Something has shifted. You''ve explicitly separated ''what he knows'' from ''what he can communicate'' — both accurate framings from different perspectives. You''ve also implied that explaining thinking is valuable for an international future, which aligns with Mr. Liu''s long-term goals.",
        "At conference, he''s still formal, but the conversation is different. He asks: ''What can we do at home to help Wei practice explaining?'' You suggest low-pressure strategies: explaining to his tutor, explaining to a friend, writing down his thinking without being perfect.",
        "Wei''s next unit assessment shows slightly more explanation. Not a dramatic change, but movement. Wei is starting to see articulating his thinking as a skill to build, not a threat to his efficiency."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Perspective 3: Wei''s Point of View Revisited",
      "content": [
        "Wei knew the math. He solved every problem correctly, the way his tutor taught him and the way he''d figured out on his own. When he got the B+, he didn''t think he''d made a calculation error. He thought: My teacher is saying my thinking is wrong.",
        "But his thinking wasn''t wrong — it was different. His tutor teaches solution methods. His teacher asks for explanation. These are not the same thing.",
        "Wei is 10 years old. He knows his father hired the tutor to keep him ahead. He knows his father wants high marks. When his mark is a B+, even though he got all the problems right, Wei reads this as: I''m not doing what the school wants.",
        "If you defend the grading, Wei assumes there''s something wrong with his thinking that even being correct can''t fix. He becomes more withdrawn.",
        "If you offer additional context and ask him to practice explaining, Wei might try — but he''s doing it to please you and his father, not because he understands why it matters.",
        "If you reframe explaining as a skill (not a judgment of his thinking), something changes. Wei can practice explaining the same way he practices piano. It''s a skill, not a character trait. And skills can be built.",
        "The cultural dynamic: Li (2005)''s research on ''virtue orientation'' meets the reality of modern tutoring culture. Li argues that in Chinese learning culture, effort and diligence are valued above innate ability. But contemporary parents like Mr. Liu operate from a different frame: results are valued most. Wei is caught between his father''s results-orientation and his teacher''s skill-orientation. Neither adult is wrong, but Wei''s only recourse is silence."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection 3",
      "prompt": "What was the fundamental disagreement between you and Mr. Liu about what grade Wei ''deserved''?",
      "options": [
        "You measure learning by accuracy; he measures it by process.",
        "You measure learning by communication; he measures it by results.",
        "You expect him to learn like an international school student; he expects him to be prepared for any system.",
        "You see explaining as essential; he sees it as nice-to-have.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Display the learner''s three choices in sequence.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised three cultural dimensions that shape the experience of high-performing students in international schools in China.",
            "Learning Philosophy (D1): Wei was living in two different learning models simultaneously. At the tutor''s place, the model was procedural mastery → fluency → confidence. At school, the model was conceptual exploration → multiple strategies → articulation. Neither model is superior. But a student who''s optimized for one doesn''t automatically thrive in the other. Your inquiry unit asked Wei to explain, discuss, and justify — precisely the behaviors his tutor didn''t require and his home culture didn''t emphasize.",
            "Exam Culture & System Structure (D3): Mr. Liu''s hiring of a tutor wasn''t paranoid or excessive — it was a rational response to a system where early advantage compounds. Even in international school, parents like Mr. Liu are hedging: ''We''re choosing a different system, but our child should have options.'' Your inquiry-based unit is genuinely valuable, but from Mr. Liu''s perspective, it''s an alternative form of rigor, not a replacement for the kind of rigor that produces measurable advantage. The 补习班 (buxiban) exists because Asian parents have learned that school + tutoring = security.",
            "Classroom Dynamics (D4): Wei''s silence in class wasn''t passivity — it was strategy. He was managing identity: the quiet, focused student at school; the advanced, confident student at the tutor''s place. Forcing him to explain would have collapsed these identities into one, making visible the gap between what he knew and what he was supposed to know. By adapting your unit to create multiple pathways, you gave him choice. By reframing explanation as skill-building rather than proof of thinking, you changed what silence could mean."
          ]
        },
        {
          "title": "The Research Behind This",
          "content": [
            "Ran, A. (2001). ''Travelling on parallel tracks: Chinese parents and English teachers.'' Educational Research, 43(3), 311-328.",
            "Li, J. (2005). ''Mind or virtue: Western and Chinese beliefs about learning.'' Current Directions in Psychological Science, 14(4), 190-194.",
            "The 补习班 (buxiban/cram school) phenomenon is documented extensively in Chinese education research as a rational adaptation to perceived system pressures, not a cultural pathology."
          ]
        }
      ],
      "finalPrompt": "You started this simulation wanting to teach inquiry-based math. You ended it navigating tutoring, parental expectations, and a quiet student''s hidden knowledge. Looking back at all three dilemmas, what would you do differently if you could start over? Would you change anything about your initial approach to Wei''s silence, the tutoring discovery, or the grade conversation? What would you prioritize?"
    }
  }',
  ARRAY[1, 3, 4],
  20,
  2,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;

-- Make the simulation live immediately
UPDATE public.pd_simulations
SET status = 'live'
WHERE id = 'a1b2c3d4-0001-0002-0001-000000000001';
-- Seed China Simulation 3: "Between Two Worlds"
-- Source: CHINA_SIM3_BETWEEN_TWO_WORLDS.md
-- Dimensions: D4 (Classroom Dynamics), D5 (Homework & Praise), D6 (Cultural Identity)
-- Run AFTER 20260330_create_simulations.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'a1b2c3d4-0001-0003-0001-000000000001',
  'china-001',
  'Between Two Worlds',
  'A student with Chinese heritage publicly refuses a cultural activity. What looks like disrespect might be something much harder to name.',
  'It''s late January at your international school. The Chinese New Year assembly is in three weeks, and Ms. Chen has coordinated a school-wide lantern-making activity. Most students are into it — it''s tactile, creative, no exam pressure. But Mei, fourteen, is sitting with her arms crossed.',
  '[
    {
      "name": "You",
      "role": "Advisory class teacher, Years 8-10",
      "description": "You''re in your fourth year at this school. You care about your students as whole people, not just learners. You have a professional, warm relationship with your colleagues and you don''t want that to fracture. You''re watching a situation unfold in real time that involves both a student you care about and a colleague you respect."
    },
    {
      "name": "Mei",
      "role": "Student, Year 9, age 14",
      "description": "Born in Chengdu, moved to an international school at age 7. Fluent in English, conversational but hesitant in Mandarin. Has lived in an expat bubble for most of her formative years. She''s sharp, funny with her friends, articulate about her ideas — but increasingly hostile to anything framed as ''Chinese'' in the school context. Her resistance isn''t authentic cultural rejection; it''s self-protection against the feeling of being trapped between two identities and fully belonging to neither."
    },
    {
      "name": "Ms. Chen",
      "role": "Mandarin language and culture teacher",
      "description": "20+ years in education (first 15 in the PRC, now 5 at international schools). Genuinely passionate about Chinese cultural transmission and sees it as part of her mission to keep her students connected to their heritage. She takes Mei''s public refusal personally — it reads to her as disrespect for something she''s devoted her career to protecting. She''s not authoritarian; she''s wounded."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A classroom during advisory time. Lantern-making materials spread across tables — colored paper, glue sticks, string. Students seated in small groups, mostly engaged, laughing at each other''s creations. Ms. Chen is circulating, warm and present.",
        "It''s late January. The Chinese New Year assembly is in three weeks, and Ms. Chen has coordinated a school-wide activity where students create silk lanterns — part cultural activity, part art lesson, part heritage celebration. Most students are into it.",
        "Mei is at a table in the back. Her friends are folding and gluing. She''s not. She''s sitting with her arms crossed, wearing an expression somewhere between bored and angry.",
        "Ms. Chen approaches the table. ''Mei, come on — this is the fun part! Make a lantern. You can choose any colors you want.''",
        "Mei doesn''t look up. ''I''m not doing this.'' ''It''s not difficult,'' Ms. Chen says, her tone gently insistent. ''Just a bit of folding and—''",
        "''I said no.'' Mei''s voice is louder now. Several students at nearby tables glance over. ''This isn''t my culture anyway. I don''t see why we have to do it.''",
        "There''s a silence. The activity doesn''t stop, but energy has shifted. Ms. Chen''s face flushes. She opens her mouth — searching for a response.",
        "You''re standing at the front of the room with a pile of lantern templates. All eyes are tracking this moment. What you do next will be witnessed and interpreted by the whole group."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Public Refusal",
      "content": ["What do you do?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Intervene publicly and firmly",
          "text": "You move quickly to Mei''s table. Your tone is calm but non-negotiable: ''Mei, I need you to step outside for a moment.'' You address the group without blame: ''Everyone keep working on your lanterns — we''ll be right back.'' You remove her from the room, away from the audience. It establishes a boundary without publicly shaming her or Ms. Chen.",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Move in privately, right now",
          "text": "You catch Ms. Chen''s eye with a small gesture that says I''ve got this, and approach Mei''s table casually. You lower yourself to her eye level, voice quiet: ''Mei, take a break from the lantern if you need to, but your arms need to uncross. Let''s figure out what''s going on here after class. For now, just sit with your group.'' You''re not forcing participation, but you''re not leaving the moment unaddressed.",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Let the moment breathe; continue the activity",
          "text": "You don''t interrupt. You let Ms. Chen respond, and you monitor the room. If this becomes a bigger blow-up, you''ll step in. But for now, you''re giving Mei space to exist in her resistance without it becoming a spectacle. You''re not reinforcing it, but you''re not crushing it either.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Outside the classroom, Mei''s defensiveness hardens. ''What? I''m not doing some random culture activity.''",
        "''That''s not actually what this is about,'' you say, ''and we both know that. This is the second time this month you''ve refused to participate in something connected to China. I''m not asking if you want to do the lantern. I''m telling you that the way you handled it — the volume, the comment, the arms crossed — isn''t okay in my classroom, regardless of the content.''",
        "Mei''s eyes get hot. ''Why does everyone care so much if I do this stupid lantern?''",
        "''Because you made it everyone''s problem in that moment. But also because Ms. Chen is noticing a pattern, and so am I. And I want to understand what''s driving it before we all end up frustrated with each other.''",
        "You''ve been direct and fair. But Mei goes back into the room feeling corrected, not heard. She sits out the rest of the lantern activity, arms still crossed. Ms. Chen is grateful that you intervened, but Mei is more entrenched.",
        "That evening, Mei''s mother emails you: ''Mei says you made her feel bad about the lantern activity. She feels like the school is trying to force her to be Chinese. Can we talk?''"
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "After class, Mei is quieter but not angrier. You''ve given her a way to save face in front of her friends.",
        "You catch her in the hallway afterward. ''So what was that about?'' ''I don''t know. I just don''t want to do stuff like that.'' ''Stuff like making art projects?'' ''Stuff like being told I have to participate in being Chinese. It''s annoying.''",
        "This is the first time Mei has said it plainly, and you hear it. She''s not rejecting the activity as much as rejecting the assumption that because she was born in China, this cultural activity should automatically feel like hers.",
        "Ms. Chen passes you in the hallway later. ''Thank you for handling that. Do you think you can talk to her? She needs to understand that this isn''t optional.''",
        "You''ve bought yourself space and information. Ms. Chen feels supported. Mei feels less publicly shamed. But the underlying tension hasn''t been resolved."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Ms. Chen takes a breath. You can see her doing it — a moment of self-regulation. She steps back slightly from Mei''s table.",
        "''Okay,'' Ms. Chen says. Her voice is quieter, the warmth strained but not gone. ''You don''t have to make a lantern. But you do have to sit here with the class without being disruptive. You can read, you can watch, but everyone needs you to be present to the group without commenting.''",
        "Mei rolls her eyes dramatically. You make a note — the eye-roll is performative, audience-aware. She''s playing a part.",
        "The activity continues. Mei sits, ostensibly reading, but clearly fuming. A few of her friends glance at her with concern. Ms. Chen looks hurt and tight for the rest of the period.",
        "By letting it play out, you haven''t escalated. But you also haven''t addressed the pattern. That conversation is still coming — it just didn''t happen in real time."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective 1: Mei''s Internal Experience",
      "content": [
        "Mei''s arms are crossed because the moment Ms. Chen approached her felt like a demand dressed up as an invitation. Make a lantern. This is the fun part. You can choose any colors.",
        "What Mei hears underneath is: You are Chinese. You should want this. Your reluctance is a personal failure. This isn''t Ms. Chen''s intention, but intention and impact aren''t the same thing.",
        "Mei was born in Chengdu. Her first memories are in Mandarin. But she''s been in English-speaking international schools since age 7, and those schools are where she''s built her identity, her friendships, her sense of competence.",
        "When she goes to China to visit family, her cousins call her ''the American girl.'' Her Mandarin is conversational but not fluent. She''s forgotten characters. She doesn''t know slang. She feels fake.",
        "At school, the Chinese cultural activities feel like they''re demanding she prove an identity she doesn''t actually inhabit. It''s not that she rejects China — it''s that she''s exhausted by being asked to perform it, especially in front of an audience that expects automatic emotional investment.",
        "The cultural dynamic: Pollock & Van Reken (1999, 2009) identify ''third culture kids'' as children who grow up in a culture that''s not their parents'' culture of origin and not the culture of their parents'' passport — they develop their own culture, often one of global mobility and intercultural fluency. But this identity can feel unstable, especially in contexts that demand simplicity: Are you Chinese or American?",
        "The answer, for third culture kids, is often: Neither. Both. A third one they''ve created. But schools that celebrate ''heritage'' often unintentionally pathologize this fluidity. Mei''s resistance is a form of identity self-defense. She''s refusing the either/or in order to protect the both/and that is actually her.",
        "Code-switching research (Blanco et al., 2021) shows that repeated demands to perform one cultural identity while suppressing another creates fatigue and resentment, especially in adolescence. Mei isn''t being difficult; she''s exhausted."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "Look back at your choice. What were you responding to in that moment?",
      "options": [
        "Mei''s rudeness to Ms. Chen and the need to enforce classroom norms.",
        "The possibility that Mei''s resistance signals a deeper struggle with her identity.",
        "The need to protect Ms. Chen''s authority and the activity''s integrity.",
        "My uncertainty about whether to prioritize the group dynamic or Mei''s individual experience.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Ms. Chen Comes to You",
      "content": [
        "Two days later, Ms. Chen asks to see you before school. She closes the door of your classroom behind her.",
        "''I need to ask you for help with something,'' she says. Her tone is not angry — it''s something more vulnerable than that. It''s hurt. ''Mei. I keep trying to include her in cultural activities, and she keeps refusing. And now she''s being loud about it, which is affecting other students'' engagement. I''m wondering if you can talk to her.''",
        "She''s not asking you to force Mei to participate. But she''s asking you, implicitly, to deliver a message: You should want to be part of this. You should care about your heritage.",
        "Ms. Chen continues: ''I''ve been teaching for twenty years. And I have to say — this generation of students, the ones who have lived here their whole lives, they''re losing connection to Chinese culture. They''re becoming too Western. And students like Mei, who are actually Chinese — when they reject it, it feels like they''re rejecting everything I''m trying to preserve.''",
        "There''s real pain in this. Ms. Chen isn''t being authoritarian. She''s grieving. But a private conversation where you reinforce her message could backfire, positioning you against Mei, who is dealing with something complicated. How do you navigate this?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Validate Ms. Chen''s frustration; agree to reinforce",
          "text": "''You''re right, and I hear you. The cultural disconnection is real. Let me talk to Mei. I''ll help her understand that participating in these activities matters — for her own identity, and for the message she''s sending to the other students.''",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Reframe Mei''s resistance as complexity, not defiance",
          "text": "''I appreciate you sharing this, and I know how much this work matters to you. But I think what we''re seeing with Mei might not be cultural rejection — it might be something more like identity confusion. She''s caught between two cultures in a way that''s genuinely hard. Before I talk to her, I want to understand what''s driving this. Can I learn more about what''s been happening in your class?''",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Suggest a three-way meeting",
          "text": "''Ms. Chen, I want to help, but I don''t think a one-on-one from me is the right move. What if the three of us sat down together? Mei, you, and me. Not to convince Mei to participate — but to actually understand what''s happening here. It sounds like there''s a real mismatch in what Mei thinks you need from her and what you''re actually trying to offer. Maybe we can close that gap together.''",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "You talk to Mei that afternoon. ''Ms. Chen is concerned about your participation in the lantern activity and some of the other cultural events. And honestly, I think she''s right to be. You''re a smart, thoughtful person, Mei, and I think you''re shutting yourself off from something that could be meaningful to you.''",
        "Mei''s face closes. ''Okay, so now you''re teaming up with her.''",
        "''That''s not what this is. I''m saying — you have a heritage. You''re actually lucky that you have multiple cultures. I think you''re dismissing something because it''s cool to be resistant right now, but you might regret that later.''",
        "Mei is quiet. When she speaks, her voice is small and angry at the same time: ''Everyone acts like being Chinese is just this automatic thing I should want. Like I woke up and decided to reject it. But I didn''t. I just didn''t grow up with it, and now everyone''s mad at me for not feeling it.''",
        "You''ve now confirmed for Mei that the adults in her world are aligned against her. She feels more alone, not less.",
        "Later, her mother reaches out again: ''Mei is really upset. She says both her teachers are pushing her to be someone she''s not. I''m worried about her.''"
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "You sit with Ms. Chen for a longer conversation. ''Can I tell you what I''m noticing? I think Mei''s resistance isn''t about disrespecting you or Chinese culture. I think she''s actually struggling with something more fundamental — which culture is ''hers.'' She was born in China, but she''s been in international schools her whole life. When she''s here, everyone expects her to be the Chinese representative. When she visits China, her cousins think she''s too Western. She doesn''t belong cleanly to either world.''",
        "''And I think the cultural activities, even though they''re well-intentioned, can feel like they''re saying: You must perform the Chinese part of your identity. And she''s kind of stuck because if she doesn''t, she''s ungrateful or disloyal. But if she does, she''s performing something that doesn''t actually feel like hers.''",
        "Ms. Chen listens. ''So what you''re saying is that this is bigger than just participation in a lantern activity.'' ''Much bigger. And if I go to her right now and reinforce that she should want to participate, I think it''ll backfire. It''ll just feel like more adults telling her who she''s supposed to be.''",
        "Ms. Chen nods slowly. ''I didn''t realize it was that deep. I thought she was just being a typical resistant teenager.''",
        "You''ve honored Ms. Chen''s concern, but you''ve also given her a more complex frame. She can now see Mei as struggling rather than defiant. It doesn''t solve the problem, but it shifts the ground."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "Ms. Chen''s initial reaction is hesitant. ''I don''t know if that will help. She''ll just be defensive.'' ''Probably,'' you say. ''But at least she''ll hear what Ms. Chen is actually trying to say, and Ms. Chen will hear what Mei is actually struggling with. Right now, you''re both guessing at each other''s intentions.''",
        "''Is that what you''re trying to do — make her be something she''s not?'' ''No, of course not. I just want her to be connected to her culture.'' ''Then maybe Mei needs to hear that directly. And maybe she needs to tell you what she''s actually struggling with — not in front of the whole class, but in a private space where it''s not about performance.''",
        "Ms. Chen agrees, though with some anxiety. ''Okay. But I want to make sure this doesn''t feel like we''re letting her off the hook for her behavior.''",
        "You schedule the meeting for later in the week. Before it happens, you have a private conversation with Mei: ''Ms. Chen wants to understand what''s been going on. Not to convince you to do the lanterns, but to actually listen. Are you willing to have that conversation?''",
        "Mei is nervous but willing. You''ve set up the possibility of real dialogue instead of parallel monologues."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective 2: Ms. Chen''s Internal Experience",
      "content": [
        "When Ms. Chen began teaching Mandarin and culture at international schools five years ago, it was because she wanted to give students like Mei — students with Chinese heritage — a place to explore that identity. In China, she was a teacher. In an international school, she''s a cultural guardian.",
        "She''s watched dozens of heritage students come through her classroom. Some of them — the ones who engage — later tell her that her class helped them feel less alone. That it gave them language to claim their identity. But other students reject it entirely.",
        "When they do it publicly, with eye-rolling and loud refusals, it feels personal. It feels like a rejection of her life''s work.",
        "Ms. Chen doesn''t know, fully consciously, that she''s processing grief. Grief about globalization, about the erosion of cultural distinctiveness, about the fact that her students are becoming something she doesn''t have a frame for. She grew up in a world where cultural identity was legible and stable. Her students are growing up in a world where it''s fluid and ambiguous.",
        "When Mei refuses the lantern, Ms. Chen feels it as an erasure: You don''t want to know where you came from. And if students like you don''t care, who will?",
        "She also doesn''t recognize — because this is hard to recognize about ourselves — that her insistence on participation, however gentle, contains an implicit demand: You should want this. You should feel grateful. You should perform your heritage for the sake of its preservation.",
        "The cultural dynamic: This is where Li''s (2005) mind-vs.-virtue framework meets identity formation theory. Ms. Chen comes from a Chinese educational tradition where moral development (virtue) is inseparable from cultural continuity. Maintaining cultural knowledge isn''t self-expression; it''s a responsibility to ancestors and community. From that frame, Mei''s refusal is a moral failing, not an identity struggle.",
        "But Western theories of adolescent identity development (Erikson, 1968; Marcia, 1980) center the individual''s right to explore and choose identity. Mei''s resistance, from this frame, is developmentally healthy — she''s exploring, questioning, testing what feels authentic. These frameworks don''t have to be in conflict, but they''re operating on different assumptions about what it means to be loyal to a culture."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What were you most concerned about protecting when you made that choice?",
      "options": [
        "My relationship with Ms. Chen and the need to support a colleague.",
        "Mei''s experience and the risk of making her feel more isolated.",
        "The possibility of genuine understanding between both parties.",
        "My own discomfort with the conflict and wanting to find the ''right'' solution.",
        "Write your own."
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "Dilemma 3: Mei''s Confession",
      "content": [
        "The next week, Mei asks to talk to you after advisory. She seems more vulnerable than usual — less performed, more real.",
        "''I know Ms. Chen is probably upset with me. And I get that what I did was rude. But I''m tired, okay? I''m tired of people asking me to care about being Chinese when I''ve never actually... lived that. I''ve visited, like, twice. My Mandarin is bad. I don''t know anything about the culture actually. When I go to China, my cousins laugh at me because I can''t read or speak properly. But here, everyone acts like I''m supposed to be this authority on Chinese culture just because I was born there.''",
        "She''s close to tears. ''The worst part is — I don''t even know who I''m supposed to be. Am I Chinese? Am I basically American because I grew up here? Am I just... neither? I''m not good enough at being Chinese for my family, and I''m not quite part of the British-American crowd here either, even though that''s where I actually feel comfortable. So what am I? And why does everyone care so much?''",
        "This is the moment. Mei isn''t rejecting culture — she''s drowning in the contradiction of being asked to authentically claim something she doesn''t actually possess. How do you respond?"
      ],
      "choices": [
        {
          "id": "choice_3a",
          "label": "Validate her emotions; frame the goal as self-acceptance",
          "text": "''I hear you, and I''m glad you''re being honest about this. Your feelings are completely legitimate. The hard thing right now is that you''re being pulled in different directions, and that''s exhausting. But what I want you to work toward is accepting yourself — all of yourself — even the parts that don''t fit neatly into one category. You''re allowed to be complex. You''re allowed to not be fluent in Mandarin and still honor your heritage in your own way.''",
          "next": "consequence_3a"
        },
        {
          "id": "choice_3b",
          "label": "Validate her experience; don''t prescribe a direction",
          "text": "''That''s a lot to carry, and I''m really glad you told me. It makes complete sense that you''re frustrated and exhausted. It sounds like you''re living in a constant negotiation between what other people expect and what you actually feel. I don''t think there''s a simple answer to ''who am I'' right now. But I do think you deserve space to figure that out without having to perform it for anyone. What would feel most true to you right now, if no one was watching?''",
          "next": "consequence_3b"
        },
        {
          "id": "choice_3c",
          "label": "Name the bind; offer language and frameworks",
          "text": "''What you''re describing is actually really common for people who grow up between cultures. There''s a researcher named Pollock who calls it being a ''Third Culture Kid,'' and it''s not about being confused — it''s about creating your own identity that''s genuinely yours. You''re not supposed to be fully Chinese OR fully Western. The goal isn''t to fit neatly. The goal is to understand your own story and own it. Would you want to understand your identity more intentionally, or would that feel like more pressure right now?''",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Consequence 3A",
      "content": [
        "Mei visibly relaxes. You''ve given her permission to stop fighting so hard. ''Yeah, okay. That helps. I just need everyone to stop expecting me to be excited about being Chinese, I guess.''",
        "But then, a week later, you notice something: Mei''s defensiveness has softened, but she''s also absent. She''s less engaged in the cultural conversations. She''s not rejecting them anymore, but she''s not participating in the way that would help her actually build any connection.",
        "She feels less alone because you''ve validated her, but she''s also more resigned. She''s accepted her identity confusion, but she hasn''t moved toward integration or understanding.",
        "Ms. Chen also feels the shift — Mei''s still not participating, but now she''s not refusing. She''s just absent. For Ms. Chen, this is a quiet loss.",
        "You''ve helped Mei feel less pressure, which was necessary. But you may have stopped short of what could have helped her more."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Consequence 3B",
      "content": [
        "Mei thinks about your question. ''I don''t know. If no one was watching, I think I''d just... not think about being Chinese? I''d just be Mei. Does that make sense?''",
        "''That makes total sense,'' you say. ''And that''s actually a healthy place to be. You don''t have to perform culture. But I will say this — you might also find that understanding your cultural roots, not as a performance but as part of your story, could be interesting to you eventually. Not now. Maybe not for years. But at some point, you might want to know more about Chengdu or your family''s history just because it''s your story.''",
        "Mei nods. ''Maybe. I don''t know. Right now I just want people to stop expecting me to have figured this out.''",
        "You''ve honored her experience without pressuring her to do anything with it. But you''ve also left her without a framework to understand what''s happening to her. She feels validated, which is important and necessary. But she doesn''t have language for her own experience — she just knows it''s confusing and exhausting.",
        "She goes back into the world still searching for an answer to ''who am I?'' but with a little more permission to struggle with it privately."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Consequence 3C",
      "content": [
        "Mei''s eyes widen slightly. ''Third Culture Kid? Is that like... a real thing?''",
        "''Very real. And it''s not something that needs to be ''fixed.'' It''s actually an asset — you have genuinely more fluency across cultures than kids who grew up in one place. But that fluency comes with its own challenges, and I think what you''re experiencing right now is one of those challenges. The world wants to put you in a box, and you don''t fit in a box because you were literally raised across multiple boxes.''",
        "''So I''m not broken,'' Mei says. ''You''re not broken. You''re navigating something genuinely complex. And the skill is learning to explain your own story to people who want a simpler narrative. That''s hard work, but it''s learnable.''",
        "She asks you for the researcher''s name, and you give it to her. Days later, Mei comes back: ''I read that article. It was weird because it was like... someone explaining my life back to me.''",
        "More importantly, she approaches the question of her identity differently. She''s not performing it for anyone. But she''s also not rejecting it as impossible. She''s begun to own her own complexity.",
        "She still doesn''t do the lantern activity. But when Ms. Chen mentions a documentary about Chengdu coming up, Mei says she might watch it — not because she has to, but because it''s actually about the place where she was born. It''s hers to explore now, not something being done to her.",
        "Ms. Chen notices the shift. She doesn''t get the public participation she was hoping for, but she gets something better: evidence that Mei is engaging with her heritage privately, on her own terms."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Perspective 3: Mei''s Deeper Truth",
      "content": [
        "Mei''s resistance isn''t authentic cultural rejection. It''s self-protection.",
        "She was six years old when she moved to her first international school. She was fluent in Mandarin, knew her neighborhood in Chengdu, felt at home. Then, suddenly, she was in a classroom where no one spoke her language, where the rules were different, where people looked at her differently.",
        "She adapted. Fast. That''s what kids do. By age 8, she was more comfortable in English than Mandarin. By age 10, she had friends who''d never been to China. By age 12, she''d learned to move through a global world with ease and competence.",
        "But ease and competence also meant invisibility within her own heritage. She stopped learning Mandarin formally after age 9. Her parents, busy navigating their own expatriate lives, didn''t push it. Then she hit age 13, and suddenly her school started emphasizing ''cultural identity'' and ''heritage pride.'' Ms. Chen showed up, passionate and expectant.",
        "And Mei panicked. Because here''s what no one told her: she''d actually moved between cultures in a real way. It wasn''t her fault. It was the natural outcome of growing up in that world. But now, at an age where identity questions are already intense, she was being asked to claim something she didn''t actually have access to anymore.",
        "So she rejected it. Loudly. Because rejection felt like the only way to say ''this is not mine'' without being told that she was ungrateful or lost. The eye-rolling, the loud refusal, the arms crossed — it was armor.",
        "What she actually needed was someone to say: You''re right. You don''t have fluency in this culture. And that''s not your failure. It''s a natural outcome of your life. And now you get to decide what your relationship to that heritage is going to be.",
        "The cultural dynamic: Pollock & Van Reken (1999, 2009) found that Third Culture Kids often experience ''cross-cultural mobility risk'' — the loss of home culture through no conscious choice of their own. They adapt rapidly to new environments as a developmental necessity, but that adaptation has a cost: alienation from their origin culture. This isn''t identity confusion; it''s adaptive development in a cross-cultural context.",
        "Blanco et al. (2021) research on code-switching fatigue shows that repeated demands to perform one cultural identity while suppressing another creates cognitive and emotional exhaustion, especially in adolescence. When Mei encounters the term ''Third Culture Kid,'' she''s not being pathologized — she''s being seen accurately. That recognition is often the first step toward integration rather than rejection."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection 3",
      "prompt": "Think about what Mei actually needed in that conversation. What did you offer her, and what else might she have needed?",
      "options": [
        "Permission to not feel Chinese and permission to be confused — she needed validation more than direction.",
        "A framework for understanding her own experience — language that helped her see herself clearly instead of as broken.",
        "Support in defining her own relationship to her heritage, untethered from what others expect.",
        "A realistic acknowledgment that this is something she''ll keep processing for years, not something to fix now.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Display the learner''s three choices in sequence.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised three cultural dimensions that shape the experience of heritage students and third culture kids in international school settings.",
            "Classroom Dynamics (D4): The lantern-making activity seems like a simple cultural celebration. But it''s actually a moment where classroom culture, teacher expectations, and student identity collide. In Chinese educational contexts, participation in collective cultural activities is often non-negotiable — it''s about group cohesion and moral development. In Western progressive education, refusal of an activity is sometimes interpreted as healthy individual assertion. Mei is caught between these frameworks, and her ''no'' is being read as defiance rather than self-protection.",
            "Homework & Praise (D5): Ms. Chen''s approach to Mei includes an implicit expectation: that because Mei has Chinese heritage, she should naturally be intrinsically motivated by Chinese cultural activities. This is the ''heritage as automatic asset'' assumption. But for Mei, who has spent her formative years in international schools where Mandarin was not her daily medium, heritage is something she''s learned about, not lived in. The praise structure — the expectation that Mei should want to participate — misaligns with her actual relationship to the culture.",
            "Cultural Identity (D6): This is the core tension. Mei is experiencing what Pollock & Van Reken identify as the ''third culture identity'' — she is not fully Chinese (in the sense of having been acculturated in China during formative years) and not fully Western (in the sense of having that as her heritage). She''s navigating a legitimate but often invisible identity formation process. The adults around her want her to choose a simple narrative. Mei''s actual experience is more fluid and complex than any of these options."
          ]
        },
        {
          "title": "The Research Behind This",
          "content": [
            "Pollock, D. C., & Van Reken, R. E. (2009). Third culture kids: Growing up among worlds (2nd ed.). Intercultural Press.",
            "Blanco, O., Kanegae, H., & Voci, A. (2021). ''Code-switching and cultural exhaustion in bilingual adolescents.'' International Journal of Intercultural Relations, 85, 156-168.",
            "Li, J. (2005). ''Mind or virtue: Western and Chinese beliefs about learning.'' Current Directions in Psychological Science, 14(4), 190-194.",
            "Erikson, E. H. (1968). Identity: Youth and crisis. W.W. Norton & Company."
          ]
        }
      ],
      "finalPrompt": "You''ve now walked through this scenario from three perspectives: Mei''s public refusal, Ms. Chen''s pain, and Mei''s private confession. Looking back at your first choice in the classroom, knowing what you now know about what was really happening for Mei, would you handle that moment differently? What would you say, and what would you be trying to do for Mei rather than for the classroom management situation?"
    }
  }',
  ARRAY[4, 5, 6],
  20,
  3,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;

-- Make the simulation live immediately
UPDATE public.pd_simulations
SET status = 'live'
WHERE id = 'a1b2c3d4-0001-0003-0001-000000000001';
-- Seed India Simulation 1: "The Scorecard"
-- Source: Codex-produced content package (india-the-scorecard-handoff.json)
-- Run AFTER 20260330_create_simulations.sql and 20260330_seed_india_module.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'a1b2c3d4-0004-0001-0001-000000000001',
  'india-001',
  'The Scorecard',
  'A PTM after a student exhibition. Mrs. Rao wants proof that Ananya''s school is academically serious. Three decisions test how you handle legibility, parent-teacher communication, and the parent grapevine.',
  'A bright corridor at Banyan International School. Student work hangs beside banners that read: Rooted in India. Ready for the World. It is late August in Bengaluru. Your Year 6 students have just finished a student-led exhibition on sustainable cities. Parents have been walking through classrooms looking at design boards, reflection journals, and group presentations. Ananya is one of your strongest students. Her English is excellent, her notebooks are immaculate, and she always turns work in on time. She asks thoughtful questions, but she also wants to know exactly what counts. On project days, she often asks, "Will this be graded?" before she starts. Your school uses narrative feedback, rubrics, and portfolio reviews more than frequent unit tests. There are no class ranks. Teachers are encouraged to talk about growth, habits of inquiry, and evidence of learning rather than percentage scores whenever possible. As parents leave the exhibition, Mrs. Rao waits near your classroom door with Ananya''s portfolio in her hand. "Teacher, the exhibition was lovely," she says. "The children were confident, and I can see the effort. But I need something more concrete. We chose this school because it promised global exposure without compromising academics. If there are no marks or rank, how do I know where Ananya actually stands?" Your assessment coordinator has been very clear: no unofficial ranking, no private comparison sheets, and no ad hoc extra tests just to reassure individual families.',
  '[
  {
    "name": "You",
    "role": "2nd-year homeroom teacher at Banyan International School, Bengaluru",
    "description": "You trained in the UK, US, or Australia. You teach Year 6. Your school markets itself as global, inquiry-driven, and rooted in Indian values. You believe in project-based learning and narrative feedback, but you are still learning what parents here read as visible rigor."
  },
  {
    "name": "Mrs. Rao",
    "role": "Mother of Ananya",
    "description": "She works in human resources in Bengaluru''s tech sector. She and her husband are investing heavily in Ananya''s schooling and chose Banyan because it promised strong English, future opportunities, and a values-based environment. She is polite, highly attentive, and wants evidence that the school is academically serious."
  }
]'::jsonb,
  '{
  "setup": {
    "id": "setup",
    "type": "setup",
    "title": "Setup",
    "content": [
      "A bright corridor at Banyan International School. Student work hangs beside banners that read: Rooted in India. Ready for the World.",
      "It is late August in Bengaluru. Your Year 6 students have just finished a student-led exhibition on sustainable cities. Parents have been walking through classrooms looking at design boards, reflection journals, and group presentations.",
      "Ananya is one of your strongest students. Her English is excellent, her notebooks are immaculate, and she always turns work in on time. She asks thoughtful questions, but she also wants to know exactly what counts. On project days, she often asks, \"Will this be graded?\" before she starts.",
      "Your school uses narrative feedback, rubrics, and portfolio reviews more than frequent unit tests. There are no class ranks. Teachers are encouraged to talk about growth, habits of inquiry, and evidence of learning rather than percentage scores whenever possible.",
      "As parents leave the exhibition, Mrs. Rao waits near your classroom door with Ananya''s portfolio in her hand.",
      "\"Teacher, the exhibition was lovely,\" she says. \"The children were confident, and I can see the effort. But I need something more concrete. We chose this school because it promised global exposure without compromising academics. If there are no marks or rank, how do I know where Ananya actually stands?\"",
      "Your assessment coordinator has been very clear: no unofficial ranking, no private comparison sheets, and no ad hoc extra tests just to reassure individual families."
    ],
    "next": "dilemma_1"
  },
  "dilemma_1": {
    "id": "dilemma_1",
    "type": "dilemma",
    "title": "Dilemma 1: The Scorecard",
    "content": [
      "How do you respond?"
    ],
    "choices": [
      {
        "id": "choice_1a",
        "label": "Defend the school''s assessment model",
        "text": "\"I understand the question, Mrs. Rao. At Banyan, we do not reduce learning to rank or constant numerical comparison. We look at evidence across projects, writing, discussion, and reflection. That gives us a fuller picture of where Ananya is growing.\"",
        "next": "consequence_1a"
      },
      {
        "id": "choice_1b",
        "label": "Reassure her, then avoid committing",
        "text": "\"Of course. I completely understand. Let me put something together that gives you a clearer picture.\" You want to calm the moment down, but you are not sure what, if anything, you can actually send.",
        "next": "consequence_1b"
      },
      {
        "id": "choice_1c",
        "label": "Create a private benchmark summary",
        "text": "\"I cannot share a rank, but I can probably give you a more concrete sense of where she is, maybe a private academic snapshot across subjects.\"",
        "next": "consequence_1c"
      }
    ]
  },
  "consequence_1a": {
    "id": "consequence_1a",
    "type": "consequence",
    "title": "Consequence 1A",
    "content": [
      "Mrs. Rao nods politely. \"I understand,\" she says. But her expression tightens almost imperceptibly.",
      "Over the next two weeks, her messages become more formal. She still thanks you for updates, but the tone shifts from partnership to monitoring.",
      "Ananya begins mentioning outside practice materials. \"My mom got a workbook so I can be ready for proper tests,\" she says one afternoon. During project work, she becomes less interested in exploratory drafts and more focused on asking what the final deliverable is worth.",
      "Nothing openly confrontational happens. But the trust channel narrows. Mrs. Rao has not stopped caring about the school''s approach. She has simply decided she cannot rely on it alone for proof of rigor."
    ],
    "next": "perspective_1"
  },
  "consequence_1b": {
    "id": "consequence_1b",
    "type": "consequence",
    "title": "Consequence 1B",
    "content": [
      "Mrs. Rao looks relieved. \"Thank you, Teacher. That would help a lot.\"",
      "You leave the conversation hoping it will fade. It does not.",
      "Three days later, a WhatsApp message arrives: \"Just following up on the academic breakdown you mentioned. Even broad subject-wise feedback with standing would be useful.\"",
      "You realize she did not hear your response as empathy. She heard it as a promise.",
      "Now you are in a harder position than if you had been clear from the start."
    ],
    "next": "perspective_1"
  },
  "consequence_1c": {
    "id": "consequence_1c",
    "type": "consequence",
    "title": "Consequence 1C",
    "content": [
      "At first, it feels practical.",
      "You send a brief note summarizing Ananya as strong in English and science, secure in math, and still developing in open-ended reflection. Mrs. Rao replies immediately: \"This is exactly the clarity I needed. Thank you.\"",
      "A few days later, your assessment coordinator, Meera, stops by.",
      "\"A parent mentioned receiving a more concrete academic snapshot from you,\" she says. \"I understand the intention, but if one family gets unofficial benchmarking, others will ask for the same. We will end up rebuilding ranking culture one private message at a time.\"",
      "You now need to tell Mrs. Rao you cannot keep providing the kind of clarity that just made her trust the system more."
    ],
    "next": "perspective_1"
  },
  "perspective_1": {
    "id": "perspective_1",
    "type": "perspective",
    "title": "Perspective 1: Mrs. Rao''s View",
    "content": [
      "Mrs. Rao is not rejecting project-based learning. She is looking for trust signals.",
      "For families like hers, school choice in India is tied to sacrifice, status, and future security. Fees are not just fees. They are an investment in mobility. Parents often use visible markers such as English-medium instruction, school brand, board results, and concrete academic evidence to judge whether that investment is sound.",
      "From her perspective, asking for a clearer academic picture is not narrow-minded or anti-child. It is responsible. She chose this school because it promised both global fluency and serious education. If the school does not produce familiar signals of rigor, she may worry that the polish is outrunning the substance.",
      "The cultural dynamic here is not simply marks versus no marks. It is about what counts as legible proof that a school is academically trustworthy."
    ],
    "next": "reflection_1"
  },
  "reflection_1": {
    "id": "reflection_1",
    "type": "reflection",
    "title": "Reflection 1",
    "prompt": "What assumption was driving your response?",
    "options": [
      "If I explain the philosophy well enough, the parent will trust it.",
      "I was trying to avoid feeding a ranking culture.",
      "I wanted to keep the relationship smooth in the moment.",
      "I underestimated how much visible rigor matters to parents like Mrs. Rao.",
      "Write your own."
    ],
    "next": "dilemma_2"
  },
  "dilemma_2": {
    "id": "dilemma_2",
    "type": "dilemma",
    "title": "Dilemma 2: The Conference",
    "content": [
      "A month later, it is conference week.",
      "Ananya is performing well across subjects. Her writing is polished, her reading is strong, and she is one of the most dependable students in your class.",
      "But you have noticed a pattern. She treats every learning moment as if it should produce a measurable result. She hesitates to share rough ideas. She dislikes open-ended tasks unless you explain exactly how they will be assessed. During inquiry circles, she often waits until someone else has tested the safe answer first.",
      "You do not think she is disengaged. You think she is optimizing for correctness so strongly that it is narrowing her learning.",
      "How do you frame the conference?"
    ],
    "choices": [
      {
        "id": "choice_2a",
        "label": "Lead with concern about pressure",
        "text": "\"Ananya is doing very well, but I am concerned that she may be under too much pressure to perform. She seems so focused on marks and correctness that she is becoming hesitant in the very inquiry tasks that should help her grow.\"",
        "next": "consequence_2a"
      },
      {
        "id": "choice_2b",
        "label": "Lead with strengths, then frame it as a learning goal",
        "text": "\"Ananya has many strengths: discipline, precision, excellent language skills, and real academic commitment. One next step I want to support is intellectual risk-taking, helping her share an idea before it is perfect and treat drafts as part of learning rather than evidence of weakness.\"",
        "next": "consequence_2b"
      },
      {
        "id": "choice_2c",
        "label": "Focus on achievement and leave it alone",
        "text": "\"Ananya is doing very well. Her work is strong, her habits are excellent, and she continues to be one of the most dependable students in the class.\"",
        "next": "consequence_2c"
      }
    ]
  },
  "consequence_2a": {
    "id": "consequence_2a",
    "type": "consequence",
    "title": "Consequence 2A",
    "content": [
      "Mrs. Rao goes still for a moment.",
      "\"We are not pressuring her,\" she says carefully. \"We are only teaching her to take her work seriously.\"",
      "You try to explain that this is not about blame. But the frame is already defensive. The conversation becomes about whether the family is creating the problem rather than how the child is experiencing school.",
      "The next week, Ananya changes. She volunteers more often, but her participation sounds rehearsed. She now checks with you repeatedly: \"Is this the kind of answer you want?\"",
      "The issue has been named, but it has landed as a correction to implement quickly, not as a developmental pattern to understand."
    ],
    "next": "perspective_2"
  },
  "consequence_2b": {
    "id": "consequence_2b",
    "type": "consequence",
    "title": "Consequence 2B",
    "content": [
      "Mrs. Rao smiles at discipline and commitment. When you describe risk-taking as a learning goal rather than a personality defect, she leans in.",
      "\"What do you mean exactly?\" she asks. \"At home she says she wants to be fully prepared before she speaks.\"",
      "You explain that in your classroom, visible thinking matters. Students are expected to try ideas aloud, test possibilities, and learn through partial answers, not only final ones.",
      "Mrs. Rao nods slowly. \"I understand. We do talk a lot at home about doing things properly. Maybe she is hearing that as don''t speak until it is perfect.\"",
      "The conversation opens. You and Mrs. Rao agree on a small plan: you will create lower-stakes spaces for Ananya to share tentative thinking, and Mrs. Rao will begin praising process and initiative, not only polished outcomes."
    ],
    "next": "perspective_2"
  },
  "consequence_2c": {
    "id": "consequence_2c",
    "type": "consequence",
    "title": "Consequence 2C",
    "content": [
      "The conference is smooth. Mrs. Rao leaves satisfied.",
      "Six weeks later, report comments go out. In Ananya''s learner profile section, you write: \"Ananya is encouraged to take more intellectual risks and participate more freely in exploratory tasks without waiting for certainty.\"",
      "That evening, Mrs. Rao messages you. \"Teacher, I was surprised by this comment. At the conference you said she was doing very well. If there was a concern about how she approaches learning, I wish I had known earlier.\"",
      "She is right. By avoiding the conversation to preserve short-term harmony, you made the later feedback feel less transparent."
    ],
    "next": "perspective_2"
  },
  "perspective_2": {
    "id": "perspective_2",
    "type": "perspective",
    "title": "Perspective 2: Mrs. Rao''s View",
    "content": [
      "For Mrs. Rao, seriousness about academics is not evidence of damage. It is evidence of care.",
      "Many Indian families treat education as the most reliable route to security and upward mobility. In that context, discipline, correctness, and visible achievement can feel morally responsible, especially when parents are making financial sacrifices to access a better school.",
      "That does not mean parents like Mrs. Rao reject inquiry or creativity. But they often need the school to translate those goals into terms that still look rigorous. If the teacher frames the issue as pressure created by the family, the parent may feel accused. If the teacher frames it as a learning pattern that can be broadened without lowering standards, the conversation becomes possible.",
      "The cultural dynamic here is about the difference between academic care as the family understands it and academic growth as the school wants to cultivate it."
    ],
    "next": "reflection_2"
  },
  "reflection_2": {
    "id": "reflection_2",
    "type": "reflection",
    "title": "Reflection 2",
    "prompt": "What were you optimizing for when you framed the conversation?",
    "options": [
      "I wanted to be direct and honest.",
      "I wanted to protect the relationship while still naming the issue.",
      "I worried that critiquing marks-orientation would sound like critiquing the family''s values.",
      "I chose short-term comfort over long-term clarity.",
      "Write your own."
    ],
    "next": "dilemma_3"
  },
  "dilemma_3": {
    "id": "dilemma_3",
    "type": "dilemma",
    "title": "Dilemma 3: The Parent Group",
    "content": [
      "It is February.",
      "Your class is juggling assessments, a service-learning event, an inter-school spelling competition, and costume details for a heritage performance. The school app posts information, but not always in the sequence parents want.",
      "Mrs. Rao messages you: \"Teacher, a few of us parents were thinking it would help to make a small WhatsApp group with you. Just six or seven of us from the class. Not for complaints, only for quick clarifications about deadlines, competitions, costume details, and school terms. Sometimes the portal updates are not enough, and parents are anyway checking with each other.\"",
      "You know this is partly about convenience, and partly about something else: parents comparing notes, reducing uncertainty, and validating their reading of the school.",
      "How do you respond?"
    ],
    "choices": [
      {
        "id": "choice_3a",
        "label": "Decline the group",
        "text": "\"Thank you, Mrs. Rao. I really appreciate the thought, but I find it fairest to keep communication through the school app and official class updates so everyone gets the same information. Please do message me directly if there is something specific about Ananya.\"",
        "next": "consequence_3a"
      },
      {
        "id": "choice_3b",
        "label": "Accept the group",
        "text": "\"That sounds useful. I would be happy to join a small group if it helps parents stay clear on class logistics.\"",
        "next": "consequence_3b"
      },
      {
        "id": "choice_3c",
        "label": "Counter-propose a whole-class structure",
        "text": "\"I understand the need for quick clarity, but I also need to keep communication manageable and equitable. What if we do one whole-class Q and A channel or weekly FAQ update with a set time window for clarifications?\"",
        "next": "consequence_3c"
      }
    ]
  },
  "consequence_3a": {
    "id": "consequence_3a",
    "type": "consequence",
    "title": "Consequence 3A",
    "content": [
      "Mrs. Rao responds politely. The parent group forms without you.",
      "At first, nothing seems different. Then you begin to notice that many questions reach you already processed through the grapevine: \"Some parents were wondering...\" \"We heard that...\"",
      "The group becomes the place where parents compare interpretations, validate concerns, and decide which issues are worth escalating.",
      "You have protected your boundaries. But you are now outside an important layer of how families are navigating your class."
    ],
    "next": "perspective_3"
  },
  "consequence_3b": {
    "id": "consequence_3b",
    "type": "consequence",
    "title": "Consequence 3B",
    "content": [
      "The first week is efficient. One message clears up costume confusion in minutes. Another helps parents understand a competition deadline.",
      "Then the stream thickens. Questions start coming in late at night: What exactly does formative mean on this rubric? Is the spelling competition optional or just framed as optional? Should children prepare extra for the service event or only the listed materials?",
      "No one is rude. That is not the problem. The problem is that the channel quietly becomes the real place where school gets interpreted.",
      "You are more accessible and more informed. You are also carrying more invisible labor than before."
    ],
    "next": "perspective_3"
  },
  "consequence_3c": {
    "id": "consequence_3c",
    "type": "consequence",
    "title": "Consequence 3C",
    "content": [
      "Mrs. Rao pauses, then replies: \"Yes, that seems fair. The main thing is that parents need clarity.\"",
      "You create a visible structure: one whole-class weekly FAQ post and a short Q and A window on weekday evenings. Parents can ask about deadlines, terminology, and event logistics in one place.",
      "The result is not perfectly calm, but it is much more transparent. One parent asks what formative assessment means. Another parent answers partially. You then step in and clarify. The conversation becomes shared rather than private.",
      "You have not removed the parent grapevine, but you have given it a healthier official alternative."
    ],
    "next": "perspective_3"
  },
  "perspective_3": {
    "id": "perspective_3",
    "type": "perspective",
    "title": "Perspective 3: Mrs. Rao''s View",
    "content": [
      "For Mrs. Rao, the parent network is not just gossip. It is infrastructure.",
      "Research on school choice in India shows that parents often rely on informal networks, what many would casually call the grapevine, to compare schools, validate decisions, and reduce uncertainty. In competitive school markets, group judgment can feel safer than individual interpretation.",
      "A WhatsApp group therefore feels practical. It lets parents make sense of school language, check expectations quickly, and reassure themselves that they are not missing something important.",
      "From the teacher''s side, the same channel can become after-hours interpretation work and an engine for escalation. The issue is not whether parents care too much. The issue is whether the school has built a sustainable way to answer the kinds of questions families will ask anyway."
    ],
    "next": "reflection_3"
  },
  "reflection_3": {
    "id": "reflection_3",
    "type": "reflection",
    "title": "Reflection 3",
    "prompt": "What were you protecting when you made your choice?",
    "options": [
      "My time and after-hours boundaries.",
      "Equity across all families.",
      "A smoother relationship with involved parents.",
      "A communication structure I could actually sustain.",
      "Write your own."
    ],
    "next": "debrief"
  },
  "debrief": {
    "id": "debrief",
    "type": "debrief",
    "title": "Debrief",
    "pathSummaryIntro": "Display the learner''s three choices in sequence.",
    "sections": [
      {
        "title": "What Was Really Happening",
        "content": [
          "This simulation exercised three recurring tensions in Indian private and international-school contexts.",
          "School Choice, Brand Value, and Academic Rigor: Research on school choice in India shows that many parents use English-medium instruction, school reputation, board results, visible discipline, teacher attention, and concrete academic evidence as signals of quality. For families paying private or international-school fees, legible academic seriousness is often part of what makes the school feel trustworthy.",
          "Parent-Teacher Communication: Recent qualitative work on parent-teacher meetings in Indian schools shows that relationships improve when teachers are receptive, specific, and respectful. Parents often become frustrated not only by problems themselves, but by feeling dismissed, vaguely reassured, or insufficiently informed about next steps.",
          "Informal Networks and School Navigation: In Indian school markets, families do not make sense of schools alone. They use relatives, neighbors, other parents, and WhatsApp-style networks to compare interpretations and validate decisions. For parents, this can feel like responsible navigation. For teachers, it can feel like an unofficial parallel system."
        ]
      },
      {
        "title": "Where the International-School Layer Matters",
        "content": [
          "International schools in India often market themselves as both global and appropriately Indian. That combination can attract families who want English, confidence, and future mobility without giving up cultural rootedness or visible academic seriousness.",
          "The tension is not that parents want contradictory things. The tension is that the school may communicate its philosophy in ways that sound holistic and future-facing, while parents are still looking for familiar proof that the school is rigorous enough to justify the investment."
        ]
      },
      {
        "title": "Research Anchors",
        "content": [
          "Boruah, B., Phogat, P., and Singh, A. (2024). A qualitative exploration of parent-teacher meetings in Indian schools.",
          "Ullah, A., Mukherjee, A., and Middendorf, G. (2025). School preferences of middle-class Indians.",
          "Babu, S. S., and Mahajan, A. (2021). Branding an ''Inter''national school: Fusing ''Indian values'' with a global diploma.",
          "Gurney, E. (2017). Choosing schools, choosing selves.",
          "Parikh, R. et al. (2019). It is like a mind attack: stress and coping among urban school-going adolescents in India."
        ]
      }
    ],
    "finalPrompt": "If you could go back to the first moment, when Mrs. Rao asked how she should know where Ananya actually stands, what would you say now? How would you preserve both clarity and trust without rebuilding rank culture one parent at a time?"
  }
}'::jsonb,
  ARRAY[1, 2, 5],
  20,
  1,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;
-- Seed Korea Simulation 1: "The Academy Planner"
-- Source: Codex-produced content package (korea-the-academy-planner.json)
-- Run AFTER 20260330_create_simulations.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'c3d4e5f6-0003-0003-0003-000000000003',
  'korea-001',
  'The Academy Planner',
  'A parent shows you a neatly organized academy planner and asks for the weekly topic focus. The question is practical. The policy is clear. The relationship is not.',
  'It is October at Han River International School in Seoul. Your KakaoTalk icon shows 9 unread messages. Minseo is one of those students who never arrives unprepared. This morning, Mrs. Park is waiting outside your classroom.',
  '[
    {
      "name": "You",
      "role": "2nd-year homeroom teacher at Han River International School, Seoul",
      "description": "You trained in the UK, US, or Australia. You teach Year 5. You care about strong family relationships but still learning local expectations around teacher authority, parental involvement, and supplementary education."
    },
    {
      "name": "Mrs. Park",
      "role": "Mother of Minseo",
      "description": "She used to work in marketing before stepping back to manage the family''s schedule. Minseo attends after-school academies. Mrs. Park is efficient, warm, and highly organized. She sees school, home, and academy as parts of one larger learning system."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A classroom in late autumn. Indoor shoes lined neatly by cubbies. Your KakaoTalk icon shows 9 unread messages.",
        "It is October at Han River International School in Seoul. You have known Minseo for seven weeks.",
        "She is one of those students who never arrives unprepared. Her pencil case is immaculate. Her homework is always early. Her reading responses are thoughtful, but polished to the point that they barely show the drafting process. In math, she is strong. In discussions, she often waits until she is certain before speaking.",
        "You met Mrs. Park briefly at orientation. She asked clear, specific questions about your literacy framework, independent reading expectations, and how writing is assessed. She was polite, well-informed, and clearly follows Minseo''s schooling closely.",
        "This morning she is waiting outside your classroom.",
        "\"Teacher, do you have one minute?\"",
        "She shows you a neatly organized academy planner. It lists the topics Minseo is studying after school and leaves space for notes.",
        "\"Minseo''s academy tries not to overlap too much with school,\" Mrs. Park says. \"If we know the broad topic you are on, they can support her more efficiently. You don''t need to do anything detailed. Even just the unit focus helps.\"",
        "Your school policy is clear: teachers do not coordinate directly with outside academies, do not share assessment details in advance, and try to avoid creating different access for families with supplementary tutoring."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Academy Planner",
      "content": ["How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Decline politely",
          "text": "\"Thank you, Mrs. Park. I can see how carefully you''re supporting Minseo. At school, I''m not able to coordinate directly with outside academies. But I can keep sharing Minseo''s progress and our class learning goals through the usual school channels.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Accept and shelve",
          "text": "\"Thank you, this is helpful context. Let me have a look and think about it.\" You plan to be gracious in the moment, then continue as usual.",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Give broad topic guidance",
          "text": "\"I can''t do anything detailed, but I can probably mention the broad unit from time to time so Minseo''s support stays aligned.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Park nods right away. \"I understand,\" she says. Her tone stays polite.",
        "Over the next two weeks, though, the rhythm changes. Her messages become more transactional. At dismissal, she still greets you warmly, but the sense of educational collaboration narrows.",
        "Minseo begins arriving with methods you have not taught yet. During a fractions lesson, she says quietly, \"At academy, we do it another way.\" She is not being rude. She is simply living across two partially connected systems.",
        "When you later ask Mrs. Park whether the unit feels manageable, she replies, \"Yes, we will reinforce at home.\"",
        "Nothing has gone wrong exactly. But the partnership has split into parallel tracks: your classroom on one side, the family''s outside support system on the other."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Park looks relieved. \"Thank you. That will help Minseo.\"",
        "You continue teaching as usual and do not follow up.",
        "A week later, Minseo says, \"My mom thought you might tell us if the unit changed.\"",
        "That evening, a KakaoTalk message arrives: \"Teacher, just checking whether the class is still on fractions this week or moving to decimals soon. I thought we might align support a little.\"",
        "You realize Mrs. Park heard your response as agreement, not courtesy. The planner was not a gift or a neutral document. It was an invitation to coordination.",
        "Now you have to retract an expectation you did not mean to create."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "At first, it feels efficient.",
        "You mention fractions in a quick reply one Friday, and Mrs. Park thanks you immediately. A few days later she messages again: \"That helped a lot. Minseo felt prepared.\"",
        "Then your grade-level lead, Alex, checks in. \"A parent mentioned that one family may be getting extra topic guidance because of academy planning. Are we sharing unit pacing individually?\"",
        "You explain that it was broad and informal. Alex is calm but firm. \"The issue isn''t only privacy. If one family''s outside support system gets direct alignment, other families may feel pressure to build the same setup.\"",
        "You now need to tell Mrs. Park you cannot keep doing something that already seemed helpful."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective 1: Mrs. Park''s View",
      "content": [
        "Mrs. Park is not trying to outsource your teaching to an academy. She is trying to reduce fragmentation.",
        "In South Korea, supplementary education is common enough that many families think in systems: school, home, and academy. If those systems are badly misaligned, the child absorbs the inefficiency through duplicated work, stress, or the sense of always catching up.",
        "From her point of view, asking about the broad unit focus is not automatically an unfair advantage. It is a practical coordination request. She may assume that a well-supported child is one whose adults are not working at cross-purposes.",
        "If you decline, she may not feel insulted. But she may conclude that school and outside study are being kept deliberately separate, and that she will need to manage the second system without your help."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What assumption was driving your response?",
      "options": [
        "Outside tutoring should stay completely separate from school.",
        "I was trying to preserve fairness across families.",
        "I wanted to be kind in the moment and avoid direct refusal.",
        "I saw the planner as optional information, not an invitation to coordination.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Conference",
      "content": [
        "It is conference week.",
        "Minseo is doing very well academically. Her reading comprehension is excellent. Her math is strong. She is conscientious to a fault.",
        "But you have noticed something. She rarely shares an idea unless she is certain it is correct. In writer''s workshop, she erases so much that she sometimes finishes less than classmates with weaker ideas. In math talks, she often solves the problem but will not explain her thinking until she has rehearsed it silently.",
        "Your school values visible thinking, productive struggle, rough drafting, and learning in public.",
        "How do you approach the conference?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Lead with concern",
          "text": "\"Minseo is doing very well overall, but I''m a little concerned that she seems anxious about mistakes. She works so hard to be correct that she sometimes avoids participating until she''s sure, and I wonder if the amount of outside academic pressure may be part of that.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Lead with strengths, then frame risk-taking as a learning goal",
          "text": "\"Minseo has so many strengths. She is diligent, prepared, and deeply thoughtful. One next step I''m working on with her is academic risk-taking: sharing an idea before it''s perfect, or submitting a strong draft without over-polishing. In our program, that''s an important learning skill, not just a personality trait.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Focus on achievement and skip the issue",
          "text": "\"Minseo is doing extremely well. Her academics are strong, her work habits are excellent, and she is exactly where I''d hope she would be at this point in the year.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Park''s face tightens slightly at the phrase outside academic pressure.",
        "\"I see,\" she says. \"At home she is just trying to do her best.\"",
        "You clarify that Minseo is wonderful and that you mean well. But the tone of the conversation has shifted from collaboration to diagnosis.",
        "The next week, Minseo changes. She raises her hand more often, but mostly for short, safe answers. She now checks your face after every response.",
        "At home, the family has clearly heard the issue as a problem to correct quickly. You surfaced the issue, but it landed as urgency rather than developmental support."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Mrs. Park smiles at diligent and thoughtful. When you describe risk-taking as a learning goal rather than a deficiency, she leans forward.",
        "\"What do you mean exactly?\" she asks. \"She tells us she wants to be correct before she speaks.\"",
        "You explain that in your classroom, students are expected to try ideas aloud, share drafts before they are polished, and learn from partial answers.",
        "Mrs. Park nods slowly. \"In Korean schools, sometimes students speak when they are ready, or when the teacher calls. If she speaks before she is sure, maybe she feels exposed.\"",
        "The conversation opens. You learn that Minseo gets upset at home if she makes small errors in academy homework. Mrs. Park learns that your feedback model rewards process, not only correctness.",
        "Together you make a plan: you will give Minseo lower-stakes moments to share with a partner first, and Mrs. Park will begin praising trying before perfect, not only finished accuracy."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "The conference is pleasant. Mrs. Park leaves reassured.",
        "Six weeks later, report comments go home. In Minseo''s learning habits section, you write: \"Minseo is encouraged to share early thinking more readily and to embrace drafting as part of learning.\"",
        "That night, Mrs. Park messages you. \"Teacher, thank you for the report. We are confused by one part. At the conference you said Minseo was doing very well. If there was a concern about participation and perfectionism, why did we not discuss it then?\"",
        "She is right. By avoiding the conversation to protect the relationship, you created a credibility gap instead."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective 2: Mrs. Park''s View",
      "content": [
        "Mrs. Park does not think Minseo''s caution is automatically a problem.",
        "From her perspective, speaking only when prepared can signal seriousness, self-control, and respect for the classroom. Accuracy matters. Public mistakes can feel exposing.",
        "That does not mean she rejects your goal. But she needs help understanding your model. If you say Minseo is anxious or imply that academy culture is harming her, she may hear criticism of the family''s judgment. If you say instead, here is a skill our school explicitly teaches and here is how we can support it, she can work with you.",
        "The cultural dynamic here is not that Korean students are naturally quiet. It is that students may be moving between educational settings that reward different forms of seriousness."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What were you optimizing for when you framed the conversation?",
      "options": [
        "I wanted to be direct and honest.",
        "I wanted to protect the relationship while still naming the issue.",
        "I worried that critiquing perfectionism would sound like critiquing the family.",
        "I chose short-term comfort over long-term clarity.",
        "Write your own."
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "Dilemma 3: The KakaoTalk Room",
      "content": [
        "It is December.",
        "Mrs. Park sends you a message: \"Teacher, some of the class mothers already have a Kakao room. We were wondering if you would join, maybe just for class questions and reminders. It can be easier than email. If language is ever an issue, I can help summarize in Korean or English.\"",
        "Your school does not forbid parent messaging groups. Some teachers find them efficient. Others avoid them because the questions never stop.",
        "How do you respond?"
      ],
      "choices": [
        {
          "id": "choice_3a",
          "label": "Decline the group",
          "text": "\"Thank you, Mrs. Park. I really appreciate the thought. I find it fairest to communicate with families through our school portal and scheduled messages so everyone receives the same information. But please do feel free to contact me directly if there is something specific about Minseo.\"",
          "next": "consequence_3a"
        },
        {
          "id": "choice_3b",
          "label": "Accept the group",
          "text": "\"That sounds helpful. I''d be happy to join a class Kakao room if it makes communication smoother for families.\"",
          "next": "consequence_3b"
        },
        {
          "id": "choice_3c",
          "label": "Counter-propose",
          "text": "\"I''d love a smoother channel, but I also need to keep communication manageable. What if we create one whole-class Kakao announcement and Q and A room with clear expectations and a set weekday window?\"",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Consequence 3A",
      "content": [
        "Mrs. Park responds warmly enough. The parents'' Kakao room continues without you.",
        "At first, this seems fine. Then you realize that a lot of interpretation is happening elsewhere. Questions about homework, field trip expectations, and classroom norms are being answered in a space you never see. Sometimes the answers are accurate. Sometimes they are not.",
        "By January, parents begin approaching you in clusters: \"Some of us were wondering...\"",
        "You have protected your boundaries. But you are now outside the real-time communication channel through which much of the class community makes sense of school."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Consequence 3B",
      "content": [
        "The first week is excellent. One reminder about library day reaches everyone quickly. Parents help each other with translations. Mrs. Park answers two logistical questions before you even open the app.",
        "Then the pace changes. Questions arrive late at night. No one is rude. But the room has altered the emotional contract. Your availability is now visible, and so is your silence.",
        "You are more connected to families than before. You are also carrying them with you into the evening."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Consequence 3C",
      "content": [
        "Mrs. Park replies after a few minutes. \"Yes, I think that can work. If expectations are clear, parents will understand.\"",
        "You create a whole-class Kakao room with a clear description and set check-in window. Mrs. Park helps explain the setup to other parents.",
        "A non-Korean parent asks about homework format, and Mrs. Park answers correctly before you do.",
        "Something important shifts. Her expertise now has a sanctioned place. She is no longer trying to create closeness by private coordination. She is helping build class understanding in a structure that works for everyone.",
        "It is not frictionless. But the channel has boundaries, and the boundaries are visible."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Perspective 3: Mrs. Park''s View",
      "content": [
        "In many Korean school communities, KakaoTalk is an ordinary coordination tool. Parent groups often circulate reminders, interpretations of assignments, and practical updates quickly. A group channel can therefore feel efficient and reassuring rather than unusually intimate.",
        "When Mrs. Park proposes a group, she is probably not imagining an endless social feed. She is imagining a lightweight communication layer that reduces uncertainty and helps parents support the class smoothly.",
        "A teacher, however, experiences the same channel differently. What feels efficient to families can quietly become after-hours labor, real-time interpretation, and a source of inequity if some parents are more active or more connected than others.",
        "The friction is not really about an app. It is about communication expectations."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection 3",
      "prompt": "What were you protecting when you made your choice?",
      "options": [
        "My time and after-hours boundaries.",
        "Equity across all families.",
        "A closer relationship with Korean parents.",
        "Clarity and consistency in school communication.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Display the learner''s three choices in sequence.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised three recurring tensions in Korean international-school contexts.",
            "Teacher Authority and Homeroom Care: In Korean schooling, the homeroom teacher has historically carried more than instructional responsibility. Research on the homeroom institution shows strong expectations of relational guidance and affective care. That does not mean every parent expects the same thing, but it helps explain why families may see the homeroom teacher as a key coordinating adult.",
            "Parent-Teacher Communication: Fast, practical communication can carry a positive meaning in Korea: responsiveness, competence, and care. But the same channels can generate unclear expectations and after-hours overload unless the structure is visible and bounded.",
            "Shadow Education, Effort, and Risk-Taking: Supplementary education is common enough in South Korea that many families think across multiple learning sites. At the same time, classroom participation and public risk-taking may need explicit scaffolding for students who are used to showing seriousness through preparation, listening, and accuracy."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Jung, H.-J. (2014). Family Metaphors and Familism in the Homeroom Institution of Korean Schools.",
            "Lee, J.-A., and Kim, C.-J. (2019). Teaching and Learning Science in Authoritative Classrooms.",
            "Howard, N.-J. (2021). A Theoretical Examination of Shadow Education in South Korea."
          ]
        }
      ],
      "finalPrompt": "If you could go back to the first moment, when Mrs. Park showed you the academy planner, what would you say now, and how would you preserve both clarity and relationship?"
    }
  }',
  ARRAY[1, 2, 3],
  20,
  1,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;

-- Make the simulation live immediately
UPDATE public.pd_simulations
SET status = 'live'
WHERE id = 'c3d4e5f6-0003-0003-0003-000000000003';
-- Seed KSA Simulation 1: "The English-Only Wall"
-- Source: Codex-produced content package (ksa-english-only-wall.json)
-- Run AFTER 20260330_create_simulations.sql

INSERT INTO public.pd_simulations (
  id,
  module_id,
  title,
  description,
  context,
  characters,
  nodes,
  dimension_tags,
  estimated_minutes,
  sort_order,
  status
) VALUES (
  'b2c3d4e5-0002-0002-0002-000000000002',
  'ksa-001',
  'The English-Only Wall',
  'A parent shows you a planner note in your own handwriting. Her daughter told her grandmother she should speak English because Arabic is not for school.',
  'It is November at Al Noor International School. A sign above your whiteboard reads: Take risks. Share ideas. Use English. This morning, Mrs. Alharbi is waiting outside your classroom with a photo on her phone.',
  '[
    {
      "name": "You",
      "role": "2nd-year homeroom teacher at Al Noor International School",
      "description": "Trained UK/US/Australia. Year 5. Believes in inquiry, student voice, and strong relationships, and knows working inside a local context where international does not mean culturally neutral."
    },
    {
      "name": "Mrs. Alharbi",
      "role": "Mother of Layan",
      "description": "Chose international school for strong English, broader opportunities, and confident future for daughter. Also wants Layan to remain grounded in Arabic, Islam, and Saudi identity. Organized, polite, attentive."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A bright classroom. Student work on the wall. A sign above the whiteboard reads: Take risks. Share ideas. Use English.",
        "It is November at Al Noor International School.",
        "Your class includes Saudi students, Arab expatriate students, and a smaller number of international families. English is the language of instruction in most subjects. Arabic and Islamic Studies are taught separately.",
        "One of the routines your grade team uses is an English-first approach. Students are encouraged to use English in class discussions, group work, and transitions. Your room has an English points chart on the wall. It is meant to be light-touch and motivational, not punitive.",
        "Layan is one of your strongest students. She reads well above grade level, writes carefully, and tracks every detail of the lesson. She is especially eager in English. She also watches adults closely and wants to understand what counts in this school.",
        "This morning, Mrs. Alharbi is waiting outside your classroom. She holds up a photo on her phone. It is a page from Layan''s planner. At the top, in your handwriting, it says: Reminder: English in class discussions.",
        "\"Layan came home upset,\" Mrs. Alharbi says calmly. \"She told her grandmother she should answer in English because Arabic is not for school. She also said she lost a point for speaking Arabic with a classmate while planning a group task. I chose this school for English, yes. But not for her to feel Arabic is a problem. Can we talk about that?\"",
        "Your school has no formal written English-only policy, but the English-first culture is strong."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The English-Only Wall",
      "content": ["How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Defend the English-first approach",
          "text": "\"I completely understand the concern, Mrs. Alharbi. The reason we encourage English in class is to build confidence and fluency. It is never meant as a judgment on Arabic. In an international school, students need as much English practice as possible.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Reassure her, but change nothing",
          "text": "\"Thank you for telling me. I definitely don''t want Layan to feel that way. I''ll keep an eye on it.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Adapt the routine",
          "text": "\"Thank you for raising this. I want English practice, but I also don''t want students to internalize that Arabic is somehow lesser. I can adjust the routine so we still use English for final sharing, but allow Arabic during planning or peer clarification when needed.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Alharbi nods. \"I understand,\" she says. \"English is important.\"",
        "But the conversation closes instead of opens. Over the next two weeks, she becomes more formal in her messages. She still thanks you, but the warmth is gone.",
        "Layan, meanwhile, becomes even more vigilant. She corrects classmates: \"English, please.\" One afternoon, when a student asks for help in Arabic, Layan says quietly, \"We are not supposed to.\"",
        "What felt like an immersion routine to you has become a value hierarchy to her.",
        "At home, Mrs. Alharbi starts compensating. Layan now does extra Arabic reading each evening. The family is reinforcing identity at home because school no longer feels trustworthy on that point."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Alharbi looks relieved. \"Thank you, Teacher. I appreciate it.\"",
        "But in class, the wall chart stays up. The reminders continue. The structure is unchanged.",
        "A week later, Layan tells you, \"My mom said you were going to make it more balanced.\"",
        "That evening, a message appears: \"Teacher, thank you again for understanding. Layan said they still lose points if they use Arabic while working. I just want to understand what was adjusted.\"",
        "You were trying to avoid conflict. Instead, you created a trust gap."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "At first, the change feels workable.",
        "You revise the chart language from English Only to English for sharing and presenting. You tell students that bilingual thinking is allowed during planning, but final academic communication should move toward English. You also say explicitly: Arabic is not bad. English is the school''s working language in this class, but both languages matter.",
        "Layan visibly relaxes.",
        "Then your grade-level colleague Megan stops by after school. \"I heard you changed the language expectation,\" she says. \"If some classes are strict and others are flexible, families will compare. And if Arabic becomes okay during work time, some students may stay there and never stretch.\"",
        "A few days later, another parent asks whether her child can now use Hindi or Urdu in the same way.",
        "Your adaptation has opened a real pedagogical conversation. It may be the right move, but it is no longer a private fix."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective 1: Mrs. Alharbi''s View",
      "content": [
        "Mrs. Alharbi did not choose an international school because she wants her daughter to become less Saudi.",
        "She chose it because she wants more doors to remain open later: university options, professional confidence, ease in English, comfort in diverse spaces. But she also assumes those gains should sit on top of a stable base, not replace it.",
        "For her, Arabic is not just a home language. It is identity, family continuity, religion, and dignity. A child answering her grandmother in English is not simply practicing language. It signals that school has begun assigning prestige unevenly.",
        "She is not anti-English. She chose the school partly because of English. But the choice was for expansion, not substitution.",
        "The tension begins when the school treats English growth and cultural continuity as if they are naturally opposed, while the family is trying to hold both."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What assumption was driving your response?",
      "options": [
        "English immersion only works if the expectation is clear and consistent.",
        "I was trying to avoid a bigger ideological conversation.",
        "I assumed the parent was resisting English, not protecting balance.",
        "I saw the issue as classroom management, not identity.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Conference",
      "content": [
        "Three weeks later, it is conference week.",
        "Layan is excelling academically. Her English writing is among the strongest in the class. Her science notebook is meticulous. She is polite, punctual, and deeply responsive to structure.",
        "But there is a pattern you cannot ignore. She has started treating English as the language of status. During group work, she rolls her eyes when other students need help formulating an answer. In Arabic class transitions, she once said to a classmate, \"This part is easy anyway.\" Last week she told another student, \"Real school is in English.\"",
        "You believe this matters. But you also know how loaded the topic is.",
        "How do you frame the conference?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Lead with concern",
          "text": "\"Layan is doing extremely well academically, but I do want to raise one concern directly. I think she may be internalizing the idea that English is the smart language and that Arabic is less important. I''ve heard comments that suggest she is starting to rank languages and even people that way.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Lead with strengths, then frame the issue as a next-step goal",
          "text": "\"Layan has many strengths: diligence, precision, strong English, and real academic confidence. One next step I want to support is bilingual belonging, helping her see that being strong in English does not require distancing herself from Arabic or from classmates who move more slowly between languages.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Focus on achievement and leave the issue alone",
          "text": "\"Layan is thriving. Her academics are excellent, her work habits are strong, and she continues to be one of the most reliable students in the class.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Alharbi listens carefully, then goes still.",
        "\"I see,\" she says. \"At home, we do not teach her to disrespect Arabic.\"",
        "You soften your wording. You explain that Layan is wonderful and that this is about environment, not blame. But the frame is already defensive.",
        "At home, the message becomes corrective. Layan returns the following week noticeably cautious. She now adds, \"But Arabic is important too,\" in a rehearsed way that sounds less like conviction than insurance.",
        "You raised the issue. You did not deepen trust."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Mrs. Alharbi smiles at the strengths list. When you say bilingual belonging, she pauses.",
        "\"What do you mean exactly?\" she asks.",
        "You explain that Layan is thriving in English, which is wonderful, but she may be absorbing a hidden lesson that English equals status. \"I want her to feel expansive, not split. Strong in English, respectful in Arabic, and generous with peers.\"",
        "Mrs. Alharbi exhales. \"Yes,\" she says quietly. \"At home we have seen something similar. She answers her younger cousin in English now to show she knows more.\"",
        "Now the issue belongs to both of you. Together you make a small plan: you will publicly validate Arabic as a legitimate thinking tool and a valued subject, and she will reinforce at home that bilingualism is strength, not superiority."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "The conference is warm and easy. Mrs. Alharbi leaves feeling reassured.",
        "Six weeks later, semester comments go out. In Layan''s learning habits section, you write: \"Layan is encouraged to grow as a collaborative bilingual learner who values all classroom voices and languages.\"",
        "That evening, Mrs. Alharbi messages you. \"Teacher, thank you for the report. I was surprised by this comment. At the conference, we discussed only strengths. If there was a concern about how Layan sees Arabic and her classmates, I wish I had known earlier.\"",
        "She is right. By trying to protect the relationship from discomfort, you made the later feedback feel less trustworthy."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective 2: Mrs. Alharbi''s View",
      "content": [
        "Mrs. Alharbi does not hear this issue as a small language preference. She hears it as a question about what kind of person the school is helping her daughter become.",
        "In her mind, a successful child in an international school should become more capable, more open, and more confident, but not detached from family, religion, or language.",
        "If the teacher presents the issue as if the family created the problem by choosing international schooling, she may become defensive. But if the teacher presents it as a predictable side effect of an English-dominant environment, and as a developmental issue the school can help mediate, then the conversation feels fair.",
        "Many Saudi families choosing international schooling are trying to hold local continuity and global opportunity together."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What were you optimizing for?",
      "options": [
        "Clarity. I wanted the family to hear the issue directly.",
        "Relationship. I wanted to raise it without sounding accusatory.",
        "Self-protection. I did not want to enter a sensitive cultural conversation.",
        "Harmony. I hoped the issue would resolve without naming it.",
        "Write your own."
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "Dilemma 3: The WhatsApp Group",
      "content": [
        "It is January.",
        "The school is preparing for a week of student presentations and displays about future pathways, family backgrounds, and community connections. The official materials are polished and upbeat, but they are written almost entirely in English and use familiar international-school language: voice, leadership, reflection, and global awareness.",
        "That evening, Mrs. Alharbi messages you: \"Teacher, some of the mothers were saying the school updates are clear in English, but sometimes we still want to check what they mean in practice. Would you join a small WhatsApp group with us? It can be easier to ask quick questions than through the app.\"",
        "Your school does not ban class WhatsApp groups, but it does not actively manage them either.",
        "How do you respond?"
      ],
      "choices": [
        {
          "id": "choice_3a",
          "label": "Decline the group",
          "text": "\"Thank you, Mrs. Alharbi. I appreciate the idea. I find it fairest to keep communication through the school app and email, so all families receive the same information the same way. But please always feel free to message me directly about Layan.\"",
          "next": "consequence_3a"
        },
        {
          "id": "choice_3b",
          "label": "Accept the group",
          "text": "\"Yes, that sounds helpful. I''d be happy to join a small WhatsApp group if it makes communication easier for families.\"",
          "next": "consequence_3b"
        },
        {
          "id": "choice_3c",
          "label": "Counter-propose",
          "text": "\"I want families to feel clear and included, but I also need to keep communication manageable and equitable. What if we create one whole-class bilingual FAQ or Q and A channel, and I check it during a set time window?\"",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Consequence 3A",
      "content": [
        "Mrs. Alharbi replies politely. The mothers keep their WhatsApp group without you.",
        "At first, this seems fine. Then you notice that interpretation is happening elsewhere. Questions about the meaning of activities, whether something is optional, and how public a student performance will be are being worked out in a parent space you cannot see.",
        "Eventually, some concerns arrive to you already socially consolidated.",
        "You have protected your evenings. But you are now outside the loop where a meaningful portion of school sense-making is happening."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Consequence 3B",
      "content": [
        "The first week feels efficient. One message clarifies a schedule change in minutes. A parent helps translate a reminder. Mrs. Alharbi thanks you often.",
        "Then the questions deepen, not because anyone is rude, but because access has changed expectations.",
        "\"For the presentation, can students include Arabic words on slides, or should everything stay in English?\"",
        "\"When the task says family background, how personal should the children be?\"",
        "\"Can students use local examples in the pathways display, or should they keep to the examples from class?\"",
        "These are reasonable questions. That is the challenge.",
        "You are no longer only sharing information. You are now interpreting the school''s language and expectations after hours.",
        "You are more trusted. You are also carrying more of the school''s cultural translation work yourself."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Consequence 3C",
      "content": [
        "Mrs. Alharbi takes a few minutes, then responds: \"Yes, I think that is reasonable. The main thing is clarity.\"",
        "You create a visible structure: one whole-class bilingual FAQ post each week, plus a short Q and A window on weekday evenings. Families can ask questions in Arabic or English.",
        "The impact is immediate. A parent asks whether students may include Arabic phrases in their display. Another parent answers, \"I think yes, as long as the main explanation is clear.\" You then confirm the school expectation.",
        "The school has not changed its ethos. But the ethos is no longer mysterious. You have created a structure where clarification is shared rather than privatized."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Perspective 3: Mrs. Alharbi''s View",
      "content": [
        "Mrs. Alharbi is not necessarily asking for special access. She is asking for interpretive reassurance.",
        "In an international school, many messages are understandable at the level of vocabulary but still unclear in practice. A family may understand the words on the page and still wonder what a task will actually look like, what counts as appropriate participation, or whether local cultural examples are welcome.",
        "A WhatsApp group lowers the threshold for asking those questions. It feels fast, human, and practical. From the parent''s side, it can feel like the shortest path to confidence.",
        "From the teacher''s side, the same channel can become unscripted labor. Quick clarification turns into ongoing interpretation."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection 3",
      "prompt": "What were you protecting when you made your choice?",
      "options": [
        "My time and personal boundaries.",
        "Equity across all families.",
        "Interpretive clarity for local families.",
        "A professional communication structure I could sustain.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Display the learner''s three choices in sequence.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised three recurring tensions in international schooling in the Kingdom of Saudi Arabia.",
            "International Ethos versus Cultural or Religious Identity: Families choosing international or private schooling in Saudi Arabia often do so for English, pedagogy, and future opportunity. At the same time, many also care deeply about Arabic, Islamic education, cultural continuity, and moral fit. The tension is not that those families are inconsistent. The tension is that the school may treat those priorities as if they compete more sharply than parents do.",
            "Parent-Teacher Communication: In contexts of cultural dissonance, communication does more than update families. It helps interpret the school. Leaders and teachers in Saudi international schools often work inside a real gap between an international-school ethos and conservative local expectations.",
            "English, Arabic, and Belonging: English-medium schooling can be highly valued by Saudi families, but the social meaning of English still matters. The issue is not usually whether children should become strong in English. It is whether English is presented as an added capacity or as a quiet hierarchy of value."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Hammad, W., and Shah, S. (2018). Dissonance Between the International and the Conservative National.",
            "Alothman et al. (2024). How Saudi parents rationalize the choice of school for their children.",
            "Alsaawi and Almulhim (2024). Impact of the English-Only Policy on Learners at International Schools in the Saudi Context."
          ]
        }
      ],
      "finalPrompt": "If you could go back to the first moment, when Mrs. Alharbi showed you the planner note and asked about Arabic, what would you say now? How would you preserve English growth without teaching a hierarchy of belonging?"
    }
  }',
  ARRAY[1, 2, 3],
  20,
  1,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  context      = EXCLUDED.context,
  characters   = EXCLUDED.characters,
  nodes        = EXCLUDED.nodes,
  status       = EXCLUDED.status;

-- Make the simulation live immediately
UPDATE public.pd_simulations
SET status = 'live'
WHERE id = 'b2c3d4e5-0002-0002-0002-000000000002';
