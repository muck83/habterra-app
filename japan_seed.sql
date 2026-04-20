-- ══════════════════════════════════════════════════════════════════════════════
-- Japan Module — Calibrate PD Layer
-- Audience: foreign / international teachers at international schools
-- DB ID: japan-001  |  slug: japan-ib  |  flag: 🇯🇵
-- Run AFTER cal_seed_part1.sql (tables must exist)
-- ══════════════════════════════════════════════════════════════════════════════

BEGIN;

-- ── MODULE ────────────────────────────────────────────────────────────────────

INSERT INTO pd_modules (id, country_code, title, tagline, preamble_md, status)
VALUES (
  'japan-001',
  'JP',
  'Understanding Japan',
  'Entrance exams, collective harmony, and the invisible pressure on your students',
  'Japanese families choosing international schools are not abandoning the system that shaped them — they are hedging against it. The juken (受験) pathway to university runs on measurable rankings and entrance examination scores. Every parent who sat that system, or watched their child sit it, carries a precise mental model of what assessment looks like: comparable, ranked, decisive. When an IB teacher offers a narrative report, a portfolio, or criterion-referenced grades with no class ranking, the parent who asks "but how does this compare?" is not resisting inquiry-based education. They are asking for the signal the system trained them to read. This module does not ask you to replicate that signal. It asks you to understand why its absence feels like silence — and how to speak into that silence in a way that builds trust rather than widening the gap.',
  'live'
)
ON CONFLICT (id) DO UPDATE SET
  title      = EXCLUDED.title,
  tagline    = EXCLUDED.tagline,
  preamble_md = EXCLUDED.preamble_md,
  status     = EXCLUDED.status;

-- ── DIMENSIONS ────────────────────────────────────────────────────────────────

INSERT INTO pd_dimensions (module_id, dimension_number, title, research_status, content) VALUES

-- ── D1: The Juken System ──────────────────────────────────────────────────────
('japan-001', 1, 'The Juken System: What Examinations Mean in Japan', 'fully_sourced',
$json${
  "summary": "Japan's university entrance examination system shapes how families understand assessment at every level — IB narrative reports are read against a backdrop where comparative ranking is the only trusted signal.",
  "sections": [
    {
      "heading": "How the system works",
      "items": [
        "Japan's university entry pathway runs through the Common Test for University Admissions (共通テスト, formerly Center Shiken) followed by university-specific second-stage examinations — multiple high-stakes days that reduce years of work to a set of numerical scores.",
        "Juku (cram schools) are not supplementary; for many families they are the primary educational institution. A 2019 MEXT survey found 40% of elementary school students and over 60% of junior high students attending juku — often more hours per week than school itself.",
        "Rankings are granular and public. Hensachi (偏差値), a deviation score normalised to a class mean of 50, is the universal currency of academic comparison. Parents, students, and juku advisors refer to it fluently and often before a child's name.",
        "The system selects intensively for compliance, accuracy, and speed under pressure — all virtues that IB deliberately underweights. A student who excels at juken-style drilling may appear to struggle with open-ended IB tasks not because of ability but because the cognitive mode is genuinely different.",
        "Families who choose international school are not immune to this logic. Many are hedging: pursuing IB credentials for overseas university admission while maintaining the possibility of a domestic route. The two frameworks coexist uneasily in the same household."
      ]
    },
    {
      "heading": "What teachers misread",
      "items": [
        "'My child needs to know where they stand' — misread as anxiety or competitiveness. Actually: a request for hensachi-equivalent information that no IB criterion can supply. The parent knows the IB doesn't rank; they want you to translate.",
        "Silence after a positive report — misread as satisfaction. Often: the report contained no comparative data, so the parent has no idea if the result is good or just pleasant-sounding.",
        "Parents sending children to juku alongside IB — misread as distrust of the school. Often: a rational hedge against the possibility that IB credentials won't open domestic university doors, or simply the continuation of a family norm.",
        "Requests for predicted grades early and often — misread as pressure. Actually: in a system where hensachi drives school selection decisions months in advance, early numeric projections are the only planning tool families understand."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Kariya (2011) documents the juken intensification across cohorts and its effect on family investment strategies — families that cannot afford juku increasingly see international school as an alternative credentialing pathway rather than a philosophical choice.",
        "Takayama (2008) on the 'crisis discourse' in Japanese education shows how government reform rhetoric (yutori kyoiku — relaxed education) provoked a parental backlash that increased juku enrollment, suggesting deep distrust of any system that reduces measurable outcomes.",
        "The MEXT 2022 white paper records 4,856 IB-candidate or authorised programmes in Japan as of 2021, up from 16 in 2010 — a 300x increase driven almost entirely by domestic university pathways recognising IB Diplomas."
      ]
    }
  ],
  "citations": [
    {"author": "Kariya, T.", "year": "2011", "doi": "10.1080/03057925.2011.573503"},
    {"author": "Takayama, K.", "year": "2008", "doi": "10.1080/03057920802036809"},
    {"author": "MEXT Japan", "year": "2022"}
  ]
}$json$::jsonb),

-- ── D2: Wa — Group Harmony ────────────────────────────────────────────────────
('japan-001', 2, 'Wa (和): Group Harmony and the Problem with Standing Out', 'fully_sourced',
$json${
  "summary": "The cultural norm of wa — collective harmony — means that individual recognition, public correction, and comparative singling-out can all be experienced as social disruptions rather than positive or neutral events.",
  "sections": [
    {
      "heading": "The logic of collective identity",
      "items": [
        "Wa (和) is not mere politeness — it is a structural principle. Group cohesion is maintained by avoiding actions that make any member conspicuous, whether through failure or exceptional success. The proverb 'deru kui wa utareru' (出る杭は打たれる — the nail that sticks up gets hammered down) is not ironic; it is descriptive.",
        "In classroom terms, a student who answers confidently before peers can be evaluated, a student who corrects the teacher publicly, or a student singled out for individual praise may all experience social cost within the peer group even when the teacher's intention is purely positive.",
        "This dynamic is not uniform — international school students are self-selected to be more comfortable with individual expression than domestic school peers. But the family culture they return to in the evening is still shaped by these norms, and the expectations parents bring to PTMs often reflect them.",
        "Group-based assessment (presentations, collaborative projects, group IAs) surfaces the tension directly. A student who deliberately underperforms to avoid outshining peers is not being lazy — they are navigating a real social calculation."
      ]
    },
    {
      "heading": "For teachers",
      "items": [
        "Public praise can backfire. Naming a student as 'the best in the class' in front of peers or parents can isolate them socially. Prefer specific private feedback or framing achievement as the group's context ('this standard is what the cohort is working toward').",
        "Student silence in discussions is not passivity. A student who does not volunteer answers in open whole-class discussion may be entirely engaged and may perform strongly in written or small-group contexts where the social calculus is different.",
        "Parents who minimise their child's achievements ('oh, she doesn't work hard enough, she's not very bright') are often performing appropriate modesty (kenjō, 謙遜) — not signalling genuine concern. Treat it as social form, not clinical data.",
        "Feedback that identifies a student as an outlier — top or bottom — should be delivered privately, with care for how the parent will relay it at home."
      ]
    },
    {
      "heading": "Research context",
      "items": [
        "Hofstede's individualism score for Japan (46) is significantly lower than most anglophone countries (Australia 90, USA 91) but higher than many East Asian comparators — suggesting a complex individualism that operates differently in school vs workplace contexts.",
        "Markus and Kitayama's (1991) foundational paper on independent vs interdependent self-construal remains the reference frame; subsequent Japan-specific work by Heine et al. (1999) showed Japanese participants were significantly less likely to self-enhance than North American counterparts, even when accurate self-assessment was incentivised."
      ]
    }
  ],
  "citations": [
    {"author": "Markus, H. & Kitayama, S.", "year": "1991", "doi": "10.1037/0033-295X.98.2.224"},
    {"author": "Heine, S. et al.", "year": "1999", "doi": "10.1037/0022-3514.77.6.1268"},
    {"author": "Hofstede, G.", "year": "2001"}
  ]
}$json$::jsonb),

