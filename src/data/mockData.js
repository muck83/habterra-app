// Habterra - Mock data for UI development.
// Swap these out for real Supabase calls when ready.

export const MOCK_SCHOOL = {
  id:     'school-nlis',
  name:   'NLIS Riyadh',
  domain: 'nlis.edu.sa',
}

// inDev: true means the module is scaffolded but not yet finished content.
// These slugs are visible to admins as a roadmap but cannot be assigned to real users.
export const MODULE_META = {
  'ksa-ib':               { slug: 'ksa-ib',               dbId: 'ksa-001',       flag: 'SA', label: 'Understand Saudi Arabia',          lang: 'EN / AR',  desc: 'Tawjihiyya, family expectations, and navigating IB in a Gulf context.', preamble_md: 'This module explores the cultural dynamics that shape how families from Saudi Arabia engage with international schools.', inDev: true },
  'india-ib':             { slug: 'india-ib',             dbId: 'india-001',     flag: 'IN', label: 'Understand India',                 lang: 'EN / HI',  desc: 'CBSE, board exams, and percentage culture.', preamble_md: 'This module explores the cultural dynamics that shape how families from India engage with international schools.' },
  'korea-ib':             { slug: 'korea-ib',             dbId: 'korea-001',     flag: 'KR', label: 'Understand Korea',                 lang: 'EN / KO',  desc: 'Suneung pressure and the Korean parents relationship with teacher authority.', preamble_md: 'This module explores the cultural dynamics that shape how families from Korea engage with international schools.', inDev: true },
  'china-ib':             { slug: 'china-ib',             dbId: 'china-001',     flag: 'CN', label: 'Understand China',                 lang: 'EN / ZH',  desc: 'Gaokao culture and what "no ranking" means to a Chinese parent.', preamble_md: 'This module explores the cultural dynamics that shape how families from China engage with international schools.', inDev: true },
  'vietnam-ib':           { slug: 'vietnam-ib',           dbId: 'vietnam-001',   flag: 'VN', label: 'Understand Vietnam',               lang: 'EN / VI',  desc: 'Filial piety, academic honour, and teaching in a system mid-reform.', preamble_md: 'Vietnamese families invest in international schools as a different route to the outcomes the national system promises.', inDev: true },
  'japan-ib':             { slug: 'japan-ib',             dbId: 'japan-001',     flag: 'JP', label: 'Understand Japan',                 lang: 'EN / JA',  desc: 'Entrance exams, collective harmony, and the invisible pressure on your students.', preamble_md: 'Japanese families choosing international schools are not abandoning the system that shaped them.', inDev: true },
  'woodstock-transition': { slug: 'woodstock-transition', dbId: 'woodstock-001', flag: 'WS', label: 'Woodstock Curriculum Transition',  lang: 'EN',       desc: 'IGCSE, AP, and WSD - what the transition means for every cohort.', preamble_md: 'This module explores the cultural dynamics that shape how families at Woodstock engage with the curriculum transition.', isParent: true },
  'indonesia-ib':         { slug: 'indonesia-ib',         dbId: 'indonesia-001', flag: 'ID', label: 'Understand Indonesia',             lang: 'EN / ID',  desc: 'UTBK pressure, face dynamics, and the faith dimension.', preamble_md: 'Indonesian families who choose international schools are navigating a dual identity.', inDev: true },
  'uae-ib':               { slug: 'uae-ib',               dbId: 'uae-001',       flag: 'AE', label: 'Understand UAE',                   lang: 'EN / AR',  desc: 'Wasta, school choice as social capital, and the Emirati family inside a global curriculum.', preamble_md: 'Families in the UAE who choose international schools are not a monolith.', inDev: true },
}

export const MOCK_ASSIGNMENTS = [
  { id: 'a1', school_id: 'school-nlis', module_slug: 'ksa-ib',   role_target: 'all',     due_date: '2026-05-01', assigned_at: '2026-03-15' },
  { id: 'a2', school_id: 'school-nlis', module_slug: 'india-ib', role_target: 'teacher', due_date: '2026-06-30', assigned_at: '2026-04-13' },
  { id: 'a3', school_id: 'school-nlis', module_slug: 'korea-ib', role_target: 'teacher', due_date: '2026-05-15', assigned_at: '2026-03-20' },
]

