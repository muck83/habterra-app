BEGIN;

-- ── SIMULATIONS ──────────────────────────────────────────────────────────────

-- Simulation A: The Quiet Meeting
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'b2c3d4e5-0004-0001-0001-000000000001',
  'vietnam-001',
  'The Quiet Meeting',
  'A parent-teacher conference where everything seems fine — the parent is warm, grateful, and asks no challenging questions. Three weeks later, a request arrives through a relative who works at the school, asking whether the student can take supplementary standardised tests. The teacher must understand what happened in the meeting and what the request actually means.',
  'It is mid-October at Lotus International School in Ho Chi Minh City. You teach Year 8 English and Humanities. Your class has just completed its first IB MYP interdisciplinary unit — a research project on urban development that combined English writing skills with Geography concepts. Students presented their findings to parents at an exhibition evening last week.

Minh is a strong student. His written English is excellent, his research was thorough, and his presentation was confident. His mother, Mrs. Nguyen, attended the exhibition and seemed genuinely impressed. She thanked you warmly and said the school was doing wonderful things.

Today is the scheduled PTM. Mrs. Nguyen arrives on time, well-dressed, and carrying a small gift — a box of mooncakes. She greets you with a warm smile.

"Teacher, thank you so much for everything you are doing for Minh. The exhibition was beautiful. He is so happy at this school."

She asks polite questions about Minh''s progress, nods at your responses, and expresses gratitude several times. She does not raise any concerns. The meeting lasts fifteen minutes and feels entirely positive.

