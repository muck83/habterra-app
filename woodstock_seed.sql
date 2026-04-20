-- ══════════════════════════════════════════════════════════════════════
-- Woodstock Curriculum Transition — Calibrate Seed
-- Project: gapmcwpttlramjmdiybu
-- Run this in the Supabase SQL Editor (paste all at once)
-- ══════════════════════════════════════════════════════════════════════

-- ── SECTION A: Profile fix ────────────────────────────────────────────
-- Ensures marktcrowell@gmail.com is admin at NLIS Riyadh

DO $$
DECLARE
  v_school_id uuid;
  v_user_id   uuid;
BEGIN
  SELECT id INTO v_school_id FROM schools WHERE domain = 'nlis.edu.sa' LIMIT 1;
  SELECT id INTO v_user_id   FROM auth.users WHERE email = 'marktcrowell@gmail.com' LIMIT 1;

  IF v_user_id IS NULL THEN
    RAISE NOTICE 'User not found — skipping profile fix';
  ELSIF v_school_id IS NULL THEN
    RAISE NOTICE 'School nlis.edu.sa not found — skipping profile fix';
  ELSE
    UPDATE profiles
    SET full_name = 'Mark Crowell',
        role      = 'admin',
        school_id = v_school_id,
        email     = 'marktcrowell@gmail.com'
    WHERE id = v_user_id;
    RAISE NOTICE 'Profile updated: Mark Crowell, admin, NLIS Riyadh';
  END IF;
END $$;

-- ── SECTION B: Add Woodstock School ──────────────────────────────────

INSERT INTO schools (name, domain)
VALUES ('Woodstock School', 'woodstockschool.in')
ON CONFLICT (domain) DO NOTHING;

-- ── SECTION C: Woodstock PD Module ───────────────────────────────────
-- country_code 'WS' = Woodstock School (not a country — used as a school key)