export const MOCK_ADMIN_ACTION_ITEMS = [
  {
    id: 'mock-action-invite-failed',
    school_id: 'school-nlis',
    user_id: null,
    module_slug: null,
    action_type: 'invite_failed',
    severity: 'high',
    status: 'open',
    title: 'Invite failed for parent.one@gmail.com',
    detail: 'The email bounced during the batch import. Check the address and resend the invitation.',
    due_date: null,
    metadata: { email: 'parent.one@gmail.com', role: 'parent' },
    created_at: '2026-04-16T12:00:00Z',
  },
  {
    id: 'mock-action-no-progress',
    school_id: 'school-nlis',
    user_id: 'u4',
    module_slug: 'ksa-ib',
    action_type: 'no_progress',
    severity: 'medium',
    status: 'open',
    title: 'Tom Walsh has not started Saudi Arabia module',
    detail: 'The assignment is more than 7 days old with no recorded progress.',
    due_date: '2026-05-01',
    metadata: { email: 'twalsh@nlis.edu.sa' },
    user: { full_name: 'Tom Walsh', email: 'twalsh@nlis.edu.sa' },
    created_at: '2026-04-16T12:00:00Z',
  },
  {
    id: 'mock-action-stalled',
    school_id: 'school-nlis',
    user_id: 'u5',
    module_slug: 'india-ib',
    action_type: 'stalled',
    severity: 'medium',
    status: 'open',
    title: 'Anna Kowalski is stalled at 30%',
    detail: 'No progress update has been recorded in 14 days for the India module.',
    due_date: '2026-06-30',
    metadata: { progress_pct: 30, email: 'akowalski@nlis.edu.sa' },
    user: { full_name: 'Anna Kowalski', email: 'akowalski@nlis.edu.sa' },
    created_at: '2026-04-16T12:00:00Z',
  },
  {
    id: 'mock-action-overdue',
    school_id: 'school-nlis',
    user_id: 'u10',
    module_slug: 'ksa-ib',
    action_type: 'overdue',
    severity: 'high',
    status: 'open',
    title: 'Li Wei is overdue for Saudi Arabia module',
    detail: 'The due date has passed and the module is not complete.',
    due_date: '2026-04-01',
    metadata: { progress_pct: 55, email: 'liwei@nlis.edu.sa' },
    user: { full_name: 'Li Wei', email: 'liwei@nlis.edu.sa' },
    created_at: '2026-04-16T12:00:00Z',
  },
  {
    id: 'mock-action-quiz-weak',
    school_id: 'school-nlis',
    user_id: null,
    module_slug: 'china-ib',
    action_type: 'quiz_weak',
    severity: 'low',
    status: 'open',
    title: 'Quiz weak spot: China module',
    detail: '44% correct across 9 responses. Teachers are over-reading parent workbook help as interference.',
    due_date: null,
    metadata: { question_id: 'china-d2-q1', correct: 4, total: 9 },
    created_at: '2026-04-16T12:00:00Z',
  },
]

