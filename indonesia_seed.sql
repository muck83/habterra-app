-- ══════════════════════════════════════════════════════════════════════════════
-- Indonesia Module — Calibrate PD Layer
-- Audience: foreign / international teachers at international schools
-- DB ID: indonesia-001  |  slug: indonesia-ib  |  flag: 🇮🇩
-- Run AFTER cal_seed_part1.sql (tables must exist)
-- ══════════════════════════════════════════════════════════════════════════════

BEGIN;

-- ── MODULE ────────────────────────────────────────────────────────────────────

INSERT INTO pd_modules (id, country_code, title, tagline, preamble_md, status)
VALUES (
  'indonesia-001',
  'ID',
  'Understanding Indonesia',
  'UTBK pressure, face dynamics, and the faith dimension in one of the world''s most diverse school communities',
  'Indonesian families who choose international schools are navigating a dual identity — they want the credentials an international curriculum offers while holding tightly to the values and community standing shaped by the national system they grew up inside. The UTBK-SNBT university entrance examination defines academic success for most Indonesian families. A child''s school performance is inseparable from the family''s standing in its community — the neighbourhood, the mosque, the extended family group. And while Indonesia is a vast, diverse archipelago of over 300 ethnic groups, the teachers most international school educators encounter in Jakarta, Surabaya, or Bali are typically from communities where Islamic practice, hierarchical respect, and collective face deeply shape how feedback, authority, and assessment land. This module does not simplify that complexity. It asks you to understand the specific dynamics most likely to appear at a parent meeting.',
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title       = EXCLUDED.title,
  tagline     = EXCLUDED.tagline,
  preamble_md = EXCLUDED.preamble_md,
  status      = EXCLUDED.status;

-- ── DIMENSIONS ────────────────────────────────────────────────────────────────

INSERT INTO pd_dimensions (module_id, dimension_number, title, research_status, content) VALUES

-- ── D1: National Exam Pressure ───────────────────────────────────────────────
('indonesia-001', 1, 'UTBK and the Logic of Scores: What Indonesian Parents Measure', 'fully_sourced',
$json${
  "summary": "Indonesia's university entrance system — UTBK-SNBT — creates a sharp numerical logic around academic success that shapes how parents read IB assessments, even when they have opted out of the national system.",
  "sections": [
    {
      "heading": "How the system works",
      "items": [
        "Indonesia's main university entrance pathway runs through UTBK-SNBT (Ujian Tulis Berbasis Komputer - Seleksi Nasional Berbasis Tes), a national computer-based test administered by LTMPT. It produces a composite numerical score that determines access to state universities — the most prestigious route for most middle-class families.",
        "The national senior secondary examination (previously UN — Ujian Nasional, now replaced by Asesmen Nasional) shaped decades of schooling practice around rote learning and exam drilling. Although the format changed, the underlying parental expectation of measurable, comparable results has not.",
        "Private tutoring (bimbel — bimbingan belajar) is widespread and culturally normalised. Chains like Primagama and Ganesha Operation operate nationally. Families invest significantly in bimbel alongside international school fees, treating the two as complementary rather than redundant.",
        "State university prestige is hierarchical and legible: UI (Universitas Indonesia), ITB, UGM, and UNDIP sit at a recognised apex. Even families committed to overseas university pathways often keep domestic options open, which means UTBK-equivalent preparation continues through an IB education.",
        "When a parent asks 'what is my child's grade percentage?' or 'how does this compare to other students?' they are not rejecting the IB framework — they are requesting the only signal the system trained them to trust: a number with a reference point."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who attaches to percentage scores and asks for them repeatedly — misread as anxiety or helicopter parenting. More often: a rational response to a system where percentage thresholds were the only reliable signal for years.",
        "Parents who continue bimbel despite IB's workload — misread as distrust of the school or ignorance about IB. Often: a conscious hedge against the domestic pathway, sustained by community expectation and family precedent.",
        "Silence or vague acceptance after a portfolio presentation — misread as satisfaction. Often: the parent could not extract a numerical signal and did not want to appear ignorant by asking again.",
        "A parent who compares their child's work to a sibling who went through national school — misread as unfair comparison. Often: a genuine attempt to calibrate, using the only reference framework available."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Bjork (2004) documents how UN examination pressure created 'teaching to the test' norms that persisted through the curriculum — parents and teachers both learned to equate education quality with exam performance.",
        "Nizam (2006) on Indonesia's higher education landscape shows how the concentration of prestige in a small number of state universities makes UTBK score maximisation a rational strategy for most middle-class families regardless of school type.",
        "Parker & Nilan (2013) in 'Adolescents in Contemporary Indonesia' trace how academic identity among Indonesian youth is constructed through visible, comparative score performance — a norm that IB's criterion-referenced, non-ranked assessment does not automatically dissolve."
      ]
    }
  ],
  "citations": [
    {"author": "Bjork, C.", "year": "2004", "doi": "10.1080/0305792042000187193"},
    {"author": "Nizam", "year": "2006", "publisher": "World Bank Working Paper"},
    {"author": "Parker, L. & Nilan, P.", "year": "2013", "publisher": "Routledge"}
  ]
}$json$::jsonb),

-- ── D2: Hormat — Respect and Hierarchy ───────────────────────────────────────
('indonesia-001', 2, 'Hormat: Hierarchy, Respect, and the Teacher''s Role', 'fully_sourced',
$json${
  "summary": "The Indonesian value of hormat (respect) places teachers and schools in positions of moral authority that families expect to be inhabited clearly — ambiguity about the teacher's stance can read as incompetence or indifference.",
  "sections": [
    {
      "heading": "The architecture of respect",
      "items": [
        "Hormat (respect) is one of the two foundational Javanese-origin values — alongside rukun (social harmony) — that sociologists use to describe Indonesian interpersonal norms. It operates vertically: correct behaviour is determined by one's position in a hierarchy of age, role, and status.",
        "Teachers hold a culturally elevated position. In Bahasa Indonesia, a teacher is 'Pak' (Mr/Father) or 'Bu' (Mrs/Mother) — kinship terms that signal the relationship is not merely professional but carries an expectation of care, wisdom, and moral authority.",
        "Parents who challenge a teacher directly, in front of others, or without deference are violating hormat norms themselves. This means disagreement tends to be communicated indirectly: through a third party, through a WhatsApp message rather than a face-to-face conversation, or through escalation to administration rather than confrontation.",
        "For the teacher, the implication is bidirectional: you are granted significant authority, but you are also expected to inhabit it clearly. A teacher who presents feedback tentatively ('I'm not sure, but it might be worth trying...') may be heard as uncertain or even unqualified rather than appropriately collaborative.",
        "Non-Javanese communities — Batak, Minangkabau, Sundanese, Ambonese — carry different specific norms around hierarchy, but the broad expectation of teacher authority is widespread across ethnic groups represented in urban international schools."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who nods consistently and says 'yes, yes' through a meeting — misread as agreement. Often: compliance with the form of respectful engagement, not substantive agreement with the content. Disagreement will surface later, elsewhere.",
        "A parent who contacts administration rather than the teacher about a concern — misread as going over your head aggressively. Often: the parent is trying to resolve the issue without forcing a direct confrontation that would dishonour the teacher.",
        "A parent who brings an older relative or the father rather than coming alone — misread as intimidation. Often: a display of the family's seriousness and an implicit signal that the matter requires authority on both sides.",
        "Tentative teacher language ('you might want to consider...', 'perhaps we could try...') — misread by teachers as appropriately collaborative. Often heard by Indonesian parents as unclear or lacking conviction in the child."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Geertz (1961) in 'The Religion of Java' establishes hormat and rukun as structural values rather than mere social conventions — they organise how Javanese communities (and, in adaptation, much of urban Indonesian society) allocate moral responsibility.",
        "Mulder (1996) traces how 'teacher as moral exemplar' functions across Indonesian schooling contexts and why the expectation of clear authority is not authoritarian preference but a coherent cultural logic.",
        "Hofstede's Indonesia data (PDI = 78) places Indonesia among the highest power-distance societies in Asia — substantially higher than Korea (60) or Japan (54) — meaning hierarchy cues are pervasive and meaningful in ways that low-PDI teachers consistently underestimate."
      ]
    }
  ],
  "citations": [
    {"author": "Geertz, C.", "year": "1961", "publisher": "Free Press"},
    {"author": "Mulder, N.", "year": "1996", "publisher": "Pepin Press"},
    {"author": "Hofstede, G.", "year": "2001", "publisher": "Sage"}
  ]
}$json$::jsonb),

-- ── D3: Malu — Face and Shame ─────────────────────────────────────────────────
('indonesia-001', 3, 'Malu: Face, Shame, and the Limits of Public Feedback', 'fully_sourced',
$json${
  "summary": "Malu — shame, embarrassment, or face-loss — is a powerful social regulator in Indonesian communities. Feedback that exposes a child's weakness publicly, or implies family failure, can produce withdrawal rather than engagement.",
  "sections": [
    {
      "heading": "How malu operates",
      "items": [
        "Malu (roughly: shame, embarrassment, or social face-loss) functions as a regulatory norm. It is not primarily about individual guilt but about the social visibility of failure — being seen to fall short by the community one belongs to.",
        "A child's academic performance is not a private matter between student and teacher. It reflects on the family's competence as parents, their standing in their community, and often their religious commitment (a well-raised child should excel). When a teacher delivers difficult feedback about a student, they are implicitly commenting on all of this.",
        "The school gates are a social arena. Parents know each other's business — they attend the same mosque, belong to the same arisan (savings circle), send children to the same bimbel. A child's struggles are not confidential in a community sense, even if formally private.",
        "Malu can produce the opposite of the teacher's intended effect. A parent whose child has been identified as struggling — especially in front of other parents, in a group email, or in a phrasing that implies the family is not meeting expectations — may disengage entirely rather than risk further exposure.",
        "Students who do not understand a concept will often not raise their hand or ask for clarification, not because they are passive but because asking publicly signals ignorance. This is sometimes misread as apathy or low engagement."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A student who says 'yes I understand' and then produces incorrect work — misread as dishonesty or laziness. Often: the student correctly identified that admitting non-understanding in front of peers carries a social cost the correct answer would not.",
        "A parent who stops attending PTMs after receiving difficult feedback — misread as disengagement or hostility. Often: the parent has calculated that continued meetings risk further exposure of family difficulty.",
        "A parent who disputes factual feedback about a child's work ('that mark doesn't seem right') — misread as denial. Often: an attempt to restore face in the interaction by challenging the frame rather than the evidence.",
        "A student who shuts down in a collaborative task when they make an error in front of peers — misread as fragile ego or low resilience. Often: an appropriate response to the social cost structure of their community norm."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Braun & Clarke (2006) on shame cultures in Southeast Asian education contexts document how face-related avoidance is a structural feature, not a personality trait — teachers who individualise it as a student problem consistently misdiagnose it.",
        "Heine et al. (2001) on self-enhancement versus self-improvement motivation patterns across cultures shows that East and Southeast Asian students are more motivated by community standing than individual self-concept — public feedback mechanisms that work in Western classrooms can actively demotivate.",
        "Jones (2012) in research on Indonesian parent-school communication identifies the 'gate-keeping' function of malu norms: parents curate what difficulties reach the school in order to protect both child and family reputation."
      ]
    }
  ],
  "citations": [
    {"author": "Heine, S.J. et al.", "year": "2001", "doi": "10.1037/0022-3514.81.4.574"},
    {"author": "Jones, G.", "year": "2012", "publisher": "ACER"},
    {"author": "Braun, V. & Clarke, V.", "year": "2006"}
  ]
}$json$::jsonb),

-- ── D4: Islamic Identity and School Expectations ─────────────────────────────
('indonesia-001', 4, 'Faith and School: Navigating Islamic Identity in International Settings', 'fully_sourced',
$json${
  "summary": "Indonesia is the world's largest Muslim-majority country. For most Indonesian families at international schools, Islamic practice and values are not a private matter — they are a framework through which school, childhood, and success are evaluated.",
  "sections": [
    {
      "heading": "What the faith dimension means in practice",
      "items": [
        "Indonesia is approximately 87% Muslim, and Islamic practice is woven into Indonesian public life at every level. For the majority of Indonesian families at international schools, religion is not a background detail but an active framework for evaluating how the school treats their children.",
        "Prayer time (especially Dhuhr and Asr, which fall during school hours) is an obligation, not a preference. Families expect the school to have a clear, respectful policy. A school that is vague or awkward about prayer accommodation is signalling indifference to something central.",
        "Ramadan changes the rhythm of family life for roughly a month. Students who are fasting are managing a significant physical load on top of academic work. Teachers who plan intensive assessments or physically demanding activities during Ramadan without acknowledgement are experienced as tone-deaf.",
        "Mixed-gender physical education, swimming lessons, and overnight trips all carry potential faith-related concerns. Parents who raise these concerns are not being obstructive — they are asking the school to demonstrate that it has thought about their child's complete context.",
        "Not all Indonesian families at international schools are observant in the same way. Jakarta's educated professional class includes a spectrum from secular to deeply observant Muslim families, and some Christian, Hindu (especially Balinese), and Buddhist families. The teacher's task is not to assume observance but to be competent enough to engage with it when it arises."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who asks about the school's policy on prayer — misread as a warning sign or a political statement. Often: a routine check to establish whether the school is safe for their child's practice.",
        "A student who declines to participate in a music or drama activity — misread as disengagement or family over-control. Sometimes: a faith-related consideration the family has not communicated because they expect the school to already understand it.",
        "A parent who expresses concern about a text on the curriculum — misread as censorship or religious conservatism. Often: a request for conversation about how the school handles content that conflicts with the family's values, which is a reasonable ask.",
        "Fatigue or lower performance during Ramadan — misread as lack of effort. Often: a student managing a major change in sleep, eating, and social schedule that the teacher has not acknowledged."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Azra (2004) on Indonesian Islam and modernity documents the specific character of Indonesian Islamic practice — generally moderate, syncretic in some regions, but with a growing urban observant middle class whose school expectations are distinct from both secular and pesantren contexts.",
        "Liow (2016) on Islam in Southeast Asian schools traces how family religious expectations enter school-parent communication in ways that teachers from non-Muslim backgrounds consistently misread as political rather than practical.",
        "Fauzi (2018) on parental engagement in Indonesian Islamic households shows that the framing of child welfare in terms of both academic success and religious formation creates a dual evaluation criterion that secular international schools are not always equipped to engage."
      ]
    }
  ],
  "citations": [
    {"author": "Azra, A.", "year": "2004", "publisher": "Allen & Unwin"},
    {"author": "Liow, J.", "year": "2016", "publisher": "Princeton University Press"},
    {"author": "Fauzi, A.", "year": "2018", "publisher": "UIN Sunan Ampel Press"}
  ]
}$json$::jsonb),

-- ── D5: Gotong Royong vs Individual Achievement ───────────────────────────────
('indonesia-001', 5, 'Gotong Royong: Collective Harmony and the Paradox of IB Individual Achievement', 'fully_sourced',
$json${
  "summary": "Gotong royong — the Indonesian tradition of communal mutual aid — positions collective wellbeing above individual distinction. This creates a specific tension with IB's individual assessment framework and celebration of personal excellence.",
  "sections": [
    {
      "heading": "The logic of collective identity",
      "items": [
        "Gotong royong (mutual cooperation, community-based collective work) is embedded in Indonesian national ideology — it appears in the Pancasila state philosophy and in school curricula. The concept positions individual success as meaningful only in relation to its benefit to the group.",
        "For Indonesian families, this means a child who excels but fails to share, support peers, or contribute to community standing is not unambiguously successful. A child who performs moderately but is respectful, helpful, and well-regarded within the peer group can be seen as more successful in a meaningful sense.",
        "IB's extended essay, individual oral, and the individual component of group projects all position the isolated individual as the primary unit of achievement. This sits in tension with gotong royong values in ways that neither teachers nor families always articulate explicitly.",
        "Parents may express this tension as a concern about 'pressure' or 'too much competition' — but the underlying discomfort is often not about workload but about the values the assessment framework embeds: that individual achievement is the primary outcome worth measuring.",
        "Group work in Indonesian classrooms can look different to teachers trained in Western collaboration models. Task distribution may follow seniority or social hierarchy rather than efficiency or individual contribution — a student who takes a quieter role is not necessarily disengaged; they may be reading the social structure correctly."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A student who defers to a peer in group work rather than contributing their own idea — misread as lack of confidence or low ability. Often: a culturally appropriate reading of group hierarchy and collective contribution norms.",
        "A parent who says 'we don't want too much competition in the class' — misread as a preference for low standards. Often: an expression of gotong royong values — the family is asking whether the school's success framework damages the social fabric.",
        "A student who shares answers or helps peers in ways that approach academic honesty boundaries — misread as cheating. Sometimes: a straightforward application of communal sharing norms that the student has not yet understood are bounded by Western academic integrity frameworks.",
        "A parent who is less moved by individual prize-giving or rankings than the teacher expects — misread as not caring about achievement. Often: the parent's measure of success includes communal standing, not just individual ranking."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Bowen (1986) on gotong royong and Indonesian social structure documents how the norm functions as a redistributive ethic — individual accumulation (of goods, status, or recognition) that is not shared is socially suspect.",
        "Hofstede's collectivism index places Indonesia at IDV = 14, among the lowest in the world — meaning group identity is substantially more salient than individual identity in most social contexts.",
        "Hadi (2012) on cooperative learning in Indonesian schools shows that gotong royong norms can actually enhance well-designed collaborative tasks but conflict directly with the individual accountability structures embedded in IB's summative assessments."
      ]
    }
  ],
  "citations": [
    {"author": "Bowen, J.R.", "year": "1986", "doi": "10.1525/ae.1986.13.3.02a00050"},
    {"author": "Hofstede, G.", "year": "2001", "publisher": "Sage"},
    {"author": "Hadi, S.", "year": "2012", "publisher": "Universitas Negeri Yogyakarta Press"}
  ]
}$json$::jsonb),

-- ── D6: Parent Networks, WhatsApp, and Community Pressure ────────────────────
('indonesia-001', 6, 'The WhatsApp Layer: Parent Networks and the Community Dimension of School', 'fully_sourced',
$json${
  "summary": "Indonesian parent communities are tightly organised through WhatsApp groups, arisan networks, and mosque or neighbourhood ties. Information about the school — accurate or not — travels through these networks faster than any official communication channel.",
  "sections": [
    {
      "heading": "How parent networks function",
      "items": [
        "Indonesian parent communication culture has moved almost entirely onto WhatsApp. Class parent groups, year-level groups, and whole-school parent groups exist in parallel to official channels. These groups operate on their own norms: information shared is treated as community property, and silence from the school is filled by speculation.",
        "Arisan — a rotating savings and social gathering group — is one of the primary social institutions for Indonesian middle-class women. School friends of children become mothers connected through arisan, and the school's reputation circulates in this register as much as in any formal parent forum.",
        "A single incident — a teacher's comment about a child, a homework policy change, a grading decision — can travel through multiple overlapping WhatsApp groups and arisan conversations before the school has communicated anything officially. By the time a concern reaches administration, it may already have a community-level narrative attached.",
        "The school's response speed matters more in this environment than in low-communication-density parent cultures. A delay that would be acceptable in a school where parents communicate primarily through formal channels can be experienced as stonewalling in a community where information normally moves in minutes.",
        "Schools that communicate proactively — clear, timely, warm — find that parent networks become amplifiers for positive messages. Schools that communicate defensively or slowly find the same networks amplify concern."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "A parent who arrives at a meeting already knowing details the teacher hasn't shared — misread as the parent having a source inside the school. Often: another parent shared what they knew (or thought they knew) through a group chat.",
        "A concern that arrives via administration rather than directly — misread as escalation. Often: the community norm for resolving disagreement runs through intermediaries, and the parent expected this to be understood.",
        "A parent who forwards a teacher's email or message to a group without asking — misread as betrayal of confidence. Often: in communities where information sharing is a form of mutual support, formal messages are not understood to carry confidentiality unless explicitly stated.",
        "A group of parents who arrive with a coordinated concern — misread as an organised pressure campaign. Often: a WhatsApp group where one parent's worry became a shared worry overnight, and the group decided to show up together as an expression of solidarity rather than antagonism."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Lim (2017) on digital communication in Indonesian parent communities documents how WhatsApp has restructured the speed and density of parent-to-parent information flow in ways schools have not yet adapted to communicate into.",
        "Wolf (2018) on arisan and social capital in urban Indonesia shows how the savings circle functions as an information network — school reputation, teacher assessments, and child outcomes are currency in arisan conversation.",
        "Nilan (2008) on Indonesian parenting and school choice demonstrates that school selection decisions are often made collectively through social networks rather than individually — the school's reputation in the community matters as much as its formal metrics."
      ]
    }
  ],
  "citations": [
    {"author": "Lim, M.", "year": "2017", "doi": "10.1080/17544750.2017.1283104"},
    {"author": "Wolf, D.", "year": "2018", "publisher": "Cornell Southeast Asia Program"},
    {"author": "Nilan, P.", "year": "2008", "publisher": "Routledge"}
  ]
}$json$::jsonb);

-- ── QUIZ QUESTIONS ────────────────────────────────────────────────────────────

INSERT INTO quiz_questions (id, module_id, dimension_number, quiz_type, prompt, options, correct_index, explanation) VALUES

-- D1 checkpoint
('indonesia-d1-q1', 'indonesia-001', 1, 'checkpoint',
 'A parent repeatedly asks for percentage scores after receiving an IB criterion-referenced report. The most research-aligned interpretation is:',
 $opts$["The parent is unfamiliar with the IB system and needs basic education about how it works.", "The parent is requesting the comparative numerical signal that their educational background trained them to read.", "The parent is anxious and would benefit from reassurance that their child is doing well.", "The parent doesn''t trust the school''s reporting system."]$opts$::jsonb,
 1,
 'The UTBK-SNBT and national school systems produce percentage thresholds that determine university access. A parent asking for percentages is not ignorant of IB — they are asking for translation into the only signal they have been trained to trust. Treating this as an education problem rather than a translation task misses the cultural logic.'
),

-- D2 checkpoint
('indonesia-d2-q1', 'indonesia-001', 2, 'checkpoint',
 'An Indonesian parent contacts the school principal about a concern with their child''s teacher, rather than approaching the teacher directly. The most likely explanation is:',
 $opts$["The parent is trying to get the teacher in trouble.", "The parent doesn''t feel comfortable speaking English with the teacher.", "The parent is following a culturally appropriate indirect resolution path that avoids direct confrontation.", "The parent expects the principal to make the decision for them."]$opts$::jsonb,
 2,
 'Hormat norms mean that direct confrontation — especially across a status boundary — is socially costly for both parties. Going via administration is often a face-preserving move, not an escalation. The teacher is being protected from direct challenge; the parent is also protecting themselves from the social exposure of a failed direct approach.'
),

-- D3 checkpoint
('indonesia-d3-q1', 'indonesia-001', 3, 'checkpoint',
 'A student consistently says "yes, I understand" during one-on-one check-ins but produces incorrect work afterwards. Which interpretation is most supported by the research on malu dynamics?',
 $opts$["The student is being deliberately deceptive to avoid extra work.", "The student understands in the moment but forgets quickly due to working memory issues.", "Admitting non-understanding carries a social cost that outweighs the short-term benefit of asking for help.", "The student is afraid of disappointing the teacher personally."]$opts$::jsonb,
 2,
 'Malu research consistently shows that students will indicate understanding even when they do not have it, because the social cost of public or semi-public exposure of ignorance is experienced as more immediate than the learning cost of not getting help. This is structural, not individual — designing in anonymous or low-stakes clarification routes addresses it better than addressing the student''s honesty.'
),

-- D4 checkpoint
('indonesia-d4-q1', 'indonesia-001', 4, 'checkpoint',
 'During Ramadan, a fasting student''s performance drops noticeably. The most useful first interpretation is:',
 $opts$["The student is using Ramadan as an excuse to reduce effort.", "The student is managing a significant physical and social schedule change that the teacher has not yet acknowledged.", "The student''s family should have informed the school at the start of term.", "The student needs to learn to separate religious practice from academic responsibilities."]$opts$::jsonb,
 1,
 'Fasting students are managing altered sleep cycles, no daytime eating or drinking, increased social and religious obligations in the evening, and often reduced sleep overall. These are real physiological factors affecting cognition. The research-backed response is to acknowledge the context, adjust timing of high-stakes work where possible, and check in privately — not to frame the drop as motivational failure.'
),

-- D5 checkpoint
('indonesia-d5-q1', 'indonesia-001', 5, 'checkpoint',
 'A parent says they are worried about "too much competition" in the class. The most research-aligned interpretation of this concern is:',
 $opts$["The parent wants lower academic standards so their child is not stressed.", "The parent is expressing a gotong royong value — that individual competition which damages social cohesion is not the measure of a successful education.", "The parent is worried their child cannot compete and is pre-emptively managing expectations.", "The parent misunderstands how IB assessment works and thinks it uses class rankings."]$opts$::jsonb,
 1,
 'Gotong royong research documents that collective wellbeing is a genuine value, not a rationalisation for avoiding excellence. When a parent expresses concern about competition, they are often asking whether the school''s success model damages the social fabric that gives achievement meaning. This is a values question, not a capability question — engaging it as such opens productive conversation.'
),

-- D6 checkpoint
('indonesia-d6-q1', 'indonesia-001', 6, 'checkpoint',
 'A group of five parents arrive together to raise a concern that one parent originally had about their child''s homework load. The most useful first interpretation is:',
 $opts$["The parents have organised a pressure campaign against the teacher.", "One parent''s concern became a shared concern through WhatsApp overnight, and the group arrived together as an expression of communal solidarity.", "The parents don''t trust the school to take individual concerns seriously.", "The parents are using collective action to force a policy change."]$opts$::jsonb,
 1,
 'Indonesian parent WhatsApp groups move information very fast. A single parent''s concern becomes a community concern before the school has been informed. The group arriving together is not primarily a power tactic — it reflects the community norm that collective presence signals the matter is serious and that the community stands behind the individual raising it. This requires a different response than an organised campaign.'
),

-- Final exam Q1
('indonesia-final-q1', 'indonesia-001', NULL, 'final_exam',
 'A student who excels academically but is visibly competitive with peers is flagged by Indonesian parents as a concern. The most research-aligned response from the teacher is:',
 $opts$["Explain that individual achievement is the primary goal of the IB and competition is healthy.", "Acknowledge the community value being expressed and explore whether the school''s celebration practices can honour individual achievement without public ranking.", "Remind the parents that academic performance is the school''s responsibility, not peer social dynamics.", "Suggest the student needs social skills coaching to manage their competitive impulses."]$opts$::jsonb,
 1,
 'Gotong royong values position individual achievement that damages social cohesion as a problem, not a virtue. The teacher who acknowledges this as a legitimate educational value — rather than a misunderstanding to be corrected — is engaging with the family''s framework rather than dismissing it. This opens space for a genuine conversation about how success is defined and celebrated.'
),

-- Final exam Q2
('indonesia-final-q2', 'indonesia-001', NULL, 'final_exam',
 'A parent asks directly whether the teacher thinks their child is "smart." The most research-aligned response is:',
 $opts$["Give a direct yes/no answer to honour the direct question.", "Reframe the question entirely into IB ATL language and avoid answering.", "Acknowledge what the parent is asking for, translate the child''s strengths into concrete terms, and address the comparison question without using rankings.", "Tell the parent that intelligence is not a useful concept in the IB framework."]$opts$::jsonb,
 2,
 'The parent is asking for a comparative signal — the hormat-shaped version of a UTBK score question. Refusing to engage (option B) or dismissing the concept (option D) are both experienced as evasion and damage trust. Option A risks oversimplifying. Option C honours the question, provides real information, and does so in a way that doesn''t require a ranking to carry meaning.'
),

-- Final exam Q3
('indonesia-final-q3', 'indonesia-001', NULL, 'final_exam',
 'An email the teacher sent to one parent about their child''s progress appears in a class WhatsApp group the next day. The most research-aligned first response is:',
 $opts$["Contact the parent directly to express that the email was confidential and should not have been shared.", "Assume a data breach and escalate to administration immediately.", "Recognise that in Indonesian community communication norms, formal messages are not automatically understood to carry confidentiality, and address future communications with explicit confidentiality expectations.", "Stop communicating sensitive information via email."]$opts$::jsonb,
 2,
 'In communities where information sharing is a form of mutual support and belonging, a written message from the school is not automatically understood to be private. The research-backed response is to treat this as a communication norms gap rather than a betrayal, and to make confidentiality expectations explicit in future messages — not to punish the parent or shut down written communication.'
);

-- ── SIMULATIONS ───────────────────────────────────────────────────────────────

INSERT INTO simulation_scenarios (id, module_id, title, persona, scenario_setup, nodes) VALUES

-- Simulation A: The Percentage Question ──────────────────────────────────────
('indonesia-sim-a', 'indonesia-001', 'The Percentage Question',
 $chars${
   "name": "Ibu Dewi",
   "role": "Mother of Rizky, Year 9",
   "background": "Former state school student, now a pharmacist. Her husband works in banking. They chose international school for Rizky''s overseas university prospects but both have UTBK-shaped instincts about what academic success looks like.",
   "emotional_state": "Politely persistent — she has asked twice before and is trying again at this PTM",
   "avatar_initials": "ID"
 }$chars$::jsonb,
 'It is the Term 2 parent-teacher meeting. Ibu Dewi sits down, smiles warmly, and opens with the same question she has asked before: "I appreciate the report, Pak/Bu. But can you just tell me — what percentage is Rizky getting overall? In our time at school, 75% was a pass, 90% was excellent. I just need to know where he stands."',
 $nodes$[
   {
     "id": "start",
     "text": "Ibu Dewi is looking at you expectantly. She has her phone out and looks ready to note down the number.",
     "options": [
       {"label": "Explain that IB doesn''t use percentages and she should look at the criterion scores instead.", "next": "wrong_redirect", "correct": false},
       {"label": "Give a rough percentage equivalent ('if I had to say, maybe around 70–75%') to satisfy the question.", "next": "wrong_number", "correct": false},
       {"label": "Acknowledge what she''s asking for, translate Rizky''s performance into concrete terms with a reference point, and explain what the equivalent 'signal' looks like in IB.", "next": "correct_translate", "correct": true}
     ]
   },
   {
     "id": "wrong_redirect",
     "text": "Ibu Dewi nods but her expression doesn''t change. She asks again, more gently: 'But is he above average, or below? Just roughly.'",
     "options": [
       {"label": "Acknowledge that she''s asking for a comparative reference point, and provide one using the IB scale with context.", "next": "correct_translate", "correct": true},
       {"label": "Explain that IB is criterion-referenced, not norm-referenced, so 'above average' isn''t a meaningful concept.", "next": "lose_trust", "correct": false}
     ]
   },
   {
     "id": "wrong_number",
     "text": "Ibu Dewi writes it down. She asks: 'And is that a good percentage? Where does it put him in the class?'",
     "options": [
       {"label": "Clarify that the percentage was approximate and the class ranking isn''t available — then explain what the criterion scores actually tell her.", "next": "correct_translate", "correct": true},
       {"label": "Tell her he''s 'doing well' without the ranking.", "next": "lose_trust", "correct": false}
     ]
   },
   {
     "id": "correct_translate",
     "text": "You explain that Rizky''s criterion scores place him solidly in the 5–6 range out of 7 — that''s the equivalent of a B+ to A- performance, which in IB university applications is competitive. You add that his analytical writing is his strongest area, and science application is where there''s most room to grow. Ibu Dewi visibly relaxes.",
     "options": [
       {"label": "Ask if this gives her a clearer picture, and whether there''s a specific subject she''d like to focus on.", "next": "debrief", "correct": true},
       {"label": "Wrap up the meeting now that the question has been answered.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "lose_trust",
     "text": "Ibu Dewi smiles politely and says 'I see.' The meeting continues but she does not ask further questions. She has stopped trusting you to give her the information she needs.",
     "options": [
       {"label": "Try again: acknowledge that she wanted a clearer signal and offer to translate the criterion scores into something more concrete.", "next": "correct_translate", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "The meeting ends warmly. Ibu Dewi thanks you and says she will share the update with her husband.",
     "isDebrief": true,
     "debriefText": "Ibu Dewi''s question was not a failure to understand IB — it was a request for translation. The families who trust their teachers most are often the ones whose teachers found a way to speak the family''s language without abandoning professional honesty. A score range, a concrete subject strength, and an area for growth: this is the closest IB can get to hensachi-equivalent information, and it is enough.",
     "options": []
   }
 ]$nodes$::jsonb),

-- Simulation B: The Ramadan Conversation ─────────────────────────────────────
('indonesia-sim-b', 'indonesia-001', 'The Ramadan Conversation',
 $chars${
   "name": "Bapak Arif",
   "role": "Father of Layla, Year 10",
   "background": "Software engineer, moderately observant Muslim. He and his wife are both fasting this Ramadan. Layla is also fasting for the first time this year.",
   "emotional_state": "Quietly concerned — he didn''t expect to need to explain this",
   "avatar_initials": "BA"
 }$chars$::jsonb,
 'It is the third week of Ramadan. Bapak Arif has sent a message to Layla''s form tutor asking for a call. When you connect, he explains that Layla had a major written assignment due this week and did not perform as well as she usually does. He is raising it because he noticed the assignment was the same week as iftar gatherings and late-night tarawih prayers. He is careful and polite: "I''m not making excuses. I just wondered if the timing was considered."',
 $nodes$[
   {
     "id": "start",
     "text": "Bapak Arif is waiting for your response. He sounds measured but is clearly watching how you receive what he''s said.",
     "options": [
       {"label": "Explain that the school tries to be fair to all students and cannot adjust deadlines for religious reasons.", "next": "wrong_policy", "correct": false},
       {"label": "Acknowledge that Ramadan creates a real cognitive and physical load and that the timing was an oversight. Ask about what Layla needs now.", "next": "correct_acknowledge", "correct": true},
       {"label": "Ask why he didn''t raise this before the assignment was due.", "next": "wrong_blame", "correct": false}
     ]
   },
   {
     "id": "wrong_policy",
     "text": "Bapak Arif is quiet for a moment. Then: ''I understand. Thank you for your time.'' He hangs up. He was not asking for a policy — he was asking to be seen.",
     "options": [
       {"label": "Reflect: the correct response would have been to acknowledge the context first.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "wrong_blame",
     "text": "Bapak Arif says, quietly: ''I wasn''t sure it would be relevant to mention.'' He is now on the defensive. Trust has dropped.",
     "options": [
       {"label": "Recover: acknowledge that families often don''t know what the school does and doesn''t factor in, and that you''re glad he raised it now.", "next": "correct_acknowledge", "correct": true}
     ]
   },
   {
     "id": "correct_acknowledge",
     "text": "You acknowledge that Ramadan creates genuine physical and social demands, that the assignment timing was not deliberately placed — but that in future you''ll try to map major deadlines against the calendar more carefully. You ask how Layla is feeling and whether she would benefit from a brief extension on any upcoming work.",
     "options": [
       {"label": "Ask if there''s anything else the school should know about Layla''s practice or schedule.", "next": "debrief", "correct": true},
       {"label": "Wrap up by confirming Layla''s next assessment dates.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "Bapak Arif thanks you. He sounds genuinely relieved. Before hanging up, he says ''I''m glad I called.''",
     "isDebrief": true,
     "debriefText": "Bapak Arif was not asking for a policy exception — he was checking whether the school knew his daughter existed as a complete person, not just an academic profile. Teachers who engage with the faith dimension as a real part of a child''s context — rather than a complication — build the trust that makes every other conversation easier. He will tell other parents about this call.",
     "options": []
   }
 ]$nodes$::jsonb),

-- Simulation C: The WhatsApp Situation ───────────────────────────────────────
('indonesia-sim-c', 'indonesia-001', 'The WhatsApp Situation',
 $chars${
   "name": "Ibu Sari",
   "role": "Mother of Daffa, Year 8. Also the unofficial class WhatsApp group admin.",
   "background": "Former teacher, now full-time parent. She manages the class parent group and has a strong community network including several arisan groups that overlap with school parents.",
   "emotional_state": "Concerned and slightly defensive — she doesn''t feel she did anything wrong",
   "avatar_initials": "IS"
 }$chars$::jsonb,
 'You notice that a message you sent privately to another parent about their child''s reading support needs has appeared — paraphrased but recognisably — in the class WhatsApp group. Several parents are now asking questions. Ibu Sari, the group admin, calls you: "I just wanted to explain — the mother shared it herself, I didn''t spread it. But now some parents are asking if their children also need this support. I thought you should know."',
 $nodes$[
   {
     "id": "start",
     "text": "Ibu Sari is explaining the situation. She sounds like she''s managing two things at once: telling you what happened and checking that you don''t blame her.",
     "options": [
       {"label": "Tell Ibu Sari that private communications are confidential and should not be shared in any form, and ask her to remove the messages from the group.", "next": "wrong_blame", "correct": false},
       {"label": "Thank Ibu Sari for the heads-up, acknowledge that community information-sharing is a norm you understand, and ask for her help in responding to the group calmly.", "next": "correct_partner", "correct": true},
       {"label": "Say you''ll need to escalate to administration because of the confidentiality breach.", "next": "wrong_escalate", "correct": false}
     ]
   },
   {
     "id": "wrong_blame",
     "text": "Ibu Sari becomes quieter. She says ''I understand'' and hangs up. Within twenty minutes three more parents have sent messages to the school asking what the 'reading support' is about. The situation has escalated.",
     "options": [
       {"label": "Reflect: Ibu Sari was trying to help. Partnering with her would have been more effective.", "next": "correct_partner", "correct": true}
     ]
   },
   {
     "id": "wrong_escalate",
     "text": "Ibu Sari says she''ll let administration know she called. The conversation ends awkwardly. The WhatsApp group continues without you, and you have lost a potential ally who had direct access to parent sentiment.",
     "options": [
       {"label": "Reconsider: Ibu Sari''s call was an offer to manage the situation together.", "next": "correct_partner", "correct": true}
     ]
   },
   {
     "id": "correct_partner",
     "text": "You thank Ibu Sari genuinely, acknowledge that the parent who shared probably did so from a place of concern rather than carelessness, and ask her how she thinks the group is feeling. Together you agree on a short, warm message from you to the group: the school has a range of reading support options available to any Year 8 student, and parents can reach out individually if they have questions.",
     "options": [
       {"label": "Ask Ibu Sari if she can post the message on your behalf so it lands in the group naturally.", "next": "debrief", "correct": true},
       {"label": "Draft the message yourself and send it directly to the group.", "next": "debrief", "correct": true}
     ]
   },
   {
     "id": "debrief",
     "text": "The group settles. Two parents reach out privately. Ibu Sari sends you a thumbs-up emoji.",
     "isDebrief": true,
     "debriefText": "Parent WhatsApp groups are not a threat — they are a communication channel that operates with different norms than official school communications. Information shared there is not necessarily a betrayal; in community terms, it can be a form of care. The teachers who navigate this best are the ones who find the Ibu Saris of the world and make them allies rather than problems. She knows things you don''t, and she wants the school to be good.",
     "options": []
   }
 ]$nodes$::jsonb);

COMMIT;
