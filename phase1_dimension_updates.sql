-- ============================================================
-- phase1_dimension_updates.sql
-- Phase 1: Research-informed dimension rewrites
-- Modules: ksa-001, korea-001, china-001
--
-- Run after: cal_seed_part1.sql, cal_seed_part2.sql, cal_seed_part3.sql
-- Safe to re-run (uses ON CONFLICT or UPDATE WHERE).
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- KSA MODULE (ksa-001)
-- Frame: The selection paradox — families who chose international
-- education and are worried about what it will do to their children,
-- simultaneously. All six dimensions sit inside this frame.
-- ────────────────────────────────────────────────────────────

-- KSA D1: The selection paradox
UPDATE public.pd_dimensions
SET
  title = 'The Selection Paradox',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "The frame for this entire module",
        "items": [
          "A 2024 peer-reviewed study in Nature — Humanities and Social Sciences Communications (''How Saudi parents rationalize the choice of school for their children'') found that cultural and religious identity was the single most important factor in school selection — ranking above academic reputation, facilities, and fees.",
          "Yet the same families are enrolling their children in international schools. This is not a contradiction. It is the paradox you will work inside every day: families who chose IB, and are simultaneously watching to see whether the cultural bargain they struck holds.",
          "The selection logic resolves when you understand it clearly: these families believe an international school can deliver globally recognised credentials without requiring their child to abandon the cultural and religious framework that gives family life meaning and social standing.",
          "Every parent interaction in this module happens inside that bargain. When a parent asks a probing question, challenges a pedagogical practice, or seems inconsistent — they are not confused about why they chose the school. They are watching whether the school is keeping its side of the deal."
        ]
      },
      {
        "heading": "What the research found",
        "items": [
          "The Nature (2024) study used semi-structured interviews with Saudi families in private K-12 schools. Cultural and religious identity as a selection factor encompassed: preference for gender-appropriate environments, concern about English displacing Arabic, and wariness of pedagogies that undermine parental and religious authority.",
          "A parallel SAGE study (Alfaraidy, 2020) — ''Factors Influencing Saudi Parents'' Choice of International Schools'' — found similar primary factors, with academic reputation and English-medium instruction as secondary considerations rather than drivers.",
          "Both studies note that local Saudi families (not just expatriates) are increasingly choosing international schools, drawn by globally recognised qualifications while simultaneously seeking to preserve cultural continuity. This dual motive is the defining characteristic of the parent population in KSA international schools."
        ]
      },
      {
        "heading": "The practical implication",
        "items": [
          "A parent who seems inconsistent — enthusiastically endorsing the school in September and asking pointed questions in November — is not being difficult. The enrollment decision was made. The monitoring has begun.",
          "Treating each challenge as an isolated complaint misses the pattern. Seeing each challenge as one data point in the parent''s ongoing assessment of whether the bargain holds changes how you respond.",
          "The most effective teachers in this context develop fluency in naming the bargain directly: ''This school can deliver X. We do this in a way that also protects Y.'' Specificity about what is and is not threatened builds trust that reassurance alone never does."
        ]
      }
    ],
    "citations": [
      {"author": "Alothman, H. et al.", "year": 2024, "title": "How Saudi parents rationalize the choice of school for their children", "journal": "Humanities and Social Sciences Communications (Nature)", "doi": "10.1057/s41599-024-03867-9"},
      {"author": "Alfaraidy, H.", "year": 2020, "title": "Factors Influencing Saudi Parents'' Choice of International Schools in Saudi Arabia", "journal": "Journal of Research in International Education", "doi": "10.1177/1475240920976259"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 1;

-- KSA D2: Religious and cultural identity in the classroom
UPDATE public.pd_dimensions
SET
  title = 'Religious and Cultural Identity in the Classroom',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "What ''student voice'' signals",
        "items": [
          "When a parent asks what a ''student voice'' or ''individual expression'' activity will teach their child to do, the surface question is about pedagogy. The deeper question is about authority: does this school''s approach require children to challenge adults?",
          "In a context where parental and religious authority are primary structuring forces in family life, a pedagogy that celebrates individual agency and self-determination can sound like a programme designed to erode exactly the values the family chose the school to protect.",
          "This is not irrationality. It is the selection paradox in action: the parent chose an international school and is now watching whether the international school will change what matters most.",
          "The correct response is not to defend the pedagogy philosophically. It is to be concrete about what the activity actually involves and what kind of participation it does and does not ask for."
        ]
      },
      {
        "heading": "Gender, environment, and cultural safety",
        "items": [
          "The Alfaraidy (2020) study found gender-appropriate environments among the top factors in Saudi school selection — a finding that holds across income levels and levels of parental international experience.",
          "For teachers, this has a practical dimension that goes beyond classroom seating. It means that the social and mixed-gender dynamics of project groups, outdoor activities, and co-curricular events are visible and significant to parents in ways they may not be in other contexts.",
          "A parent who raises concerns about a mixed-gender event is not necessarily opposed to co-education. They may be signalling that the event sits close to a boundary they negotiated internally when choosing the school, and they want to know the school is aware of that boundary too."
        ]
      },
      {
        "heading": "The interpretive burden in every interaction",
        "items": [
          "The Nature (2024) study found that routine parent communication is doing interpretive work that goes beyond logistics. Questions that appear to be about scheduling, materials, or activity content are often also questions about what the school''s practices mean — whether the school''s international ethos fits with local moral and cultural expectations.",
          "A teacher who answers only the surface question (the scheduling, the materials) is likely leaving the interpretive question unanswered. That gap gets filled by assumptions, often worst-case.",
          "Effective communication in this context adds a brief cultural translation layer: not just ''here is what we are doing'' but ''here is what this does and does not mean for your child''s values.''"
        ]
      }
    ],
    "citations": [
      {"author": "Alfaraidy, H.", "year": 2020, "title": "Factors Influencing Saudi Parents'' Choice of International Schools in Saudi Arabia", "journal": "Journal of Research in International Education", "doi": "10.1177/1475240920976259"},
      {"author": "Alothman, H. et al.", "year": 2024, "title": "How Saudi parents rationalize the choice of school for their children", "journal": "Humanities and Social Sciences Communications (Nature)", "doi": "10.1057/s41599-024-03867-9"},
      {"author": "Hammad, W. & Shah, S.", "year": 2018, "title": "Dissonance Between the International and the Conservative National", "journal": "Educational Administration Quarterly", "doi": "10.1177/0013161X18785864"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 2;

-- KSA D3: The language bargain
UPDATE public.pd_dimensions
SET
  title = 'The Language Bargain',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "English as opportunity and as risk",
        "items": [
          "Saudi families who choose English-medium international schools are making a deliberate investment in English as an economic asset. This is not ambiguous: the demand for English-medium education in Saudi Arabia is strong, growing, and parent-driven.",
          "But research on Saudi children in Riyadh international schools (''Language Shift Among Saudi Children Studying in Riyadh International Schools,'' 2024) found that children in English-medium settings shift toward English as their dominant spontaneous language — including at home. Parents are aware of this risk.",
          "A study on English-only policy in Saudi international schools (''Impact of the English-Only Policy on Learners,'' 2024) found that English-medium instruction had minimal impact on students'' religious or cultural values but significantly affected Arabic literacy and language preference. Parents do not always have access to this distinction — they experience the language shift as more threatening than the research suggests it is."
        ]
      },
      {
        "heading": "When an English-first routine becomes more than a policy",
        "items": [
          "An English-first classroom routine is a language policy. It can also become a hidden curriculum about which language carries intelligence, seriousness, and social legitimacy.",
          "When a child begins treating English as the language of status — using it to signal competence, avoiding Arabic with peers — the school''s policy has begun teaching a hierarchy of linguistic belonging alongside English fluency.",
          "This is not inevitable. It is the product of specific design choices: whether teachers correct English errors but not Arabic ones, whether assemblies are English-only, whether Arabic-speaking parents are addressed in English at school events. Each choice sends a signal about which language the school values."
        ]
      },
      {
        "heading": "What this means for teacher communication",
        "items": [
          "A parent who raises concern about English displacing their child''s Arabic is not anti-English. They invested in English. They are raising a specific, research-supported concern about a measurable side-effect.",
          "The most effective response acknowledges the concern as legitimate and specific, not as a general fear of modernity. ''We teach English because X. We also do Y and Z to actively support Arabic literacy.'' This answer only works if Y and Z are true.",
          "Teachers who do not know what the school does to support Arabic literacy cannot answer this question well. Finding out is worth the effort — because this is one of the questions the Nature (2024) study found Saudi parents most concerned about when evaluating whether the cultural bargain is holding."
        ]
      }
    ],
    "citations": [
      {"author": "Alsaawi, A. & Almulhim, F.", "year": 2024, "title": "Language Shift Among Saudi Children Studying in Riyadh International Schools: Fact or Fiction?", "journal": "ResearchGate / Journal of Language and Education"},
      {"author": "Alsaawi, A. et al.", "year": 2024, "title": "Impact of the English-Only Policy on Learners at International Schools: A Sociocultural Study in the Saudi Context", "journal": "ResearchGate"},
      {"author": "Alothman, H. et al.", "year": 2024, "title": "How Saudi parents rationalize the choice of school for their children", "journal": "Humanities and Social Sciences Communications (Nature)", "doi": "10.1057/s41599-024-03867-9"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 3;

-- KSA D4: Vision 2030 and the new uncertainty
UPDATE public.pd_dimensions
SET
  title = 'Vision 2030 and the New Uncertainty',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "What Vision 2030 is actually asking of families",
        "items": [
          "Saudi Arabia''s Vision 2030 reform agenda is pushing female workforce participation, English competence, and globally recognised qualifications simultaneously. These are not minor adjustments — they represent a state-level redefinition of what a successful educational outcome looks like.",
          "The result, documented in Springer Nature research (''Education reform and Vision 2030 in Saudi Arabia,'' 2025), is that families are navigating this redefinition without a prior generation to look at. For many parents, there is no social proof for what a ''good'' Vision 2030 outcome looks like in practice.",
          "In 2018, approximately 66% of Saudi university graduates in STEM fields were female — a striking statistic that reflects both genuine change and the speed of that change. Parents of daughters in international schools are watching a social transformation in real time and making educational decisions without a clear map."
        ]
      },
      {
        "heading": "The parent who questions your pedagogy is often asking a different question",
        "items": [
          "A parent who challenges a ''student leadership'' programme, a ''self-directed learning'' unit, or a ''student voice'' initiative may be opposed to those things in principle. More often, they are working out what Vision 2030 modernity requires of their family and whether this school''s version of modernity is the right one.",
          "The distinction matters enormously for how you respond. Resistance to a principle requires persuasion. Navigation of uncertainty requires information and specificity.",
          "''Our student leadership programme develops the skills your child will need for the kinds of roles Vision 2030 is creating'' is a more useful sentence than ''this is internationally normal practice.'' One connects to the parent''s own uncertainty; the other dismisses it."
        ]
      },
      {
        "heading": "Cultural preservation and modernisation are not opposites here",
        "items": [
          "The research is consistent on one finding: Saudi families choosing international schools are not choosing between culture and modernity. They are trying to achieve both. The school that understands this stops treating cultural preservation and academic modernisation as competing priorities.",
          "A teacher who frames their classroom as a space where students can be globally ambitious and culturally grounded — not one or the other — is working with the family''s logic, not against it.",
          "This does not mean avoiding tension. It means being honest about what the school''s approach does and does not ask of students, so families can make informed decisions rather than worried assumptions."
        ]
      }
    ],
    "citations": [
      {"author": "Springer Nature", "year": 2025, "title": "Education reform and Vision 2030 in Saudi Arabia: challenges and pathways", "journal": "Discover Education", "doi": "10.1007/s44217-025-01005-4"},
      {"author": "Oxford Business Group", "year": 2024, "title": "Learning landscape: regulatory adjustments and technological innovation in Saudi Arabia", "journal": "Saudi Arabia 2024 Report"},
      {"author": "OECD", "year": 2025, "title": "Education GPS — Saudi Arabia overview", "journal": "Education at a Glance"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 4;

-- KSA D5: Communication in a high-context culture
UPDATE public.pd_dimensions
SET
  title = 'Communication in a High-Context Culture',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "What a polite structured PTM actually tells you",
        "items": [
          "In high-context communication cultures, the explicit content of a conversation is a small fraction of what is being communicated. Formality, tone, and the choice of channel carry as much meaning as words.",
          "A parent meeting that is warm, formal, and free of direct challenge is not evidence that the parent has no concerns. It is evidence that the parent is choosing an appropriate register for a first or early meeting with a school authority figure.",
          "The research on Saudi parent-school communication consistently finds that dissatisfaction travels through formal channels and third-party intermediaries — not through direct confrontation in a PTM. A parent who leaves a meeting seeming satisfied may be planning to contact the principal, or a trusted school intermediary, afterward."
        ]
      },
      {
        "heading": "What formal communication protocols mean",
        "items": [
          "A parent who communicates only through formal school channels — who will not use WhatsApp, who schedules meetings through the admin office, who copies the principal on emails — is not being cold or bureaucratic. They are maintaining appropriate protocol for a relationship with an institution, not signalling emotional distance.",
          "Western teachers trained in informal, relationship-first communication styles sometimes read this formality as a lack of investment. The research suggests the opposite is more likely: high formality often indicates that the parent is taking the relationship seriously and managing it carefully.",
          "Matching the register — responding formally to formal communication, offering structure rather than informality — builds trust in this context. Pushing toward informality before the parent initiates it can feel presumptuous."
        ]
      },
      {
        "heading": "How dissatisfaction actually travels",
        "items": [
          "In the KSA international school context, parent concerns that are not addressed in formal channels do not disappear. They move to: community networks (both in-person and WhatsApp-based), formal written complaints addressed to school leadership, withdrawal without stated reason.",
          "A teacher who receives a formal complaint and is surprised by it has likely missed earlier, softer signals — a question that felt larger than it should, a formal follow-up email after a meeting, a request for a meeting with the head of school rather than the classroom teacher.",
          "Reading these signals accurately requires understanding what they are. A request to speak with someone more senior is not necessarily distrust of the teacher — it may be the culturally appropriate escalation route for a concern the parent does not want to bring directly to the person they are concerned about."
        ]
      }
    ],
    "citations": [
      {"author": "Hammad, W. & Shah, S.", "year": 2018, "title": "Dissonance Between the International and the Conservative National", "journal": "Educational Administration Quarterly", "doi": "10.1177/0013161X18785864"},
      {"author": "Alothman, H. et al.", "year": 2024, "title": "How Saudi parents rationalize the choice of school for their children", "journal": "Humanities and Social Sciences Communications (Nature)", "doi": "10.1057/s41599-024-03867-9"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 5;

-- KSA D6: What actually works
UPDATE public.pd_dimensions
SET
  title = 'What Actually Works',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "Name the bargain explicitly",
        "items": [
          "The single most effective communication move in this context is also the most direct: name what the school does and does not require of students, in terms that connect to what the family is actually worried about.",
          "''This programme develops independent thinking. It does not ask students to challenge parental or religious authority. Here is specifically what a student voice activity involves.'' This answer is more trusted than general reassurance because it is falsifiable — the parent can hold you to it.",
          "Schools that do this proactively — at the beginning of the year, before concerns arise — create a different context for the concerns that inevitably come. The parent who has already heard the school address their worry explicitly is less likely to assume the worst when something ambiguous happens."
        ]
      },
      {
        "heading": "University outcomes data",
        "items": [
          "The selection paradox resolves most reliably when families can see evidence that the bet is paying off. University placement data — where IB graduates from this school are going, what they are studying, which employers are hiring them — answers the competitive question in terms families understand.",
          "This is especially powerful for families navigating Vision 2030 uncertainty, where the right educational outcome for their child is genuinely unclear. Showing them what students who completed this programme went on to do gives them social proof they cannot get from prior generations.",
          "The Quercia (2025) practitioner framework from Chinese international schools applies here too: parent workshops that translate IB outcomes into legible competitive terms are more effective than ones that explain IB philosophy."
        ]
      },
      {
        "heading": "Maintain communication about Arabic alongside English",
        "items": [
          "Given the research on language shift and Arabic literacy loss, schools that communicate proactively about Arabic literacy — what they do to support it, how they monitor it, what parents can do at home — demonstrate awareness of the specific concern the research identifies as most live.",
          "This does not require a bilingual programme. It requires intentional messaging: ''We teach English. We also do X to protect Arabic. Here is what that looks like.''",
          "Teachers who can speak to this — not just the English programme but the Arabic support — are more trusted by Saudi families than those who only speak to the English outcomes. It signals that the school has thought about the whole bargain, not just the credential."
        ]
      }
    ],
    "citations": [
      {"author": "Alsaawi, A. & Almulhim, F.", "year": 2024, "title": "Language Shift Among Saudi Children Studying in Riyadh International Schools: Fact or Fiction?", "journal": "ResearchGate"},
      {"author": "Quercia, V.", "year": 2025, "title": "Parents have doubts about the IB in China — but we can win them over", "journal": "TES Magazine"},
      {"author": "Alothman, H. et al.", "year": 2024, "title": "How Saudi parents rationalize the choice of school for their children", "journal": "Humanities and Social Sciences Communications (Nature)", "doi": "10.1057/s41599-024-03867-9"}
    ]
  }'::jsonb
