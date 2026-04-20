# Calibrate — Content Implementation Plan

How the research in RESEARCH_BRIEF.md shapes the actual module content.
This document drives the SQL seed files and simulation scenario writing.

---

## Structural changes that affect all modules

### 1. Add a shared orientation unit

Before any cultural module, every teacher should encounter a short framing piece —
either a D0 dimension or a standalone intro section in the module UI — that names the
inquiry-assessment gap directly:

> "Every parent you'll meet comes from a system that told them marks were proof of
> their child's worth. IB does not give them marks in that sense. That gap is the
> relationship problem underneath most of the interactions in this module."

This does not need to be a separate Supabase module. It can live as a `preamble`
field on each `pd_modules` row, rendered before D1 begins. It should be 150–200 words,
culturally neutral, and reference the parent's home system by name in each module's
version (CBSE, gaokao, Suneung, ĐGNL, tawjihiyya).

**SQL action:** Add a `preamble_md` column to `pd_modules`. Populate for all five
modules. Render in `ModuleView.jsx` before the dimension list.

### 2. Reframe all quiz questions around misreadings, not facts

Current checkpoint questions test cultural knowledge ("what does X mean in Y culture?").
The research suggests this produces empathy for an abstraction without changing
behaviour. Every quiz question should instead probe a *specific misreading moment* — a
concrete scenario where the teacher's default interpretation is wrong.

**Question structure for all modules:**
- Stem: a specific classroom or PTM moment (a parent says X, a student does Y)
- Four options: one correct interpretation, three plausible misreadings
- The correct answer should never be the most comfortable or flattering one
- Explanations should name the structural dynamic, not just the cultural label

### 3. Each module needs at least two simulation scenarios

Current modules have zero or one simulation. Each module should have:

**Scenario A — The smooth meeting that escalates:** A PTM that feels positive. The
parent is polite, says the right things, leaves satisfied-seeming. A week later, a
formal complaint or a withdrawal enquiry arrives. The teacher must identify what they
missed and what they should have said differently.

