BEGIN;

-- Simulation B: The Assessment Translation
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'b2c3d4e5-0004-0001-0002-000000000002',
  'vietnam-001',
  'The Assessment Translation',
  'A teacher gives a student positive public feedback. The student looks uncomfortable. Later, the parent contacts the teacher to ask whether the child is actually performing well — revealing a disconnect between how feedback is given and how it is received in Vietnamese culture.',
  'It is November at Lotus International School. You are wrapping up a group presentation in Year 9 Individuals and Societies. Linh, a quiet but capable student, has just delivered a well-researched section on economic inequality in Southeast Asia. Her analysis was clear, her evidence was specific, and she spoke with more confidence than you have seen before.

You are genuinely impressed, and you say so in front of the class: "That was excellent work, Linh. Your analysis was really strong — you should be proud of how you handled that."

Linh gives a small, tight smile and looks down. She does not seem pleased. If anything, she seems uncomfortable.

Two days later, you receive an email from Linh''s father, Mr. Tran: "Dear Teacher, thank you for your continued support of Linh. She mentioned that you praised her work in class. We appreciate this, but we want to understand clearly: is Linh actually performing well in your subject? We would like to know specifically what she needs to improve. If there are areas where she is falling behind, please tell us directly so we can support her at home."',
  '[
    {"name":"You","role":"Year 9 Individuals and Societies teacher at Lotus International School","description":"You have been teaching at Lotus for three years. You use positive reinforcement regularly and believe that public praise builds student confidence."},
    {"name":"Linh","role":"Year 9 student","description":"She is quiet, diligent, and performs consistently well on written work. She rarely volunteers in class but produces strong analysis when called upon. She attends private tutoring twice a week for maths and English."},
    {"name":"Mr. Tran","role":"Linh''s father","description":"He is an engineer who studied at a Vietnamese national university. He is the first in his family to send a child to an international school. He is serious, formal in communication, and deeply invested in Linh''s academic success."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "You have just praised Linh publicly for an excellent presentation. She looked uncomfortable rather than pleased.",
        "Two days later, her father emails: \"She mentioned that you praised her work in class. We appreciate this, but we want to understand clearly: is Linh actually performing well? We would like to know specifically what she needs to improve.\"",
        "The praise that was intended to build confidence has been received as ambiguous. The family is now asking for the feedback they actually value: what needs to change."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: Responding to Mr. Tran",
      "content": ["How do you respond to Mr. Tran''s email?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Reaffirm the positive feedback and explain your assessment approach",
          "text": "\"Dear Mr. Tran, Linh is genuinely performing very well. The praise I gave was based on strong analytical work. In our assessment approach, we celebrate achievement alongside identifying growth areas...\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Lead with what Linh needs to improve, then contextualise the strengths",
          "text": "\"Dear Mr. Tran, thank you for your email. Let me be specific about where Linh can grow: her oral confidence is developing but she could push herself to contribute more frequently in discussions. Her written analysis is strong — she is performing at the upper range of the criteria. Here is what the next level looks like and how she can reach it...\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Ask for a meeting to discuss in person",
          "text": "\"Dear Mr. Tran, thank you for reaching out. I would like to discuss Linh''s progress in detail — could we arrange a brief meeting?\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mr. Tran replies politely: \"Thank you, Teacher. But we would still like to know what she needs to work on.\"",
        "He has heard your reassurance and filed it away. It did not answer his question. For Mr. Tran, positive feedback without developmental specificity sounds like the teacher is being polite rather than serious.",
        "The exchange is cordial but the communication gap remains. He still does not have the information he actually requested."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mr. Tran replies the same evening — unusually quickly.",
        "\"Thank you, Teacher. This is very helpful. We will encourage Linh to speak more in discussions. Can you tell us: at her current level, what kind of university programmes would she be competitive for? We want to make sure she is on the right path.\"",
        "By leading with the developmental feedback, you gave him the signal he was listening for: this teacher is serious and specific. The conversation is now open and productive. He is asking about outcomes — which means the trust channel is working."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Mr. Tran agrees to a meeting but his reply is brief and formal.",
        "When you meet, he is polite but clearly expecting specific information. He has prepared questions. He wants to know exactly where Linh stands, what she needs to improve, and what the school is doing about it.",
        "The meeting goes well — but it could have been accomplished in a well-written email. By deferring to an in-person meeting, you inadvertently raised the formality level. Mr. Tran may have interpreted the meeting request as a sign that there is something serious to discuss."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective: Why Praise Landed Wrong",
      "content": [
        "In Vietnamese educational culture, public praise can create discomfort for several reasons.",
        "First, it singles out the student from the group, which disrupts collective harmony — a core Confucian classroom value.",
        "Second, for a student operating under filial piety, praise from the teacher does not resolve the question ''Am I doing well enough?'' — only the family''s assessment resolves that, and the family''s assessment is based on improvement data, not celebration.",
        "Third, Vietnamese parents are accustomed to improvement-focused feedback. A teacher who leads with positives and does not specify what needs to change may be heard as either being polite (and therefore not fully honest) or as having low expectations.",
        "Mr. Tran''s email was not a sign of dissatisfaction. It was a culturally appropriate request for the kind of feedback his educational experience taught him to expect: direct, specific, and focused on what his daughter needs to do next."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What assumption was behind your use of public praise?",
      "options": [
        "I assumed public recognition would build Linh''s confidence.",
        "I was using the feedback method I was trained in without considering cultural reception.",
        "I did not realise that praise could be heard as ambiguous rather than affirming.",
        "I thought positive feedback would strengthen the parent relationship.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Adjusting Your Practice",
      "content": [
        "You reflect on the exchange and realise that your default feedback style — lead with positives, build confidence through public recognition — may not be serving all students equally.",
        "You have 28 students in Year 9. About a third are Vietnamese, a third are Korean, and the rest are a mix of nationalities.",
        "How do you adjust?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Stop public praise entirely and move to private feedback only",
          "text": "You decide that public praise is too culturally variable and switch to giving all meaningful feedback privately — in writing or in one-to-one conversations.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Keep public praise but add private developmental follow-up for families who prefer it",
          "text": "You continue to recognise strong work publicly, but you also establish a regular written update to parents that leads with specific areas for improvement and includes concrete next steps. You mention this practice to parents at the next conference.",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Ask students individually how they prefer to receive feedback",
          "text": "You design a brief questionnaire asking students how they feel about public praise, what kind of feedback helps them most, and how they would like their parents to be updated.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "The shift works well for some students. Linh seems more relaxed.",
        "But several other students — particularly those from cultures where public recognition is motivating — notice the change. A parent mentions: ''My daughter said the teacher stopped praising students. Is something wrong?''",
        "You have overcorrected. The issue was not public praise itself — it was the assumption that one feedback style works equally well across all cultural contexts."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "The dual approach works. Vietnamese and Korean parents respond well to the improvement-focused written updates. Other parents appreciate the public recognition continuing.",
        "Mr. Tran''s next email is brief and appreciative: ''Thank you for the update. This is very clear. We will work on the areas you mentioned.''",
        "You have not changed the classroom culture. You have added a communication layer that meets different parents where they are."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "The questionnaire produces interesting data. Most Vietnamese students say they prefer private feedback. Most Western students say they like public recognition. Korean students are split.",
        "But several students — including Linh — do not answer honestly. They write what they think you want to hear. The questionnaire reveals preferences but also reveals the limits of self-report in a culture where students avoid contradicting the teacher.",
        "The data is useful but incomplete. You will need to observe and adjust over time, not rely on a single survey."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective: The Feedback Gap",
      "content": [
        "This simulation surfaces a gap that many international teachers do not see until it creates confusion: the gap between how feedback is intended and how it is received.",
        "In Western teacher training, positive reinforcement is a foundational technique. Praise builds confidence. Public recognition motivates. The sandwich model (positive-growth-positive) is standard.",
        "In Vietnamese educational culture, the serious content of feedback is what needs to improve. A teacher who leads with positives may be heard as either avoiding the real conversation or having low expectations. The parent who asks ''but what does she need to work on?'' is not being negative — they are asking for the feedback format they trust.",
        "The adjustment is not to stop praising. It is to ensure that improvement-focused, specific, action-oriented feedback reaches the families who need it — in writing, proactively, and without requiring the family to ask for it."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What is the most important thing you learned about feedback in this scenario?",
      "options": [
        "Praise is culturally variable — it does not land the same way for every student.",
        "Vietnamese parents want developmental feedback as the primary communication, not the secondary one.",
        "I need to design feedback systems, not just rely on feedback moments.",
        "The way I was trained to give feedback is not universal.",
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
            "This simulation exercised the gap between Western feedback norms and Vietnamese feedback culture.",
            "Public Praise: In Confucian-heritage classrooms, singling out a student disrupts collective harmony and can create social discomfort rather than confidence. The student who looks uncomfortable after praise is not ungrateful — they are managing a social situation the teacher inadvertently created.",
            "Improvement-Focused Communication: Vietnamese parents are culturally calibrated to hear what needs to change as the substantive, respectful content of educational feedback. Leading with positives can signal avoidance or low expectations. The parent who asks for improvement data is telling you how to build trust with them.",
            "Feedback Systems: The solution is not to choose between Western and Vietnamese feedback styles but to build a communication system that delivers both — public recognition for those who benefit from it, and proactive, specific, improvement-focused written updates for families who need that format."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "PMC (2022). Culture expectations in foreign language classrooms: a case in Vietnam.",
            "Tandfonline (2025). Primary classroom rules in Confucian heritage culture: a case study in Vietnam.",
            "MDPI (2025). Confucian Educational Thought and its Relevance to Contemporary Vietnamese Education."
          ]
        }
      ],
      "finalPrompt": "Think about your current feedback practices. If a third of your students come from cultures where public praise creates discomfort rather than confidence, how would you redesign your approach?"
    }
  }'::jsonb,
  ARRAY[3, 4, 6],
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
  dimension_tags = EXCLUDED.dimension_tags,
  status       = EXCLUDED.status;


COMMIT;
