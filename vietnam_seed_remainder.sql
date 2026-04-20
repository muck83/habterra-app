BEGIN;

-- ── DIMENSIONS ────────────────────────────────────────────────────────────────

INSERT INTO pd_dimensions (module_id, dimension_number, title, research_status, content) VALUES

-- ── D1: The ĐGNL/Exam System ─────────────────────────────────────────────────
('vietnam-001', 1, 'Education as Family Honour: The Exam System and What Scores Mean', 'fully_sourced',
  $${"summary":"In Vietnam, academic success is not a personal achievement — it is a family event. The national university entrance examination system, including the ĐGNL (Đánh giá năng lực) competency-based test used by Vietnam National University and the traditional thi tốt nghiệp THPT (high school graduation exam), functions as the sorting mechanism for life outcomes. But the cultural weight of scores extends far beyond university placement. A child's exam results are understood as reflecting the family's investment, the parents' sacrifice, and the honour of the family name across generations. When an IB teacher presents a portfolio or a rubric that does not produce a rank, the parent is not rejecting the pedagogy — they are losing access to the only proof of educational quality they have ever been trained to read.","sections":[{"heading":"The Exam as Family Honour","items":["Vietnam's university entrance system is the primary sorting mechanism for social mobility. Preparation begins years before the exam, and results are treated as public information within extended families and communities.","Academic success is understood through the Confucian frame of filial piety: the child who scores well is repaying the parents' sacrifice. The child who scores poorly is not just failing academically — they are failing a moral obligation.","A 2020 Frontiers in Psychology study comparing Polish and Vietnamese students found that authoritarian filial piety — the obligation-driven variant where a child studies out of duty rather than intrinsic motivation — is a stronger predictor of study engagement in collectivistic cultures like Vietnam. The same study found this variant is negatively associated with actual academic achievement and positively associated with depressive symptoms.","The practical implication: a Vietnamese student who is visibly hardworking and compliant may be carrying a burden that has nothing to do with curiosity or intrinsic motivation and everything to do with not dishonouring the family."]},{"heading":"Scores as Social Currency","items":["In Vietnamese communities, a child's academic results circulate as social information. Extended family gatherings, neighbourhood conversations, and Lunar New Year visits include discussion of children's academic standing.","Parents who have invested in international school fees — often representing a significant proportion of household income — are monitoring the return on that investment using the only metric their community recognises: comparative academic position.","When a parent asks 'how does my child compare?', they are not asking for a ranking out of curiosity. They are asking for the information they need to report back to a social network that evaluates parenting through academic outcomes.","The student who says 'my parents will be disappointed' after a moderate assessment result is often reporting a literal truth about how the result will be received at home, not expressing personal anxiety alone."]},{"heading":"What This Means for IB Teachers","items":["The parent who asks for marks, rankings, or standardised test results is not rejecting your assessment philosophy. They are requesting the data format their entire social world is calibrated to interpret.","Explaining that IB 'doesn't work that way' answers a question the parent did not ask. The question is: 'Is my child competitive? Is this investment working?' Answer that question first.","University outcomes data is the single most effective bridge: showing what IB graduates achieve in Vietnamese and international university admissions gives parents a legible outcome in the competitive frame they understand.","The student carrying exam-culture pressure into an IB classroom needs explicit, repeated reassurance that the assessment format rewards what they are doing — not just that it is 'different from what they are used to'."]}],"citations":[{"author":"Frontiers in Psychology","year":2020,"title":"The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison","doi":"10.3389/fpsyg.2020.607141"},{"author":"Tran et al.","year":2024,"title":"Academic stress among students in Vietnam: a three-year longitudinal study","doi":"PMC11442093"},{"author":"WENR","year":2017,"title":"Education in Vietnam","doi":""}]}$$::jsonb),

-- ── D2: Studying to Repay Parents ────────────────────────────────────────────
('vietnam-001', 2, 'Học Để Đền Ơn: Studying to Repay Parents', 'fully_sourced',
  $${"summary":"The Vietnamese phrase 'học để đền ơn' — studying to repay the debt to one's parents — captures a motivational framework that most Western-trained teachers have no equivalent for. In individualistic educational cultures, motivation is understood as intrinsic (curiosity, passion, self-actualisation) or extrinsic (grades, rewards). In Vietnamese culture, there is a third category that sits between these: filial obligation. The student studies hard not primarily because the subject fascinates them, and not primarily because they want a good grade, but because academic effort is the morally correct way to honour the sacrifices their parents have made. Understanding this reframes nearly every signal a teacher receives from Vietnamese students.","sections":[{"heading":"Filial Piety as Educational Motivation","items":["Confucian filial piety (hiếu) in Vietnam operates as a structuring force in educational motivation. Children are taught from early childhood that parents sacrifice for their education and that academic success is the primary way to repay that sacrifice.","Research distinguishes between two forms: reciprocal filial piety (based on gratitude and emotional closeness) and authoritarian filial piety (based on obligation, duty, and fear of disappointing). Both are present in Vietnamese families, but the authoritarian variant dominates in educational contexts.","A 2024 PMC study on happiness and filial piety in Vietnamese families found that filial piety and family happiness are deeply interdependent — academic success is experienced as contributing to family wellbeing, not just individual achievement.","The student who says 'I need to do well for my parents' is not reporting external pressure in the way a Western teacher might hear it. They are describing what they understand as a moral reality — a debt that academic effort repays."]},{"heading":"What Teachers Misread","items":["A hardworking, compliant student who never volunteers in discussion and always completes assignments on time — this profile is frequently read by international teachers as 'strong student, perhaps a bit quiet.' The research suggests a different reading: this may be a student whose entire relationship to learning is structured by obligation rather than curiosity, and whose compliance masks a rising stress load.","The student who asks 'is this important for my grade?' is not necessarily grade-obsessed. In the filial piety frame, they are asking: 'Does this count toward the thing I owe my family?' If it doesn't count, the effort feels morally unanchored.","When a parent says 'we have sacrificed everything for this education,' they are not being dramatic. Vietnamese families, particularly those outside the urban elite, often redirect significant household resources toward international school fees. The parent is naming a literal economic reality and the moral weight it carries.","The longitudinal data from Tran et al. (2024) shows academic stress rising significantly from Grade 6 to Grade 9, with father's educational level as the strongest family predictor. Highly educated fathers place expectations tied to familial reputation — their children show significantly higher stress in despondency and workload domains."]},{"heading":"Navigating Filial Motivation Without Dismissing It","items":["The worst response is to tell a student that they should study 'for themselves, not for their parents.' This invalidates the moral framework that organises their entire relationship to education and produces disorientation rather than liberation.","The better response is to work within the frame: 'Your parents want you to succeed, and this skill — being able to think independently and take intellectual risks — is part of what will make you successful.' This honours the filial motivation while expanding what counts as success.","For parents: frame IB skills as competitive advantages, not alternatives to academic rigour. 'Critical thinking is what top universities are looking for' connects inquiry pedagogy to the outcome parents care about without asking them to abandon the motivational structure that drives their child's effort.","Pastoral care teams should be alert to the specific depression risk documented in the research: 27% depression rate in a Hanoi secondary student study, with authoritarian filial piety as a contributing factor. A student who appears high-functioning but reports feeling trapped by academic expectations may need support that goes beyond study skills."]}],"citations":[{"author":"Frontiers in Psychology","year":2020,"title":"The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison","doi":"10.3389/fpsyg.2020.607141"},{"author":"PMC","year":2024,"title":"The interdependence of happiness and filial piety within the family: a study in Vietnam","doi":"PMC11016942"},{"author":"Tran et al.","year":2024,"title":"Academic stress among students in Vietnam: a three-year longitudinal study","doi":"PMC11442093"}]}$$::jsonb),