export const MOCK_QUIZ_ANALYTICS = {
  'india-ib': [
    { id: 'india-d4-q1',    label: 'D4 Checkpoint', prompt: '"Indian values" language can sound inclusive while actually centering a selective version of belonging - what does the research say?', n: 12, correct: 5,  topWrong: 'C - Parents treat this as branding' },
    { id: 'india-d3-q1',    label: 'D3 Checkpoint', prompt: 'Which PTM outcome is most likely to produce frustration later?', n: 12, correct: 7,  topWrong: 'A - Teacher is respectful but formal' },
    { id: 'india-final-q2', label: 'Final Q2',      prompt: 'Best interpretation when a parent asks whether Indian Values Week includes regional differences?', n: 10, correct: 5,  topWrong: 'C - Parent just wants event details' },
    { id: 'india-d5-q1',    label: 'D5 Checkpoint', prompt: 'A high-performing student avoids visible trial-and-error. Strongest first interpretation?', n: 12, correct: 8,  topWrong: 'A - Family is pressuring student' },
    { id: 'india-d2-q1',    label: 'D2 Checkpoint', prompt: 'Why do marks remain powerful in schools that sincerely promote inquiry?', n: 12, correct: 9,  topWrong: 'C - Narrative feedback cannot carry useful information' },
    { id: 'india-d6-q1',    label: 'D6 Checkpoint', prompt: 'Most useful way to understand parent WhatsApp groups?', n: 11, correct: 8,  topWrong: 'A - Gossip channels schools should avoid' },
    { id: 'india-d1-q1',    label: 'D1 Checkpoint', prompt: 'After a polished exhibition, a parent asks where my child actually stands - strongest first interpretation?', n: 12, correct: 10, topWrong: 'A - Rejecting holistic education' },
    { id: 'india-final-q1', label: 'Final Q1',      prompt: 'Parent asks for concrete scorecard after project exhibition - most research-aligned response?', n: 10, correct: 7,  topWrong: 'A - Marks are outdated' },
    { id: 'india-final-q3', label: 'Final Q3',      prompt: 'Parents want WhatsApp group for clarifications - best guiding principle?', n: 10, correct: 8,  topWrong: 'B - Refuse because parent groups are toxic' },
  ],
  'ksa-ib': [
    { id: 'ksa-d1-q1',    label: 'D1 Checkpoint', prompt: 'Parent asks what a student voice activity teaches - strongest first interpretation?', n: 32, correct: 25, topWrong: null },
    { id: 'ksa-d2-q1',    label: 'D2 Checkpoint', prompt: 'Why do routine parent questions sometimes feel larger than they appear?', n: 30, correct: 19, topWrong: 'A - Families want faster updates' },
    { id: 'ksa-d3-q1',    label: 'D3 Checkpoint', prompt: 'Why can an English-first routine become more than a language policy?', n: 28, correct: 14, topWrong: 'C - Families usually oppose English' },
    { id: 'ksa-d4-q1',    label: 'D4 Checkpoint', prompt: 'Family chose international school but expects Islamic Studies to anchor the week?', n: 27, correct: 13, topWrong: 'B - They are confused about offerings' },
    { id: 'ksa-d5-q1',    label: 'D5 Checkpoint', prompt: 'Student unusually quiet during mixed-gender group task - strongest interpretation?', n: 26, correct: 20, topWrong: null },
    { id: 'ksa-d6-q1',    label: 'D6 Checkpoint', prompt: 'Most important teacher move when parent frames feedback in religious terms?', n: 25, correct: 16, topWrong: 'A - Redirect to secular objectives' },
    { id: 'ksa-final-q1', label: 'Final Q1',      prompt: 'Parent asks if student voice teaches challenging adults - best first move?', n: 22, correct: 17, topWrong: null },
    { id: 'ksa-final-q2', label: 'Final Q2',      prompt: 'Child begins treating English as language of status - strongest explanation?', n: 21, correct: 16, topWrong: null },
    { id: 'ksa-final-q3', label: 'Final Q3',      prompt: 'Saudi school-choice research suggests what about many families?', n: 20, correct: 13, topWrong: 'B - Trading local continuity for opportunity' },
  ],
  'korea-ib': [
    { id: 'korea-d1-q1',    label: 'D1 Checkpoint', prompt: 'Parent says Suneung is the only exam that matters - strongest interpretation?', n: 34, correct: 22, topWrong: 'C - Rejecting IB philosophy' },
    { id: 'korea-d2-q1',    label: 'D2 Checkpoint', prompt: 'Parent expects homeroom teacher to coordinate all subjects - best explanation?', n: 31, correct: 24, topWrong: null },
    { id: 'korea-d3-q1',    label: 'D3 Checkpoint', prompt: 'Parent coalition pushes back when test week is replaced by project week?', n: 29, correct: 15, topWrong: 'A - Uncomfortable with innovation' },
    { id: 'korea-d4-q1',    label: 'D4 Checkpoint', prompt: 'Most students attend hagwon until 10pm and are fatigued - strongest interpretation?', n: 27, correct: 14, topWrong: 'B - Parents undermining school' },
    { id: 'korea-d5-q1',    label: 'D5 Checkpoint', prompt: 'Student waits until sure before speaking - strongest interpretation?', n: 26, correct: 20, topWrong: null },
    { id: 'korea-d6-q1',    label: 'D6 Checkpoint', prompt: 'Most important teacher move when parent frames concerns through ranking language?', n: 24, correct: 15, topWrong: 'A - Rankings are harmful' },
    { id: 'korea-final-q1', label: 'Final Q1',      prompt: 'Parent asks why school does not publish class rankings - best first move?', n: 21, correct: 16, topWrong: null },
    { id: 'korea-final-q2', label: 'Final Q2',      prompt: 'Student performs well but shows distress before assessments - strongest explanation?', n: 20, correct: 12, topWrong: 'C - Just test anxiety' },
    { id: 'korea-final-q3', label: 'Final Q3',      prompt: 'What principle captures the modules approach to parent communication?', n: 19, correct: 15, topWrong: null },
  ],
  'china-ib': [
    { id: 'china-d1-q1',    label: 'D1 Checkpoint', prompt: 'Parent asks where the fluency drills are - strongest interpretation?', n: 35, correct: 23, topWrong: 'A - Rejecting deep understanding' },
    { id: 'china-d2-q1',    label: 'D2 Checkpoint', prompt: 'Parent offers workbook matched to your unit overview - best default reading?', n: 33, correct: 17, topWrong: 'A - Overstepping boundaries' },
    { id: 'china-d3-q1',    label: 'D3 Checkpoint', prompt: 'After Double Reduction, why can more practice still feel reasonable?', n: 30, correct: 22, topWrong: null },
    { id: 'china-d4-q1',    label: 'D4 Checkpoint', prompt: 'Student reproduces model answer almost exactly - most careful first response?', n: 28, correct: 13, topWrong: 'A - Treat it as plagiarism' },
    { id: 'china-d5-q1',    label: 'D5 Checkpoint', prompt: 'Quiet student listens carefully - strongest first interpretation?', n: 27, correct: 21, topWrong: null },
    { id: 'china-d6-q1',    label: 'D6 Checkpoint', prompt: 'Most important teacher move across the China scenario bank?', n: 25, correct: 15, topWrong: 'A - Convince parents Western inquiry is advanced' },
    { id: 'china-final-q1', label: 'Final Q1',      prompt: 'Parent asks publicly in WeChat why your class gives less homework - best first move?', n: 22, correct: 14, topWrong: 'C - Ignore it' },
    { id: 'china-final-q2', label: 'Final Q2',      prompt: 'Which statement best captures the parallel-tracks problem?', n: 21, correct: 12, topWrong: 'A - Parents and teachers want different outcomes' },
    { id: 'china-final-q3', label: 'Final Q3',      prompt: 'Student quiet but attentive, parent says respectful listening - what should teacher do?', n: 20, correct: 16, topWrong: null },
  ],
}