**Scenario B — The assessment translation moment:** A parent asks about their child's
progress in a way that exposes the assessment gap ("but what mark is that?", "how does
this compare to other students?"). The teacher must navigate this without either
capitulating to ranking logic or dismissing the question.

A third scenario specific to each culture is listed in the per-module plans below.

---

## Per-module dimension plans

### India (`india-ib`, DB: `india-001`)

**Current state:** 6 dimensions seeded. Research adds the caste-signalling layer,
sharpens the marks-as-social-currency frame, and gives us the WhatsApp group dynamic.

**Revised dimension structure:**

| # | Title | Core content from research |
|---|-------|---------------------------|
| D1 | The percentage question | Marks as proof of social standing, not just academic measurement. Why "where does my child stand?" is a structural need, not a personality trait. The CBSE scale (65% = below average, 95% = exceptional). |
| D2 | The credential ladder | IB as a pipeline *alongside* CBSE logic, not a replacement. India's 225+ IB schools as elite pathway institutions. What "global education" actually signals to families navigating caste and class. |
| D3 | Reading the meeting | How parent deference performs in PTMs. The real conversation happening in WhatsApp groups after. What silence and warmth mean vs. what they feel like. |
| D4 | The "Indian values" signal | What "Indian values" language is actually doing in school communications. The Bengaluru ethnographic study: forward-caste Hindu ethos + IB accreditation as a class-and-community marker. How this creates exclusion dynamics teachers may be unwittingly maintaining. |
| D5 | What the student is carrying | Marks anxiety as family-reputation anxiety. The student who avoids visible trial-and-error. Gender, class, and parental educational level as stress predictors. |
| D6 | What actually works | Answering the competitive question directly (university placement data, IB outcomes). How to make portfolio assessment legible without reducing it to a ranking. Framing the WhatsApp group as a community resource, not a complaint channel. |

**Simulation C (India-specific):** "Indian Values Week" planning meeting. A parent
subgroup pushes for content framing that a teacher notices is culturally specific to
one community. How do you respond without dismissing the parent's cultural investment
or allowing the school to implicitly centre one group's identity?

**Quiz revision priority:** D4 is the most under-served by current questions. Add a
question that probes whether teachers understand the class-and-caste signalling in
"Indian values" language vs. reading it as straightforward cultural pride.

---

### KSA (`ksa-ib`, DB: `ksa-001`)

**Current state:** 6 dimensions seeded, quiz missing entirely. Research gives us the
selection paradox as the organising frame, the language-shift dynamic, and the Vision
2030 tension.

**Revised dimension structure:**

| # | Title | Core content from research |
|---|-------|---------------------------|
| D1 | The selection paradox | Families who chose international education and are worried about what it will do to their child — simultaneously. This is the frame for the entire module. Cultural/religious identity as the *primary* school selection factor (Nature 2024). |
| D2 | Religious and cultural identity in the classroom | What "student voice" and "individual expression" pedagogy signals to families navigating religious authority structures. Why this is heard as a threat to parental authority, not a pedagogical preference. The Alfaraidy research on gender segregation preferences. |
| D3 | The language bargain | English as economic opportunity AND as cultural displacement risk. The Riyadh language-shift research: children in English-medium schools shift to English as dominant spontaneous language. Arabic literacy loss as a measurable parental concern. |
| D4 | Vision 2030 and the new uncertainty | The state pushing female workforce participation, English competence, global credentials — while families navigate what a "good" outcome looks like with no prior generation to look at. The parent who questions student voice activities may be working out what modernity means for their family, not resisting it. |
| D5 | Communication in a high-context culture | Formal communication protocols as appropriate practice, not emotional distance. How dissatisfaction travels (formal channels, third-party intermediaries, not direct confrontation). What a polite, structured PTM actually tells you. |
| D6 | What actually works | Naming the cultural bargain explicitly: "This school can deliver X without requiring Y." University outcomes data. Maintaining communication about Arabic literacy alongside English instruction. |

**Simulation C (KSA-specific):** A parent expresses concern after a class discussion
on "student leadership" — they worry the school is teaching their child to challenge
adult authority. They are polite but clearly troubled. The teacher must navigate this
without dismissing the concern or abandoning the pedagogy.

**Quiz design note:** All 6 checkpoint questions and 3 final questions need to be
written from scratch. The selection paradox should anchor D1. Questions should probe
whether teachers can hold the tension ("this parent chose us AND is worried about us")
rather than resolving it into either "the parent is conservative" or "the parent is
fine."

---

### Korea (`korea-ib`, DB: `korea-001`)

**Current state:** 6 dimensions seeded, quiz missing. Research is the richest of any
module — the 2023 crisis produced extensive documented data.

**Revised dimension structure:**

| # | Title | Core content from research |
|---|-------|---------------------------|
| D1 | The zero-sum structure | Suneung as the sorting mechanism. Birth rate 0.78: most Korean parents have one or two children — all investment concentrated. Why intensity of parental involvement is structurally generated, not a personality type. |
| D2 | The legal architecture | The Child Welfare Act and how vague "emotional abuse" language created a formal complaint mechanism parents can use against teachers. 1,200+ accusations in five years, 1.5% conviction rate. What this has done to teacher behaviour (radical non-intervention). |
| D3 | The Confucian contract breaking | The "due respect immediately afforded to teachers based on Confucian ideas has lost its ground" (East Asia Forum, 2023). How the client logic replaced deference without a new framework arriving to replace either. 93% of teachers fear abuse accusations; 63.2% show depression symptoms. |
| D4 | What parents are actually expressing | Reframing intense parental behaviour as investment anxiety without an adequate release valve. The parent who calls at night is not irrational — they have one child, one bet, and no institutionalised channel for concern. The difference between personalising the behaviour and understanding the structure. |
| D5 | What the student is carrying | Risk avoidance and face protection. The student who will not attempt something publicly without certainty of success. Suneung preparation culture and what it does to relationship with failure. The student who seems passive but is actually performing rational self-protection. |
| D6 | What actually works | The proactive expectation-setting model: naming what parents can ask for and what teachers can provide before a dispute creates the context. The alternative school case study. Recording-friendly meeting practices. How to document concerns without escalating them. |

**Simulation C (Korea-specific):** A parent contacts the teacher via personal
messaging channel late in the evening about a grade. The message is emotionally charged
but stops short of a formal complaint. The teacher must decide how to respond in a way
that addresses the concern, establishes appropriate boundaries, and does not create a
paper trail that could be used against them.

**Quiz design note:** D2 (the legal architecture) is unusual content for a PD module
but essential for teachers working in Korean schools. The quiz question for D2 should
not test recall of the law but probe whether teachers understand the *structural
incentive* the law created (complaint as first-resort because it works, not because
parents are malicious).

---

### China (`china-ib`, DB: `china-001`)

**Current state:** 6 dimensions seeded, quiz missing. Research gives us the three
friction points as a clear organising structure.

**Revised dimension structure:**

| # | Title | Core content from research |
|---|-------|---------------------------|
| D1 | The gaokao shadow | The exam as family honour marker. "The most important indicator of school quality and decides the honor or shame of a family." Why choosing IB is a calculated bet, not an exit from competitive logic. The political layer: IB increasingly framed in state media as an obstacle to the China Dream. |
| D2 | Assessment friction | Why portfolio-and-presentation assessment feels unverifiable. Parents cannot compare their child to peers or to last year's cohort. The specific request for standardised tests is a request for *legible comparative data*, not a rejection of inquiry learning. |
| D3 | The extracurricular calculation | Service learning, outdoor ed, creative arts — read through the lens of a system where private tutoring already extends the school day to 10pm, any time not spent on academic preparation is a competitive disadvantage. This is rational, not obstructionist. |
| D4 | Face and the smooth meeting | Mianzi (face) as a structuring force. Why a warm, agreeable PTM is not a resolved parent. The real assessment of the school happens in parent networks after the meeting. What the parent is doing in the meeting vs. what they are actually thinking. |
| D5 | The Confucian-IB tension | Collective responsibility vs. individual agency. Teacher authority and Confucian deference coexisting with the client logic of international school fees. The student who will not take intellectual risks in public. Why the tension is *within* families, not between traditional and modern families. |
| D6 | What actually works | University outcomes data as the bridge. Structured assessments within IB coursework (practice standardised tests, criteria-based grading visible to parents). Student-led conferences to make portfolio assessment tangible. Parent workshops that translate IB criteria into familiar language. |

**Simulation C (China-specific):** After a student-led conference that the parent
attended and seemed positive about, the teacher receives a message through the school's
formal channel asking whether there is a way to see how their child's portfolio
"compares to international standards." The parent cites specific university admission
statistics from another school. What does the teacher do?

**Quiz design note:** D4 (face and the smooth meeting) is the highest-stakes misreading
for Chinese context. The quiz question should present a PTM scenario that sounds
positive and ask teachers to identify the warning signs they are likely to miss.

---

### Vietnam (`vietnam-ib`) — Full new build

**Current state:** Module slug exists in the UI but nothing is seeded. Full build needed.

**DB ID to use:** `vietnam-001`

**Module metadata:**
- Title: Understand Vietnam
- Subtitle: Filial piety, academic honour, and teaching in a system mid-reform
- Flag: 🇻🇳
- Intro: Vietnam's international school sector is one of the fastest-growing in the
  world, but the families choosing these schools are navigating a culture in transition.
  Confucian educational values — deference to teacher authority, academic success as
  family honour, collective harmony over individual expression — sit alongside a
  government reform agenda explicitly pushing toward learner-centred, competency-based
  education. This module helps you understand the gap between those two forces and how
  it shapes the parents and students in your classroom.

**Dimension structure:**

| # | Title | Core content from research |
|---|-------|---------------------------|
| D1 | Education as family honour | Filial piety and academic success as a means of bringing esteem to the family name — not personal achievement. Authoritarian filial piety (obligation-driven) vs. reciprocal filial piety (relationship-driven). Why a student who is visibly hardworking and compliant may be carrying a depression risk, not a motivation advantage. |
| D2 | The reform gap | Resolution 29 (2013) mandated learner-centred education nationally. But "quality education" for many families still means textbook coverage and structured visible output. The teacher returning from an overseas programme encounters this gap every day. Parents who ask for more homework are not anti-reform — they are using the only quality signal they know. |
| D3 | Teacher authority and face | Teacher authority held in highest esteem (Confucian heritage). Students do not ask questions or challenge ideas in class — not because they are disengaged but because doing so would disrupt collective harmony and cost both parties face. The teacher who reads silence as comprehension may be misreading cultural performance. |
| D4 | The assessment translation problem | How textbook-driven learning functions as a quality marker for Vietnamese parents. The parallel between Vietnam and China on assessment legibility — with one difference: Vietnam's French lycée tradition in urban areas makes essay-based and portfolio assessment more familiar if framed as academically rigorous. |
| D5 | What the student is carrying | The longitudinal data: academic stress rising measurably from Grade 6 to Grade 9. 92.1% of students attend private tutoring. Father's educational level as the strongest family stress predictor. The student who enrolls in extra classes alongside international school is not doubting the school — they are fulfilling a family obligation. Depression rates (27% in Hanoi secondary study) as a background context for pastoral care. |
| D6 | What actually works | Framing portfolio assessment as rigorous (the French academic tradition as a bridge). Proactive parent communication about what the school's assessment *produces* (university outcomes). Student-led conferences to make learning visible. Understanding that improvement-focused parent communication is culturally normal — Vietnamese parents are accustomed to hearing about what needs to improve, not what is already good. |

**Simulation scenarios (Vietnam):**

**Scenario A — The smooth meeting that escalates:** PTM with a Vietnamese parent who
is extremely polite, expressive of gratitude, and asks no challenging questions. Three
weeks later the school receives a request — channelled through a relative who works at
the school — asking whether the student can take supplementary standardised tests to
verify their level. The teacher must understand what happened in the meeting and what
the request actually means.

**Scenario B — The improvement-focused feedback moment:** A teacher gives a student
positive feedback in front of the class. The student looks uncomfortable. Later, the
parent contacts the teacher to ask whether the child is actually performing well, because
"the teacher seemed to say so in class but we are not sure." The teacher must understand
the communication dynamic and what kind of feedback travels well in this cultural context.

**Scenario C — The extra classes question:** A parent reveals that their child attends
a tutoring centre for maths and science three evenings a week alongside international
school. They ask whether this is a problem. The teacher must navigate this without
either validating the tutoring as a vote of no-confidence in the school or dismissing
the family's investment logic.

**Quiz questions (Vietnam — all new):**

Checkpoints (one per dimension, dimension_number 1–6):
- D1: A hardworking, compliant student who always does the work but never volunteers
  in discussion — strongest first interpretation? (Tests whether teacher reads filial
  piety obligation vs. low confidence or personality)
- D2: A parent asks for more homework because "the other school used to give three
  worksheets every night" — strongest first interpretation? (Tests whether teacher reads
  quality-marker logic vs. resistance to IB)