-- ── D3: The Rote Learning Bargain ────────────────────────────────────────────
('vietnam-001', 3, 'The Rote Learning Bargain: What "Learning" Means in Vietnamese Pedagogy', 'fully_sourced',
  $${"summary":"International teachers are trained to view rote learning as the enemy of understanding. Vietnamese educational culture treats it as the foundation. This is not a simple disagreement about teaching methods — it is a fundamentally different theory of how knowledge is acquired. In the Confucian pedagogical tradition that shapes Vietnamese schooling, memorisation comes first; understanding follows through repeated practice and application. The student who memorises before they understand is not doing it wrong — they are following a centuries-old learning sequence that their parents, their tutors, and their previous teachers all reinforced. A teacher who dismisses this as 'just rote learning' is dismissing the only model of academic seriousness the student has ever known.","sections":[{"heading":"Memorisation as Foundation, Not Enemy","items":["Vietnamese classroom culture, shaped by both Confucian heritage and the post-1975 Soviet-influenced education model, treats textbook mastery and memorisation as the baseline of academic competence. A student who can reproduce content accurately is demonstrating the first stage of learning.","This is not the same as saying Vietnamese education values memorisation over understanding. The sequence is different: memorise first, then understand through application. Western inquiry pedagogy reverses this sequence — understand first, then apply. Neither is inherently superior, but the collision between them produces genuine confusion for students and families.","A 2023 Tandfonline study on Vietnam's education reforms documented the gap between policy intent (learner-centred, competency-based) and classroom reality: many teachers and parents still associate 'quality education' with textbook coverage, structured instruction, and visible academic output.","Resolution 29 (2013) mandated a national shift toward learner-centred education. Implementation has been uneven. The reform is real, but many families have not yet seen it deliver outcomes they trust."]},{"heading":"What 'Quality Education' Looks Like to Vietnamese Parents","items":["For many Vietnamese parents, quality education is visible: full notebooks, regular homework, structured lessons, clear textbook progression. These are not superficial signals — they are the quality markers the national system trained families to recognise.","A parent who asks for more homework is not resisting IB pedagogy. They are using the only quality signal they have. In a system where 92.1% of students attend private tutoring alongside regular school, the amount of structured academic work is a proxy for institutional seriousness.","Portfolio assessment, student-led conferences, and narrative feedback can feel unverifiable to parents whose entire educational experience was built on standardised outputs. The parent is not suspicious of the school — they are missing the data format they know how to read.","The French colonial educational overlay in urban Vietnam (particularly Ho Chi Minh City) provides one bridge: the French lycée tradition values structured written argument and intellectual rigour in essay form. Portfolio assessment framed as academically rigorous writing — rather than as creative expression — may land better with Vietnamese parents than the same assessment framed through progressive pedagogy language."]},{"heading":"Working With the Rote Foundation, Not Against It","items":["The productive move is not to eliminate memorisation but to build on it. A student who has memorised key content can be invited to apply it in novel contexts — this honours their preparation while extending it toward the skills IB assessment rewards.","Explicit scaffolding between memorisation and application reduces anxiety: 'You know the content. Now I want you to use it to solve a problem you haven't seen before.' This frames inquiry as the next step, not a replacement for what the student already does well.","For parents: explain what your assessment tests and how the student's existing study habits contribute to it. 'The textbook knowledge your child has is valuable. Our assessments also test whether they can use that knowledge in new situations — and that is what top universities are looking for.'","Avoid framing the transition as 'from rote to real learning.' Vietnamese families hear this as a dismissal of the entire educational tradition that produced their own competence. Frame it as 'from strong foundations to deeper application.'"]}],"citations":[{"author":"Tandfonline","year":2023,"title":"Changing teachers' beliefs and practices towards learner-centred education: experiences from Vietnam's education reforms","doi":"10.1080/25783858.2023.2177191"},{"author":"WENR","year":2017,"title":"Education in Vietnam","doi":""},{"author":"Tran et al.","year":2024,"title":"Academic stress among students in Vietnam: a three-year longitudinal study","doi":"PMC11442093"}]}$$::jsonb),

-- ── D4: Face and Parent Communication ────────────────────────────────────────
('vietnam-001', 4, 'Face and the Smooth Meeting: What Silence and Agreement Actually Mean', 'fully_sourced',
  $${"summary":"Vietnamese communication culture is structured by face (thể diện) — a concept that governs what can be said, to whom, and in what context. In a parent-teacher meeting, face operates on both sides simultaneously: the parent will not openly challenge the teacher because doing so would cost the teacher face and, by implication, cost the parent face for having created an uncomfortable situation. The teacher who reads a polite, agreeable PTM as a resolved parent is misreading cultural performance as satisfaction. The real assessment of the school is happening elsewhere — in family conversations, in parent networks, and in decisions about supplementary tutoring that the school may never see.","sections":[{"heading":"How Face Structures Parent-Teacher Communication","items":["In Vietnamese culture, direct criticism of a teacher is culturally inappropriate — it implies the teacher is incompetent (costing them face) and that the parent is the kind of person who creates conflict (costing the parent face). The result: meetings feel warmer and more resolved than they are.","A parent who says 'yes, I understand' in a PTM may be performing agreement rather than expressing it. The Vietnamese communication norm prioritises harmony in the immediate interaction; disagreement is processed privately, later, through indirect channels.","Silence in a meeting is not absence of opinion. It may be the parent managing the social cost of what they actually want to say. A parent who listens attentively, nods, thanks the teacher, and leaves without questions may have a list of concerns they chose not to raise.","The request channelled through a third party — a relative who works at the school, a more senior parent, or a formal written communication — is often how genuine concerns travel. If a concern arrives through an intermediary, it has likely been discussed extensively before reaching the teacher."]},{"heading":"The Parallel Assessment: What Happens After the Meeting","items":["Vietnamese parents, like parents in other Confucian-heritage cultures, assess the school through informal networks — conversations with other parents, family discussions, and comparison with other families' experiences. The meeting is one data point; the network discussion afterward is where the real evaluation happens.","A parent who praises the school warmly to the teacher's face and simultaneously enrolls their child in supplementary tutoring is not being inconsistent. They are managing two parallel systems: the relationship with the school (face-preserved) and the academic insurance policy (family honour protected).","When a parent asks whether the portfolio is 'the same standard as the national curriculum,' they are often testing whether the school's assessment produces outcomes their network can recognise. The question is about legibility, not distrust.","Teachers should expect that any significant communication — a grade, a behavioural concern, a programme change — will be discussed in the parent network before the next interaction. Planning for this is not paranoia; it is culturally informed communication."]},{"heading":"Improvement-Focused Feedback Culture","items":["Vietnamese parents are culturally accustomed to hearing what needs to improve, not what is already good. A teacher who leads with positives and buries the developmental feedback may inadvertently signal that the child is not being taken seriously.","The 'sandwich' feedback model (positive-negative-positive) common in Western teacher training can misfire: the parent may hear the positives as filler and wonder what the teacher is avoiding saying. Many Vietnamese parents prefer directness about what needs to change.","'Please always tell us what our child needs to improve' is not a negative parenting signal. It is a culturally appropriate request for the kind of feedback that feels useful and respectful in Vietnamese educational culture.","The most effective feedback format for Vietnamese parents: name the specific skill or behaviour that needs development, explain what improvement looks like, and describe what the school and family can each do to support it. This is concrete, actionable, and lands as serious engagement rather than vague reassurance."]}],"citations":[{"author":"PMC","year":2022,"title":"Culture expectations in foreign language classrooms: a case in Vietnam","doi":"PMC9364017"},{"author":"Tandfonline","year":2023,"title":"Changing teachers' beliefs and practices towards learner-centred education: experiences from Vietnam's education reforms","doi":"10.1080/25783858.2023.2177191"},{"author":"MDPI","year":2025,"title":"Confucian Educational Thought and its Relevance to Contemporary Vietnamese Education","doi":"10.3390/philosophies10030070"}]}$$::jsonb),