-- ── D3: Tatemae and Honne ─────────────────────────────────────────────────────
('japan-001', 3, 'Tatemae and Honne: Reading What Is Not Said', 'fully_sourced',
$json${
  "summary": "Tatemae (public face) and honne (true feeling) operate as a communication system — Japanese parents and students routinely present one thing and mean another, and a teacher who takes the surface presentation at face value will consistently misread the relationship.",
  "sections": [
    {
      "heading": "How the system works",
      "items": [
        "Tatemae (建前) is the socially appropriate public position; honne (本音) is the private, often unspeakable actual view. Both are real. The person presenting tatemae is not lying — they are participating in a shared social contract that keeps interaction smooth.",
        "In a PTM, a parent who says 'thank you, we are very satisfied' (tatemae) may simultaneously be composing a detailed complaint to the principal (honne). The surface expression of satisfaction is not a reliable signal of actual satisfaction.",
        "Indirect communication channels (the classroom parent representative, the PTA, a carefully worded formal letter) often carry more actual signal than the direct conversation with the teacher. A complaint that arrives through three intermediaries is not bureaucratic obstruction — it is high-status communication.",
        "Students use the same system. 'I understand' (wakarimashita, 分かりました) is often tatemae. It signals that the interaction can proceed, not that comprehension has occurred. Checking understanding by asking a student to demonstrate or explain rather than confirm is more reliable."
      ]
    },
    {
      "heading": "Practical implications",
      "items": [
        "Never read silence or polite agreement as consent or understanding. Build in verification: ask students to show you their thinking, not confirm it.",
        "The most important feedback you receive about a Japanese parent's actual concerns may not come from the parent directly. Stay alert to what comes through the class rep, the PTA secretary, or the school admin office.",
        "When you need honest input from a Japanese parent or student, lower the social stakes of honesty. Anonymous written feedback, small-group conversations, or framing as a question ('I'm trying to improve how I explain this — what was confusing?') work better than 'please tell me if anything is wrong'.",
        "If a parent smiles and nods throughout a difficult meeting — a meeting where you shared a failing grade, a behavioural concern, a missed deadline — do not assume they have processed the information positively. Follow up in writing."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Gudykunst and Nishida's (1994) work on low- and high-context communication remains foundational; Japan scores among the highest context-dependency of any national culture studied, meaning proportionally less meaning is carried by explicit verbal content.",
        "Yamada (1997) on conversational style shows that Japanese business and educational conversations operate on the premise that shared context replaces explicit statement — a premise that fails entirely when one party (the teacher) does not share that context."
      ]
    }
  ],
  "citations": [
    {"author": "Gudykunst, W. & Nishida, T.", "year": "1994"},
    {"author": "Yamada, H.", "year": "1997"},
    {"author": "Hall, E.T.", "year": "1976"}
  ]
}$json$::jsonb),

-- ── D4: Teacher Authority ─────────────────────────────────────────────────────
('japan-001', 4, 'Sensei: Teacher Authority and the Limits of Challenge', 'partial',
$json${
  "summary": "In Japan, 'sensei' (先生) carries institutional weight that 'teacher' does not — challenging a teacher's judgement is socially costly, which means the absence of challenge cannot be read as agreement.",
  "sections": [
    {
      "heading": "What sensei means",
      "items": [
        "The word sensei (先生, literally 'one who came before') is used for doctors, lawyers, politicians, and teachers — it connotes earned expertise and social seniority. When a Japanese parent calls you sensei, they are placing you in a category that implies deference.",
        "This deference is real and affects behaviour in PTMs, emails, and hallway conversations. Parents are unlikely to directly contradict a teacher's academic judgement, question a grade aloud, or suggest a teaching approach was wrong — even when they believe all of these things.",
        "The practical consequence: teachers who rely on absence of complaint as confirmation that everything is fine will consistently miss the cases where parents are quietly dissatisfied. Active effort to create low-stakes feedback channels is necessary to get real signal.",
        "International school teachers who are informal, first-name, and collaborative in style are sometimes experienced by Japanese families as — puzzlingly — less trustworthy rather than more approachable. The informality reads as lack of gravitas, not openness."
      ]
    },
    {
      "heading": "When the framework strains",
      "items": [
        "Second-generation Japanese families and families with Western experience are more likely to challenge directly. Do not assume all Japanese parents operate identically — the norm is the starting point, not the rule.",
        "A parent who does push back directly — writes a pointed email, requests a meeting with the Head of School — is often experiencing significant private distress. The public act of challenge is costly enough that it typically signals a problem that has been accumulating for some time.",
        "Students who have internalised sensei-deference may find IB's expectation of critical thinking, questioning sources, and arguing with received wisdom disorienting at first. Frame the academic exercise explicitly: 'In this task, I am asking you to challenge the text — that is the assignment, not a social transgression.'"
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Power Distance Index (Hofstede): Japan scores 54 — moderate, but the expression of power distance in Japan is complex, concentrated in institutional contexts (school, hospital, government) rather than diffuse across all relationships.",
        "Cave (2007) on Japanese primary schooling documents how student compliance and teacher authority are systematically reproduced through daily routines — the deference teachers encounter from Japanese families reflects what those families experienced as students."
      ]
    }
  ],
  "citations": [
    {"author": "Cave, P.", "year": "2007", "doi": "10.4324/9780203945742"},
    {"author": "Hofstede, G.", "year": "2001"},
    {"author": "LeTendre, G.", "year": "2000"}
  ]
}$json$::jsonb),

