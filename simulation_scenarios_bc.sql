-- Calibrate: Simulation Scenarios B & C for India, KSA, Korea, China
-- 8 new branching simulations (2 per country)
-- Run AFTER 20260330_create_simulations.sql
-- Each scenario has: setup, 2 dilemmas, consequences, perspective, reflection, debrief

BEGIN;

----------------------------------------------------------------------
-- INDIA Scenario B: "The Percentage Question"
-- Assessment translation moment — parent sees rubric, asks for a number
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'india-sim-b',
  'india-001',
  'The Percentage Question',
  'Report card day. Mr. Sharma opens his daughter''s portfolio and sees rubric descriptors where numbers used to be. He needs you to translate.',
  'It is November at Banyan International School, Bengaluru. Report portfolios have just been sent home. Your school uses criterion-based rubrics with descriptors: Emerging, Developing, Meeting, Exceeding. There are no percentages, no class ranks, no subject-wise totals. Priya is a strong Year 8 student. She scored "Meeting" or "Exceeding" across every strand. By your school''s standards, this is excellent. Mr. Sharma arrives at the scheduled portfolio review holding a printout. He has circled the word "Meeting" in three places. "Teacher, I appreciate the detail," he says. "But my wife and I cannot read this. In CBSE, Meeting would be around 70%. Is that what you mean? Because 70% in our family would be a serious concern." He is not angry. He is genuinely trying to decode the document. His older son is at a CBSE school and just scored 91% in his boards. He has a concrete reference point, and your report has removed it.',
  '[
    {"name": "You", "role": "Year 8 humanities teacher, 3rd year at Banyan International School", "description": "You believe in criterion-based assessment and narrative feedback. You also know that parents like Mr. Sharma are not wrong to want clarity — they just need a different kind of clarity than you are trained to give."},
    {"name": "Mr. Sharma", "role": "Father of Priya, senior manager at an IT consultancy", "description": "He chose Banyan for its English immersion and global university track. He is data-driven by profession. He is not hostile to inquiry — he just cannot evaluate his daughter''s progress without comparable data points."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Portfolio Review",
      "content": [
        "November at Banyan International School, Bengaluru. Report portfolios have just been sent home.",
        "Your school uses criterion-based rubrics with descriptors: Emerging, Developing, Meeting, Exceeding. There are no percentages, no class ranks, no subject-wise totals.",
        "Priya is a strong Year 8 student. She scored \"Meeting\" or \"Exceeding\" across every strand. By your school''s standards, this is excellent.",
        "Mr. Sharma arrives holding a printout. He has circled the word \"Meeting\" in three places.",
        "\"Teacher, I appreciate the detail,\" he says. \"But my wife and I cannot read this. In CBSE, Meeting would be around 70%. Is that what you mean? Because 70% in our family would be a serious concern.\"",
        "His older son is at a CBSE school and just scored 91% in his boards. He has a concrete reference point, and your report has removed it."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: Translating the Rubric",
      "content": ["How do you help Mr. Sharma read the report?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Give him an unofficial percentage equivalent",
          "text": "\"Meeting is roughly equivalent to 75-85% in CBSE terms. Exceeding would be 90%+. Priya is doing very well by any scale.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Explain the rubric on its own terms",
          "text": "\"I understand the confusion, Mr. Sharma. These descriptors are not percentages — they describe what Priya can do. Meeting means she demonstrates the skills and understanding expected at her level consistently. Let me show you specific examples in her portfolio.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Acknowledge the gap and offer a bridge",
          "text": "\"You are right that this report does not give you what a CBSE report gives you. Let me be direct: Priya is one of the strongest students in this cohort. Here is what she can do, and here is what our graduates go on to do at university. Can I walk you through both?\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Unofficial Translation",
      "content": [
        "Mr. Sharma relaxes visibly. \"75-85%. That is more like it. So she is doing well.\"",
        "The conversation becomes easier. But two things happen afterward.",
        "First, Mr. Sharma shares the percentage equivalents with the parent WhatsApp group. Within a day, three other parents message you asking for the same breakdown.",
        "Second, your curriculum coordinator hears about it. \"If we start giving percentage translations, we are telling parents that our assessment system needs their system to be legible. We have just undone a year of work.\""
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Philosophy Explanation",
      "content": [
        "Mr. Sharma listens carefully. He nods at the portfolio examples. He asks good questions.",
        "But as the conversation ends, he says: \"I understand what you are telling me. I can see she is working hard. But when my wife asks me tonight — is Priya doing as well as Rohan? — I still will not have an answer for her.\"",
        "He is not rejecting your explanation. He is telling you it does not solve his problem. He needs to go home and report to his family in a language they understand. You have given him a philosophy lesson when he needed a translation."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Bridge Approach",
      "content": [
        "Mr. Sharma leans forward when you say \"one of the strongest.\" That is a data point he can use.",
        "When you show him university placement outcomes — where Banyan graduates went, what they studied, what their acceptance rates were — he starts writing notes.",
        "\"This is what we needed,\" he says. \"Not a percentage. But proof that this system produces results we can measure.\"",
        "You have not given him a rank. You have given him outcome data that answers the question behind the question: is this school worth the investment?"
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mr. Sharma''s View",
      "content": [
        "Mr. Sharma is not innumerate or narrow-minded. He is bilingual in assessment systems — and your school is only speaking one language.",
        "In CBSE culture, a number is not reductive. It is legible. It lets a parent compare their child to a known standard, communicate progress to extended family, and make decisions about tutoring, enrichment, or school change. Removing the number without replacing it with something equally concrete does not feel progressive to him. It feels opaque.",
        "His question — \"Is that what you mean?\" — is an invitation to translate. He is giving you a chance to make your system legible in his terms. If you refuse, he will translate it himself, and his translation may be less generous than yours."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What was the real question behind Mr. Sharma''s question?",
      "options": [
        "He wanted a percentage so he could compare Priya to her brother.",
        "He wanted proof that the school is academically serious.",
        "He wanted language he could take home to his wife and family.",
        "He was testing whether the teacher understood what he needed.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Follow-Up",
      "content": [
        "A week later, Mr. Sharma emails you. It is polite and specific:",
        "\"Dear Teacher, thank you for the conversation last week. My wife and I discussed it. We have two requests: (1) Could the school provide a subject-wise summary with some form of comparative indicator — even just Above/At/Below cohort average? (2) Could you share Priya''s standing in the class for mathematics specifically? She wants to pursue engineering and we need to know if she is competitive.\"",
        "You know other parents are asking similar questions. Your principal has said the school will not introduce ranking. But this parent is asking for something between a rank and a rubric."
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Escalate to leadership as a systemic issue",
          "text": "\"Mr. Sharma, I think your request speaks to something many families are feeling. I would like to bring this to our assessment coordinator — not just for Priya, but as a question about how we communicate progress to all families. Can I loop you in when we have a proposal?\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Give him what you can within the rules",
          "text": "\"I cannot share a class rank, but I can tell you that Priya''s mathematics work is consistently strong. She is well-prepared for the rigour of MYP and DP mathematics at higher level. I can also share our graduates'' university maths placement data.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Hold the line on school policy",
          "text": "\"I understand the request, but our school has a clear position: we do not provide comparative rankings or cohort positioning. I am happy to discuss Priya''s specific strengths and growth areas in mathematics at any time.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Systemic Response",
      "content": [
        "Mr. Sharma is surprised — and pleased — that his request is being taken seriously rather than deflected.",
        "\"Yes, please do. We are not trying to create problems. We just need the school to meet us halfway on how it talks about progress.\"",
        "You bring the request to your assessment coordinator. She is initially resistant, but when you frame it as a pattern across multiple families, she agrees to design a \"progress snapshot\" — a one-page summary per student that shows criterion levels alongside cohort distribution bands (without names). No ranking, but real context.",
        "It takes two months to implement. When it arrives, parent satisfaction in the next survey rises measurably."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Partial Answer",
      "content": [
        "Mr. Sharma reads your reply carefully. He thanks you for the university data.",
        "But he replies: \"This helps for the long term. For now, we are making decisions about whether to add a maths tutor for the ISCE preparation track. Without knowing where she is relative to peers, we are guessing.\"",
        "He is not wrong. Your answer gave him a destination without a map. He now knows where Banyan graduates end up, but not whether Priya is on that track today.",
        "The conversation is not closed. It is deferred."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Policy Wall",
      "content": [
        "Mr. Sharma replies briefly: \"Thank you, Teacher. Understood.\"",
        "The conversation ends. But a month later, you learn from a colleague that Mr. Sharma has been asking other parents whether their children''s teachers gave more specific feedback. He is not escalating formally. He is comparison-shopping informally.",
        "At the next parent information evening, three parents independently ask the principal the same question Mr. Sharma asked you. The principal is caught off guard.",
        "By holding the line individually, you pushed the pressure to a less prepared venue."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Structural View",
      "content": [
        "Mr. Sharma''s email was not an act of resistance. It was a product specification.",
        "He is telling you exactly what he needs: a signal that is concrete enough to make educational decisions (tutoring, stream selection, school continuation) and comparable enough to give his family confidence. The CBSE system provided this automatically. Your system has removed it without replacing it.",
        "The families asking for comparative data are not rejecting inquiry. They are asking for assessment legibility — the ability to read their child''s standing in terms that connect to the decisions they actually need to make."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "What would you do differently if you could redesign how your school communicates assessment to parents like Mr. Sharma?",
      "options": [
        "Add cohort context to reports without naming individual students.",
        "Create parent workshops that teach families how to read rubric-based reports.",
        "Provide university outcome data alongside every report cycle.",
        "Ask parents what information they need before designing the report format.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested your ability to translate between two assessment languages. Mr. Sharma was not asking you to abandon inquiry-based assessment. He was asking you to make it legible in the terms his family uses to make real decisions.",
            "The CBSE system produces a number that is immediately comparable. When IB schools remove that number, they remove a decision-making tool without always replacing it. The parent who asks ''what percentage is this?'' is not being reductive — they are asking for the data point your system has withheld."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The percentage question): Mr. Sharma''s core request — make the invisible visible.",
            "D2 (The credential ladder): His comparison of Priya to her CBSE brother reveals how families evaluate school systems in parallel.",
            "D6 (What actually works): University outcome data as the bridge between assessment philosophies."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Shankar, S. (2025). International Schools in India and the Emergence of a New School-to-University Pipeline. SAGE.",
            "CBSE grading norms: 91-100 = A1 (highest distinction), 81-90 = A2, below 33 = fail.",
            "Babu & Mahajan (2021). Branding an ''Inter''national school — the ''Indian values'' + global diploma ethnography."
          ]
        }
      ],
      "finalPrompt": "Think about the next parent who will sit across from you with a report they cannot read. What one change would you make to the conversation — or the report itself — before that meeting happens?"
    }
  }'::jsonb,
  ARRAY[1, 2, 6],
  15,
  2,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

----------------------------------------------------------------------
-- INDIA Scenario C: "Indian Values Week"
-- Culture-specific — parent subgroup pushes framing that centres one community
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'india-sim-c',
  'india-001',
  'Indian Values Week',
  'The parent committee wants a cultural celebration week. The proposed content centres one community''s identity. You notice. Now what?',
  'March at Banyan International School. The Parent-Teacher Association has proposed "Indian Values Week" — a five-day programme of assemblies, guest speakers, art displays, and a closing ceremony. The PTA committee of six parents has drafted a programme. You have been asked to review it as the Year 6 homeroom teacher whose class will host the opening assembly. Reading the draft, you notice a pattern. The guest speakers are drawn from one religious tradition. The "values" highlighted — puja, dharma, guru-shishya parampara — are Hindu-origin concepts presented as universally Indian. The art display features rangoli and diya-making. The food stalls list only vegetarian options from North Indian cuisine. None of this was done with malice. Mrs. Kulkarni, the PTA chair, has put genuine effort into the programme. But you teach students from Muslim, Christian, Sikh, Jain, and non-religious families. Two of your students are from Kerala Christian families. One is from a Kashmiri Muslim family. The programme as drafted would ask them to participate in a celebration of values that are not theirs, framed as everyone''s.',
  '[
    {"name": "You", "role": "Year 6 homeroom teacher, hosting the opening assembly", "description": "You are a non-Indian international hire. You have enough cultural awareness to notice the pattern, but you are not sure whether raising it will be heard as helpful or as an outsider overstepping."},
    {"name": "Mrs. Kulkarni", "role": "PTA chair, mother of a Year 5 student", "description": "She is warm, well-connected, and genuinely invested in the school community. She grew up in a Brahmin family in Pune. She does not think of the programme as exclusionary — she thinks of it as celebrating what she knows."},
    {"name": "Mr. Ansari", "role": "Father of a Year 6 student from a Kashmiri Muslim family", "description": "He has not seen the draft programme yet. He is active in school life but tends to raise concerns privately rather than in group settings."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Programme Draft",
      "content": [
        "March at Banyan International School. The PTA has proposed \"Indian Values Week.\"",
        "You have been asked to review the programme draft. Reading it, you notice a pattern.",
        "The guest speakers are drawn from one religious tradition. The values highlighted — puja, dharma, guru-shishya parampara — are Hindu-origin concepts presented as universally Indian.",
        "The art display features rangoli and diya-making. The food stalls list only vegetarian options from North Indian cuisine.",
        "Mrs. Kulkarni, the PTA chair, has put genuine effort into this. But you teach students from Muslim, Christian, Sikh, Jain, and non-religious families.",
        "The programme as drafted would ask them to participate in a celebration of values that are not theirs, framed as everyone''s."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: Raising the Concern",
      "content": ["You have a meeting with Mrs. Kulkarni to discuss logistics. Do you raise the representation issue?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Name it directly",
          "text": "\"Mrs. Kulkarni, I love the energy behind this. I want to flag something I noticed: the programme draws heavily from one tradition. I am wondering if we can broaden it so that families from other backgrounds see themselves in the week too.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Suggest additions without naming the gap",
          "text": "\"This is wonderful. Could we also include a Sufi poetry reading, a Kerala cooking demonstration, and maybe a Sikh langar tradition segment? It would show the full range of Indian culture.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Say nothing and let it proceed",
          "text": "You decide this is a parent-led initiative and it is not your place — as a non-Indian teacher — to tell Indian parents what counts as Indian values.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Direct Approach",
      "content": [
        "Mrs. Kulkarni pauses. Her expression shifts — not to anger, but to something closer to confusion.",
        "\"I did not think of it that way,\" she says slowly. \"These are values I grew up with. I suppose I assumed everyone recognises them as Indian.\"",
        "There is an awkward silence. Then she adds: \"But you may be right. Let me talk to the other committee members.\"",
        "Two days later she messages you: \"We are going to add a few segments. Thank you for the feedback.\" The programme expands — imperfectly, but meaningfully. A Muslim parent contributes a calligraphy demonstration. A Christian parent offers to speak about community service traditions in Kerala churches.",
        "Mrs. Kulkarni later tells another teacher: \"I was a little taken aback at first. But the week was better for it.\""
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Additive Approach",
      "content": [
        "Mrs. Kulkarni brightens. \"Those are lovely ideas! Let me see if we can fit them in.\"",
        "The additions are made. The programme now includes Sufi poetry and a Kerala cooking stall alongside the original content.",
        "But the framing does not change. The week is still called \"Indian Values Week.\" The opening assembly still centres dharma and guru-shishya parampara as the universal frame. The additions feel like appendices to a main text that was never revised.",
        "Mr. Ansari attends the opening assembly. Afterward, he messages you privately: \"I appreciated the effort. But it felt like my son''s tradition was added as a footnote to someone else''s definition of Indian.\""
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Silence",
      "content": [
        "The week proceeds as planned. It is colourful, well-attended, and warmly received by most families.",
        "Mr. Ansari does not attend. When you ask his son why, the boy says quietly: \"My dad said it is not really for us.\"",
        "No complaint is filed. No confrontation happens. But a family has quietly opted out of a school community event because the community it celebrated was not theirs.",
        "You find yourself wondering: was it really not your place? Or did you use cultural humility as a reason to avoid a hard conversation?"
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "What ''Indian Values'' Is Actually Doing",
      "content": [
        "The 2020 Tandfonline ethnography of a Bengaluru IB school found that ''Indian values'' language often functions as a class-and-caste signal. When schools use this phrase, they are frequently describing a forward-caste Hindu cultural ethos and presenting it as nationally universal.",
        "This is not usually deliberate exclusion. It is the default of a dominant group that does not experience its own culture as particular. For families outside that default — Muslim, Christian, Dalit, Adivasi, or simply from a different regional tradition — the signal is clear: this school''s version of Indian includes us politely but centres someone else.",
        "The teacher''s role is not to adjudicate what counts as Indian. It is to notice when a community event is unconsciously centring one group and to find a way to broaden it that respects everyone''s investment."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What made this decision hard for you?",
      "options": [
        "I was not sure if it was my place as a non-Indian to raise it.",
        "I did not want to offend a parent who was genuinely trying.",
        "I was not confident I understood the cultural dynamics well enough.",
        "I worried it would look like I was making a political statement.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Aftermath",
      "content": [
        "The week is over. Mr. Ansari requests a private meeting with you.",
        "\"Teacher, I want to say something carefully,\" he begins. \"My son felt uncomfortable during the opening assembly. He told me the values being celebrated were not his values. I do not want to make a formal complaint. But I want you to know that when the school says ''Indian values,'' some of us hear: ''not your India.''\"",
        "He looks at you steadily. \"I am not asking you to fix it now. I am asking: will someone remember this next year?\""
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Promise to advocate for change",
          "text": "\"Mr. Ansari, I hear you. I will bring this to the PTA planning process for next year and advocate for a framework that represents the full community. I cannot promise the outcome, but I can promise the conversation will happen.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Invite him to help shape next year''s programme",
          "text": "\"Would you be willing to join the planning committee next year? Your perspective would make the programme stronger. I will make sure there is space for it.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Acknowledge and document but do not commit",
          "text": "\"I appreciate you telling me this. I noticed some of the same things. I want to be honest: I am not sure how much influence I have over PTA programming, but I will make sure this feedback reaches the right people.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Advocacy Path",
      "content": [
        "Mr. Ansari nods. \"That is all I am asking.\"",
        "Over the summer, you draft a brief proposal for the principal: rename the event ''Cultures of India Week,'' require representation from at least three distinct traditions on the planning committee, and frame the values explored as plural rather than singular.",
        "The proposal is accepted. Mrs. Kulkarni, to her credit, supports it. \"I learned something last year,\" she says. The following year''s programme is meaningfully different.",
        "You did not fix it in the moment. You built a structure that prevents the same blindspot next time."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Invitation Path",
      "content": [
        "Mr. Ansari considers this. \"I will think about it. I am not always comfortable being the one who represents the other perspective. But if there is genuine space, yes.\"",
        "He joins the committee the following year. His presence changes the conversation — not because he objects to everything, but because the committee naturally considers a wider range when he is in the room.",
        "The risk: he carries a disproportionate burden of representation. The benefit: the programme becomes structurally more inclusive rather than depending on one teacher noticing a gap."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Honest Uncertainty",
      "content": [
        "Mr. Ansari looks at you for a long moment. \"I understand,\" he says. \"Thank you for listening.\"",
        "He leaves. The feedback does reach the principal — in your end-of-year reflection. But it arrives as one line in a document rather than a conversation with momentum.",
        "Next year, the programme is slightly adjusted but structurally unchanged. The same dynamic plays out with slightly different content.",
        "Your honesty was appreciated. But honesty without a follow-through plan is a holding pattern."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Inclusion Dynamic",
      "content": [
        "In Indian international schools, cultural celebration events are often sites where dominant-group norms get performed as universal. This is not malice — it is the invisible centre.",
        "For minority families, the signal is legible: the school celebrates India in a way that is someone else''s India. The response is usually quiet withdrawal, not confrontation.",
        "The teacher''s leverage is not in the moment of the event. It is in the planning process that precedes it and the structural changes that follow it."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "What is the difference between cultural sensitivity and structural inclusion?",
      "options": [
        "Sensitivity notices the problem. Inclusion changes the process so it does not recur.",
        "Sensitivity is about feelings. Inclusion is about who is in the room when decisions are made.",
        "Sensitivity is individual. Inclusion is institutional.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested whether you could identify an exclusion dynamic that was operating through celebration rather than restriction, and whether you could intervene without either overstepping or staying silent.",
            "The ''Indian values'' framing is a real pattern documented in ethnographic research. It functions as a class-and-caste signal that tells some families they belong and others that they are guests in someone else''s cultural space."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D4 (The ''Indian values'' signal): The core dynamic — cultural language that functions as community-belonging code.",
            "D3 (Reading the meeting): Mr. Ansari raised his concern privately, not publicly. Understanding why requires reading the communication norms.",
            "D6 (What actually works): Structural changes (committee composition, naming conventions) over one-off interventions."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Babu & Mahajan (2021). Branding an ''Inter''national school: Fusing ''Indian values'' with a global diploma. Tandfonline.",
            "Shankar, S. (2025). International Schools in India and the Emergence of a New School-to-University Pipeline. SAGE."
          ]
        }
      ],
      "finalPrompt": "Think about a cultural event at your school. Whose version of culture does it centre? Who is included as a participant but not as a designer? What would you change about the planning process?"
    }
  }'::jsonb,
  ARRAY[3, 4, 6],
  20,
  3,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

COMMIT;

BEGIN;

----------------------------------------------------------------------
-- KSA Scenario B: "The Comparison Request"
-- Assessment translation — father asks how daughter compares to top students
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'ksa-sim-b',
  'ksa-001',
  'The Comparison Request',
  'Mr. Al-Dosari wants to know where his daughter stands relative to the top students. He frames it as career planning. You hear ranking. He hears responsibility.',
  'April at Al-Noor International Academy in Jeddah. End-of-term conferences. Your school is one of the leading IB World Schools in the Western Province. Mr. Al-Dosari arrives exactly on time, wearing a thobe and carrying a leather folder. His daughter Noura is in Year 10, approaching her DP subject selections. She is academically capable but cautious — she produces consistently good work but rarely takes intellectual risks in class. Mr. Al-Dosari opens the folder and shows you a spreadsheet. He has listed Noura''s predicted grades, her cousin''s IGCSE results at another school, and the entry requirements for King Abdullah University of Science and Technology (KAUST). "I am not asking for gossip about other students," he says carefully. "I am asking whether Noura is competitive. If she is in the top quarter of her cohort for sciences, we continue on this path. If she is not, we need to consider alternatives — perhaps adding a tutor, perhaps changing schools." He looks at you directly. "You understand, this is a family decision that affects her next ten years."',
  '[
    {"name": "You", "role": "Year 10 science teacher and DP coordinator at Al-Noor International Academy", "description": "You have been in the Gulf for four years. You respect the directness of Saudi fathers in educational planning but find it difficult when their requests push against school assessment policy."},
    {"name": "Mr. Al-Dosari", "role": "Father of Noura, petroleum engineer", "description": "He is methodical, respectful, and direct. He has planned Noura''s educational trajectory since she was five. He chose an IB school because KAUST values international credentials, not because he rejects Saudi educational culture. His decisions are strategic, not emotional."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Conference",
      "content": [
        "April at Al-Noor International Academy, Jeddah. End-of-term conferences.",
        "Mr. Al-Dosari arrives with a leather folder containing a spreadsheet: Noura''s predicted grades, her cousin''s IGCSE results, and KAUST entry requirements.",
        "\"I am not asking for gossip about other students,\" he says. \"I am asking whether Noura is competitive. If she is in the top quarter for sciences, we continue. If not, we need alternatives — a tutor, perhaps a different school.\"",
        "He looks at you directly. \"This is a family decision that affects her next ten years.\""
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Ranking Request",
      "content": ["Mr. Al-Dosari is waiting. How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Provide contextual positioning without a rank",
          "text": "\"Mr. Al-Dosari, I cannot give you a class ranking. But I can tell you this: Noura''s predicted grades in chemistry and biology place her comfortably within the range that KAUST accepts. Our last three cohorts had a 40% acceptance rate to Gulf universities with STEM programmes. She is well within that profile.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Redirect to growth areas instead of position",
          "text": "\"I think the better question is not where Noura ranks but where she needs to grow. Her content knowledge is strong. What holds her back is her reluctance to take risks in experimental design and open-ended investigations. That is the gap between a good IB score and an excellent one.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Offer to connect him with the university counsellor",
          "text": "\"I think the person best placed to answer your question is our university counsellor. She has the admission data, the cohort statistics, and the relationships with Gulf universities. Can I set up a meeting for next week?\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Data Bridge",
      "content": [
        "Mr. Al-Dosari writes something in his folder. He nods slowly.",
        "\"Forty percent acceptance rate. That is useful. And you are saying she is within that group?\"",
        "\"Comfortably,\" you confirm.",
        "He closes the folder. \"Good. Then we continue. But I want to revisit this in January. If the predicted grades shift, I need to know immediately — not at the next scheduled conference.\"",
        "He has accepted your framing. But he has also established a monitoring relationship. You have bought trust, but it comes with accountability."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Growth Redirect",
      "content": [
        "Mr. Al-Dosari listens. Then he says, with measured patience:",
        "\"Teacher, I appreciate the educational perspective. But you are answering the question you want me to ask. I asked whether she is competitive. Growth is important, but it does not tell me whether we are on the right track or whether we need to change course.\"",
        "He is not being difficult. He is pointing out that you redirected a strategic question into a pedagogical one. For him, the two operate on different timescales. Growth is this semester. Competitiveness is this decade."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Referral",
      "content": [
        "Mr. Al-Dosari agrees to the meeting. But as he stands to leave, he says:",
        "\"I will meet the counsellor. But I also want to understand something. You are her teacher. You see her every day. You know whether she belongs at the top. I am asking because I trust your judgment, not because I want a bureaucratic referral.\"",
        "He is telling you that the referral felt like avoidance. He came to you because you are the person with ground truth. Sending him to another office, however practical, read as deflection."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mr. Al-Dosari''s View",
      "content": [
        "In Saudi professional culture, planning is serious and sequential. Mr. Al-Dosari is not helicopter parenting — he is project-managing his daughter''s future with the same discipline he applies to engineering projects.",
        "The 2024 Nature study on Saudi school selection found that families prioritise cultural and religious identity as the top factor, but competitive positioning is second. They chose international education because it opens doors. They expect the school to help them see whether those doors are actually opening.",
        "When he asks ''is she competitive?'' he is not asking you to rank her against her friends. He is asking whether the investment is tracking toward the outcome. If you cannot answer that question in terms he can act on, he will find someone who can."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What was your instinct when you heard the word ''competitive''?",
      "options": [
        "I wanted to redirect away from comparison.",
        "I recognised it as a legitimate planning question.",
        "I felt uncomfortable because I could not answer it within school policy.",
        "I assumed he was asking for something I should not provide.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The WhatsApp Follow-Up",
      "content": [
        "Two weeks later, you receive a WhatsApp message from Mr. Al-Dosari at 9:30pm:",
        "\"Teacher, I want to share something in confidence. My brother''s daughter is at [rival school]. She scored 42 in her predicted IB. My brother says their science programme is stronger. I trust Noura''s school, but I need you to help me understand: is a 38 predicted at Al-Noor equivalent to a 42 at [rival school]? Or are we behind?\"",
        "This is a comparison question layered inside a loyalty question. He is telling you he wants to stay, but he needs ammunition to justify it to his family."
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Answer the comparison honestly",
          "text": "\"Predicted grades vary by school. A 38 at Al-Noor with our moderation standards is strong and credible. I cannot speak to another school''s predictions, but I can tell you that our DP results have been within 1-2 points of predictions consistently. Noura is on track.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Redirect to outcomes rather than predictions",
          "text": "\"Mr. Al-Dosari, predicted grades are internal tools — they are not standardised across schools. What I can share is where our graduates are now: KAUST, King Fahd, UCL, Edinburgh. The outcome data is more reliable than comparing predictions between two different schools.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Set a boundary on the channel",
          "text": "\"I appreciate your trust, but I think this conversation deserves a proper meeting rather than a late-night message. Can we schedule a call with the DP coordinator this week? I want to give you a thorough answer.\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Honest Comparison",
      "content": [
        "Mr. Al-Dosari replies quickly: \"Thank you. This is what I needed. I will tell my brother that Al-Noor''s predictions are conservative and reliable.\"",
        "You have given him a talking point for a family conversation. He is not just a parent managing his daughter''s education — he is a family member defending a school choice to relatives who are watching.",
        "The relationship deepens. He messages you less frequently after this, not more. The trust question has been answered."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Outcomes Redirect",
      "content": [
        "Mr. Al-Dosari reads the message. His reply is brief: \"Good universities. But my brother will ask about the number. In our family, the number is the conversation.\"",
        "He is telling you that outcome data works for him, but it does not work for the audience he has to convince. His brother will not research university placement rates. His brother will compare two numbers.",
        "You have given the right answer to the wrong audience."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Boundary",
      "content": [
        "Mr. Al-Dosari apologises for the late hour. The meeting is scheduled.",
        "It goes well — the DP coordinator provides detailed outcome data and moderation context. Mr. Al-Dosari leaves satisfied.",
        "But you notice he does not message you again for the rest of the term. The boundary was appropriate but it slightly cooled a channel that had been building trust. In Gulf professional culture, personal accessibility signals respect. Redirecting to a formal meeting, while correct, may have felt like a step back in the relationship."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Family Decision Layer",
      "content": [
        "In Saudi families, educational decisions are often collective. Mr. Al-Dosari is not making this decision alone — he is making it in front of his brother, his parents, and his wife''s family. Each of them has an opinion about whether the school is good enough.",
        "When he asks you for data, he is asking for ammunition. He needs to defend his choice in a family conversation where the competing school has a higher number. Your job is not just to educate Noura. It is to give her father the language to justify keeping her where she is.",
        "This is the selection paradox in action: he chose you, and he needs you to help him keep choosing you."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "What does Mr. Al-Dosari actually need from you?",
      "options": [
        "Data he can use in a family conversation.",
        "Confidence that the investment is tracking toward the outcome.",
        "A relationship where he can ask hard questions without being redirected.",
        "Proof that your school''s assessment is credible even without ranking.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested your ability to recognise that a Saudi father''s request for competitive positioning is a planning question, not a ranking obsession. Mr. Al-Dosari is operating in a context where educational investment is a family project with collective accountability.",
            "The selection paradox means he chose IB because it opens doors, but he needs the school to prove — repeatedly — that those doors are actually opening."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The selection paradox): He chose you AND needs you to justify the choice to his family.",
            "D5 (Communication norms): The late-night WhatsApp is a trust signal, not a boundary violation — in Gulf professional culture, personal accessibility conveys respect.",
            "D6 (What actually works): University outcome data as the credible bridge between assessment philosophies."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Nature — Humanities and Social Sciences Communications (2024). School selection factors in Saudi Arabia: cultural/religious identity as primary, competitive positioning as secondary.",
            "Hammad & Shah (2018). Communication norms in Gulf educational contexts."
          ]
        }
      ],
      "finalPrompt": "Think about the next parent who asks you whether their child is ''competitive.'' What information would you prepare in advance so you can answer the real question — not with a rank, but with data that lets them make the decision they need to make?"
    }
  }'::jsonb,
  ARRAY[1, 5, 6],
  18,
  2,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

----------------------------------------------------------------------
-- KSA Scenario C: "Student Leadership"
-- Culture-specific — parent worried school teaches child to challenge adult authority
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'ksa-sim-c',
  'ksa-001',
  'Student Leadership',
  'Mrs. Al-Harbi is troubled after a class discussion on student leadership. She worries the school is teaching her son to challenge adult authority. She is polite. She is also serious.',
  'October at Al-Noor International Academy. You have just finished a unit on student leadership in your MYP Individuals & Societies class. Students designed proposals for improving the school community — peer mentoring, environmental initiatives, student council restructuring. Your Year 9 student, Fahad, presented a proposal arguing that students should have a vote on school uniform policy. His presentation was confident and well-structured. His mother, Mrs. Al-Harbi, requests a meeting the following day. She arrives wearing an abaya, greets you warmly, and begins: "Teacher, Fahad came home very excited about his project. He said he argued that students should challenge school rules they disagree with. I want to understand what you are teaching. In our family, we teach our children to respect authority — parents, teachers, elders. Is the school teaching him something different?"',
  '[
    {"name": "You", "role": "MYP Individuals & Societies teacher, Year 9", "description": "You are committed to student agency and voice as IB pedagogical principles. You also understand that you are working in a cultural context where authority structures have different weight."},
    {"name": "Mrs. Al-Harbi", "role": "Mother of Fahad, homemaker with a degree in Islamic Studies", "description": "She is articulate, composed, and deeply invested in her son''s moral education. She chose an international school for the English and the opportunities, not to replace her family''s value system. She is not hostile — she is concerned."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Meeting",
      "content": [
        "October at Al-Noor International Academy. You have just finished a unit on student leadership.",
        "Fahad presented a proposal arguing students should have a vote on school uniform policy. His presentation was confident and well-structured.",
        "Mrs. Al-Harbi requests a meeting the next day.",
        "\"Fahad came home very excited,\" she begins. \"He said he argued that students should challenge school rules they disagree with.\"",
        "She pauses. \"In our family, we teach our children to respect authority — parents, teachers, elders. Is the school teaching him something different?\""
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: Responding to the Concern",
      "content": ["Mrs. Al-Harbi is waiting. How do you frame your response?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Defend the pedagogy",
          "text": "\"Mrs. Al-Harbi, student voice is a core part of the IB framework. We teach students to think critically, question assumptions, and advocate for change through respectful dialogue. That is not the same as challenging authority — it is learning to participate responsibly in a community.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Acknowledge the tension directly",
          "text": "\"I hear your concern, and I think you are naming something real. The word ''leadership'' in our curriculum can sound like ''challenge authority'' when it reaches home. What we are actually teaching is how to propose improvements through proper channels — which is closer to shura than to rebellion. But I understand why it landed differently.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Minimise the concern",
          "text": "\"I think Fahad may have exaggerated what happened. He was not arguing against authority. He was practising presentation skills with a hypothetical scenario. It was really just an exercise.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Pedagogical Defence",
      "content": [
        "Mrs. Al-Harbi listens carefully. She does not interrupt.",
        "When you finish, she says: \"I understand that this is your educational philosophy. But I need you to understand mine. In our tradition, a child learns wisdom by listening to those who have it, not by practising how to question them. I am not saying your approach is wrong. I am saying it creates a conflict in my home that I have to manage.\"",
        "She is not rejecting IB. She is telling you that your pedagogy has downstream effects in her household that you have not considered. The gap is not between right and wrong — it is between two legitimate authority structures."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Bridge Frame",
      "content": [
        "Mrs. Al-Harbi''s expression changes. The word ''shura'' lands.",
        "\"Yes,\" she says. \"Shura is exactly what I would want for him. To learn how to contribute to a community respectfully, not to learn that his opinion is as valid as his teacher''s simply because he can articulate it.\"",
        "The conversation shifts. She begins asking specific questions: How is participation graded? Is there a way to frame leadership as service rather than advocacy? Can she see the assessment criteria?",
        "She has not abandoned her concern. But you have given her a frame that connects your pedagogy to a principle she already values. The conversation becomes collaborative rather than adversarial."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Minimisation",
      "content": [
        "Mrs. Al-Harbi''s expression hardens slightly.",
        "\"Teacher, my son does not exaggerate. He told me exactly what happened. He said he argued his position in front of the class and was praised for it. If it was just an exercise, why was he graded on how persuasive he was?\"",
        "She is right. You graded the presentation on argumentation and persuasion. Telling her it was hypothetical does not change the fact that the skill being assessed was the ability to challenge a position convincingly.",
        "You have now lost ground. She feels dismissed, and the next part of the conversation will be harder."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Al-Harbi''s View",
      "content": [
        "Mrs. Al-Harbi is not anti-education or anti-modernity. She is navigating the selection paradox: she chose an international school for the English, the credentials, and the future opportunities. She did not choose it to have her family''s authority structure undermined.",
        "In Islamic educational tradition, knowledge and wisdom are transmitted through relationships of respect and guidance. A student who questions a teacher is not seen as intellectually brave — they may be seen as lacking adab (proper conduct).",
        "''Student voice'' and ''critical thinking'' as IB pedagogical values can sound, when they reach home, like the school is teaching children that their opinions are equal to their parents''. That is not what you intend. But it is what she hears.",
        "The Alfaraidy research found that families who chose international schools in Saudi Arabia overwhelmingly wanted their children to develop confidence and English fluency — but within a moral and cultural framework that the family, not the school, defines."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What was your instinct when you heard ''Is the school teaching him something different?''",
      "options": [
        "I wanted to defend the IB approach because I believe in it.",
        "I felt accused and wanted to clarify what actually happened.",
        "I recognised this as a legitimate concern from a different value system.",
        "I was unsure how to hold both the pedagogy and the parent''s values.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Fahad''s Next Unit",
      "content": [
        "The next MYP unit is ''Ethics and Global Engagement.'' Students will debate real-world ethical dilemmas, including topics like environmental regulation, digital privacy, and gender-based policy differences across cultures.",
        "You know Fahad will be engaged. You also know that some of these topics will generate conversations at home that may concern Mrs. Al-Harbi further.",
        "Do you adjust your approach?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Send a pre-unit parent communication",
          "text": "You draft a letter to all Year 9 parents explaining the upcoming unit, its learning objectives, and how students will engage with sensitive topics. You include the assessment criteria and invite parents to discuss any concerns.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Have a private conversation with Mrs. Al-Harbi",
          "text": "You message Mrs. Al-Harbi directly: \"The next unit covers ethical dilemmas. I wanted to give you a heads-up and ask if there are topics where you would like me to be particularly thoughtful about framing. I want Fahad to be fully engaged without creating friction at home.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Teach the unit as planned",
          "text": "You decide that adjusting the curriculum for one parent''s concerns would compromise the integrity of the programme. You teach the unit as designed.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Proactive Communication",
      "content": [
        "Several parents respond positively. Mrs. Al-Harbi writes back: \"Thank you for this. It helps to know what is coming. I have no objections to the topics, but I appreciate being informed.\"",
        "The unit proceeds smoothly. When Fahad comes home talking about digital privacy, his mother can contextualise it because she has seen the framework.",
        "You have not changed the curriculum. You have changed the information architecture around it. The parent is no longer surprised by what their child brings home."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Personal Outreach",
      "content": [
        "Mrs. Al-Harbi is touched by the message. She replies: \"Teacher, thank you for this respect. I do not want to censor what he learns. But some topics — like gender policy — I would prefer to discuss with him at home before he forms an opinion in class. Could you let me know when that topic is scheduled?\"",
        "You agree. The unit proceeds with Mrs. Al-Harbi as an informed partner rather than a surprised bystander.",
        "The risk: other parents may feel excluded if they learn you gave one family advance notice. The benefit: you have built a trust channel that prevents escalation."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Unchanged Approach",
      "content": [
        "The unit goes well academically. Fahad is engaged and articulate.",
        "Three weeks in, Mrs. Al-Harbi requests another meeting. This time, she brings her husband.",
        "\"We are not asking you to change the curriculum,\" Mr. Al-Harbi says. \"We are asking why we were not told. Our son came home arguing that gender segregation in schools is outdated. He said his teacher said there is no right answer. In our home, there is a right answer. We needed to be part of that conversation.\"",
        "The issue is not the content. It is the lack of forewarning. They feel blindsided, and the school now has a formal concern to manage."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Authority Negotiation",
      "content": [
        "Saudi families who choose international schools are not surrendering their moral authority to the school. They are extending a conditional trust: we will let you teach our children critical thinking, as long as we remain the primary moral frame.",
        "Vision 2030 has accelerated this tension. The state is pushing female workforce participation, English competence, and global credentials. Families are navigating what modernity means for them — not in the abstract, but in their living rooms, when their child comes home with a new idea.",
        "The teacher who sees this as resistance is missing the point. The parent is not opposed to the lesson. They are opposed to losing control of the moral conversation. Proactive communication — telling parents what is coming and inviting them to be part of the framing — is not a compromise of pedagogical integrity. It is a recognition that education in this context is a partnership between two authority structures."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "How do you hold student voice and parental authority at the same time?",
      "options": [
        "Teach the content fully but communicate proactively with families about sensitive topics.",
        "Frame leadership and voice within cultural values the family already holds (shura, adab, service).",
        "Accept that some tension is inherent and focus on maintaining the relationship through transparency.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested your ability to hold two legitimate authority structures — IB pedagogy and Saudi family values — without collapsing one into the other.",
            "Mrs. Al-Harbi was not asking you to stop teaching critical thinking. She was asking you to recognise that your classroom is not the only place where her son learns what is right."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The selection paradox): She chose the school AND wants to keep her authority over moral formation.",
            "D2 (Religious and cultural identity): ''Student voice'' pedagogy signals threat to structures the family depends on.",
            "D4 (Vision 2030): The broader social tension between modernisation and tradition plays out in her living room."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Nature — Humanities and Social Sciences Communications (2024). Saudi parents rank cultural/religious identity as the primary school selection factor.",
            "Alfaraidy, M. Gender and education in Saudi Arabia: segregation preferences and the role of authority.",
            "Hammad & Shah (2018). Communication and authority in Gulf educational contexts."
          ]
        }
      ],
      "finalPrompt": "Think about your next unit that touches on values, ethics, or authority. What would you communicate to families before the unit begins — and how would you frame it so they see partnership, not replacement?"
    }
  }'::jsonb,
  ARRAY[1, 2, 4],
  20,
  3,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

COMMIT;

BEGIN;

----------------------------------------------------------------------
-- KOREA Scenario B: "The Hagwon Report Card"
-- Assessment translation — mother shows hagwon scores, asks why school tells different story
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'korea-sim-b',
  'korea-001',
  'The Hagwon Report Card',
  'Mrs. Park shows you her son''s hagwon test scores. They say top 8%. Your report says "Developing." She wants to know which one is lying.',
  'December at Hana International School, Pangyo. Mid-year conferences. Mrs. Park arrives with two documents: your school''s narrative report for her son Minjun, and a printout from his hagwon (private academy). The hagwon report shows national percentile rankings: top 8% in mathematics, top 12% in English. Your report describes Minjun as "Developing" in mathematical reasoning, with a note about his reluctance to show working and his difficulty with extended problem-solving tasks. Mrs. Park places both documents on the table side by side. "Teacher, please help me understand," she says. "His hagwon teacher says he is in the top 8%. Your school says Developing. One of these is wrong. Which one?"',
  '[
    {"name": "You", "role": "Year 7 mathematics teacher at Hana International School", "description": "You have been in Korea for two years. You understand the hagwon system exists and that most of your students attend one. You believe your school''s assessment is measuring something the hagwon does not — but you also know that ''Developing'' sounds like failure to a Korean parent."},
    {"name": "Mrs. Park", "role": "Mother of Minjun, former high school maths teacher turned full-time educational manager", "description": "She gave up her teaching career to manage her two children''s education. She schedules their hagwon, monitors their scores, and adjusts their study plans quarterly. She is not emotional — she is systematic. She has data, and your data contradicts hers."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Two Report Cards",
      "content": [
        "December at Hana International School, Pangyo. Mid-year conferences.",
        "Mrs. Park arrives with two documents: your narrative report and a hagwon printout.",
        "The hagwon report: top 8% in mathematics nationally, top 12% in English.",
        "Your report: Minjun is \"Developing\" in mathematical reasoning. Note about reluctance to show working and difficulty with extended problem-solving.",
        "She places both documents side by side.",
        "\"Teacher, please help me understand. His hagwon says top 8%. Your school says Developing. One of these is wrong. Which one?\""
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: Two Systems",
      "content": ["Mrs. Park is waiting with both reports in front of her. How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Explain that they measure different things",
          "text": "\"Neither report is wrong, Mrs. Park. They are measuring different skills. The hagwon tests procedural fluency — can Minjun solve this type of problem quickly and accurately? Our assessment measures reasoning — can he explain why a method works, apply it to an unfamiliar context, and show his thinking? He is excellent at the first. He is still developing the second.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Validate the hagwon data and reframe yours",
          "text": "\"Minjun''s hagwon scores are impressive, and they reflect real skill. What our report is saying is that there is an additional layer — reasoning and problem-solving — where he has room to grow. ''Developing'' does not mean he is weak. It means we see potential that has not been fully activated yet.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Challenge the hagwon assessment",
          "text": "\"Mrs. Park, I want to be direct. Hagwon tests are designed to make students look successful — that is their business model. Our assessment is designed to identify what students actually need. The gap is not a contradiction. It is the difference between a test that confirms and an assessment that reveals.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Two-Skills Frame",
      "content": [
        "Mrs. Park listens carefully. She writes something on her notepad.",
        "\"So you are saying the hagwon is teaching him to perform, and your school is trying to teach him to think.\"",
        "\"That is a fair summary,\" you say.",
        "She pauses. \"Then why does your report not say that? It says ''Developing'' with no context. Any Korean parent reading this will think their child is failing. If you mean ''strong at computation, growing in reasoning,'' say that.\"",
        "She is right. Your report language was designed for an audience that reads ''Developing'' as a growth stage. She reads it as a grade — and in the only grading system she knows, it is a bad one."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Reframe",
      "content": [
        "Mrs. Park relaxes slightly when you validate the hagwon data. She did not expect that.",
        "\"So you are not dismissing his scores?\"",
        "\"Not at all. Those scores show discipline and accuracy. What we are adding is a different kind of challenge.\"",
        "She nods slowly. \"I can work with that. But I need you to be specific. What does ''developing reasoning'' look like? What should he practise at home?\"",
        "She is offering you a partnership. She manages his study schedule with precision. If you give her a concrete target, she will build it into the plan. If you stay abstract, she will defer to the system that gives her numbers."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Challenge",
      "content": [
        "Mrs. Park''s expression does not change, but her posture does. She sits back.",
        "\"Teacher, I was a maths teacher for eight years before I had children. I know what a well-designed test looks like. Minjun''s hagwon uses nationally standardised items. I am not asking you to validate their business model. I am asking you to explain why your assessment contradicts data that I have reason to trust.\"",
        "You have underestimated her. She is not a naive consumer of hagwon marketing. She is a trained professional comparing two data sources. By dismissing one, you have made it harder for her to trust the other."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Park''s View",
      "content": [
        "Mrs. Park is not confused. She is cross-referencing.",
        "In Korea, the parent — especially the mother — is the educational manager. She does not just monitor progress; she engineers it. She selects hagwon, adjusts study plans, and benchmarks outcomes across multiple data sources. This is not helicopter parenting. It is a culturally rational response to a system where a single exam (the Suneung) determines university placement and, by extension, career trajectory.",
        "When your report says ''Developing'' without context, she reads it through the only scale she has: national percentiles. In that scale, Developing is in the bottom third. You mean it as a growth descriptor. She hears it as a verdict.",
        "The gap is not between good assessment and bad assessment. It is between two assessment languages that have never been translated for each other."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "When you saw the hagwon report, what was your first reaction?",
      "options": [
        "I wanted to explain why our assessment is better.",
        "I felt defensive because the data contradicted my report.",
        "I recognised that she has a valid second data source.",
        "I thought the hagwon scores were inflated.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Minjun''s Behaviour Change",
      "content": [
        "January. Minjun''s behaviour in class shifts.",
        "He begins asking, before every task: \"Is this for the report?\" If the answer is no, he disengages. If yes, he produces meticulous work with correct answers but no visible thinking process.",
        "You also notice he has started bringing a hagwon workbook to school. During free study periods, he works through it rather than engaging with your class extension tasks.",
        "At lunch, another student tells you: \"Minjun''s mum added two more hagwon sessions per week. He is there until 10pm on Tuesdays and Thursdays now.\"",
        "You suspect that the conference, rather than building a bridge, triggered an intensification of the parallel system."
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Talk to Minjun directly",
          "text": "\"Minjun, I have noticed you are working on hagwon materials during free study. Can we talk about that? I want to understand how you are balancing your workload.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Contact Mrs. Park about the increased load",
          "text": "You message Mrs. Park: \"I wanted to check in. Minjun seems more tired recently, and I have noticed his engagement in class-based tasks has shifted. Is there anything I should know about his schedule outside school?\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Adjust your classroom approach",
          "text": "You redesign your extension tasks to be more structured — clear success criteria, visible skill progression, concrete feedback that Minjun can add to his study plan. You meet the student where he is rather than insisting he meet you where you are.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Talking to the Student",
      "content": [
        "Minjun is polite but guarded. \"My mum wants me to be ready for the DP. She says your school grades differently from the rest of Korea, so I need to be strong in both systems.\"",
        "He is not rebelling. He is executing his mother''s strategy. The dual system — school for reasoning, hagwon for speed and ranking — is his normal. He does not experience it as contradictory. He experiences it as thorough.",
        "You realise that talking to Minjun will not change the dynamic. The decision-maker is Mrs. Park, and she has already decided."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Parent Check-In",
      "content": [
        "Mrs. Park replies promptly: \"Thank you for noticing, Teacher. Yes, we added sessions. After our conference, I realised that Minjun needs to strengthen his reasoning — as you said — but he also cannot afford to lose his procedural edge. The extra sessions cover both.\"",
        "She has taken your feedback and integrated it into her system — but her system includes the hagwon as a permanent feature, not a temporary supplement. She is not ignoring you. She is adding your assessment to a larger data model.",
        "The question is not whether she listens. It is whether you can influence the model she is building."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Classroom Adjustment",
      "content": [
        "The restructured tasks work. Minjun engages more when he can see the success criteria and track his progress. His reasoning improves — not because the task is easier, but because the pathway is visible.",
        "Mrs. Park notices. In February, she messages you: \"Minjun says he understands what you want now. He said the new tasks make sense to him.\"",
        "She adds: \"I reduced one hagwon session. If your school can show me he is progressing in reasoning, I do not need the hagwon to cover it.\"",
        "You did not ask her to reduce hagwon. You made your system legible enough that she voluntarily adjusted hers."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Parallel System",
      "content": [
        "The hagwon is not going away. In Korea, private tutoring is a $20 billion industry. Over 78% of students attend at least one hagwon. For parents like Mrs. Park, it is not an alternative to school — it is a complement, a hedge, and a quality-control mechanism.",
        "When an international school tells Korean parents that their assessment is better or more meaningful than hagwon data, the parent does not stop using hagwon. They stop trusting the school''s assessment.",
        "The productive move is not to compete with the hagwon but to make your assessment legible within the parent''s decision framework. If she can see what your assessment measures and how it maps to outcomes she cares about, she will integrate it. If she cannot, she will default to the system that gives her numbers."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "What would you change about how your school communicates assessment to Korean families?",
      "options": [
        "Translate report language so ''Developing'' does not read as failure.",
        "Include visible skill progressions that show movement over time.",
        "Acknowledge the hagwon data as a valid second source rather than competing with it.",
        "Provide outcome data (university, DP scores) alongside formative reports.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested your ability to work alongside a parallel assessment system rather than against it. Mrs. Park is not rejecting your school. She is operating a dual-system strategy that she will not abandon because you asked her to.",
            "The productive question is not ''how do I get her to trust my assessment instead?'' It is ''how do I make my assessment legible enough that she incorporates it into her decision model?''"
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The zero-sum structure): The Suneung creates the context where dual systems feel necessary.",
            "D3 (Institutional context): The hagwon is not a pathology — it is a $20B institutional reality.",
            "D4 (What parents are actually expressing): Mrs. Park''s intensity is investment anxiety with a data-driven methodology."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Korean Institute for Curriculum and Evaluation: 78.3% hagwon participation rate.",
            "Bong, M. (2008). Achievement motivation in the Korean educational system.",
            "Yang, Kim, et al. (2017). Private tutoring spending and academic outcomes in Korea."
          ]
        }
      ],
      "finalPrompt": "Your next report goes out in three months. What would you add to the report format — not the content, but the communication design — so that a parent with hagwon data can read your assessment without needing a translation meeting?"
    }
  }'::jsonb,
  ARRAY[1, 3, 4],
  18,
  2,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

----------------------------------------------------------------------
-- KOREA Scenario C: "Project Week"
-- Culture-specific — test week replaced by project week, parent backlash
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'korea-sim-c',
  'korea-001',
  'Project Week',
  'Your school replaced mid-year exams with a project week. Korean parents are pushing back. The loudest voice belongs to a father who used to trust you.',
  'January at Hana International School. The school has announced that the traditional mid-year exam block is being replaced with an interdisciplinary project week. Students will work in teams on a real-world problem, present their findings to a panel, and receive formative feedback rather than grades. The decision was made by the curriculum committee over the summer. Parents were informed in September. Most international families are supportive. The Korean parent community is not. Mr. Choi, father of your Year 9 student Jiwon, has been the most vocal. He is a lawyer and a member of the school''s parent advisory board. He sends a measured but pointed email to the principal, CC-ing you: "We chose this school because it promised both IB rigour and structures that Korean families recognise as serious. Replacing examinations with group projects sends a signal that the school does not value individual academic achievement. My daughter has been preparing for these exams. I need to understand: what is the school''s evidence that project-based assessment produces better outcomes than examinations?" The principal asks you — as Year 9 coordinator — to respond.',
  '[
    {"name": "You", "role": "Year 9 coordinator and humanities teacher", "description": "You supported the project week decision. You believe it is pedagogically sound. But you also know that in Korea, exams are the primary trust signal for academic seriousness, and you have just removed them."},
    {"name": "Mr. Choi", "role": "Father of Jiwon, corporate lawyer", "description": "He is analytical, articulate, and expects evidence-based reasoning. He is not hostile to the school — he sits on the advisory board. His email is a formal challenge, not a complaint. He wants data."},
    {"name": "Jiwon", "role": "Year 9 student", "description": "She is high-achieving and anxious. She prepared extensively for the exams and is confused by the change. She told her father she feels like her preparation was wasted."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Email",
      "content": [
        "January at Hana International School. Mid-year exams have been replaced with an interdisciplinary project week.",
        "Mr. Choi, a lawyer and parent advisory board member, sends a formal email to the principal, CC-ing you:",
        "\"We chose this school because it promised both IB rigour and structures that Korean families recognise as serious. Replacing examinations with group projects sends a signal that the school does not value individual academic achievement.\"",
        "\"My daughter has been preparing for these exams. I need to understand: what is the school''s evidence that project-based assessment produces better outcomes than examinations?\"",
        "The principal asks you to respond as Year 9 coordinator."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Response",
      "content": ["How do you respond to Mr. Choi''s email?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Share the research evidence",
          "text": "You compile research on project-based learning outcomes: critical thinking gains, collaborative skills, university readiness. You send a detailed response with citations and an invitation to discuss further.",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Acknowledge the concern and offer a compromise",
          "text": "\"Mr. Choi, your point about individual assessment is well taken. The project week is not replacing examinations permanently — it is adding a complementary assessment mode. Students will still receive individual criterion-based grades for their contributions. I would like to meet to show you the individual assessment rubric and discuss how Jiwon''s exam preparation skills transfer directly to this format.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Invite him to observe the project week",
          "text": "\"Mr. Choi, I think the best response is to show rather than tell. Would you be willing to attend the final presentations as an observer — or even as a panel member? I believe that seeing the rigour of the process will address your concerns more effectively than any email.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Research Response",
      "content": [
        "Mr. Choi reads your email carefully. He replies within the hour — point by point.",
        "\"Thank you for the research. I have two observations. First, the studies you cite measure ''critical thinking gains'' in Western educational contexts. My daughter does not need to develop critical thinking for a Western job market — she needs to be competitive for Korean and international university admissions where exam performance is a gating criterion.\"",
        "\"Second, none of these studies address the question I asked: does this produce better outcomes? Better than what? Better for whom?\"",
        "He is a lawyer. He has read your evidence and found it unresponsive to his actual question. You sent research about learning. He asked about outcomes."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Compromise Frame",
      "content": [
        "Mr. Choi agrees to the meeting. When he sees the individual assessment rubric, he relaxes visibly.",
        "\"This is what I needed,\" he says. \"If Jiwon is being assessed individually with clear criteria, that is different from what I understood. The email from the school made it sound like exams were being replaced with group work and feelings.\"",
        "He pauses. \"The communication was the problem, not the decision. When you tell Korean parents that exams are gone, they hear that rigour is gone. You need to lead with what replaces it, not with what you are removing.\"",
        "He leaves the meeting as an ally. He even offers to explain the format to other Korean parents on the advisory board."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Observation Invite",
      "content": [
        "Mr. Choi accepts. He attends the final presentations as a panel member.",
        "Halfway through the second presentation, he leans over and says quietly: \"This is much more rigorous than I expected. The students are being questioned by experts. This is harder than an exam.\"",
        "After the event, he sends an email to the parent advisory board: \"I was sceptical. I was wrong. The project week is serious academic work. I recommend other parents observe next year.\"",
        "The risk was real — if the presentations had been weak, you would have confirmed every fear. But they were strong, and Mr. Choi became your most credible advocate because he arrived as a sceptic."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mr. Choi''s View",
      "content": [
        "Mr. Choi is not opposed to innovation. He is opposed to risk without evidence.",
        "In the Korean educational context, examinations are not just assessment tools — they are trust signals. They tell parents that the school is serious, that standards exist, and that individual achievement is visible. When you remove exams, you remove the signal. The replacement must be at least as legible, or parents will interpret the change as a reduction in standards.",
        "Mr. Choi''s email was not a complaint. It was a quality-assurance audit from a stakeholder who believes in the institution but needs evidence that a major change is sound. Responding with philosophy when he asked for data will lose him. Responding with visible rigour will win him."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "When you read Mr. Choi''s email, what was your first instinct?",
      "options": [
        "I wanted to defend the project week because I believe in it.",
        "I felt frustrated that a parent was questioning a professional decision.",
        "I recognised his question as legitimate and data-driven.",
        "I worried that other Korean parents would join him.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Jiwon''s Distress",
      "content": [
        "During project week, Jiwon struggles. Not academically — she is capable. But she is visibly distressed.",
        "Her team assigned her the research role because she is \"the smart one.\" She did all the research, wrote the script, and prepared the presentation slides. Her teammates contributed less. When you ask about the team dynamic, she says: \"It is fine. I do not mind doing more work.\"",
        "But her homeroom teacher tells you that Jiwon cried in the bathroom after school. She told a friend: \"I studied for months for exams and now it does not count. I did all the work in the group and they will get the same grade. What was the point?\"",
        "The project week is going well overall. But for Jiwon — a student who thrived under the exam system — the format change feels like a betrayal."
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Address the team dynamic and reassure her individually",
          "text": "You pull Jiwon aside. \"I know this format is different from what you prepared for. I want you to know that your individual contribution is visible and will be assessed separately. You will not be penalised for carrying the team. And your exam preparation skills — research, organisation, precision — are exactly what made you so strong in this project.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Restructure the team assessment in real time",
          "text": "You add an individual reflection component to the project: each student submits a one-page analysis of their own contribution, what they learned, and what they would change. This makes individual effort visible without dismantling the team structure.",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Let it play out as a learning experience",
          "text": "You decide that learning to navigate team dynamics — including carrying unequal loads — is part of the project week''s value. Jiwon is uncomfortable, but discomfort is part of growth.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Individual Reassurance",
      "content": [
        "Jiwon''s shoulders drop slightly. \"Thank you, Teacher. I was worried it would not matter how much I did.\"",
        "She finishes the project week with renewed focus. Her individual assessment is strong.",
        "But the underlying dynamic is unchanged: Jiwon treated the project as an exam in disguise — she optimised for the grade, not the collaboration. She learned that hard work pays off. She did not learn how to share the work.",
        "You addressed the symptom (her distress) without addressing the pattern (her relationship with assessment as the only form of visible achievement)."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Structural Fix",
      "content": [
        "The individual reflection component works. Jiwon writes a precise, honest analysis. She notes that she \"found it difficult to delegate because I was not confident the work would meet the standard I set for myself.\"",
        "Other students'' reflections are revealing too. One teammate writes: \"Jiwon did most of the work because she started before we agreed on the plan. I wanted to contribute but I did not know where.\"",
        "The reflections give you data you did not have before: the team dynamic was not laziness on one side and diligence on the other. It was a collision between two working styles — one driven by individual excellence and another driven by consensus-building.",
        "You share the reflections (anonymised) with the team. The debrief becomes the most valuable learning moment of the week."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Growth Argument",
      "content": [
        "Jiwon finishes the week. Her presentation is polished. The project is well-received.",
        "But in the following weeks, something shifts. She becomes more withdrawn in class. She stops volunteering answers. When you assign group work, she does it silently and efficiently but without engagement.",
        "Her homeroom teacher reports that Jiwon told her parents she \"does not trust the school to value her work.\" Mr. Choi does not send another email. He does something quieter: he starts researching other schools.",
        "You preserved the pedagogical principle. You may have lost the student."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "What Jiwon Was Carrying",
      "content": [
        "Jiwon is not fragile. She is the product of a system that taught her one rule: preparation plus performance equals recognition. She followed that rule perfectly — and then the school changed the game.",
        "In Korean educational culture, effort that does not produce a visible, individual result is wasted effort. Group work where one student carries the team is not a collaboration problem — it is a fairness problem. Jiwon is not upset about the format. She is upset because the format made her effort invisible.",
        "For students from Suneung culture, the most dangerous moment in an international school is when the assessment system changes without explaining how the new system still values what they do best: discipline, precision, and sustained effort."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "How do you protect a student like Jiwon without abandoning the innovation?",
      "options": [
        "Build individual visibility into every collaborative assessment.",
        "Explain the change in terms of what is being added, not what is being removed.",
        "Create a bridge: acknowledge that exam skills transfer directly to project skills.",
        "Talk to the student before the format change, not after the distress.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested two things: your ability to respond to institutional change pushback from a data-driven parent, and your ability to see how that same change affects the student most invested in the old system.",
            "Mr. Choi and Jiwon are expressing the same concern from different positions: the school removed a trust signal without adequately replacing it. He expressed it as a policy question. She expressed it as tears in the bathroom."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The zero-sum structure): When every assessment feels like a competitive event, removing exams feels like removing the playing field.",
            "D5 (What the student is carrying): Jiwon''s distress is not about this project. It is about a lifetime of preparation-equals-recognition being invalidated.",
            "D6 (What actually works): Individual visibility within collaborative formats. Communication that leads with what replaces the exam, not with its removal."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Ferguson, R. (2001). The role of testing in Korean educational culture.",
            "Bong, M. (2008). Effects of achievement goals on achievement emotions and performance in Korea.",
            "East Asia Forum (2023). South Korea''s teaching crisis: the collapse of Confucian authority."
          ]
        }
      ],
      "finalPrompt": "Your school is planning another assessment innovation for next year. Before you announce it, what would you do differently — in the communication to parents, in the support for students, and in the design of the assessment itself — to prevent the same dynamic from recurring?"
    }
  }'::jsonb,
  ARRAY[1, 4, 5, 6],
  20,
  3,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

COMMIT;

BEGIN;

----------------------------------------------------------------------
-- CHINA Scenario B: "The WeChat Critique"
-- Assessment translation — parent posts in WeChat group questioning no rankings
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'china-sim-b',
  'china-001',
  'The WeChat Critique',
  'A parent posts in the class WeChat group questioning why the school has no class rankings. Other parents pile on. By the time you see it, the conversation has been running for two hours.',
  'March at Mingde International School, Shanghai. You teach Year 8 English and humanities. Your school has 340 students, predominantly Chinese nationals with some Korean and expatriate families. Reports went home last Friday. On Monday morning, your Chinese teaching assistant shows you her phone. In the Year 8 parent WeChat group — a group you are not in — a parent named Mrs. Liu has posted a long message. Your TA translates the key section: "I have been patient for two years. Every report tells me my son is ''meeting expectations.'' Meeting whose expectations? In his cousin''s school, he would have a class rank, a percentile, and a clear picture of where he stands. Here I get paragraphs of encouragement and no data. I am not asking for praise. I am asking: is my son competitive for the universities we are targeting, yes or no? If the school cannot answer this, I need to know now, not in Year 12." Fourteen parents have replied. Most are supportive of Mrs. Liu. Two defend the school. The conversation is still active.',
  '[
    {"name": "You", "role": "Year 8 English and humanities teacher, homeroom for 8B", "description": "You are a Western-trained teacher in your third year in Shanghai. You speak conversational Mandarin. You are not in the WeChat group but your TA is. You know Mrs. Liu — she has always been polite in person."},
    {"name": "Mrs. Liu", "role": "Mother of Wei, finance professional", "description": "She works in asset management. She is analytical, direct in writing, and careful in person. She chose Mingde because of its IB track record for university placements. She is not attacking the school — she is demanding accountability."},
    {"name": "Ms. Chen", "role": "Your Chinese teaching assistant", "description": "She bridges the cultural gap. She understands what parents are saying in WeChat and what they are not saying to you. She is your most valuable source of ground truth."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The WeChat Thread",
      "content": [
        "March at Mingde International School, Shanghai. Reports went home last Friday.",
        "Your Chinese TA shows you her phone. In the Year 8 parent WeChat group — a group you are not in — Mrs. Liu has posted a long message.",
        "Your TA translates: \"Every report tells me my son is ''meeting expectations.'' Meeting whose expectations? In his cousin''s school, he would have a class rank. Here I get paragraphs of encouragement and no data.\"",
        "\"Is my son competitive for the universities we are targeting, yes or no? If the school cannot answer this, I need to know now, not in Year 12.\"",
        "Fourteen parents have replied. Most support Mrs. Liu. The thread has been running for two hours."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Response Channel",
      "content": ["You are not in the WeChat group. The conversation is happening without you. What do you do?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Ask your TA to post a response on your behalf",
          "text": "You draft a message in English, your TA translates it, and she posts it in the group: \"Teacher [Your Name] has seen the discussion and wants to address the concerns directly. She is arranging a parent information session this Friday to walk through assessment, university outcomes, and how to read the reports. She welcomes all questions.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Contact Mrs. Liu privately first",
          "text": "You message Mrs. Liu directly through the school communication app: \"Mrs. Liu, I understand you have questions about Wei''s report and our assessment approach. I would like to meet with you this week — not to defend the system, but to give you the specific information you are asking for. Would Wednesday work?\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Escalate to the principal and let leadership respond",
          "text": "You forward the translated thread to your principal with a note: \"This is a systemic concern, not an individual complaint. I think it needs a school-level response, not a teacher-level one.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Group Response",
      "content": [
        "The message lands well. Several parents reply with thumbs-up emojis. Mrs. Liu writes: \"Thank you. We will attend.\"",
        "The Friday session is well attended — 22 parents. You present university outcome data, explain the rubric system, and take questions for 45 minutes.",
        "But Ms. Chen tells you afterward: \"The real conversation happened after the session, in the WeChat group. Some parents said the data was convincing. Others said the school only shares good numbers. Mrs. Liu wrote: ''The session was professional. But I notice they only responded after I made noise in the group. That tells me something.''\"",
        "You addressed the surface. The trust question underneath — does the school listen unless parents force it? — remains open."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Private Meeting",
      "content": [
        "Mrs. Liu accepts. She arrives on Wednesday with a folder — printouts of Wei''s reports from the last three semesters, university requirements for five target schools, and a spreadsheet comparing Mingde''s DP results to two competing schools.",
        "\"I am not trying to be difficult,\" she says. \"I am trying to plan. My son is in Year 8. I have four years to make sure he is competitive. Every other data source I have gives me numbers. Your school gives me words. I cannot plan with words.\"",
        "You show her Wei''s specific criterion levels, explain how they map to predicted DP grades, and share three years of university placement data.",
        "She studies it. \"This is what the report should contain,\" she says. \"Not instead of the narrative — alongside it. Give me both.\"",
        "She leaves satisfied. But you know: you just gave one parent a personalised data briefing. The other 13 who agreed with her still have the same question."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Escalation",
      "content": [
        "Your principal reads the thread and calls a leadership meeting. The response takes three days to draft.",
        "By then, the WeChat conversation has moved on. Parents have drawn their own conclusions: the school took three days to respond to a reasonable question. In a culture where responsiveness signals respect, the delay is itself a message.",
        "Ms. Chen tells you: \"Two parents have contacted admissions offices at other schools. They may not leave, but they are looking. Mrs. Liu told the group: ''If they cannot answer the question quickly, the answer is probably not good.''\"",
        "The institutional response, when it arrives, is thorough and professional. But it arrives after the trust window has closed."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Mrs. Liu''s View",
      "content": [
        "In Chinese educational culture, the WeChat parent group is not a complaint forum. It is the real governance layer. The PTA meeting is performative. The WeChat group is where parents share intelligence, compare interpretations, and make collective judgments about school quality.",
        "Mrs. Liu''s post was not impulsive. It was strategic. She waited two years, accumulated evidence, and chose a moment — right after reports — when her concern would resonate with other parents. She wrote in measured language because she wanted to be taken seriously, not dismissed as emotional.",
        "The concept of mianzi (face) is operating here in a specific way: Mrs. Liu gave the school face by being polite in person for two years. The WeChat post is what happens when private patience exhausts itself. She is not losing face by posting — she is spending the social capital she built to force a response."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What did you assume about the WeChat conversation before you responded?",
      "options": [
        "I assumed it was a complaint that needed damage control.",
        "I recognised it as a legitimate accountability demand.",
        "I was uncomfortable that the conversation was happening without me.",
        "I focused on the tone rather than the substance of what was being asked.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Report Redesign",
      "content": [
        "After the WeChat episode, your principal asks you to join a task force redesigning the Year 8 report format. The goal: make reports legible to Chinese parents without introducing class rankings.",
        "The task force has three proposals on the table.",
        "You have one vote."
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Add cohort distribution bands",
          "text": "Show each student''s criterion level alongside a cohort distribution chart. Parents see where their child falls within the range without knowing individual names. This gives comparative context without ranking.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Add predicted DP grade equivalents",
          "text": "Map each Year 8 criterion level to a predicted IB DP score range. Parents see a number they can compare to university entry requirements. This gives forward-looking data without a class comparison.",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Add a parent-facing data supplement",
          "text": "Keep the narrative report as is. Add a one-page supplement: university placement data for the last three cohorts, average DP scores by subject, and the student''s predicted trajectory. This gives outcome data without changing the assessment system.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Cohort Distribution",
      "content": [
        "The distribution bands are implemented for the next reporting cycle.",
        "Mrs. Liu messages Ms. Chen: \"Finally. Now I can see where Wei actually is. He is in the upper third for English and the middle for mathematics. I can work with this.\"",
        "Some Western parents are uncomfortable: \"Are we creating a ranking by stealth?\" The principal reassures them that distribution bands are not rankings — they are context.",
        "The distinction is real but fragile. If parents start reverse-engineering the bands to identify individuals, the system will face the same pressure from the other direction."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Predicted DP Equivalents",
      "content": [
        "The predicted scores give parents a number they understand. Mrs. Liu can now map Wei''s Year 8 performance to a DP score range and compare it to university entry requirements.",
        "The risk surfaces quickly: parents treat predicted scores as promises. When Wei''s Year 9 report shows a lower predicted range (normal fluctuation), his mother contacts you immediately: \"His predicted score dropped. What happened?\"",
        "You have given parents a data point they can use — but also one they can misinterpret. The predicted score is a snapshot, not a guarantee. Without that framing, every fluctuation becomes a crisis."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Data Supplement",
      "content": [
        "The supplement is well-received. Parents like seeing university outcomes and average DP scores.",
        "But Mrs. Liu''s original question remains partially unanswered: she can see where graduates went, but she still cannot see where Wei is relative to his peers. The supplement gives her a destination without a map.",
        "Ms. Chen reports from the WeChat group: \"Parents are happy with the supplement but still want individual positioning. Mrs. Liu wrote: ''Progress, but not enough. We will keep asking.''\"",
        "You have improved the communication. You have not yet solved the legibility problem."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Legibility Problem",
      "content": [
        "Chinese parents in international schools are not asking for rankings because they are obsessed with competition. They are asking because rankings are the only assessment language their own educational system ever taught them.",
        "The gaokao system produces a single score that determines university placement. Every Chinese parent understands that number intuitively. When your school produces a narrative instead, you are asking them to learn a new language without providing a dictionary.",
        "The concept of mianzi adds another layer: a parent who cannot explain their child''s standing to grandparents, colleagues, and friends loses face. Your report may be pedagogically superior, but if it cannot travel — if it cannot be summarised in a sentence at a dinner table — it fails the parent''s social function.",
        "Assessment legibility is not a concession to ranking culture. It is a communication design problem."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "If you could redesign the report from scratch for Chinese families, what would it look like?",
      "options": [
        "Narrative + cohort context + predicted trajectory + university outcomes — all on one page.",
        "A number and a narrative, side by side, with the narrative explaining what the number means.",
        "A report designed with parent input — ask families what information they need before designing the format.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested your ability to respond to a public accountability demand through an informal channel you do not control, and then to design a systemic solution to the underlying legibility problem.",
            "Mrs. Liu''s WeChat post was not a complaint. It was a two-year-delayed request for data, delivered through the only channel where she could be sure other parents would hear it."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D2 (Assessment friction): The core problem — portfolio assessment without comparative context is opaque to gaokao-trained parents.",
            "D4 (Face and the smooth meeting): Mrs. Liu was polite in person for two years. The WeChat post is what happens when face-saving patience runs out.",
            "D6 (What actually works): Report design as a communication problem, not an assessment problem."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Ran, A. (2001). Travelling on parallel tracks: Chinese parents and English teachers. Educational Research.",
            "Li, J. (2005). Mind or virtue: Western and Chinese beliefs about learning. Current Directions in Psychological Science.",
            "Ding, X. (2023). Double reduction and the persistence of gaokao logic in Chinese education."
          ]
        }
      ],
      "finalPrompt": "Think about the parent communication channels at your school — the ones you control and the ones you do not. What information would you proactively share to prevent a WeChat moment like this? And how would you design the report so that a parent can summarise their child''s standing in one sentence at a family dinner?"
    }
  }'::jsonb,
  ARRAY[2, 4, 6],
  20,
  5,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

----------------------------------------------------------------------
-- CHINA Scenario C: "The Model Answer"
-- Culture-specific — student submits work mirroring a textbook, teacher must decide: plagiarism or learning pattern?
----------------------------------------------------------------------
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes,
  dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'china-sim-c',
  'china-001',
  'The Model Answer',
  'A student submits an essay that closely mirrors a published example. Your school calls it academic dishonesty. His educational culture calls it mastery. You have to decide what to do before the deadline.',
  'November at Mingde International School. You are grading Year 10 English A essays. Yichen''s essay on the theme of isolation in The Remains of the Day is well-written — polished vocabulary, clear structure, sophisticated analysis. Too sophisticated. You run a passage through a search engine and find a published student exemplar from an IB resource site. Yichen''s essay does not copy it word for word. But the structure is identical. The thesis is the same. Three of the key analytical points use the same textual evidence in the same order. The phrasing is paraphrased rather than copied, but the intellectual architecture is clearly derived from the model. Your school''s academic honesty policy is clear: submitting work that is substantially derived from another source without attribution is a Level 2 violation, carrying a zero on the assignment and a meeting with parents. But you know something the policy does not account for: in Chinese educational culture, studying model answers and reproducing their structure is not cheating. It is how learning works. The model answer is the starting point. Mastery means being able to replicate the expert''s approach. Yichen may genuinely not understand that what he did is a problem.',
  '[
    {"name": "You", "role": "Year 10 English A teacher, IB DP", "description": "You have taught IB English for six years. You understand academic honesty as an IB principle. You also know that enforcing it without cultural context can punish a student for following the learning method that got them this far."},
    {"name": "Yichen", "role": "Year 10 student, recently transferred from a bilingual school in Beijing", "description": "He is diligent, quiet, and produces careful work. He transferred to Mingde 18 months ago. His previous school used model essays as a standard teaching tool. He has never been told that reproducing a model structure is a problem."},
    {"name": "Mrs. Fang", "role": "Yichen''s mother, university professor of Chinese literature", "description": "She is highly educated and values academic excellence. She helped Yichen study the model essay as part of his preparation. She does not consider this dishonest. She considers it responsible study practice."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "The Essay",
      "content": [
        "November at Mingde International School. You are grading Year 10 English A essays.",
        "Yichen''s essay on isolation in The Remains of the Day is well-written. Too well-written.",
        "You find a published student exemplar. Yichen''s essay does not copy it word for word, but the structure is identical. The thesis is the same. Three key analytical points use the same evidence in the same order.",
        "Your school''s academic honesty policy: substantially derived work without attribution is a Level 2 violation. Zero on the assignment, parent meeting.",
        "But in Chinese educational culture, studying model answers and reproducing their structure is standard practice. The model is the starting point. Mastery means replicating the expert''s approach.",
        "Yichen transferred from a Beijing bilingual school 18 months ago. He may genuinely not understand that what he did is a problem."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Decision",
      "content": ["The academic honesty deadline is Friday. You need to decide: do you report this as a violation?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Report it as a Level 2 violation",
          "text": "The policy is clear. You file the report. Yichen receives a zero and his parents are called in for a meeting.",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Talk to Yichen first before deciding",
          "text": "You pull Yichen aside. \"I want to understand your process. How did you approach this essay? Did you look at any example essays before writing?\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Treat it as a teaching moment, not a violation",
          "text": "You decide not to report it. Instead, you give Yichen the essay back with a note: \"Your writing is strong. I need to teach you something about how IB handles sources — including model essays. Please come see me.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "The Formal Report",
      "content": [
        "Yichen is devastated. He does not argue. He goes quiet — the kind of quiet that is not compliance but withdrawal.",
        "Mrs. Fang arrives for the meeting. She is composed but visibly upset.",
        "\"I helped him study that essay,\" she says. \"In my university, students study model papers before they write their own. This is how scholarship works in Chinese academic tradition. You are punishing him for studying.\"",
        "The academic honesty coordinator holds firm: the policy applies equally to all students. Mrs. Fang leaves the meeting with a formal letter in her son''s file.",
        "Yichen''s writing becomes mechanical after this. He produces safe, formulaic essays that cannot be accused of anything. He has learned the wrong lesson: not how to cite, but how to avoid being caught caring about quality."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "The Conversation",
      "content": [
        "Yichen looks confused. \"Yes, Teacher. My mother found a good essay online. I studied the structure and used it for my essay. That is how we prepare in my old school. The teacher would give us model answers and we would practise until we could write like that.\"",
        "He is not being evasive. He is describing his training.",
        "\"Did you think you should cite it?\" you ask.",
        "\"Cite a study guide? No. It is a tool, not a source. Like a textbook.\"",
        "You now have information the policy does not capture. Yichen used the model as a pedagogical scaffold, not as a shortcut. The question is whether your school''s definition of academic honesty has room for that distinction."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "The Teaching Moment",
      "content": [
        "Yichen comes to your office. He is nervous but attentive.",
        "You explain: \"In IB, if you use another essay''s structure as your starting point, you need to say so. Not because using models is wrong — it is actually a good study technique — but because the IB assesses your original analysis. If the structure comes from somewhere else, the examiner needs to know.\"",
        "Yichen nods slowly. \"So I can study the model, but I need to write my own structure?\"",
        "\"Exactly. And if you do borrow a structural approach, cite it.\"",
        "He rewrites the essay. The new version is slightly less polished but genuinely his. His analysis is still strong — the model taught him well. He just needed to learn where the line is.",
        "The risk: if another teacher discovers the original essay and sees that you did not report it, you may face questions about inconsistent enforcement."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Two Academic Traditions",
      "content": [
        "In Chinese educational tradition, learning through imitation is not dishonest — it is foundational. The phrase ''learning by heart'' (背诵, bèisòng) carries no negative connotation. Students are expected to internalise model texts before producing original work. The model answer is not a crutch. It is the scaffold.",
        "Jin Li''s research on Chinese beliefs about learning (2005) describes a ''virtue orientation'' where mastery comes through sustained effort, repetition, and gradual refinement. The student who reproduces a model''s structure is demonstrating diligence, not dishonesty.",
        "IB academic honesty policy was designed in a Western academic tradition where originality is the primary marker of intellectual achievement. These two traditions are not in conflict about the value of learning. They are in conflict about what the first step looks like.",
        "Yichen is caught between two definitions of good practice. In his old school, he would have been praised. In your school, he may be punished. The gap is institutional, not moral."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Pause and Reflect",
      "prompt": "What was your first reaction when you saw the similarity to the model essay?",
      "options": [
        "I assumed it was plagiarism.",
        "I suspected a cultural difference but was not sure how to handle it.",
        "I wanted to protect the student but also uphold the policy.",
        "I felt conflicted about applying a rule that does not account for his background.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: Mrs. Fang''s Challenge",
      "content": [
        "Regardless of how you handled Dilemma 1, Mrs. Fang requests a meeting.",
        "She arrives with printed copies of three published model essays from IB resource sites, a Chinese university writing guide that recommends studying exemplars, and a highlighted copy of your school''s academic honesty policy.",
        "\"I have read your policy carefully,\" she says. \"It says students must not submit work that is substantially derived from another source. I accept that. But it also says the school will support students in understanding academic honesty expectations.\"",
        "She places the Chinese writing guide on the table. \"This is what my son was taught. Your school has a responsibility to teach him the difference, not to punish him for not knowing it already.\""
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Agree and propose a bridge programme",
          "text": "\"Mrs. Fang, you are right. We need to do a better job of explicitly teaching the distinction between studying models and citing them. I would like to propose a short workshop for students who transferred from Chinese-medium schools — not as remediation, but as translation between two academic traditions.\"",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Acknowledge the gap but hold the standard",
          "text": "\"I understand the tradition Yichen comes from, and I respect it. Our policy still applies — the expectation is clear in the student handbook. But I agree that we could do more to support students in transition. Let me discuss this with the DP coordinator.\"",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Ask her to help you design the solution",
          "text": "\"Mrs. Fang, you are a university professor. You understand both traditions better than I do. Would you be willing to help us design a resource — maybe a one-page guide — that explains IB citation expectations specifically for students who learned through model-answer methodology?\"",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "The Bridge Programme",
      "content": [
        "Mrs. Fang softens. \"That is exactly what I hoped you would say.\"",
        "You design a two-session workshop: ''Two Traditions of Learning.'' It explains model-answer methodology as a legitimate learning practice, then shows how IB citation requirements work. Students practise converting model-study into properly attributed analysis.",
        "Twelve students attend. Several say afterward: \"I did not know this was different. I thought I was doing it right.\"",
        "The workshop does not eliminate academic honesty violations. But it eliminates the ones caused by cultural translation failures. The remaining violations are genuine, and easier to address because the expectation has been explicitly taught."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "The Held Standard",
      "content": [
        "Mrs. Fang''s expression does not change. She collects her documents.",
        "\"I understand your position,\" she says. \"But I want you to understand mine. My son studied hard. He used every resource available to him. In his previous school, his teacher would have praised this essay. In your school, it is a violation. That gap is not his failure. It is yours.\"",
        "She leaves. Yichen''s file now contains a formal note. His mother''s trust in the school has been damaged — not because the standard is wrong, but because the school applied it without first teaching the distinction it assumes."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "The Co-Design",
      "content": [
        "Mrs. Fang is surprised by the invitation. She agrees.",
        "Over two weeks, she helps you create a one-page bilingual guide: ''How IB Citation Differs from Model-Answer Study.'' It explains in Mandarin and English what Chinese students have been taught, what IB expects, and how to bridge the gap. It includes examples of acceptable and unacceptable use of model essays.",
        "The guide is distributed to all Year 10 students and shared with the Chinese parent WeChat group. Mrs. Fang posts it herself with a note: ''The school listened. This is useful.''",
        "You have turned a potential adversary into a co-author. The guide is more credible because a Chinese parent helped write it."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "The Confucian-IB Tension",
      "content": [
        "This scenario sits at the heart of the Confucian-IB tension. In Chinese learning culture, the master''s work is the model. The student''s job is to internalise it, reproduce it, and eventually transcend it. This is not plagiarism — it is pedagogy. Li (2005) calls this the ''virtue orientation'': learning is moral work, and diligence in imitation demonstrates respect for knowledge.",
        "IB''s academic honesty framework assumes a ''mind orientation'': original thinking is the primary marker of intellectual achievement. Attribution is required because the individual''s contribution must be distinguishable from the source.",
        "Neither tradition is wrong. But when a school enforces one without teaching students how it differs from the other, it punishes cultural competence as misconduct.",
        "The productive question is not ''did he cheat?'' It is ''did anyone teach him the line, and was it drawn in a language he understands?''"
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Final Reflection",
      "prompt": "What would you change about how your school introduces academic honesty to transfer students?",
      "options": [
        "Teach the distinction explicitly in the first week, with examples from Chinese academic practice.",
        "Create a transition period where violations by new transfers are handled educationally before punitively.",
        "Involve Chinese parents in designing the onboarding materials.",
        "Train all teachers to recognise model-answer methodology so they can distinguish it from plagiarism.",
        "Write your own."
      ],
      "next": "debrief"
    },
    "debrief": {
      "id": "debrief",
      "type": "debrief",
      "title": "Debrief",
      "pathSummaryIntro": "Here is the path you took through this scenario.",
      "sections": [
        {
          "title": "What Was Really Happening",
          "content": [
            "This scenario tested whether you could see a culturally-trained learning behaviour inside what your policy defines as misconduct, and whether you could respond in a way that upholds academic standards while respecting the student''s educational background.",
            "Yichen was not cheating. He was studying. The gap between those two interpretations is the gap your school needs to bridge — not through stricter enforcement, but through explicit teaching of a distinction his previous school never needed to make."
          ]
        },
        {
          "title": "Dimension Connections",
          "content": [
            "D1 (The gaokao shadow): Model-answer methodology is a product of exam culture where the correct answer is the goal, not the original one.",
            "D5 (The Confucian-IB tension): Imitation as respect vs. originality as achievement — two legitimate academic traditions in collision.",
            "D6 (What actually works): Bilingual resources, parent co-design, and explicit teaching of the distinction."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Li, J. (2005). Mind or virtue: Western and Chinese beliefs about learning. Current Directions in Psychological Science.",
            "Ran, A. (2001). Travelling on parallel tracks: Chinese parents and English teachers.",
            "IBO Academic Honesty Policy (2019). Principles and expectations for IB World Schools."
          ]
        }
      ],
      "finalPrompt": "Think about a student in your class who recently transferred from a different educational system. What assumptions are you making about what they already know about your school''s expectations? What would you teach them explicitly in their first week?"
    }
  }'::jsonb,
  ARRAY[1, 5, 6],
  20,
  6,
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, description = EXCLUDED.description,
  context = EXCLUDED.context, characters = EXCLUDED.characters,
  nodes = EXCLUDED.nodes, status = EXCLUDED.status;

COMMIT;

----------------------------------------------------------------------
-- VERIFICATION QUERIES
----------------------------------------------------------------------
-- Run these after applying to confirm all 8 new simulations landed:

SELECT module_id, count(*) as sim_count
FROM pd_simulations
WHERE id IN (
  'india-sim-b', 'india-sim-c',
  'ksa-sim-b', 'ksa-sim-c',
  'korea-sim-b', 'korea-sim-c',
  'china-sim-b', 'china-sim-c'
)
GROUP BY module_id
ORDER BY module_id;
-- Expected:
-- china-001:  2
-- india-001:  2
-- korea-001:  2
-- ksa-001:    2

-- Total simulations per module (including previously seeded):
SELECT module_id, count(*) as total_sims
FROM pd_simulations
WHERE status = 'live'
GROUP BY module_id
ORDER BY module_id;
-- Expected (approximate, depends on prior seeds):
-- china-001:  6  (4 existing + 2 new)
-- india-001:  4  (2 existing + 2 new)
-- korea-001:  4  (2 existing + 2 new)
-- ksa-001:    4  (2 existing + 2 new)