-- ── D5: What the Student Is Carrying ─────────────────────────────────────────
('vietnam-001', 5, 'What the Student Is Carrying: Sacrifice, Stress, and the First-Generation Dynamic', 'fully_sourced',
  $${"summary":"The Vietnamese student sitting in your IB classroom is often carrying a weight that is invisible to the teacher: the family's economic sacrifice to afford the fees, the expectation that this education will transform the family's trajectory, the pressure of being the first generation to attend an international school with no older sibling or cousin who has been through this system before, and — for students from outside Ho Chi Minh City or Hanoi — the rural-urban tension of having left a community behind for an urban educational opportunity. Understanding this weight does not mean lowering expectations. It means reading student behaviour accurately and providing support that addresses the actual pressure rather than the presenting symptom.","sections":[{"heading":"Economic Sacrifice and Educational Investment","items":["International school fees in Vietnam represent a significant proportion of household income for many families — particularly those outside the established urban elite. The decision to enroll a child in an international school is often a family-level economic event, not a routine consumer choice.","For families making this sacrifice, every aspect of the school's output is evaluated against the investment. A parent who questions the value of an extracurricular activity or asks whether service learning 'counts' is often calculating the return on a financial commitment that constrains the rest of the family's spending.","The student is often aware of this sacrifice. Vietnamese children, raised in the filial piety framework, understand that their parents are giving up something for their education. This awareness can be motivating — but it can also be paralysing when the student encounters difficulty or failure.","The practical implication: a student who seems disproportionately distressed by a moderate assessment result may be responding not just to the grade but to the weight of the family investment it represents. 'I cannot fail because my parents have given up too much' is a real cognitive frame, not an exaggeration."]},{"heading":"The First-Generation International School Dynamic","items":["Vietnam's international school sector is younger than China's or India's. Many families choosing IB schools are first-generation international school parents — they have fewer peers who have been through the system and are navigating with less social proof than equivalent Chinese or Indian families.","This means the parent is learning the system at the same time as the child. Terms like 'formative assessment,' 'learner profile,' 'inquiry cycle,' and 'criterion-referenced rubric' are not just unfamiliar vocabulary — they represent an entire educational philosophy the parent has no frame of reference for.","First-generation parents are more likely to rely on proxy signals for quality: homework volume, teacher strictness, visible academic structure. These are not signs of conservatism — they are the only quality markers available to someone without prior international school experience.","The teacher's role includes parent education as much as student education. Explicit, jargon-free explanation of how the school works — not as a one-time orientation event but as a sustained communication practice — is the single most protective factor for the parent-school relationship."]},{"heading":"The Stress Data","items":["A three-year longitudinal study (Tran et al., 2024, PMC11442093) tracked Vietnamese students from Grade 6 to Grade 9 and found that academic stress rose significantly over time — mean ESSA scores increasing from 46.4 to 53.5 (p<0.001).","92.1% of students in the study attended extra (tutoring) classes. Attending extra classes was independently associated with higher stress. The student who enrolls in private tutoring three evenings a week alongside international school is not doubting the school — they are fulfilling a family expectation so normalised that stopping would feel like reducing investment.","Father's educational level was the strongest family-level stress predictor. Highly educated fathers placed greater expectations tied to familial reputation, and their children showed significantly higher stress in 'despondency' and 'workload' domains.","A 2019 Hanoi study cited in the same research found a 27% depression rate in secondary students. This is background context for pastoral care: Vietnamese students are statistically likely to be carrying more stress than they present, and the cultural norm of maintaining composure and not burdening others makes self-reporting unreliable as a detection method."]}],"citations":[{"author":"Tran et al.","year":2024,"title":"Academic stress among students in Vietnam: a three-year longitudinal study","doi":"PMC11442093"},{"author":"Frontiers in Psychology","year":2020,"title":"The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison","doi":"10.3389/fpsyg.2020.607141"},{"author":"ISC Research","year":2022,"title":"Vietnam international school market data","doi":""}]}$$::jsonb),

-- ── D6: What Actually Works ──────────────────────────────────────────────────
('vietnam-001', 6, 'What Actually Works: Concrete Strategies for Vietnamese Family Dynamics', 'partial',
  $${"summary":"This dimension translates the cultural understanding from D1–D5 into concrete, actionable strategies. The overarching principle: Vietnamese parents are not the problem to be managed. They are stakeholders navigating a high-stakes educational transition with limited social proof and a deep cultural framework that defines academic success as a family-level moral achievement. Every strategy here is designed to work within that framework rather than against it.","sections":[{"heading":"Making Assessment Legible","items":["Answer the competitive question directly before explaining your assessment philosophy. When a parent asks 'how is my child doing?', begin with the outcome data: 'Students from our programme are accepted at these universities with these outcomes.' Then explain how the assessment system produces those outcomes.","Use the French academic tradition as a bridge where appropriate. Portfolio assessment framed as 'rigorous academic writing and structured argument' lands differently with Vietnamese parents than the same assessment framed as 'creative expression' or 'student voice.' The former sounds serious; the latter sounds soft.","Student-led conferences are one of the most effective tools for shifting parent understanding of portfolio assessment. When students explain their own learning process to parents, parents encounter IB assessment as lived experience rather than abstract philosophy. But student-led conferences alone do not address the competitive positioning question — pair them with explicit university outcomes data.","Provide assessment criteria in advance, translated into plain language. A rubric that says 'demonstrates critical thinking' means nothing to a parent whose educational experience measured learning in percentage points. A rubric that says 'can use evidence to support an argument and consider a counter-argument' is concrete and legible."]},{"heading":"Communicating With Vietnamese Parents","items":["Lead with what needs to improve, not with positives. Vietnamese parents are culturally calibrated to hear developmental feedback as the serious part of the conversation. Leading with positives can feel like avoidance.","Be specific and action-oriented. 'Your child needs to develop critical thinking' is too abstract. 'Your child can identify the main argument in a text but does not yet consider alternative interpretations — here is how we are working on that' is useful.","Expect the real conversation to happen after the meeting. Plan your communication assuming that everything you say will be discussed in the family and possibly in the parent network. This is not a threat — it is an opportunity. Clear, specific, action-oriented feedback travels well through networks. Vague reassurance generates anxiety.","Use written follow-ups after PTMs. A brief email summarising what was discussed, what the next steps are, and what the family can do at home gives the parent a concrete reference for their post-meeting discussions."]},{"heading":"Supporting Students Carrying the Weight","items":["Name the transition explicitly. Tell students: 'The way you learned before was not wrong. It prepared you well. What we are adding here is the ability to use that knowledge in new situations — and that is what will make you strong in university.' This validates their existing identity while expanding it.","Create low-stakes practice spaces for intellectual risk-taking. Vietnamese students who have been trained to avoid public error need graduated exposure: written reflection before verbal sharing, pair discussion before whole-class contribution, draft-and-revise before final submission.","Monitor the tutoring load. Ask students directly — in a pastoral, not disciplinary context — about their after-school schedule. A student attending tutoring three evenings a week alongside a full IB day is operating on a cognitive load that affects everything from attention in morning classes to capacity for creative work.","Connect pastoral care to the specific depression risk. The 27% secondary depression rate in Vietnamese students is not an abstraction — it means roughly one in four students in your class may be carrying a mental health burden. Vietnamese cultural norms around composure and not burdening others make self-reporting unreliable. Proactive check-ins, normalising struggle, and creating safe private channels for disclosure are essential."]}],"citations":[{"author":"Tran et al.","year":2024,"title":"Academic stress among students in Vietnam: a three-year longitudinal study","doi":"PMC11442093"},{"author":"Tandfonline","year":2023,"title":"Changing teachers' beliefs and practices towards learner-centred education: experiences from Vietnam's education reforms","doi":"10.1080/25783858.2023.2177191"},{"author":"Hattie, J.","year":2009,"title":"Visible Learning: A Synthesis of Over 800 Meta-Analyses Relating to Achievement","doi":""}]}$$::jsonb)

ON CONFLICT (module_id, dimension_number) DO UPDATE SET
  title           = EXCLUDED.title,
  research_status = EXCLUDED.research_status,
  content         = EXCLUDED.content;

-- ── QUIZ QUESTIONS ────────────────────────────────────────────────────────────