-- ── D5: Parent Involvement ────────────────────────────────────────────────────
('japan-001', 5, 'Kyōiku Mama and PTA Culture: How Japanese Parents Engage Schools', 'partial',
$json${
  "summary": "Japanese parental involvement follows structured channels — the PTA, class representatives, and the kyōiku mama (education mother) role — that are often invisible to foreign teachers but carry significant social and institutional weight.",
  "sections": [
    {
      "heading": "The kyōiku mama dynamic",
      "items": [
        "The kyōiku mama (教育ママ, education mother) refers to a mother whose primary social identity is organised around her child's academic success. The term has some negative connotation in Japan (over-investment, pressure), but the underlying dynamic — mother as primary educational broker between family and school — is widespread regardless of label.",
        "In practice, this means the mother is often the parent who attends PTMs, manages the juku schedule, reads the school reports, and communicates with teachers. The father may be present at formal events but is often not the operational contact. Directing important communications to 'the family' often means they will reach the mother.",
        "This is not universal — fathers at international schools tend to be more involved than domestic school norms suggest — but as a baseline, calibrate to the mother as the primary educational decision-maker unless you have evidence otherwise."
      ]
    },
    {
      "heading": "PTA and class rep culture",
      "items": [
        "Japanese PTAs (保護者会, hogosha-kai) are not advisory — they are functional. They coordinate school events, manage communications between parent cohorts, and sometimes function as an unofficial grievance channel. The class rep (クラス委員) has real social standing.",
        "A concern that surfaces through the class rep is not gossip — it is a formally routed communication. Treat it as seriously as a direct email from a parent.",
        "PTA meetings, parent observation days (授業参観), and school ceremonies carry more weight than their equivalents in anglophone schools. Poor turnout at these events by the school (unprepared staff, late starts, unclear agenda) damages trust significantly.",
        "Japanese parents who are active in PTA roles are often the most informed and most influential in the parent community. They are an asset, not an administrative overhead."
      ]
    },
    {
      "heading": "Communication norms",
      "items": [
        "Written communication — formal letters, printed handouts, the school diary/communication book — is still preferred for important information by many Japanese families, even where digital channels are available. Email is widely used but a printed follow-up is not unusual.",
        "Frequency matters. Japanese domestic schools communicate with parents very regularly — weekly or biweekly written updates. International schools that communicate only when something is wrong will be experienced as opaque or concerning.",
        "Language access is a real equity issue. Japanese parents whose English is limited are systematically excluded from PTMs, school events, and written communications. This is not a technical problem — it is a relationship problem that compounds over time."
      ]
    }
  ],
  "citations": [
    {"author": "Holloway, S.", "year": "2010"},
    {"author": "Yamamoto, Y. & Brinton, M.", "year": "2010", "doi": "10.1353/sof.2010.0013"},
    {"author": "MEXT Japan", "year": "2019"}
  ]
}$json$::jsonb),

-- ── D6: Kikokushijo ───────────────────────────────────────────────────────────
('japan-001', 6, 'Kikokushijo: Returnee Students and the Cost of the In-Between', 'partial',
$json${
  "summary": "Kikokushijo (帰国子女, returnee children) — Japanese students who have lived abroad — occupy a structurally ambiguous position on return: too foreign for domestic peers, insufficiently foreign for international ones, and navigating both schools simultaneously.",
  "sections": [
    {
      "heading": "Who kikokushijo are",
      "items": [
        "Kikokushijo are Japanese students who have spent a significant period of their education outside Japan — typically one to five years — and then returned, or who attend international school in Japan as a domestic student with overseas experience.",
        "Their numbers have grown steadily with Japanese corporate expatriate culture: MEXT estimates approximately 86,000 students overseas at any time, with 10,000–12,000 returning annually. International schools in Tokyo, Osaka, and Kobe serve a substantial kikokushijo population.",
        "Their academic profile is often unusual: strong in English and globally-referenced subjects, sometimes weaker in Japanese language arts and history, and sometimes significantly stronger at critical and creative thinking tasks than domestic school peers.",
        "Their social position is precarious. Domestic peers may perceive them as showing off, overly direct, or insufficiently Japanese. International peers may not count them as genuinely international. The school is often the only environment where their profile is an asset."
      ]
    },
    {
      "heading": "What families worry about",
      "items": [
        "The primary anxiety of kikokushijo families is re-integration: will their child be able to re-enter the Japanese education system and employment market with credentials that are recognised and social skills that fit? The IB Diploma's recognition by Japanese universities has improved this calculation but not resolved it.",
        "A second anxiety is Japanese language attrition. Parents who have watched their child's kanji writing deteriorate during an overseas posting often experience this as a serious identity and capability loss, not merely an academic gap.",
        "Kikokushijo students themselves often experience significant code-switching burden — performing appropriately in each context (international school, domestic Japanese environment, family expectations) is cognitively and emotionally expensive in ways that are not visible to teachers.",
        "Teachers who celebrate a student's 'international perspective' without acknowledging the social cost of being conspicuously different are inadvertently increasing the student's exposure — making them more visible to peers who may already be skeptical."
      ]
    },
    {
      "heading": "Research grounding",
      "items": [
        "Goodman (1990) remains the foundational study of kikokushijo; his framing of returnees as a 'critical case' for Japanese national identity has been extended by Willis et al. (2008) to show how schools actively construct and manage returnee identity rather than simply accommodating it.",
        "Yamashita (2015) on third-culture kids in Japanese international schools shows that identity flexibility — the ability to move between cultural frames — is a learnable skill that needs deliberate scaffolding from teachers, not just peer integration."
      ]
    }
  ],
  "citations": [
    {"author": "Goodman, R.", "year": "1990"},
    {"author": "Willis, D. et al.", "year": "2008"},
    {"author": "Yamashita, H.", "year": "2015"}
  ]
}$json$::jsonb)

ON CONFLICT (module_id, dimension_number) DO UPDATE SET
  title            = EXCLUDED.title,
  research_status  = EXCLUDED.research_status,
  content          = EXCLUDED.content;

-- ── QUIZ QUESTIONS ────────────────────────────────────────────────────────────
-- 6 checkpoint (one per dimension) + 3 final_exam

INSERT INTO pd_quiz_questions (id, module_id, quiz_type, sort_order, dimension_number, prompt, options) VALUES

