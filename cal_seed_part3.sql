-- ─────────────────────────────────────────────────────────────────────────────
-- PATCH: Korea module research integration — Session 3 JSTOR findings
-- Run after: 20260330_create_pd_layer.sql
--
-- Changes:
--   1. Korea D2 (Collectivism & Group Harmony) — add Bong (2008) teacher-as-
--      parental-envoy mechanism to content sections + citations.
--   2. Korea D5 (Teacher Authority & Hierarchical Expectations) — add Bong
--      (2008) directly to content sections + citations, upgrade research_status
--      from 'partial' to 'fully_sourced'.
--   3. Korea D3 (Confucian Educational Values) — remove Takayama (2009) from
--      citations (low relevance, Japan-focused).
-- ─────────────────────────────────────────────────────────────────────────────

-- ── 1. Korea D2: add Bong (2008) teacher-as-parental-envoy ───────────────────
UPDATE public.pd_dimensions
SET content = jsonb_set(
  jsonb_set(
    content,
    '{sections}',
    (content->'sections') || jsonb_build_array(jsonb_build_object(
      'heading', 'The Teacher as Parental Envoy',
      'items', jsonb_build_array(
        'Bong (2008) identifies a mechanism specific to Korean parent–teacher relations: the teacher is implicitly expected to act as a parental envoy inside the school — enforcing family-aligned values and relaying the family''s social aspirations onto the student.',
        'This creates a tripartite accountability loop: teacher ↔ student ↔ parent, in which the teacher is not a neutral professional but a trusted extension of the family unit.',
        'Western-trained teachers who position themselves as independent from parental input — or who openly contradict a family''s academic priorities — rupture this expectation and are perceived as failing a core professional duty.',
        'Practical implication: parent communication should position you as aligned with the family''s long-term goals, even when your pedagogical approach differs. Frame divergences as complementary, not oppositional.'
      )
    ))
  ),
  '{citations}',
  COALESCE(content->'citations', '[]'::jsonb) || jsonb_build_array(jsonb_build_object(
    'author', 'Bong, M.',
    'year', 2008,
    'title', 'Effects of parent-child relationships and classroom goal structures on motivation, help-seeking avoidance, and cheating',
    'journal', 'Journal of Experimental Education',
    'doi', '10.3200/JEXE.76.2.191-217'
  ))
)
WHERE module_id = 'korea-001'
  AND dimension_number = 2;

-- ── 2. Korea D5: add Bong (2008), upgrade to fully_sourced ───────────────────
UPDATE public.pd_dimensions
SET
  research_status = 'fully_sourced',
  content = jsonb_set(
    jsonb_set(
      content,
      '{sections}',
      (content->'sections') || jsonb_build_array(jsonb_build_object(
        'heading', 'Bong (2008): Authority, Hierarchy, and Academic Self-Regulation',
        'items', jsonb_build_array(
          'Bong (2008) provides direct empirical support for how Korean hierarchical classroom norms affect student motivation and behaviour in relation to teacher authority.',
          'Students in high power-distance classrooms (characterised by unquestioned teacher authority) show significantly higher rates of help-seeking avoidance — they will not ask for help rather than risk face loss in front of a teacher they view as an authority figure, not a resource.',
          'The same study links hierarchical expectations to elevated academic dishonesty: when students perceive the teacher–student gap as unbridgeable, cheating becomes a rational response to unattainable standards rather than a moral failure.',
          'For foreign teachers: students who appear passive, disengaged, or evasive are often navigating this authority gap. Reducing perceived hierarchy — through side-by-side feedback rather than front-of-class correction — meaningfully improves engagement and honest academic effort.'
        )
      ))
    ),
    '{citations}',
    COALESCE(content->'citations', '[]'::jsonb) || jsonb_build_array(jsonb_build_object(
      'author', 'Bong, M.',
      'year', 2008,
      'title', 'Effects of parent-child relationships and classroom goal structures on motivation, help-seeking avoidance, and cheating',
      'journal', 'Journal of Experimental Education',
      'doi', '10.3200/JEXE.76.2.191-217'
    ))
  )
WHERE module_id = 'korea-001'
  AND dimension_number = 5;

-- ── 3. Korea D3: remove Takayama (2009) from citations ───────────────────────
UPDATE public.pd_dimensions
SET
  content = jsonb_set(
    content,
    '{citations}',
    COALESCE(
      (
        SELECT jsonb_agg(c)
        FROM jsonb_array_elements(content->'citations') AS c
        WHERE NOT (c->>'author' ILIKE '%Takayama%')
      ),
      '[]'::jsonb
    )
  )
WHERE module_id = 'korea-001'
  AND dimension_number = 3;

-- ── Verify ────────────────────────────────────────────────────────────────────
-- After running, confirm:
--   SELECT dimension_number, research_status,
--          jsonb_array_length(content->'citations') as citation_count
--   FROM pd_dimensions
--   WHERE module_id = 'korea-001'
--   ORDER BY dimension_number;
--
-- Expected: D2 and D5 have one more citation each, D5 research_status = 'fully_sourced',
--           D3 citation count reduced by 1.
-- ─────────────────────────────────────────────────────────────────────────────
-- CHINA MODULE: Full content rewrite — all 6 dimensions + 4 new scenarios
-- Sources: Li (2005), Ran (2001), Dahlin & Watkins (2000), Jin & Cortazzi (1998)
-- Run after: 20260330_create_pd_layer.sql
-- ─────────────────────────────────────────────────────────────────────────────

