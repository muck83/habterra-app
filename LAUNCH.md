# Habterra — Launch Runbook

Target: `https://habterra.com` on Vercel, backed by production Supabase.

---

## 0. Prerequisites you'll need in hand

Before starting, have these three things ready:

1. Your Vercel account (free tier is fine).
2. Your **production** Supabase URL + anon key. Find them at: Supabase Dashboard → your prod project → Project Settings → API.
3. Access to your `habterra.com` DNS (wherever you bought it — GoDaddy, Namecheap, Cloudflare).

---

## 1. First deploy (Vercel CLI — ~5 minutes)

The CLI is the fastest path. From the `calibrate/` folder:

```bash
# one-time install, globally
npm i -g vercel

# log in (opens a browser)
vercel login

# first-time setup — this reads vercel.json and prompts for project name
vercel
```

When prompted:

| Prompt | Answer |
| --- | --- |
| Set up and deploy? | **Y** |
| Which scope? | your personal account (or team) |
| Link to existing project? | **N** |
| Project name? | **habterra** |
| Which directory is your code in? | **./** (accept default) |
| Modify settings? | **N** (vercel.json handles it) |

This produces a preview URL like `habterra-abc123.vercel.app`. It **will not work yet** — no env vars. That's next.

## 2. Set production env vars

Via dashboard: **Vercel → habterra project → Settings → Environment Variables**. Add both for *Production*, *Preview*, and *Development*:

```
VITE_SUPABASE_URL        = https://<your-prod-ref>.supabase.co
VITE_SUPABASE_ANON_KEY   = <your-prod-anon-key>
```

Or via CLI:

```bash
vercel env add VITE_SUPABASE_URL production
vercel env add VITE_SUPABASE_ANON_KEY production
# repeat for `preview` and `development` if you want preview deploys to work
```

## 3. Promote to production

```bash
vercel --prod
```

You'll get a URL like `habterra.vercel.app`. Open it — the app should load, Supabase should connect, and `/module/<slug>` deep-links should resolve (that's what `vercel.json`'s SPA rewrite is for).

Verify in order:

- [ ] Home page loads, Fraunces/Inter render correctly
- [ ] Tab favicon shows the teal-square Habterra mark
- [ ] Can sign in with a real account
- [ ] A module page loads (`/module/india-ib`)
- [ ] Certificate page renders (visit a completed module's cert)

If any of these fail, check the browser console and Vercel's deploy logs.

## 4. Attach `habterra.com`

Vercel → habterra project → **Settings → Domains → Add** → enter `habterra.com`.

Vercel will show you DNS records to create at your registrar. For a **root (apex) domain** the typical setup is one of:

| Your DNS provider supports | Record type | Host | Value |
| --- | --- | --- | --- |
| CNAME flattening (Cloudflare, DNSimple) | CNAME | `@` | `cname.vercel-dns.com` |
| A records only (GoDaddy, Namecheap) | A | `@` | `76.76.21.21` |

Also add `www.habterra.com` as a CNAME to `cname.vercel-dns.com` (Vercel will auto-redirect `www` → apex or vice versa based on what you pick as primary).

DNS typically propagates in 5–30 minutes. Vercel auto-provisions a free Let's Encrypt SSL cert as soon as it sees the record.

## 5. Supabase — production checks

Before you announce the URL, verify in your **production** Supabase project:

- [ ] **Auth → URL Configuration**: set *Site URL* to `https://habterra.com`. Add `https://habterra.com/**` to Redirect URLs so magic-link / password-reset emails work.
- [ ] **Auth → Email Templates**: the confirmation/reset emails still say "Calibrate"? Update them to "Habterra" branding.
- [ ] **Database**: schema is migrated (you said prod is ready — skim a few tables to double-check: `profiles`, `completions`, `modules`).
- [ ] **Settings → API**: confirm the anon key you pasted into Vercel matches the one shown here.

## 6. Post-launch smoke test

On the live `https://habterra.com`:

1. Sign up a fresh test account (or use an existing one) — does login work?
2. Click a module → start it → advance past one chapter — does progress persist on reload?
3. Open DevTools Network tab → confirm requests are going to `<your-prod-ref>.supabase.co`, not dev.
4. Share `https://habterra.com` in Slack / iMessage → verify the OG preview shows the Habterra card, not a blank tile.

## 7. Nice-to-haves after launch (not blockers)

- **CI via GitHub integration**: in Vercel → Settings → Git, connect the repo. Every `main` push auto-deploys to prod; every PR gets a preview URL. This replaces running `vercel --prod` from your laptop.
- **Bundle size**: the JS bundle is 657 kB / 175 kB gzipped. Works fine, but if load time matters, code-split the admin and superadmin routes with `React.lazy()`. One afternoon of work.
- **Brand scrub in Supabase content**: some SQL seed files and internal strings still say "Calibrate" in comments. Not user-visible, so not urgent, but flagging for future cleanup. A separate memory note covers this.

---

## Rollback

If something goes wrong post-launch:

- Vercel keeps every deploy. Go to **Deployments**, find the last good one, click **⋯ → Promote to Production**. Rollback is ~10 seconds.
- DNS rollback is slower (same propagation wait as any DNS change).