-- Checkpoint D1
('japan-001-cp-d1', 'japan-001', 'checkpoint', 1, 1,
 'After a positive end-of-year report, a Japanese parent emails to ask: "Could you tell me how Kenji compares to the rest of the class?" How should you read this question?',
 $opts$[
   {"id": "a", "text": "The parent is being competitive and doesn''t trust the IB''s criterion-based approach.", "isCorrect": false, "feedback": "Competitiveness may be a secondary factor, but the primary driver is more structural. The parent is asking for hensachi-equivalent data — the comparative ranking signal that their educational formation taught them to require. This is a literacy gap, not a character flaw.", "research": []},
   {"id": "b", "text": "The parent wants comparative ranking information because that is the only evaluative signal their educational background taught them to trust.", "isCorrect": true, "feedback": "Exactly. In the juken system, a positive narrative means nothing without comparative position. The parent isn''t rejecting your report — they''re asking you to translate it into the only frame that makes planning decisions possible for them.", "research": ["Kariya 2011", "MEXT 2022"]},
   {"id": "c", "text": "The parent thinks Kenji is doing poorly and is looking for evidence to confront the school.", "isCorrect": false, "feedback": "If the report was positive, this reading requires adding information not in evidence. A more parsimonious reading is that the parent simply needs comparative context to evaluate what ''positive'' means.", "research": []},
   {"id": "d", "text": "The parent is checking whether the teacher knows the students well enough to have an opinion.", "isCorrect": false, "feedback": "This is possible in some contexts but doesn''t explain why comparison with classmates is the specific request. The question is most directly explained by the juken cultural context, not a relational test.", "research": []}
 ]$opts$::jsonb),

-- Checkpoint D2
('japan-001-cp-d2', 'japan-001', 'checkpoint', 2, 2,
 'You publicly praise Yuki in front of the class: "Yuki''s essay was the strongest piece of writing I''ve seen this year." The next week, Yuki submits a noticeably weaker essay and seems withdrawn. What is the most likely explanation?',
 $opts$[
   {"id": "a", "text": "Yuki had a difficult week at home and the quality drop is unrelated to the praise.", "isCorrect": false, "feedback": "Possible, but this explanation ignores the sequencing and requires an coincidence. The timing — weak submission immediately after public singling-out — is a classic pattern in high-wa environments.", "research": []},
   {"id": "b", "text": "Public recognition in front of peers created social pressure that Yuki is managing by reducing visibility.", "isCorrect": true, "feedback": "In a group-harmony culture, being publicly identified as the best creates exposure. Peers may signal disapproval; Yuki may be self-correcting to restore group equilibrium. This is not a motivational failure — it is a sophisticated social response.", "research": ["Markus & Kitayama 1991", "Heine et al. 1999"]},
   {"id": "c", "text": "Yuki is testing whether the praise was genuine by submitting weaker work.", "isCorrect": false, "feedback": "This reading attributes a strategic quality that is unlikely for a student navigating genuine social discomfort. Occam''s razor favours the wa explanation.", "research": []},
   {"id": "d", "text": "The strong essay was a fluke and Yuki''s true ability level is lower.", "isCorrect": false, "feedback": "This explanation arrives too quickly and ignores the behavioural signal (withdrawn affect). Ability regression this abrupt should prompt investigation of context, not rerating.", "research": []}
 ]$opts$::jsonb),

-- Checkpoint D3
('japan-001-cp-d3', 'japan-001', 'checkpoint', 3, 3,
 'At a PTM, Mrs Nakamura smiles throughout your presentation of her son''s below-average performance, says "yes, yes, I understand" repeatedly, and thanks you warmly at the end. Two days later you receive an email from the Head of School saying Mrs Nakamura has lodged a formal complaint. How do you account for this?',
 $opts$[
   {"id": "a", "text": "Mrs Nakamura was being manipulative — she waited to complain to gain strategic advantage.", "isCorrect": false, "feedback": "Attributing manipulation requires evidence of intent. The more parsimonious explanation is that tatemae (public face) and honne (private feeling) were operating normally. Mrs Nakamura''s warmth was genuine social form; her complaint was her genuine private response. Both were real.", "research": []},
   {"id": "b", "text": "Mrs Nakamura didn''t understand what you said at the PTM and the complaint reflects a misunderstanding.", "isCorrect": false, "feedback": "Possible, but the complaint being routed through the Head of School suggests a deliberate, considered action rather than a confusion response. The tatemae/honne reading is more consistent with the facts.", "research": []},
   {"id": "c", "text": "Mrs Nakamura was operating within tatemae/honne norms — public agreement and private dissatisfaction are not contradictory in this communication system.", "isCorrect": true, "feedback": "Exactly. Mrs Nakamura''s smile and agreement were tatemae — appropriate social form for a face-to-face meeting with an authority figure. Her complaint was honne — her actual response, expressed through the appropriate formal channel. Neither invalidates the other.", "research": ["Gudykunst & Nishida 1994", "Yamada 1997"]},
   {"id": "d", "text": "The complaint was prompted by something that happened after the PTM, not during it.", "isCorrect": false, "feedback": "Without specific evidence of a post-PTM event, this explanation adds information not in the scenario. The most coherent reading uses information given.", "research": []}
 ]$opts$::jsonb),

-- Checkpoint D4
('japan-001-cp-d4', 'japan-001', 'checkpoint', 4, 4,
 'Mr Tanaka, a parent, never questions your academic decisions at PTMs and always defers to your judgement. You take this as a sign of a healthy, trusting relationship. What might you be missing?',
 $opts$[
   {"id": "a", "text": "Nothing — parental deference is a strong positive signal in any cultural context.", "isCorrect": false, "feedback": "Deference as a universal positive is not supported by the research. In a high-sensei-deference context, absence of challenge tells you about social norms, not actual satisfaction. The relationship may be warm, but you need other signals to know whether the substance is working.", "research": []},
   {"id": "b", "text": "Mr Tanaka may have significant concerns he is not voicing because challenging a sensei figure directly carries social cost.", "isCorrect": true, "feedback": "Exactly. In Japanese institutional culture, challenging a teacher''s academic judgement directly is socially costly. Mr Tanaka''s deference tells you he is a well-formed Japanese parent in an institutional setting — it tells you almost nothing about his actual views on your teaching.", "research": ["Cave 2007", "Hofstede 2001"]},
   {"id": "c", "text": "Mr Tanaka probably has concerns he hasn''t thought through clearly yet.", "isCorrect": false, "feedback": "This reading assumes he lacks concerns rather than lacks a channel to express them. The distinction matters for what you do next.", "research": []},
   {"id": "d", "text": "Mr Tanaka is less invested in his child''s education than parents who ask more questions.", "isCorrect": false, "feedback": "Equating questions with investment ignores the cultural context entirely. Mr Tanaka''s silence about your academic decisions says nothing about the depth of his investment — Japanese educational investment, including juku spend, is among the highest in the world.", "research": []}
 ]$opts$::jsonb),

