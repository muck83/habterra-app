/* ─────────────────────────────────────────────────────────────────────────────
   School branding registry — the unauthed-side counterpart to schools.* in
   the database.

   Used on screens where we don't yet have a logged-in profile (i.e. the
   public Login page) but want to render school-specific branding when we
   can detect which school the visitor is from. Detection sources, in order
   of priority:

     1. URL query param  ?school=<slug>      (deep link from school site / email)
     2. Email domain match on the sign-in    (user types you@woodstockschool.in)
     3. localStorage memo from a prior visit (set after either of the above)

   Once a real profile loads (post sign-in), the database-side schools.*
   columns take over via AuthContext + the Logo brandName/brandLogoUrl props.

   ADDING A NEW SCHOOL: add an entry here with the same `slug` you'll use in
   marketing links and an exact `domain` match for the school's email. The
   asset paths point at files under public/schools/<slug>/.
   ───────────────────────────────────────────────────────────────────────── */

export const SCHOOLS = {
  woodstock: {
    slug: 'woodstock',
    domain: 'woodstockschool.in',
    displayName: 'Woodstock School',
    shortName: 'Woodstock',
    tagline: 'Parent & Teacher Companion',
    // The vertical lockup is sized for the Login left brand panel — seal +
    // wordmark stacked, white-on-transparent for the dark teal background.
    loginLockupUrl: '/schools/woodstock/lockup-white-vertical.png',
    // Tight, school-specific body copy for the Login left panel. Falls back
    // to the generic Habterra line when no school is detected.
    loginBodyCopy:
      "Cultural context and curriculum guidance for Woodstock families — assigned by your school, in your language, tracked to completion.",
  },
  // NLIS deliberately not registered here — it uses the default Habterra
  // login experience for now. Add an entry when a partner school wants its
  // own Login branding.
}

const STORAGE_KEY = 'habterra:school'

/* Look up a school by URL-safe slug ("woodstock"). */
export function bySlug(slug) {
  if (!slug) return null
  const key = String(slug).trim().toLowerCase()
  return SCHOOLS[key] || null
}

/* Look up a school by exact email domain ("woodstockschool.in"). Returns null
   if the domain isn't one of our registered schools. */
export function byDomain(domain) {
  if (!domain) return null
  const target = String(domain).trim().toLowerCase()
  for (const school of Object.values(SCHOOLS)) {
    if (school.domain === target) return school
  }
  return null
}

/* Pull the school slug out of the current URL (?school=<slug>). Returns null
   if the param is absent or unrecognised. Safe to call from SSR — no-ops if
   window is undefined. */
export function fromUrl() {
  if (typeof window === 'undefined') return null
  const params = new URLSearchParams(window.location.search)
  const slug = params.get('school')
  return bySlug(slug)
}

/* Read the last-seen school slug from localStorage. Returns null if nothing
   was stored or the slug is no longer registered. */
export function fromMemo() {
  if (typeof window === 'undefined') return null
  try {
    const slug = window.localStorage.getItem(STORAGE_KEY)
    return bySlug(slug)
  } catch {
    return null
  }
}

/* Persist a school slug so the next visit on this device skips detection.
   Pass null to clear (e.g. on sign-out from a co-branded school). */
export function memoize(slug) {
  if (typeof window === 'undefined') return
  try {
    if (slug) window.localStorage.setItem(STORAGE_KEY, slug)
    else      window.localStorage.removeItem(STORAGE_KEY)
  } catch {
    /* swallow — quota errors / disabled storage shouldn't crash branding */
  }
}

/* Extract the domain ("woodstockschool.in") from an email string. Returns
   the empty string if the input isn't a parseable email. */
export function emailDomain(email) {
  if (!email) return ''
  const at = String(email).indexOf('@')
  if (at < 0) return ''
  return email.slice(at + 1).trim().toLowerCase()
}