- D3: A student never asks a question in class but performs well on written assessments
  — what does the research say about this pattern? (Tests Confucian face-saving in
  classroom vs. comprehension)
- D4: A parent asks whether the portfolio is "the same as the national curriculum
  standard" — what is the most useful way to hear this? (Tests assessment-legibility
  request vs. system distrust)
- D5: A student enrols in private tutoring three evenings a week alongside the
  international school — strongest first interpretation? (Tests 92.1% tutoring
  normalisation vs. school distrust)
- D6: A parent says "please always tell us what our child needs to improve" and seems
  uninterested in hearing positives — what does the research say about this? (Tests
  Vietnamese feedback culture vs. negative parent assumption)

Final exam questions (3, dimension_number NULL):
- Q1: A PTM goes smoothly, the parent is warm and grateful, and the teacher feels
  confident the relationship is strong. Which of the following should the teacher still
  consider? (Face-saving / indirect communication)
- Q2: A Vietnamese parent asks for a comparison between their child and "the class
  average" on an IB assignment. The most research-aligned first response? (Assessment
  legibility + French academic frame bridge)
- Q3: A student shows signs of high stress alongside high performance. The most useful
  frame for understanding this pattern? (Authoritarian filial piety + depression risk)

---

## Parent module outline (v2)

The research makes a strong case for parent-facing content. This is not in the current
build scope but should be planned now so the DB schema can accommodate it.