-- Checkpoint D5
('japan-001-cp-d5', 'japan-001', 'checkpoint', 5, 5,
 'You send home an important update about a curriculum change. Mr Ito (the father) acknowledges receipt at pickup. A week later it becomes clear that the family did not act on the information. What is the most likely structural explanation?',
 $opts$[
   {"id": "a", "text": "The family chose to ignore the communication.", "isCorrect": false, "feedback": "Wilful ignoring requires motivation; the scenario gives none. A structural explanation is more useful: in many Japanese families, the father receives and acknowledges but the mother is the operational manager of school communications — if she didn''t see it, the family didn''t act on it.", "research": []},
   {"id": "b", "text": "The communication was unclear and the family didn''t understand what action was required.", "isCorrect": false, "feedback": "Possible, but the scenario doesn''t indicate a clarity problem. The structural routing explanation is more specific and more actionable.", "research": []},
   {"id": "c", "text": "The communication reached the father but in this family the mother is the educational decision-maker and she may not have received it.", "isCorrect": true, "feedback": "The kyōiku mama dynamic means the mother is often the operational point of contact for school matters, even when the father is the more visible or accessible parent at school events. Routing critical communications so they reliably reach the mother is an operational design question, not a character judgement.", "research": ["Holloway 2010", "Yamamoto & Brinton 2010"]},
   {"id": "d", "text": "The family is disengaged from school communications generally.", "isCorrect": false, "feedback": "Generalising from one missed action to disengagement is a significant inferential leap. The routing explanation is both more specific and more charitable.", "research": []}
 ]$opts$::jsonb),

-- Checkpoint D6
('japan-001-cp-d6', 'japan-001', 'checkpoint', 6, 6,
 'Hana, a kikokushijo student who spent four years in the US, is consistently the most articulate participant in class discussions but is socially isolated from her Japanese peers and seems increasingly anxious. Your instinct is to praise her English confidence more visibly to build her self-esteem. Why might this backfire?',
 $opts$[
   {"id": "a", "text": "It might make her peers jealous.", "isCorrect": false, "feedback": "Jealousy is a secondary effect. The more precise concern is that increased visibility worsens the structural social problem — Hana is isolated partly because she is already too conspicuous, and additional public singling-out increases the distance between her and her peers.", "research": []},
   {"id": "b", "text": "Increased public recognition makes Hana more conspicuous in a peer environment that already perceives her as insufficiently Japanese, deepening her isolation rather than addressing it.", "isCorrect": true, "feedback": "Exactly. The wa dynamic and the kikokushijo social position mean Hana''s anxiety is partly driven by her conspicuousness. Praising her English skills publicly — however well-intentioned — signals to peers that she is different in a way the school endorses. Private acknowledgement and deliberate peer-integration strategies are more useful.", "research": ["Goodman 1990", "Willis et al. 2008"]},
   {"id": "c", "text": "Hana may not value English confidence as a skill worth praising.", "isCorrect": false, "feedback": "This contradicts her classroom behaviour. The concern is not whether she values the skill but what public recognition does to her social position.", "research": []},
   {"id": "d", "text": "Praising English specifically might embarrass her Japanese peers who are less fluent.", "isCorrect": false, "feedback": "This reading focuses on the peers'' feelings rather than Hana''s position. The more precise problem is what the praise does to Hana''s social integration, not how it reflects on others.", "research": []}
 ]$opts$::jsonb),

-- Final exam Q1
('japan-001-fe-1', 'japan-001', 'final_exam', 1, NULL,
 'A Japanese parent reviews their child''s end-of-year IB report — strong criterion scores, specific feedback, genuine praise. They reply: "This is very helpful, but I still don''t understand — is the result good or not?" What is the most constructive response?',
 $opts$[
   {"id": "a", "text": "Explain that the IB doesn''t rank students and reassure the parent that criterion-referenced grades are internationally recognised.", "isCorrect": false, "feedback": "This answers the system question, not the parent''s question. The parent knows IB doesn''t rank — they''re asking you to translate the result into a frame they can evaluate. Explaining the system again without translating is a non-answer.", "research": []},
   {"id": "b", "text": "Tell the parent their child is performing above or below the cohort average and provide a rough comparison.", "isCorrect": false, "feedback": "IB privacy norms and assessment philosophy both cut against direct comparative ranking. There is a better option.", "research": []},
   {"id": "c", "text": "Translate the result into language they can evaluate: what this score means for university admission prospects, how it compares to the grade boundary for the Diploma, and what would need to change to reach the next level.", "isCorrect": true, "feedback": "This works because it gives the parent actionable, outcome-linked information without ranking students. University admission data and grade boundary context are the closest available translation of the hensachi signal they are looking for.", "research": ["Kariya 2011"]},
   {"id": "d", "text": "Involve the Head of School to explain the IB philosophy more fully.", "isCorrect": false, "feedback": "Escalation to the Head for a translation question misreads the relationship. The parent isn''t questioning IB — they''re asking for help reading their child''s result.", "research": []}
 ]$opts$::jsonb),

-- Final exam Q2
('japan-001-fe-2', 'japan-001', 'final_exam', 2, NULL,
 'In a parent survey, Japanese parents consistently rate "teacher communication" as the weakest aspect of the school even though the school sends monthly newsletters and holds termly PTMs. What is the most likely explanation?',
 $opts$[
   {"id": "a", "text": "Japanese parents have unusually high expectations and the school should invest in more frequent communications.", "isCorrect": false, "feedback": "Frequency alone does not explain the rating gap. Adding more newsletters of the same type will not address the underlying issue.", "research": []},
   {"id": "b", "text": "The communication format does not match the expectations shaped by Japanese domestic school norms — which favour proactive, frequent, personalised contact in Japanese, not scheduled institutional publications in English.", "isCorrect": true, "feedback": "Correct. Japanese domestic schools communicate frequently, personally, and in Japanese. A monthly English newsletter is low frequency, impersonal, and inaccessible to parents with limited English. The survey data reflects a format mismatch, not a quantity shortage.", "research": ["Holloway 2010", "MEXT 2019"]},
   {"id": "c", "text": "The surveys may be unreliable because Japanese respondents tend to underrate in formal surveys.", "isCorrect": false, "feedback": "While some research suggests Japanese respondents use scale midpoints more than Western respondents, a consistent low rating on a specific dimension is signal, not noise.", "research": []},
   {"id": "d", "text": "The parents are comparing to their peers'' reports rather than their own experience.", "isCorrect": false, "feedback": "This requires speculating about an information channel not in evidence. The format mismatch explanation is directly supported by the research.", "research": []}
 ]$opts$::jsonb),

