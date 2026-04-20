BEGIN;

-- Simulation C: The Tutor Question
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'b2c3d4e5-0004-0001-0003-000000000003',
  'vietnam-001',
  'The Tutor Question',
  'A parent reveals that their child attends a tutoring centre three evenings a week alongside international school. They ask whether this is a problem — revealing a disconnect about what learning looks like and what counts as sufficient investment in education.',
  'It is January at Lotus International School. You teach Year 10 Sciences. Duc is a solid student — not exceptional, but consistent. He submits work on time, follows instructions carefully, and produces competent lab reports. He rarely contributes to class discussions voluntarily.

During a routine check-in with parents about subject selection for the IB Diploma Programme, Mrs. Pham mentions casually: "Duc is also attending Mr. Long''s tutoring centre on Monday, Wednesday, and Friday evenings for mathematics and science. It has been very helpful. But I wanted to ask you — is this a problem for the school? Some parents said the school might not like it."

You were not aware of the tutoring. Looking at Duc''s recent performance, several things click: his lab reports have become more formulaic over the past term. His answers on tests are technically correct but lack the explanatory depth your rubric rewards. In group discussions, he waits for others to take risks and then confirms the safe answer.

Mrs. Pham is watching your face carefully. She is genuinely asking — not challenging. She wants to know whether the school and the tutoring can coexist.',
  '[
    {"name":"You","role":"Year 10 Sciences teacher at Lotus International School","description":"You have been teaching IB Sciences for four years. You value inquiry-based learning and want students to explain their reasoning, not just produce correct answers."},
    {"name":"Duc","role":"Year 10 student","description":"He is consistent and conscientious. He has attended tutoring for two years. His father is an accountant; his mother runs a small business. He is the eldest of two children and carries visible responsibility for his academic outcomes."},
    {"name":"Mrs. Pham","role":"Duc''s mother","description":"She is practical, warm, and slightly nervous in school settings. She completed secondary school in the Vietnamese national system and did not attend university. She is investing significantly in both the international school fees and the tutoring fees."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "It is January at Lotus International School. You teach Year 10 Sciences.",
        "During a routine parent check-in, Mrs. Pham mentions that Duc attends tutoring three evenings a week for maths and science.",
        "\"Is this a problem for the school?\" she asks. \"Some parents said the school might not like it.\"",
        "You notice that Duc''s recent work has become more formulaic — technically correct but lacking the explanatory depth your rubric rewards.",
        "Mrs. Pham is watching your face carefully. She is genuinely asking, not challenging."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Initial Response",
      "content": ["How do you respond to Mrs. Pham''s question about the tutoring?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Reassure her that tutoring is fine",
          "text": "\"Not at all — many families use tutoring alongside the school. As long as Duc is managing his workload, there is no problem.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Express concern about the tutoring''s impact on Duc''s learning",
          "text": "\"I appreciate you telling me. I have noticed that Duc''s work has become more formulaic recently — technically correct but without the depth our assessments reward. I wonder if the tutoring method might be teaching him to produce answers rather than explanations.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Acknowledge the tutoring and reframe the conversation around Duc''s IB preparation",
          "text": "\"Thank you for sharing this, Mrs. Pham. Tutoring is very normal and I understand why families invest in it. Let me show you what our IB assessments actually test, because it is slightly different from what tutoring typically prepares for — and I want to make sure Duc is getting the best from both.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Pham looks relieved. \"Good. We were worried.\"",
        "The conversation moves on. But you have missed the diagnostic opportunity.",
        "Over the next term, Duc''s pattern deepens. His test answers become more efficiently correct and less explanatorily rich. His Internal Assessment proposal is technically sound but conceptually shallow. He is optimising for the tutoring model — structured recall — while your assessment rewards something different.",
        "By the time you raise it at the next conference, the pattern is harder to shift."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Pham''s expression tightens.",
        "\"Mr. Long is a very experienced teacher,\" she says carefully. \"Many families use him. Are you saying we should stop?\"",
        "You have accidentally set up a competition between yourself and the tutor — and in Mrs. Pham''s world, the tutor is a known quantity with community validation. You are a foreign teacher at an expensive school suggesting that the family''s additional investment might be harmful.",
        "The conversation becomes defensive. Mrs. Pham leaves politely but you sense the trust has narrowed."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Mrs. Pham nods slowly. \"Please — show me.\"",
        "You pull up a recent lab report from Duc. You show her the rubric: ''This criterion rewards correct methodology. Duc scores well here. This criterion rewards explaining why the method works and what the limitations are. This is where Duc has room to grow.''",
        "\"So the tutoring helps with the first part but not the second?\" she asks.",
        "\"Exactly. The tutoring is giving him a strong foundation. What we are adding at school is the ability to use that foundation to think through problems he has not seen before. Both matter.\"",
        "Mrs. Pham asks whether there is something she can encourage at home. You suggest: ''When Duc tells you about a science concept, ask him why it works, not just what it is.'' She writes this down.",
        "The relationship has strengthened. You have validated her investment while expanding her understanding of what the school adds."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective: Mrs. Pham''s View",
      "content": [
        "Mrs. Pham did not attend university. Her husband completed a Vietnamese national university programme. They are investing in Duc''s international education because they believe it will open doors they did not have.",
        "The tutoring is not a vote of no-confidence in the school. It is standard practice — 92.1% of Vietnamese students attend extra classes. For Mrs. Pham, stopping tutoring would feel like reducing investment in her son''s future, which would be a failure of parental duty in the filial piety framework.",
        "Her question — ''Is this a problem?'' — was genuine. She has heard from other parents that international schools sometimes disapprove of tutoring. She is trying to navigate two systems that may have different expectations, and she does not want to get it wrong.",
        "The most helpful teacher response validates the family''s investment logic while helping them understand what the school adds that the tutoring does not. This is not about choosing one system over the other — it is about making both work together."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What was your first instinct when Mrs. Pham mentioned the tutoring?",
      "options": [
        "I wanted to reassure her so the conversation would not become awkward.",
        "I was concerned that the tutoring was undermining my teaching.",
        "I was curious about how the tutoring was affecting Duc''s learning.",
        "I felt defensive — as if the tutoring implied my teaching was not enough.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Workload Question",
      "content": [
        "A week later, you check in with Duc privately during a lab session.",
        "\"How is everything going? I know you have a busy schedule with tutoring in the evenings.\"",
        "Duc pauses. \"It is fine, Teacher. I am used to it.\"",
        "You notice he looks tired. His eyes are red. He has been less focused in morning classes over the past month.",
        "\"Duc — honestly, how are you sleeping?\"",
        "He looks down. \"I usually finish my tutoring homework around 11. Then I do school homework. I sleep around midnight or 12:30. But it is okay. My parents work very hard for me. I cannot waste their investment.\"",
        "What do you do with this information?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Raise it with Mrs. Pham immediately",
          "text": "You contact Mrs. Pham to express concern about Duc''s sleep and workload, suggesting that the tutoring schedule may need adjustment.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Refer to pastoral care and let them handle the family conversation",
          "text": "You flag the conversation with your pastoral lead, sharing Duc''s words about not wasting his parents'' investment and his sleep schedule. You ask them to follow up.",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Work with Duc first, then bring the family in",
          "text": "You talk to Duc about managing his time between the two systems. You help him identify which tutoring work overlaps with school content so he can reduce duplication. Then you contact Mrs. Pham with a specific, practical suggestion rather than a general concern.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Pham is quiet on the phone.",
        "\"We appreciate your concern, Teacher. But Duc has always been this way. Vietnamese students work hard. This is normal.\"",
        "She is not dismissing you. She is telling you that what you see as concerning is, in her experience, the standard level of effort expected from a serious student. The 92.1% tutoring rate is not an abstraction — it is Mrs. Pham''s neighbourhood.",
        "You have expressed the concern. But the framing — ''your child is overworked'' — has been received as a foreign teacher not understanding how Vietnamese families approach education."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Your pastoral lead follows up. They are experienced with Vietnamese families and frame the conversation carefully: ''We want to support Duc''s long-term success, including his health. Here is what we''ve observed, and here is what the research says about sleep and academic performance.''",
        "Mrs. Pham is more receptive to this framing. The pastoral lead provides specific data: ''Students who sleep less than 7 hours perform measurably worse on the kind of complex reasoning IB assessments require.''",
        "This connects the concern to the outcome Mrs. Pham cares about — academic performance — rather than framing it as a lifestyle critique."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "You sit with Duc and map out his weekly schedule. Together, you identify three hours of overlap where the tutoring is covering material he has already learned in school.",
        "You contact Mrs. Pham: ''I have been working with Duc on his study schedule. He is doing well, but I noticed some overlap between his tutoring content and what we cover in class. If we can reduce the duplication, he can use that time for the deeper analysis work that IB assessments reward — and get more sleep.''",
        "Mrs. Pham asks: ''Will this affect his results?''",
        "You show her the specific areas where Duc''s IB performance would improve with more sleep and more time for explanatory thinking. She agrees to discuss the schedule with Mr. Long.",
        "The change is modest — one fewer evening, one more hour of sleep — but it came through collaboration rather than criticism."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective: What Duc Is Carrying",
      "content": [
        "Duc''s statement — ''My parents work very hard for me. I cannot waste their investment'' — is a textbook expression of authoritarian filial piety.",
        "He is not describing pressure from an external source. He has internalised the family''s sacrifice as a debt he must repay through academic effort. Every hour of study is a moral act. Every hour of rest feels like a betrayal of his parents'' investment.",
        "The research is clear: this dynamic is negatively associated with academic achievement and positively associated with depressive symptoms. The student who appears most dedicated may be the one most at risk.",
        "The 27% depression rate in Vietnamese secondary students is not an abstraction. Duc is a real version of that statistic — high-functioning, compliant, visibly hardworking, and quietly carrying a load that is eroding his capacity for the kind of learning the IB actually rewards."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What is the most important thing you want to carry forward from this conversation?",
      "options": [
        "The tutoring is not the problem — the total load is.",
        "I need to know my students'' full schedules, not just their school schedules.",
        "Telling a Vietnamese family to reduce investment is heard differently than I intend it.",
        "The student who says ''I cannot waste my parents'' investment'' is telling me something about their mental health, not just their motivation.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Review the choices you made across both dilemmas.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This simulation exercised the tutoring dynamic that is nearly universal in Vietnamese education.",
            "The Normalisation of Tutoring: 92.1% of Vietnamese students attend extra classes. For a family like the Phams, enrolling Duc in tutoring is not a critique of the school — it is the minimum expected investment in a serious education. Stopping tutoring would feel like reducing parental commitment.",
            "The Method Conflict: Tutoring centres in Vietnam typically teach structured recall and exam technique. IB assessment rewards explanatory depth, application to novel contexts, and analytical reasoning. The two systems produce different kinds of competence, and students caught between them often default to the tutoring model because it feels safer and more concrete.",
            "The Filial Piety Load: Duc''s statement about not wasting his parents'' investment reveals the internalised obligation dynamic that the research documents. This is not external pressure being applied to a resistant student — it is a moral framework the student has accepted as reality. The risk is not overwork; it is the depression and disengagement that the research associates with authoritarian filial piety."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Tran et al. (2024). Academic stress among students in Vietnam: a three-year longitudinal study. PMC11442093.",
            "Frontiers in Psychology (2020). The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison.",
            "PMC (2024). The interdependence of happiness and filial piety within the family: a study in Vietnam. PMC11016942."
          ]
        }
      ],
      "finalPrompt": "Think about your current students. How many of them are attending tutoring alongside your school? What do you know about their total weekly cognitive load? And what would change in your teaching if you knew?"
    }
  }'::jsonb,
  ARRAY[2, 5, 6],
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
  dimension_tags = EXCLUDED.dimension_tags,
  status       = EXCLUDED.status;

COMMIT;

COMMIT;
