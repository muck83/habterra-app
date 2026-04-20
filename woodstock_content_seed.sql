-- ============================================================
-- woodstock_content_seed.sql
-- Migrates Woodstock parent-transition content into pd_modules
-- and the existing six pd_dimensions rows.
--
-- No schema change is required: pd_dimensions.content jsonb holds
-- the structured parent-guide content for the Step 2 renderer.
-- Safe to re-run.
-- ============================================================

BEGIN;

INSERT INTO public.pd_modules (
  id,
  country_code,
  title,
  tagline,
  research_backbone,
  hofstede_data,
  completion_threshold,
  unlock_reward,
  status
)
VALUES (
  'woodstock-001',
  'WS',
  'The Woodstock Curriculum Transition',
  'Understanding the shift from IB to IGCSE, AP, and the Woodstock School Diploma',
  $$[
    {
      "source": "src/vocab/woodstock-parent-transition.js",
      "type": "school-authored transition guide",
      "mapping": {
        "meta": "pd_modules title/tagline plus pd_dimensions.content",
        "directorNote": "dimension 1",
        "openingHook": "dimension 1",
        "cohortGuide": "dimension 2",
        "cards": "dimension 3",
        "universityGuide": "dimension 4",
        "ibUniversityGuide": "dimension 4",
        "studentTransition": "dimension 5",
        "igcseDeepDive": "dimension 5",
        "apDeepDive": "dimension 5",
        "ibProgramme": "dimension 5",
        "scenarios": "dimension 6",
        "nextSteps": "dimension 6",
        "feedbackCta": "dimension 1"
      }
    }
  ]$$::jsonb,
  '{}'::jsonb,
  80,
  'Woodstock transition guide',
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  tagline = EXCLUDED.tagline,
  research_backbone = EXCLUDED.research_backbone,
  completion_threshold = EXCLUDED.completion_threshold,
  unlock_reward = EXCLUDED.unlock_reward,
  status = EXCLUDED.status;

INSERT INTO public.pd_dimensions (module_id, dimension_number, title, research_status, content)
VALUES
  (
    'woodstock-001',
    1,
    'Transition overview and parent reassurance',
    'community',
    $${
      "sourceKey": "meta/directorNote/openingHook/feedbackCta",
      "summary": "Woodstock is evolving from the International Baccalaureate programme to a combination of Cambridge IGCSE, Advanced Placement, and the Woodstock School Diploma. The change is gradual, cohort-specific, and designed so that students already in Grades 9-12 complete IB as planned.",
      "meta": {
        "title": "The Woodstock Curriculum Transition",
        "subtitle": "Understanding the shift from IB to IGCSE, AP, and the Woodstock School Diploma",
        "intro": "Woodstock is evolving its curriculum from the International Baccalaureate programme to a combination of Cambridge IGCSE, Advanced Placement, and the Woodstock School Diploma. This change is gradual - your child's pathway depends entirely on their current grade. This guide answers the questions heard most often at Parent-Teacher Conferences."
      },
      "directorNote": {
        "quote": "We did not make this decision lightly. Three years of consultation with universities, employers, and our own faculty led us here. The result is a curriculum that is more rigorous, more flexible, and more true to who Woodstock is than any off-the-shelf programme could be.",
        "attribution": "Woodstock School Academic Leadership"
      },
      "openingHook": {
        "question": "If we chose Woodstock for IB, should we still stay?",
        "directAnswer": "Yes - if your child is happy and learning. The new pathway is internationally respected, more flexible for different learners, and better aligned with Woodstock's residential and outdoor-education mission. If your child is currently in Grades 9-12, they complete IB as planned."
      },
      "feedbackCta": {
        "text": "Questions not answered here?",
        "email": "academics@woodstockschool.in",
        "cta": "Email the academic office"
      },
      "sections": [
        {
          "heading": "The protection principle",
          "items": [
            "Students already in Grades 9-12 complete their IB pathway as planned.",
            "No student is moved mid-programme.",
            "Current parent questions should always be answered by cohort, not in general terms."
          ]
        },
        {
          "heading": "The core reassurance",
          "items": [
            "IGCSE, AP, and WSD are internationally respected credentials.",
            "The new pathway creates more subject flexibility in Grades 11-12.",
            "Woodstock's residential, service, and outdoor-learning mission becomes more visible through the WSD."
          ]
        },
        {
          "heading": "Director note",
          "items": [
            "Three years of consultation with universities, employers, and faculty led to this transition.",
            "The new curriculum is intended to be more flexible and more Woodstock-specific than an off-the-shelf programme."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  ),
  (
    'woodstock-001',
    2,
    'Cohort pathways by current grade',
    'community',
    $${
      "sourceKey": "cohortGuide",
      "summary": "A family's experience depends entirely on the child's current grade. This row preserves the five cohort pathways from the parent-transition guide.",
      "cohortGuide": {
        "intro": "Your child's experience depends entirely on their current grade. Find your cohort below.",
        "protectionCallout": "Any student already in Grades 9-12 completes their IB programme as planned. No student mid-programme is moved. This is non-negotiable.",
        "cohorts": [
          {
            "id": "grade-11-12",
            "label": "Current Grades 11-12",
            "path": "Complete IB Diploma - no change",
            "detail": "Your child finishes the IB Diploma Programme exactly as originally planned. Zero disruption. The transition happens after your child graduates.",
            "timeline": "IB exams as scheduled.",
            "action": "Nothing changes for your family. Continue exactly as normal.",
            "note": "Students graduate with both the IB Diploma and the Woodstock School Diploma. CAS, the Extended Essay, residential life, and academic credits map into WSD requirements without extra coursework."
          },
          {
            "id": "grade-10",
            "label": "Current Grade 10",
            "path": "Enter IB Diploma in Grade 11 - complete as planned",
            "detail": "Your child enters the IB Diploma in Grade 11 and completes the full Diploma Programme in Grade 12. They are fully protected.",
            "timeline": "Enter IB Diploma in Grade 11. Final exams May 2027.",
            "action": "Finalize HL and SL subject choices and begin thinking about the Extended Essay topic.",
            "note": "The WSD is earned through the IB work already being completed, plus Woodstock's residential and outdoor requirements."
          },
          {
            "id": "grade-9",
            "label": "Current Grade 9",
            "path": "MYP Years 4-5, then IB Diploma in Grades 11-12",
            "detail": "Your child completes MYP Year 5 in Grade 10, including the Personal Project, then enters the IB Diploma in Grade 11 as the last cohort to enter IB.",
            "timeline": "MYP Year 5 in Grade 10, IB Diploma in Grades 11-12, final exams May 2029.",
            "action": "Treat Grade 10 as a runway into IB, not a holding pattern.",
            "note": "The Personal Project is sustained independent academic work and strong preparation for the IB Extended Essay."
          },
          {
            "id": "grade-8",
            "label": "Current Grade 8",
            "path": "Complete MYP, then IGCSE + AP + WSD from Grade 9 onward",
            "detail": "This is the bridge cohort: students carry the IB foundation into Cambridge IGCSE, then AP and WSD.",
            "timeline": "MYP Grade 8, IGCSE Grades 9-10, AP + WSD Grades 11-12.",
            "action": "Use Grade 8 to prepare for IGCSE subject selection and external-exam skills.",
            "note": "Subject selection in Grade 8 shapes AP availability in Grades 11-12."
          },
          {
            "id": "grade-6-7",
            "label": "Current Grades 6-7",
            "path": "Full new pathway from start - Middle School to IGCSE to AP + WSD",
            "detail": "Students spend Grades 6-8 in standards-based Middle School, then take IGCSE in Grades 9-10 and AP + WSD in Grades 11-12.",
            "timeline": "Middle School Grades 6-8, IGCSE Grades 9-10, AP + WSD Grades 11-12.",
            "action": "Focus now on engagement, curiosity, study habits, and readiness for later credentials.",
            "note": "The credential conversation can wait for younger students; strong habits matter most now."
          }
        ]
      },
      "sections": [
        {
          "heading": "Cohort map",
          "items": [
            "Grades 11-12: complete IB Diploma with no change.",
            "Grade 10: enters and completes IB Diploma as planned.",
            "Grade 9: completes MYP Year 5, then IB Diploma.",
            "Grade 8: bridge cohort into IGCSE, then AP + WSD.",
            "Grades 6-7: full new pathway from the start."
          ]
        },
        {
          "heading": "Staff habit",
          "items": [
            "Never answer transition questions without first identifying the student's current grade.",
            "Do not conflate Grade 8, Grade 9, and Grade 10 pathways.",
            "Repeat the no-mid-programme-change principle early in conversations."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  ),
  (
    'woodstock-001',
    3,
    'Credential guide: IGCSE, AP, WSD, and IB',
    'community',
    $${
      "sourceKey": "cards/igcseDeepDive/apDeepDive/ibProgramme",
      "summary": "This row stores the credential explanations parents need most: what IGCSE is, how AP works, what the Woodstock School Diploma means, and how continuing IB cohorts should understand their pathway.",
      "cards": [
        {
          "id": "igcse",
          "label": "Cambridge IGCSE · Grades 9–10",
          "concept": "What is IGCSE — and is it equivalent to Class 10?",
          "concern": "We chose Woodstock partly for IB. Now it is being replaced with something we have never heard of. Are we downgrading?",
          "bridge": "The IGCSE (International General Certificate of Secondary Education) is Cambridge University's qualification for ages 14–16. It is taken by over 3 million students in 160+ countries. For Indian families: IGCSE is recognized by the Association of Indian Universities (AIU) as equivalent to Class 10 board exams — CBSE, ICSE, and state boards. It is not less rigorous. It is differently rigorous: where IB's MYP emphasizes interdisciplinary thinking, IGCSE emphasizes deep subject mastery and formal external examination in each subject.",
          "goal": "Your child leaves Grade 10 with a formal Cambridge credential in 5–7 core subjects. Universities worldwide — in the UK, US, India, Australia, and beyond — recognize IGCSE exactly as they would a UK GCSE, Indian Class 10 board exam, or American 9th-grade transcript.",
          "whatToAsk": [
            "Which subjects will my child take for IGCSE? (Typically: Maths, English, Sciences, and 2–3 electives such as History, Geography, Languages, or Computer Science.)",
            "How do IGCSE grades compare to CBSE/ICSE grades? (IGCSE A* and A are broadly equivalent to CBSE 90%+. The grading scale is A*–G, not percentages.)",
            "Is IGCSE recognized for Indian university entrance? (Yes. AIU recognizes IGCSE as equivalent to Class 10. For JEE/NEET, the subjects taught — Maths, Physics, Chemistry, Biology — overlap significantly.)",
            "If my child struggles in one subject, can they resit IGCSE? (Yes. Students can resit in January or May of the following year.)"
          ]
        },
        {
          "id": "cbse-comparison",
          "label": "Comparing to CBSE / ICSE",
          "concept": "How does IGCSE + AP + WSD compare to the Indian board system?",
          "concern": "Indian parents and relatives will ask: why are you not doing CBSE or ICSE?",
          "bridge": "CBSE and ICSE are excellent systems designed for Indian university entry. IGCSE + AP is designed for international university entry — including India's top private universities (Ashoka, FLAME, Jindal, Symbiosis). The difference is not quality — it is orientation. IGCSE covers similar content to Class 10 CBSE/ICSE, often at greater depth in Sciences and Maths. AP courses are broadly equivalent to first-year university level.",
          "goal": "When your child applies to university, they will have Cambridge IGCSE results (Class 10 equivalent, recognized by AIU), AP scores (Class 12 equivalent, recognized worldwide), and the Woodstock School Diploma (MSA-accredited).",
          "whatToAsk": [
            "Will my child be able to apply to IITs or medical colleges? (For JEE/NEET: students can sit these exams with IGCSE — the exams are open to any student who meets eligibility criteria regardless of board.)",
            "Which Indian universities explicitly accept IGCSE + AP? (Ashoka University, FLAME University, OP Jindal Global University, Symbiosis International University, and many others.)",
            "What about the Woodstock School Diploma — does India know what that is? (WSD is MSA-accredited. The IGCSE and AP credentials are the primary academic markers; WSD provides the holistic narrative.)"
          ]
        },
        {
          "id": "ap",
          "label": "Advanced Placement · Grades 11–12",
          "concept": "What is Advanced Placement (AP)?",
          "concern": "AP sounds American. Woodstock is international. Will AP be recognized globally?",
          "bridge": "AP (Advanced Placement) is the College Board's university-level course programme — the same College Board that administers the SAT. It is taken by 2.5+ million students annually, and 4,000+ universities in 75+ countries accept AP credit. Woodstock has offered AP since 1961. AP is not American only: it is globally respected because the courses are genuinely university-level.",
          "goal": "Your child takes AP courses (typically 3–5 over Grades 11–12) in subjects they choose. AP exams are scored 1–5, where 3+ is passing. Scores of 4–5 often earn college credit — meaning your child may enter university as a second-semester freshman, saving fees and time.",
          "whatToAsk": [
            "Which AP subjects does Woodstock offer? (AP Calculus, Statistics, Biology, Chemistry, Physics, Computer Science, English Language & Literature, History, Geography, Psychology, Economics, Spanish, French, and more.)",
            "How many APs should my child take? (Typically 3–5 over two years. Quality over quantity — a 5 in three subjects is better than a 3 in six.)",
            "Can AP results secure a university place before Grade 12 ends? (Yes — strong AP scores in Grade 11 can earn conditional or unconditional offers from UK universities before Grade 12 even begins.)"
          ]
        },
        {
          "id": "wsd",
          "label": "Woodstock School Diploma · Grades 9–12",
          "concept": "What is the Woodstock School Diploma (WSD)?",
          "concern": "I have never heard of it. How will universities know what it means?",
          "bridge": "The Woodstock School Diploma is Woodstock's own credential, built over 60+ years of offering a school-based diploma pathway alongside external qualifications. The current formalized 24-credit WSD structure is accredited by the Middle States Association (MSA). This is not a participation certificate — it is a structured, credit-bearing diploma.",
          "goal": "Your child graduates with three credentials: IGCSE (Cambridge), AP course completions (College Board), and the Woodstock School Diploma (MSA-accredited). Together these tell a complete story: subject mastery (IGCSE), intellectual depth (AP), and whole-person development (WSD).",
          "whatToAsk": [
            "What are the 24 WSD credits? (Approximately: English 4, Maths 3, Science 3, Social Studies 3, Foreign Language 2, Religious Education 1, PE 1, Outdoor Learning 1, Arts 2, Projects 1, Electives 3. Woodstock will share the full breakdown.)",
            "Can my child choose a domain (pathway) within WSD? (Yes. Woodstock offers pathways in Global Affairs, STEM, Business, Arts, Life Sciences, and Sport.)",
            "Do outdoor expeditions and residential life count toward WSD? (Yes — and this is the point. Outdoor Learning and residential service are built into WSD credits, not extras.)"
          ]
        },
        {
          "id": "university-recognition",
          "label": "University Recognition Worldwide",
          "concept": "Will universities recognize IGCSE, AP, and WSD equally to IB?",
          "concern": "Different countries prefer different qualifications. Will my child be at a disadvantage?",
          "bridge": "Universities do not prescribe a single qualification — they look at rigor, performance, and fit. IGCSE, AP, and WSD are all recognized and rigorous. Many admissions officers prefer IGCSE + AP over IB because it shows subject mastery (IGCSE) combined with intellectual independence (AP).",
          "goal": "Your child can apply to universities in any country. IGCSE is the international standard for ages 14–16. AP is accepted by 4,000+ universities in 75+ countries. WSD is Woodstock-specific and backed by MSA accreditation.",
          "whatToAsk": [
            "Do IGCSE grades directly affect US university admission? (Less than AP does. US universities focus on AP scores. IGCSE is seen as a strong foundation.)",
            "Can AP scores earn a UK university place before Grade 12 exams? (Yes — strong Grade 11 AP scores can result in conditional or unconditional UK offers before Grade 12 begins.)",
            "What about Indian university admissions specifically? (IGCSE is AIU-recognized as Class 10 equivalent. AP is recognized by India's top private universities.)"
          ]
        },
        {
          "id": "why-evolve",
          "label": "Why Did Woodstock Evolve Beyond IB?",
          "concept": "If IB works, why change?",
          "concern": "This feels like disruption for disruption's sake. Woodstock had something good.",
          "bridge": "IB is excellent. Woodstock is not moving away from IB because IB failed — it is moving toward a curriculum that is a better fit for Woodstock's specific mission. Over three years, Woodstock's faculty and academic leadership consulted admissions officers, IB educators, AP educators, employers, and universities worldwide.",
          "goal": "You can trust that this change is purposeful. Woodstock is not switching programmes because it is reacting to a problem. It is proactively building a curriculum that is designed for Woodstock — not an off-the-shelf package.",
          "whatToAsk": [
            "Did universities request this change? (No. Woodstock initiated it. The university consultation confirmed the new pathway would be equally or better received.)",
            "Are the teachers ready for the new curriculum? (Yes. Woodstock's faculty have been part of this design process. AP teachers are trained and certified through the College Board; IGCSE teachers are trained by Cambridge.)",
            "Is Woodstock losing any accreditation? (No. Woodstock maintains MSA accreditation throughout.)"
          ]
        }
      ],
      "deepDives": {
        "igcse": {
          "headline": "IGCSE: Grades, Transcripts & University Impact",
          "gradingScale": ["A* Exceptional", "A Excellent", "B Very Good", "C Good", "D-G Passing to low passing", "U Ungraded"],
          "targetNote": "At Woodstock, the target range for university-bound students is A*-B in core subjects and A*-C in electives."
        },
        "ap": {
          "headline": "AP at Woodstock: Courses, Scores & College Credit",
          "scoringScale": ["5 Extremely Well Qualified", "4 Well Qualified", "3 Qualified", "2 Possibly Qualified", "1 No Recommendation"],
          "earlyOfferSteps": ["Grade 10: first APs where appropriate", "Grade 11: 2-3 major APs", "July-October Grade 11: UK universities evaluate", "Grade 12: additional APs strengthen the profile"]
        },
        "ib": {
          "headline": "The IB Diploma Programme - what it is and how it works",
          "overview": "IBDP is a two-year qualification in Grades 11-12 with six subjects plus Extended Essay, Theory of Knowledge, and CAS.",
          "scoring": "Each subject is scored 1-7. EE and TOK add up to 3 bonus points, for a maximum of 45."
        }
      },
      "sections": [
        {
          "heading": "How to explain the credential mix",
          "items": [
            "IGCSE gives externally assessed subject mastery by Grade 10.",
            "AP gives university-level depth and more subject flexibility in Grades 11-12.",
            "WSD makes Woodstock's residential, service, outdoor, and project-based learning visible in the transcript story.",
            "Continuing IB students keep the globally recognized IB Diploma pathway they started."
          ]
        },
        {
          "heading": "Common credential misread",
          "items": [
            "Do not frame AP as American-only.",
            "Do not describe IGCSE as less rigorous because it is different from IB.",
            "Do not present WSD as a participation certificate; it is credit-bearing and MSA-accredited."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  ),
  (
    'woodstock-001',
    4,
    'University recognition by destination',
    'community',
    $${
      "sourceKey": "universityGuide/ibUniversityGuide",
      "summary": "Parents need destination-specific answers. This row stores how IGCSE, AP, WSD, and continuing IB are read in the UK, US, India, Australia, and other major university systems.",
      "universityGuide": {
        "intro": "IGCSE, AP, and WSD are read differently by each university system. The key parent move is to ask about the destination system, not whether one credential is universally better.",
        "destinations": [
          {
            "id": "uk",
            "label": "UK Universities",
            "verdict": "IGCSE is familiar, AP is accepted by many UK universities, and strong AP results can support conditional or unconditional offers.",
            "topTip": "For UK-bound students, plan AP subjects backward from intended degree requirements."
          },
          {
            "id": "us",
            "label": "US Universities",
            "verdict": "AP is native to the US system and is the primary academic credential for credit and advanced placement; IGCSE shows foundation and breadth.",
            "topTip": "A small number of strong AP scores in rigorous subjects is better than many weak scores."
          },
          {
            "id": "india",
            "label": "Indian Universities",
            "verdict": "IGCSE is AIU-recognized as Class 10 equivalent, and AP is recognized by many leading private universities.",
            "topTip": "For JEE/NEET paths, confirm required IGCSE subjects early and document AIU equivalency steps."
          },
          {
            "id": "australia",
            "label": "Australian Universities",
            "verdict": "Australian universities understand international credentials and increasingly accept AP for admission and credit decisions.",
            "topTip": "Check each university and faculty's published AP/IGCSE requirements from Grade 10."
          }
        ]
      },
      "ibUniversityGuide": {
        "intro": "The IB Diploma remains one of the world's most recognized secondary qualifications for continuing cohorts.",
        "destinations": [
          {
            "id": "uk",
            "label": "UK Universities",
            "detail": "UK universities are deeply familiar with IB. Conditional offers often depend on total points and relevant HL grades."
          },
          {
            "id": "us",
            "label": "US Universities",
            "detail": "US universities understand IB well; strong HL subjects, Extended Essay, and TOK can strengthen applications."
          },
          {
            "id": "india",
            "label": "Indian Universities",
            "detail": "Leading private universities recognize IB. Government pathways may require an AIU equivalency certificate."
          },
          {
            "id": "australia",
            "label": "Australian Universities",
            "detail": "Australian universities convert IB scores to ATAR equivalents for admission."
          }
        ]
      },
      "sections": [
        {
          "heading": "How to answer recognition questions",
          "items": [
            "Ask which destination system the family is considering.",
            "Name the credential that matters most in that destination.",
            "Avoid promising credit or admission outcomes; direct families to current university policies.",
            "For India, separate AIU equivalency, JEE/NEET eligibility, and private-university recognition."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  ),
  (
    'woodstock-001',
    5,
    'Student experience and transition wins',
    'community',
    $${
      "sourceKey": "studentTransition",
      "summary": "The credential change is the official story. This row preserves the parent guide's explanation of what changes for students day to day and why the new pathway can be a stronger fit for many learners.",
      "studentTransition": {
        "headline": "What this means for your child - not just the paperwork",
        "intro": "The lived experience includes more subject choice, genuine university-level work, earlier admissions opportunities, clearer external validation, and formal credit for Woodstock's outdoor and residential life.",
        "wins": [
          {
            "id": "freedom-to-specialize",
            "title": "They study what they're actually good at",
            "detail": "AP allows students to choose university-level subjects aligned with strengths and goals."
          },
          {
            "id": "real-university-work",
            "title": "AP courses are genuinely university-level",
            "detail": "A strong AP result demonstrates proficiency equivalent to first-year university work."
          },
          {
            "id": "early-admission-window",
            "title": "They can have a university place before Grade 12 exams",
            "detail": "Strong Grade 10-11 AP results can create early UK admissions opportunities."
          },
          {
            "id": "igcse-clear-foundation",
            "title": "Cambridge IGCSE gives clear, external validation",
            "detail": "Students finish Grade 10 with externally moderated Cambridge results."
          },
          {
            "id": "woodstock-dna-credited",
            "title": "Woodstock's outdoor and residential life formally counts",
            "detail": "Outdoor learning, service, projects, and residential life become part of the diploma structure."
          },
          {
            "id": "distributed-assessment",
            "title": "Assessment is spread across years",
            "detail": "IGCSE and AP assessment is distributed rather than concentrated in one final IB season."
          },
          {
            "id": "pathway-identity",
            "title": "They graduate with a clear identity and direction",
            "detail": "WSD domain pathways help students build a coherent application story."
          }
        ],
        "studentVoice": {
          "prompt": "What would a current student tell a Grade 8 student about the new pathway?",
          "response": "By Grade 11, you will be doing real university-level work. Expeditions and outdoor learning are part of your diploma, and careful AP planning can open university options early."
        }
      },
      "sections": [
        {
          "heading": "Student-facing wins",
          "items": [
            "More freedom to specialize in genuine strengths.",
            "University-level work earlier through AP.",
            "External validation through IGCSE before the final two years.",
            "Woodstock's outdoor, service, and residential life are formally credited.",
            "The student transcript tells a clearer pathway story."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  ),
  (
    'woodstock-001',
    6,
    'Parent conversation scenarios and next steps',
    'community',
    $${
      "sourceKey": "scenarios/nextSteps",
      "summary": "This row stores the parent guide's common conversation scenarios and grade-specific next steps so staff can respond with clarity during PTMs and informal conversations.",
      "scenarios": [
        {
          "id": "score-panic",
          "title": "The Grade Comparison Moment",
          "termsInPlay": ["IGCSE A*-G", "AP 1-5", "IB 1-7"],
          "situation": "A child receives an IGCSE B and the family reads it as a poor result.",
          "withUnderstanding": "The family checks the Cambridge equivalency chart and understands that the scale differs from IB or CBSE-style percentages.",
          "withoutUnderstanding": "The family assumes standards have dropped and spreads misinformation."
        },
        {
          "id": "flexibility-moment",
          "title": "The I Finally Love School Conversation",
          "termsInPlay": ["IB required subjects", "AP student-chosen depth", "WSD domain pathways"],
          "situation": "A student can finally focus deeply on subjects that fit their strengths.",
          "withUnderstanding": "The family sees specialization as a strength.",
          "withoutUnderstanding": "The family mistakes choice for reduced rigor."
        },
        {
          "id": "university-lock-in-moment",
          "title": "The Early Admission Window",
          "termsInPlay": ["AP as university-level work", "Grade 11 early offers", "UK conditional/unconditional"],
          "situation": "Strong Grade 11 AP results produce early UK university opportunities.",
          "withUnderstanding": "The family plans AP choices intentionally.",
          "withoutUnderstanding": "The family misses the structural advantage."
        },
        {
          "id": "jee-neet-moment",
          "title": "The JEE / NEET Question at the Dinner Table",
          "termsInPlay": ["IGCSE subject selection", "AIU equivalency", "PCM/PCB"],
          "situation": "A family asks whether IGCSE keeps Indian entrance-exam options open.",
          "withUnderstanding": "The school gives a clear yes with subject-selection conditions.",
          "withoutUnderstanding": "The family hears uncertainty and considers transferring."
        },
        {
          "id": "predicted-grades-moment",
          "title": "The Predicted Grades Meeting",
          "termsInPlay": ["IB predicted grades", "UCAS", "moderation"],
          "situation": "A continuing IB family worries that predicted grades are teacher-dependent.",
          "withUnderstanding": "The school explains the moderation process and next steps.",
          "withoutUnderstanding": "The parent frames the prediction as unfairness from one teacher."
        }
      ],
      "nextSteps": [
        "Find your child's grade cohort and read the timeline carefully.",
        "For new-pathway families, read the university guide by destination.",
        "For Grade 8 parents, discuss IGCSE subject choices before Grade 9.",
        "For Indian university options, ask about AIU equivalency and AP recognition.",
        "For Grades 6-7, focus now on engagement and study habits.",
        "For Grades 9-12, remember that your child completes IB as planned.",
        "For child-specific questions, email academics@woodstockschool.in.",
        "For Grade 9, begin the HL/SL subject conversation before the end of Grade 10.",
        "For Grade 9, treat the Personal Project as preparation for the Extended Essay.",
        "For Grade 10, review IB subject guides before Grade 11 begins.",
        "For Grades 11-12, ask how revision, mock exams, and predicted grades are managed."
      ],
      "sections": [
        {
          "heading": "Conversation stance",
          "items": [
            "Start with the cohort.",
            "Name the credential scale before interpreting results.",
            "Give clear yes/condition answers for JEE and NEET rather than vague reassurance.",
            "For IB families, explain institutional processes such as predicted-grade moderation."
          ]
        }
      ],
      "citations": []
    }$$::jsonb
  )
ON CONFLICT (module_id, dimension_number) DO UPDATE SET
  title = EXCLUDED.title,
  research_status = EXCLUDED.research_status,
  content = EXCLUDED.content;

COMMIT;

-- Verification
SELECT id, title, tagline, status
FROM public.pd_modules
WHERE id = 'woodstock-001';

SELECT dimension_number, title, content->>'sourceKey' AS source_key
FROM public.pd_dimensions
WHERE module_id = 'woodstock-001'
ORDER BY dimension_number;

SELECT count(*) AS woodstock_dimensions
FROM public.pd_dimensions
WHERE module_id = 'woodstock-001';