-- Final exam Q3
('japan-001-fe-3', 'japan-001', 'final_exam', 3, NULL,
 'A kikokushijo student (three years in Canada, now back in Tokyo at your school) performs excellently in English-medium subjects but is clearly struggling socially and has told you she "doesn''t belong anywhere." The most harmful response is:',
 $opts$[
   {"id": "a", "text": "Acknowledging the difficulty openly, naming it as a known experience for returnee students, and asking what kind of support would help.", "isCorrect": false, "feedback": "This is actually among the more constructive responses — naming the experience reduces isolation and gives the student agency in the support design.", "research": []},
   {"id": "b", "text": "Emphasising how much her international experience is an asset to the class and asking her to share her perspectives more often.", "isCorrect": true, "feedback": "This is the most harmful option. It treats her conspicuousness as a resource to be extracted rather than a social cost to be managed. Asking her to perform her difference more visibly deepens the isolation she is already experiencing. Her skills are real; using them as a classroom resource without addressing the integration problem first makes her situation worse.", "research": ["Goodman 1990", "Yamashita 2015"]},
   {"id": "c", "text": "Connecting her with other returnee students or a kikokushijo support group if available.", "isCorrect": false, "feedback": "This is a constructive response — peer connection with others who share the experience is one of the most effective interventions available.", "research": []},
   {"id": "d", "text": "Raising the situation with the school counsellor and ensuring the pastoral care team is aware.", "isCorrect": false, "feedback": "Appropriate escalation to the pastoral team is a correct response, particularly given the student has said she ''doesn''t belong anywhere'' — that language warrants professional follow-up.", "research": []}
 ]$opts$::jsonb)

ON CONFLICT (id) DO UPDATE SET
  prompt  = EXCLUDED.prompt,
  options = EXCLUDED.options;

-- ── SIMULATIONS ───────────────────────────────────────────────────────────────

INSERT INTO public.pd_simulations
  (module_id, title, description, context, estimated_minutes, status, characters, nodes)
VALUES

-- ── Simulation 1: The Silent PTM ──────────────────────────────────────────────
('japan-001',
 'The Silent PTM',
 'A Japanese mother is polite and agreeable throughout a difficult parents'' evening conversation. You leave feeling the meeting went well. It didn''t.',
 'You are six weeks into term. Riku''s performance has been sliding — two missed deadlines, declining quiz scores, and what looks like disengagement in class. You have scheduled a PTM with his mother, Mrs Yamamoto. She arrives on time, formally dressed, and greets you with a bow. She speaks limited English; you have a brief written translation of key points prepared.',
 20, 'live',
 $chars$[
   {"name": "You", "role": "IB Teacher", "description": "A foreign teacher at a Tokyo international school, well-intentioned but unfamiliar with tatemae communication norms."},
   {"name": "Mrs Yamamoto", "role": "Riku''s mother", "description": "A Japanese mother in her early 40s. She manages all school communication for the family. Her English is functional but limited. She defers to teachers but has strong private views."}
 ]$chars$::jsonb,
 $nodes${
   "setup": {
     "id": "setup", "type": "setup",
     "content": [
       "Mrs Yamamoto sits across from you, hands folded, expression attentive. You share your prepared notes: Riku has missed two deadlines, his last two quiz scores have fallen from his usual level, and he seems disengaged in class discussions.",
       "As you speak, Mrs Yamamoto nods at each point. She says 'yes, yes' several times. When you finish, she says: 'Thank you, Sensei. I understand. I will speak to Riku.' She smiles.",
       "The meeting is five minutes old. You have two choices about how to proceed."
     ],
     "next": "dilemma_1"
   },
   "dilemma_1": {
     "id": "dilemma_1", "type": "dilemma",
     "title": "How do you read Mrs Yamamoto's response?",
     "content": ["She has acknowledged everything you said and committed to act. How do you proceed?"],
     "choices": [
       {
         "id": "a", "label": "Close the meeting positively",
         "text": "Thank her for her engagement, say you're confident Riku will improve with her support, and wrap up.",
         "next": "consequence_1a"
       },
       {
         "id": "b", "label": "Check understanding and open a channel",
         "text": "Ask a specific question about what Riku says about school at home, and explain how she can contact you directly if concerns arise.",
         "next": "consequence_1b"
       }
     ]
   },
   "consequence_1a": {
     "id": "consequence_1a", "type": "consequence",
     "content": [
       "The meeting ends warmly. Mrs Yamamoto bows and thanks you again.",
       "Three weeks later, you receive an email from the school's Head of Pastoral Care: Mrs Yamamoto has raised a formal concern that Riku's difficulties were not properly explained to her, that no action plan was offered, and that the school does not communicate clearly with Japanese families.",
       "Her meeting notes — which she wrote that evening — describe feeling that the teacher presented information but did not help her understand what to do, and that she was too embarrassed to ask for clarification in the meeting itself."
     ],
     "next": "perspective_1"
   },
   "consequence_1b": {
     "id": "consequence_1b", "type": "consequence",
     "content": [
       "You ask: 'Does Riku talk about school at home? Does he mention any subjects he finds difficult?'",
       "Mrs Yamamoto pauses — the first genuine pause of the meeting. She says quietly: 'He says he does not understand the essay marking. He says he works hard but does not know what to improve.'",
       "This is new information. The disengagement you read as motivational may be navigational — Riku doesn't know how to improve, so he's stopped trying.",
       "You spend the remaining ten minutes going through one marked essay together, showing Mrs Yamamoto the criterion descriptors. She takes photos of the marking sheet. She leaves with a specific action and a direct email address."
     ],
     "next": "perspective_1"
   },
   "perspective_1": {
     "id": "perspective_1", "type": "perspective",
     "title": "Mrs Yamamoto's experience of the meeting",
     "content": [
       "Mrs Yamamoto arrived prepared to defer. In Japanese institutional culture, a PTM with a teacher (sensei) is not a negotiation — it is a briefing. She expected to receive information and affirm it.",
       "Her 'yes, yes' was not agreement. It was the social lubricant that keeps the interaction moving. Her smile was appropriate warmth, not satisfaction.",
       "She left with unresolved concerns she had no script for expressing directly. Writing to the Head of School — a formal, routed communication — was not passive aggression. It was the appropriate channel for a concern that couldn't be aired face-to-face."
     ],
     "next": "reflection_1"
   },
   "reflection_1": {
     "id": "reflection_1", "type": "reflection",
     "prompt": "What does this interaction reveal about how you normally check for understanding in a PTM?",
     "options": [
       "I usually read agreement signals (nodding, 'yes') as genuine understanding.",
       "I know agreement signals can be social form, but I don't always design for alternatives.",
       "I regularly use specific questions or demonstrations to verify understanding, not just confirmation."
     ],
     "next": "dilemma_2"
   },
   "dilemma_2": {
     "id": "dilemma_2", "type": "dilemma",
     "title": "Following up after the meeting",
     "content": ["Whether the meeting went well or not, you want to follow up. What form does this take?"],
     "choices": [
       {
         "id": "a", "label": "Send a brief email summary in English",
         "text": "Summarise the key points and next steps in a short email.",
         "next": "consequence_2a"
       },
       {
         "id": "b", "label": "Send a written action plan with the key points translated",
         "text": "Prepare a one-page summary with Riku's specific targets, translated into Japanese using a tool like DeepL, and send via email with an offer to meet again.",
         "next": "consequence_2b"
       }
     ]
   },
   "consequence_2a": {
     "id": "consequence_2a", "type": "consequence",
     "content": [
       "The email is clear and professional. Mrs Yamamoto reads it with some difficulty — her English comprehension is better in writing than in speech, but the technical language around IB criteria is challenging.",
       "She forwards it to her husband. He is uncertain what 'formative assessment' means. The email sits in the inbox.",
       "At the next PTM, the same issues recur."
     ],
     "next": "debrief"
   },
   "consequence_2b": {
     "id": "consequence_2b", "type": "consequence",
     "content": [
       "The Japanese-language summary reaches Mrs Yamamoto in a form she can fully read. She replies — in Japanese — with two questions about specific criterion descriptors. You use DeepL to respond.",
       "Over the following month, Riku submits both outstanding assignments. His mother emails to say she showed him the criterion sheet and they worked through it together at the kitchen table.",
       "The relationship has shifted from institutional to collaborative."
     ],
     "next": "debrief"
   },
   "debrief": {
     "id": "debrief", "type": "debrief",
     "sections": [
       {
         "title": "What tatemae means in a PTM",
         "content": [
           "Mrs Yamamoto's behaviour was not evasive — it was structurally appropriate. In Japanese institutional communication, direct expression of dissatisfaction to an authority figure (sensei) in a formal setting is costly. The appropriate channel for real concerns is indirect: the formal complaint, the class rep, the written letter.",
           "This is not a personal style preference. It is a communication system. Teachers who do not know the system will consistently misread warmth as satisfaction."
         ]
       },
       {
         "title": "The design implication",
         "content": [
           "You cannot fix tatemae/honne by asking people to be more direct. You fix it by building channels that lower the social cost of honest communication: specific questions rather than open invitations, written summaries parents can engage with at their own pace, and follow-up options that don't require a face-to-face confrontation.",
           "The translation step is not a nice-to-have. For families whose English is limited, it is the difference between a working relationship and a formal complaint."
         ]
       }
     ],
     "finalPrompt": "Think of a parent interaction in the last term where you read the surface warmth and assumed things were fine. What would you do differently now?"
   }
 }$nodes$::jsonb),

