// DEPRECATED: Used only in MOCK_MODE. Production reads from Supabase pd_dimensions.
/* ─────────────────────────────────────────────────────────────────────
   Woodstock School — Parent Transition Vocab
   Ported from campfire/src/vocab/woodstock/parent-transition.js
   This file is kept as the MOCK_MODE fallback for local dev without a
   .env / Supabase connection. Production data lives in pd_modules and
   pd_dimensions (seeded by woodstock_content_seed.sql).
   ───────────────────────────────────────────────────────────────────── */

export const woodstockParentTransition = {

  meta: {
    title: 'The Woodstock Curriculum Transition',
    subtitle: 'Understanding the shift from IB to IGCSE, AP, and the Woodstock School Diploma',
    intro: 'Founded in 1854 as the first international boarding school in India — and in all of Asia — Woodstock has reshaped its academic programme many times across more than 170 years in the Himalayas to stay true to its founding purpose. The current shift, from the International Baccalaureate programme to a combination of Cambridge IGCSE, Advanced Placement, and the Woodstock School Diploma, is the latest chapter in that tradition. It is gradual — your child\'s pathway depends entirely on their current grade. This guide answers the questions we heard most often at Parent-Teacher Conferences.',
  },

  directorNote: {
    quote: 'We did not make this decision lightly. Three years of consultation with universities, employers, and our own faculty led us here. In more than 170 years in the Himalayas, Woodstock has reshaped its programme before when the moment required it. The result of this latest work is a curriculum that is more rigorous, more flexible, and more true to who Woodstock is than any off-the-shelf programme could be.',
    attribution: 'Woodstock School Academic Leadership',
  },

  openingHook: {
    question: 'If we chose Woodstock for IB, should we still stay?',
    directAnswer: 'Yes — if your child is happy and learning. The new pathway (IGCSE + AP + WSD) is internationally respected, more flexible for different learners, and better aligned with Woodstock\'s residential and outdoor-education mission. Most importantly: if your child is currently in Grades 9–12, they complete IB as planned. Zero change for them.',
  },

  cohortGuide: {
    intro: 'Your child\'s experience depends entirely on their current grade. Find your cohort below.',
    protectionCallout: 'Any student already in Grades 9–12 completes their IB programme as planned. No student mid-programme is moved. This is non-negotiable.',
    cohorts: [
      {
        id: 'grade-11-12',
        label: 'Current Grades 11–12',
        path: 'Complete IB Diploma — no change',
        detail: 'Your child finishes the IB Diploma Programme exactly as originally planned. Zero disruption. Their IB final exams are May 2026 (Grade 12) and May 2027 (if applicable). Woodstock protects every student mid-programme from curriculum changes.',
        timeline: 'IB exams as scheduled. The transition happens after your child graduates.',
        action: 'Nothing changes for your family. Continue exactly as normal.',
        wsdNote: {
          heading: 'Two credentials, not one',
          body: 'Your child graduates with both the IB Diploma and the Woodstock School Diploma (WSD). The WSD is not additional work — it is structured to complement IB requirements directly. Your child\'s IB CAS programme satisfies the Outdoor Learning and Service credits within WSD. The Extended Essay satisfies the Senior Project credit. The academic subjects and residential life complete the remaining WSD credits. No extra coursework. Your child simply graduates with two internationally recognized credentials: the IB Diploma and the WSD (accredited by the Middle States Association).',
        },
      },
      {
        id: 'grade-10',
        label: 'Current Grade 10',
        path: 'Enter IB Diploma in Grade 11 — complete as planned',
        detail: 'Your child enters the IB Diploma in Grade 11 and completes the full Diploma Programme in Grade 12. They experience IB exactly as designed — no modification. They are fully protected.',
        timeline: 'Enter IB Diploma in Grade 11 (2026–27). Final exams May 2027. Graduate with full IB Diploma credential.',
        action: 'Your child transitions to IB as planned. No curriculum changes. This year is the moment to finalize HL and SL subject choices and begin thinking about the Extended Essay topic.',
        wsdNote: {
          heading: 'Two credentials, not one',
          body: 'Your child will graduate with both the IB Diploma and the Woodstock School Diploma (WSD). The WSD is structured to complement IB requirements: CAS satisfies Outdoor Learning and Service credits; the Extended Essay satisfies the Senior Project credit. There is no parallel programme — your child earns the WSD through the IB work they are already doing, plus Woodstock\'s residential and outdoor requirements. Two credentials, no duplication.',
        },
      },
      {
        id: 'grade-9',
        label: 'Current Grade 9',
        path: 'MYP Years 4–5, then IB Diploma in Grades 11–12',
        detail: 'Your child is in MYP Year 4 (Grade 9) now, and will complete MYP Year 5 in Grade 10 — the capstone year of the Middle Years Programme, culminating in the MYP Personal Project. They then enter the IB Diploma in Grade 11 and graduate with the full IB Diploma in Grade 12. They are the last cohort to enter IB (2027–28 intake).',
        timeline: 'MYP Year 4 — Grade 9 (2025–26). MYP Year 5 + Personal Project — Grade 10 (2026–27). IB Diploma Year 1 — Grade 11 (2027–28). IB Diploma Year 2 + Final Exams — Grade 12 (2028–29). Final exams May 2029.',
        action: 'Grade 10 is not a gap year — it is MYP Year 5. The Personal Project in Grade 10 is your child\'s first sustained independent research experience, and it is the strongest academic preparation for the IB Extended Essay in Grade 11.',
        grade10Note: {
          heading: 'What happens in Grade 10 — the year parents wonder about',
          body: 'Grade 10 is MYP Year 5: the final and most academically demanding year of the Middle Years Programme. The centrepiece is the Personal Project — a self-directed investigation in a topic of your child\'s choosing, resulting in a product, performance, or written study, evaluated against MYP criteria. It is your child\'s first experience of sustained independent academic work. Alongside the Personal Project, Grade 10 includes final MYP subject assessments across all curriculum areas. The year ends with your child academically and intellectually ready to enter the IB Diploma. Think of it as the runway, not a holding pattern.',
        },
      },
      {
        id: 'grade-8',
        label: 'Current Grade 8',
        path: 'Complete MYP, then IGCSE + AP + WSD from Grade 9 onward',
        detail: 'Your child completes MYP through Grade 8, then begins the new pathway: Cambridge IGCSE (Grades 9–10) followed by Advanced Placement and the Woodstock School Diploma in Grades 11–12. This is the bridge cohort — they carry the IB foundation into the new system.',
        timeline: 'MYP Grade 8 (2026). IGCSE Grades 9–10 (2027–29). IGCSE exams May 2029. AP + WSD Grades 11–12 (2029–31).',
        action: 'Your child gets the IB foundation through MYP, then transitions to the new pathway. A strong combination — foundational thinking from MYP, subject mastery from IGCSE, intellectual depth from AP.',
        bridgeNote: {
          heading: 'How Grade 8 prepares your child for IGCSE',
          body: 'Grade 8 is not just the final year of MYP — it is Woodstock\'s deliberate preparation year for Cambridge IGCSE. Teachers in Grade 8 explicitly develop the skills Cambridge tests: structured written responses, source analysis, mathematical reasoning under examination conditions, and subject-specific academic vocabulary. Your child is not walking cold into IGCSE in Grade 9. They are arriving prepared.',
          subjectNote: 'IGCSE subject selection happens in Grade 8. Your child will typically choose 5–7 subjects covering Maths, English, Sciences, and 2–3 electives. This conversation — which subjects, and why — is worth having now. The choices made in Grade 8 shape which AP courses are available in Grades 11–12.',
        },
      },
      {
        id: 'grade-6-7',
        label: 'Current Grades 6–7',
        path: 'Full new pathway from start — Middle School → IGCSE → AP + WSD',
        detail: 'Your child spends Grades 6–8 in Middle School (standards-based), then takes IGCSE in Grades 9–10, and finishes with AP + Woodstock School Diploma in Grades 11–12. This cohort experiences the complete new system from the beginning.',
        timeline: 'Middle School Grades 6–8 (2026–29). IGCSE Grades 9–10 (2029–31). AP + WSD Grades 11–12 (2031–33).',
        action: 'Your child benefits from a curriculum designed for them. Woodstock has offered AP since 1961 and WSD for 60+ years — the IGCSE addition is the only genuinely new element.',
        currentYear: {
          heading: 'What is happening right now in your child\'s classroom',
          body: 'Woodstock\'s Middle School (Grades 6–8) uses a standards-based learning framework — your child receives feedback against clearly defined outcomes (Approaching, Meeting, Exceeding) rather than traditional letter grades. This approach builds genuine understanding and self-awareness rather than grade-chasing. The curriculum covers English, Mathematics, Sciences, Social Studies, Foreign Language, Religious Education, and Physical Education, with outdoor learning woven throughout. By the end of Grade 8, students are well prepared for Cambridge IGCSE\'s external examination demands.',
          whatToWatch: 'At this stage the most important thing is engagement and habit formation. Is your child reading widely? Asking questions rather than waiting for answers? Building study discipline? These foundations matter more right now than any credential. The credentials come later — and they will come more easily if these habits are in place.',
        },
      },
    ],
  },

  cards: [
    {
      id: 'igcse',
      label: 'Cambridge IGCSE · Grades 9–10',
      en: {
        concept: 'What is IGCSE — and is it equivalent to Class 10?',
        concern: 'We chose Woodstock partly for IB. Now it\'s being replaced with something we\'ve never heard of. Are we downgrading?',
        bridge: 'The IGCSE (International General Certificate of Secondary Education) is Cambridge University\'s qualification for ages 14–16. It is taken by over 3 million students in 160+ countries. For Indian families: IGCSE is recognized by the Association of Indian Universities (AIU) as equivalent to Class 10 board exams — CBSE, ICSE, and state boards. It is not less rigorous. It is differently rigorous: where IB\'s MYP emphasizes interdisciplinary thinking, IGCSE emphasizes deep subject mastery and formal external examination in each subject.',
        goal: 'Your child leaves Grade 10 with a formal Cambridge credential in 5–7 core subjects. Universities worldwide — in the UK, US, India, Australia, and beyond — recognize IGCSE exactly as they would a UK GCSE, Indian Class 10 board exam, or American 9th-grade transcript.',
        whatToAsk: [
          'Which subjects will my child take for IGCSE? (Typically: Maths, English, Sciences, and 2–3 electives such as History, Geography, Languages, or Computer Science.)',
          'How do IGCSE grades compare to CBSE/ICSE grades? (IGCSE A* and A are broadly equivalent to CBSE 90%+. The grading scale is A*–G, not percentages.)',
          'Is IGCSE recognized for Indian university entrance? (Yes. AIU recognizes IGCSE as equivalent to Class 10. For JEE/NEET, the subjects taught — Maths, Physics, Chemistry, Biology — overlap significantly.)',
          'If my child struggles in one subject, can they resit IGCSE? (Yes. Students can resit in January or May of the following year.)',
        ],
      },
    },
    {
      id: 'cbse-comparison',
      label: 'Comparing to CBSE / ICSE',
      en: {
        concept: 'How does IGCSE + AP + WSD compare to the Indian board system?',
        concern: 'Indian parents and relatives will ask: why aren\'t you doing CBSE or ICSE?',
        bridge: 'CBSE and ICSE are excellent systems designed for Indian university entry. IGCSE + AP is designed for international university entry — including India\'s top private universities (Ashoka, FLAME, Jindal, Symbiosis). The difference is not quality — it\'s orientation. IGCSE covers similar content to Class 10 CBSE/ICSE, often at greater depth in Sciences and Maths. AP courses are broadly equivalent to first-year university level.',
        goal: 'When your child applies to university, they will have Cambridge IGCSE results (Class 10 equivalent, recognized by AIU), AP scores (Class 12 equivalent, recognized worldwide), and the Woodstock School Diploma (MSA-accredited).',
        whatToAsk: [
          'Will my child be able to apply to IITs or medical colleges? (For JEE/NEET: students can sit these exams with IGCSE — the exams are open to any student who meets eligibility criteria regardless of board.)',
          'Which Indian universities explicitly accept IGCSE + AP? (Ashoka University, FLAME University, OP Jindal Global University, Symbiosis International University, and many others.)',
          'What about the Woodstock School Diploma — does India know what that is? (WSD is MSA-accredited. The IGCSE and AP credentials are the primary academic markers; WSD provides the holistic narrative.)',
        ],
      },
    },
    {
      id: 'ap',
      label: 'Advanced Placement · Grades 11–12',
      en: {
        concept: 'What is Advanced Placement (AP)?',
        concern: 'AP sounds American. Woodstock is international. Will AP be recognized globally?',
        bridge: 'AP (Advanced Placement) is the College Board\'s university-level course programme — the same College Board that administers the SAT. It is taken by 2.5+ million students annually, and 4,000+ universities in 75+ countries accept AP credit. Woodstock has offered AP since 1961. AP is not "American only": it is globally respected because the courses are genuinely university-level.',
        goal: 'Your child takes AP courses (typically 3–5 over Grades 11–12) in subjects they choose. AP exams are scored 1–5, where 3+ is passing. Scores of 4–5 often earn college credit — meaning your child may enter university as a second-semester freshman, saving fees and time.',
        whatToAsk: [
          'Which AP subjects does Woodstock offer? (AP Calculus, Statistics, Biology, Chemistry, Physics, Computer Science, English Language & Literature, History, Geography, Psychology, Economics, Spanish, French, and more.)',
          'How many APs should my child take? (Typically 3–5 over two years. Quality over quantity — a 5 in three subjects is better than a 3 in six.)',
          'Can AP results secure a university place before Grade 12 ends? (Yes — strong AP scores in Grade 11 can earn conditional or unconditional offers from UK universities before Grade 12 even begins.)',
        ],
      },
    },
    {
      id: 'wsd',
      label: 'Woodstock School Diploma · Grades 9–12',
      en: {
        concept: 'What is the Woodstock School Diploma (WSD)?',
        concern: 'I\'ve never heard of it. How will universities know what it means?',
        bridge: 'The Woodstock School Diploma is Woodstock\'s own credential, built over 60+ years of offering a school-based diploma pathway alongside external qualifications. The current formalized 24-credit WSD structure is accredited by the Middle States Association (MSA). This is not a participation certificate — it is a structured, credit-bearing diploma.',
        goal: 'Your child graduates with three credentials: IGCSE (Cambridge), AP course completions (College Board), and the Woodstock School Diploma (MSA-accredited). Together these tell a complete story: subject mastery (IGCSE), intellectual depth (AP), and whole-person development (WSD).',
        whatToAsk: [
          'What are the 24 WSD credits? (Approximately: English 4, Maths 3, Science 3, Social Studies 3, Foreign Language 2, Religious Education 1, PE 1, Outdoor Learning 1, Arts 2, Projects 1, Electives 3. Woodstock will share the full breakdown.)',
          'Can my child choose a domain (pathway) within WSD? (Yes. Woodstock offers pathways in Global Affairs, STEM, Business, Arts, Life Sciences, and Sport.)',
          'Do outdoor expeditions and residential life count toward WSD? (Yes — and this is the point. Outdoor Learning and residential service are built into WSD credits, not extras.)',
        ],
      },
    },
    {
      id: 'university-recognition',
      label: 'University Recognition Worldwide',
      en: {
        concept: 'Will universities recognize IGCSE, AP, and WSD equally to IB?',
        concern: 'Different countries prefer different qualifications. Will my child be at a disadvantage?',
        bridge: 'Universities don\'t prescribe a single qualification — they look at rigor, performance, and fit. IGCSE, AP, and WSD are all recognized and rigorous. Many admissions officers prefer IGCSE + AP over IB because it shows subject mastery (IGCSE) combined with intellectual independence (AP).',
        goal: 'Your child can apply to universities in any country. IGCSE is the international standard for ages 14–16. AP is accepted by 4,000+ universities in 75+ countries. WSD is Woodstock-specific and backed by MSA accreditation.',
        whatToAsk: [
          'Do IGCSE grades directly affect US university admission? (Less than AP does. US universities focus on AP scores. IGCSE is seen as a strong foundation.)',
          'Can AP scores earn a UK university place before Grade 12 exams? (Yes — strong Grade 11 AP scores can result in conditional or unconditional UK offers before Grade 12 begins.)',
          'What about Indian university admissions specifically? (IGCSE is AIU-recognized as Class 10 equivalent. AP is recognized by India\'s top private universities.)',
        ],
      },
    },
    {
      id: 'why-evolve',
      label: 'Why Did Woodstock Evolve Beyond IB?',
      en: {
        concept: 'If IB works, why change?',
        concern: 'This feels like disruption for disruption\'s sake. Woodstock had something good.',
        bridge: 'IB is excellent. Woodstock is not moving away from IB because IB failed — it is moving toward a curriculum that is a better fit for Woodstock\'s specific mission. Woodstock was founded in 1854 as the first international boarding school in India and Asia, and across more than 170 years in the Himalayas the school has reshaped its academic programme many times to serve that founding purpose. The current evolution is consistent with that tradition: over three years, Woodstock\'s faculty and academic leadership consulted admissions officers, IB educators, AP educators, employers, and universities worldwide — with a deliberate phasing designed to mature by the school\'s 175th anniversary in 2029.',
        goal: 'You can trust that this change is purposeful. Woodstock is not switching programmes because it is reacting to a problem. It is proactively building a curriculum that is designed for Woodstock — not an off-the-shelf package.',
        whatToAsk: [
          'Did universities request this change? (No. Woodstock initiated it. The university consultation confirmed the new pathway would be equally or better received.)',
          'Are the teachers ready for the new curriculum? (Yes. Woodstock\'s faculty have been part of this design process. AP teachers are trained and certified through the College Board; IGCSE teachers are trained by Cambridge.)',
          'Is Woodstock losing any accreditation? (No. Woodstock maintains MSA accreditation throughout.)',
        ],
      },
    },
  ],

  scenarios: [
    {
      id: 'score-panic',
      en: {
        title: 'The Grade Comparison Moment',
        termsInPlay: ['IGCSE A*–G', 'AP 1–5', 'IB 1–7'],
        situation: 'Your child gets their first IGCSE result: a "B" in Maths. You panic. In IB, your child was getting 6–7 consistently. Is this a drop? Did the transition cause a regression? You start questioning the whole decision.',
        withUnderstanding: 'You remember: IGCSE and IB use completely different scales. An IGCSE "B" is excellent — broadly equivalent to a 6 in IB. You check the equivalency chart Woodstock provided. You feel relieved. You send a quick message to the teacher to confirm. You move on.',
        withoutUnderstanding: 'You assume grades have dropped. You email the Headmaster asking why your child regressed. You tell other parents "the new curriculum has lower standards." You consider pulling your child out. Misinformation spreads — and none of it was accurate.',
      },
    },
    {
      id: 'flexibility-moment',
      en: {
        title: 'The "I Finally Love School" Conversation',
        termsInPlay: ['IB: 6 required subjects', 'AP: student-chosen depth', 'WSD domain pathways'],
        situation: 'Your child loves Biology and Chemistry but has always struggled with languages. In IB, they\'d have to take a language — it\'s required. In AP + WSD, they don\'t. Your child says: "I finally feel like I can study what I\'m actually good at."',
        withUnderstanding: 'You see this as a strength. Your child specializes earlier and with more ownership. You trust that the combination of IGCSE breadth (Grades 9–10) plus AP choice (Grades 11–12) gives your child both foundation and freedom. The engagement lift is real.',
        withoutUnderstanding: 'You worry that removing the language requirement is "dumbing down" education. You push for a language anyway. Your child resents the pressure. You miss the insight: deep mastery in a chosen area is often more valuable than mediocre breadth.',
      },
    },
    {
      id: 'university-lock-in-moment',
      en: {
        title: 'The Early Admission Window',
        termsInPlay: ['AP as university-level work', 'Grade 11 early offers', 'UK conditional/unconditional'],
        situation: 'Your child finishes Grade 11 with strong AP results: 5 in Calculus, 5 in Chemistry, 4 in Physics. A UK university offers conditional admission in late Grade 11 — before Grade 12 even starts. In IB, this wouldn\'t happen.',
        withUnderstanding: 'You see the advantage clearly. Your child has a place secured. Grade 12 becomes a year of growth, leadership, and confidence — not anxiety. You planned AP choices in Grade 10 specifically to create this window.',
        withoutUnderstanding: 'You assume early offers are unusual or luck. You don\'t realize this is a structural feature of AP. You don\'t plan toward it, so the window passes.',
      },
    },
    {
      id: 'jee-neet-moment',
      en: {
        title: 'The JEE / NEET Question at the Dinner Table',
        termsInPlay: ['IGCSE Science overlap with JEE/NEET', 'AP as Class 12 equivalent', 'Indian competitive exam eligibility'],
        situation: 'Your extended family asks: "If your child isn\'t doing CBSE, how will they sit JEE or NEET?" You don\'t know the answer. You start to wonder if Woodstock has closed off the Indian competitive exam option.',
        withUnderstanding: 'You know that JEE/NEET eligibility is based on having a Class 10 and Class 12 equivalent — not on which specific board you used. IGCSE is AIU-recognized as Class 10. AP is recognized as Class 12 equivalent. Your child can register for JEE/NEET if they meet the subject requirements.',
        withoutUnderstanding: 'You assume IGCSE forecloses JEE/NEET. You either push your child toward CBSE at a different school, or you carry unnecessary anxiety throughout their Woodstock years. The answer was always yes — with the right planning.',
      },
    },
    {
      id: 'predicted-grades-moment',
      en: {
        title: 'The Predicted Grades Meeting',
        termsInPlay: ['IB predicted grades', 'HL subject requirements', 'UK conditional offer'],
        situation: 'Mid-Grade 11, the teacher\'s predicted IB grades arrive. One Higher Level subject is predicted a 4 — below the 5 that your target UK university typically requires. You\'re worried. You start questioning whether your child is on track.',
        withUnderstanding: 'You know that a predicted grade is a snapshot, not a verdict. You book a meeting with the IB coordinator to understand specifically which components are dragging the prediction. Together you make a concrete plan. The Grade 12 mock shows real improvement. The prediction is revised upward.',
        withoutUnderstanding: 'You escalate immediately — emails to the Headmaster, demands that the prediction be revised. The teacher feels pressured rather than supported. Your anxiety transfers to your child at the exact moment they need calm confidence. The prediction doesn\'t change. The relationship with the teacher does.',
      },
    },
  ],

  universityGuide: {
    intro: 'Universities worldwide recognize IGCSE, AP, and WSD. How they weight each credential varies by region — here is what to know for each major destination.',
    destinations: [
      {
        id: 'uk',
        label: 'UK Universities',
        flag: '🇬🇧',
        howIgcse: 'IGCSE is the direct equivalent of UK GCSE. UK universities see it as the standard foundation qualification for ages 14–16 — they know it well, they trust it, and they evaluate it exactly as they would a domestic GCSE.',
        howAp: 'AP is treated as an advanced qualification equivalent to A-levels. Strong AP scores (4–5) can result in conditional or unconditional university offers by the end of Grade 11 — before Grade 12 exams even begin. This is one of the clearest structural advantages AP has over IB.',
        howWsd: 'WSD is Woodstock-specific. UK universities recognize Woodstock\'s institutional reputation. WSD strengthens the personal statement and interview narrative — it shows leadership, residential character, and whole-person development.',
        verdict: 'Your child is well-positioned for UK universities. IGCSE is fully familiar; AP is increasingly preferred over IB by some universities; WSD adds distinction.',
        topTip: 'Have your child research specific universities from Grade 10 onward. Some UK universities explicitly state they prefer AP to IB. Others are AP-agnostic. Knowing this early lets your child plan AP subject choices strategically.',
      },
      {
        id: 'us',
        label: 'US Universities',
        flag: '🇺🇸',
        howIgcse: 'IGCSE is not standard in the US system, but US universities understand and respect it as a rigorous international foundation credential. It is secondary to AP in US admission evaluations, but it demonstrates academic preparation and subject breadth.',
        howAp: 'AP is native to the US system. Strong AP results (4–5) can earn college credit or advanced placement, sometimes reducing college fees and time to degree. For US admissions, AP is the primary academic credential — it carries the most weight.',
        howWsd: 'WSD is recognized at US universities that know Woodstock. US admissions officers at selective universities are often familiar with Woodstock\'s residential reputation. WSD demonstrates leadership, character, and community engagement.',
        verdict: 'Your child is competitive for US universities. AP is the key academic credential; IGCSE provides foundation and breadth; WSD adds the character narrative.',
        topTip: 'If your child aims for top-tier US universities, encourage 4–5 rigorous APs in subjects they genuinely excel at. A 5 in three demanding APs is stronger than a 3 in six average ones.',
      },
      {
        id: 'india',
        label: 'Indian Universities',
        flag: '🇮🇳',
        howIgcse: 'IGCSE is recognized by the Association of Indian Universities (AIU) as equivalent to Class 10 board examinations. Top Indian universities understand IGCSE. Your child\'s IGCSE results will be evaluated comparably to Class 10 results from any major board.',
        howAp: 'AP is less commonly seen in India but is recognized by leading private universities: Ashoka University, FLAME University, OP Jindal Global University, Symbiosis International University, and others. Several offer merit scholarships and course credit on the basis of AP scores of 4–5.',
        howWsd: 'WSD is Woodstock-specific. For top Indian private universities, WSD aligns with their whole-person admissions philosophy. Highlight IGCSE results prominently in Indian university applications — they are immediately understood.',
        verdict: 'Your child is well-positioned for India\'s leading private universities. IGCSE is the strong recognized foundation; AP adds academic depth; WSD adds distinction.',
        topTip: 'For JEE / NEET aspirations: IGCSE Maths and Sciences cover substantial JEE/NEET content. Students who intend to sit these exams should discuss the timeline and additional preparation with Woodstock\'s counselors from Grade 8 onward.',
        watchOut: 'For government university admissions requiring AIU equivalency certificates, your child will need to apply for an AIU equivalency letter for their IGCSE results. Woodstock will support this process, but plan ahead — it takes time.',
      },
      {
        id: 'australia',
        label: 'Australian Universities',
        flag: '🇦🇺',
        howIgcse: 'IGCSE is recognized in Australia as a strong international qualification. Australian universities — especially the Group of Eight — understand and respect IGCSE as a rigorous foundation credential.',
        howAp: 'AP is increasingly accepted at Australian universities. The University of Melbourne, UNSW, ANU, and others explicitly accept AP and may grant credit or advanced standing for scores of 4–5.',
        howWsd: 'WSD is recognized for its rigor. Australian universities value holistic education; WSD aligns well with their admissions philosophy.',
        verdict: 'Your child is competitive for Australian universities. The IGCSE + AP + WSD combination is internationally recognizable and strong.',
        topTip: 'Check individual university requirements from Grade 10. Some Australian universities offer direct AP credit; others require a direct application with full transcripts.',
      },
    ],
  },

  ibUniversityGuide: {
    intro: 'The IB Diploma is one of the world\'s most recognized secondary qualifications. Here is how universities in each major destination read it — and what to know for each system.',
    destinations: [
      {
        id: 'uk',
        label: 'UK Universities',
        flag: '🇬🇧',
        detail: 'UK universities are deeply familiar with IB. Russell Group universities regularly make conditional offers on the basis of predicted IB grades. Typical offers range from 36–40 points for competitive programmes. HL grades in relevant subjects matter significantly — a 6 or 7 in HL subjects related to the degree is expected for selective courses.',
        topTip: 'For UK applications via UCAS, predicted grades in Grade 11 are the basis for conditional offers. A student who understands the HL/SL distinction and performs strongly in Grade 11 assessments will receive stronger predicted grades — and stronger offers.',
      },
      {
        id: 'us',
        label: 'US Universities',
        flag: '🇺🇸',
        detail: 'US universities understand IB well. A full IB Diploma with a strong total (38+) is a powerful application signal. Many US universities grant credit for HL subjects where a grade of 5, 6, or 7 was achieved. The Extended Essay and TOK are valued in applications for demonstrating intellectual curiosity.',
        topTip: 'Lead with the IB Diploma total in US applications. Also highlight the Extended Essay topic — for US liberal arts colleges specifically, a strong EE topic in a genuine area of passion is a significant differentiator.',
      },
      {
        id: 'india',
        label: 'Indian Universities',
        flag: '🇮🇳',
        detail: 'India\'s leading private universities — Ashoka, FLAME, OP Jindal, KREA — recognize IB Diploma. Most evaluate the total score and HL subject grades for admissions and merit scholarships. For government university admissions, an equivalency certificate from AIU is typically needed.',
        topTip: 'IB students at Woodstock earn WSD alongside IB with no additional work. Include both credentials in Indian university applications — WSD adds a whole-person narrative that strengthens applications at holistic-admissions universities.',
      },
      {
        id: 'australia',
        label: 'Australian Universities',
        flag: '🇦🇺',
        detail: 'Australian universities recognize IB Diploma and convert IB scores to ATAR equivalents for admissions purposes. A score of 36–38 typically equates to a strong ATAR. Group of Eight universities (Melbourne, ANU, UNSW, etc.) have published IB-to-ATAR conversion tables.',
        topTip: 'Check each university\'s published IB-to-ATAR conversion table from Grade 10 — they vary significantly between institutions and can help your child set realistic score targets.',
      },
    ],
  },

  studentTransition: {
    headline: 'What this means for your child — not just the paperwork',
    intro: 'The credential change is the official story. Here is the lived experience — what actually changes for students, and where the genuine wins are.',
    wins: [
      {
        id: 'freedom-to-specialize',
        title: 'They study what they\'re actually good at',
        icon: '🌱',
        detail: 'IB requires six prescribed subjects across specific groups. AP does not. In Grades 11–12, your child chooses which subjects to study at university level. If they are strong in Sciences and want to specialize, they can take three or four Science APs. For many students, this shift from "do everything" to "go deep in what you love" is transformative.',
      },
      {
        id: 'real-university-work',
        title: 'AP courses are genuinely university-level',
        icon: '📜',
        detail: 'AP courses are not "like" university courses — they are university courses, recognized by the College Board and taught to a standard that earns college credit at 4,000+ institutions. A student who scores 5 in AP Calculus has demonstrated proficiency equivalent to first-year university calculus.',
      },
      {
        id: 'early-admission-window',
        title: 'They can have a university place before Grade 12 exams',
        icon: '🗝️',
        detail: 'AP exams happen at the end of each academic year (May). A student who performs strongly in Grades 10–11 can accumulate AP scores that UK universities evaluate for conditional or unconditional offers — before Grade 12 begins. This structural advantage does not exist in IB.',
      },
      {
        id: 'igcse-clear-foundation',
        title: 'Cambridge IGCSE gives clear, external validation',
        icon: '🪨',
        detail: 'IGCSE exams are external, subject-specific, and graded by Cambridge. Every grade (A*–G) is externally verified and internationally comparable. Students finish Grade 10 with a Cambridge credential in hand, having proven themselves against an international standard, before the higher-stakes AP years begin.',
      },
      {
        id: 'woodstock-dna-credited',
        title: 'Woodstock\'s outdoor and residential life formally counts',
        icon: '🏔️',
        detail: 'In WSD, Outdoor Learning is a formal credit. Senior and Junior Projects are formal credits. The residential, service, and leadership dimensions of Woodstock life are built into the diploma — not added on top. The things students love most about Woodstock become part of their academic record.',
      },
      {
        id: 'distributed-assessment',
        title: 'Assessment is spread across years — not one high-stakes season',
        icon: '🛤️',
        detail: 'AP assessment is cumulative: IGCSE exams in May of Grade 10, then AP exams each May from Grades 10–12. Performance builds year by year. If a student has a difficult exam period one year, they have more opportunities. For students who experience anxiety around high-stakes testing, this distributed model is meaningfully better for wellbeing.',
      },
      {
        id: 'pathway-identity',
        title: 'They graduate with a clear identity and direction',
        icon: '🧭',
        detail: 'WSD\'s domain pathways (Global Affairs, STEM, Business, Arts, Life Sciences, Sport) give students a framework for making coherent choices across Grades 9–12. By the time they apply to university, their application tells a coherent story — not a checklist.',
      },
    ],
    studentVoice: {
      prompt: 'What would a current student tell a Grade 8 student about the new pathway?',
      response: 'You will take harder Maths than your CBSE friends in India and your GCSE friends in the UK — but it will make you genuinely stronger. By Grade 11, you will be doing real university-level work. The expeditions and outdoor learning are not in addition to your academics — they are part of your diploma. And if you plan your APs carefully, you might have a university place before your final year even starts.',
    },
  },

  igcseDeepDive: {
    headline: 'IGCSE: Grades, Transcripts & University Impact',
    gradingScale: {
      heading: 'How IGCSE grades work',
      explanation: 'IGCSE uses a letter scale from A* (highest) to G (lowest passing grade). There is no percentage score on the certificate — only the letter grade. Cambridge sets grade boundaries after each exam session based on the global cohort.',
      grades: [
        { grade: 'A*', label: 'Exceptional', description: 'Mastery beyond the A standard. Roughly equivalent to IB 7, CBSE 90%+, US A+.', color: '#5B3A8C' },
        { grade: 'A',  label: 'Excellent',   description: 'Strong command of the subject. Roughly equivalent to IB 6–7, CBSE 80–89%, US A.', color: '#5B3A8C' },
        { grade: 'B',  label: 'Very Good',   description: 'Confident performance. Roughly equivalent to IB 5–6, CBSE 70–79%, US B+/A-.', color: '#1D9E75' },
        { grade: 'C',  label: 'Good',        description: 'Solid pass. Most universities consider C the minimum for core subjects. Roughly equivalent to IB 4–5, CBSE 60–69%.', color: '#1D9E75' },
        { grade: 'D',  label: 'Satisfactory', description: 'A passing grade. Generally not competitive for selective university admissions in core subjects.', color: '#C45C26' },
        { grade: 'E',  label: 'Acceptable',   description: 'A passing grade at the lower end. Sufficient for the IGCSE certificate but weak for competitive admissions.', color: '#C45C26' },
        { grade: 'F–G', label: 'Passing (lowest)', description: 'Technically passing. Very rare at Woodstock. Not competitive for university admissions.', color: '#999' },
        { grade: 'U',  label: 'Ungraded',    description: 'Not awarded a grade. Extremely rare.', color: '#bbb' },
      ],
      targetNote: 'At Woodstock, the target range for university-bound students is A*–B in core subjects (Maths, English, Sciences) and A*–C in electives.',
    },
    woodstockSubjects: {
      heading: 'IGCSE subjects at Woodstock',
      note: 'Students typically take 5–7 IGCSE subjects. Confirm the current offering directly with Woodstock — the list below is indicative.',
      core: ['Mathematics', 'English Language', 'English Literature', 'Biology', 'Chemistry', 'Physics'],
      electives: ['History', 'Geography', 'Economics', 'Computer Science', 'French', 'Spanish', 'Hindi', 'Art & Design', 'Music', 'Physical Education'],
      choiceNote: 'IGCSE subject choice in Grade 8–9 directly shapes which AP courses are available in Grades 11–12. Plan with Woodstock\'s counselors.',
    },
  },

  apDeepDive: {
    headline: 'AP at Woodstock: Courses, Scores & College Credit',
    scoringScale: {
      heading: 'How AP scores work',
      scores: [
        { score: 5, label: 'Extremely Well Qualified', description: 'The highest score. Most universities grant full credit for a 5. The target for university-bound students in their strongest subjects.', color: '#5B3A8C' },
        { score: 4, label: 'Well Qualified',           description: 'Many universities grant credit for a 4. For UK universities, a 4 is typically competitive for conditional or unconditional offers.', color: '#1D9E75' },
        { score: 3, label: 'Qualified',                description: 'Passing score. Some universities grant credit for a 3; others require a 4 or 5.', color: '#1D9E75' },
        { score: 2, label: 'Possibly Qualified',       description: 'Below the threshold for most credit awards.', color: '#C45C26' },
        { score: 1, label: 'No Recommendation',        description: 'Does not earn credit. Students can choose whether to report this score on applications.', color: '#C45C26' },
      ],
    },
    woodstockOfferings: {
      heading: 'AP courses offered at Woodstock',
      note: 'Woodstock has offered AP since 1961. Confirm the current subject list directly with Woodstock.',
      subjects: [
        { area: 'Mathematics', courses: ['AP Calculus AB', 'AP Calculus BC', 'AP Statistics'] },
        { area: 'Sciences', courses: ['AP Biology', 'AP Chemistry', 'AP Physics 1', 'AP Physics C: Mechanics', 'AP Environmental Science'] },
        { area: 'Computer Science', courses: ['AP Computer Science A', 'AP Computer Science Principles'] },
        { area: 'English', courses: ['AP English Language & Composition', 'AP English Literature & Composition'] },
        { area: 'Social Sciences', courses: ['AP World History', 'AP Human Geography', 'AP Psychology', 'AP Economics (Macro)', 'AP Economics (Micro)'] },
        { area: 'Languages', courses: ['AP Spanish Language', 'AP French Language'] },
        { area: 'Arts', courses: ['AP Art History', 'AP Music Theory'] },
      ],
    },
    earlyOfferSteps: [
      { step: 1, title: 'Grade 10: Take first AP(s)', detail: 'Some students sit AP Calculus or CS in Grade 10. Strong results give a one-year head start on the AP profile.' },
      { step: 2, title: 'Grade 11: Sit 2–3 major APs', detail: 'The core AP session — typically Sciences, Maths, and one humanities subject. Results arrive July of Grade 11.' },
      { step: 3, title: 'July–October Grade 11: UK universities evaluate', detail: 'UK universities receive AP scores via UCAS. Some make conditional or unconditional offers based on Grade 11 AP results alone.' },
      { step: 4, title: 'Grade 12: Additional APs strengthen the profile', detail: 'Students may take 1–2 additional APs. The core admission offer may already be secured.' },
      { step: 5, title: 'Graduate with IGCSE + AP + WSD', detail: 'Cambridge IGCSE certificate (Grade 10), AP score reports (annual), Woodstock School Diploma (graduation). Three documents, every university.' },
    ],
  },

  ibProgramme: {
    headline: 'The IB Diploma Programme — what it is and how it works',
    intro: 'Your child is completing one of the world\'s most respected secondary qualifications. Understanding how it is structured — and what each component actually demands — helps you support them through it with confidence rather than anxiety.',
    overview: {
      heading: 'What the IB Diploma actually is',
      body: 'The International Baccalaureate Diploma Programme (IBDP) is a two-year qualification taken in Grades 11 and 12. Students study six subjects simultaneously across different disciplines, plus three core requirements. It is externally assessed — exams are written in May of Grade 12, marked by IB examiners worldwide, not by Woodstock teachers. The maximum score is 45 points. A score of 24 or above passes; most university-bound students aim for 32–38.',
    },
    subjectGroups: [
      { group: 'Group 1', label: 'Studies in Language & Literature', example: 'English A: Literature or Language & Literature', detail: 'Develops literary analysis, close reading, and academic writing.' },
      { group: 'Group 2', label: 'Language Acquisition', example: 'Hindi B, Spanish B, French B (or Ab Initio)', detail: 'A second language at B (intermediate) or Ab Initio (beginner) level.' },
      { group: 'Group 3', label: 'Individuals & Societies', example: 'History, Geography, Economics, Psychology, Global Politics', detail: 'A humanities or social science subject at university-level depth.' },
      { group: 'Group 4', label: 'Sciences', example: 'Biology, Chemistry, Physics, Environmental Systems', detail: 'A laboratory science, assessed through experiments, investigation, and written exams.' },
      { group: 'Group 5', label: 'Mathematics', example: 'Mathematics: Analysis & Approaches or Applications & Interpretation', detail: 'Two routes: AA (abstract, algebra-heavy) and AI (applied, statistics-heavy). The choice has significant implications for university options.' },
      { group: 'Group 6', label: 'The Arts (or a second subject)', example: 'Visual Arts, Music, Theatre — or an additional subject from Groups 1–4', detail: 'Students can take an arts subject or substitute a second subject from Groups 1–4.' },
    ],
    hlSlNote: 'Three subjects are taken at Higher Level (HL) — roughly first-year university depth — and three at Standard Level (SL). Subject choices and HL/SL decisions are the most consequential academic decisions of the IB years.',
    core: [
      {
        title: 'Extended Essay (EE)',
        icon: '📄',
        detail: 'A 4,000-word independent research essay in a subject of the student\'s choosing. The EE is the closest thing to a university research paper available at secondary level. Students begin in Grade 11 and submit in Grade 12.',
        parentNote: 'The EE often becomes the basis for university personal statements. A strong EE demonstrates that your child has something genuine to say — not just academic ability.',
      },
      {
        title: 'Theory of Knowledge (TOK)',
        icon: '🧠',
        detail: 'A 1,600-word essay and a class presentation exploring how we know what we know across different disciplines. TOK contributes up to 3 bonus points to the final IB score, and a failing grade can prevent Diploma award regardless of subject scores.',
        parentNote: 'The students who perform best are those who engage with it genuinely rather than treating it as a box to check. Encouraging your child to take the TOK questions seriously in conversation is one of the most valuable things you can do.',
      },
      {
        title: 'CAS — Creativity, Activity, Service',
        icon: '🏔️',
        detail: 'CAS requires a sustained programme of creative projects, physical activity, and community service throughout Grades 11 and 12. At Woodstock, CAS is one of the most naturally fulfilled IB requirements: the mountain expeditions, residential service, outdoor learning, and arts programme mean students are doing CAS continuously.',
        parentNote: 'Woodstock\'s outdoor programme means CAS is built into daily life in a way it is not at most IB schools. The WSD Outdoor Learning and Service credits overlap with CAS requirements — your child earns both simultaneously.',
      },
    ],
    scoring: {
      heading: 'How IB scores work',
      scale: 'Each of the six subjects is scored 1–7 by IB examiners. Maximum from subjects is 42. The EE and TOK together contribute up to 3 bonus points, giving a maximum total of 45.',
      benchmarks: [
        { range: '40–45', label: 'Exceptional', detail: 'Top 5% globally. Competitive for Oxford, Cambridge, Ivy League, and the most selective programmes worldwide.' },
        { range: '36–39', label: 'Very strong', detail: 'Competitive for Russell Group, top US liberal arts, leading Indian private universities.' },
        { range: '32–35', label: 'Solid', detail: 'Competitive for most universities in the UK, US, India, and Australia. Most Woodstock students aim in this range.' },
        { range: '28–31', label: 'Acceptable', detail: 'Passes the Diploma. Some university options may be limited at the most selective end.' },
        { range: '24–27', label: 'Minimum pass', detail: 'Diploma awarded. University counseling is important to identify the right fit applications.' },
        { range: 'Below 24', label: 'Diploma not awarded', detail: 'A certificate for individual subject results is issued. Individual subject results still have value for many universities.' },
      ],
    },
  },

  nextSteps: [
    // 0 — all grades
    'Go to "Your Child\'s Pathway" and find your child\'s grade cohort. Read the timeline carefully — it tells you exactly when each programme begins, what credential they graduate with, and whether anything is changing for them right now.',
    // 1 — new pathway (6-8)
    'Go to "University Guide" and select your most likely destination. Read what IGCSE and AP mean there specifically — not in general, but in that system.',
    // 2 — grade 8
    'For Grade 8 parents: talk to your child about IGCSE subject choices before Grade 9. They will typically take 5–7 subjects covering Maths, English, Sciences, and 2–3 electives. Early conversations help them choose subjects that align with their AP plans in Grades 11–12.',
    // 3 — Indian families
    'For families with Indian university options in mind: email academics@woodstockschool.in and ask specifically about the AIU equivalency process for IGCSE, and which Indian universities have confirmed AP recognition. Get this documented early.',
    // 4 — grade 6-7
    'For Grade 6–7 parents: the credential conversation can wait. What matters now is whether your child is engaged, curious, and building strong habits in Middle School.',
    // 5 — protection reminder (9-12)
    'If your child is in Grades 9–12: they complete IB as planned. Nothing changes. Re-read the protection principle in "Your Child\'s Pathway" if you have any doubt.',
    // 6 — contact
    'If you have questions specific to your child\'s circumstances: email academics@woodstockschool.in with your child\'s name and current grade. Counselors can walk through the specifics with you.',
    // 7 — grade 9: HL/SL
    'Start the HL and SL subject conversation before the end of Grade 10. The IB Diploma requires three Higher Level subjects and three Standard Level subjects — choosing them thoughtfully is one of the most consequential decisions of their Woodstock years.',
    // 8 — grade 9: Personal Project
    'In Grade 10, your child will complete the MYP Personal Project — a self-directed investigation in a topic of their choosing. Encourage them to treat it seriously. A strong Personal Project is direct preparation for the IB Extended Essay in Grade 11.',
    // 9 — grade 10: prep
    'Before Grade 11 begins, ask Woodstock\'s IB coordinator for a copy of the IB subject guide for each of your child\'s intended HL subjects. Reading the first two pages gives you a realistic picture of what university-level study in that subject looks like.',
    // 10 — grade 11-12: support
    'Ask the IB coordinator specifically: what does Woodstock\'s IB support structure look like in Grade 12? Which revision resources are provided, how are mock exams run, and how are predicted grades determined?',
  ],

  feedbackCta: {
    text: 'Questions not answered here?',
    email: 'academics@woodstockschool.in',
    cta: 'Email the academic office',
  },
}
