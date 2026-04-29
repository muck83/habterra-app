# Habterra — Supabase auth email templates

All six templates Supabase ships for email auth, redrafted in the Habterra brand. Role-neutral where possible so a single template serves teachers, parents, counselors, and admins.

## How to install

Each block below corresponds to one slot in **Supabase dashboard → Authentication → Email Templates**. For each slot:

1. Paste the suggested **Subject** into the subject field.
2. Paste the HTML body into the message field.
3. Save.

Supabase renders the templates as Go templates. Variables used here: `{{ .ConfirmationURL }}`, `{{ .Token }}`, and `{{ .SiteURL }}`. All are provided by Supabase at send time.

## Brand reference

Keep these consistent across every template so the emails feel like one product.

| Token            | Value     | Used for                                    |
|------------------|-----------|---------------------------------------------|
| Canvas           | `#F8F6F1` | Outer background                            |
| Card             | `#ffffff` | Inner card                                  |
| Card border      | `#E8E2D6` | 1px card border + horizontal rule           |
| Accent           | `#7B302E` | Eyebrow, button, link                       |
| Heading text     | `#1C1814` | H1                                          |
| Body text        | `#4A4541` | Paragraph copy                              |
| Muted text       | `#8A8379` | Fallback URL hint + footer                  |
| Type stack       | `-apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif` | Everything |
| Container width  | 560px     | Card                                        |

---

## 1. Confirm signup

**Supabase slot:** Confirm signup
**Subject:** Confirm your Habterra account

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · Confirm your email</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">Welcome to Habterra</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 14px 0;">
          Thanks for signing up. Confirm your email address to activate your account and open the modules, guides, and tools your school has assigned to you.
        </p>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 28px 0;">
          This link expires in 24 hours.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: #7B302E; color: #ffffff; text-decoration: none; padding: 13px 30px; border-radius: 8px; font-size: 14px; font-weight: 600; letter-spacing: 0.02em;">Confirm email</a>
        </div>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; margin: 0 0 6px 0;">
          Or paste this link into your browser:
        </p>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; word-break: break-all; margin: 0 0 24px 0;">
          <a href="{{ .ConfirmationURL }}" style="color: #7B302E; text-decoration: underline;">{{ .ConfirmationURL }}</a>
        </p>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          If you didn't create a Habterra account, you can ignore this email — no account is created until you confirm.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## 2. Invite user

**Supabase slot:** Invite user
**Subject:** You've been invited to Habterra

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · School Invitation</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">You've been invited</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 14px 0;">
          Your school has added you to Habterra — a cultural-readiness platform for international school communities. When you sign in, you'll see the modules, guides, and tools your administrator has tailored to your role.
        </p>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 28px 0;">
          Click below to set your password and sign in. The link expires in 24 hours.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: #7B302E; color: #ffffff; text-decoration: none; padding: 13px 30px; border-radius: 8px; font-size: 14px; font-weight: 600; letter-spacing: 0.02em;">Accept invitation &amp; sign in</a>
        </div>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; margin: 0 0 6px 0;">
          Or paste this link into your browser:
        </p>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; word-break: break-all; margin: 0 0 24px 0;">
          <a href="{{ .ConfirmationURL }}" style="color: #7B302E; text-decoration: underline;">{{ .ConfirmationURL }}</a>
        </p>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          This invitation was sent by your school's administrator. If you weren't expecting it, you can ignore this email — no account is created until you click the link.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## 3. Magic Link

**Supabase slot:** Magic Link
**Subject:** Your Habterra sign-in link

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · Sign-in link</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">Your sign-in link</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 14px 0;">
          You asked to sign in to Habterra. Click below to continue — no password needed.
        </p>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 28px 0;">
          The link is single-use and expires in 1 hour.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: #7B302E; color: #ffffff; text-decoration: none; padding: 13px 30px; border-radius: 8px; font-size: 14px; font-weight: 600; letter-spacing: 0.02em;">Sign in to Habterra</a>
        </div>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; margin: 0 0 6px 0;">
          Or paste this link into your browser:
        </p>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; word-break: break-all; margin: 0 0 24px 0;">
          <a href="{{ .ConfirmationURL }}" style="color: #7B302E; text-decoration: underline;">{{ .ConfirmationURL }}</a>
        </p>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          If you didn't ask for this link, you can ignore this email — your account is safe.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## 4. Change Email Address

**Supabase slot:** Change Email Address
**Subject:** Confirm your new Habterra email