INSERT INTO pd_quiz_questions (id, module_id, quiz_type, dimension_number, prompt, options, sort_order)
VALUES

  -- Checkpoint D1
  ('vietnam-d1-q1', 'vietnam-001', 'checkpoint', 1,
   'A hardworking, compliant student always completes assignments on time and takes meticulous notes, but never volunteers in class discussion and avoids open-ended tasks. What is the strongest first interpretation?',
   $$[
     {"id":"vietnam-d1-q1-a","text":"The student lacks confidence and would benefit from encouragement to participate more.","isCorrect":false,"feedback":"Too quick. This reads the behaviour through a Western confidence lens. The pattern described — visible diligence without intellectual risk-taking — is more consistent with obligation-driven study than personality-based reluctance.","explanation":"This reads the behaviour through a Western confidence lens and misses the filial piety motivation structure."},
     {"id":"vietnam-d1-q1-b","text":"The student is performing the study behaviours that filial piety demands — diligence and compliance — without necessarily being driven by curiosity or personal engagement.","isCorrect":true,"feedback":"Yes. The research on authoritarian filial piety in Vietnamese students shows this pattern: high visible effort driven by family obligation rather than intrinsic motivation. This student may also be carrying a depression risk that the compliance masks.","explanation":"Authoritarian filial piety produces visible diligence that can mask obligation-driven stress rather than genuine engagement."},
     {"id":"vietnam-d1-q1-c","text":"The student is probably performing well in tutoring classes and saving their energy for that context.","isCorrect":false,"feedback":"Possible but not the strongest first reading. While 92.1% of Vietnamese students attend extra classes, the behavioural pattern described points more directly to the filial piety motivation structure than to split academic loyalty.","explanation":"Tutoring is common but the described pattern maps more directly to filial obligation than split attention."},
     {"id":"vietnam-d1-q1-d","text":"The student is introverted and would perform better in written assessments than in class participation.","isCorrect":false,"feedback":"This personalises a culturally structured behaviour. The avoidance of open-ended tasks and class discussion is more likely a face-protection and obligation-performance pattern than a personality trait.","explanation":"Personalising culturally structured behaviour as introversion misses the systemic dynamic."}
   ]$$::jsonb,
   1),

  -- Checkpoint D2
  ('vietnam-d2-q1', 'vietnam-001', 'checkpoint', 2,
   'A parent says: "The school my child attended before gave three worksheets every night. Here there seems to be very little homework. How do I know the school is serious?" What is the strongest first interpretation?',
   $$[
     {"id":"vietnam-d2-q1-a","text":"The parent is resistant to IB pedagogy and prefers a traditional teaching model.","isCorrect":false,"feedback":"Too reductive. The parent is not making a pedagogical argument — they are using the only quality signal they have. Homework volume is a proxy for institutional seriousness in a system where 92.1% of students attend supplementary tutoring.","explanation":"The parent is not resisting IB — they are applying the only quality metric their educational experience provided."},
     {"id":"vietnam-d2-q1-b","text":"The parent is using homework volume as a quality marker because that is the only signal of institutional seriousness they have been trained to read.","isCorrect":true,"feedback":"Yes. In a system where structured academic output is the visible proof of quality education, the absence of homework reads as the absence of rigour — not as a different pedagogical approach. The response is to make your assessment model visible and legible, not to defend the philosophy.","explanation":"Homework volume is a quality proxy trained by the Vietnamese system. The response is to make your approach legible, not to defend a philosophy."},
     {"id":"vietnam-d2-q1-c","text":"The parent is comparing costs and wants to see more visible output to justify the higher fees.","isCorrect":false,"feedback":"Fee consciousness is real, but the concern runs deeper than value-for-money. The parent is asking whether this school produces the kind of academic seriousness that their community recognises.","explanation":"This underestimates the concern. The parent is asking about educational legitimacy, not cost-efficiency."},
     {"id":"vietnam-d2-q1-d","text":"The parent is anxious and needs reassurance that the school has high standards.","isCorrect":false,"feedback":"Partially right but too generic. The specific dynamic is that homework volume is a learned quality marker in Vietnamese education culture — the parent needs their quality framework translated, not their anxiety soothed.","explanation":"Reassurance addresses the symptom; translating the quality framework addresses the cause."}
   ]$$::jsonb,
   2),

  -- Checkpoint D3
  ('vietnam-d3-q1', 'vietnam-001', 'checkpoint', 3,
   'A student never asks a question in class and does not challenge ideas during discussion, but performs well on written assessments. A colleague says: "She clearly understands the material — she just needs to participate more." What does the research say about this pattern?',
   $$[
     {"id":"vietnam-d3-q1-a","text":"The colleague is right — the student understands but needs to build participation habits.","isCorrect":false,"feedback":"This treats silence as a skill deficit. In Confucian-heritage classroom culture, not asking questions and not challenging the teacher is not passive — it is an active performance of respect that protects both the student's and the teacher's face.","explanation":"Silence in a Confucian classroom is an active performance of respect, not a participation deficit."},
     {"id":"vietnam-d3-q1-b","text":"The student's silence is a culturally structured behaviour: asking questions or challenging ideas in class disrupts collective harmony and costs both parties face. The written performance confirms understanding; the silence confirms cultural navigation.","isCorrect":true,"feedback":"Yes. The student is demonstrating competence in two systems simultaneously: the written assessment (academic) and the classroom interaction (cultural). Pushing for more verbal participation without understanding why it feels risky will likely produce rehearsed compliance rather than genuine engagement.","explanation":"The student is navigating two competency systems — academic understanding (written) and cultural performance (classroom behaviour)."},
     {"id":"vietnam-d3-q1-c","text":"The student is probably doing most of her real learning in tutoring and treating school as a social environment.","isCorrect":false,"feedback":"The strong written performance contradicts this reading. The student is clearly learning effectively — the question is about why verbal participation looks different, not about whether learning is happening.","explanation":"Strong written performance directly contradicts the idea that learning is happening elsewhere."},
     {"id":"vietnam-d3-q1-d","text":"The student may have a language barrier that makes verbal participation more difficult than written work.","isCorrect":false,"feedback":"Worth considering but not the strongest first reading for a Vietnamese student in this context. The pattern of strong written work with absent verbal participation maps more directly to face-saving classroom norms than to language proficiency.","explanation":"Language barriers are worth checking but the described pattern maps more directly to Confucian face-saving norms."}
   ]$$::jsonb,
   3),

  -- Checkpoint D4
  ('vietnam-d4-q1', 'vietnam-001', 'checkpoint', 4,
   'A parent asks whether your school''s portfolio assessment is "equivalent to the national curriculum standard." What is the most useful way to hear this question?',
   $$[
     {"id":"vietnam-d4-q1-a","text":"The parent distrusts the IB and wants their child back in the national system.","isCorrect":false,"feedback":"Too adversarial. The parent chose this school. The question is not about leaving — it is about whether the school's assessment produces outcomes that are legible to the world the parent navigates.","explanation":"The parent chose this school. The question is about legibility, not about exit."},
     {"id":"vietnam-d4-q1-b","text":"The parent is asking for reassurance that the school is accredited.","isCorrect":false,"feedback":"Accreditation may be part of it, but the deeper question is about whether the school's assessment currency is recognised in the competitive arena the parent understands — university admissions, community reputation, employability.","explanation":"Accreditation is surface-level. The real question is about competitive legibility."},
     {"id":"vietnam-d4-q1-c","text":"The parent is requesting a translation: they need to understand what the portfolio assessment produces in terms they — and their community — can recognise as legitimate academic evidence.","isCorrect":true,"feedback":"Yes. This is the assessment translation problem. The parent is not rejecting your system — they are asking you to make it legible in the only frame they have. University outcomes data, structured criteria explanations, and explicit connections to recognised academic standards address the real question.","explanation":"The parent needs a translation from portfolio language into the competitive-outcome language their world uses."},
     {"id":"vietnam-d4-q1-d","text":"The parent is comparing your school unfavourably to a competitor and fishing for weaknesses.","isCorrect":false,"feedback":"This reads malicious intent into what is more likely genuine uncertainty. First-generation international school parents in Vietnam have fewer reference points than parents in more established international school markets.","explanation":"Reading malicious intent into genuine uncertainty misses the first-generation dynamic."}
   ]$$::jsonb,
   4),

  -- Checkpoint D5
  ('vietnam-d5-q1', 'vietnam-001', 'checkpoint', 5,
   'A student reveals that she attends a tutoring centre for maths and science three evenings a week alongside her international school day. A colleague says: "That means the parents don''t trust what we''re doing." What is the strongest first interpretation?',
   $$[
     {"id":"vietnam-d5-q1-a","text":"The colleague is probably right — the family is hedging against the school's approach.","isCorrect":false,"feedback":"This frames tutoring as a vote of no-confidence. In a context where 92.1% of students attend extra classes, the decision to enroll in tutoring is normative — not enrolling would feel like reducing investment.","explanation":"In a context where 92.1% attendance is the norm, tutoring is the default, not a signal of distrust."},
     {"id":"vietnam-d5-q1-b","text":"Tutoring is so normalised in Vietnamese education culture (92.1% participation) that the family is fulfilling a standard expectation, not expressing distrust of the school. The real concern is the student's total cognitive load.","isCorrect":true,"feedback":"Yes. The interpretive move is to shift from 'why are they doing this to us?' to 'what is this student carrying?' A student attending tutoring three evenings a week alongside a full school day is operating on a schedule that affects attention, creative capacity, and mental health.","explanation":"The diagnostic question is not 'do they trust us?' but 'what is this student's total load?' — and that load has documented mental health implications."},
     {"id":"vietnam-d5-q1-c","text":"The student is probably performing better in tutoring and may eventually transfer to a more traditional school.","isCorrect":false,"feedback":"This reads the situation as competitive when it is more likely complementary. Vietnamese families typically see tutoring as additional support, not as a replacement pathway.","explanation":"Vietnamese families typically see tutoring as complementary support, not a competing pathway."},
     {"id":"vietnam-d5-q1-d","text":"The parents may not be able to afford the tutoring long-term and should be advised to stop.","isCorrect":false,"feedback":"Advising a Vietnamese family to stop tutoring — particularly from a foreign teacher — risks being heard as the school telling parents they are investing too much in their child's education. This is culturally tone-deaf.","explanation":"Telling a Vietnamese family to reduce educational investment contradicts the filial piety framework and will be heard as dismissive."}
   ]$$::jsonb,
   5),

  -- Checkpoint D6
  ('vietnam-d6-q1', 'vietnam-001', 'checkpoint', 6,
   'A parent says: "Please always tell us what our child needs to improve. We do not need to hear what is going well — we can see that at home." A colleague responds: "That''s quite a negative approach to parenting." What does the research say?',
   $$[
     {"id":"vietnam-d6-q1-a","text":"The colleague is right to be concerned — focusing only on deficits can damage a child's self-esteem.","isCorrect":false,"feedback":"This applies a Western feedback model to a different cultural communication norm. Vietnamese parents are accustomed to hearing what needs to improve as the substantive content of educational feedback. Leading with positives can be read as the teacher avoiding the real conversation.","explanation":"Western feedback norms do not map directly onto Vietnamese educational communication culture."},
     {"id":"vietnam-d6-q1-b","text":"The parent is expressing a culturally normal Vietnamese feedback preference: improvement-focused communication is heard as serious engagement, not negativity. The teacher who leads with positives may actually be undermining trust.","isCorrect":true,"feedback":"Yes. Vietnamese educational culture treats developmental feedback as the serious, respectful part of the conversation. A parent who asks for improvement-focused communication is telling you how to build trust with them — listen to it.","explanation":"In Vietnamese feedback culture, improvement-focused communication signals seriousness and respect. Leading with positives can signal avoidance."},
     {"id":"vietnam-d6-q1-c","text":"The parent is probably anxious about the child's performance and needs data to feel reassured.","isCorrect":false,"feedback":"Partially true but misses the cultural layer. This is not anxiety-driven — it is a communication preference shaped by Vietnamese educational norms. The parent is not asking for reassurance; they are asking for the kind of feedback they consider useful.","explanation":"This is a communication preference, not anxiety. The parent is telling you what format of feedback they consider useful."},
     {"id":"vietnam-d6-q1-d","text":"The parent may be putting too much pressure on the child and the teacher should flag this with pastoral care.","isCorrect":false,"feedback":"Premature. The request for improvement-focused feedback is culturally normative in Vietnam and does not, by itself, indicate harmful parental pressure. Pathologising normal cultural communication risks damaging the parent-teacher relationship.","explanation":"Pathologising a culturally normal communication preference risks damaging the relationship without evidence of harm."}
   ]$$::jsonb,
   6),

  -- Final Exam Q1
  ('vietnam-final-q1', 'vietnam-001', 'final_exam', NULL,
   'A PTM goes smoothly. The parent is warm, grateful, and asks no challenging questions. The teacher feels confident the relationship is strong. Which of the following should the teacher still consider?',
   $$[
     {"id":"vietnam-final-q1-a","text":"Nothing — a smooth meeting with a grateful parent is a good sign that the relationship is working.","isCorrect":false,"feedback":"In Vietnamese communication culture, a smooth meeting is a necessary but insufficient signal. Face-saving norms mean that concerns are processed privately, often after the meeting, through family discussion or parent networks.","explanation":"A smooth meeting in a face-saving culture tells you the relationship is polite. It does not tell you the parent is satisfied."},
     {"id":"vietnam-final-q1-b","text":"The parent may have concerns they chose not to raise because doing so would cost face for both parties. The teacher should follow up with a written summary and an explicit invitation to share concerns privately.","isCorrect":true,"feedback":"Yes. The face dynamic in Vietnamese PTMs means the real assessment often happens after the meeting. A written follow-up with specific next steps and an explicit invitation to raise concerns in writing gives the parent a lower-cost channel for the feedback they withheld in person.","explanation":"Providing a lower-cost channel for feedback after the meeting accounts for the face dynamic and invites the real conversation."},
     {"id":"vietnam-final-q1-c","text":"The teacher should ask a direct question at the end of the meeting: 'Is there anything you are concerned about that we have not discussed?'","isCorrect":false,"feedback":"Well-intentioned but culturally counterproductive. A direct question about concerns in a face-to-face meeting creates exactly the social pressure that face-saving norms are designed to avoid. The parent is likely to say 'no, everything is fine' regardless.","explanation":"Direct questions about concerns in a face-to-face context replicate the exact social pressure that face-saving norms are designed to manage."},
     {"id":"vietnam-final-q1-d","text":"The teacher should check with colleagues whether this parent has raised concerns through other channels.","isCorrect":false,"feedback":"Not wrong as a practice, but this is reactive rather than proactive. The better move is to create a communication structure that makes it easier for the parent to raise concerns before they travel through indirect channels.","explanation":"Checking with colleagues is reactive. Creating accessible feedback channels is proactive."}
   ]$$::jsonb,
   1),

  -- Final Exam Q2
  ('vietnam-final-q2', 'vietnam-001', 'final_exam', NULL,
   'A Vietnamese parent asks: "How does my child compare to the class average on this IB assignment?" What is the most research-aligned first response?',
   $$[
     {"id":"vietnam-final-q2-a","text":"Explain that IB does not rank students and redirect to the rubric criteria.","isCorrect":false,"feedback":"Technically accurate but practically unhelpful. The parent is asking for comparative data in the only format they know. Redirecting to the rubric without first addressing the underlying question — 'is my child competitive?' — leaves the question unanswered.","explanation":"Redirecting to the rubric answers a question the parent did not ask. The real question is about competitive positioning."},
     {"id":"vietnam-final-q2-b","text":"Provide a brief, honest assessment of the child's performance against the criteria, connect it to university outcomes ('students performing at this level are well-positioned for...'), and then explain what the rubric measures and how it connects to those outcomes.","isCorrect":true,"feedback":"Yes. This answers the competitive question first (using university outcomes as the legible frame), then explains the assessment system. The French academic tradition in urban Vietnam provides an additional bridge: framing portfolio work as rigorous structured argument rather than creative expression helps the assessment feel academically serious.","explanation":"Answer the competitive question first with outcome data, then explain the system. This respects the parent's actual information need."},
     {"id":"vietnam-final-q2-c","text":"Share the class average to build trust, then explain the limitations of averages.","isCorrect":false,"feedback":"Sharing class averages may seem practical but creates an expectation of ongoing comparative data that the school cannot sustain without rebuilding ranking culture. The better approach is to answer the competitive question through university outcomes rather than peer comparison.","explanation":"Sharing class averages sets an unsustainable precedent. University outcomes data addresses the same need without creating a ranking expectation."},
     {"id":"vietnam-final-q2-d","text":"Ask the parent why they want to compare — understanding their motivation will help you respond better.","isCorrect":false,"feedback":"This reverses the power dynamic inappropriately. The parent's motivation is clear from the cultural context: they need comparative data to assess whether the investment is working. Asking them to justify the question can feel interrogative.","explanation":"The parent's motivation is culturally legible. Asking them to justify it can feel like the teacher is questioning their right to the information."}
   ]$$::jsonb,
   2),

  -- Final Exam Q3
  ('vietnam-final-q3', 'vietnam-001', 'final_exam', NULL,
   'A student shows signs of high stress — difficulty sleeping, perfectionism about assignments, reluctance to submit work that is not flawless — alongside consistently high academic performance. A colleague says: "She is just a perfectionist — high achievers are like that." What is the most useful frame for understanding this pattern?',
   $$[
     {"id":"vietnam-final-q3-a","text":"The colleague is probably right — some students are naturally perfectionistic and it usually resolves with maturity.","isCorrect":false,"feedback":"This normalises a pattern that the research identifies as a risk indicator. In the Vietnamese context, perfectionism combined with high stress and high performance is consistent with authoritarian filial piety — obligation-driven study that is negatively associated with actual achievement and positively associated with depressive symptoms.","explanation":"Normalising this pattern misses a documented risk indicator. The research connects it to obligation-driven study and depression."},
     {"id":"vietnam-final-q3-b","text":"The student may be operating under authoritarian filial piety — studying out of obligation to repay parental sacrifice rather than intrinsic motivation. This pattern is documented as a risk factor for depression in Vietnamese students, and the high performance is masking, not resolving, the underlying stress.","isCorrect":true,"feedback":"Yes. The 2020 Frontiers study found that authoritarian filial piety is negatively associated with academic achievement and positively associated with depressive symptoms. The 27% depression rate in Hanoi secondary students provides background context. This student needs proactive pastoral attention, not reassurance that perfectionism is normal.","explanation":"Authoritarian filial piety combined with high stress is a documented depression risk factor. The high performance masks rather than resolves the problem."},
     {"id":"vietnam-final-q3-c","text":"The student needs better time management skills and study-life balance support.","isCorrect":false,"feedback":"Study skills are not the issue. The student is performing well academically. The stress is coming from the motivational structure — obligation, family honour, fear of disappointing — not from poor organisation. Addressing study skills treats the symptom while missing the cause.","explanation":"The student's time management is clearly functional given high performance. The stress source is motivational and cultural, not organisational."},
     {"id":"vietnam-final-q3-d","text":"The teacher should contact the parents to discuss reducing academic pressure at home.","isCorrect":false,"feedback":"Risky without careful framing. Telling Vietnamese parents that they are creating too much pressure can be heard as the school criticising the family's values. The better approach is to work with the family — framing the concern as 'we want to support your child's long-term success, including wellbeing' rather than 'you are causing the problem.'","explanation":"Framing the conversation as parental criticism risks the relationship. Working within the family honour frame is more effective."}
   ]$$::jsonb,
   3)