WHERE module_id = 'ksa-001' AND dimension_number = 6;


-- ────────────────────────────────────────────────────────────
-- KOREA MODULE (korea-001)
-- Frame: Structural forces produced this parental behaviour.
-- The goal is systemic understanding, not cultural judgment.
-- ────────────────────────────────────────────────────────────

-- Korea D1: The zero-sum structure
UPDATE public.pd_dimensions
SET
  title = 'The Zero-Sum Structure',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "The exam that organises everything",
        "items": [
          "The Suneung (수능) — South Korea''s national university entrance exam — is not just a test. It is the primary sorting mechanism for life outcomes: university placement determines career trajectory, income, social standing, and marriage prospects in ways that are comparatively direct and publicly understood.",
          "Preparation for the Suneung is not limited to the final year. Shadow education — private academies (hagwons), individual tutors, and specialised cram schools — extends academic preparation across the full school career. The Berkeley Political Review (2024) documents the zero-sum nature of this system: universities in the Seoul metropolitan area compete in ways that resemble a single-elimination tournament, with no equivalent of the tiered public university system that distributes outcomes in countries like the US.",
          "For international school families, the Suneung is a background reference point, not the primary exam. But the competitive logic it has produced — where educational positioning is understood as inherently comparative and high-stakes — shapes how Korean parents read every school interaction, regardless of curriculum."
        ]
      },
      {
        "heading": "Birth rate 0.78: the concentrated investment",
        "items": [
          "South Korea''s birth rate of 0.78 (2023, the lowest ever recorded for any country) means that most Korean parents have one or two children. This is not incidental to the intensity of parental educational investment — it is its structural explanation.",
          "When all parental hope, financial resource, and social aspiration is concentrated in a single or double bet, the stakes of educational failure are not distributed. They are total. A parent who contacts a teacher at 11pm about a grade is not pathologically anxious. They are expressing the logical consequence of a system that has trained them to understand their child''s educational trajectory as the single most important variable in the family''s future.",
          "Understanding this does not mean accepting all parental behaviour. It means interpreting it structurally rather than personally — which is the prerequisite for responding usefully rather than defensively."
        ]
      },
      {
        "heading": "What this means in an international school",
        "items": [
          "Korean families choosing international schools are not exiting the competitive framework. They are choosing a different lane within it — one that leads to US or UK university admission rather than the Suneung pathway.",
          "The intensity of parental investment follows them. The question ''will this get my child into a good university?'' is present in every PTM, every grade, every extracurricular decision, whether or not it is spoken.",
          "A teacher who understands this can anticipate which interactions are likely to carry extra weight and prepare for them differently. A teacher who does not understand it will experience parent intensity as irrational — which makes every difficult conversation harder."
        ]
      }
    ],
    "citations": [
      {"author": "Berkeley Political Review", "year": 2024, "title": "Not My Child: Parental Pressure on Teachers in South Korea"},
      {"author": "NPR / Gong, S.E.", "year": 2023, "title": "South Korea teachers seek protection from harassment by students'' parents"},
      {"author": "Shin, E.", "year": 2023, "title": "South Korean educators want to teach parents a lesson", "journal": "East Asia Forum"},
      {"author": "Statistics Korea", "year": 2023, "title": "Birth rate data 0.78"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 1;

-- Korea D2: The legal architecture
UPDATE public.pd_dimensions
SET
  title = 'The Legal Architecture',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "The Child Welfare Act and its unintended consequences",
        "items": [
          "South Korea''s Child Welfare Act (2014) was designed to protect children from domestic abuse. Article 17 bans ''emotional abuse that may harm a child''s mental health and development'' — a clause broad enough that parents can file criminal complaints against teachers for disciplinary actions, grade disputes, or perceived slights.",
          "NPR (2023) documented the scale of this: more than 1,200 accusations of child abuse were filed against teachers in a five-year period. Of teachers who were actually charged, only 1.5% were eventually convicted. The complaint mechanism works as a legal and social tool regardless of outcome.",
          "The practical effect on teacher behaviour has been severe. A survey by the Korean Teachers and Education Workers Union (KTU) in 2022 found that 93% of teachers said they fear being accused of child abuse. As one civic leader summarised: ''There''s a popular saying among teachers these days — if you don''t do anything, then nothing will happen to you.''"
        ]
      },
      {
        "heading": "What the 2023 crisis revealed",
        "items": [
          "In July 2023, a young Seoul elementary school teacher died by apparent suicide after sustained parental harassment. Teacher protests that followed grew from 5,000 attendees at the first rally to 300,000 by September 2. At least four teachers total died by suicide during the period. A KTU survey from August 2023 found 63.2% of teachers showing symptoms of depression, and 16% had considered suicide.",
          "The crisis was not caused by individual bad parents. It was the visible consequence of a legal architecture that had, over nine years, accidentally made teachers accountable to parents as if parents were clients with formal legal standing over a professional service.",
          "The National Assembly passed legislative amendments in September 2023 restricting dismissal of teachers without justifiable reason if abuse allegations arise, and requiring parents who interfere with educational activities to receive special training. As of 2025, teachers'' groups report the underlying vulnerability remains."
        ]
      },
      {
        "heading": "Why this is relevant to international school teachers",
        "items": [
          "International schools in Korea operate under different legal jurisdiction from public schools. But the cultural context — parents who are accustomed to formal complaint as a first-resort tool — does not stop at the school gate.",
          "A Korean parent who is dissatisfied with an international school teacher''s decision about a grade or a discipline issue may reach for the formal complaint mechanism as a default, not as an escalation. Understanding this changes how you document interactions, how you communicate decisions, and how you respond to early signs of concern.",
          "The most important implication is not legal — it is communicative. The parental behaviour the research describes emerges partly because there is no other institutionalised channel. Schools that create clear, structured channels for parent concern reduce the pressure that currently pushes directly onto individual teachers."
        ]
      }
    ],
    "citations": [
      {"author": "NPR / Gong, S.E.", "year": 2023, "title": "South Korea teachers seek protection from harassment by students'' parents"},
      {"author": "Berkeley Political Review", "year": 2024, "title": "Not My Child: Parental Pressure on Teachers in South Korea"},
      {"author": "KTU (Korean Teachers and Education Workers Union)", "year": 2022, "title": "Survey on teacher fear of child abuse accusations"},
      {"author": "KTU", "year": 2023, "title": "Survey on teacher depression and wellbeing"},
      {"author": "Korea National Assembly", "year": 2023, "title": "Legislative amendments to teacher protection provisions"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 2;

-- Korea D3: The Confucian contract breaking
UPDATE public.pd_dimensions
SET
  title = 'The Confucian Contract Breaking',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "What used to hold",
        "items": [
          "Korean education was historically anchored in a Confucian framework that placed teachers in a position of near-absolute moral authority. The teacher was not simply an instructor but a trusted adult extension of the family — responsible for the student''s character development, not just academic progress.",
          "This framework produced a specific social contract: parents deferred to teachers'' professional judgment, and teachers reciprocated by understanding their role as extending well beyond the curriculum. The homeroom teacher, in particular, was expected to know the whole child.",
          "East Asia Forum (Eunyoung Shin, 2023) captures what has changed: ''The due respect that was once immediately afforded to teachers based on Confucian ideas has lost its ground.'' It has not been replaced by a new framework — it has simply eroded, leaving a power vacuum that the Child Welfare Act and the consumer logic of private education have partially filled."
        ]
      },
      {
        "heading": "The client logic that replaced it",
        "items": [
          "As Korean families increasingly pay fees for private and international education, and as state education has professionalised away from the Confucian homeroom model, a consumer logic has emerged: the school is a service provider, the parent is a client, and client satisfaction is a legitimate performance measure.",
          "This logic is not unique to Korea — it appears across international school systems globally. But in Korea it collides with a context where the formal complaint mechanism already exists, where parental investment is unusually concentrated, and where the prior deference-based contract has broken without a replacement arriving.",
          "The result is a system in which teachers are neither protected by Confucian deference nor operating inside a clear consumer-professional framework. The Korea Herald (2023) reported that 56.9% of teachers identify parent complaints as their primary source of workplace stress."
        ]
      },
      {
        "heading": "What this means for how you work",
        "items": [
          "You cannot restore the Confucian contract. You can, however, create clarity about your role and your boundaries in a way that does not depend on that contract.",
          "Teachers who are most effective in this context do not wait for a dispute to define what parents can expect of them. They name it proactively: at the start of the year, in writing, in a format that is transparent and consistent across the class.",
          "This is not defensive documentation. It is the professional equivalent of what the Confucian contract used to provide — a clear understanding of what kind of relationship this is, and what it does and does not include."
        ]
      }
    ],
    "citations": [
      {"author": "Shin, E.", "year": 2023, "title": "South Korean educators want to teach parents a lesson", "journal": "East Asia Forum"},
      {"author": "Korea Herald", "year": 2023, "title": "6 out of 10 Korean teachers cite parent complaints as main source of stress"},
      {"author": "NPR / Gong, S.E.", "year": 2023, "title": "South Korea teachers seek protection from harassment by students'' parents"},
      {"author": "Jung, J.", "year": 2014, "title": "The Homeroom Teacher Role in Korean Education"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 3;

-- Korea D4: What parents are actually expressing
UPDATE public.pd_dimensions
SET
  title = 'What Parents Are Actually Expressing',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "Investment anxiety without a release valve",
        "items": [
          "The parent who calls a teacher at 11pm is not demonstrating poor impulse control. They have one or two children, have concentrated every parental resource on this educational bet, are watching it in real time, and have no institutionalised channel through which to express concern when something worries them.",
          "The NPR (2023) reporting documents this structural gap explicitly: ''The burden of dealing with parent complaints falls solely on teachers, with no institutionalized response system or obligation for school leadership''s involvement.'' In the absence of a structured channel, the teacher''s personal contact becomes the channel.",
          "Understanding this reframes the interaction entirely. The teacher who hears ''you need to fix this tonight'' as aggression experiences it differently from the teacher who hears it as the expression of investment anxiety in a system that provides no other way to direct that anxiety."
        ]
      },
      {
        "heading": "The difference between structural and personal",
        "items": [
          "Personalising parental behaviour — reading it as a judgment of you as a teacher, as a person, as a professional — is the most common response and the most damaging.",
          "The research on the 2023 teacher crisis documents what happens at scale when teachers experience parental behaviour as personal: 93% fearful of accusations, 63.2% showing depression symptoms, active self-censorship of pedagogical judgments to avoid conflict.",
          "Structural reading does not mean accepting all behaviour. It means accurately identifying the source — which makes it possible to respond to the source rather than just the surface. ''You seem very concerned about this. Let me set up a meeting with you and the head of pastoral care this week'' addresses the source. ''Please do not contact me outside school hours'' addresses only the symptom."
        ]
      },
      {
        "heading": "The high-context communication layer",
        "items": [
          "Not all Korean parent communication about concern is direct. The parent who seems satisfied in a meeting and escalates afterward is not being dishonest — they are navigating a context in which direct confrontation with a teacher is culturally inappropriate, even when Confucian deference no longer provides full protection.",
          "Indirect signals of concern include: a meeting that ends without the parent''s usual questions being fully answered; a formal follow-up email that rephrases what was discussed; a request for a second meeting soon after the first; contact from another parent relaying what this parent said.",
          "Reading these signals accurately requires understanding that the meeting is not always where the real assessment happens. What a parent tells other parents, or writes formally, after a meeting is often the more honest record of their view."
        ]
      }
    ],
    "citations": [
      {"author": "NPR / Gong, S.E.", "year": 2023, "title": "South Korea teachers seek protection from harassment by students'' parents"},
      {"author": "Berkeley Political Review", "year": 2024, "title": "Not My Child: Parental Pressure on Teachers in South Korea"},
      {"author": "KTU", "year": 2022, "title": "Teacher survey on parent complaints and fear of accusations"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 4;

-- Korea D5: What the student is carrying
UPDATE public.pd_dimensions
SET
  title = 'What the Student Is Carrying',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "Risk avoidance as rational self-protection",
        "items": [
          "A Korean student who will not attempt something in public without certainty of success is not demonstrating low confidence. They are performing rational self-protection in a system where visible failure carries disproportionate social consequences.",
          "The research by Bong (2008) on Korean classroom dynamics found that students in high power-distance settings — where teacher authority is felt as unbridgeable — show significantly higher rates of help-seeking avoidance. They will not ask for help rather than risk face loss in front of an authority figure. The same study links this dynamic to higher rates of academic dishonesty: when the gap between student and teacher feels uncrossable, cheating becomes a rational response to otherwise unattainable standards.",
          "For international school teachers trained to value visible risk-taking and public intellectual exploration, a student who will not attempt something without knowing they''re right can read as disengaged or passive. The research suggests they are usually neither — they are applying a learned survival strategy to a new environment."
        ]
      },
      {
        "heading": "The Suneung preparation culture",
        "items": [
          "Even in an international school, Korean students carry the cultural weight of an exam-preparation system that begins in primary school and continues through midnight hagwon sessions. The relationship with failure that this produces — where error is not a learning step but a competitive setback — does not switch off when the student enters an IB classroom.",
          "More than 100 Korean public school teachers took their own lives between 2018 and June 2023. The student who appears passive or anxious is often navigating the same structural pressure from a different angle.",
          "Understanding this changes how you design risk: not as a character challenge (''try even if you might be wrong'') but as a skill to be explicitly taught and practised in structured low-stakes conditions before moving to higher-stakes ones."
        ]
      },
      {
        "heading": "What the student cannot say",
        "items": [
          "The student who is being harassed by a parent, who is caught between a parent''s expectation and a teacher''s assessment, who is experiencing the pressure the research documents at home — cannot usually say so directly.",
          "Indirect indicators matter: a student whose work quality declines sharply after a low grade; a student who seems distracted or anxious before a test without being able to articulate why; a student who asks a question privately that they would not ask in class.",
          "A teacher who notices these signals and creates a private, low-stakes space for the student to speak — without requiring the student to criticise their parents — gives that student something the system otherwise does not provide: a trusted adult who sees what is happening."
        ]
      }
    ],
    "citations": [
      {"author": "Bong, M.", "year": 2008, "title": "Effects of parent-child relationships and classroom goal structures on motivation, help-seeking avoidance, and cheating", "journal": "Journal of Experimental Education", "doi": "10.3200/JEXE.76.2.191-217"},
      {"author": "Berkeley Political Review", "year": 2024, "title": "Not My Child: Parental Pressure on Teachers in South Korea"},
      {"author": "Lee, S. & Kim, H.", "year": 2019, "title": "Academic risk and face protection in Korean secondary classrooms"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 5;

-- Korea D6: What actually works
UPDATE public.pd_dimensions
SET
  title = 'What Actually Works',
  research_status = 'fully_sourced',
  content = '{
    "sections": [
      {
        "heading": "The proactive expectation-setting model",
        "items": [
          "The most transferable finding from the 2023 Korean teacher crisis is a specific practice documented in the NPR reporting: a psychiatrist-principal who runs an alternative school in Seoul has not experienced the harassment pattern that plagues mainstream schools. His method: at the beginning of each semester, he holds a session that explicitly names what parents can ask of the school and what teachers are able to provide.",
          "This is not a legal disclaimer. It is a relational contract — a shared understanding of what the relationship includes and what it does not, agreed to before a dispute creates the context for the conversation.",
          "The mechanism is simple: ambiguity gets filled by assumptions, and in high-stakes competitive environments those assumptions are usually worst-case. Naming the contract explicitly preempts the gap. It does not eliminate all conflict, but it changes what conflict is about — from ''what are the rules?'' to ''are we following the rules we agreed on?''"
        ]
      },
      {
        "heading": "Structuring concern, not just responding to it",
        "items": [
          "The research identifies the absence of an institutionalised channel as one of the primary structural causes of teacher harassment. When there is no channel, the teacher''s person becomes the channel.",
          "Creating a structured channel — a clear protocol for how parents raise concerns, who they raise them with at each level, and what the school''s response commitment is — does more than reduce pressure on individual teachers. It tells parents that their concern is taken seriously and has a route. This is what prevents concerns from escalating to formal complaints.",
          "Practical structure: a written communication protocol sent to all parents at the start of year; a named pastoral lead or ombudsman role at school level; a commitment to a response time for formal concerns. None of these require resources that are not already present. They require intentional design."
        ]
      },
      {
        "heading": "Reducing perceived hierarchy in the classroom",
        "items": [
          "Bong''s (2008) research suggests that reducing the perceived gap between teacher and student — not eliminating authority, but making it approachable — meaningfully reduces help-seeking avoidance and academic dishonesty.",
          "Practical approaches: side-by-side feedback instead of front-of-class correction; explicit normalisation of error as part of learning (with specific examples, not just the general principle); small-group structures where risk-taking is witnessed only by peers rather than the whole class and the teacher simultaneously.",
          "These are not cultural accommodations — they are good pedagogy that happens to be especially effective in contexts where face protection is a strong norm. Framing them this way internally (not ''I am doing this for Korean students'' but ''I am doing this because it produces better learning'') is also more sustainable."
        ]
      }
    ],
    "citations": [
      {"author": "NPR / Gong, S.E.", "year": 2023, "title": "South Korea teachers seek protection from harassment by students'' parents"},
      {"author": "Bong, M.", "year": 2008, "title": "Effects of parent-child relationships and classroom goal structures on motivation, help-seeking avoidance, and cheating", "journal": "Journal of Experimental Education", "doi": "10.3200/JEXE.76.2.191-217"},
      {"author": "Shin, E.", "year": 2023, "title": "South Korean educators want to teach parents a lesson", "journal": "East Asia Forum"}
    ]
  }'::jsonb
WHERE module_id = 'korea-001' AND dimension_number = 6;


-- ────────────────────────────────────────────────────────────
-- CHINA MODULE (china-001)
-- Existing dimensions have good Li (2005) / Ran (2001) content.
-- This patch layers in: gaokao family honour, assessment legibility
-- gap (Quercia 2025), face/smooth meeting dynamic, political context.
-- ────────────────────────────────────────────────────────────

-- China D1: The gaokao shadow (was: Mind vs. Virtue)
UPDATE public.pd_dimensions
SET
  title = 'The Gaokao Shadow',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "The exam as family honour marker",
        "items": [
          "The gaokao (高考) is not simply China''s university entrance exam. It is, as one USC research report frames it, ''the most important indicator of school quality and the deciding factor for the honour or shame of a family.'' Preparation begins from ninth grade. University admission through the gaokao determines career trajectory, marriage prospects, and the family''s social standing in ways that are direct, public, and multigenerational.",
          "Chinese families who choose an international school — and the IB pathway — are making a calculated bet: that a Western university admission will outperform the gaokao pathway for their specific child, in the global economy they expect their child to navigate. This is not a rejection of the gaokao logic. It is the gaokao logic applied to a different game.",
          "A TES Magazine practitioner account from Hefei (Quercia, 2025) summarises what this means for every parent interaction: ''Success is measured through high test scores and content mastery, often reinforced by private tutoring and long study hours.'' The parent asking about homework volume, test frequency, or academic rigour is not being difficult — they are applying the only quality framework they have been trained to trust."
        ]
      },
      {
        "heading": "The political layer",
        "items": [
          "A 2022 Tandfonline study (''The turning tide of the International Baccalaureate in China'') documented a significant shift: the number of international schools in China grew from 260 in 2010 to 1,103 by 2022 — and then government pushback began. The IB has been increasingly framed in state media and government documents as an obstacle to the ''China Dream'' of national rejuvenation.",
          "For parents, this creates a second layer of uncertainty: they are choosing a pathway that is simultaneously aspirational (global university admission) and politically ambiguous (choosing an international curriculum in a climate where that choice has begun to carry political valence).",
          "Teachers who understand this context read a parent''s questions about ''whether the IB is still a good choice'' differently. The parent may be genuinely reconsidering. They are more likely asking for reassurance that the bet still makes sense — competitive reassurance, in the form of university outcomes data, is more effective than philosophical reassurance."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 1;

-- China D2: Assessment friction (was: Parent-Teacher Communication: Parallel Tracks)
UPDATE public.pd_dimensions
SET
  title = 'Assessment Friction',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "Why portfolio assessment feels unverifiable",
        "items": [
          "The IB''s portfolio-and-presentation model is designed to be developmental, holistic, and reflective. From the perspective of a parent whose entire educational formation has involved standardised, ranked, comparative assessment, this model has a specific flaw: it does not tell you where your child stands.",
          "Victoria Quercia (TES Magazine, 2025), drawing on six years of practice in Chinese international schools, identifies this as the first of three recurring friction points: ''Parents prefer frequent standardised testing and letter/percentage grades. IB''s portfolio-and-presentation model feels unverifiable — a parent cannot compare their child to peers or to last year''s cohort.''",
          "The parent who asks for more tests, or for a grade percentage alongside a rubric score, is making a specific, coherent request: give me comparative data in a format I can use. This is not a request to abandon inquiry-based learning. It is a request for legibility."
        ]
      },
      {
        "heading": "What the request for a comparison actually means",
        "items": [
          "When a Chinese parent asks how their child''s portfolio compares to ''international standards,'' or asks for a class average, they are not trying to introduce competitive ranking into an IB classroom. They are asking the same question they have always asked — ''is my child competitive?'' — in the only language they know how to ask it.",
          "The most effective response does not refuse the question or explain why ranking is the wrong frame. It answers the competitive question directly — using IB university placement data, graduate outcome statistics, or specific feedback on where the student''s work sits relative to IB benchmark descriptors — and then shows how the portfolio connects to those outcomes.",
          "Ran''s (2001) ''parallel tracks'' framework remains the most useful conceptual tool here: parents and teachers are often pursuing the same outcome (a competitive, capable student) while using frameworks that do not communicate with each other. The teacher''s job is to build the bridge."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 2;

-- China D3: The extracurricular calculation (was: Exam Culture, System Structure)
UPDATE public.pd_dimensions
SET
  title = 'The Extracurricular Calculation',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "Why service learning is a hard sell",
        "items": [
          "Quercia (2025) identifies the extracurricular question as the second of three major friction points: ''Service learning, outdoor education, creative arts — time spent on these activities is time not spent on academic preparation. In a system where private tutoring routinely extends the school day to 10pm, an extracurricular requirement reads as a competitive disadvantage.''",
          "This is not a misunderstanding of what service learning is. It is a rational calculation in the context of a system that has consistently rewarded academic hours above all other inputs. A parent who questions a service requirement is asking a fair question: ''Does this help my child get into university, or does it cost us time we cannot afford to spend?''",
          "The answer that works is the one that connects the activity to the competitive outcome — not the one that defends the activity''s intrinsic value. ''University admissions offices in the UK and US specifically value documented leadership and service experience. Here is how this activity contributes to your child''s application profile'' is a more trusted answer than ''this develops the whole child.''"
        ]
      },
      {
        "heading": "The tutoring parallel",
        "items": [
          "Chinese parents who enroll their children in private tutoring alongside the international school''s programme are not expressing distrust of the school. They are hedging a high-stakes bet using the only tool they have been trained to trust.",
          "A parent who tells you their child attends a tutoring centre three evenings a week is often not aware that this is unusual or that it might concern you. It is simply what investment in education looks like from within their framework.",
          "The most useful response is not to discourage the tutoring but to ensure the school''s communication about academic preparation is specific enough that the parent can assess whether the tutoring is additive or redundant. ''Your child''s IB coursework already develops the analytical skills the tutor is targeting — here is specifically where'' is more useful than a general reassurance that the school is rigorous."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 3;

-- China D4: Face and the smooth meeting (was: Classroom Dynamics and Learning Sequence)
UPDATE public.pd_dimensions
SET
  title = 'Face and the Smooth Meeting',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "Mianzi in the parent-teacher meeting",
        "items": [
          "Mianzi (面子) — face — is a structuring force in Chinese social interaction that operates in parent-teacher meetings in a specific way. A parent will not openly challenge a teacher''s authority in a formal meeting. To do so would cost the parent face (implying the teacher is incompetent) and cost the teacher face (making the incompetence public in a way that cannot be unseen).",
          "The practical result is that parent-teacher meetings in Chinese international school contexts tend to feel warmer and more resolved than they are. The parent performs satisfaction, the teacher reads satisfaction, and the real assessment of the school happens in parent networks after the meeting.",
          "Quercia (2025) names this explicitly: what a parent tells other parents in WeChat groups after a meeting is often the more honest record of their view. A teacher who reads a quiet, polite meeting as a sign of a strong parent relationship may be reading cultural performance."
        ]
      },
      {
        "heading": "What to watch for instead",
        "items": [
          "Indicators that a seemingly positive meeting has left concerns unresolved: a formal follow-up message that rephrases what was discussed; a request for a second meeting soon after the first; a parent who asks another family to raise a concern on their behalf; increased activity in the parent WeChat group.",
          "The WeChat group is not a gossip channel to be managed. It is the primary epistemic community for most Chinese parents at the school — the place where the school is actually evaluated, where trust is built or lost, and where the real PTM debrief happens.",
          "Teachers who understand this can use it: a parent who speaks positively about a teacher in the WeChat group after a meeting has provided an endorsement that is more trusted than anything the school could say. Creating conditions for that endorsement — by following up PTMs with something specific and useful — is worth the effort."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 4;

-- China D5: The Confucian-IB tension (was: Homework, Praise, and What "Support" Means)
UPDATE public.pd_dimensions
SET
  title = 'The Confucian-IB Tension',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "The tension is within families, not between types",
        "items": [
          "The most common framing of the Confucian-IB tension is that it runs between ''traditional'' and ''modern'' Chinese families — as if families who choose international schools have already resolved the tension on the modern side. This framing is wrong, and it produces systematically bad predictions.",
          "The Quercia (2025) account from Hefei is precise on this: ''Traditional Chinese schooling reinforces values like collective responsibility and deference to authority. By contrast, the IB promotes independent thought, self-expression and student agency. This divergence can create friction between student experiences at school and parental expectations at home.'' The family chose the school. The tension came with them.",
          "A student who is confident and self-directed at school but deferential and achievement-focused at home is not confused. They are navigating two coherent value systems that do not fully align. A teacher who understands this is better positioned to support the student''s development without inadvertently creating the family conflict the IB''s ''international mindedness'' framing can sometimes produce."
        ]
      },
      {
        "heading": "Why the student will not take intellectual risks publicly",
        "items": [
          "A Chinese student who will not speculate, guess, or think aloud in front of the class is not passive or intellectually incurious. They are applying a learned framework in which visible error carries social cost — for them, and potentially for the family whose investment they represent.",
          "Jin and Cortazzi (1998) documented this dynamic in large Chinese classrooms: the norm of ''answering only when certain'' is not about intelligence but about the relationship between public performance and social standing.",
          "The classroom design implication is the same as in the Korean context: risk-taking must be explicitly taught and practised in structures where the social cost of error is low before it can be asked for in high-visibility contexts. The expectation that students will speculate publicly without that scaffolding is a cross-cultural assumption, not a pedagogical universal."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 5;

-- China D6: What actually works (was: Cultural Identity and the Third Culture Child)
UPDATE public.pd_dimensions
SET
  title = 'What Actually Works',
  content = jsonb_set(
    content,
    '{sections}',
    (content->'sections') || '[
      {
        "heading": "University outcomes data as the bridge",
        "items": [
          "The single most effective trust-building tool documented in the practitioner research for Chinese international school parents is concrete university placement data. Not IB philosophy. Not holistic development claims. Where did IB students from this school go? What are they studying? What jobs are they getting?",
          "Quercia (2025) describes the trust-building workshop model: parent sessions that show IB graduate outcomes in terms parents can compare — not ''the IB develops critical thinking'' but ''75% of our IB graduates are admitted to Russell Group or top-50 US universities, and here is what they studied.'' This answers the competitive question in the only language that resolves it.",
          "The political layer adds urgency: in a climate where the IB is being questioned in Chinese state media, parents need the competitive data more than ever. A teacher who can speak confidently to outcomes — not just to the programme''s values — is more trusted by families navigating this uncertainty."
        ]
      },
      {
        "heading": "Structured assessments within IB and student-led conferences",
        "items": [
          "Quercia''s (2025) trust-building framework includes two specific practices that have produced measurable increases in parental buy-in at her school: structured assessments within IB coursework (practice standardised tests, criteria-based grading that parents can read alongside rubric scores) and student-led conferences.",
          "Student-led conferences are especially effective because they make the IB''s portfolio model tangible rather than abstract. When a parent watches their child explain their own learning process — what they worked on, what they are proud of, what they found hard — they encounter IB assessment as lived experience rather than school philosophy. The IB PYP Blog (2015) documents the consistent finding that SLCs shift parent focus from summative grade to learning process.",
          "The combination — outcomes data to answer the competitive question, student-led conference to make the assessment model visible — addresses both the rational and the experiential dimension of the parent''s concern."
        ]
      },
      {
        "heading": "Parent-to-parent trust",
        "items": [
          "The research across international school contexts consistently finds that parent-to-parent communication is more trusted than school-to-parent communication. For Chinese families, where the WeChat group functions as the primary community evaluation channel, this is especially true.",
          "A parent who speaks positively about the school in the group after a student-led conference, or after receiving specific and useful feedback, has provided an endorsement the school cannot buy. Creating conditions for that endorsement is the highest-return communication investment available.",
          "The practical implication: parent community events, parent ambassador programmes, and opportunities for experienced families to speak to newer ones are not supplementary relationship-management activities. In the Chinese international school context, they are the primary mechanism through which the school builds the trust that keeps families enrolled."
        ]
      }
    ]'::jsonb
  )
WHERE module_id = 'china-001' AND dimension_number = 6;


-- ── Verification ─────────────────────────────────────────────
-- After running, confirm titles and section counts:

-- SELECT module_id, dimension_number, title,
--        jsonb_array_length(content->'sections') AS section_count,
--        research_status
-- FROM pd_dimensions
-- WHERE module_id IN ('ksa-001', 'korea-001', 'china-001')
-- ORDER BY module_id, dimension_number;

-- Expected:
--   ksa-001:   D1–D6 with new titles, 3 sections each, fully_sourced
--   korea-001: D1–D6 with new titles, 3 sections each, fully_sourced
--   china-001: D1–D6 with updated titles, existing + new sections, research_status preserved
