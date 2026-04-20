import { createClient } from '@supabase/supabase-js'

// Add your Supabase project URL and anon key to a .env file:
//   VITE_SUPABASE_URL=https://xxxx.supabase.co
//   VITE_SUPABASE_ANON_KEY=your-anon-key

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY
const MOCK_MODE   = !supabaseUrl

export const supabase = createClient(supabaseUrl ?? 'http://localhost', supabaseKey ?? 'anon')

const wait = ms => new Promise(resolve => setTimeout(resolve, ms))

// ---------- Mock fallbacks ----------

const MOCK_PD_MODULES = {
  'india-001': {
    id: 'india-001', country_code: 'IN', title: 'India',
    tagline: 'CBSE, board exams, percentage culture, and what IB looks like from that world.',
    preamble_md: 'Parent questions about marks, rank, and proof of progress are often trust-seeking moves, not resistance to inquiry.',
    status: 'live',
  },
  'ksa-001': {
    id: 'ksa-001', country_code: 'SA', title: 'Saudi Arabia',
    tagline: 'Tawjihiyya, family expectations, and navigating IB in a Gulf context.',
    preamble_md: 'Use this guide to separate surface objections from deeper concerns about language, family authority, religious continuity, and future opportunity.',
    status: 'live',
  },
  'korea-001': {
    id: 'korea-001', country_code: 'KR', title: 'South Korea',
    tagline: 'Suneung pressure, class rankings, and the Korean parent relationship with teacher authority.',
    preamble_md: 'Korean families may value international learning and still expect precision, effort, ranking literacy, and teacher responsibility.',
    status: 'live',
  },
  'china-001': {
    id: 'china-001', country_code: 'CN', title: 'China',
    tagline: 'Gaokao culture and what "no ranking" means to a Chinese parent.',
    preamble_md: 'This module frames practice, fluency, parental help, and quiet participation as culturally meaningful signals.',
    status: 'live',
  },
  'woodstock-001': {
    id: 'woodstock-001', country_code: 'IN', title: 'Woodstock Curriculum Transition',
    tagline: 'IGCSE, AP, and WSD - the transition explained for every cohort.',
    preamble_md: 'This module is a parent-facing guide to the IGCSE / AP / WSD pathway.',
    status: 'live',
  },
}

function mockDimensionsForModuleView(moduleId) {
  const mod = MOCK_PD_MODULES[moduleId] ?? { title: 'Mock module' }
  return Array.from({ length: 6 }, (_, idx) => ({
    id: `mock-${moduleId}-dimension-${idx + 1}`,
    module_id: moduleId,
    dimension_number: idx + 1,
    title: `${mod.title} lens ${idx + 1}`,
    research_status: idx < 4 ? 'fully_sourced' : idx === 4 ? 'partial' : 'community',
    content: {
      summary: `A mock dimension summary for ${mod.title}. Keeps the learner view visible in MOCK_MODE while Supabase content is unavailable.`,
      sections: [
        { heading: 'Teacher move', items: ['Pause before interpreting parent concern as resistance.', 'Name the educational purpose in language the family can trust.'] },
      ],
    },
  }))
}

function mockQuizQuestionsForModule(moduleId) {
  const checkpoints = mockDimensionsForModuleView(moduleId).map(dim => ({
    id: `${moduleId}-mock-d${dim.dimension_number}-q1`,
    module_id: moduleId,
    quiz_type: 'checkpoint',
    sort_order: dim.dimension_number,
    dimension_number: dim.dimension_number,
    prompt: `What is the strongest first move for ${dim.title}?`,
    options: [
      { id: 'a', text: 'Assume the family rejects international education.',                            isCorrect: false, feedback: 'That is too reductive.' },
      { id: 'b', text: 'Ask what concern or prior expectation sits underneath the question.',          isCorrect: true,  feedback: 'Correct. Start by interpreting the concern before responding.' },
      { id: 'c', text: 'Explain that IB practice is already globally accepted.',                        isCorrect: false, feedback: 'That may be true, but it can skip the trust issue.' },
      { id: 'd', text: 'Move the conversation quickly back to policy.',                                 isCorrect: false, feedback: 'Policy may matter later, but it is rarely the best first move.' },
    ],
  }))

  const finals = MOCK_FINAL_EXAMS[moduleId] ?? []
  return [...checkpoints, ...finals]
}