Note: Supabase sends this to the **new** email address. It only needs confirmation from the new mailbox to complete the change.

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · Email change</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">Confirm your new email</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 14px 0;">
          A request was made to change your Habterra sign-in email to this address. Confirm the change to finish updating your account.
        </p>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 28px 0;">
          This link expires in 24 hours.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: #7B302E; color: #ffffff; text-decoration: none; padding: 13px 30px; border-radius: 8px; font-size: 14px; font-weight: 600; letter-spacing: 0.02em;">Confirm new email</a>
        </div>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; margin: 0 0 6px 0;">
          Or paste this link into your browser:
        </p>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; word-break: break-all; margin: 0 0 24px 0;">
          <a href="{{ .ConfirmationURL }}" style="color: #7B302E; text-decoration: underline;">{{ .ConfirmationURL }}</a>
        </p>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          If you didn't request this change, ignore this email and tell your school administrator — the change won't take effect without confirmation.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## 5. Reset Password

**Supabase slot:** Reset Password
**Subject:** Reset your Habterra password

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · Password reset</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">Reset your password</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 14px 0;">
          Click below to set a new password for your Habterra account. Your current password stays active until you finish the reset.
        </p>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 28px 0;">
          This link expires in 1 hour.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <a href="{{ .ConfirmationURL }}" style="display: inline-block; background: #7B302E; color: #ffffff; text-decoration: none; padding: 13px 30px; border-radius: 8px; font-size: 14px; font-weight: 600; letter-spacing: 0.02em;">Reset password</a>
        </div>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; margin: 0 0 6px 0;">
          Or paste this link into your browser:
        </p>
        <p style="font-size: 12px; line-height: 1.6; color: #8A8379; word-break: break-all; margin: 0 0 24px 0;">
          <a href="{{ .ConfirmationURL }}" style="color: #7B302E; text-decoration: underline;">{{ .ConfirmationURL }}</a>
        </p>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          If you didn't request a password reset, ignore this email. Your current password will continue to work.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## 6. Reauthentication

**Supabase slot:** Reauthentication
**Subject:** Your Habterra verification code

Note: Reauthentication uses a short-lived OTP code (`{{ .Token }}`) rather than a clickable link. The template displays the code in a large monospace block instead of a button.

```html
<table width="100%" cellpadding="0" cellspacing="0" style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: #F8F6F1; padding: 32px 0;">
  <tr><td align="center">
    <table width="560" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 12px; padding: 40px 44px; border: 1px solid #E8E2D6;">
      <tr><td>
        <div style="font-size: 11px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; color: #7B302E; margin-bottom: 14px;">Habterra · Verification code</div>
        <h1 style="font-size: 22px; font-weight: 700; color: #1C1814; margin: 0 0 16px 0; line-height: 1.3;">Your verification code</h1>
        <p style="font-size: 15px; line-height: 1.65; color: #4A4541; margin: 0 0 20px 0;">
          Enter this code in Habterra to verify it's you. The code expires in 10 minutes.
        </p>
        <div style="text-align: center; margin: 0 0 28px 0;">
          <div style="display: inline-block; background: #F8F6F1; border: 1px solid #E8E2D6; border-radius: 8px; padding: 18px 32px; font-family: 'SFMono-Regular', Menlo, Consolas, monospace; font-size: 28px; font-weight: 700; letter-spacing: 0.2em; color: #1C1814;">
            {{ .Token }}
          </div>
        </div>
        <hr style="border: none; border-top: 1px solid #E8E2D6; margin: 24px 0;">
        <p style="font-size: 12px; line-height: 1.55; color: #8A8379; margin: 0;">
          If you didn't request this code, someone may be trying to access your account. Contact your school administrator.
        </p>
      </td></tr>
    </table>
    <p style="font-size: 11px; color: #8A8379; margin: 16px 0 0 0;">Habterra · <a href="https://habterra.com" style="color: #8A8379;">habterra.com</a></p>
  </td></tr>
</table>
```

---

## Testing checklist

After pasting each template into Supabase:

- [ ] Trigger the flow (invite a test user, request a reset, etc.) against a real inbox and confirm the email renders correctly in Gmail (web + mobile) and Outlook.
- [ ] Confirm the button contrasts correctly in dark mode (some clients invert light backgrounds; the `#7B302E` accent on white card should survive).
- [ ] Confirm the fallback URL line wraps cleanly on narrow viewports.
- [ ] Click the link and confirm the landing page on habterra.com matches the flow (e.g., reset-password template should redirect to the set-password page, not the login page).
- [ ] Verify the "if you didn't request this" copy doesn't create anxiety (no threatening language, no vague "account compromised" claims).

## If you want role-aware copy later

Supabase email templates support Go conditionals against custom data passed to auth calls. The `invite-user` edge function already forwards `role`. If you later want the invite eyebrow to vary by role, the pattern is:

```
{{ if eq .Data.role "parent" }}Parent Guide{{ else if eq .Data.role "teacher" }}Professional Development{{ else if eq .Data.role "admin" }}Admin Access{{ else }}School Invitation{{ end }}
```

Keep the rest of the template role-neutral so one HTML body covers every recipient.