ON CONFLICT (id) DO UPDATE SET
  prompt  = EXCLUDED.prompt,
  options = EXCLUDED.options;

-- ── SIMULATIONS ──────────────────────────────────────────────────────────────

-- Simulation A: The Quiet Meeting
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'b2c3d4e5-0004-0001-0001-000000000001',
  'vietnam-001',
  'The Quiet Meeting',
  'A parent-teacher conference where everything seems fine — the parent is warm, grateful, and asks no challenging questions. Three weeks later, a request arrives through a relative who works at the school, asking whether the student can take supplementary standardised tests. The teacher must understand what happened in the meeting and what the request actually means.',
  'It is mid-October at Lotus International School in Ho Chi Minh City. You teach Year 8 English and Humanities. Your class has just completed its first IB MYP interdisciplinary unit — a research project on urban development that combined English writing skills with Geography concepts. Students presented their findings to parents at an exhibition evening last week.

Minh is a strong student. His written English is excellent, his research was thorough, and his presentation was confident. His mother, Mrs. Nguyen, attended the exhibition and seemed genuinely impressed. She thanked you warmly and said the school was doing wonderful things.

Today is the scheduled PTM. Mrs. Nguyen arrives on time, well-dressed, and carrying a small gift — a box of mooncakes. She greets you with a warm smile.