-- ══════════════════════════════════════════════════════════════════════════════
-- D1 — Mind vs. Virtue: Two Models of What Learning Is
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Mind vs. Virtue: Two Models of What Learning Is',
  research_status = 'fully_sourced',
  content = '{
    "summary": "In Western education, learning is framed as developing the mind—cultivating curiosity, inquiry, and self-esteem through discovering knowledge. In China, learning is framed as becoming a better person through diligence, humility, and moral self-perfection. These are not minor pedagogical differences; they shape how students interpret feedback, define success, and understand why they are in school. You will need to decode this gap early, because a compliment that seems encouraging in one system can signal concern in the other.",
    "sections": [
      {
        "heading": "The Two Models: Mind vs. Virtue",
        "items": [
          "Western education is anchored in what researchers call a ''mind orientation''—inherited from the Socratic tradition. The goal is to develop students'' intellectual capacity: awaken curiosity, teach them to question, help them discover knowledge themselves. A successful student thinks independently and feels pride in their achievement. Failure brings disappointment or doubt in one''s ability.",
          "Chinese education is anchored in what researchers call a ''virtue orientation''—inherited from Mencian philosophy. The goal is to become a better person through self-discipline and moral development. Diligence, humility, endurance, concentration, and perseverance are not side effects of learning; they are learning. A successful student continues striving toward moral self-perfection with humility. Failure generates shame and guilt—but shame is a moral motivator, not a signal of inadequacy.",
          "The numbers are stark. When researchers asked Chinese college students to define ''knowledge,'' 79% said it means ''a need to self-perfect and spiritual power.'' Only 15% of Western students gave similar answers. Conversely, 96% of Western students defined knowledge as ''facts, information, skills, understanding.'' Only 32% of Chinese students did.",
          "These are not neutral differences. They shape the entire student experience. Chinese students expect to learn through a sequence: memorize, then understand, then apply, then question. Western teachers often expect questioning first—which can look like laziness or unwillingness to engage before students have secured the material."
        ]
      },
      {
        "heading": "How This Shapes Classroom Behavior",
        "items": [
          "In a virtue-oriented system, speaking has weight. To speak up in class is to commit yourself—to claim you have something worth saying, to stake your reputation on being right. If you cannot back your claim with action, silence is safer than false confidence. This is not shyness or passivity; it is moral caution. Chinese students see quiet receptiveness as methodical and disciplined; Western teachers sometimes read it as lacking critical thinking.",
          "Chinese children as young as four describe school''s purpose differently than Western peers. Ask a Chinese child why they go to school, and they will say: self-improvement, mastery, contribution to society. Ask a Western child, and they will say: friendship, play, being smart. These are not quirks—they reflect what their educational cultures emphasize from the start.",
          "The gap shows up when Western teachers praise ''good questions'' or ''challenging the material.'' In a mind-oriented system, this is encouragement. In a virtue-oriented system, this can read as permission to disrespect the teacher''s expertise. One teacher in Hong Kong was puzzled when praised questioning did not lead to more questions; she eventually realized her students heard ''question authority'' as morally dangerous.",
          "Participation grades—common in Western classrooms—create genuine conflict for virtue-oriented learners. Speaking in class is not practice; it is commitment. You do not earn points for tentative thinking; you speak when you are ready to stand by what you have said."
        ]
      },
      {
        "heading": "How Parents and Teachers Define Success Differently",
        "items": [
          "When a Western teacher writes ''good vocabulary and satisfactory spelling,'' they mean to encourage. The student is doing well. But Chinese parents hear ''satisfactory'' as barely adequate—not meeting expectations but only just meeting them. The same language that feels affirming in one system signals concern in the other.",
          "Chinese parents look for weak points because they assume the teacher''s job is to praise and the parent''s job is to fix gaps. Extra homework, extra practice, extra tutoring—these show investment and love. When a Western teacher suggests no extra homework is needed, the parents may hear ''I am not taking your child''s education seriously enough to identify what needs work.''",
          "The grading system reinforces this. In Chinese systems, 100/100 is achievable and meaningful—perfection exists and is worth pursuing. In Western systems, an A covers a range (90–100 typically), and perfection is not the stated goal. A student who scores 95 and one who scores 100 both ''get an A''—but in a Chinese frame, that is 5 points of waste.",
          "A ''good teacher'' in the Western frame arouses interest, explains clearly, and organizes activities. A ''good teacher'' in the Chinese frame has deep knowledge, can answer any question, and serves as a moral model. When you fall short of the Chinese image, parents do not necessarily think you are bad—they may think you are simply young or inexperienced."
        ]
      }
    ],
    "citations": [
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"},
      {"author": "Pratt, Kelly, & Wong", "year": 1999, "title": "Chinese Conceptions of Effective Teaching in Hong Kong", "journal": "International Journal of Lifelong Learning"},
      {"author": "Jin, L. & Cortazzi, M.", "year": 1998, "title": "Dimensions of Dialogue: Large Classes in China", "journal": "International Journal of Educational Research"},
      {"author": "Ran, A.", "year": 2001, "title": "Travelling on Parallel Tracks: Chinese Parents and English Teachers", "journal": "Educational Research", "doi": "10.1080/00131880110081062"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 1;


-- ══════════════════════════════════════════════════════════════════════════════
-- D2 — Parent-Teacher Communication: "Parallel Tracks"
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Parent-Teacher Communication: Parallel Tracks',
  research_status = 'fully_sourced',
  content = '{
    "summary": "Chinese parents and Western teachers often believe they have communicated after a meeting when they have actually talked past each other on parallel tracks. Parents listen for weak points and specific actions to take at home. Teachers speak about targets and growth. Parents want accuracy; teachers want process. Praise alarms Chinese parents; constructive criticism reassures them. Understanding these patterns before your first parent meeting will save you months of frustration and prevent small misunderstandings from becoming trust fractures.",
    "sections": [
      {
        "heading": "What Parents Hear vs. What You Mean to Say",
        "items": [
          "When you tell a Chinese parent their child has ''good vocabulary,'' they may hear ''spelling is a problem.'' When you call something ''satisfactory,'' they interpret it as barely adequate. The same praise that feels warm in a Western context can sound like thinly veiled criticism to a parent from a virtue-oriented system, where the focus is always on what needs fixing.",
          "Parents want you to identify weak points explicitly. They are listening for specifics: which grammar mistakes? Which calculation errors? Which books does the child struggle with? A teacher who emphasizes ''overall she is doing well'' leaves parents frustrated because they hear nothing actionable.",
          "The word ''target'' means different things. You might say ''our target this term is to build confidence in public speaking''—framed as a stretch goal. Parents hear ''target'' as a pass-or-fail benchmark. Miss it, and the child has failed. The framing of goals as iterative and growth-oriented feels foreign to parents whose system treats targets as binary.",
          "Scores above 80% sound like excellence in Western contexts but incomplete in Chinese contexts. An 85% might be a solid B or A-; in the Chinese system, 85% is 15 points lost, and parents want to know which 15."
        ]
      },
      {
        "heading": "Three Case Studies: Real Parent-Teacher Friction",
        "items": [
          "Jiahui''s mother praised the school but left meetings confused. Mrs Smith had celebrated Jiahui''s vocabulary as ''good'' and spelling as ''satisfactory.'' Mrs Lu wanted specific weaknesses to address at home. She bought extra spelling workbooks, assigned Chinese homework, and was frustrated the school did not use standard textbooks she could follow along with. The teacher and parent shared one goal—better spelling—but incompatible vocabularies made alignment impossible.",
          "Yang''s father looked at a report showing ''above average, performing really well'' and felt alarm. In his frame, ''half marks in total'' was the salient data point. Mrs Brown saw an A-grade equivalent; Mr Tan saw 50% failure. He asked for extra homework to take home. Mrs Brown reassured him everything was fine—which, to Mr Tan, meant she was not paying close enough attention.",
          "Bob stood up to answer a question—normal in Chinese classrooms—and was embarrassed when no one else did. His early behavioral problems (''naughty—not horrendously naughty, but not on task'') were cultural adjustment, not defiance. He was encouraged to write in Chinese, but the teacher wanted it translated to English. No one had made the expectation explicit.",
          "Mr Zhao attended his son Qirui''s meeting and left wanting more emphasis on weaknesses. Mrs Lewis had actually spent significant time on areas for development—but in indirect, child-centered language that Mr Zhao did not register as criticism. Chinese academic discourse is very direct; British child-centered discourse wraps critique in encouragement. The wrapping is invisible to Chinese parents."
        ]
      },
      {
        "heading": "The Parallel Tracks Pattern",
        "items": [
          "Parents listen for ''weak points.'' Teachers stress ''targets.'' Same goal, incompatible vocabulary. Both sides leave meetings believing they communicated when they did not.",
          "Parents want accuracy and perfect scores. Teachers want growth and process. Mrs Brown told Mr Tan: ''It is not the answer. It is how you get there. It is not winning the race, but to see how you run it.'' This is meaningless in a system where the answer IS the measure of learning.",
          "Extra homework from parents means love and investment—not pressure. Chinese parents will spend hours supervising study, buying extra materials, drilling weak areas. A teacher who says ''no extra homework needed'' is perceived as uncommitted.",
          "Praise alarms Chinese parents. Criticism, constructively framed, reassures them. One parent observed that British teachers ''make excuses for children in order to encourage them, whereas Chinese teachers criticize children in an effort to pressurize them to improve.'' The parent found the encouragement frustrating."
        ]
      },
      {
        "heading": "How to Bridge the Tracks",
        "items": [
          "Be explicit about weaknesses. Do not frame everything as ''areas for growth.'' Say: ''Her addition is solid. Subtraction with regrouping is where we are focusing. Here is what that looks like at home.'' Directness is clarity, not coldness.",
          "Separate process from outcomes. When a parent wants 100%, do not dismiss it. Say: ''I understand 100% is your goal. We are building toward that. This week it is X; next week Y.'' Connect their outcome focus to your process focus.",
          "Expect parents to do extra work at home—and welcome it. Give them specific, high-value actions: ''The most helpful thing is to have him explain what he learned today. Not drill; conversation.'' This channels their energy productively.",
          "Provide visual evidence. Photos of classwork, annotated samples, rubrics with checkmarks. A parent who can see exactly which letters need improvement or which math steps were skipped trusts that you have actually looked closely.",
          "Acknowledge the system gap openly. ''I know our grading looks different from what you are used to. Let me explain what an A means in our system, and how I track progress within that band.'' Transparency prevents the parallel-track drift."
        ]
      }
    ],
    "citations": [
      {"author": "Ran, A.", "year": 2001, "title": "Travelling on Parallel Tracks: Chinese Parents and English Teachers", "journal": "Educational Research", "doi": "10.1080/00131880110081062"},
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 2;


-- ══════════════════════════════════════════════════════════════════════════════
-- D3 — Exam Culture, System Structure, and the Stakes
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Exam Culture, System Structure, and the Stakes',
  research_status = 'partial',
  content = '{
    "summary": "China''s examination system is high-stakes in ways that shape every decision a parent makes about their child''s education. The gaokao—a single national exam taken once in year 13—determines university entry, which largely determines career. Vocational tracks are differentiated early and hard to switch from. Tutoring is technically restricted but thrives in shadow markets. International schools offer an alternative pathway, but parents bring gaokao-shaped expectations with them. Understanding the system''s logic helps you understand why parents push so hard and why international education feels both liberating and unsettling to them.",
    "sections": [
      {
        "heading": "The Gaokao and Why Every Year Counts",
        "items": [
          "The gaokao is not just an important exam. It is the primary mechanism by which students are sorted into universities, and universities are stratified by prestige and placement outcomes. A student''s university determines the jobs they are recruited for, the networks they enter, and often their geographic mobility. There is no second chance; you take it once. This is not helicopter parenting—it is rational response to genuine scarcity.",
          "Because the gaokao looms, parents reason backward. A first-grader''s habits, strengths, and weaknesses now will compound through nine years. Early intervention—extra tutoring, specific skill-building, character cultivation—is insurance. The parent investing heavily now is trying to prevent a crisis when the child reaches year 13 unprepared.",
          "Track differentiation begins early and is largely irreversible. Students are sorted into academic vs. vocational tracks, sometimes as early as middle school. The academic track leads to gaokao; the vocational track leads to different examinations and different outcomes. Parents fight fiercely for the academic track because switching later is difficult.",
          "International schools are partly an escape valve from this pressure. Parents choose international education hoping for more balance. But they often cannot release the gaokao-shaped expectations they have internalized. A teacher who says ''we do not grade or rank students'' can confuse parents who see ranking as essential preparation."
        ]
      },
      {
        "heading": "How the System Shapes Learning Beliefs",
        "items": [
          "The gaokao does not just select students; it reinforces the virtue-oriented model of learning. The system rewards diligence, persistence, concentration, and willingness to endure hardship. A student who studies eight hours a day, memorizes efficiently, and maintains focus for three-hour exam blocks is not wasting time—they are developing exactly the character traits their culture values.",
          "The shadow tutoring economy persists despite the Double Reduction policy of 2021, which banned for-profit tutoring for K–9. Parents find loopholes: private tutoring, online classes framed as ''enrichment,'' study groups with paid facilitators. For parents, tutoring is risk mitigation. For students, it is often exhausting normality.",
          "Grading systems embody these stakes. A Chinese system allows 100/100—perfection is achievable and meaningful. A Western system uses letter grades or bands where an A is 90–100. A Chinese parent sees 95/100 as five points of failure; a Western teacher sees 95/100 as excellent. These are not different standards; they are different assumptions about whether perfection is the standard.",
          "Chinese children''s beliefs about learning—diligence, persistence, concentration as moral virtues—are reinforced by this system every day. The system and the culture are mutually reinforcing; neither can be understood without the other."
        ]
      },
      {
        "heading": "What Parents Expect From International Schools",
        "items": [
          "Parents enroll children in international schools partly to escape gaokao pressure and partly to hedge their bets. They want the option of studying abroad. They also hope for a more balanced education. But they often have not released the underlying assumption: education''s primary purpose is preparation for high-stakes sorting.",
          "When your school says it does not rank students or publish league tables, parents may feel liberated or anxious. Explaining how a process-focused system still builds the skills that matter—on any high-stakes exam—is essential early communication.",
          "Expect questions about rigor and comparisons. ''What percentage of graduates get into top universities?'' ''How does your English teaching compare?'' These questions are rational in their framework. Answering evasively creates doubt. Answer directly, then reframe.",
          "The most effective parent communication acknowledges the tension: ''We are not preparing for the gaokao, but we are building the deep learning and resilience that help students succeed on any high-stakes exam. Here is what that looks like in practice.'' Validate the concern, then clarify the approach."
        ]
      }
    ],
    "citations": [
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"},
      {"author": "Ministry of Education (China)", "year": 2021, "title": "Circular on Further Reducing Burden of Homework and Off-Campus Tutoring for Compulsory Education Students"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 3;


-- ══════════════════════════════════════════════════════════════════════════════
-- D4 — Classroom Dynamics and the Learning Sequence
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Classroom Dynamics and the Learning Sequence',
  research_status = 'fully_sourced',
  content = '{
    "summary": "Chinese students learn through a specific sequence: memorize first, then understand, then apply, then question. Western teachers often expect immediate verbal engagement and questioning—which asks students to skip to step four before completing steps one through three. The result is a classroom where silence looks like disengagement but is actually disciplined method, and where the teacher''s most encouraging behaviors can feel disorienting to students trained in a different order of operations.",
    "sections": [
      {
        "heading": "The Four-Step Sequence: Memorize, Understand, Apply, Question",
        "items": [
          "Chinese learners typically follow a sequence that looks like this: first, commit the new material to memory. Second, work toward understanding through sustained personal effort. Third, apply the knowledge to real situations. Fourth—and only then—question it, challenge it, extend it. Western classrooms often start at step four: ''What do you think about this? Challenge the idea. Ask questions.'' To a Chinese student, this feels like being asked to critique a building before seeing the blueprints.",
          "Dahlin and Watkins found that Chinese students use memorization and repetition more than British peers—but for different purposes. British students viewed understanding as sudden insight, a flash of clarity. Chinese students viewed understanding as a long process requiring extensive personal effort, with memorization as a path toward deeper comprehension, not a substitute for it.",
          "This means a Chinese student who is silently re-reading a passage is not stuck. They are on step one or two—securing the material before they are ready to discuss it. Asking them to ''share their initial reactions'' can feel premature and anxiety-inducing, because they have not yet earned the right (in their framework) to have reactions.",
          "Repetition is not rote. In the Chinese model, you repeat to deepen, not just to recall. Each pass through the material adds a layer of understanding. Western teachers who see repetition as low-level and discussion as high-level are mapping their own hierarchy onto a different system."
        ]
      },
      {
        "heading": "Why Silence Is Not Disengagement",
        "items": [
          "Speaking in the Confucian tradition carries moral weight. To speak is to commit yourself—to claim publicly that your idea has merit. If you cannot back your claim with action, the virtuous choice is silence. Kim (2002) found that speaking did not interfere with Western students'' thinking performance but actively interfered with Asian American students''. The processing mode is different.",
          "Pratt, Kelly, and Wong (1999) found that Western teachers in Hong Kong characterized Chinese students as ''quiet and receptive, lacking a challenging attitude toward authority.'' The students themselves described learning as requiring ''tremendous dedication and methodical steps.'' Both descriptions are accurate—they are just describing different things.",
          "When you ask a question and get silence, it does not mean nobody knows the answer. It may mean everyone is still in the memorize-and-understand phase and considers it premature to speak. Or it may mean students know the answer but see no reason to perform knowledge publicly when the teacher already knows it.",
          "Participation grades create a genuine ethical conflict: you are asking students to perform a behavior (tentative public thinking) that their moral framework considers reckless. This does not mean you cannot build toward participation—but understand that you are asking for cultural code-switching, not just a classroom skill."
        ]
      },
      {
        "heading": "Process vs. Product: The Daily Friction Point",
        "items": [
          "One teacher, Mrs Brown, described her Chinese student Yang as following instructions ''to the letter''—expending great effort, very anxious about mistakes. But when asked to do investigative maths (open-ended problem-solving), Yang responded: ''I have not got the answer yet''—as if the task was to find the single correct answer, not to explore the problem. Mrs Brown''s philosophy was: ''It is not the answer. It is how you get there.'' Yang''s framework had no space for this.",
          "A ''good teacher'' in the Western frame arouses interest, explains clearly, and organizes activities. A ''good teacher'' in the Chinese frame has deep subject knowledge, can answer any question, and serves as a moral model for students. When you prioritize facilitation over instruction, students may feel you do not know the material well enough to teach it directly.",
          "Homework follows the same split. Chinese parents expect homework to reinforce and drill specific skills taught that day. Open-ended homework (''write about something interesting'') can confuse both parents and students because it lacks the structure that signals rigor."
        ]
      }
    ],
    "citations": [
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"},
      {"author": "Dahlin, B. & Watkins, D.", "year": 2000, "title": "The Role of Repetition in the Processes of Memorizing and Understanding", "journal": "British Journal of Educational Psychology", "doi": "10.1348/000709900157976"},
      {"author": "Kim, H.S.", "year": 2002, "title": "We Talk, Therefore We Think? A Cultural Analysis of the Effect of Talking on Thinking", "journal": "Journal of Personality and Social Psychology", "doi": "10.1037/0022-3514.83.4.828"},
      {"author": "Ran, A.", "year": 2001, "title": "Travelling on Parallel Tracks: Chinese Parents and English Teachers", "journal": "Educational Research", "doi": "10.1080/00131880110081062"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 4;


-- ══════════════════════════════════════════════════════════════════════════════
-- D5 — Homework, Praise, and What "Support" Means
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Homework, Praise, and What "Support" Means',
  research_status = 'fully_sourced',
  content = '{
    "summary": "Chinese parents and Western teachers have fundamentally different definitions of what it means to support a child''s learning. Parents show support through extra homework, close monitoring of weak points, and direct criticism aimed at improvement. Teachers show support through encouragement, celebrating progress, and building self-esteem. Neither side realizes their version of support looks like neglect—or even harm—to the other. This dimension is a translation guide for the daily interactions where these systems collide.",
    "sections": [
      {
        "heading": "Homework as Love Language",
        "items": [
          "Chinese parents giving extra homework at home is not pressure. It is care. Mrs Lu, a parent in Ran''s study, said: ''If we know the content of the textbook, we can check and help her if she has any problem. Now we cannot follow her. Since we cannot help her, we feel guilty.'' She was frustrated that the school did not use standard textbooks she could track.",
          "Another parent: ''Chinese parents, no matter how busy we are, we will spend some time in child''s study. The problem is we do not know how to help her.'' The desire to help is intense and genuine. Parents who request extra homework from you are testing your commitment to their child, not burdening them.",
          "Mrs Brown discovered that parents were doing extensive supervised work at home—and she had no idea. ''They were anxious for me to provide them with material for them to work with at home.'' When she found out, she felt conflicted: providing worksheets felt like capitulating to drill culture, but she recognized the parents'' effort as deeply invested care.",
          "When you say ''no extra homework needed,'' parents hear: ''I have not identified any weaknesses worth addressing.'' This does not mean you should assign busy-work. It means you should offer specific, targeted practice: ''This week, practice these five subtraction problems. Here is exactly where he gets confused.''"
        ]
      },
      {
        "heading": "Praise as Alarm, Criticism as Reassurance",
        "items": [
          "Chinese parents observed that British teachers ''make excuses for children in order to encourage them, whereas Chinese teachers criticize children in an effort to pressurize them to improve.'' One parent found it ''frustrating that the teacher seemed to spend more time praising than complaining or pointing out her weaknesses.''",
          "When you say ''your child''s vocabulary is good,'' parents hear you highlighting vocabulary because everything else is a problem. When you say ''satisfactory,'' they hear ''barely passing.'' The same words carry different emotional weight across the two systems.",
          "Parents take your good points for granted and focus on the weak points—because that is where action is needed. A teacher who only delivers good news is perceived as either unobservant or withholding the truth. Directness about weaknesses is what builds trust.",
          "This does not mean you should abandon encouragement. It means you should lead with the weakness, then follow with the strength. ''Subtraction with regrouping needs work—here is our plan. Her addition and multiplication are strong, which tells me she has the foundation to get there.'' The parent hears a professional who has actually looked."
        ]
      },
      {
        "heading": "Translation Guide: What They Say, What They Mean, What to Do",
        "items": [
          "Parent says: ''Can you give her more homework?'' They mean: ''I want to be involved in her learning at home. Give me something concrete to do.'' What to do: provide specific, targeted practice. Frame it as partnership, not extra burden.",
          "Parent says: ''Is 85% good enough?'' They mean: ''I see 15 points of room for improvement. Which 15?'' What to do: break down the score. Show exactly which concepts were missed and what the plan is. Do not just say ''85% is great.''",
          "Parent says: ''The teacher in China would have told me exactly what to fix.'' They mean: ''Your feedback is too vague for me to act on.'' What to do: be specific. ''Chapter 3 fractions are solid. Chapter 4 decimals need more practice. Here is a worksheet.''",
          "Parent says nothing and seems satisfied. They may mean: ''I do not know how to navigate this system, so I will handle it at home.'' What to do: proactively share detailed written feedback. Do not assume silence means agreement."
        ]
      }
    ],
    "citations": [
      {"author": "Ran, A.", "year": 2001, "title": "Travelling on Parallel Tracks: Chinese Parents and English Teachers", "journal": "Educational Research", "doi": "10.1080/00131880110081062"},
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 5;


-- ══════════════════════════════════════════════════════════════════════════════
-- D6 — Cultural Identity and the Third Culture Child
-- ══════════════════════════════════════════════════════════════════════════════
UPDATE public.pd_dimensions
SET
  title = 'Cultural Identity and the Third Culture Child',
  research_status = 'partial',
  content = '{
    "summary": "Chinese children in international schools live between two models of learning every day. At home: diligence, humility, moral effort, respect for authority, and the pursuit of perfection. At school: curiosity, self-expression, questioning, and the celebration of process over product. The child navigating both systems does not blend them—they code-switch between them, often without anyone noticing. Understanding this dual existence is essential to supporting students who may look adapted but are quietly managing a deeper tension.",
    "sections": [
      {
        "heading": "The Question No One Asks",
        "items": [
          "Li poses the central question directly: ''How does acculturation of learning beliefs proceed when children reared in one culture attend school in another?'' Chinese children in international schools live this question daily. They are educated in one model and raised in another. The two systems do not merge naturally.",
          "Children''s learning beliefs become stronger with age, not weaker. Li and Wang (2004) found that by kindergarten, Chinese children already describe learning in terms of self-improvement, mastery, and social contribution, while Western children emphasize smartness and play. By age 8, these patterns are deeply set. A child who enters international school at 8 does not arrive as a blank slate—they arrive with deeply embedded virtue-orientation beliefs that will not dissolve on exposure to Western methods.",
          "Li asks a question with no comfortable answer: ''To what extent should educators attempt to reform Asian students into talkers; or similarly, to what extent should Asian educators make Western children quiet learners?'' There is no right answer. But teachers should know the question exists, because it shapes everything about how a Chinese student experiences an international classroom."
        ]
      },
      {
        "heading": "What Code-Switching Looks Like",
        "items": [
          "Bob, in Ran''s study, became ''naughty'' during his cultural transition—not horrendously, but unfocused and resistant. His father was called into school. The behavior was cultural disorientation, not defiance. Bob had been encouraged to write in Chinese but the teacher wanted it in English. He stood up to answer questions (normal in China) and was embarrassed when classmates stayed seated. These small friction points accumulated.",
          "Despite years in British schools, Chinese parents in Ran''s study maintained Chinese learning beliefs and practices at home. The home culture does not dilute—it runs parallel to the school culture. Children learn to present differently in each context: engaged questioner at school, diligent memorizer at home.",
          "A child who seems fully adapted may be managing significant cognitive load. They may participate verbally in class because they have learned it is expected, while privately believing that real learning happens through silent effort. They may accept teacher praise at school while knowing their parents will focus on what went wrong.",
          "Do not assume adaptation means reconciliation. Ask students what they think learning means. Ask how they study at home. Listen for the dual tracks. A student who says ''I study by reading the textbook three times, then doing practice problems'' is showing you their virtue-orientation method—even if they also raise their hand in class."
        ]
      },
      {
        "heading": "Supporting the Whole Student",
        "items": [
          "Acknowledge the tension explicitly with older students: ''I know our classroom looks different from what you might be used to. Both approaches have real strengths. You do not have to choose one.'' Giving permission to hold both models reduces the hidden pressure to perform one identity.",
          "Talk to parents about the dual system. Most Chinese parents in international schools know the tension exists—they chose it deliberately. What they want is reassurance that the school respects their values while offering something different. ''We build on the discipline and focus your child brings from home'' is a bridge sentence.",
          "Watch for signs of exhaustion that are not academic: a child who is quiet at school AND at home may be depleted from constant code-switching. A child whose parents report excellent behavior at home but who acts out at school may be releasing the pressure of a system they cannot fully inhabit."
        ]
      }
    ],
    "citations": [
      {"author": "Li, J.", "year": 2005, "title": "Mind or Virtue: Western and Chinese Beliefs About Learning", "journal": "Current Directions in Psychological Science", "doi": "10.1111/j.0963-7214.2005.00342.x"},
      {"author": "Li, J. & Wang, Q.", "year": 2004, "title": "Perceptions of Achievement and Achieving Peers in U.S. and Chinese Kindergartners", "journal": "Social Development"},
      {"author": "Ran, A.", "year": 2001, "title": "Travelling on Parallel Tracks: Chinese Parents and English Teachers", "journal": "Educational Research", "doi": "10.1080/00131880110081062"}
    ]
  }'::jsonb
WHERE module_id = 'china-001' AND dimension_number = 6;


-- ══════════════════════════════════════════════════════════════════════════════
-- NEW SCENARIOS — 4 additional scenarios from Ran (2001) case studies
-- ══════════════════════════════════════════════════════════════════════════════

-- Scenario: The parent who brings a textbook
INSERT INTO public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, source_type, dimension_tags, status)
VALUES (
  'china-001',
  'The parent who brings a textbook to the meeting',
  'Mrs Lu arrives at the parent-teacher meeting with a stack of maths textbooks she bought from a bookshop. She asks you which chapters you are covering this term and whether you can send home a list of exercises her daughter should complete each week. She also mentions she has been giving extra Chinese homework and handwriting practice at home.',
  'The parent is a pushy tiger-mom who is putting excessive academic pressure on her child and trying to micromanage your curriculum. She does not trust your teaching methods and wants to impose a Chinese-style drill approach.',
  'Mrs Lu cannot help her daughter because she does not know what is being taught or how. In China, parents follow along with standard textbooks and check their children''s work each night. Without a textbook to reference, she feels locked out of her child''s education. The extra homework is not pressure—it is the only way she knows how to show care and involvement. She is asking you to let her in.',
  '["Acknowledge her effort: ''Thank you for being so involved. That matters enormously.''", "Provide a specific, simplified overview of what you are covering each week—even a one-page summary helps.", "Offer targeted practice: ''This week, these five problems will reinforce what we did in class. Here is where she tends to get stuck.''", "Frame her home practice as complementary: ''The Chinese writing and handwriting practice you do at home builds discipline that helps in every subject here.''"]'::jsonb,
  'academic',
  '{2, 5}'::integer[],
  'live'
);

-- Scenario: The investigative maths frustration
INSERT INTO public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, source_type, dimension_tags, status)
VALUES (
  'china-001',
  'The investigative maths frustration',
  'You set an open-ended maths investigation: students must find patterns in number sequences and explain their reasoning. Yang, your Chinese student, follows your instructions precisely and works harder than anyone. But when you ask her to share her ''initial thinking,'' she says ''I have not got the answer yet.'' She seems anxious, redrafts every sentence, and will not submit work until it is perfect. Her father later asks you for extra exercises to do at home.',
  'Yang is a perfectionist who cannot handle ambiguity. She needs to loosen up, take risks, and accept that ''messy thinking'' is part of learning. Her father is reinforcing rigid thinking by drilling at home.',
  'Yang is following the Chinese learning sequence: memorize, understand, apply, then question. You are asking her to jump to step four (share reasoning, explore) before she has completed steps one and two (secure the knowledge, understand it deeply). Her perfectionism is not anxiety—it is the virtue of diligence. Her father''s request for exercises is rational: in his frame, structured practice is how you build toward open-ended thinking, not a substitute for it.',
  '["Start investigations with a structured warm-up that lets students secure foundational facts first, then open up the inquiry.", "Reframe ''initial thinking'' as ''what you notice so far''—lower the commitment threshold so students can share observations without claiming conclusions.", "Provide Yang with a worked example of what an investigation looks like completed, so she can see the destination before navigating the journey.", "Give her father the structured exercises he wants AND explain: ''These build the foundation. The investigation in class builds on top of it. Both matter.''"]'::jsonb,
  'academic',
  '{1, 4}'::integer[],
  'live'
);

-- Scenario: The naughty bilingual kid
INSERT INTO public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, source_type, dimension_tags, status)
VALUES (
  'china-001',
  'The bilingual student who acts out',
  'Bob arrived from China a year ago. He is bright—his maths is ''way ahead'' of British peers in mechanical arithmetic. But he has become disruptive: off-task, occasionally defiant, described as ''naughty—not horrendously naughty, but not on task.'' His father was called in. Bob had also been encouraged to write in Chinese for some assignments, but you asked for it in English, and nothing was submitted. Bob stands up every time he wants to speak.',
  'Bob has a behavior problem. He is not adjusting well, possibly needs additional support or a behavior plan. His standing up to speak is odd. The Chinese writing issue is a misunderstanding about homework expectations.',
  'Bob is navigating two complete cultural systems simultaneously and no one has made either set of expectations explicit. Standing up to speak is normal classroom behavior in China—he was embarrassed when he realized British students stay seated. The ''naughtiness'' is frustration from cultural disorientation, not defiance. He was told to write in Chinese to maintain his first language, but did not understand the teacher also expected an English version. Each small miscommunication compounds.',
  '["Make classroom conventions explicit: ''In our class, we stay seated to answer. I know it is different from what you are used to—both ways are fine, we just do it this way here.''", "Clarify assignment expectations in writing, especially for bilingual students: ''Write your first draft in whichever language helps you think. Then we will work on the English version together.''", "Reframe the behavior narrative: before escalating to a behavior plan, ask ''what changed recently?'' Cultural adjustment stress peaks at 6-12 months, not on arrival.", "Meet with the father to align: he may not know about classroom friction. Chinese parents are often deeply cooperative once they understand the specific expectations."]'::jsonb,
  'academic',
  '{4, 6}'::integer[],
  'live'
);

-- Scenario: The standing-up-to-answer embarrassment
INSERT INTO public.pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, source_type, dimension_tags, status)
VALUES (
  'china-001',
  'The classroom convention clash',
  'You notice that your Chinese student stands up every time you call on them, even though all other students remain seated. Other students giggle. The student looks confused and embarrassed. In the same week, you ask the class to debate a topic, and your Chinese students sit silently while Western students dominate the discussion. When you call on a Chinese student directly, she says quietly: ''I am still thinking.''',
  'The standing student does not know basic classroom etiquette. The silent students are disengaged or lack confidence. They need encouragement to ''find their voice'' and participate more actively.',
  'Standing to address the teacher is a sign of respect in Chinese classrooms—the student is showing deference, not ignorance. The silent students are not disengaged; they are following the Chinese learning norm where you speak only when you are certain and can back your claim. Saying ''I am still thinking'' is an honest and culturally appropriate response. In the Confucian tradition, speaking is an act of commitment—premature speech is considered reckless, not brave.',
  '["Quietly explain classroom conventions one-on-one, not publicly: ''Here, students usually stay seated. It is just a different custom—you were being very respectful.''", "For discussions, build in structured ''think time'' before any speaking. Give 2 minutes of silent writing first, then invite sharing. This respects the memorize-understand-then-speak sequence.", "Offer multiple participation modes: written responses, pair discussions before whole-class sharing, or digital polls. Not all learning needs to be verbal.", "Never frame silence as a problem to fix. Frame it as a different mode of engagement: ''Some students process by talking, others by thinking quietly first. Both are valuable in this classroom.''"]'::jsonb,
  'academic',
  '{1, 4}'::integer[],
  'live'
);


-- ══════════════════════════════════════════════════════════════════════════════
-- Verify after running:
--   SELECT dimension_number, title, research_status,
--          length(content::text) as content_chars,
--          jsonb_array_length(content->'sections') as sections,
--          jsonb_array_length(content->'citations') as citations
--   FROM pd_dimensions
--   WHERE module_id = 'china-001'
--   ORDER BY dimension_number;
--
--   SELECT count(*) FROM pd_scenarios WHERE module_id = 'china-001';
--   -- Expected: 9 (5 original + 4 new)
-- ══════════════════════════════════════════════════════════════════════════════
-- Cultural vocabulary module feedback
-- Collects teacher responses after completing a cultural vocab activity.
-- Used to identify inaccuracies, gaps, and what landed well.

CREATE TABLE IF NOT EXISTS pd_cultural_feedback (
  id               UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  activity_id      TEXT        NOT NULL,   -- e.g. 'ksa-cultural-001'
  module_id        TEXT        NOT NULL,   -- e.g. 'ksa-001'
  country          TEXT        NOT NULL,   -- e.g. 'Kingdom of Saudi Arabia'
  context_selected TEXT,                  -- e.g. 'middle-east' (from user selector)
  rating           INTEGER     CHECK (rating BETWEEN 1 AND 5),
  inaccuracies     TEXT,                  -- "Did anything feel inaccurate or off?"
  what_was_missing TEXT,                  -- "What did we miss?"
  most_useful      TEXT,                  -- "What was most useful or surprising?"
  submitted_at     TIMESTAMPTZ DEFAULT NOW()
);

-- Allow anyone to insert feedback (no auth required for pilot)
ALTER TABLE pd_cultural_feedback ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anyone can submit feedback"
  ON pd_cultural_feedback
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Mark only: no public read
CREATE POLICY "no public read"
  ON pd_cultural_feedback
  FOR SELECT
  TO anon
  USING (false);
-- Seed China Simulation 4: "The Public WeChat Question"
-- Source: CHINA_SIM3_THE_PUBLIC_WECHAT_QUESTION.md
-- Dimensions: D2 (Parent-Teacher Communication), D3 (Visible Rigor and Academic Trust), D5 (Public Accountability Through Parent Networks)
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
  'a1b2c3d4-0001-0004-0001-000000000001',
  'china-001',
  'The Public WeChat Question',
  'A parent posts a homework comparison in the class WeChat group at 7pm. What looks like a simple question is actually a public trust test.',
  'It is October at Riverstone International School in Shanghai. Your class has just finished a literacy week focused on reading response journals and discussion-based homework. This term, your grade level agreed to keep homework purposeful and limited: one reading response, one short math practice task, and one optional extension across the week.',
  '[
    {
      "name": "You",
      "role": "Year 4 homeroom teacher",
      "description": "You are in your third year at this school. You trained in the UK, US, or Australia. You believe in purposeful homework, conceptual understanding, and keeping parent communication calm and clear. You care about trust, but you are still learning how quickly ordinary questions can become public signals in a Chinese parent group."
    },
    {
      "name": "Mrs. Chen",
      "role": "Mother of Junhao",
      "description": "Mrs. Chen works in finance and is active in the parent WeChat group. She is efficient, articulate, and highly attentive to signs of rigor. She does not see herself as confrontational. She sees herself as making sure the class stays academically serious."
    },
    {
      "name": "Junhao",
      "role": "Student, Year 4, age 9",
      "description": "Junhao is diligent, warm with classmates, and attentive to adult expectations. He does well academically and is especially sensitive to whether home and school seem aligned."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "7:12 p.m. The Year 4 parent WeChat group has 26 members. Several recent class photos sit above an unread message bubble.",
        "It is October at Riverstone International School in Shanghai. Your class has just finished a literacy week focused on reading response journals and discussion-based homework. This term, your grade level agreed to keep homework purposeful and limited: one reading response, one short math practice task, and one optional extension across the week.",
        "You know some families appreciate this. Others are less sure.",
        "At 7:12 p.m., Mrs. Chen posts in the class WeChat group: ''Hello Teacher. Thank you for your hard work. I have one question. My friend''s child in another Year 4 class has daily spelling dictation and more math sheets. Our class homework seems lighter. Can you clarify whether the expectations are the same? Some parents are worried the children may not be getting enough practice.''",
        "Within minutes, three parents react with thumbs-up emojis. One writes, ''Yes, I was also wondering.'' Another adds, ''My son finished tonight''s homework in 12 minutes.''",
        "No one is rude. But the question is now public, visible, and hanging in the group.",
        "Your school does not forbid WeChat communication, but leadership has repeatedly reminded teachers not to let parent groups become ranking forums or parallel accountability systems.",
        "You can already feel the tension in the message. Mrs. Chen is not only asking about homework. She is asking whether your class is academically serious enough."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "The Group Message",
      "prompt": "How do you respond to Mrs. Chen''s public WeChat question?",
      "choices": [
        {
          "id": "1a",
          "label": "Answer publicly and firmly",
          "text": "Thank you for the question, Mrs. Chen. Every class is different, and I design homework intentionally based on our students'' needs. More worksheets do not always mean more learning. Please trust that the class is being challenged appropriately.",
          "next": "consequence_1a"
        },
        {
          "id": "1b",
          "label": "Move it private immediately",
          "text": "Thanks, Mrs. Chen. I''ll message you directly.",
          "next": "consequence_1b"
        },
        {
          "id": "1c",
          "label": "Acknowledge publicly, answer structurally",
          "text": "Thank you for raising this, Mrs. Chen. I know homework load is something families watch closely. Our class uses shorter homework by design, but the rigor comes through reading response quality, in-class writing, and weekly retrieval checks. I''ll send a short overview tomorrow so all families can see how homework fits into our broader learning plan.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Answered Publicly and Firmly",
      "content": [
        "The group goes quiet.",
        "No one argues. No one thanks you either.",
        "The next morning, two parents message you privately asking what you meant by ''appropriately challenged.'' One asks whether there are hidden assessments they are not seeing. Another says, ''We understand your philosophy, but parents still need some way to know the standard is high.''",
        "Mrs. Chen says nothing more in the group. But that silence does not feel like resolution. It feels like withdrawal.",
        "At pick-up, Junhao''s grandmother mentions casually, ''At home they are now giving him some extra dictation, just in case.''",
        "You defended your professionalism, but the public reassurance did not actually satisfy the need beneath the question. Families wanted legible proof. You offered authority."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Moved It Private",
      "content": [
        "Mrs. Chen replies in the group with a polite ''Thank you, Teacher.''",
        "Then the side-messaging begins.",
        "Three parents contact you privately within the hour asking versions of the same question. One says, ''We saw the message and were also curious.'' Another says, ''If there is a class difference, we just want to understand.''",
        "Because the issue was never addressed in the public space where it appeared, the uncertainty multiplies rather than shrinks.",
        "When you message Mrs. Chen privately, she is polite but specific: ''Thank you. I did not mean criticism. But if several parents are concerned, it may help if the class can see the expectation clearly.''",
        "You avoided a public confrontation, but you also left the public uncertainty untouched."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Acknowledged Publicly, Answered Structurally",
      "content": [
        "The tone in the group shifts almost immediately.",
        "One parent replies, ''Thank you, that would be helpful.'' Another says, ''Yes, understanding the weekly plan would reduce confusion.''",
        "The next day, you post a simple homework overview: weekly reading response expectations, spelling retrieval in class on Fridays, math fluency checks, and where deeper rigor sits in the curriculum beyond raw worksheet volume.",
        "Mrs. Chen responds with a thumbs-up and a short note: ''This explanation is clear. Thank you.''",
        "The concern has not disappeared completely. But it has moved from comparison to interpretation. Instead of debating whether your class is soft, parents are now talking about how rigor is being shown."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Chen''s View",
      "content": [
        "Mrs. Chen did not ask the question in the group because she wanted to embarrass you.",
        "She asked it there because WeChat has become a practical accountability channel. In her experience, if a concern is only raised privately, other parents remain uncertain, rumors spread, and each family ends up solving the same problem alone.",
        "She is also operating in a context where homework volume is often used as a visible trust signal. If one class appears lighter than another, that difference does not read as neutral. It raises a question: is the class being challenged enough?",
        "From her perspective, the group question is not automatically disrespectful. It is efficient. It turns a private doubt into a shared clarification.",
        "Research note: Guo, Wu, and Liu (2019) describe contemporary Chinese parent-teacher relationships as more negotiated and interactive than older authority models suggest. Digital platforms like WeChat make parental concerns faster, more collective, and more public. What a teacher may hear as pressure can feel, to parents, like responsible monitoring in a competitive educational environment."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What did you assume the public WeChat question meant?",
      "options": [
        "A challenge to my authority",
        "A request for visible academic proof",
        "An attempt to speak for several parents at once",
        "A communication style mismatch more than a personal attack"
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "The Follow-Up",
      "prompt": "Mrs. Chen messages you privately the next afternoon. ''Thank you for replying yesterday. I appreciate the overview. I am still trying to understand how I should evaluate Junhao''s progress at home. If homework is short and there is no class rank, how can parents know whether children are really on track? We do not want to wait until problems are serious.'' How do you reply?",
      "choices": [
        {
          "id": "2a",
          "label": "Defend your homework philosophy",
          "text": "I understand the concern. At our school, we avoid overloading students with homework because we value balanced, high-quality learning. Trust that if Junhao were off track, I would let you know.",
          "next": "consequence_2a"
        },
        {
          "id": "2b",
          "label": "Offer private reassurance only",
          "text": "Junhao is doing well. He participates thoughtfully, reads carefully, and his recent work has been strong. I would not worry.",
          "next": "consequence_2b"
        },
        {
          "id": "2c",
          "label": "Make rigor more legible for all families",
          "text": "That is a fair question. Rather than increasing homework volume, I think the better solution is clearer evidence. I can start sending a short weekly note showing what we checked for in reading, math, and writing so families can see how progress is being monitored without turning everything into extra worksheets.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Defended Philosophy",
      "content": [
        "Mrs. Chen thanks you. Then she adds: ''I understand. Parents just need some concrete way to follow.''",
        "The exchange remains courteous, but you can feel the mismatch.",
        "In the following weeks, Mrs. Chen stops asking about classroom learning directly. Instead, Junhao begins bringing extra practice books home and mentioning that his mother wants him to ''stay sharp.'' Another parent asks if you recommend outside dictation apps. A third asks whether the class should be doing more at home ''to be safe.''",
        "You have not lost the relationship. But you have lost interpretive ground. Parents are now building their own parallel reassurance systems outside school."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Offered Private Reassurance Only",
      "content": [
        "Mrs. Chen seems relieved at first. ''Thank you, Teacher. That is good to hear.''",
        "But the next week, another parent asks in the group whether Year 4 will have any end-of-unit benchmark before the next break. Soon after, a father asks privately whether your class uses the same spelling standards as the others.",
        "You realize the underlying issue was never just Junhao. It was the class''s legibility as an academic environment. By answering only at the individual level, you calmed one parent briefly but left the shared uncertainty intact.",
        "You are now repeating the same reassurance one family at a time."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Made Rigor More Legible",
      "content": [
        "You begin sending a concise Friday post: what students practiced, what you checked in class, one sample of what strong work looked like, and one sentence on what parents might listen for at home.",
        "The posts are short, but they change the temperature.",
        "Parents start responding less with ''Should we add more?'' and more with ''Thank you, now I understand what to look for.'' Mrs. Chen remains active, but her questions become narrower and more constructive.",
        "You have not made everyone agree with your philosophy. You have made it easier for them to see the academic structure inside it."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Junhao''s View",
      "content": [
        "Junhao is paying close attention to whether home and school sound like the same story.",
        "When his mother asks public questions about homework, he notices. When you respond with warmth and clarity, he feels that school is understandable. When adults speak past one another, he feels the gap even if no one mentions him directly.",
        "At home, ''serious school'' often looks like visible practice: dictation, math sheets, things you can point to on a table. At school, you ask him to think, discuss, revise, and read deeply. He can do both, but he does not automatically know how they fit together.",
        "If the adults around him treat those two worlds as if they are competing, Junhao may start to think one of them must be the real school and the other is just extra.",
        "Research note: Public communication about standards affects children too. In a system where parents are watching carefully for trust signals, students can start to absorb the same hierarchy of visible over invisible rigor unless teachers make the deeper logic of learning legible."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the parent really asking for in the follow-up message?",
      "options": [
        "More homework",
        "A clearer way to monitor progress",
        "Proof that this class is not less rigorous than others",
        "A translation of school philosophy into something families can use"
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "The Comparison Moment",
      "prompt": "Two weeks later, a grade coordinator mentions that several Year 4 parents have been comparing homework practices across classes. That evening, Mrs. Chen messages: ''Thank you for the weekly notes. They help. Some parents still feel the other class has stronger visible practice. Could you perhaps add one weekly dictation or one more math review page so there is less difference? I think this would reassure families.'' How do you respond?",
      "choices": [
        {
          "id": "3a",
          "label": "Reject the comparison",
          "text": "I understand the concern, but I do not think it is helpful for parents to compare classes this way. My responsibility is to teach the students in front of me, not to match another teacher''s homework style.",
          "next": "consequence_3a"
        },
        {
          "id": "3b",
          "label": "Accommodate the pressure",
          "text": "I can add a weekly dictation check and one extra review page so families feel the practice is more concrete.",
          "next": "consequence_3b"
        },
        {
          "id": "3c",
          "label": "Reframe around shared standards",
          "text": "I appreciate the honesty. I do not want to add work simply so it looks heavier, but I do think the year group should make standards more visible. Let me speak with the team about sharing common outcomes and common checks so families can see alignment without every class having to look identical.",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Rejected the Comparison",
      "content": [
        "Mrs. Chen replies politely, but the note is cool: ''Understood. Thank you for explaining.''",
        "The comparison does not stop. It simply moves further away from you.",
        "At the next coffee morning, another parent mentions that ''some Year 4 families are doing extra work at home because they are not fully confident in the homework expectations.'' Nothing is openly hostile, but you can feel that your class has become a point of informal comparison.",
        "You protected your autonomy. You did not rebuild trust."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Accommodated the Pressure",
      "content": [
        "The extra dictation and review sheet calm things quickly.",
        "Parents thank you. Mrs. Chen posts, ''This is helpful.'' The messages quiet down.",
        "But inside the classroom, you feel the shift. Homework gets longer. A few students now rush the reading response to finish the new review sheet. You have not just adjusted communication. You have altered the shape of the learning week.",
        "And because the change came through parent pressure, you also know it can happen again.",
        "The relationship is smoother. The precedent is stronger too."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Reframed Around Shared Standards",
      "content": [
        "You speak with the grade-level team and leadership. Within a week, Year 4 begins sending a common fortnightly standards snapshot: shared learning outcomes, examples of how each class checks them, and where approaches may differ without reducing expectations.",
        "The result is not perfect harmony, but the comparison becomes more manageable. Parents still notice differences, yet those differences are now framed inside a common standard rather than as evidence that one teacher is softer than another.",
        "Mrs. Chen responds: ''This helps. Parents mainly want to see that the classes are equally serious even if the style is different.''",
        "The issue has become institutional instead of personal."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Mrs. Chen Revisited",
      "content": [
        "Mrs. Chen''s core concern was never really about one extra worksheet.",
        "It was about trust in a fee-paying, choice-based educational environment where parents watch for signals all the time. If one class appears lighter, families do not experience that as a neutral stylistic variation. They wonder whether their child is receiving the same academic seriousness as everyone else.",
        "In that environment, parent networks do not just spread anxiety. They also create collective interpretations. Once a few parents begin asking the same question, the question gains weight.",
        "Research note: The challenge is not to eliminate parental comparison. The challenge is to keep comparison from becoming the only way families can read rigor. In contemporary urban Chinese schooling, especially in high-pressure and choice-based contexts, teachers often need to make standards publicly legible before they can expect families to stop using volume and comparison as proxies."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the deepest issue in the final dilemma?",
      "options": [
        "Parents were trying to control the classroom",
        "Families needed visible signals that standards were shared across classes",
        "The school had not made rigor legible enough at the year-group level",
        "A public communication problem was being mistaken for an individual parent problem"
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "content": [
        "This simulation explored three recurring tensions in contemporary parent-teacher relationships in urban China.",
        "Parent-Teacher Communication (D2): In digitally connected school communities, parent questions do not always arrive in private, one-to-one forms. Platforms like WeChat change the social meaning of communication. A public question may be less about disrespect than about collective clarification, visible accountability, and making sure everyone hears the same answer.",
        "Visible Rigor and Academic Trust (D3): Homework volume, dictation, and repeatable practice often function as legible trust signals. When a teacher uses lighter but more purposeful homework, families may not read that as sophistication automatically. They may read it as a possible reduction in seriousness unless the structure of rigor is made explicit.",
        "Public Accountability Through Parent Networks (D5): In a choice-based, middle-class educational environment, parents often compare classes, ask questions publicly, and triangulate through one another. That does not necessarily mean they reject the teacher''s expertise. It often means they are using the tools available to them to reduce uncertainty about quality and fairness.",
        "Research: Guo, Y., Wu, X., and Liu, X. (2019). Challenges and Opportunities in Parent-Teacher Relationships in Contemporary China. DOI: 10.5206/cie-eci.v47i2.9331"
      ],
      "researchCitations": [
        {
          "author": "Guo, Wu, and Liu",
          "year": "2019",
          "title": "Challenges and Opportunities in Parent-Teacher Relationships in Contemporary China",
          "doi": "10.5206/cie-eci.v47i2.9331"
        }
      ],
      "closingPrompt": "If you could go back to the original WeChat message, how would you answer in a way that protects your professionalism, reduces group uncertainty, and makes rigor visible without turning the class into a comparison contest?"
    }
  }',
  ARRAY[2,3,5],
  20,
  4,
  'live'
);
-- Seed India Simulation 2: "The PTM Follow-Up"
-- Source: INDIA_SIM2_THE_PTM_FOLLOW_UP.md
-- Dimensions: D2 (Parent-Teacher Follow-Through), D4 (Relational Trust and School Responsiveness), D5 (Escalation, Specificity, and System Efficacy)
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
  'a1b2c3d4-0004-0002-0001-000000000001',
  'india-001',
  'The PTM Follow-Up',
  'A parent raises a concern at a PTM about group work dynamics. Two weeks later, he emails to ask what happened. Your response will determine whether the meeting meant anything.',
  'It is July at Greenwood Academy in Pune. Midterm PTMs are underway. You are moving quickly from one family to the next, trying to be present without running too late. Aarav''s father, Mr. Sharma, sits down with a notebook in his hand.',
  '[
    {
      "name": "You",
      "role": "Year 5 class teacher at Greenwood Academy, Pune",
      "description": "You trained in the UK, US, or Australia. You care deeply about student belonging and good communication with families. You are warm in meetings, but your workload is heavy and your follow-through can become more general than specific when several issues are moving at once."
    },
    {
      "name": "Mr. Sharma",
      "role": "Father of Aarav",
      "description": "Mr. Sharma works in operations for a manufacturing company and takes PTMs seriously. He is courteous, practical, and not especially argumentative. He expects that if a concern is discussed in a meeting, the school will either act on it or explain clearly what happens next."
    },
    {
      "name": "Aarav",
      "role": "Student, Year 5, age 10",
      "description": "Aarav is thoughtful, slightly reserved in large groups, and academically capable. He likes school but does not always insert himself socially. When group work turns messy, he often lets louder children decide roles."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "Parent-Teacher Meeting Day. A plastic chair, a paper sign-in sheet, half-finished tea, and six more families still waiting.",
        "It is July at Greenwood Academy in Pune. Midterm PTMs are underway. You are moving quickly from one family to the next, trying to be present without running too late.",
        "Aarav''s father, Mr. Sharma, sits down with a notebook in his hand.",
        "''Aarav is doing well academically,'' he says, ''but he has mentioned something a few times. In group work, the same louder children keep deciding roles, and he gets pushed to smaller tasks. He says this happened again during the science chart activity. I do not want to overreact, but I also do not want this to become a pattern.''",
        "You know the class dynamic he means. Nothing looks like outright bullying. But there are definitely students who dominate shared tasks unless guided carefully.",
        "You have eight minutes left in the slot, one child waiting outside to show a portfolio, and three parents already glancing at the clock."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "The PTM Response",
      "prompt": "How do you respond in the meeting?",
      "choices": [
        {
          "id": "1a",
          "label": "Offer warm reassurance only",
          "text": "Thank you for telling me, Mr. Sharma. I am glad you raised it. Aarav is such a lovely child, and I will definitely keep an eye on it.",
          "next": "consequence_1a"
        },
        {
          "id": "1b",
          "label": "Promise quick action",
          "text": "Thank you. I will speak to the group tomorrow and make sure Aarav gets more equitable roles right away.",
          "next": "consequence_1b"
        },
        {
          "id": "1c",
          "label": "Name a specific follow-through plan",
          "text": "Thank you for raising it. I have noticed that some students dominate group roles unless I structure them. Over the next two weeks, I will observe Aarav during collaborative tasks, rotate roles more explicitly, and check back with you by next Friday about what I am seeing.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Warm Reassurance Only",
      "content": [
        "Mr. Sharma nods politely. ''Thank you, Teacher.''",
        "The PTM ends smoothly.",
        "But the next two weeks are crowded. A reading assessment cycle begins, one student is absent for a family wedding, and you do not specifically revisit Aarav''s group experiences. You assume that because you are now more aware, you are effectively monitoring the issue.",
        "Then an email arrives: ''At the PTM we discussed Aarav''s difficulty getting meaningful roles in group work. I asked him this week, and he says it is still happening. Could you let me know what has been done since the meeting?''",
        "You realize that from his side, the meeting produced sympathy but not evidence."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Promised Quick Action",
      "content": [
        "The next day, you speak to the class in general terms about sharing responsibility in groups.",
        "It feels like you have done something. But in practice, the reminder is broad, and the next science activity still falls into familiar patterns. Aarav ends up lettering the title while two stronger personalities drive the task.",
        "Mr. Sharma writes again: ''Thank you for taking it up. Aarav says there was still no real change in his role this week. Could you explain what steps are being taken?''",
        "Your promise created a higher bar than your classroom follow-through actually met."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Named a Specific Follow-Through Plan",
      "content": [
        "You set a note in your planner. During the next two collaborative tasks, you deliberately watch Aarav''s groups, assign rotating roles, and record who leads, who writes, and who presents.",
        "At the end of the week, you message Mr. Sharma: ''I observed Aarav in two tasks. He contributes ideas but yields quickly when peers move faster. I have started rotating roles more explicitly and will keep doing so. Next step: I want to support him in claiming the recorder or presenter role at least once next week.''",
        "Mr. Sharma replies, ''Thank you. This is very helpful.''",
        "The problem is not solved yet. But the parent can now see that the meeting produced movement, not just empathy."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mr. Sharma''s View",
      "content": [
        "Mr. Sharma did not come to the PTM because he wanted a long emotional conversation.",
        "He came because the meeting is supposed to matter.",
        "From his perspective, parent-teacher engagement is not successful when the teacher sounds kind. It is successful when the concern enters the school''s working memory. If a teacher listens warmly but the problem returns unchanged, the parent may feel not only disappointed but dismissed, even if no one intended that.",
        "Research note: In Indian PTM contexts, parents often judge the meeting by whether it produces visible responsiveness. The frustration is not always with disagreement itself. It is with the feeling that the system absorbed the concern politely and then carried on as before. (Munthe and Westergård, 2023)"
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the biggest risk in your first response?",
      "options": [
        "Sounding uncaring",
        "Promising more than you could track",
        "Treating empathy as if it were evidence of action",
        "Underestimating how concretely the parent would interpret your response"
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "The Parent Email",
      "prompt": "Mr. Sharma''s follow-up email is direct but respectful: ''At the PTM we discussed Aarav''s difficulty in getting proper roles in group work. I checked with him this week, and he feels the pattern is continuing. I wanted to understand what has been observed and what the school is doing next.'' You feel a flash of defensiveness. You are doing your best. But you also know the email is fair. How do you reply?",
      "choices": [
        {
          "id": "2a",
          "label": "Be defensive",
          "text": "Group work is complex, and these situations are not always as clear as children describe them. Aarav is doing well overall, and I think it would be best not to magnify a small issue.",
          "next": "consequence_2a"
        },
        {
          "id": "2b",
          "label": "Explain generally",
          "text": "Thank you for following up. I have been mindful of the issue and am continuing to observe classroom interactions. We are always working on collaboration as a class, and I will keep encouraging fair participation.",
          "next": "consequence_2b"
        },
        {
          "id": "2c",
          "label": "Account concretely for what happened",
          "text": "Thank you for following up. You are right to ask. Since the PTM, I gave a general reminder about shared roles, but I did not yet create a strong enough structure to change the pattern consistently. I have now planned three specific next steps: rotating roles, observing Aarav''s next two group tasks directly, and checking back with you on Friday with what I saw.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Defensive Response",
      "content": [
        "Mr. Sharma''s next reply is still polite, but firmer: ''I understand group work is complex. My concern is not that the issue is huge, but that it may become a pattern if not addressed. I was hoping for a clearer response.''",
        "The problem is now larger than it was at the PTM. It is no longer only about Aarav''s group role. It is about whether the school takes parent concerns seriously once the polite meeting is over.",
        "You protected yourself in the moment. You weakened the relationship."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "General Explanation",
      "content": [
        "Mr. Sharma thanks you for the message. Then nothing changes.",
        "A week later, he writes again, now cc''ing the grade coordinator: ''I appreciate the reply. I am still not clear on what has been specifically observed or changed. I would be grateful for a more concrete update.''",
        "Your answer was calm, professional, and almost useless from the parent''s point of view. It described attention, not action."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Concrete Account",
      "content": [
        "Mr. Sharma responds: ''Thank you. I appreciate the clarity.''",
        "You follow through. In the next task, Aarav is assigned discussion leader. He hesitates, but with a bit of prompting, he does it. In the second task, he volunteers to present one section.",
        "When you update Mr. Sharma on Friday, you can describe what you saw rather than what you meant to do.",
        "The original issue is still real. But the parent now experiences the school as responsive rather than slippery."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Aarav''s View",
      "content": [
        "Aarav notices more than adults think.",
        "He knows his father raised the issue because his father asked him again after the PTM. He also knows whether anything actually changed. Children like Aarav can sense quickly whether school conversations stay in the adult layer or alter classroom reality.",
        "If the adults speak warmly but nothing changes, Aarav learns a quiet lesson: meetings are for talking, not for shifting the pattern. If he sees a real change, even a small one, he learns that speaking up through a parent can matter.",
        "Research note: Responsiveness is not only for parents. It shapes children''s sense of whether school structures are real and whether quieter students can count on adults to rebalance participation."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What made the strongest response in the second dilemma more effective?",
      "options": [
        "It sounded more apologetic",
        "It admitted the gap between intention and action",
        "It gave observable next steps and a timeline",
        "It treated the parent''s follow-up as legitimate rather than irritating"
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "The System Question",
      "prompt": "The grade coordinator asks if this situation points to a broader issue. She says, ''We are getting more parent follow-ups after PTMs this term. Not hostile ones, but specific ones. I think some families are leaving meetings unclear about what happens next.'' You now have a chance to recommend a change beyond Aarav''s case. What do you suggest?",
      "choices": [
        {
          "id": "3a",
          "label": "Treat this as an individual parent issue",
          "text": "Some parents simply expect too much immediate action. I do not think the school needs a new system because of a few persistent follow-up emails.",
          "next": "consequence_3a"
        },
        {
          "id": "3b",
          "label": "Overcorrect immediately",
          "text": "We should require teachers to send written action plans after every PTM, even for small concerns, so no parent can say the school did nothing.",
          "next": "consequence_3b"
        },
        {
          "id": "3c",
          "label": "Tighten the follow-up system thoughtfully",
          "text": "We do not need formal action plans for every conversation, but for concerns that involve recurring patterns, teachers should record one clear next step, one time frame, and one follow-up point. That would make PTMs feel more consequential without becoming bureaucratic.",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Treated as Individual Issue",
      "content": [
        "Nothing systemic changes.",
        "Some teachers keep doing excellent follow-through. Others keep offering warm but vague reassurance. The pattern continues unevenly across classes.",
        "Parents who are persistent get clarity eventually. Parents who are less confident may simply stop asking.",
        "The school avoids extra process. It also misses a chance to make responsiveness more equitable."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Overcorrected Immediately",
      "content": [
        "The new PTM paperwork is heavy. Teachers resent it. Many start filling it with generic language just to comply.",
        "Parents receive more documentation, but not always more meaning. Aarav''s case is now technically covered by a stronger system, yet the school as a whole becomes more performative than responsive.",
        "You solved the visibility problem by creating a bureaucracy problem."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Tightened the System Thoughtfully",
      "content": [
        "The grade coordinator adopts a simple shared practice for substantive concerns: note the issue, note one next step, note a time frame, note who closes the loop.",
        "It is small enough to use and concrete enough to matter.",
        "At the next PTM cycle, teachers begin sending shorter but clearer follow-up messages. Parents still ask questions, but fewer of them feel they must reopen the whole conversation just to know whether anything happened.",
        "You have turned one parent email into a healthier school habit."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Mr. Sharma Revisited",
      "content": [
        "Mr. Sharma''s persistence was not really about group work alone.",
        "It was about whether the PTM is a meaningful institutional space or a courtesy ritual. If the school listens, nods, and forgets, the meeting functions as performance. If the school listens, records, acts, and reports back, the meeting becomes part of the learning system.",
        "Research note: In many Indian school contexts, trust is built less through polished messaging than through visible follow-through. Parents do not always need perfect outcomes. They need to know the concern entered a real process."
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the central lesson of the final dilemma?",
      "options": [
        "Schools need fewer parent meetings",
        "Teachers should never promise too much",
        "Responsiveness needs light structure, not just goodwill",
        "The real issue was parent impatience"
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "content": [
        "This simulation explored three recurring tensions in parent-teacher engagement in Indian school settings.",
        "Parent-Teacher Follow-Through (D2): Families often judge a meeting not only by the teacher''s warmth, but by whether the concern produces visible action, observation, or closure afterward.",
        "Relational Trust and School Responsiveness (D4): Trust is not built only through kindness. It is built when the school''s response is legible, specific, and proportionate. Parents may tolerate disagreement more easily than vagueness.",
        "Escalation, Specificity, and System Efficacy (D5): When follow-through is weak, parents often re-ask, escalate, or widen the circle — not necessarily because they are adversarial, but because they are trying to confirm that the issue entered an actual school process. Light institutional structure can prevent small concerns from becoming credibility problems.",
        "Research: Munthe, E., and Westergård, E. (2023). Parents'', teachers'', and students'' roles in parent-teacher conferences: A systematic review and meta-synthesis. Teaching and Teacher Education, 136, 104355. DOI: 10.1016/j.tate.2023.104355"
      ],
      "researchCitations": [
        {
          "author": "Munthe and Westergård",
          "year": "2023",
          "title": "Parents'', teachers'', and students'' roles in parent-teacher conferences: A systematic review and meta-synthesis",
          "journal": "Teaching and Teacher Education",
          "doi": "10.1016/j.tate.2023.104355"
        }
      ],
      "closingPrompt": "If you could return to the original PTM, what would you say so that Mr. Sharma leaves feeling heard and you leave with a follow-through plan you can actually sustain?"
    }
  }',
  ARRAY[2,4,5],
  20,
  2,
  'live'
);
-- Seed Korea Simulation 2: "The Reform Petition"
-- Source: KOREA_SIM2_THE_REFORM_PETITION.md
-- Dimensions: D1 (Meritocracy and Legible Achievement), D2 (Parent Activism and School Communication), D4 (Reform, Fairness, and Competitive Signals)
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
  'c3d4e5f6-0003-0003-0003-000000000004',
  'korea-001',
  'The Reform Petition',
  'A parent network organises around a school reform that removes a test week. What looks like resistance to change is really a demand for legibility.',
  'It is April at Haneul Global School in Seoul. Leadership has announced a new initiative: next month, one traditional test week will be replaced by an interdisciplinary project week. Students will still produce assessed work, but instead of sitting three subject tests, they will build a collaborative inquiry project and present their findings.',
  '[
    {
      "name": "You",
      "role": "Middle school humanities teacher and grade-level advisor",
      "description": "You trained in the UK, US, or Australia. You believe good assessment should show growth, collaboration, and thinking, not only ranking. You are comfortable explaining pedagogy in theory, but less experienced at navigating organised parent pressure."
    },
    {
      "name": "Mrs. Kim",
      "role": "Mother of Seojun",
      "description": "Mrs. Kim is a former lawyer who now works part-time and spends significant time managing her son''s schooling. She is well connected, articulate, and respected among other parents. She does not see herself as oppositional. She sees herself as responsibly protecting clear academic pathways."
    },
    {
      "name": "Seojun",
      "role": "Student, middle school, age 13",
      "description": "Seojun is diligent, high-performing, and careful. He responds well to structure and benchmarks. He likes project work once he understands how it will count."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A grade-level planning slide titled Future Learning Week. The line that keeps coming up in meetings: ''Replace one test week with interdisciplinary evidence of learning.''",
        "It is April at Haneul Global School in Seoul. Leadership has announced that next month, one traditional test week will be replaced by an interdisciplinary project week. Students will still produce assessed work, but instead of sitting three subject tests, they will build a collaborative inquiry project and present their findings.",
        "Your leadership team believes this is more authentic and more future-facing. They keep using words like transfer, creativity, and real-world application.",
        "Some families are less convinced.",
        "Seojun is one of your strongest students. He does well on tests, prepares carefully, and likes to know exactly how performance will be evaluated. He is not rigid, but he is accustomed to clear academic signals.",
        "At 8:03 p.m., Mrs. Kim messages you privately: ''Teacher, I wanted to ask before tomorrow''s parent coffee morning. Some parents are worried that replacing test week with a project may reduce academic seriousness. We understand innovation, but children still need clear standards. A few of us have drafted a note asking the school to provide formal benchmarking alongside the project. I wanted to hear your view.''",
        "Attached is a polished statement signed by several parents. It is respectful, but unmistakably organised.",
        "You know this is bigger than one mother''s concern. A parent network is mobilising around the reform."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "The Private Message",
      "prompt": "How do you respond to Mrs. Kim''s first message?",
      "choices": [
        {
          "id": "1a",
          "label": "Defend the reform directly",
          "text": "I understand the concern, but the project week is academically rigorous. It is not replacing learning with something softer. We are assessing important skills that traditional tests do not always capture.",
          "next": "consequence_1a"
        },
        {
          "id": "1b",
          "label": "Distance yourself privately",
          "text": "I see why parents are asking questions. These decisions come from leadership rather than individual teachers, so I cannot really comment. I am sure the school will explain more soon.",
          "next": "consequence_1b"
        },
        {
          "id": "1c",
          "label": "Translate the reform into clear academic signals",
          "text": "It is a fair question. The project is not meant to remove standards, only to show them differently. If it helps, I can explain what evidence of learning, rubrics, and subject knowledge checks will still be part of the week so the change feels less vague.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Defended the Reform",
      "content": [
        "Mrs. Kim thanks you politely. But the next line changes the tone: ''I understand the philosophy. Parents are worried about accountability, not creativity.''",
        "You realise the issue is not whether the project has value. The issue is whether it preserves legible competitive signals.",
        "At the coffee morning, two parents ask whether project grades will appear on transcripts the same way test scores do. Another asks whether students who are strong in exams are being disadvantaged.",
        "You gave a principled defence. The parents are still asking for a scoreboard."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Distanced Yourself",
      "content": [
        "Mrs. Kim replies: ''Thank you. I thought it would be useful to hear from the teachers directly since you see the students'' needs most clearly.''",
        "The next day, the petition grows.",
        "Because teachers stayed neutral and leadership spoke in generalities, parents fill the interpretive vacuum themselves. Rumours spread that project week is being used because students are ''too stressed'' and that formal assessment may be reduced more broadly.",
        "You avoided being drawn in. But your silence helped make the reform feel even less anchored."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Translated the Reform",
      "content": [
        "You send Mrs. Kim a short, concrete explanation: content knowledge will still be assessed, students will receive subject-specific rubric scores, reflection and collaboration will add evidence not replace mastery, and departments will moderate work across classes.",
        "Mrs. Kim responds: ''This is helpful. I still think parents will want stronger benchmarking, but at least I can see the structure.''",
        "The petition does not disappear. But its emotional charge softens. The conversation begins moving from ''the school is removing rigour'' to ''the school needs to show rigour more clearly.''"
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Kim''s View",
      "content": [
        "Mrs. Kim is not automatically anti-reform.",
        "She is operating inside a system where parents have learned to watch closely for anything that affects legibility, fairness, and positioning. When a familiar academic signal disappears, it does not feel like a neutral pedagogical experiment. It feels like a possible loss of clarity in a highly competitive environment.",
        "From her perspective, organised parent action is not evidence of irrational anxiety. It is evidence of responsible vigilance. Good parents do not wait passively to see whether a reform harms their children. They intervene early, gather information, and use networks to influence outcomes.",
        "Research note: Jang (2024) shows that parental activism in South Korea is often driven by meritocratic logic and access to capital. Parents mobilise not only because they resist change, but because they believe responsible care requires active management of the educational environment when competitive signals become less clear."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What did you initially assume the parent message was about?",
      "options": [
        "Resistance to innovation",
        "A request for clearer academic legibility",
        "A parent network testing how much influence it has",
        "A fairness concern disguised as a pedagogy debate"
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "The Petition Spreads",
      "prompt": "Two days later, leadership asks you and the other advisors to attend an open parent session about Future Learning Week. Before the session, Mrs. Kim sends you the updated note — it now has twelve parent names on it. At the meeting, parents ask: How will students know where they stand? Will high-performing students lose an advantage? How can one project be as objective as multiple tests? You are not the principal. But you are the teacher in the room who actually knows the students. How do you handle the meeting?",
      "choices": [
        {
          "id": "2a",
          "label": "Treat the petition as inappropriate pressure",
          "text": "I want to say respectfully that educational decisions cannot be made through parent campaigns. The school must act in students'' best interests, not just in response to anxiety about competition.",
          "next": "consequence_2a"
        },
        {
          "id": "2b",
          "label": "Listen carefully, but stay mostly neutral",
          "text": "I can hear that families want clarity and fairness. I may not have all the policy answers, but I understand why these questions matter. I will make sure leadership hears the specific concerns being raised.",
          "next": "consequence_2b"
        },
        {
          "id": "2c",
          "label": "Create a public explanation channel",
          "text": "I think the strongest next step is to make the assessment architecture visible. Rather than debating whether projects are good or bad, let us show exactly what will be assessed, how moderation works, and what evidence students will receive so this does not feel like a leap of faith.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Treated It as Pressure",
      "content": [
        "The room quiets. Then a father says, ''Parents are not trying to run the school. We are trying to understand how standards are being protected.''",
        "Mrs. Kim remains calm, but the tone hardens.",
        "After the meeting, one parent emails leadership saying teachers seem dismissive of legitimate family concerns. Another writes that the school talks about partnership only when parents agree.",
        "You were not wrong that the petition was a form of pressure. But by naming only that, you made it harder for parents to hear anything else you said."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Listened, Stayed Neutral",
      "content": [
        "Parents appreciate your calm tone. No one leaves angry.",
        "But very little changes.",
        "Because no one translated the reform into concrete academic terms during the meeting, families continue interpreting it through comparison and suspicion. Some assume the school will later backtrack. Others begin arranging extra tutoring ''just in case.''",
        "You preserved the room. You did not reduce uncertainty."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Created a Public Explanation Channel",
      "content": [
        "Leadership agrees to your suggestion. Within 48 hours, the school shares a sample project rubric, subject-specific criteria, an explanation of moderation, examples of feedback students will receive, and a statement on how the project complements rather than abolishes formal assessment.",
        "Parents still debate the reform, but the debate changes shape. The loudest questions become operational rather than existential.",
        "Mrs. Kim says at the end of the session: ''I may still prefer stronger benchmarking, but this is the first time the reform feels educationally concrete.''"
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Seojun''s View",
      "content": [
        "Seojun has heard enough at home to know the adults are worried.",
        "He likes project work once he understands the criteria, but he trusts tests because they are legible. When parents say the project may not be fair, he starts to wonder whether he should trust the new format either.",
        "If the school explains the reform vaguely, Seojun hears this as a possible downgrade in seriousness. If the school explains it concretely, he can map the new task onto something familiar: effort, evidence, evaluation, outcome.",
        "Research note: Competitive systems do not only shape parents. They shape students'' sense of security too. Reform becomes easier to accept when children can still see how performance will be read and rewarded."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What did the parents need most in the meeting?",
      "options": [
        "To be told to trust the professionals",
        "To be heard without being indulged",
        "To see the reform translated into concrete evidence structures",
        "To know the school understood how high the stakes feel to them"
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "The Decision Point",
      "prompt": "A week later, leadership asks grade-level staff for feedback. The principal is considering three options: keep the project week exactly as planned, restore one common test inside the week, or keep the reform but provide stronger common evidence reporting afterward. Mrs. Kim sends one final message: ''Thank you for helping explain things. Parents still feel one formal benchmark would protect fairness. If the school wants innovation, perhaps it should add, not replace.'' You have influence, even if you do not have final authority. What do you advocate internally?",
      "choices": [
        {
          "id": "3a",
          "label": "Reject parent influence and keep the reform unchanged",
          "text": "If we adjust now, we teach parents that coordinated pressure can rewrite academic decisions. The school should keep the week unchanged.",
          "next": "consequence_3a"
        },
        {
          "id": "3b",
          "label": "Restore one benchmark quietly",
          "text": "Adding one common test would calm the parent body and preserve trust. It may not be ideal pedagogically, but it would give families a signal they recognise.",
          "next": "consequence_3b"
        },
        {
          "id": "3c",
          "label": "Keep the reform, add clearer common evidence",
          "text": "We should keep the project week, but publish stronger shared evidence afterward: common criteria, moderated samples, short subject comments, and explicit links between project performance and core knowledge. Parents are asking for fairness and legibility more than old formats themselves.",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Rejected Parent Influence",
      "content": [
        "Leadership keeps the reform unchanged.",
        "Pedagogically, the week goes well. Student work is strong. Some presentations are excellent.",
        "But the parent conversation remains tense. Several families leave the term feeling the school heard them but did not really understand why they were worried. Mrs. Kim becomes cooler in future interactions. Not hostile, just less trusting.",
        "The reform survived. The relationship cost was real."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Restored a Benchmark",
      "content": [
        "Leadership adds a short common test at the end of project week.",
        "Parents are relieved immediately. Mrs. Kim writes, ''This feels balanced.''",
        "The school also learns something uncomfortable: once the familiar signal reappears, many families ignore the richer evidence the project produced. The test becomes the headline. The reform remains, but its meaning shrinks.",
        "You preserved confidence. You also narrowed the pedagogical ambition."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Kept the Reform, Added Clearer Evidence",
      "content": [
        "Leadership adopts a hybrid reporting model without restoring the test: common rubric strands, short subject competency notes, moderated exemplars, and a summary explaining how students demonstrated knowledge, process, and application.",
        "The parent body remains mixed, but the level of alarm drops sharply. Mrs. Kim still says she prefers stronger benchmarking, yet she also acknowledges that the school is not asking families to trust blindly.",
        "You have not removed the meritocratic logic in the room. You have built a structure that can survive inside it."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Mrs. Kim Revisited",
      "content": [
        "Mrs. Kim''s position was never simply ''tests good, projects bad.''",
        "Her central concern was whether the school understood what parents lose when a familiar signal disappears. In a context where families invest enormous time, emotion, and capital into educational positioning, reforms that reduce legibility can feel like hidden risk.",
        "When teachers treat this as mere conservatism, parents feel patronised. When schools translate new approaches into recognisable evidence, even sceptical families become more willing to engage.",
        "Research note: In South Korea, activism around schooling often reflects not only pressure for performance, but a broader habit of active educational stewardship. The challenge for schools is not to eliminate that activism, but to keep reforms intelligible enough that activism does not harden into distrust. (Jang, 2024)"
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the deepest issue in the final decision?",
      "options": [
        "Whether parent activism should ever shape school decisions",
        "Whether the reform could survive without recognisable evidence of fairness",
        "Whether the school had confused innovation with opacity",
        "Whether families were protecting competitive security rather than tradition itself"
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "content": [
        "This simulation explored three recurring tensions in South Korean school contexts shaped by meritocracy and active parental involvement.",
        "Meritocracy and Legible Achievement (D1): In a highly competitive environment, families often depend on visible signals of performance to assess whether a child is secure, advancing, and fairly positioned. When those signals become less clear, concern rises quickly.",
        "Parent Activism and School Communication (D2): Organised parental action is not always a sign of anti-school hostility. It can reflect a deeply normalised belief that responsible parents intervene, ask questions early, and mobilise networks when schooling becomes less legible.",
        "Reform, Fairness, and Competitive Signals (D4): Innovative reforms often fail not because parents reject new learning in principle, but because the school underestimates how much familiar benchmarks function as fairness devices. The key challenge is translation: how to preserve pedagogical ambition while making evidence visible enough to retain trust.",
        "Research: Jang, S. (2024). Capital mechanisms driving parental activism in South Korea: Perspectives from parentocracy, meritocracy, and a Bourdieusian analysis of capital. DOI: 10.1016/j.ijedudev.2024.103104"
      ],
      "researchCitations": [
        {
          "author": "Jang",
          "year": "2024",
          "title": "Capital mechanisms driving parental activism in South Korea: Perspectives from parentocracy, meritocracy, and a Bourdieusian analysis of capital",
          "doi": "10.1016/j.ijedudev.2024.103104"
        }
      ],
      "closingPrompt": "If you could go back to Mrs. Kim''s first message, how would you respond in a way that respects the stakes parents feel without reducing every reform to a demand for old-style benchmarking?"
    }
  }',
  ARRAY[1,2,4],
  20,
  2,
  'live'
);
-- Seed KSA Simulation 2: "The Student Voice Week"
-- Source: KSA_SIM2_THE_STUDENT_VOICE_WEEK.md
-- Dimensions: D1 (International Ethos and Cultural Fit), D2 (Parent Interpretation and Trust), D4 (Voice, Leadership, and Moral Meaning)
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
  'b2c3d4e5-0002-0002-0002-000000000003',
  'ksa-001',
  'The Student Voice Week',
  'A school launches Student Voice Week. A parent asks what the school means by ''voice'' and ''leadership.'' What looks like a simple question is really a test of whether the school can translate its values into culturally grounded practice.',
  'It is January at Al Manar International School in Riyadh. The school has launched Student Voice Week, a cross-campus initiative where students will identify a problem in school life and propose improvements. Leadership describes it as a way to build agency, communication, and collaborative citizenship.',
  '[
    {
      "name": "You",
      "role": "Year 5 classroom teacher at Al Manar International School, Riyadh",
      "description": "You trained in the UK, US, or Australia. You believe students should speak up, solve problems, and contribute ideas. You care about making students feel capable, but you are still learning how international-school language can sound different in Saudi family contexts."
    },
    {
      "name": "Mrs. Alsubaie",
      "role": "Mother of Noura",
      "description": "Mrs. Alsubaie chose the school for English, confidence, and future opportunities, but also expects clear cultural and moral fit. She is thoughtful, polite, and precise. She is not suspicious by default. She wants to understand what the school really means by the values-heavy language it uses."
    },
    {
      "name": "Noura",
      "role": "Student, Year 5, age 10",
      "description": "Noura is strong in English, observant, eager to do school ''the right way,'' and increasingly attentive to which kinds of speech seem admired by adults."
    }
  ]',
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "A bright classroom slide titled Student Voice Week. Under it: ''Speak up. Lead change. Make school better.''",
        "It is January at Al Manar International School in Riyadh. The school has launched Student Voice Week, a cross-campus initiative where students will identify a problem in school life and propose improvements. Leadership describes it as a way to build agency, communication, and collaborative citizenship.",
        "Your class is excited. So are many teachers.",
        "But you know the phrase student voice can carry different meanings depending on who hears it.",
        "Noura is one of your most capable students. She is strong in English, confident in presentations, and highly attuned to what the school rewards. When the announcement slides went up, she whispered to a friend, ''We get to tell the school what should change.''",
        "That afternoon, Mrs. Alsubaie messages you: ''Teacher, may I ask about Student Voice Week? Noura explained it as children making proposals to improve school. That sounds positive. I only want to understand the boundaries. Is this about problem-solving inside school life, or is it encouraging children to question adults more generally? I ask because the language can mean different things.''",
        "The question is calm, not hostile. But it is asking you to do interpretive work, not just provide logistics."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "The First Explanation",
      "prompt": "How do you respond to Mrs. Alsubaie''s message?",
      "choices": [
        {
          "id": "1a",
          "label": "Defend the student voice language",
          "text": "Student voice is an important part of modern learning. We want students to think critically, express opinions, and take ownership. It is about helping them become confident leaders.",
          "next": "consequence_1a"
        },
        {
          "id": "1b",
          "label": "Reassure vaguely",
          "text": "Please do not worry. It is just a school activity and nothing controversial.",
          "next": "consequence_1b"
        },
        {
          "id": "1c",
          "label": "Translate the activity concretely",
          "text": "That is a fair question. In our Year 5 context, this means identifying practical school-life issues — like playground flow, library access, or classroom routines — then making respectful proposals with evidence. It is not about telling children to challenge family authority or moral boundaries. It is about guided problem-solving inside school.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Defended the Language",
      "content": [
        "Mrs. Alsubaie thanks you, but her reply is careful: ''I understand. My question was more about how the idea is being interpreted by children.''",
        "The next day, you hear Noura telling another student, ''We are supposed to speak up even if we disagree.''",
        "Nothing in your message was wrong. But because it stayed at the level of international-school ideals, it left the concrete boundaries of the activity unclear. The school slogan travelled faster than the practical meaning.",
        "You now have a family that is not against the activity, but less sure that the school notices how its language lands."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Reassured Vaguely",
      "content": [
        "Mrs. Alsubaie responds politely: ''Thank you, Teacher.''",
        "Two days later, she writes again: ''I appreciate that. Could you still clarify what kinds of proposals children are being asked to make? Noura says they can suggest rules that adults should change.''",
        "Your first answer solved nothing because it addressed the emotion, not the meaning.",
        "By trying to avoid the values layer, you made it harder for the parent to trust that you had actually understood the question."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Translated the Activity Concretely",
      "content": [
        "Mrs. Alsubaie replies almost immediately: ''Thank you. That makes much more sense.''",
        "The next day, Noura comes to class with a different tone. ''Can my group propose a quieter lunch line system?'' she asks. The activity is still energising, but now it is framed as collaborative improvement rather than vague permission to challenge everything.",
        "You have not removed the possibility of misunderstanding altogether. But you have narrowed the interpretive gap before it widened."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Alsubaie''s View",
      "content": [
        "Mrs. Alsubaie is not objecting to participation.",
        "She is trying to determine what kind of person the school is helping form. In an international-school context, the same words that sound obviously positive to teachers can carry broader meanings for families. Voice, leadership, and critical thinking may be heard not only as classroom skills, but as signals about authority, boundaries, and moral orientation.",
        "From her perspective, asking for clarification is not resistance. It is due diligence.",
        "Research note: Hammad and Shah (2018) show that international schools in Saudi Arabia often operate inside a zone of dissonance between international discourse and national expectations. Families do not always reject the school''s aims. They often need the school to translate those aims into concrete practice so they can judge their cultural fit."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the parent really asking in the first message?",
      "options": [
        "Whether the school was becoming too political",
        "Whether school language and classroom practice meant the same thing",
        "Whether student agency had clear cultural and relational boundaries",
        "Whether she could trust the school''s interpretation of its own slogans"
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "The Child''s Interpretation",
      "prompt": "Later that week, Noura presents a draft poster with her group. At the top it says: ''Students should have more say because adults do not always know what is best for us.'' That afternoon, a second parent asks if students are being taught to ''challenge decisions.'' Leadership notices the concern and asks teachers to be careful in how they describe the week. How do you respond now?",
      "choices": [
        {
          "id": "2a",
          "label": "Frame the concern as a misunderstanding",
          "text": "The parents are overreading the activity. The children are simply getting a little carried away with the language. We should not overreact.",
          "next": "consequence_2a"
        },
        {
          "id": "2b",
          "label": "Treat it as a child-development issue",
          "text": "The issue is not that families are unreasonable. The children need stronger scaffolding so they understand that voice means respectful, evidence-based problem-solving within agreed boundaries.",
          "next": "consequence_2b"
        },
        {
          "id": "2c",
          "label": "Clarify institutional intent publicly",
          "text": "We need a school-wide explanation now. If we leave each family to infer what voice means, the activity will keep accumulating meanings we did not intend. We should send a concrete note about purpose, examples, and limits.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Called It a Misunderstanding",
      "content": [
        "The school does very little.",
        "Teachers quietly rephrase a few slides. Parents continue comparing interpretations in WhatsApp groups. The activity still happens, but it now carries an undercurrent of unease because the school seems to believe the problem is simply parental sensitivity.",
        "Mrs. Alsubaie does not complain further. She just becomes more careful in future conversations, especially when school language sounds too abstract.",
        "The immediate issue passes. The trust issue lingers."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Treated It as a Child-Development Issue",
      "content": [
        "You revise your class instructions: focus on shared school problems, propose realistic solutions, explain respectfully, and do not frame adults as opponents.",
        "The change helps in your room. Noura''s group rewrites its poster: ''Students notice things adults may miss, and we can help improve them respectfully.''",
        "But outside your class, the wording remains inconsistent. Some families still hear very different versions of what the week means.",
        "You improved pedagogy locally. The institutional ambiguity remains."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Clarified Institutional Intent Publicly",
      "content": [
        "Leadership accepts the suggestion and sends a brief bilingual note: Student Voice Week is about school improvement not opposition to adults, proposals must be respectful and evidence-based, examples include routines and facilities, and teachers guide all discussions and outputs.",
        "The note does not please every parent equally, but it changes the tone. The school''s intent is now visible enough to discuss rather than merely infer.",
        "Mrs. Alsubaie replies, ''This clarification is helpful. Thank you for making the practical boundaries clearer.''"
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Noura''s View",
      "content": [
        "Noura is doing exactly what schools often ask children like her to do: she is listening carefully for what counts.",
        "When the school says lead, speak up, and make change, she assumes those phrases are aspirational and expansive. She wants to perform the ideal student identity the school celebrates.",
        "If teachers do not define the boundaries, students will supply their own.",
        "Research note: Much of the tension in international schools is not caused by bad intent. It emerges when broad, values-loaded language travels farther and faster than the practical classroom structures meant to contain it."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What needed to happen once students started overextending the message?",
      "options": [
        "Parents needed to relax",
        "Teachers needed better scaffolding",
        "The school needed a clearer shared explanation",
        "The activity needed to be translated from slogan to practice"
      ],
      "next": "dilemma_3"
    },
    "dilemma_3": {
      "id": "dilemma_3",
      "type": "dilemma",
      "title": "The School''s Next Move",
      "prompt": "At the end of the week, leadership asks for feedback. Future Learning and Student Voice initiatives are likely to continue, but wording and framing may change. You are asked what the school should do next time. What do you recommend?",
      "choices": [
        {
          "id": "3a",
          "label": "Keep the language unchanged",
          "text": "The school should not dilute its values language simply because some parents read it narrowly. We should keep the messaging bold and trust families to adapt.",
          "next": "consequence_3a"
        },
        {
          "id": "3b",
          "label": "Quietly soften the activity",
          "text": "To avoid future tension, we should reduce the emphasis on voice and make it more of a teacher-led suggestion exercise.",
          "next": "consequence_3b"
        },
        {
          "id": "3c",
          "label": "Keep the activity, revise the framing",
          "text": "The school should keep the activity, but pair aspirational language with explicit examples, limits, and culturally grounded explanation so families do not have to guess what terms like voice and leadership mean in practice.",
          "next": "consequence_3c"
        }
      ]
    },
    "consequence_3a": {
      "id": "consequence_3a",
      "type": "consequence",
      "title": "Kept the Language Unchanged",
      "content": [
        "The school''s values branding remains strong. So does the interpretive friction.",
        "Some teachers are comfortable with this. Others begin informally translating school language on their own to prevent avoidable parent concern. The result is inconsistency. Students hear one message in posters, another in classrooms, and a third at home.",
        "You protected the ideal. You did not strengthen the bridge between school and family."
      ],
      "next": "perspective_3"
    },
    "consequence_3b": {
      "id": "consequence_3b",
      "type": "consequence",
      "title": "Quietly Softened the Activity",
      "content": [
        "Next term, similar activities become much narrower. Students still participate, but the energy is lower. Teachers feel safer. Families ask fewer questions.",
        "But something is lost. The school has not solved the translation problem. It has simply reduced the ambition of the experience so the tension goes away.",
        "The activity is smoother. The institutional confidence is weaker."
      ],
      "next": "perspective_3"
    },
    "consequence_3c": {
      "id": "consequence_3c",
      "type": "consequence",
      "title": "Kept the Activity, Revised the Framing",
      "content": [
        "The school adopts a new pattern: aspirational language stays, every initiative includes concrete examples, teacher scripts clarify purpose and boundaries, and parent communications explain what the activity is and is not.",
        "The next time a similar unit launches, fewer parents need private interpretation because much of that work has already been done publicly.",
        "Mrs. Alsubaie remains thoughtful and engaged, but no longer wary. She sees that the school is capable of translation, not only branding."
      ],
      "next": "perspective_3"
    },
    "perspective_3": {
      "id": "perspective_3",
      "type": "perspective",
      "title": "Mrs. Alsubaie Revisited",
      "content": [
        "Mrs. Alsubaie''s concern was never that children should remain passive.",
        "Her concern was whether the school understood that its language has moral and cultural meanings beyond the classroom. Families choosing international schools in Saudi Arabia are often balancing aspiration and rootedness at the same time. They do not necessarily want less confidence for their children. They want confidence formed inside recognisable boundaries.",
        "Research note: The real work is not choosing between ''international'' and ''national.'' It is building enough interpretive clarity that families do not experience that choice as a zero-sum one in ordinary classroom life. (Hammad and Shah, 2018)"
      ],
      "next": "reflection_3"
    },
    "reflection_3": {
      "id": "reflection_3",
      "type": "reflection",
      "title": "Reflection",
      "prompt": "What was the core lesson of the final dilemma?",
      "options": [
        "Schools should not change for parent concern",
        "Schools should avoid values language altogether",
        "Schools need translation, not just conviction",
        "The issue was never the activity alone, but the meanings attached to it"
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "content": [
        "This simulation explored three recurring tensions in international schools in the Kingdom of Saudi Arabia.",
        "International Ethos and Cultural Fit (D1): Families may actively want English, confidence, and future-facing education while still expecting clear cultural fit. These aims are not contradictory from the family''s perspective. Tension begins when the school acts as if they are.",
        "Parent Interpretation and Trust (D2): Parents often need more than reassurance. They need translation. When school language is highly aspirational but practically underdefined, families are left to interpret meanings for themselves, often through a broader cultural and moral lens.",
        "Voice, Leadership, and Moral Meaning (D4): Concepts like student voice and leadership are not culturally self-explanatory. In values-laden contexts, they require concrete framing so that agency is understood as guided participation rather than boundaryless challenge.",
        "Research: Hammad, W., and Shah, S. (2018). Dissonance Between the ''International'' and the Conservative ''National'': Challenges Facing School Leaders in International Schools in Saudi Arabia. DOI: 10.1177/0013161X18785864"
      ],
      "researchCitations": [
        {
          "author": "Hammad and Shah",
          "year": "2018",
          "title": "Dissonance Between the International and the Conservative National: Challenges Facing School Leaders in International Schools in Saudi Arabia",
          "doi": "10.1177/0013161X18785864"
        }
      ],
      "closingPrompt": "If you could go back to Mrs. Alsubaie''s first message, how would you explain Student Voice Week so that its educational purpose remains strong but its practical meaning is unmistakably clear?"
    }
  }',
  ARRAY[1,2,4],
  20,
  2,
  'live'
);
