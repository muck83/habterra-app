# Habterra — Admin & Superadmin Audit

_Written 2026-04-17. Covers the admin surfaces after the eschoonard superadmin provisioning._

## TL;DR

The data model is more capable than the UI reveals. `assignments` already supports per-user, per-school, and per-role targeting — the admin form just doesn't expose the first two. Superadmin dashboard is content-editor only (modules/dimensions/preview); it has no user, school, or assignment surface. The result: anything that isn't "edit copy" or "assign a module to every teacher at my school" either requires SQL or isn't possible at all.

Recommended build order at the bottom.

---

## 1. What exists today

### 1a. Superadmin (`/superadmin` → `SuperAdminDashboard.jsx`)

Three tabs, all content-centric:

- **Modules** — list of `pd_modules` rows. Per row: toggle `status` (draft ↔ live), jump to Edit Content.
- **Edit Content** — prose fields on the module (title, tagline, preamble_md) + raw JSON editor for each dimension. Woodstock has its own bespoke `WoodstockEditor`.
- **Preview** — renders the module the way a teacher sees it.

No views for: users, schools, assignments, invites, quiz analytics across schools, subscription/access control, audit log.

### 1b. Admin (`/admin` → `AdminDashboard.jsx`)

Views: `overview`, `users`, `assign`, `analytics` (plus the invite batch / action-items flows).

The **Assign** form is the specific thing Mark flagged:

```
Module: <select from MODULE_META (filters out in-dev)>
Assign to: [ Teachers only ] [ Parents only ] [ Everyone ]
Due date: <optional>
```

That `Assign to` control is the bottleneck — it writes `role_target` only. The DB row it produces is `{ school_id, user_id: null, role_target, module_slug, ... }`. There's no affordance for picking an individual user, and no affordance for seeing/removing an existing assignment (the "Currently active" panel is read-only — no × button, no per-user drill-down).

### 1c. Schema (the important part)

`assignments` already supports all three targeting modes:

| Column        | Used for                                              |
|---------------|-------------------------------------------------------|
| `school_id`   | Required — scopes the assignment                      |
| `user_id`     | **If set → targets that individual**                  |
| `role_target` | `teacher` / `parent` / `all` — used when `user_id` null |
| `module_slug` | Which module                                          |
| `due_date`    | Optional                                              |
| `assigned_by` | Audit                                                 |

And `getAssignments(userId, schoolId)` already resolves this correctly: it returns any assignment with `user_id = me` OR (`school_id = mine AND user_id IS NULL`). So individual-user targeting is already plumbed end-to-end — it just has no UI.

`profiles.role` now accepts `'teacher' | 'admin' | 'parent' | 'superadmin'` (constraint added by `superadmin_role.sql`). RLS on `pd_*` content tables gives superadmins full bypass.

---

## 2. What's missing / clunky

### Admin side

1. **No individual-user assignment.** Must pick a role bucket. "Assign Woodstock to these three counselors only" is impossible from the UI.
2. **No way to remove an assignment.** The "Currently active" list shows them but has no unassign button.
3. **No drill-down from a user.** `users` view lists people but you can't click one to see "what are they assigned, what's their progress, remove X."
4. **No drill-down from an assignment.** You can't click an assignment to see "who actually got this, who's done, who hasn't started."
5. **Assignment dedup is weak.** Nothing stops me clicking Assign twice and creating two rows for the same (school, role, module).

### Superadmin side

1. **No user management.** Can't see who exists across schools, can't promote/demote, can't see eschoonard without SQL.
2. **No school management.** `schools` table is invisible in the app. Can't create, rename, see totals.
3. **No cross-school assignment.** Can't say "assign Woodstock to every user at Woodstock School." Superadmins can technically write to `assignments` (RLS allows it for role='superadmin' — see the `Fix RLS for assignments admin and superadmin` SQL) but there's no UI.
4. **No access controls.** Can't say "this school only sees India + Woodstock." Every live module is visible to every school right now.
5. **No audit log.** Who changed what content, when. This matters the moment there are >1 superadmin.
6. **No nav button to `/superadmin`.** Admin gets a button in TopBar; superadmin has to know to type the URL. Esther will hit this tomorrow.