-- ── Simulation 2: The Deflected Praise ────────────────────────────────────────
('japan-001',
 'The Deflected Praise',
 'A high-performing student consistently downplays their work. You read it as low self-esteem. The explanation is different.',
 'Sora is one of the strongest writers in your Year 11 English class. Their personal essay was, in your view, exceptional — the best in the cohort. When you return the marked essays and mention Sora''s work as an example of what you were looking for, Sora looks at the desk and says "It wasn''t very good." In the break, you pull Sora aside to ask if everything is okay.',
 15, 'live',
 $chars$[
   {"name": "You", "role": "IB English Teacher", "description": "Committed to student wellbeing, trained to identify low self-esteem signals."},
   {"name": "Sora", "role": "Year 11 student, kikokushijo", "description": "A Japanese student who spent two years in Australia (ages 12–14). Academically strong, socially careful. Comfortable with you but aware of peer dynamics."}
 ]$chars$::jsonb,
 $nodes${
   "setup": {
     "id": "setup", "type": "setup",
     "content": [
       "You find Sora near the lockers. 'Your essay was really strong — I meant it. Is everything okay? You seemed uncomfortable when I mentioned it.'",
       "Sora is quiet for a moment, then says: 'I don't like it when people look at me.' You note this as a possible self-esteem concern and consider your next move."
     ],
     "next": "dilemma_1"
   },
   "dilemma_1": {
     "id": "dilemma_1", "type": "dilemma",
     "title": "How do you interpret 'I don't like it when people look at me'?",
     "content": ["You have a few minutes. What lens do you use?"],
     "choices": [
       {
         "id": "a", "label": "Self-esteem concern",
         "text": "This sounds like it might be about confidence. Offer reassurance and consider flagging for the counsellor.",
         "next": "consequence_1a"
       },
       {
         "id": "b", "label": "Social navigation",
         "text": "Ask specifically about peer dynamics: 'Does being singled out in class make things awkward with your classmates?'",
         "next": "consequence_1b"
       }
     ]
   },
   "consequence_1a": {
     "id": "consequence_1a", "type": "consequence",
     "content": [
       "You offer reassurance: 'You're a strong student, Sora. You should feel proud of your work.'",
       "Sora thanks you politely and goes to class. The discomfort continues in subsequent lessons — Sora still deflects when praised publicly.",
       "You flag a possible self-esteem concern with the counsellor. The counsellor meets with Sora and reports back: 'Sora seems fine — says they just don't like being the centre of attention.'",
       "The actual dynamic — that public singling-out is increasing Sora's social exposure in a peer group that already sees them as conspicuously different — hasn't been addressed."
     ],
     "next": "perspective_1"
   },
   "consequence_1b": {
     "id": "consequence_1b", "type": "consequence",
     "content": [
       "Sora's expression shifts — something more specific than you've seen before. 'Some of them already think I show off because of Australia. When you say my essay is the best... it makes it worse.'",
       "This is different from a self-esteem problem. Sora's public modesty ('it wasn't very good') was social management — a corrective move to lower the temperature with peers, not a reflection of internal doubt.",
       "You and Sora agree: you'll continue to give specific, written feedback on work quality. Public examples will be anonymised. You ask if she wants to help you design a peer feedback activity where everyone's strong points get named."
     ],
     "next": "perspective_1"
   },
   "perspective_1": {
     "id": "perspective_1", "type": "perspective",
     "title": "What Sora was managing",
     "content": [
       "Sora's 'it wasn't very good' was not self-doubt — it was kenjō (謙遜, modesty) deployed strategically. In front of peers who already see her as too conspicuously international, her performance of modesty was a repair move: bringing herself back into the group's orbit.",
       "For a kikokushijo student, academic praise creates a double exposure: it highlights both excellence (always slightly dangerous in a high-wa environment) and international schooling (the marker that already sets her apart).",
       "The counsellor wasn't wrong that Sora 'seems fine.' Sora is managing competently. The question is whether the school's practices are making that management easier or harder."
     ],
     "next": "reflection_1"
   },
   "reflection_1": {
     "id": "reflection_1", "type": "reflection",
     "prompt": "When a student deflects praise, which is your default interpretation?",
     "options": [
       "I default to self-esteem — deflection is usually about internal doubt.",
       "I consider both internal and social explanations, but I don't always ask specifically about peers.",
       "I regularly ask about peer dynamics when students show discomfort with visibility."
     ],
     "next": "debrief"
   },
   "debrief": {
     "id": "debrief", "type": "debrief",
     "sections": [
       {
         "title": "The wa dynamic in the classroom",
         "content": [
           "Public praise in a high-wa peer environment is not a neutral act. For a student who is already more visible than comfortable — through academic performance, cultural difference, or both — it can create real social cost.",
           "This doesn't mean avoiding recognition. It means designing recognition carefully: anonymous examples, private written feedback, group framing ('this is the standard the class is working toward') rather than individual spotlighting."
         ]
       },
       {
         "title": "Kikokushijo's specific position",
         "content": [
           "Sora's situation is specific to returnee students: the academic strengths built abroad can be socially costly in Japan's domestic peer culture. The school is often the only place where those strengths are valued. Making the school feel safe for visibility requires active work, not just good intentions."
         ]
       }
     ],
     "finalPrompt": "How do you currently handle public recognition of strong work? What would you change to reduce unintended social cost for students who are already conspicuous?"
   }
 }$nodes$::jsonb),