"Teacher, thank you so much for everything you are doing for Minh. The exhibition was beautiful. He is so happy at this school."

She asks polite questions about Minh''s progress, nods at your responses, and expresses gratitude several times. She does not raise any concerns. The meeting lasts fifteen minutes and feels entirely positive.

Three weeks later, Ms. Tran from the school office mentions that Mrs. Nguyen''s sister-in-law — who works in the school''s finance department — has passed along a question: "Is there a way for Minh to take a standardised test so the family can see where he stands compared to other students at his level?"',
  '[
    {"name":"You","role":"Year 8 English/Humanities teacher at Lotus International School, HCMC","description":"You trained overseas and have been teaching at Lotus for two years. You believe in inquiry-based learning and narrative feedback. You thought Mrs. Nguyen was one of your most supportive parents."},
    {"name":"Mrs. Nguyen","role":"Mother of Minh","description":"She runs a small import-export business. She and her husband are investing a significant portion of their income in Minh''s international school fees. She is the first in her extended family to send a child to an international school. She is warm, respectful, and deeply invested in Minh''s education."},
    {"name":"Ms. Tran","role":"School finance department colleague","description":"She is Mrs. Nguyen''s sister-in-law. She is passing along the family''s question informally, not as a formal complaint."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "It is mid-October at Lotus International School in Ho Chi Minh City. You teach Year 8 English and Humanities.",
        "Your class has just completed its first IB MYP interdisciplinary unit — a research project on urban development. Students presented their findings at an exhibition evening last week.",
        "Minh is a strong student. His written English is excellent, his research was thorough, and his presentation was confident. His mother, Mrs. Nguyen, attended the exhibition and seemed genuinely impressed.",
        "Today is the scheduled PTM. Mrs. Nguyen arrives with a warm smile and a box of mooncakes.",
        "\"Teacher, thank you so much for everything you are doing for Minh. The exhibition was beautiful. He is so happy at this school.\"",
        "She asks polite questions, nods at your responses, and expresses gratitude several times. She does not raise any concerns. The meeting feels entirely positive.",
        "Three weeks later, Ms. Tran from the finance department mentions that Mrs. Nguyen''s sister-in-law has passed along a question: \"Is there a way for Minh to take a standardised test so the family can see where he stands compared to other students?\""
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Indirect Request",
      "content": ["The request has arrived through a family connection inside the school, not through a formal channel or direct conversation with you. How do you respond?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Treat it as informal and wait for a direct request",
          "text": "\"I appreciate Ms. Tran mentioning it, but I think I should wait for Mrs. Nguyen to raise this with me directly before acting on it.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Contact Mrs. Nguyen directly to discuss the request",
          "text": "You email Mrs. Nguyen: \"I understand you may have some questions about how we track Minh''s progress. I would love to have a conversation about this — would you be available for a quick call or meeting?\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Respond through the same indirect channel",
          "text": "You ask Ms. Tran to let the family know that you would be happy to provide a more detailed academic summary of Minh''s progress against IB criteria, and that you can meet to walk through it together.",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Nguyen does not raise the request directly. The indirect channel was the request.",
        "Two months later, you learn from a colleague that Minh has been enrolled in weekend test-preparation classes at a local tutoring centre. His workload has visibly increased. His written work, once careful and creative, has become more formulaic — optimised for speed rather than depth.",
        "Mrs. Nguyen continues to be warm and grateful at school events. Nothing has changed on the surface. But underneath, the family has quietly created a parallel assessment system because the school''s system did not give them what they needed."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Nguyen replies politely but seems slightly startled. She did not expect the request to reach you so directly.",
        "\"Oh, it was just a small question,\" she says. \"Please do not worry about it. Minh is doing very well.\"",
        "The conversation has been shut down. By addressing the request head-on, you accidentally raised the stakes of what was intended as a low-cost, face-preserving inquiry. Mrs. Nguyen now feels exposed — her indirect question was made direct, and she retreated.",
        "The concern has not gone away. It has simply moved further underground."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Ms. Tran passes the message along. A few days later, Mrs. Nguyen sends you a polite email: \"Thank you, Teacher. That would be very helpful. We just want to understand clearly how Minh is doing.\"",
        "You prepare a detailed summary of Minh''s performance across MYP criteria, with specific examples from his recent work and a clear explanation of what each level means in terms of university readiness.",
        "Mrs. Nguyen responds warmly. She asks one follow-up question: \"Is there a way to see how this compares to what students at his level typically achieve?\" The underlying question — comparative positioning — is still there. But the channel is now open, the tone is collaborative, and you can address it directly."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective: Mrs. Nguyen''s View",
      "content": [
        "Mrs. Nguyen is not being evasive or manipulative. She is communicating through the channel that feels safest.",
        "In Vietnamese communication culture, raising a concern directly with a teacher risks creating an uncomfortable situation for both parties. The indirect channel — through a family connection at the school — allows the question to be asked without anyone losing face.",
        "The warmth in the PTM was genuine. Mrs. Nguyen truly is grateful. But gratitude and concern coexist. She can appreciate the school and still worry about whether the assessment system is producing outcomes her extended family will recognise as legitimate.",
        "As a first-generation international school parent, she has no older sibling or cousin to ask: ''Is this normal? Is my child really doing well?'' The standardised test request is not distrust — it is a search for legible proof in a system she is still learning to read."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What did you assume about the PTM when it ended?",
      "options": [
        "I thought the meeting went well and the relationship was strong.",
        "I noticed she did not ask challenging questions but assumed she was satisfied.",
        "I suspected there might be unspoken concerns but was not sure how to surface them.",
        "I did not consider that the warm meeting and the later request could be connected.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Assessment Question",
      "content": [
        "You now have a meeting scheduled with Mrs. Nguyen to walk through Minh''s academic progress.",
        "You know she wants comparative data. Your school does not rank students. The IB MYP uses criterion-referenced assessment, not norm-referenced.",
        "But you also know that Minh is genuinely performing well — he would be in the top third of most Year 8 cohorts internationally.",
        "How do you prepare for this meeting?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Explain the MYP criteria system and why ranking is not part of it",
          "text": "You prepare a clear explanation of how MYP criteria work, what each level means, and why the school uses criterion-referenced rather than norm-referenced assessment. You want to educate her about the system.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Lead with outcomes and connect criteria to university readiness",
          "text": "You prepare university placement data for graduates of your school. You show Minh''s performance against each criterion with specific examples of his work, and you connect each level to what it means for future university readiness: ''Students performing at Minh''s level are well-positioned for competitive university programmes.''",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Create an unofficial benchmark comparison",
          "text": "You prepare a summary that informally contextualises Minh''s performance: ''Among students at this stage of MYP internationally, Minh''s performance is strong.'' You are careful not to rank him within the class but you give her the comparative frame she is looking for.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Nguyen listens carefully and nods throughout your explanation.",
        "At the end, she thanks you. Then she asks: \"So... is he doing well?\"",
        "You realise that the entire explanation answered a question she did not ask. She wanted to know whether Minh is competitive. You explained how the scoring system works.",
        "The meeting ends politely. Mrs. Nguyen is no better informed about the question that actually matters to her."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Mrs. Nguyen leans forward when you show the university data.",
        "\"So students at Minh''s level — they go to universities like this?\" She points to several names on the list.",
        "\"Yes,\" you say. \"And Minh is performing at or above the level where our graduates have been successful in these programmes.\"",
        "For the first time, the concern relaxes. She has heard the answer to her actual question — not in percentage terms, but in outcome terms that she can report to her family with confidence.",
        "She asks whether you can share this kind of update once per term. You agree. The relationship has moved from warm-but-anxious to informed-and-collaborative."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "Mrs. Nguyen is clearly relieved. \"Thank you, Teacher. This is exactly what I needed to know.\"",
        "The meeting goes well. But two weeks later, your MYP coordinator stops by your classroom.",
        "\"A parent mentioned receiving some comparative benchmarking from you. I understand the intention, but we need to be careful — if one family gets this, others will expect it, and we risk recreating a ranking system informally.\"",
        "You are now in the same position as if you had given Mrs. Rao in India an unofficial percentage conversion. The short-term trust gain has created a long-term institutional problem."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective: What the Request Actually Means",
      "content": [
        "The request for comparative data is not about distrust. It is about legibility.",
        "Mrs. Nguyen''s extended family will ask about Minh''s progress at Tet. Her husband''s colleagues will mention their children''s scores. Her neighbours know she is paying international school fees and will want to know whether it is ''working.''",
        "In all of these conversations, the currency is comparative positioning. Without it, Mrs. Nguyen cannot answer the social question her community is asking.",
        "The most effective teacher response is to give her a different kind of comparative data — university outcomes, programme trajectories, skill benchmarks — that she can use in those conversations without requiring the school to rank students against each other."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What question was Mrs. Nguyen actually asking?",
      "options": [
        "How does MYP assessment work?",
        "Is my child performing well enough that I can tell my family this investment is working?",
        "Does this school produce outcomes I can recognise?",
        "Can I trust you to be honest with me about my child?",
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
            "This simulation exercised two of the most common misreadings in Vietnamese international school contexts.",
            "The Smooth Meeting: Vietnamese communication culture, structured by face (thể diện), produces PTMs that feel warmer and more resolved than they are. A parent who is genuinely grateful and simultaneously concerned will express the gratitude in the meeting and process the concern privately. The teacher who reads the warm meeting as a resolved relationship misses the gap.",
            "The Indirect Channel: Concerns in Vietnamese culture often travel through intermediaries rather than direct confrontation. A request that arrives through a family connection is not gossip or boundary violation — it is the culturally appropriate way to raise a concern without creating an uncomfortable direct encounter. Treating it as informal and waiting for a direct request may mean waiting forever.",
            "The Assessment Translation: The request for standardised test data is a request for legible proof. First-generation international school parents in Vietnam have fewer reference points for what IB performance means in the competitive arena they navigate. University outcomes data — not assessment philosophy — is the bridge."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Tran et al. (2024). Academic stress among students in Vietnam: a three-year longitudinal study. PMC11442093.",
            "Frontiers in Psychology (2020). The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison.",
            "Tandfonline (2023). Changing teachers'' beliefs and practices towards learner-centred education: experiences from Vietnam''s education reforms.",
            "WENR (2017). Education in Vietnam."
          ]
        }
      ],
      "finalPrompt": "If you could go back to the original PTM with Mrs. Nguyen — before she channelled her question through Ms. Tran — what would you do differently in the meeting itself to make it easier for her to raise the question she was actually carrying?"
    }
  }'::jsonb,
  ARRAY[1, 4],
  20,
  1,
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

-- Simulation C: The Tutor Question
INSERT INTO public.pd_simulations (
  id, module_id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status
) VALUES (
  'b2c3d4e5-0004-0001-0003-000000000003',
  'vietnam-001',
  'The Tutor Question',
  'A parent reveals that their child attends a tutoring centre three evenings a week alongside international school. They ask whether this is a problem — revealing a disconnect about what learning looks like and what counts as sufficient investment in education.',
  'It is January at Lotus International School. You teach Year 10 Sciences. Duc is a solid student — not exceptional, but consistent. He submits work on time, follows instructions carefully, and produces competent lab reports. He rarely contributes to class discussions voluntarily.

During a routine check-in with parents about subject selection for the IB Diploma Programme, Mrs. Pham mentions casually: "Duc is also attending Mr. Long''s tutoring centre on Monday, Wednesday, and Friday evenings for mathematics and science. It has been very helpful. But I wanted to ask you — is this a problem for the school? Some parents said the school might not like it."

You were not aware of the tutoring. Looking at Duc''s recent performance, several things click: his lab reports have become more formulaic over the past term. His answers on tests are technically correct but lack the explanatory depth your rubric rewards. In group discussions, he waits for others to take risks and then confirms the safe answer.

Mrs. Pham is watching your face carefully. She is genuinely asking — not challenging. She wants to know whether the school and the tutoring can coexist.',
  '[
    {"name":"You","role":"Year 10 Sciences teacher at Lotus International School","description":"You have been teaching IB Sciences for four years. You value inquiry-based learning and want students to explain their reasoning, not just produce correct answers."},
    {"name":"Duc","role":"Year 10 student","description":"He is consistent and conscientious. He has attended tutoring for two years. His father is an accountant; his mother runs a small business. He is the eldest of two children and carries visible responsibility for his academic outcomes."},
    {"name":"Mrs. Pham","role":"Duc''s mother","description":"She is practical, warm, and slightly nervous in school settings. She completed secondary school in the Vietnamese national system and did not attend university. She is investing significantly in both the international school fees and the tutoring fees."}
  ]'::jsonb,
  '{
    "setup": {
      "id": "setup",
      "type": "setup",
      "title": "Setup",
      "content": [
        "It is January at Lotus International School. You teach Year 10 Sciences.",
        "During a routine parent check-in, Mrs. Pham mentions that Duc attends tutoring three evenings a week for maths and science.",
        "\"Is this a problem for the school?\" she asks. \"Some parents said the school might not like it.\"",
        "You notice that Duc''s recent work has become more formulaic — technically correct but lacking the explanatory depth your rubric rewards.",
        "Mrs. Pham is watching your face carefully. She is genuinely asking, not challenging."
      ],
      "next": "dilemma_1"
    },
    "dilemma_1": {
      "id": "dilemma_1",
      "type": "dilemma",
      "title": "Dilemma 1: The Initial Response",
      "content": ["How do you respond to Mrs. Pham''s question about the tutoring?"],
      "choices": [
        {
          "id": "choice_1a",
          "label": "Reassure her that tutoring is fine",
          "text": "\"Not at all — many families use tutoring alongside the school. As long as Duc is managing his workload, there is no problem.\"",
          "next": "consequence_1a"
        },
        {
          "id": "choice_1b",
          "label": "Express concern about the tutoring''s impact on Duc''s learning",
          "text": "\"I appreciate you telling me. I have noticed that Duc''s work has become more formulaic recently — technically correct but without the depth our assessments reward. I wonder if the tutoring method might be teaching him to produce answers rather than explanations.\"",
          "next": "consequence_1b"
        },
        {
          "id": "choice_1c",
          "label": "Acknowledge the tutoring and reframe the conversation around Duc''s IB preparation",
          "text": "\"Thank you for sharing this, Mrs. Pham. Tutoring is very normal and I understand why families invest in it. Let me show you what our IB assessments actually test, because it is slightly different from what tutoring typically prepares for — and I want to make sure Duc is getting the best from both.\"",
          "next": "consequence_1c"
        }
      ]
    },
    "consequence_1a": {
      "id": "consequence_1a",
      "type": "consequence",
      "title": "Consequence 1A",
      "content": [
        "Mrs. Pham looks relieved. \"Good. We were worried.\"",
        "The conversation moves on. But you have missed the diagnostic opportunity.",
        "Over the next term, Duc''s pattern deepens. His test answers become more efficiently correct and less explanatorily rich. His Internal Assessment proposal is technically sound but conceptually shallow. He is optimising for the tutoring model — structured recall — while your assessment rewards something different.",
        "By the time you raise it at the next conference, the pattern is harder to shift."
      ],
      "next": "perspective_1"
    },
    "consequence_1b": {
      "id": "consequence_1b",
      "type": "consequence",
      "title": "Consequence 1B",
      "content": [
        "Mrs. Pham''s expression tightens.",
        "\"Mr. Long is a very experienced teacher,\" she says carefully. \"Many families use him. Are you saying we should stop?\"",
        "You have accidentally set up a competition between yourself and the tutor — and in Mrs. Pham''s world, the tutor is a known quantity with community validation. You are a foreign teacher at an expensive school suggesting that the family''s additional investment might be harmful.",
        "The conversation becomes defensive. Mrs. Pham leaves politely but you sense the trust has narrowed."
      ],
      "next": "perspective_1"
    },
    "consequence_1c": {
      "id": "consequence_1c",
      "type": "consequence",
      "title": "Consequence 1C",
      "content": [
        "Mrs. Pham nods slowly. \"Please — show me.\"",
        "You pull up a recent lab report from Duc. You show her the rubric: ''This criterion rewards correct methodology. Duc scores well here. This criterion rewards explaining why the method works and what the limitations are. This is where Duc has room to grow.''",
        "\"So the tutoring helps with the first part but not the second?\" she asks.",
        "\"Exactly. The tutoring is giving him a strong foundation. What we are adding at school is the ability to use that foundation to think through problems he has not seen before. Both matter.\"",
        "Mrs. Pham asks whether there is something she can encourage at home. You suggest: ''When Duc tells you about a science concept, ask him why it works, not just what it is.'' She writes this down.",
        "The relationship has strengthened. You have validated her investment while expanding her understanding of what the school adds."
      ],
      "next": "perspective_1"
    },
    "perspective_1": {
      "id": "perspective_1",
      "type": "perspective",
      "title": "Perspective: Mrs. Pham''s View",
      "content": [
        "Mrs. Pham did not attend university. Her husband completed a Vietnamese national university programme. They are investing in Duc''s international education because they believe it will open doors they did not have.",
        "The tutoring is not a vote of no-confidence in the school. It is standard practice — 92.1% of Vietnamese students attend extra classes. For Mrs. Pham, stopping tutoring would feel like reducing investment in her son''s future, which would be a failure of parental duty in the filial piety framework.",
        "Her question — ''Is this a problem?'' — was genuine. She has heard from other parents that international schools sometimes disapprove of tutoring. She is trying to navigate two systems that may have different expectations, and she does not want to get it wrong.",
        "The most helpful teacher response validates the family''s investment logic while helping them understand what the school adds that the tutoring does not. This is not about choosing one system over the other — it is about making both work together."
      ],
      "next": "reflection_1"
    },
    "reflection_1": {
      "id": "reflection_1",
      "type": "reflection",
      "title": "Reflection 1",
      "prompt": "What was your first instinct when Mrs. Pham mentioned the tutoring?",
      "options": [
        "I wanted to reassure her so the conversation would not become awkward.",
        "I was concerned that the tutoring was undermining my teaching.",
        "I was curious about how the tutoring was affecting Duc''s learning.",
        "I felt defensive — as if the tutoring implied my teaching was not enough.",
        "Write your own."
      ],
      "next": "dilemma_2"
    },
    "dilemma_2": {
      "id": "dilemma_2",
      "type": "dilemma",
      "title": "Dilemma 2: The Workload Question",
      "content": [
        "A week later, you check in with Duc privately during a lab session.",
        "\"How is everything going? I know you have a busy schedule with tutoring in the evenings.\"",
        "Duc pauses. \"It is fine, Teacher. I am used to it.\"",
        "You notice he looks tired. His eyes are red. He has been less focused in morning classes over the past month.",
        "\"Duc — honestly, how are you sleeping?\"",
        "He looks down. \"I usually finish my tutoring homework around 11. Then I do school homework. I sleep around midnight or 12:30. But it is okay. My parents work very hard for me. I cannot waste their investment.\"",
        "What do you do with this information?"
      ],
      "choices": [
        {
          "id": "choice_2a",
          "label": "Raise it with Mrs. Pham immediately",
          "text": "You contact Mrs. Pham to express concern about Duc''s sleep and workload, suggesting that the tutoring schedule may need adjustment.",
          "next": "consequence_2a"
        },
        {
          "id": "choice_2b",
          "label": "Refer to pastoral care and let them handle the family conversation",
          "text": "You flag the conversation with your pastoral lead, sharing Duc''s words about not wasting his parents'' investment and his sleep schedule. You ask them to follow up.",
          "next": "consequence_2b"
        },
        {
          "id": "choice_2c",
          "label": "Work with Duc first, then bring the family in",
          "text": "You talk to Duc about managing his time between the two systems. You help him identify which tutoring work overlaps with school content so he can reduce duplication. Then you contact Mrs. Pham with a specific, practical suggestion rather than a general concern.",
          "next": "consequence_2c"
        }
      ]
    },
    "consequence_2a": {
      "id": "consequence_2a",
      "type": "consequence",
      "title": "Consequence 2A",
      "content": [
        "Mrs. Pham is quiet on the phone.",
        "\"We appreciate your concern, Teacher. But Duc has always been this way. Vietnamese students work hard. This is normal.\"",
        "She is not dismissing you. She is telling you that what you see as concerning is, in her experience, the standard level of effort expected from a serious student. The 92.1% tutoring rate is not an abstraction — it is Mrs. Pham''s neighbourhood.",
        "You have expressed the concern. But the framing — ''your child is overworked'' — has been received as a foreign teacher not understanding how Vietnamese families approach education."
      ],
      "next": "perspective_2"
    },
    "consequence_2b": {
      "id": "consequence_2b",
      "type": "consequence",
      "title": "Consequence 2B",
      "content": [
        "Your pastoral lead follows up. They are experienced with Vietnamese families and frame the conversation carefully: ''We want to support Duc''s long-term success, including his health. Here is what we''ve observed, and here is what the research says about sleep and academic performance.''",
        "Mrs. Pham is more receptive to this framing. The pastoral lead provides specific data: ''Students who sleep less than 7 hours perform measurably worse on the kind of complex reasoning IB assessments require.''",
        "This connects the concern to the outcome Mrs. Pham cares about — academic performance — rather than framing it as a lifestyle critique."
      ],
      "next": "perspective_2"
    },
    "consequence_2c": {
      "id": "consequence_2c",
      "type": "consequence",
      "title": "Consequence 2C",
      "content": [
        "You sit with Duc and map out his weekly schedule. Together, you identify three hours of overlap where the tutoring is covering material he has already learned in school.",
        "You contact Mrs. Pham: ''I have been working with Duc on his study schedule. He is doing well, but I noticed some overlap between his tutoring content and what we cover in class. If we can reduce the duplication, he can use that time for the deeper analysis work that IB assessments reward — and get more sleep.''",
        "Mrs. Pham asks: ''Will this affect his results?''",
        "You show her the specific areas where Duc''s IB performance would improve with more sleep and more time for explanatory thinking. She agrees to discuss the schedule with Mr. Long.",
        "The change is modest — one fewer evening, one more hour of sleep — but it came through collaboration rather than criticism."
      ],
      "next": "perspective_2"
    },
    "perspective_2": {
      "id": "perspective_2",
      "type": "perspective",
      "title": "Perspective: What Duc Is Carrying",
      "content": [
        "Duc''s statement — ''My parents work very hard for me. I cannot waste their investment'' — is a textbook expression of authoritarian filial piety.",
        "He is not describing pressure from an external source. He has internalised the family''s sacrifice as a debt he must repay through academic effort. Every hour of study is a moral act. Every hour of rest feels like a betrayal of his parents'' investment.",
        "The research is clear: this dynamic is negatively associated with academic achievement and positively associated with depressive symptoms. The student who appears most dedicated may be the one most at risk.",
        "The 27% depression rate in Vietnamese secondary students is not an abstraction. Duc is a real version of that statistic — high-functioning, compliant, visibly hardworking, and quietly carrying a load that is eroding his capacity for the kind of learning the IB actually rewards."
      ],
      "next": "reflection_2"
    },
    "reflection_2": {
      "id": "reflection_2",
      "type": "reflection",
      "title": "Reflection 2",
      "prompt": "What is the most important thing you want to carry forward from this conversation?",
      "options": [
        "The tutoring is not the problem — the total load is.",
        "I need to know my students'' full schedules, not just their school schedules.",
        "Telling a Vietnamese family to reduce investment is heard differently than I intend it.",
        "The student who says ''I cannot waste my parents'' investment'' is telling me something about their mental health, not just their motivation.",
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
            "This simulation exercised the tutoring dynamic that is nearly universal in Vietnamese education.",
            "The Normalisation of Tutoring: 92.1% of Vietnamese students attend extra classes. For a family like the Phams, enrolling Duc in tutoring is not a critique of the school — it is the minimum expected investment in a serious education. Stopping tutoring would feel like reducing parental commitment.",
            "The Method Conflict: Tutoring centres in Vietnam typically teach structured recall and exam technique. IB assessment rewards explanatory depth, application to novel contexts, and analytical reasoning. The two systems produce different kinds of competence, and students caught between them often default to the tutoring model because it feels safer and more concrete.",
            "The Filial Piety Load: Duc''s statement about not wasting his parents'' investment reveals the internalised obligation dynamic that the research documents. This is not external pressure being applied to a resistant student — it is a moral framework the student has accepted as reality. The risk is not overwork; it is the depression and disengagement that the research associates with authoritarian filial piety."
          ]
        },
        {
          "title": "Research Anchors",
          "content": [
            "Tran et al. (2024). Academic stress among students in Vietnam: a three-year longitudinal study. PMC11442093.",
            "Frontiers in Psychology (2020). The Implications of Filial Piety in Study Engagement and Study Satisfaction: A Polish-Vietnamese Comparison.",
            "PMC (2024). The interdependence of happiness and filial piety within the family: a study in Vietnam. PMC11016942."
          ]
        }
      ],
      "finalPrompt": "Think about your current students. How many of them are attending tutoring alongside your school? What do you know about their total weekly cognitive load? And what would change in your teaching if you knew?"
    }
  }'::jsonb,
  ARRAY[2, 5, 6],
  20,
  3,
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