### Architecture

Parent modules are a separate module type (`module_type: 'parent'`) that:
- Are shorter (3 dimensions instead of 6)
- Use first-person language ("your child," "you," not "the parent")
- Focus on assessment literacy and school navigation rather than cultural self-awareness
- Are assigned to parents in the `assignments` table using `role_target: 'parent'`

### Proposed parent modules

**Understanding IB Assessment** (cross-cultural, all schools)
- D1: What portfolio assessment actually measures (and how to read it)
- D2: How to have a productive conversation with your child's teacher
- D3: What your child's IB results mean for university admission

**Understanding the Curriculum Change** (Woodstock-specific — already exists as
`woodstock-transition`, currently parent-facing)

**Your Child in an International School** (culture-specific versions)
- One version per nationality group; uses the *same research* as the teacher modules
  but frames it from the parent's perspective: "Here is why your teacher does X. Here
  is what it means for your child."

### DB schema addition needed

```sql
-- Add to pd_modules:
ALTER TABLE pd_modules ADD COLUMN IF NOT EXISTS module_type text DEFAULT 'teacher'
  CHECK (module_type IN ('teacher', 'parent', 'shared'));

-- Parent modules can then be filtered in the UI by role:
-- teachers see teacher + shared modules
-- parents see parent + shared modules
```