// -----------------------------------------------------------
// Final exam banks - 10 questions per live module, each tagged with
// a research anchor so the exam functions as recall + frame-sharpening
// rather than a compliance quiz.
// -----------------------------------------------------------
const MOCK_FINAL_EXAMS = {
  'india-001': [
    {
      id: 'india-final-q1', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 1, dimension_number: 1,
      prompt: 'A parent asks at the November PTM: "I appreciate the exhibition, but where does my child actually stand compared to peers?" What does the research say is the strongest first response?',
      research_anchor: 'Hattie (2009) - feedback effect sizes increase when paired with explicit mastery criteria',
      options: [
        { id: 'a', text: 'Explain that rankings are pedagogically outdated.',                                                                         isCorrect: false, feedback: 'This skips the trust signal underneath the question and can sound dismissive of the parent\'s frame.' },
        { id: 'b', text: 'Offer a concrete mastery statement ("can construct argument X, developing at Y") plus an invitation to see the rubric.',     isCorrect: true,  feedback: 'Correct. Hattie shows feedback works best when tied to visible criteria - this gives the parent a version of "standing" they can act on.' },
        { id: 'c', text: 'Provide a percentile band against the IB cohort to reassure them.',                                                          isCorrect: false, feedback: 'This tells the parent what they asked for, but reinforces that rank is the only legible unit - the opposite of what the module argues.' },
        { id: 'd', text: 'Promise a separate written report at the end of term.',                                                                      isCorrect: false, feedback: 'Kicks the conversation down the road. The trust move is in the PTM itself, not a deferred artifact.' },
      ],
    },
    {
      id: 'india-final-q2', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 2, dimension_number: 2,
      prompt: 'Kim et al. (2013) tracked Chinese-American adolescents across tiger-parenting, supportive, easygoing, and harsh parenting styles. The finding most relevant to your Indian parent conversations is:',
      research_anchor: 'Kim, Wang, Orozco-Lapray, Shen & Murtuza (2013), J. Fam. Psychol.',
      options: [
        { id: 'a', text: 'Tiger parenting produced the strongest academic outcomes across the sample.',                                                isCorrect: false, feedback: 'This is the folk reading. The paper found the opposite on most outcomes.' },
        { id: 'b', text: 'Supportive parenting outperformed tiger parenting on academic achievement, GPA, educational attainment, AND psychological adjustment.', isCorrect: true,  feedback: 'Correct. This is the single most-cited piece of evidence against the "pressure works" frame - worth naming in parent conversations.' },
        { id: 'c', text: 'Parenting style had no significant effect once socioeconomic status was controlled.',                                        isCorrect: false, feedback: 'SES matters, but the effect sizes in this paper survived that control.' },
        { id: 'd', text: 'Effects were detectable on academic measures but not on emotional wellbeing.',                                               isCorrect: false, feedback: 'Effects were found on both - emotional wellbeing arguably the stronger differentiator.' },
      ],
    },
    {
      id: 'india-final-q3', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 3, dimension_number: 2,
      prompt: 'A high-performing Grade 9 student stops attempting problems in class unless she is sure of the answer. She still scores well on written assessments. The module\'s strongest first interpretation is:',
      research_anchor: 'Dweck (2006) / Boaler on mistake tolerance; percentage culture as external-judgement frame',
      options: [
        { id: 'a', text: 'She is under family pressure and the school should contact parents.',                                                        isCorrect: false, feedback: 'Possible but premature. Contacting parents before understanding the frame can confirm their worst fear.' },
        { id: 'b', text: 'She has internalised a system where visible error reduces her legible status and is protecting her external record.',        isCorrect: true,  feedback: 'Correct. Percentage culture trains students to treat the record as the outcome. The intervention is reframing errors as visible learning, not adding more work.' },
        { id: 'c', text: 'She is disengaged and should be moved to a more challenging group.',                                                         isCorrect: false, feedback: 'The behaviour is engagement with self-protection, not disengagement.' },
        { id: 'd', text: 'She is being polite and letting peers have the floor.',                                                                      isCorrect: false, feedback: 'This is the charitable reading of the surface behaviour but it misses the systemic pattern.' },
      ],
    },
    {
      id: 'india-final-q4', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 4, dimension_number: 3,
      prompt: 'An Indian parent asks to create a WhatsApp group "for clarifications about the unit." Which principle from the module best guides your response?',
      research_anchor: 'EEF Parental Engagement Toolkit - structured parental communication adds +3 months progress when purpose is defined',
      options: [
        { id: 'a', text: 'Refuse because parent channels become gossip channels.',                                                                    isCorrect: false, feedback: 'Reduces trust without solving the underlying coordination need.' },
        { id: 'b', text: 'Accept and let the group self-moderate.',                                                                                    isCorrect: false, feedback: 'EEF evidence shows unmoderated parent channels tend to drift into comparison and anxiety without a defined purpose.' },
        { id: 'c', text: 'Accept with a named purpose and a norm ("for clarifying questions about the current unit; individual issues still go by email").', isCorrect: true,  feedback: 'Correct. Parental engagement works when it is structured around a purpose. The group is a tool; the norm is the intervention.' },
        { id: 'd', text: 'Create a broadcast-only channel so parents can receive updates but not reply.',                                              isCorrect: false, feedback: 'Safer, but loses the clarification loop that the parents were asking for - and that the research says is useful when framed.' },
      ],
    },
    {
      id: 'india-final-q5', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 5, dimension_number: 4,
      prompt: 'The module distinguishes "Indian values" as inclusive branding from "Indian values" as culturally specific practice. Which of the following is the most defensible stance for a teacher running Indian Values Week?',
      research_anchor: 'Critical multiculturalism (May & Sleeter 2010) - surface inclusion can mask selective belonging',
      options: [
        { id: 'a', text: 'Avoid the event entirely because any framing of "Indian values" is essentialising.',                                         isCorrect: false, feedback: 'Avoidance trades one risk for another - the families for whom this matters lose visibility.' },
        { id: 'b', text: 'Present a single, unified narrative of Indian values so all families feel included.',                                        isCorrect: false, feedback: 'This is the risk the module flags: surface inclusion that centers one region or caste and renders others invisible.' },
        { id: 'c', text: 'Plan the week around multiple regional, linguistic, and religious traditions, and be explicit that the week is a sampling, not a definition.',      isCorrect: true,  feedback: 'Correct. Naming the sampling-vs-definition distinction is the move that keeps the event inclusive without false universalism.' },
        { id: 'd', text: 'Let parents define the content entirely so the school stays neutral.',                                                        isCorrect: false, feedback: 'Abdicates the curriculum responsibility and often amplifies whichever parent subgroup is loudest.' },
      ],
    },
    {
      id: 'india-final-q6', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 6, dimension_number: 5,
      prompt: 'A polished Grade 10 exhibition ends, and an Indian parent says quietly: "This is beautiful. But I still don\'t know if my daughter is good enough for IIT prep later." The module argues the most useful frame for this moment is:',
      research_anchor: 'Trust-seeking framing - parent questions as information requests about the child\'s future, not curriculum resistance',
      options: [
        { id: 'a', text: 'The parent rejects inquiry learning and is signalling they will pull the student.',                                         isCorrect: false, feedback: 'This is the reading that makes these conversations defensive. The module pushes back against it.' },
        { id: 'b', text: 'The parent is asking for a specific piece of information about their child\'s trajectory and is using the available vocabulary.',                   isCorrect: true,  feedback: 'Correct. The ask is trust-seeking and future-oriented. Engaging the specifics - current strengths, development edges - answers what they actually want to know.' },
        { id: 'c', text: 'The parent wants you to validate a decision they have already made.',                                                        isCorrect: false, feedback: 'Sometimes true, but projecting the decision onto them forecloses a conversation that has not yet happened.' },
        { id: 'd', text: 'The parent needs a reassurance statement that IB students do succeed at IIT-equivalent pathways.',                          isCorrect: false, feedback: 'Reassurance without specifics is the move that sounds like branding.' },
      ],
    },
    {
      id: 'india-final-q7', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 7, dimension_number: 6,
      prompt: 'An Indian parent sees "no ranking" on a school report and asks what it means. The strongest teacher response per the module:',
      research_anchor: 'Black & Wiliam (1998) - assessment for learning; ranking as "ego-involving" vs "task-involving" feedback',
      options: [
        { id: 'a', text: '"We don\'t rank because ranking is harmful."',                                                                              isCorrect: false, feedback: 'True-ish but lectures the parent and closes the conversation.' },
        { id: 'b', text: '"Rankings shift attention from the task to the self, which reduces learning. We show mastery instead - let me walk you through the rubric."',       isCorrect: true,  feedback: 'Correct. Black & Wiliam\'s distinction gives the parent a reason, and the rubric offer gives them a concrete substitute.' },
        { id: 'c', text: '"No ranking is IB policy, so we follow it."',                                                                                isCorrect: false, feedback: 'Hides behind policy and models the compliance frame the module is trying to avoid.' },
        { id: 'd', text: '"Ranking is fine in CBSE but not here."',                                                                                    isCorrect: false, feedback: 'Throws the parent\'s home system under the bus and is unlikely to build trust.' },
      ],
    },
    {
      id: 'india-final-q8', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 8, dimension_number: 1,
      prompt: 'Which of these PTM behaviours is the module\'s evidence base most likely to flag as the highest-risk for producing parent frustration later?',
      research_anchor: 'EEF - "Parent-teacher conferences have neutral to negative effect sizes when exchanges remain at the pleasantry level"',
      options: [
        { id: 'a', text: 'Teacher is respectful, formal, and gives a surface-level description of progress.',                                         isCorrect: true,  feedback: 'Correct. Polite-but-thin is the single most reliable producer of the "I left the PTM with nothing" complaint - and it is the default mode when teachers feel time pressure.' },
        { id: 'b', text: 'Teacher disagrees openly with the parent\'s characterisation and explains why.',                                            isCorrect: false, feedback: 'Disagreement done well tends to build trust, not undermine it.' },
        { id: 'c', text: 'Teacher brings a specific piece of the student\'s work to the conference.',                                                 isCorrect: false, feedback: 'This is close to the module\'s ideal move.' },
        { id: 'd', text: 'Teacher suggests one concrete action the parent can take this week.',                                                       isCorrect: false, feedback: 'This is a high-leverage behaviour, not a risk.' },
      ],
    },
    {
      id: 'india-final-q9', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 9, dimension_number: 3,
      prompt: 'A parent offers to share a CBSE-aligned workbook that "matches" your unit. The module\'s default reading is:',
      research_anchor: 'Epstein (2001) - parental involvement is a collaboration signal, not a boundary violation, when framed cooperatively',
      options: [
        { id: 'a', text: 'Overstepping - politely decline and remind them of the curriculum.',                                                         isCorrect: false, feedback: 'Treats a collaboration offer as a boundary violation and misses what Epstein calls the most reliable marker of engaged families.' },
        { id: 'b', text: 'A signal that the parent wants to be useful and is using the vocabulary they have. Engage with the offer and explain how your unit\'s practice is structured.', isCorrect: true,  feedback: 'Correct. Reframe the gesture as cooperation, not interference. You can accept the offer partially, redirect it, or thank them explicitly.' },
        { id: 'c', text: 'An attempt to shadow-assess the student against CBSE standards.',                                                           isCorrect: false, feedback: 'Sometimes true for some families, but not the default reading - and assuming it sets an adversarial tone.' },
        { id: 'd', text: 'A red flag that the family is considering a transfer back to CBSE.',                                                         isCorrect: false, feedback: 'Over-reads the move.' },
      ],
    },
    {
      id: 'india-final-q10', module_id: 'india-001', quiz_type: 'final_exam',
      sort_order: 10, dimension_number: 6,
      prompt: 'Which single sentence best captures the module\'s core stance toward parent conversations?',
      research_anchor: 'Module synthesis - cultural fluency x research-anchored feedback x trust-seeking interpretation',
      options: [
        { id: 'a', text: '"Parents in percentage cultures need to be shown that inquiry is better."',                                                 isCorrect: false, feedback: 'This is the persuasion frame the module rejects.' },
        { id: 'b', text: '"Parent questions about marks, rank, and proof of progress are usually trust-seeking moves that deserve specific, evidence-anchored answers - not reassurance or policy."', isCorrect: true,  feedback: 'Correct. The module is not about converting parents; it is about reading the ask and responding with the specificity that earns trust.' },
        { id: 'c', text: '"Teachers should defer to parents on matters of cultural values."',                                                         isCorrect: false, feedback: 'Abdicates the teacher\'s professional judgement.' },
        { id: 'd', text: '"The goal is to align parent expectations with IB philosophy by the end of the year."',                                     isCorrect: false, feedback: 'Alignment is not the module\'s stated outcome - trust-producing conversations are.' },
      ],
    },
  ],
}