### Shared

1. **No search.** Users view and assignments view both need to scale past ~50 rows.
2. **No batch actions.** "Unassign this module for these 12 people" → not possible.
3. **Mobile admin is unusable.** Dense tables, no responsive treatment.

---

## 3. Proposed build order

I'd ship these as discrete PRs so each is testable. Every item below is scoped to fit in one sitting.

### Ship-this-week (unblocks Esther, unblocks real customers)

1. **Superadmin nav button in TopBar.** One line. Show a second button when `isSuperAdmin`. (Fixes the "I can't find the superadmin page" onboarding problem that Esther will hit.)
2. **Add individual-user target to the admin Assign form.** A fourth radio: `Specific users`, which reveals a multi-select of the school's users. Writes `user_id` per selection. One `createAssignment` call per user.
3. **Add × remove button to the "Currently active" assignments list.** One `deleteAssignment(id)` supabase helper + a click handler + a confirm.

### Next (drill-downs — this is where Mark's "click on the individual user or school and remove modules" lives)

4. **User detail drawer in admin.** Click a user in the Users view → side drawer shows their profile, their assignments (with × to unassign), their completion progress. No navigation, just a drawer.
5. **School management view in superadmin.** New tab: `Schools`. List of schools with member count + assignment count. Click → drawer with users + current assignments + "Assign module to whole school" button.
6. **Superadmin Assignments tab.** Same form as admin but with a school picker at the top (so superadmin can assign cross-school).

### Nice-to-have (polish)

7. **Dedup guard on createAssignment.** Upsert on `(school_id, user_id, role_target, module_slug)`.
8. **Search + filter on Users view.** Plain `filter().toLowerCase().includes()` — low cost, high value.
9. **Audit log.** A `content_audit` table + a read-only Superadmin tab showing last 100 edits.
10. **Responsive admin layout.** Collapse tables to cards below ~720px.

### Don't-build-yet (but name explicitly so they don't get forgotten)

- **Per-school module access control.** Requires schema work (`school_modules` join table) and a visibility check in `Dashboard.jsx`. Punt until a customer actually asks for it.
- **Role-change UI.** Promoting a user to admin/superadmin should stay SQL-only for now. Keep the blast radius small.

---

## 4. Concretely: the 3 PRs I'd start with

To turn this into code today:

**PR 1 — Superadmin nav button + remove-assignment**
- `TopBar.jsx`: add `{ key: 'superadmin', label: 'Superadmin', path: '/superadmin' }` when `isSuperAdmin`.
- `lib/supabase.js`: add `deleteAssignment(id)`.
- `AdminDashboard.jsx`: add × to each row in the "Currently active" panel.

**PR 2 — Individual user targeting**
- `AdminDashboard.jsx`: add `'users'` to the `roleTarget` options; conditionally render a multi-select of school members when selected.
- `createAssignment` call becomes a loop over user ids.
- Show these as "→ Sarah Chen" pills in the "Currently active" panel.

**PR 3 — User detail drawer**
- New component `UserDrawer.jsx`.
- Wire into the existing `users` view: click row → open drawer.
- Drawer shows: full name, email, role, school, assignments (with ×), completion table.

---

## 5. Out-of-band: what Esther needs to know

- She's now `role = 'superadmin'` in `profiles` — confirmed via SQL.
- When she logs into habterra.com, she'll see an **Admin** button in the top bar (because `isAdmin = role === 'admin' || role === 'superadmin'`).
- Until PR 1 ships, the Superadmin content editor is only reachable by typing **`https://www.habterra.com/superadmin`** directly.
- If she logged in before the role promotion, she needs to sign out and back in (or hard-refresh) to pick up the new role — the profile is loaded once per session.