---

## Implementation sequence

### Phase 1 — Revise existing SQL seeds (before Codex Step 1)

For each of india, ksa, korea, china: update `pd_dimensions` rows to align body_md
content with the revised dimension structure above. This is content editing, not schema
change. Priority order: KSA → Korea → China → India (India is already strongest).

### Phase 2 — Write quiz SQL (Codex Step 1)

Write checkpoint and final exam questions for KSA, Korea, China following the misreading
frame. Use the dimension structure above as the content spec for each question.

### Phase 3 — Write simulation scenarios SQL (alongside Codex Step 1)

For each module, write 2–3 scenarios into `pd_scenarios`. The Scenario A and B
templates above are generic; Scenario C is module-specific. Each scenario needs:
`setup`, `common_misread`, `actual_dynamic`, `response_framework`.

### Phase 4 — Build Vietnam from scratch (new SQL file: `vietnam_seed.sql`)

Full build: `pd_modules` row, 6 `pd_dimensions` rows, 6 checkpoint questions, 3 final
questions, 3 simulation scenarios. DB ID: `vietnam-001`. Use the content plan above as
the spec.

### Phase 5 — Add `preamble_md` to all modules

Schema migration + populate for all five modules. The shared orientation text (the
inquiry-assessment gap framing) should appear before D1 in every module.

### Phase 6 — Parent module schema (v2 planning only)

Add `module_type` column to `pd_modules`. No parent content yet — this is prep so
the schema is ready when parent modules are built.

---

## Content principles (for all writing)

These apply to every dimension body, quiz question, and simulation scenario written
from here forward:

1. **Name the structure, not the culture.** "The Suneung creates a zero-sum investment
   dynamic" is more useful than "Koreans are intense about education."

2. **Never frame the parent as the problem.** Every parent behaviour documented in the
   research is a rational response to the system that formed them. The module should
   produce systemic understanding, not cultural judgment.

3. **Misreadings are the content.** The most valuable moment in any dimension is the
   specific scenario where a well-intentioned teacher gets it wrong. Lead with that.

4. **The correct answer is rarely comfortable.** Quiz questions where the right answer
   validates the teacher's existing instinct are not testing anything. The correct
   option should require the teacher to update their default interpretation.

5. **Practical takeaways must be concrete.** "Be culturally sensitive" is not a
   takeaway. "When a parent asks where their child stands, answer the competitive
   question directly before explaining why ranking isn't the whole picture" is.