// ---------- Auth helpers ----------

export async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password })
  if (error) throw error
  return data
}

export async function signOut() {
  const { error } = await supabase.auth.signOut()
  if (error) throw error
}

export async function resetPasswordForEmail(email) {
  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/login`,
  })
  if (error) throw error
}

export async function getProfile(userId) {
  const { data, error } = await supabase
    .from('profiles')
    .select('*, school:schools(id, name, domain)')
    .eq('id', userId)
    .single()
  if (error) throw error
  return data
}

// ---------- Assignments ----------

export async function getAssignments(userId, schoolId) {
  const { data, error } = await supabase
    .from('assignments')
    .select('*')
    .or(`user_id.eq.${userId},and(school_id.eq.${schoolId},user_id.is.null)`)
    .order('due_date', { ascending: true, nullsFirst: false })
  if (error) throw error
  return data ?? []
}

export async function createAssignment({ schoolId, userId, roleTarget, moduleSlug, assignedBy, dueDate }) {
  const { error } = await supabase
    .from('assignments')
    .insert({
      school_id:   schoolId,
      user_id:     userId ?? null,
      role_target: roleTarget ?? null,
      module_slug: moduleSlug,
      assigned_by: assignedBy,
      due_date:    dueDate ?? null,
    })
  if (error) throw error
}

// Remove an assignment by id. RLS handles permission — admins can
// only delete within their own school, superadmins can delete anywhere.
export async function deleteAssignment(assignmentId) {
  const { error } = await supabase
    .from('assignments')
    .delete()
    .eq('id', assignmentId)
  if (error) throw error
}

// ---------- Completions ----------

export async function getCompletions(userId) {
  const { data, error } = await supabase
    .from('module_completions')
    .select('*')
    .eq('user_id', userId)
  if (error) throw error
  return data ?? []
}

export async function upsertCompletion(userId, moduleSlug, progressPct) {
  const isComplete = progressPct >= 80
  const { error } = await supabase
    .from('module_completions')
    .upsert({
      user_id:      userId,
      module_slug:  moduleSlug,
      progress_pct: progressPct,
      completed_at: isComplete ? new Date().toISOString() : null,
      last_updated: new Date().toISOString(),
    }, { onConflict: 'user_id,module_slug' })
  if (error) throw error
}

// ---------- Admin: school rollups ----------

export async function getSchoolProgress(schoolId) {
  const { data, error } = await supabase
    .from('profiles')
    .select(`
      id, full_name, email, role,
      completions:module_completions(module_slug, progress_pct, completed_at)
    `)
    .eq('school_id', schoolId)
    .neq('role', 'admin')
    .order('full_name')
  if (error) throw error
  return data ?? []
}

export async function getSchoolAssignments(schoolId) {
  const { data, error } = await supabase
    .from('assignments')
    .select('*')
    .eq('school_id', schoolId)
    .order('assigned_at', { ascending: false })
  if (error) throw error
  return data ?? []
}

// Every profile row attached to this school. Used to populate the admin
// roster, the "Specific users" assignment picker, and per-user lookups.
export async function getSchoolMembers(schoolId) {
  const { data, error } = await supabase
    .from('profiles')
    .select('id, email, full_name, role, school_id')
    .eq('school_id', schoolId)
    .order('full_name', { ascending: true })
  if (error) throw error
  return data ?? []
}

// Admin edit — update a member's name/role, and (superadmin) their school.
// RLS enforces that regular admins can only edit members of their own school.
export async function updateMemberProfile({ userId, fullName, role, schoolId }) {
  const patch = {}
  if (fullName !== undefined) patch.full_name = fullName
  if (role     !== undefined) patch.role      = role
  if (schoolId !== undefined) patch.school_id = schoolId
  const { error } = await supabase
    .from('profiles')
    .update(patch)
    .eq('id', userId)
  if (error) throw error
}

// All schools — used by the superadmin "move member to school" dropdown.
// RLS should restrict this to superadmins only.
export async function getAllSchools() {
  const { data, error } = await supabase
    .from('schools')
    .select('id, name')
    .order('name', { ascending: true })
  if (error) throw error
  return data ?? []
}

// ---------- PD Module content ----------

export async function getModule(dbId) {
  if (MOCK_MODE) return MOCK_PD_MODULES[dbId] ?? {
    id: dbId, title: dbId,
    tagline: 'Mock module content',
    preamble_md: 'Mock preamble - Supabase is not configured.',
    status: 'live',
  }
  const { data, error } = await supabase
    .from('pd_modules')
    .select('*')
    .eq('id', dbId)
    .single()
  if (error) throw error
  return data
}

export async function getDimensions(dbId) {
  if (MOCK_MODE) return mockDimensionsForModuleView(dbId)
  const { data, error } = await supabase
    .from('pd_dimensions')
    .select('*')
    .eq('module_id', dbId)
    .order('dimension_number')
  if (error) throw error
  return data ?? []
}

export async function getQuizQuestions(dbId) {
  if (MOCK_MODE) return mockQuizQuestionsForModule(dbId)
  const { data, error } = await supabase
    .from('pd_quiz_questions')
    .select('*')
    .eq('module_id', dbId)
    .order('quiz_type')
    .order('sort_order')
  if (error) throw error
  return data ?? []
}

export async function getSimulations(dbId) {
  if (MOCK_MODE) return []
  const { data, error } = await supabase
    .from('pd_simulations')
    .select('id, title, description, context, characters, nodes, dimension_tags, estimated_minutes, sort_order, status')
    .eq('module_id', dbId)
    .eq('status', 'live')
    .order('sort_order')
  if (error) throw error
  return data ?? []
}

export async function saveSimulationResponse({ sessionId, simulationId, nodeId, choiceId = null, reflectionText = null }) {
  if (MOCK_MODE) return
  const { error } = await supabase
    .from('pd_simulation_responses')
    .insert({ session_id: sessionId, simulation_id: simulationId, node_id: nodeId, choice_id: choiceId, reflection_text: reflectionText })
  if (error) console.warn('Simulation response save failed (non-blocking):', error)
}

// ---------- Quiz responses ----------

export async function upsertQuizResponse({ userId, moduleId, questionId, optionId, isCorrect, quizType, dimensionNumber }) {
  const { error } = await supabase
    .from('quiz_responses')
    .upsert({
      user_id:          userId,
      module_id:        moduleId,
      question_id:      questionId,
      option_id:        optionId,
      is_correct:       isCorrect,
      quiz_type:        quizType,
      dimension_number: dimensionNumber ?? null,
      answered_at:      new Date().toISOString(),
    }, { onConflict: 'user_id,question_id' })
  if (error) throw error
}

export async function getUserQuizResponses(userId) {
  if (MOCK_MODE) return []
  const { data, error } = await supabase
    .from('quiz_responses')
    .select('module_id, question_id, is_correct, quiz_type, dimension_number, answered_at')
    .eq('user_id', userId)
  if (error) throw error
  return data ?? []
}

export async function getModuleQuizAnalytics(moduleId) {
  if (MOCK_MODE) return []
  const { data, error } = await supabase
    .from('quiz_responses')
    .select('user_id, question_id, option_id, is_correct, quiz_type, dimension_number')
    .eq('module_id', moduleId)
  if (error) throw error
  return data ?? []
}

export async function getModuleQuizQuestions(moduleId) {
  if (MOCK_MODE) return []
  const { data, error } = await supabase
    .from('pd_quiz_questions')
    .select('id, prompt, quiz_type, sort_order, dimension_number, options')
    .eq('module_id', moduleId)
    .order('sort_order')
  if (error) throw error
  return data ?? []
}

// ---------- Admin: invite batches ----------

export async function createInviteBatch({ schoolId, createdBy, totalRows }) {
  if (MOCK_MODE) {
    await wait(120)
    return {
      id: `mock-batch-${Date.now()}`,
      school_id: schoolId,
      created_by: createdBy,
      total_rows: totalRows,
      imported: 0,
      failed: 0,
      status: 'in_progress',
      created_at: new Date().toISOString(),
    }
  }
  const { data, error } = await supabase
    .from('invite_batches')
    .insert({
      school_id:  schoolId,
      created_by: createdBy,
      total_rows: totalRows,
      imported:   0,
      failed:     0,
      status:     'in_progress',
    })
    .select('*')
    .single()
  if (error) throw error
  return data
}

export async function createInviteBatchRows(batchId, rows) {
  if (MOCK_MODE) { await wait(80); return rows.length }
  const payload = rows.map(r => ({
    batch_id: batchId,
    email:    r.email,
    full_name: r.full_name,
    role:     r.role,
    status:   r.status ?? 'pending',
    error_message: r.error_message ?? null,
  }))
  const { error } = await supabase.from('invite_batch_rows').insert(payload)
  if (error) throw error
  return payload.length
}

export async function updateInviteBatchCounts(batchId, { imported, failed, status }) {
  if (MOCK_MODE) { await wait(80); return }
  const { error } = await supabase
    .from('invite_batches')
    .update({
      imported,
      failed,
      status: status ?? 'completed',
      completed_at: new Date().toISOString(),
    })
    .eq('id', batchId)
  if (error) throw error
}

export async function inviteUser({ email, fullName, role, schoolId }) {
  if (MOCK_MODE) {
    await wait(150)
    return { ok: true, user_id: `mock-user-${Date.now()}` }
  }
  const { data, error } = await supabase.functions.invoke('invite-user', {
    body: { email, full_name: fullName, role, school_id: schoolId },
  })
  if (error) throw error
  return data
}

// ---------- Admin: action queue ----------

export async function getAdminActionItems(schoolId) {
  if (MOCK_MODE) return []
  const { data, error } = await supabase
    .from('admin_action_items')
    .select('*, user:profiles!admin_action_items_user_id_fkey(full_name, email)')
    .eq('school_id', schoolId)
    .eq('status', 'open')
    .order('severity', { ascending: false })
    .order('created_at', { ascending: false })
  if (error) throw error
  return data ?? []
}

export async function refreshAdminActionItems(schoolId) {
  if (MOCK_MODE) { await wait(150); return { ok: true } }
  const { error } = await supabase.rpc('refresh_admin_action_items', { target_school: schoolId })
  if (error) throw error
  return { ok: true }
}

export async function resolveAdminActionItem(itemId, { resolvedBy, note }) {
  if (MOCK_MODE) { await wait(80); return }
  const { error } = await supabase
    .from('admin_action_items')
    .update({
      status: 'resolved',
      resolved_at: new Date().toISOString(),
      resolved_by: resolvedBy ?? null,
      resolution_note: note ?? null,
    })
    .eq('id', itemId)
  if (error) throw error
}

// ---------- SuperAdmin: module editor ----------

export async function getAllModules() {
  if (MOCK_MODE) {
    await wait(100)
    return Object.values(MOCK_PD_MODULES)
  }
  const { data, error } = await supabase
    .from('pd_modules')
    .select('id, country_code, title, tagline, preamble_md, status')
    .order('title')
  if (error) throw error
  return data ?? []
}

export async function updateModuleStatus(moduleId, status) {
  if (MOCK_MODE) { await wait(80); return }
  const { error } = await supabase
    .from('pd_modules')
    .update({ status })
    .eq('id', moduleId)
  if (error) throw error
}

// Update the prose fields on pd_modules (title, tagline, preamble_md).
// Only fields present in the patch are sent — callers can pass any subset.
export async function updateModule(moduleId, patch) {
  if (MOCK_MODE) { await wait(80); return }
  const payload = {}
  if (patch.title       !== undefined) payload.title       = patch.title
  if (patch.tagline     !== undefined) payload.tagline     = patch.tagline
  if (patch.preamble_md !== undefined) payload.preamble_md = patch.preamble_md
  if (Object.keys(payload).length === 0) return
  const { error } = await supabase
    .from('pd_modules')
    .update(payload)
    .eq('id', moduleId)
  if (error) throw error
}

export async function getAllDimensions(moduleId) {
  if (MOCK_MODE) return mockDimensionsForModuleView(moduleId)
  const { data, error } = await supabase
    .from('pd_dimensions')
    .select('id, module_id, dimension_number, title, content, research_status')
    .eq('module_id', moduleId)
    .order('dimension_number')
  if (error) throw error
  return data ?? []
}

export async function updateDimension(dimensionId, { title, content }) {
  if (MOCK_MODE) { await wait(80); return }
  const { error } = await supabase
    .from('pd_dimensions')
    .update({
      title: title ?? undefined,
      content: content ?? undefined,
    })
    .eq('id', dimensionId)
  if (error) throw error
}