INSERT INTO pd_modules (id, country_code, title, tagline, research_backbone, hofstede_data, completion_threshold, unlock_reward, status)
VALUES (
  'woodstock-001',
  'WS',
  'Woodstock Curriculum Transition',
  'IGCSE, AP, and WSD — what the transition means for every cohort, and how to talk about it',
  '[]'::jsonb,
  '{}'::jsonb,
  80,
  'Woodstock transition guide — counselor edition',
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title              = EXCLUDED.title,
  tagline            = EXCLUDED.tagline,
  status             = EXCLUDED.status;

-- ── SECTION D: Dimensions (max 6, constraint enforced by schema) ──────

INSERT INTO pd_dimensions (module_id, dimension_number, title, research_status, content) VALUES

  -- 1. The Transition
  ('woodstock-001', 1, 'The Transition — Why and What', 'community',
    $${"summary":"Woodstock is moving from the International Baccalaureate to a framework combining IGCSE, Advanced Placement, and the Woodstock School Diploma. This is a deliberate, phased change — not an emergency, and not a retreat from rigour. Understanding the full picture is the foundation for every parent conversation.","sections":[{"heading":"Why Woodstock is transitioning","items":["The IB curriculum constrains subject choice in ways that limit flexibility at Grade 11 — particularly for students with strong STEM or arts focus","IB's recognition for JEE and NEET eligibility has caused genuine concern among Indian families, who form a large share of the school's community","Advanced Placement offers over 38 subjects with more granular university credit, and early conditional university offers are possible in Grade 11","The Woodstock School Diploma (WSD) credentials the school's distinctive outdoor education, service, and interdisciplinary programs — something IB doesn't accommodate","The transition positions Woodstock ahead of a global shift toward multi-credential frameworks"]},{"heading":"What the new pathway looks like","items":["Middle School (Grades 6–8): Standards-based learning. No external exams. Habits of mind and preparation for Cambridge IGCSE.","Grades 9–10: IGCSE examinations in 5–7 subjects. Cambridge-assessed, externally moderated, globally recognized.","Grades 11–12 (new pathway): AP courses + Woodstock School Diploma. Students sit 3–5 AP exams.","IB Diploma (existing students only): Grade 11–12 students who enrolled under IB continue and complete IB Diploma as planned."]},{"heading":"The 4-year phased timeline","items":["Year 1 (now): Grades 6–8 begin the new IGCSE pathway. Grade 11–12 complete IB Diploma as planned.","Year 2: First cohort of IGCSE students reaches Grade 10 exams.","Year 3: First cohort enters Grade 11 on the AP + WSD pathway.","Year 4: Last IB Diploma cohort graduates. Woodstock is fully on the new framework.","Key principle: No student is switched mid-stream. Every cohort completes the credential they started."]},{"heading":"Language to use and avoid","items":["Use: 'Woodstock is evolving its curriculum to give students more flexibility and stronger global pathways.'","Avoid: 'We are dropping IB' — Woodstock is not dropping IB for any currently enrolled student","Avoid: 'switching' — this implies disruption that isn't happening. The transition is cohort-based.","Use: 'Your child's cohort will complete [specific pathway].' Personalized language reduces anxiety."]}],"citations":[]}$$::jsonb),

  -- 2. The Five Cohorts
  ('woodstock-001', 2, 'The Five Cohorts — Who Sees What', 'community',
    $${"summary":"Not every family is affected the same way. The transition is structured around five cohort groups based on current grade. Conflating cohorts is the single most common source of unnecessary parent alarm — staff must know these precisely.","sections":[{"heading":"The cohort map","items":["Grades 6–7 → Full new pathway. IGCSE starting Grade 9. Then AP + WSD in Grades 11–12. No IB exposure.","Grade 8 → Bridge cohort. Currently in MYP Year 3. IGCSE subject selection happens in Grade 8 (5–7 subjects). Enters IGCSE exams in Grade 10.","Grade 9 → Last IB cohort. Completing MYP Years 4–5, then IB Diploma in Grades 11–12. Grade 10 = Personal Project year.","Grade 10 → Enters IB Diploma in Grade 11 as always planned. Nothing has changed.","Grades 11–12 → Completing IB Diploma. Exams in May 2026 (Grade 12) and May 2027 (Grade 11 current). Nothing changes."]},{"heading":"Grade 8 — the critical hinge year","items":["Grade 8 is deliberately designed as an IGCSE preparation year, not a transition year","MYP inquiry and research skills map directly onto Cambridge IGCSE demands — the shift is in form (external exams), not intellectual rigour","IGCSE subject selection happens in Grade 8: families choose 5–7 subjects from Woodstock's IGCSE offering","JEE/NEET-aspirant families must select PCM (Physics, Chemistry, Math) or PCB (Physics, Chemistry, Biology) at this point"]},{"heading":"The 'Grade 10 mystery' for Grade 9 parents","items":["Grade 10 (for current Grade 9 students) = MYP Year 5","MYP Year 5 culminates in the Personal Project: a self-directed investigation chosen entirely by the student","The Personal Project is direct preparation for the IB Extended Essay in Grade 11","Message for Grade 9 parents: 'Grade 10 is one of the most meaningful years in MYP. Your child leads their own research project — genuine preparation for Grade 11.'"]},{"heading":"What staff must never do","items":["Never conflate cohorts in a parent conversation — a Grade 8 and a Grade 11 parent need completely different answers","Never tell a Grade 11–12 family that 'things are changing' — for them, nothing is changing","Never speculate about future cohort changes beyond what has been formally communicated by the Head of School","If unsure which cohort applies to a specific student, check the counselor database before the meeting"]}],"citations":[]}$$::jsonb),

  -- 3. IGCSE — The Cambridge Qualification
  ('woodstock-001', 3, 'IGCSE — The Cambridge Qualification', 'community',
    $${"summary":"IGCSE (International General Certificate of Secondary Education) is a globally recognized qualification from Cambridge Assessment International Education. Understanding how it is graded — and how to explain that grading to Indian families accustomed to CBSE percentages — is essential preparation for every staff member.","sections":[{"heading":"What IGCSE is","items":["Developed and assessed by Cambridge University Press & Assessment","Taken in approximately 160 countries; over 500,000 students globally sit IGCSE each year","Students typically sit 5–7 subjects at end of Grade 10 as external examinations","Each subject is assessed independently — there is no 'pass the whole thing or fail' requirement","IGCSE sits at the same level as UK GCSEs and is the standard pre-A-level qualification worldwide"]},{"heading":"How IGCSE is graded","items":["A* — Outstanding. Top 5–10% of candidates globally. Equivalent to 90%+ performance.","A — Excellent. Top 15–20%. Equivalent to 80–89%.","B — Good. Equivalent to 70–79%. A strong result for most university pathways.","C — Satisfactory. Equivalent to 60–69%. Broadly considered the minimum for university consideration.","D, E, F, G — Below C. Not typically sufficient for university entry.","Grades are NOT reported as percentages — families accustomed to CBSE or ICSE systems need explicit calibration."]},{"heading":"The grading conversation with Indian families","items":["An Indian family seeing 'B' may interpret this as 60–70% — a CBSE-scale reading that undersells the result","A B on IGCSE represents 70–79% performance among an international candidate pool — a strong outcome","The conversation to have: 'Cambridge grades are not percentages. A B is what Cambridge calls a Good pass — equivalent to what CBSE would show as 75–80%.'","Do not simply reassure — show the grading scale. Visual calibration is more convincing than verbal explanation.","Brief families on grading expectations BEFORE results arrive, not after."]},{"heading":"University recognition of IGCSE","items":["UK: IGCSE is the direct predecessor to A-levels. UK universities understand it fluently.","US: IGCSE signals strong academic preparation. AP scores are the primary US university currency.","India — JEE/NEET: IGCSE qualifies as the 10th board exam, provided student has taken the required science subjects.","India — Private universities: Ashoka, FLAME, OP Jindal, Symbiosis recognize IGCSE and offer merit pathways.","Australia: Recognized through international student admission processes."]}],"citations":[]}$$::jsonb),

  -- 4. AP and WSD
  ('woodstock-001', 4, 'AP and the Woodstock School Diploma', 'community',
    $${"summary":"Advanced Placement (AP) replaces IB subject courses for new-pathway students. The Woodstock School Diploma (WSD) sits alongside both IB and AP as an additional credential recognizing what makes Woodstock distinctive. Staff must understand both well enough to explain them to any parent.","sections":[{"heading":"What AP is","items":["College Board program — the same organization behind the SAT and PSAT","Over 38 subjects available; external examinations held each May, scored 1–5","AP courses are university-level — students learn at the standard of a first-year university course","Woodstock offers approximately 16–18 AP subjects across STEM, Humanities, Languages, and Arts"]},{"heading":"The 1–5 scoring scale","items":["5 — Extremely well qualified. College credit nearly certain. Top ~15% of candidates.","4 — Well qualified. College credit at most selective universities.","3 — Qualified. The benchmark for credit at the majority of US colleges. A solid result.","2 — Possibly qualified. Does not typically earn credit.","1 — No recommendation.","Woodstock target: all students aiming for 3+ in chosen AP subjects."]},{"heading":"AP vs. IB — the subject choice difference","items":["IB requires 6 subjects across 6 prescribed groups: students have limited choice within each group","AP allows students to choose any combination of subjects — a STEM-focused student can take 4 science APs without being forced into Humanities or Languages","This is particularly valuable for students with strong STEM or Arts profiles","Framing for parents: AP is not a lesser version of IB — it is a more flexible credential that rewards depth of focus"]},{"heading":"What WSD is","items":["A Woodstock-designed credential that recognizes academic, service, and experiential learning unique to the school","Awarded alongside IGCSE + AP — it is an additional credential, not a replacement","24 credits earned across six domain pathways over Grades 9–12","IB students earn WSD automatically: CAS maps to Outdoor Learning/Service credits; Extended Essay maps to Senior Project credit","Two credentials, no duplication of effort: IB Diploma AND WSD at graduation"]}],"citations":[]}$$::jsonb),

  -- 5. University Recognition
  ('woodstock-001', 5, 'University Recognition by Region', 'community',
    $${"summary":"One of the most common parent concerns is whether IGCSE and AP are 'as good as' IB for university admission. In most markets, IGCSE + AP is equally or more flexible than IB Diploma. Staff need to be able to explain this by region — not in general terms.","sections":[{"heading":"UK universities","items":["IGCSE is the direct equivalent of GCSEs — UK universities understand it fluently","AP is recognized by UCAS as equivalent to A-levels for points calculation","Oxford, Cambridge, Imperial, LSE: all have stated AP recognition policies","A student with IGCSE A*/A in core subjects + AP 4–5 in relevant subjects is a strong UK applicant","For medicine (UK): IGCSE + AP Chemistry/Biology is accepted; verify UCAT and BMAT requirements separately"]},{"heading":"US universities","items":["AP was designed for the US system — it is the strongest possible preparation for US college applications","Common App fully supports AP transcripts and AP score reporting","Over 4,000 US colleges award credit for scores of 3+","Students with strong AP scores can enter US universities as sophomores, saving a full year of tuition","Early conditional offers from US colleges based on Grade 11 AP scores are a real advantage over IB"]},{"heading":"Indian universities — JEE and NEET","items":["JEE Main and JEE Advanced: IGCSE qualifies as the 10th board examination, provided student has taken Physics, Chemistry, and Mathematics","NEET: IGCSE qualifies, provided student has taken Physics, Chemistry, and Biology","The counselor's role: ensure JEE/NEET-aspirant families select correct IGCSE subjects in Grade 8","Wrong subject selection at IGCSE can disqualify a student from JEE/NEET — this is critical","Private universities: Ashoka, FLAME, OP Jindal, Symbiosis offer merit scholarships for AP — confirm current policies"]},{"heading":"Australian and Canadian universities","items":["Australia: Strong international student pathways recognize IGCSE; AP scores used via faculty-direct assessment","Canada: McGill, UoT, UBC recognize AP for credit and advanced standing","For both markets: IGCSE + AP 3–5 is a competitive application profile","Direct families to each university's international student admission page — policies vary by faculty"]},{"heading":"What counselors must not say","items":["Do not promise specific credit outcomes — verify with institutions first","Do not compare IB and AP/IGCSE as if one is universally better — they serve different markets","Do not speculate about future university policy changes","Do say: 'IGCSE + AP is a well-traveled, globally recognized pathway. Here is how specific universities read it.'"]}],"citations":[]}$$::jsonb),

  -- 6. Difficult Conversations
  ('woodstock-001', 6, 'Difficult Conversations — The Five Scenarios', 'community',
    $${"summary":"The five most common parent anxiety scenarios at Woodstock, and how to respond to each with clarity and calm. This dimension is designed to prepare staff for PTMs and informal hallway conversations where these questions actually arise.","sections":[{"heading":"Scenario 1 — The Score Panic","items":["Parent says: 'My child got a B in IGCSE. That's bad, isn't it?'","What's happening: Parent is reading Cambridge grades through a CBSE percentage lens","What to say: 'B on IGCSE represents 70–79% performance among a global candidate pool. Let me show you how universities read the scale.'","Key move: Show the A*–G grading chart. Visual calibration beats verbal reassurance.","Prepare before results: Brief families on grading expectations at the START of IGCSE, not when results arrive."]},{"heading":"Scenario 2 — The Subject Freedom Question","items":["Parent says: 'Can my child still choose their own subjects?'","What's happening: Parent assumes AP is as constrained as IB's six-group structure","What to say: 'AP gives your child significantly more choice than IB. They can select from 16+ subjects based on their interests and university goals.'","Key move: Frame AP as an upgrade in flexibility, not a compromise. Lead with the student's benefit."]},{"heading":"Scenario 3 — The University Lock-In Worry","items":["Parent says: 'If my child does AP, will they only get into US universities?'","What's happening: Mistaken belief that AP is a US-only credential","What to say: 'AP is recognized by universities in the UK, India, Australia, and Canada. Oxford and Cambridge have formal AP recognition policies.'","Key move: Lead with the UK example — UK recognition defuses this concern fastest."]},{"heading":"Scenario 4 — The JEE/NEET Eligibility Question","items":["Parent says: 'Can my child still write JEE or NEET with IGCSE?'","What's happening: Genuine eligibility concern — JEE/NEET regulations specify a recognized 10th board","What to say: 'Yes. IGCSE qualifies — provided your child takes Physics, Chemistry, and Mathematics (JEE) or Biology and Chemistry (NEET) at IGCSE. We'll build this into their subject selection.'","Key move: Give the definitive yes first, then explain the condition. Hedging the yes causes panic.","Critical action: For JEE/NEET families in Grade 8, confirm subject selection with the academic counselor this term."]},{"heading":"Scenario 5 — IB Predicted Grades Anxiety","items":["Parent says: 'My IB child's predicted grades feel high-stakes and teacher-dependent. How does Woodstock manage this?'","What's happening: IB predicted grades are submitted with UCAS applications and can make or break UK offers","What to say: 'Woodstock has a structured prediction process. Teachers submit predictions, which are reviewed and moderated by the IB Coordinator. Predicted grades reflect trajectory, not a single moment.'","Key move: Separate the institutional process from the individual anxiety. Explain the safeguards without promising specific outcomes.","Refer if needed: If the parent wants to discuss a specific teacher's prediction, refer to the IB Coordinator."]}],"citations":[]}$$::jsonb)

ON CONFLICT (module_id, dimension_number) DO UPDATE SET
  title           = EXCLUDED.title,
  research_status = EXCLUDED.research_status,
  content         = EXCLUDED.content;

-- ── SECTION E: Scenarios (pd_scenarios table) ─────────────────────────

INSERT INTO pd_scenarios (module_id, title, setup, common_misread, actual_dynamic, response_framework, dimension_tags, source_type, status)
VALUES

  ('woodstock-001', 'The Score Panic',
   'A Grade 9 parent contacts you after IGCSE mock results. Her daughter received a B in English — the parent is very upset, reading it as equivalent to a 65% CBSE score. The parent says she is considering pulling her daughter out of Woodstock.',
   'The student has underperformed and something is wrong.',
   'The parent is calibrating Cambridge grades against a CBSE percentage scale. B on IGCSE = 70–79% performance in a global cohort — a strong result. This is a communication failure that needs to be corrected before the meeting ends.',
   '["Acknowledge the parent''s concern without agreeing that the grade is bad","Show the Cambridge A*–G grading scale — visual calibration works faster than verbal explanation","Explain: B = 70–79% performance in a global cohort, not 65% CBSE","Note that mock grades are also formative and that the student has time to improve before final exams","If genuine academic concern exists separately, schedule a follow-up with the subject teacher"]'::jsonb,
   '{3}'::integer[], 'community_submitted', 'live'),

  ('woodstock-001', 'The JEE Eligibility Concern',
   'A Grade 8 family with a son who plans to write JEE Advanced is choosing IGCSE subjects. The mother has heard conflicting information — her friend told her IGCSE is not recognized by IITs. She is considering moving her son to a CBSE school.',
   'IGCSE is not valid for JEE and the family needs to move to CBSE.',
   'IGCSE qualifies for JEE Main and JEE Advanced as a recognized 10th board exam — but only if the student takes Physics, Chemistry, and Mathematics at IGCSE. The subject selection decision must be made now, in Grade 8. Wrong subject selection is the real risk, not the qualification itself.',
   '["Give the definitive answer first: Yes, IGCSE qualifies for JEE — do not hedge","Explain the condition: PCM subjects must be in the IGCSE selection","Flag this as time-sensitive: subject selection happens this term in Grade 8","Connect the family immediately with the academic counselor to confirm subject choices","Offer to share the IGCSE subject list so the family can see PCM is available"]'::jsonb,
   '{3,5}'::integer[], 'community_submitted', 'live'),

  ('woodstock-001', 'The Subject Choice Question',
   'A Grade 8 parent asks about AP subject selection for her daughter, who wants to study Architecture at a UK university. The father says he heard that AP is "just like IB — you''re forced into a fixed set of subjects." He seems skeptical of the transition.',
   'AP is equally constrained as IB and the family is losing flexibility.',
   'AP offers significantly more subject choice than IB. IB locks students into one subject per six prescribed groups. AP allows students to select any combination from 38+ subjects. An Architecture-bound student can take AP Studio Art, AP Physics, AP Environmental Science, and AP Art History simultaneously — none of which IB''s group structure would easily accommodate.',
   '["Correct the misunderstanding directly: AP is more flexible than IB, not less","Walk through IB''s 6-group constraint vs AP''s open menu","Show Woodstock''s specific AP subject list","Connect the student''s Architecture goal to relevant AP subjects (Art, Physics, possibly History of Art)","If the parent remains skeptical, offer a follow-up meeting with the Head of Academics"]'::jsonb,
   '{4,5}'::integer[], 'community_submitted', 'live'),

  ('woodstock-001', 'The UK Admissions Worry',
   'A Grade 10 parent has a daughter targeting Oxford for Law. She is worried that AP is "an American qualification" and that her daughter will be at a disadvantage against students submitting A-levels or IB Diplomas. She wants to know if her daughter should transfer to a school that still offers IB.',
   'AP is an American-only credential that disadvantages students applying to UK universities.',
   'AP is formally recognized by Oxford, Cambridge, Imperial, and other UK universities as equivalent to A-level preparation. For Law at Oxford, the relevant AP subjects (English Language, History, Government) combined with strong LNAT performance form a competitive application. IB recognition is not inherently stronger than AP at UK universities — the key is subject match and score quality.',
   '["Lead with UK recognition: Oxford has a formal AP recognition policy","Explain that UCAS accepts AP scores and how they map to tariff points","Identify the AP subjects most relevant to Law (English, History) and confirm Woodstock offers them","Note that the LNAT matters for Oxford Law — a pathway discussion, not just qualification","Do not suggest the student transfer — offer to arrange a conversation with the counselor about the Oxford Law application specifically"]'::jsonb,
   '{5}'::integer[], 'community_submitted', 'live'),

  ('woodstock-001', 'The IB Predicted Grades Conversation',
   'A Grade 11 IB parent requests a meeting. Her son received a predicted grade of 5 in Physics from his teacher. His conditional offer from Imperial College requires a 6. She wants the prediction changed and implies the teacher is being unfair.',
   'The teacher has made an error or is being harsh and the prediction should be changed.',
   'IB predicted grades are the teacher''s professional assessment of trajectory toward May exams, moderated by the IB Coordinator. A 5 prediction reflects the teacher''s honest view of where the student is heading — not the student''s best-ever performance. Changing a prediction without evidence-based justification undermines the school''s credibility with UCAS. The right response is to explain the process, explore what the student can do to improve trajectory, and refer to the IB Coordinator if the parent escalates.',
   '["Acknowledge the parent''s concern and the importance of the Imperial offer","Explain the prediction process: teacher assessment + IB Coordinator moderation — it is not a single person''s opinion","Ask the parent what specific concern the student has about the Physics grade — is there a trajectory issue in recent assessments?","Do not offer to change the prediction in this meeting","Refer to the IB Coordinator for any further discussion about the specific prediction","If the student has a genuine case (recent strong assessments, upward trajectory), that evidence can be reviewed through the proper channel"]'::jsonb,
   '{6}'::integer[], 'community_submitted', 'live')

ON CONFLICT (module_id, title) DO UPDATE SET
  setup              = EXCLUDED.setup,
  common_misread     = EXCLUDED.common_misread,
  actual_dynamic     = EXCLUDED.actual_dynamic,
  response_framework = EXCLUDED.response_framework,
  status             = EXCLUDED.status;

-- ── SECTION F: Assign module to Woodstock School ─────────────────────

INSERT INTO assignments (school_id, user_id, role_target, module_slug, assigned_by, due_date)
SELECT
  s.id,
  NULL,
  'parent',
  'woodstock-transition',
  (SELECT id FROM profiles WHERE role = 'admin' LIMIT 1),
  '2026-06-30'
FROM schools s
WHERE s.domain = 'woodstockschool.in'
ON CONFLICT DO NOTHING;

-- ── Verification queries (run after to confirm) ───────────────────────
-- SELECT name, domain FROM schools ORDER BY name;
-- SELECT id, title, tagline, status FROM pd_modules WHERE id = 'woodstock-001';
-- SELECT dimension_number, title, research_status FROM pd_dimensions WHERE module_id = 'woodstock-001' ORDER BY dimension_number;
-- SELECT title, source_type, status FROM pd_scenarios WHERE module_id = 'woodstock-001';
-- SELECT module_slug, role_target, due_date FROM assignments WHERE module_slug = 'woodstock-transition';