-- ── Simulation 3: The PTA Complaint ───────────────────────────────────────────
('japan-001',
 'The Routed Complaint',
 'A parent concern arrives through three intermediaries. You treat it as bureaucratic noise. It isn''t.',
 'You receive an email from the school''s parent liaison officer: the Japanese PTA class representative has asked her to pass on that "some parents" are concerned about the amount of homework in your Year 10 class. No names are attached. No specific incident is cited. You have a new assessment unit starting next week.',
 18, 'live',
 $chars$[
   {"name": "You", "role": "Year 10 Class Teacher", "description": "Mid-career teacher, well-organised. You believe your workload is appropriate and calibrated to IB norms."},
   {"name": "Parent Liaison Officer", "role": "School staff", "description": "An experienced Japanese-speaking staff member who manages PTA communications."},
   {"name": "The Parents (unnamed)", "role": "Japanese parent cohort", "description": "A group of parents who have chosen to route a concern through the formal PTA structure rather than contact you directly."}
 ]$chars$::jsonb,
 $nodes${
   "setup": {
     "id": "setup", "type": "setup",
     "content": [
       "The email is brief: 'The Year 10 class rep has asked me to pass on that a number of parents have raised concerns about homework volume in your class. She felt it was worth flagging before next term's unit begins.'",
       "You check your records. Your homework assigns are within the school's stated guidelines. The concern feels vague and unsubstantiated. You consider your response."
     ],
     "next": "dilemma_1"
   },
   "dilemma_1": {
     "id": "dilemma_1", "type": "dilemma",
     "title": "How do you treat this communication?",
     "content": ["An anonymous complaint through three intermediaries, citing no specific incident. What do you do?"],
     "choices": [
       {
         "id": "a", "label": "Respond to the liaison, note that your homework is within guidelines",
         "text": "Reply to the liaison explaining that your assign volume meets school policy, and suggest that any parent with specific concerns contact you directly.",
         "next": "consequence_1a"
       },
       {
         "id": "b", "label": "Ask the liaison for more context before responding",
         "text": "Reply asking the liaison: what specifically did parents say? Is there one unit or consistent across the year? Ask if she can share more detail, and indicate you'll review the upcoming unit's assign schedule either way.",
         "next": "consequence_1b"
       }
     ]
   },
   "consequence_1a": {
     "id": "consequence_1a", "type": "consequence",
     "content": [
       "The liaison passes your response to the class rep.",
       "Two weeks into the new unit, the concern escalates: the class rep now writes directly to the Head of School, attaching a list of seven families' concerns. The complaints are more specific this time: parents feel the teacher is defensive, that the school's 'contact us directly' policy doesn't work because families don't feel comfortable approaching foreign teachers, and that the concerns weren't taken seriously.",
       "The Head calls you in. What began as a low-level signal is now a formal issue."
     ],
     "next": "perspective_1"
   },
   "consequence_1b": {
     "id": "consequence_1b", "type": "consequence",
     "content": [
       "The liaison replies with more detail: the concern is mainly about the reading assignments on top of the analytical writing tasks — students are spending 3+ hours on your homework some nights, particularly those who also attend juku.",
       "You review the upcoming unit. You realise the reading and the written task were designed to run in parallel, but the combined load wasn't something you'd calculated. You restructure: the reading becomes in-class supported time; the writing task stays.",
       "At the next PTA meeting, the liaison reports that the class rep has said 'the teacher listened.' The issue closes."
     ],
     "next": "perspective_1"
   },
   "perspective_1": {
     "id": "perspective_1", "type": "perspective",
     "title": "Why the complaint was routed this way",
     "content": [
       "The parents who raised the concern were not being cowardly or passive-aggressive. They were using the correct channel. In Japanese institutional culture, raising a concern with a teacher directly — particularly a foreign teacher — carries significant social risk: it challenges the sensei hierarchy, it risks the teacher 'losing face,' and it exposes the family to potential social costs in the parent community if the complaint becomes known.",
       "The PTA class rep channel is specifically designed to allow concerns to surface without individual attribution. Anonymous, group-endorsed, routed through a trusted intermediary: this is high-status communication, not noise.",
       "Responding to it with 'contact me directly' sends the message that you don't understand how the system works — and that you're not listening."
     ],
     "next": "reflection_1"
   },
   "reflection_1": {
     "id": "reflection_1", "type": "reflection",
     "prompt": "How do you normally respond when anonymous or indirect feedback arrives about your class?",
     "options": [
       "I treat it with skepticism unless a parent is willing to put their name to it.",
       "I acknowledge it but weight direct feedback more heavily in my response.",
       "I treat indirect and direct feedback with similar seriousness and investigate either way."
     ],
     "next": "debrief"
   },
   "debrief": {
     "id": "debrief", "type": "debrief",
     "sections": [
       {
         "title": "The PTA channel is the signal",
         "content": [
           "When a concern arrives through the PTA class rep, it has already passed through a social filtering process. Individual families have discussed it, reached a shared view, and agreed to route it formally. By the time it reaches you, it represents a cohort position — not one anxious parent.",
           "Treating it as anonymous noise and asking for named complainants misses how the system is designed to work. It also communicates to the class rep — who is a social hub in the parent community — that the school doesn't take routed communication seriously."
         ]
       },
       {
         "title": "The juku variable",
         "content": [
           "The detail that emerged — students attending juku on top of IB homework — is not exceptional. For many Japanese families in international schools, IB and juku run in parallel. Your homework estimate of '60 minutes' may be accurate for a student not in juku; for a student who attends juku three evenings per week, it lands in a very different total-load context.",
           "This doesn't require you to design all tasks around juku students. It requires you to know the variable exists and factor it into your workload estimates."
         ]
       }
     ],
     "finalPrompt": "What channels currently exist for Japanese-speaking parents in your school to raise concerns without having to approach a foreign teacher directly? What would you add or change?"
   }
 }$nodes$::jsonb)

ON CONFLICT (module_id, title) DO UPDATE SET
  description       = EXCLUDED.description,
  context           = EXCLUDED.context,
  estimated_minutes = EXCLUDED.estimated_minutes,
  status            = EXCLUDED.status,
  characters        = EXCLUDED.characters,
  nodes             = EXCLUDED.nodes;

COMMIT;