// Completions: pct >= 80 is treated as "complete" (same rule as stool-app PD layer)
export const MOCK_USERS = [
  { id: 'u1',  full_name: 'Sarah Chen',     email: 'schen@nlis.edu.sa',     role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 65,  'korea-ib': 0   } },
  { id: 'u2',  full_name: 'James Hartley',  email: 'jhartley@nlis.edu.sa',  role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 100, 'korea-ib': 40  } },
  { id: 'u3',  full_name: 'Priya Nair',     email: 'pnair@nlis.edu.sa',     role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 100, 'korea-ib': 100 } },
  { id: 'u4',  full_name: 'Tom Walsh',      email: 'twalsh@nlis.edu.sa',    role: 'teacher',
    completions: { 'ksa-ib': 0,   'india-ib': 0,   'korea-ib': 0   } },
  { id: 'u5',  full_name: 'Anna Kowalski',  email: 'akowalski@nlis.edu.sa', role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 30,  'korea-ib': 15  } },
  { id: 'u6',  full_name: 'Dmitri Volkov',  email: 'dvolkov@nlis.edu.sa',   role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 100, 'korea-ib': 80  } },
  { id: 'u7',  full_name: 'Yuki Tanaka',    email: 'ytanaka@nlis.edu.sa',   role: 'teacher',
    completions: { 'ksa-ib': 85,  'india-ib': 0,   'korea-ib': 0   } },
  { id: 'u8',  full_name: "Clare O'Brien",  email: 'cobrien@nlis.edu.sa',   role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 80,  'korea-ib': 55  } },
  { id: 'u9',  full_name: 'Fatima Al-Harbi', email: 'falharbi@nlis.edu.sa', role: 'teacher',
    completions: { 'ksa-ib': 100, 'india-ib': 45,  'korea-ib': 0   } },
  { id: 'u10', full_name: 'Li Wei',         email: 'liwei@nlis.edu.sa',     role: 'parent',
    completions: { 'ksa-ib': 55,  'india-ib': 0,   'korea-ib': 0   } },
]

const COMPLETION_THRESHOLD = 80

// Active module slugs assigned to this school, filtered by role (teacher/parent/all).
export function getActiveModuleSlugs(roleFilter = 'all') {
  const slugs = new Set()
  for (const a of MOCK_ASSIGNMENTS) {
    if (roleFilter === 'all' || a.role_target === 'all' || a.role_target === roleFilter) {
      slugs.add(a.module_slug)
    }
  }
  return Array.from(slugs)
}

// Aggregated stats displayed on the admin dashboard header.
export function getSchoolStats(roleFilter = 'all') {
  const users = MOCK_USERS.filter(u => roleFilter === 'all' ? true : u.role === roleFilter)
  const slugs = getActiveModuleSlugs(roleFilter)

  let totalCells = 0
  let completedCells = 0
  let inProgressCells = 0

  users.forEach(u => {
    slugs.forEach(slug => {
      const pct = u.completions?.[slug] ?? 0
      totalCells += 1
      if (pct >= COMPLETION_THRESHOLD) completedCells += 1
      else if (pct > 0) inProgressCells += 1
    })
  })

  return {
    totalUsers:       users.length,
    totalAssignments: totalCells,
    completed:        completedCells,
    inProgress:       inProgressCells,
    notStarted:       totalCells - completedCells - inProgressCells,
    completionRate:   totalCells > 0 ? Math.round((completedCells / totalCells) * 100) : 0,
    teacherCount:     MOCK_USERS.filter(u => u.role === 'teacher').length,
    parentCount:     MOCK_USERS.filter(u => u.role === 'parent').length,
  }
}