Three weeks later, Ms. Tran from the school office mentions that Mrs. Nguyen''s sister-in-law — who works in the school''s finance department — has passed along a question: "Is there a way for Minh to take a standardised test so the family can see where he stands compared to other students at his level?"',
  '[
    {"name":"You","role":"Year 8 English/Humanities teacher at Lotus International School, HCMC","description":"You trained overseas and have been teaching at Lotus for two years. You believe in inquiry-based learning and narrative feedback. You thought Mrs. Nguyen was one of your most supportive parents."},
    {"name":"Mrs. Nguyen","role":"Mother of Minh","description":"She runs a small import-export business. She and her husband are investing a significant portion of their income in Minh''s international school fees. She is the first in her extended family to send a child to an international school. She is warm, respectful, and deeply invested in Minh''s education."},
    {"name":"Ms. Tran","role":"School finance department colleague","description":"She is Mrs. Nguyen''s sister-in-law. She is passing along the family''s question informally, not as a formal complaint."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "It is mid-October at Lotus International School in Ho Chi Minh City. You teach Year 8 English and Humanities.",
        "Your class has just completed its first IB MYP interdisciplinary unit — a research project on urban development. Students presented their findings at an exhibition evening last week.",
        "Minh is a strong student. His written English is excellent, his research was thorough, and his presentation was confident. His mother, Mrs. Nguyen, attended the exhibition and seemed genuinely impressed.",
        "Today is the scheduled PTM. Mrs. Nguyen arrives with a warm smile and a box of mooncakes.",
        "\"Teacher, thank you so much for everything you are doing for Minh. The exhibition was beautiful. He is so happy at this school.\"",
        "She asks polite questions, nods at your responses, and expresses gratitude several times. She does not raise any concerns. The meeting feels entirely positive.",
        "Three weeks later, Ms. Tran from the finance department mentions that Mrs. Nguyen''s sister-in-law has passed along a question: \"Is there a way for Minh to take a standardised test so the family can see where he stands compared to other students?\""
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Indirect Request",
      "content": ["The request has arrived through a family connection inside the school, not through a formal channel or direct conversation with you. How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Treat it as informal and wait for a direct request",
          "text": "\"I appreciate Ms. Tran mentioning it, but I think I should wait for Mrs. Nguyen to raise this with me directly before acting on it.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Contact Mrs. Nguyen directly to discuss the request",
          "text": "You email Mrs. Nguyen: \"I understand you may have some questions about how we track Minh''s progress. I would love to have a conversation about this — would you be available for a quick call or meeting?\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Respond through the same indirect channel",
          "text": "You ask Ms. Tran to let the family know that you would be happy to provide a more detailed academic summary of Minh''s progress against IB criteria, and that you can meet to walk through it together.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Nguyen does not raise the request directly. The indirect channel was the request.",
        "Two months later, you learn from a colleague that Minh has been enrolled in weekend test-preparation classes at a local tutoring centre. His workload has visibly increased. His written work, once careful and creative, has become more formulaic — optimised for speed rather than depth.",
        "Mrs. Nguyen continues to be warm and grateful at school events. Nothing has changed on the surface. But underneath, the family has quietly created a parallel assessment system because the school''s system did not give them what they needed."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Nguyen replies politely but seems slightly startled. She did not expect the request to reach you so directly.",
        "\"Oh, it was just a small question,\" she says. \"Please do not worry about it. Minh is doing very well.\"",
        "The conversation has been shut down. By addressing the request head-on, you accidentally raised the stakes of what was intended as a low-cost, face-preserving inquiry. Mrs. Nguyen now feels exposed — her indirect question was made direct, and she retreated.",
        "The concern has not gone away. It has simply moved further underground."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Ms. Tran passes the message along. A few days later, Mrs. Nguyen sends you a polite email: \"Thank you, Teacher. That would be very helpful. We just want to understand clearly how Minh is doing.\"",
        "You prepare a detailed summary of Minh''s performance across MYP criteria, with specific examples from his recent work and a clear explanation of what each level means in terms of university readiness.",
        "Mrs. Nguyen responds warmly. She asks one follow-up question: \"Is there a way to see how this compares to what students at his level typically achieve?\" The underlying question — comparative positioning — is still there. But the channel is now open, the tone is collaborative, and you can address it directly."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective: Mrs. Nguyen''s View",
      "content": [
        "Mrs. Nguyen is not being evasive or manipulative. She is communicating through the channel that feels safest.",
        "In Vietnamese communication culture, raising a concern directly with a teacher risks creating an uncomfortable situation for both parties. The indirect channel — through a family connection at the school — allows the question to be asked without anyone losing face.",
        "The warmth in the PTM was genuine. Mrs. Nguyen truly is grateful. But gratitude and concern coexist. She can appreciate the school and still worry about whether the assessment system is producing outcomes her extended family will recognise as legitimate.",
        "As a first-generation international school parent, she has no older sibling or cousin to ask: ''Is this normal? Is my child really doing well?'' The standardised test request is not distrust — it is a search for legible proof in a system she is still learning to read."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What did you assume about the PTM when it ended?",
      "options": [
        "I thought the meeting went well and the relationship was strong.",
        "I noticed she did not ask challenging questions but assumed she was satisfied.",
        "I suspected there might be unspoken concerns but was not sure how to surface them.",
        "I did not consider that the warm meeting and the later request could be connected.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Assessment Question",
      "content": [
        "You now have a meeting scheduled with Mrs. Nguyen to walk through Minh''s academic progress.",
        "You know she wants comparative data. Your school does not rank students. The IB MYP uses criterion-referenced assessment, not norm-referenced.",
        "But you also know that Minh is genuinely performing well — he would be in the top third of most Year 8 cohorts internationally.",
        "How do you prepare for this meeting?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Explain the MYP criteria system and why ranking is not part of it",
          "text": "You prepare a clear explanation of how MYP criteria work, what each level means, and why the school uses criterion-referenced rather than norm-referenced assessment. You want to educate her about the system.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Lead with outcomes and connect criteria to university readiness",
          "text": "You prepare university placement data for graduates of your school. You show Minh''s performance against each criterion with specific examples of his work, and you connect each level to what it means for future university readiness: ''Students performing at Minh''s level are well-positioned for competitive university programmes.''",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Create an unofficial benchmark comparison",
          "text": "You prepare a summary that informally contextualises Minh''s performance: ''Among students at this stage of MYP internationally, Minh''s performance is strong.'' You are careful not to rank him within the class but you give her the comparative frame she is looking for.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Nguyen listens carefully and nods throughout your explanation.",
        "At the end, she thanks you. Then she asks: \"So... is he doing well?\"",
        "You realise that the entire explanation answered a question she did not ask. She wanted to know whether Minh is competitive. You explained how the scoring system works.",
        "The meeting ends politely. Mrs. Nguyen is no better informed about the question that actually matters to her."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Mrs. Nguyen leans forward when you show the university data.",
        "\"So students at Minh''s level — they go to universities like this?\" She points to several names on the list.",
        "\"Yes,\" you say. \"And Minh is performing at or above the level where our graduates have been successful in these programmes.\"",
        "For the first time, the concern relaxes. She has heard the answer to her actual question — not in percentage terms, but in outcome terms that she can report to her family with confidence.",
        "She asks whether you can share this kind of update once per term. You agree. The relationship has moved from warm-but-anxious to informed-and-collaborative."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "Mrs. Nguyen is clearly relieved. \"Thank you, Teacher. This is exactly what I needed to know.\"",
        "The meeting goes well. But two weeks later, your MYP coordinator stops by your classroom.",
        "\"A parent mentioned receiving some comparative benchmarking from you. I understand the intention, but we need to be careful — if one family gets this, others will expect it, and we risk recreating a ranking system informally.\"",
        "You are now in the same position as if you had given Mrs. Rao in India an unofficial percentage conversion. The short-term trust gain has created a long-term institutional problem."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective: What the Request Actually Means",
      "content": [
        "The request for comparative data is not about distrust. It is about legibility.",
        "Mrs. Nguyen''s extended family will ask about Minh''s progress at Tet. Her husband''s colleagues will mention their children''s scores. Her neighbours know she is paying international school fees and will want to know whether it is ''working.''",
        "In all of these conversations, the currency is comparative positioning. Without it, Mrs. Nguyen cannot answer the social question her community is asking.",
        "The most effective teacher response is to give her a different kind of comparative data — university outcomes, programme trajectories, skill benchmarks — that she can use in those conversations without requiring the school to rank students against each other."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What question was Mrs. Nguyen actually asking?",
      "options": [
        "How does MYP assessment work?",
        "Is my child performing well enough that I can tell my family this investment is working?",
        "Does this school produce outcomes I can recognise?",
        "Can I trust you to be honest with me about my child?",
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
            "This simulation exercised two of the most common misreadings in Vietnamese international school contexts.",
            "The Smooth Meeting: Vietnamese communication culture, structured by face (thể diện), produces PTMs that feel warmer and more resolved than they are. A parent who is genuinely grateful and simultaneously concerned will express the gratitude in the meeting and process the concern privately. The teacher who reads the warm meeting as a resolved relationship misses the gap.",
            "The Indirect Channel: Concerns in Vietnamese culture often travel through intermediaries rather than direct confrontation. A request that arrives through a family connection is not gossip or boundary violation — it is the culturally appropriate way to raise a concern without creating an uncomfortable direct encounter. Treating it as informal and waiting for a direct request may mean waiting forever.",
            "The Assessment Translation: The request for standardised test data is a request for legible proof. First-generation international school parents in Vietnam have fewer reference points for what IB performance means in the competitive arena they navigate. University outcomes data — not assessment philosophy — is the bridge."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Tran et al. (2024). Academic stress among students in Vietnam: a three-year longitudinal study. PMC11442093.",
            "Frontiers in Psychology (2020). The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison.",
            "Tandfonline (2023). Changing teachers'' beliefs and practices towards learner-centred education: experiences from Vietnam''s education reforms.",
            "WENR (2017). Education in Vietnam."
          ]
        }
      ],
      "finalPrompt": "If you could go back to the original PTM with Mrs. Nguyen — before she channelled her question through Ms. Tran — what would you do differently in the meeting itself to make it easier for her to raise the question she was actually carrying?"
    }
  }'::jsonb,
  ARRAY[1, 4],
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
  dimension_tags = EXCLUDED.dimension_tags,
  status       = EXCLUDED.status;


COMMIT;
