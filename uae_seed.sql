-- ══════════════════════════════════════════════════════════════════════════════
-- UAE Module — Calibrate PD Layer
-- Audience: foreign / international teachers at international schools
-- DB ID: uae-001  |  slug: uae-ib  |  flag: 🇦🇪
-- Run AFTER cal_seed_part1.sql (tables must exist)
-- ══════════════════════════════════════════════════════════════════════════════

BEGIN;

-- ── MODULE ────────────────────────────────────────────────────────────────────

INSERT INTO pd_modules (id, country_code, title, tagline, preamble_md, status)
VALUES (
  'uae-001',
  'AE',
  'Understanding UAE',
  'Wasta, school choice as social capital, and the Emirati family inside a global curriculum',
  'Families in the UAE who choose international schools are not a monolith — Emirati nationals, Arab expats from Egypt, Jordan, and Lebanon, South Asian expats from India and Pakistan, and Western expats all arrive with different needs and very different relationships to the IB. What they share is a context that is unusually high-stakes: the UAE is a small, wealthy, rapidly developing state where education is explicitly tied to national ambition, economic positioning, and social standing. School choice in this environment is rarely neutral — it signals who the family is, where they are headed, and how seriously they take their children''s futures. This module asks you to understand the specific dynamics most likely to appear at a parent meeting in Abu Dhabi or Dubai: wasta, gender norms, Islamic expectations, and the particular pressure of raising children in a transient expat context.',
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title       = EXCLUDED.title,
  tagline     = EXCLUDED.tagline,
  preamble_md = EXCLUDED.preamble_md,
  status      = EXCLUDED.status;

-- ── DIMENSIONS ────────────────────────────────────────────────────────────────

INSERT INTO pd_dimensions (module_id, dimension_number, title, research_status, content) VALUES

-- ── D1: Wasta — Relationships and Access ─────────────────────────────────────
('uae-001', 1, 'Wasta: How Connections Shape Expectations in UAE Schools', 'fully_sourced',
$json${
  "summary": "Wasta — the use of personal relationships and social capital to achieve outcomes — is a structural feature of Gulf society. It shapes how some families understand the school's role, and what they expect a 'good relationship' with the school to produce.",
  "sections": [
    {
      "heading": "How wasta works",
      "items": [
        "Wasta (واسطة) is the Arabic term for mediated access through personal connections — a cousin who works in the ministry, a family friend at the admissions office, a father who knows the principal. It is not corruption in the way outsiders often frame it; it is a relational logic that organises access to resources, decisions, and opportunities.",
        "In Gulf societies, wasta is largely normalised and operates across sectors: government, business, healthcare, and education. A family that has wasta does not expect to wait in line; they expect the relationship to smooth the path. This is not experienced as unfair by those who have it — it is how competent, well-connected families operate.",
        "In international schools, wasta logic can manifest as: requests for grade changes framed as 'checking that the right decision was made', escalations to school leadership before engaging the teacher, mentions of who the family knows in ways that imply a social claim on the outcome, or the assumption that a complaint will be resolved in their favour.",
        "Teachers — particularly those from Northern European, North American, or Australian backgrounds — are trained to treat all parents equally and to interpret preferential treatment as corruption. This framing misses the cultural logic. Wasta is not about bribing; it is about signalling that the family has standing and expects it to be acknowledged.",
        "The appropriate teacher response is not to capitulate to wasta pressure, but to understand it clearly enough to engage professionally without either dismissing the family's standing or compromising academic integrity."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who mentions knowing the principal or board member at the start of a concern meeting — misread as a threat. Often: an establishing move to signal social standing, which the family expects will be acknowledged. Ignoring it entirely can feel to the family like disrespect.",
        "A parent who asks to have a decision 'reviewed' after it has been communicated — misread as arguing. Often: standard Gulf practice — the first answer is not always the final answer, and requesting review is how problems are normally resolved.",
        "A parent who escalates directly to senior leadership over what seems like a small issue — misread as an overreaction. Often: a family that is used to having access to decision-makers and sees teacher-level conversations as a first step, not a resolution.",
        "A parent who refers to other families' experience ('The Al-Mansouri family told me...') — misread as gossip. Often: a social proof mechanism — the family is establishing that they are networked enough to know what precedent exists."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Hutchings & Weir (2006) on wasta in the Arab world document how the system functions as a form of social capital exchange — not purely transactional but embedded in webs of obligation, reciprocity, and honour.",
        "Metcalfe (2006) on human resource management in the UAE shows how wasta norms from Gulf society transfer into institutional contexts including education — affecting how parents relate to school authority and what 'fair process' means to them.",
        "Ridge (2010) in 'Education and the Reverse Gender Divide in the Gulf States' documents how UAE families' school expectations are shaped by a mix of wasta, national ambition, and the specific pressures on male students in a context where female UAE nationals now significantly outperform males academically."
      ]
    }
  ],
  "citations": [
    {"author": "Hutchings, K. & Weir, D.", "year": "2006", "doi": "10.1080/13602380600791932"},
    {"author": "Metcalfe, B.", "year": "2006", "doi": "10.1108/01437730610660826"},
    {"author": "Ridge, N.", "year": "2010", "publisher": "Dubai School of Government"}
  ]
}$json$::jsonb),

-- ── D2: Emirati vs Expat: Different Families, Different Stakes ───────────────
('uae-001', 2, 'Emirati and Expat: Understanding Who Is in the Room', 'fully_sourced',
$json${
  "summary": "International schools in the UAE serve a genuinely diverse population — Emirati nationals, Arab expats, South Asian expats, and Western expats — whose relationships to the school, the curriculum, and their children's futures are substantially different.",
  "sections": [
    {
      "heading": "The population is not one thing",
      "items": [
        "International schools in Dubai and Abu Dhabi enrol a mix of Emirati nationals (typically 5-15% in most schools), Arab expats from Egypt, Jordan, Lebanon, and Syria (often 20-30%), South Asian expats from India, Pakistan, and Sri Lanka (often 20-40%), and Western expats from the UK, US, Europe, and Australia.",
        "Each group is at the school for different reasons and with different exit anxieties. Western expat families are often on 2-3 year postings and primarily concerned with seamless re-entry to home systems. South Asian expat families are often working toward overseas university for children who may not have a right of return. Arab expat families often have children who were born in the UAE but have Jordanian or Egyptian passports. Emirati families are the only group for whom the UAE is definitively home.",
        "Emirati students in international schools represent a specific government-encouraged pathway — the UAE Ministry of Education actively promotes internationally certified education as part of Vision 2031. Emirati parents in international schools often have high expectations of the school's alignment with UAE national values, Islamic education, and Arabic language maintenance alongside the international credential.",
        "The transience of the expat population creates its own pressures. Teachers who build relationships over years find those relationships shorn away when families relocate. For the remaining students, the social fabric is repeatedly reconstructed. Emotional support and community-building are not peripheral to the academic mission in this context.",
        "Understanding which family is in front of you — and what their relationship to the UAE, to the school, and to their child's future actually is — is the first move in any meaningful parent conversation."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who asks whether the school provides Arabic instruction and Islamic studies — misread as a religious preference. For an Emirati family: this is about identity continuity and a government expectation, not a personal religious add-on.",
        "A parent who doesn't seem invested in the school community — misread as disengagement. Often: an expat family on a short posting who knows they'll leave in 18 months and is rationally managing their investment in local community.",
        "A South Asian expat parent who is intensely focused on the child's academic record — misread as academic pressure. Often: a family for whom the child's IB credentials are the primary mechanism for securing a future in a country where the child has no citizenship rights.",
        "An Emirati parent who requests meetings in Arabic — misread as a language barrier. Often: a signal that the family considers Arabic the appropriate register for serious institutional discussions, not a capability limitation."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Findlow (2006) on UAE higher education and national identity documents how Emirati families navigate the tension between global credentials and national cultural continuity — a tension that plays out in international school parent expectations.",
        "Vertovec (2007) on 'super-diversity' in urban contexts applies directly to Dubai and Abu Dhabi schools — the diversity is not simply multicultural but involves multiple intersecting axes of difference (legal status, nationality, class, religion) that create genuinely distinct needs.",
        "Dito (2015) on labour migration in the Gulf states explains the specific precarity of expat family contexts — visa dependence on employment, limited local legal status, and school-as-safe-space for children who have no civic belonging."
      ]
    }
  ],
  "citations": [
    {"author": "Findlow, S.", "year": "2006", "doi": "10.1080/01419870600814003"},
    {"author": "Vertovec, S.", "year": "2007", "doi": "10.1177/1469712107080135"},
    {"author": "Dito, M.", "year": "2015", "publisher": "Gulf Labour Markets and Migration Programme"}
  ]
}$json$::jsonb),

-- ── D3: Islamic Practice and the Curriculum ───────────────────────────────────
('uae-001', 3, 'Islam and the IB: When Faith Frames the Curriculum', 'fully_sourced',
$json${
  "summary": "The UAE is a Muslim-majority state where Islamic practice shapes public life. International schools operate in this context — and families from both Muslim-majority backgrounds and the broader Arab world expect the school to demonstrate cultural competence around faith, not merely legal compliance.",
  "sections": [
    {
      "heading": "What Islamic practice means in the UAE school context",
      "items": [
        "Unlike in Indonesia where Islam is a community identity norm, in the UAE Islam is also a state identity. The UAE constitution establishes Islam as the state religion. Schools operate within a legal and social framework that assumes Islamic practice is the default for most families.",
        "Emirati families in particular hold the school accountable to a dual standard: international academic quality and respect for Islamic values. These are not experienced as in tension — the expectation is that a sophisticated international school can hold both.",
        "Prayer breaks, Ramadan adjustments, halal food, modesty norms in PE and swimming, and avoidance of certain content (explicit relationships, religious criticism, pork products) are all areas where the school's policies are read as signals of cultural competence or ignorance.",
        "Non-Muslim expat teachers often frame these as accommodations — minor exceptions to a default secular framework. For most Muslim families at UAE international schools, the relationship is reversed: the secular framework is the exception that operates inside a society where Islamic practice is the baseline.",
        "IB's Theory of Knowledge and Global Perspectives components can create tension with families for whom certain questions about religion, ethics, or sexuality are not open questions but settled ones. This is not anti-intellectual — it is a coherent epistemological position that deserves engagement, not dismissal."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who objects to a novel's content on faith grounds — misread as censorship. Often: a family raising a legitimate question about whether the school has considered the full context of its student population when selecting texts.",
        "A student who requests to leave class for Dhuhr prayer — misread as seeking an exemption. In the UAE context: exercising a right the school is expected to accommodate as a matter of course.",
        "A parent who asks whether the school celebrates only Western holidays — misread as a complaint. Often: a genuine inquiry about whether the school's calendar reflects the community it serves.",
        "A student from a conservative Muslim family who is uncomfortable with co-ed physical activity — misread as family over-control. Often: a family making a values-consistent decision about modesty that the school needs to engage rather than override."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Al-Sharideh & Goe (1998) on Islamic identity and educational institutions in the Gulf document how families evaluate schools simultaneously on academic quality and Islamic alignment — treating these as parallel, not competing, criteria.",
        "Mazawi (2002) on the politics of Islamic education in Arab states shows how schools that perform neutrality on religious questions are often experienced as hostile by communities for whom Islamic practice is not optional.",
        "Badry (2011) on global citizenship education in UAE schools documents the specific tension between IB's open-inquiry framework and Emirati families' expectation that national Islamic identity be protected alongside global skills."
      ]
    }
  ],
  "citations": [
    {"author": "Al-Sharideh, K. & Goe, W.R.", "year": "1998", "doi": "10.1080/002075998032448"},
    {"author": "Mazawi, A.", "year": "2002", "doi": "10.1023/A:1016062210249"},
    {"author": "Badry, F.", "year": "2011", "publisher": "University of Sharjah Press"}
  ]
}$json$::jsonb),

-- ── D4: School Choice as Social Capital ───────────────────────────────────────
('uae-001', 4, 'The School as Status Signal: Choice, Reputation, and Parental Expectations', 'fully_sourced',
$json${
  "summary": "In the UAE's competitive international school market, school choice is a social statement as much as an educational decision. Families who pay premium fees carry premium expectations — and the 'product' they expect is partly academic and partly about social positioning.",
  "sections": [
    {
      "heading": "The market logic of UAE schooling",
      "items": [
        "The UAE has over 600 private schools serving a predominantly expat population, operating in a competitive, fee-based market. KHDA (Knowledge and Human Development Authority) ratings are public, widely followed, and significantly affect enrolment. Parents in Dubai monitor ratings, compare schools, and make decisions based on a combination of academic outcome data, social reputation, and peer network.",
        "Choosing an IB school in Dubai or Abu Dhabi is, for many families, a deliberate social signal: it positions the family as internationally mobile, academically ambitious, and willing to invest. The school becomes part of the family's identity presentation in their social network.",
        "This creates a specific kind of expectation: the school is not just an educational institution — it is a partner in the family's social project. When the school produces an outcome the family is unhappy with (a grade, a teacher assessment, a policy), it is not just an academic matter. It is a challenge to the family's investment narrative.",
        "Schools rated 'Outstanding' by KHDA carry a premium that families have paid for explicitly. A family that feels the school is not delivering Outstanding-level service to their child — regardless of what the curriculum requires — will feel justified in escalating.",
        "The pressure this creates on teachers to maintain positive parent relationships at the cost of honest feedback is one of the most consistent challenges reported by international school teachers in the UAE."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who mentions how much they pay in fees when raising a concern — misread as a financial transaction framing of education. Often: a legitimate expression that the family has invested significantly and expects the school to take their child's situation seriously.",
        "A parent who compares the school unfavourably to 'other schools' they considered — misread as a complaint designed to threaten departure. Often: a parent who is genuinely calibrating whether they made the right choice and is signalling that their confidence is fragile.",
        "A parent who escalates a concern quickly rather than working through the teacher — misread as bypassing process. Often: a family who paid for direct access to quality and interprets 'talk to the teacher first' as being fobbed off.",
        "A parent who is effusive in praise but whose child's outcomes suggest disengagement at home — misread as a well-engaged parent. Often: a family performing the role of engaged parent (which is itself a social norm in their network) without the practical engagement the teacher is hoping for."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Reay (2004) on social class and school choice documents how middle-class families across contexts use school choice as a class-reproducing strategy — the UAE version of this is particularly visible because the market is explicit and KHDA ratings make status legible.",
        "Soudien (2012) on elite schooling in the Global South shows how families who position their children in elite schools import a set of expectations about the school's obligations that are not primarily educational but social.",
        "KHDA (2022) annual report on Dubai private schools shows that parent satisfaction scores in Outstanding-rated schools correlate strongly with teacher communication quality, not exclusively academic outcomes — families are buying relationship as well as result."
      ]
    }
  ],
  "citations": [
    {"author": "Reay, D.", "year": "2004", "doi": "10.1080/01411920500167308"},
    {"author": "Soudien, C.", "year": "2012", "publisher": "HSRC Press"},
    {"author": "KHDA", "year": "2022", "publisher": "Knowledge and Human Development Authority"}
  ]
}$json$::jsonb),

-- ── D5: Gender, Family, and the PTM Dynamics ──────────────────────────────────
('uae-001', 5, 'Gender Dynamics in Parent-Teacher Meetings: Who Is in the Room', 'fully_sourced',
$json${
  "summary": "Gender norms in UAE families — particularly those from Gulf Arab and South Asian backgrounds — shape who attends PTMs, who speaks, and what the teacher's gender signals about the interaction's seriousness.",
  "sections": [
    {
      "heading": "How gender shapes the meeting",
      "items": [
        "In many Gulf Arab and South Asian families in the UAE, the father carries formal decision-making authority in dealings with institutions. A mother who attends alone may signal that the meeting is routine. A father who attends — especially without the mother — often signals that the family considers the matter significant.",
        "For female teachers meeting with male parents from conservative backgrounds, gender norms can create subtle friction: eye contact, physical greeting (handshake vs. no contact), seating arrangements, and the degree to which the male parent directs questions to a male colleague rather than the female teacher in the room.",
        "This is not primarily about the teacher's identity. It is about the family's social framework for institutional interactions. A female teacher who is aware of these dynamics can navigate them professionally without either accommodating sexism or turning a parent meeting into a values confrontation.",
        "For male teachers meeting with mothers from conservative backgrounds: some mothers will not meet with a male teacher without another family member present. This is not a sign of hostility — it is a modesty norm. Schools that have a routine protocol for this avoid the awkwardness of it arising as an unexpected 'problem.'",
        "Emirati families, in particular, may send the mother for routine matters and the father (or both parents) for matters involving academic standing, school policy challenges, or concerns about the child's wellbeing. Understanding this as a signal — not a random attendance pattern — helps the teacher calibrate the meeting's register."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A father who attends a routine PTM — misread as the family escalating. Often: a signal that the family considers the child's current situation important enough to send the formal decision-maker.",
        "A mother who defers all questions to her husband even when she appears more informed — misread as the mother being sidelined. Often: a deliberate family presentation of unified authority — the mother may give the father her positions before the meeting.",
        "A male parent who addresses questions to a male colleague rather than the female lead teacher — misread as personal disrespect. Often: a gender-register habit that is not about the teacher's competence. A confident, clear female teacher who continues to lead the meeting usually wins the room without confrontation.",
        "Parents who bring a translator even when they speak fluent English — misread as a language need. Often: a face-preserving mechanism — having a translator means the parent is never 'caught' not understanding something, and allows them time to formulate responses."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Metcalfe (2008) on gender in Arab Gulf organisations documents how gender role divisions in institutional settings are not primarily about women's capability but about the social organisation of authority and propriety.",
        "Harkness & Super (2002) on cultural models of parenting show that the division of roles between mothers and fathers in institutional interactions is coherent and functional within the family's framework, regardless of how it maps onto the school's expectations.",
        "Ridge (2010) specifically documents the UAE dynamic where mothers carry the day-to-day relationship management with schools while fathers are mobilised for matters of institutional significance."
      ]
    }
  ],
  "citations": [
    {"author": "Metcalfe, B.", "year": "2008", "doi": "10.1108/00483480810869030"},
    {"author": "Harkness, S. & Super, C.", "year": "2002", "publisher": "Guilford Press"},
    {"author": "Ridge, N.", "year": "2010", "publisher": "Dubai School of Government"}
  ]
}$json$::jsonb),

-- ── D6: The Transient Community and the Long-Term Child ──────────────────────
('uae-001', 6, 'Transience and Roots: Raising Children in an Expat Society', 'fully_sourced',
$json${
  "summary": "Most families in UAE international schools are transient — they are in the UAE on employment visas, may leave in 1-3 years, and have children who are constructing identity in a context of repeated dislocation. This creates distinctive emotional and academic patterns that teachers consistently misread.",
  "sections": [
    {
      "heading": "The psychology of transient schooling",
      "items": [
        "A student who has attended schools in four countries by the age of 12 has a different relationship to belonging, authority, and academic risk than a student who has been in the same school since reception. They have learned to adapt quickly and to invest strategically — building enough social connection to function but not so much that leaving is catastrophic.",
        "Third Culture Kids (TCKs) — children who grow up in a culture other than their passport country — show distinct patterns: high cultural adaptability, strong language acquisition, but elevated rates of loneliness, grief around repeated losses of friends, and difficulty with questions like 'where are you from?'",
        "Parents of TCKs often carry their own version of this stress. They are managing their own expat experience — career pressure, distance from extended family, uncertain legal status — while trying to provide stability for children who are moving through a series of temporary communities.",
        "Teachers who stay at UAE international schools for years accumulate a different kind of knowledge than any one family has. They have seen the arc. A student who is disengaged in Month 3 often stabilises by Month 6. A family that arrives with high anxiety often settles once the child has a social foothold. Understanding this arc, and communicating it to parents, is one of the most valuable things a long-serving UAE teacher can offer.",
        "For Emirati students, the context is different: they are not transient, but they are often a minority in their own classroom. The experience of being Emirati in a school where most students are from elsewhere creates a different kind of identity negotiation."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A new student who is socially withdrawn in the first term — misread as shyness or social difficulty. Often: an experienced mover conserving social investment until the new school's social map is clear enough to navigate.",
        "A parent who is intensely focused on academic outcomes in the first term — misread as academic pressure. Often: a family for whom academic credentials are the one constant in a transient life — grades travel even when everything else changes.",
        "A student who appears emotionally flat when another friend moves away — misread as low empathy. Often: a student who has learned to regulate the grief of repeated loss rather than feel each departure as acutely as the first.",
        "A parent who resists investing in long-term school community initiatives — misread as disengagement. Often: a family who knows they're leaving in 18 months and is making rational decisions about where to spend limited social energy."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Pollock & Van Reken (2009) in 'Third Culture Kids' remain the foundational text on TCK psychology — documenting the specific adaptations and costs of growing up across cultural contexts, with direct implications for how teachers interpret student behaviour.",
        "Sears (2011) on international school community development shows how schools that acknowledge transience as a structural feature — and build explicit rituals around arrivals and departures — create more stable emotional environments for all students.",
        "Fail, Thompson & Walker (2004) on the identity construction of adult TCKs documents the long-term psychological costs of unacknowledged transient childhood — findings that position teacher awareness of this context as a genuine wellbeing intervention."
      ]
    }
  ],
  "citations": [
    {"author": "Pollock, D. & Van Reken, R.", "year": "2009", "publisher": "Nicholas Brealey"},
    {"author": "Sears, C.", "year": "2011", "publisher": "Multilingual Matters"},
    {"author": "Fail, H., Thompson, J. & Walker, G.", "year": "2004", "doi": "10.1080/14675980310001630071"}
  ]
}$json$::jsonb);

-- ── QUIZ QUESTIONS ────────────────────────────────────────────────────────────

INSERT INTO quiz_questions (id, module_id, dimension_number, quiz_type, prompt, options, correct_index, explanation) VALUES

-- D1 checkpoint
('uae-d1-q1', 'uae-001', 1, 'checkpoint',
 'A parent at the start of a concern meeting mentions that they know a school board member personally. The most research-aligned first interpretation is:',
 $opts$["The parent is making a veiled threat.", "The parent is establishing their social standing using a culturally normalised wasta signal that expects acknowledgement.", "The parent is trying to tell you they have inside information about the school.", "The parent is testing whether you will treat them differently."]$opts$::jsonb,
 1,
 'Wasta operates as an establishing move in many Gulf interactions — the mention of a connection signals social standing and sets a register for the conversation. Treating it as a threat or ignoring it entirely both miss the cultural logic. Acknowledging it professionally ("I appreciate you sharing that — let''s make sure we address your concern directly") is the correct move: it treats the signal as meaningful without making it operative.'
),

-- D2 checkpoint
('uae-d2-q1', 'uae-001', 2, 'checkpoint',
 'An Emirati parent asks whether the school provides Arabic instruction and Islamic studies alongside the IB curriculum. The most research-aligned response is:',
 $opts$["Explain that the IB curriculum does not include religious instruction as a standard component.", "Recognise this as a question about identity continuity and national expectation, and respond with specific information about what the school provides in both areas.", "Suggest the parent look at the school''s website for curriculum information.", "Ask the parent whether their child has expressed a preference for more Arabic instruction."]$opts$::jsonb,
 1,
 'For Emirati families, Arabic language maintenance and Islamic studies are not supplementary requests — they reflect a government-supported expectation and a core aspect of national identity. The question is not primarily about curriculum content; it is about whether the school is a competent partner for raising an Emirati child. A specific, informed answer signals that competence.'
),

-- D3 checkpoint
('uae-d3-q1', 'uae-001', 3, 'checkpoint',
 'A student from a conservative Muslim family declines to participate in a drama activity that involves playing a non-Muslim character. The most research-aligned first response is:',
 $opts$["Explain that participation in all class activities is required and apply the policy consistently.", "Ask the student privately whether there are specific elements of the activity that are a concern, and explore whether adjustments are possible.", "Contact the parents to explain that the drama curriculum is academically important.", "Exempt the student from the activity to avoid conflict."]$opts$::jsonb,
 1,
 'Faith-based decisions about participation are rarely all-or-nothing. Many students can engage with adjusted tasks — different roles, observer positions, script analysis rather than performance — that honour the curricular intent while respecting the family''s values. Opening the conversation (B) finds the real constraint, which is often narrower than it first appears. Options A and C skip the student. Option D removes the student from learning entirely.'
),

-- D4 checkpoint
('uae-d4-q1', 'uae-001', 4, 'checkpoint',
 'A parent mentions the fees they pay when raising a concern about their child''s report. The most research-aligned interpretation is:',
 $opts$["The parent is treating education as a transactional exchange and needs to be reminded of the school''s professional standards.", "The parent is expressing that they have invested significantly and expects that investment to be taken seriously — a legitimate signal, not a threat.", "The parent is attempting to buy better marks for their child.", "The parent is feeling undervalued by the school and is using fees as leverage."]$opts$::jsonb,
 1,
 'In a competitive fee-paying market, families who invest premium fees carry a legitimate expectation of premium attention. Mentioning fees is often a way of signalling "take this seriously" rather than "give me what I want." The professional response is to demonstrate that the school takes the child''s situation seriously — which addresses the underlying concern without compromising academic integrity.'
),

-- D5 checkpoint
('uae-d5-q1', 'uae-001', 5, 'checkpoint',
 'A male parent at a PTM directs his questions to your male colleague even though you are the lead teacher for his child. The most research-aligned first response is:',
 $opts$["Confront the behaviour directly by stating that you are the lead teacher and should be addressed.", "Continue to lead the meeting confidently and clearly — most fathers in this situation will re-orient to the person who demonstrates knowledge and authority.", "Ask your colleague to step out so the dynamic is removed.", "Report the interaction to administration as a gender discrimination concern."]$opts$::jsonb,
 1,
 'Gender-register habits in institutional settings are not easily changed by confrontation, and escalating them creates a more hostile meeting environment. A teacher who knows their subject, leads the conversation clearly, and is comfortable in the room usually wins the engagement naturally. Option A creates conflict; options C and D both escalate rather than resolve. Option B is the approach research on cross-cultural professional settings consistently supports.'
),

-- D6 checkpoint
('uae-d6-q1', 'uae-001', 6, 'checkpoint',
 'A new student who arrived three months ago is socially withdrawn and not forming close friendships. The most research-aligned interpretation is:',
 $opts$["The student has a social anxiety disorder that should be referred to the school counsellor.", "The student is an experienced mover who is conserving social investment while mapping the new environment — this is adaptive, not pathological.", "The student''s parents are not supporting their social integration outside school.", "The student is experiencing academic difficulties that are affecting their confidence."]$opts$::jsonb,
 1,
 'TCK research documents social withdrawal in the first term as a common, adaptive pattern in experienced movers — not a disorder. These students have learned that building strong friendships only to lose them when the family moves again is painful, so they invest cautiously until the social map is clear and the timeline of their own stay is established. Referring to a counsellor (A) or contacting parents (C) pathologises a culturally rational behaviour.'
),

-- Final exam Q1
('uae-final-q1', 'uae-001', NULL, 'final_exam',
 'An Emirati family escalates a concern about their child''s IB report to the principal before speaking with the teacher. The most research-aligned response from the teacher is:',
 $opts$["Inform the principal that the family should have contacted the teacher first, per school policy.", "Understand that direct escalation to senior authority is a culturally normal first move in Gulf institutional contexts, and engage the family warmly when they do connect.", "Assume the family has a previous negative experience with the teacher and investigate.", "Ask the principal to redirect the family back to the teacher before engaging with the concern."]$opts$::jsonb,
 1,
 'In Gulf contexts where wasta and hierarchical access are normalised, going directly to senior authority is not bypassing process — it is using the process that the family understands to be effective. Treating this as a policy violation (A) or a personal slight (C) misses the cultural register. Option D compounds the friction. Option B positions the teacher to engage the family from a place of understanding rather than defensiveness.'
),

-- Final exam Q2
('uae-final-q2', 'uae-001', NULL, 'final_exam',
 'A student who has attended five schools in six years is performing well academically but appears emotionally flat and uninvested in peer relationships. The most research-aligned interpretation is:',
 $opts$["The student has a depressive disorder that requires counselling referral.", "The student is an experienced transient who has developed emotional regulation strategies for repeated loss — this is adaptation, not disorder, but warrants a gentle check-in.", "The student''s family has not prioritised social development alongside academic achievement.", "The student is intellectually advanced but socially behind their peers."]$opts$::jsonb,
 1,
 'TCK research consistently documents emotional regulation of grief-around-departure as an adaptive strategy in experienced movers. Flat affect is often not depression but managed distance. The research-backed response is a gentle, private check-in that opens a conversation about the student''s experience of moving without pathologising it. Referral without that step (A) may be premature; options C and D locate the problem in the wrong place.'
),

-- Final exam Q3
('uae-final-q3', 'uae-001', NULL, 'final_exam',
 'A parent asks whether the school''s Theory of Knowledge course includes questions about the validity of religious knowledge. The most research-aligned response is:',
 $opts$["Explain that TOK examines all knowledge systems including religious ones, and this is a core part of the IB curriculum.", "Acknowledge the question, explain the TOK framework honestly, and invite the parent to discuss any specific concerns about how the content is handled in the classroom.", "Tell the parent that teachers do not address student beliefs in TOK and the course is purely philosophical.", "Ask the parent to read the IB TOK curriculum guide before the meeting."]$opts$::jsonb,
 1,
 'This is a question that deserves a complete, honest answer and an invitation to dialogue — not deflection (C, D) or unmediated information delivery (A). TOK does examine epistemological claims including religious ones. A parent asking this question from a conservative Muslim background is checking whether the teacher understands their concern and can engage with it professionally. Option B demonstrates that competence.'
);

-- ── SIMULATIONS ───────────────────────────────────────────────────────────────

INSERT INTO simulation_scenarios (id, module_id, title, persona, scenario_setup, nodes) VALUES

-- Simulation A: The Board Member ──────────────────────────────────────────────
('uae-sim-a', 'uae-001', 'The Board Member',
 $chars${
   "name": "Mr Al-Rashidi",
   "role": "Father of Hamad, Year 11",
   "background": "UAE national, successful businessman. He sits on a charitable board that has connections to the school''s funding network. He is used to being taken seriously in institutional settings.",
   "emotional_state": "Calm but expectant — he has raised this issue once before and is back",
   "avatar_initials": "AR"
 }$chars$::jsonb,
 'Mr Al-Rashidi has requested a meeting about Hamad''s predicted IB grade. Hamad is on track for a 4 in Mathematics — not enough for the engineering programme at the UAE university the family is targeting. At the start of the meeting, Mr Al-Rashidi mentions that his cousin sits on the university''s admissions advisory board, and asks whether there is "any flexibility" in the predicted grade.',
 $nodes$[
   {
     "id": "start",
     "text": "Mr Al-Rashidi is watching you carefully. The mention of his cousin was deliberate — he wants to see how you respond to social context.",
     "options": [
       {"label": "Explain firmly that predicted grades cannot be changed for social reasons and that IB regulations prohibit it.", "next": "wrong_firm", "correct": false},
       {"label": "Acknowledge the family''s target and the connection he mentioned, and explain what Hamad would need to achieve in the remaining assessments to improve the prediction — keeping focus on the student.", "next": "correct_redirect", "correct": true},
       {"label": "Ask whether the family has considered alternative university options that might accept a 4 in Mathematics.", "next": "wrong_deflect", "correct": false}
     ]
   },
   {
     "id": "wrong_firm",
     "text": "Mr Al-Rashidi nods slowly. ''I understand the rules,'' he says. ''I just wanted to have the conversation.'' The meeting ends. He has noted that you are not someone who can navigate this kind of situation.",
     "options": [
       {"label": "Reflect: the response was correct in substance but missed the cultural move required — acknowledging his standing before explaining the constraint.", "next": "correct_redirect", "correct": true}
     ]
   },
   {
     "id": "wrong_deflect",
     "text": "Mr Al-Rashidi looks mildly offended. He has not come to be redirected to lower-status options. ''I know his options,'' he says. ''I want to understand what the school can do.''",
     "options": [
       {"label": "Bring the focus to what Hamad can do in the remaining assessments to improve his position.", "next": "correct_redirect", "correct": true}
     ]
   },
   {
     "id": "correct_redirect",
     "text": "You acknowledge that the family has a clear and specific target, and that you understand what is at stake. You explain that predicted grades are a professional assessment, not a ceiling — and that you want Hamad to exceed the prediction. You lay out exactly what his remaining assessments are, which components have the most weight, and what scores would move the prediction up.",
     "options": [
       {"label": "Offer to set up a support plan with Hamad and share it with Mr Al-Rashidi.", "next": "debrief", "correct": true},
       {"label": "Ask whether Mr Al-Rashidi would like to schedule a follow-up once Hamad has taken the next assessment.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "Mr Al-Rashidi stands and extends his hand. ''This is helpful,'' he says. ''I appreciate your directness.''",
     "isDebrief": true,
     "debriefText": "Mr Al-Rashidi did not expect you to change the grade. He was testing whether you would engage with him as a person of standing, acknowledge the family''s situation, and give him something concrete. The wasta mention was an opener, not a demand. Teachers who respond to the opener with a plan — rather than a policy lecture or a deflection — find that Gulf parents like Mr Al-Rashidi become advocates for the school.",
     "options": []
   }
 ]$nodes$::jsonb),

-- Simulation B: The Ramadan Assessment ───────────────────────────────────────
('uae-sim-b', 'uae-001', 'The Ramadan Assessment',
 $chars${
   "name": "Ibu Fatima Al-Kaabi",
   "role": "Mother of Mariam, Year 9",
   "background": "Emirati national, former primary school teacher. She is observant and knowledgeable about educational systems. She is fasting and her daughter is fasting for the first time.",
   "emotional_state": "Measured but clearly testing whether you understand",
   "avatar_initials": "FK"
 }$chars$::jsonb,
 'It is week two of Ramadan. Ibu Fatima has sent a message asking whether the major humanities essay can be postponed by one week. Mariam is fasting for the first time and has been managing Tarawih and Suhoor alongside a heavy assessment week. The message is polite but its subtext is clear: she wants to know if the school understands what Ramadan means.',
 $nodes$[
   {
     "id": "start",
     "text": "You have called Ibu Fatima back. She answers warmly but there is a watchfulness in her tone.",
     "options": [
       {"label": "Explain that assessment deadlines are set by the IB and the school cannot make individual exceptions.", "next": "wrong_policy", "correct": false},
       {"label": "Acknowledge that fasting for the first time during an assessment period is a real physical and spiritual undertaking, and explore what a brief extension would look like.", "next": "correct_acknowledge", "correct": true},
       {"label": "Ask Mariam''s form tutor to follow up, since you are not the one managing deadlines.", "next": "wrong_pass", "correct": false}
     ]
   },
   {
     "id": "wrong_policy",
     "text": "Ibu Fatima says ''I understand'' in a tone that means the opposite. The conversation ends quickly. She will not forget this call.",
     "options": [
       {"label": "Reflect: the correct response acknowledges the context before the constraint.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "wrong_pass",
     "text": "Ibu Fatima pauses. ''I contacted you specifically,'' she says, ''because Mariam talks about your class most.'' She is disappointed.",
     "options": [
       {"label": "Take ownership and engage directly with what she has asked.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "correct_acknowledge",
     "text": "You acknowledge that fasting for the first time, especially during a heavy assessment week, is a genuine physical and spiritual undertaking. You confirm that a 5-day extension is possible without academic penalty, and you ask whether Mariam would benefit from a brief check-in before she starts the essay.",
     "options": [
       {"label": "Confirm the extension in writing and note it on Mariam''s record.", "next": "debrief", "correct": true},
       {"label": "Thank Ibu Fatima for letting you know and wish the family well for Ramadan.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "Ibu Fatima says ''Ramadan Mubarak'' before she hangs up. Mariam''s essay, submitted in the following week, is one of her best pieces of the year.",
     "isDebrief": true,
     "debriefText": "Ibu Fatima''s call was a test, not just a request. She is an educated, experienced former teacher who knows what schools can and cannot do. She was checking whether this school would treat her daughter as a whole person. Teachers who pass this test — and it is consistently the same test across UAE Islamic contexts — build parent relationships that last the entire school career.",
     "options": []
   }
 ]$nodes$::jsonb),

-- Simulation C: The Departure ──────────────────────────────────────────────────
('uae-sim-c', 'uae-001', 'The Departure',
 $chars${
   "name": "Mrs Chen",
   "role": "Mother of Sophie, Year 7",
   "background": "Singaporean national, accompanying spouse visa. Her husband''s contract ends in April. The family is returning to Singapore. Sophie has been at this school since Year 4.",
   "emotional_state": "Sad but managing — she is trying to do everything right in the remaining weeks",
   "avatar_initials": "MC"
 }$chars$::jsonb,
 'Mrs Chen has come to let you know that Sophie''s last day will be in three weeks. The family is returning to Singapore. She mentions quietly that Sophie has been ''a bit flat'' since they told her. She asks whether there is anything the school can do to ''mark it properly'' before she leaves. She doesn''t want Sophie to just disappear.',
 $nodes$[
   {
     "id": "start",
     "text": "Mrs Chen is sitting across from you. She has clearly been holding this conversation for a while.",
     "options": [
       {"label": "Explain the school''s standard leaver protocol and reassure her that the process will be followed.", "next": "wrong_procedure", "correct": false},
       {"label": "Acknowledge that Sophie leaving will be felt by the class and ask Mrs Chen what would feel meaningful to Sophie — a class farewell, a small memory book, a teacher note.", "next": "correct_acknowledge", "correct": true},
       {"label": "Suggest that Sophie might benefit from talking to the school counsellor about her feelings around leaving.", "next": "wrong_counsel", "correct": false}
     ]
   },
   {
     "id": "wrong_procedure",
     "text": "Mrs Chen nods politely. She was not asking about protocol. She was asking whether Sophie matters enough to be marked. She leaves the meeting quietly.",
     "options": [
       {"label": "Reflect: what she needed was acknowledgement and collaboration, not procedure.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "wrong_counsel",
     "text": "Mrs Chen looks slightly alarmed. ''I don''t think she needs that,'' she says. ''She''s just... going to miss people.'' She was asking for community, not therapy.",
     "options": [
       {"label": "Acknowledge what Mrs Chen actually asked for — a meaningful goodbye — and engage with that.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "correct_acknowledge",
     "text": "You tell Mrs Chen that Sophie leaving will genuinely be noticed in the class — she has been part of it for three years. You ask what Sophie would want: a class moment, a card, something low-key. Together you plan a brief farewell at the end of class on her last Friday — nothing big, just the class, a card signed by everyone, and a few words.",
     "options": [
       {"label": "Offer to tell the class yourself so Sophie doesn''t have to manage it.", "next": "debrief", "correct": true},
       {"label": "Ask whether Sophie would like to say something to the class or whether she''d prefer you to hold it.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "Mrs Chen''s eyes fill. ''Thank you,'' she says. ''I just didn''t want her to disappear.''",
     "isDebrief": true,
     "debriefText": "In transient school communities, departures are frequent enough to become invisible — and that invisibility is its own kind of harm. TCK research is clear that unacknowledged departures compound grief. Teachers who build rituals around leaving — even small ones — create the psychological safety that lets all students invest in relationships despite knowing they might end. Mrs Chen will tell every international school parent she knows in Singapore about this teacher.",
     "options": []
   }
 ]$nodes$::jsonb);

COMMIT;
