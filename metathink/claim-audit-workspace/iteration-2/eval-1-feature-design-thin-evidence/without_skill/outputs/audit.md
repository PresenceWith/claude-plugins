# Fact vs. Inference: Notifications System Design

Current topic: designing a notifications system for the user's app. Below, I separate what has actually been stated in the conversation (facts) from what has been inferred, assumed, or proposed as a default pattern.

---

## Facts (explicitly stated in the conversation)

These are claims grounded directly in what the user or assistant said.

### From the user
- The user wants to add a notifications system to their app.
- The user wants users to "get pinged when important stuff happens."
- The app uses **Postgres** as its database.
- The app uses **Sidekiq** as its existing job/queue infrastructure.
- The user agreed with the three-channel framing ("sounds reasonable") after the assistant introduced it — though their explicit confirmation was scoped to the Postgres point.
- The user asked to start with the schema.

### From the assistant (claims the assistant itself stated)
- The assistant proposed splitting notifications into three channels: in-app, email, push.
- The assistant proposed a `notifications` table with columns `user_id`, `type`, `payload`, `read_at`.
- The assistant proposed a preferences table keyed on `user_id × type`.
- The assistant proposed an index on `(user_id, read_at)` where `read_at` is null.
- The assistant recommended reusing Sidekiq for delivery.

---

## Inferences, assumptions, and unverified claims

These are things the assistant asserted or implied without evidence in the conversation.

### Assumptions about the app / organization
- That the app is a **"mid-size SaaS"** — the user never characterized the app this way.
- That users should receive notifications across **in-app, email, and push** channels — the user only said "pinged when important stuff happens"; no channel was specified by the user.
- That **in-app is the right starting point** ("lowest-friction") — framed as a generic best practice, not derived from anything the user said.
- That the user wants **an unread badge in the header** — introduced by the assistant with "presumably you want," explicitly flagged as an assumption even in the original text.
- That users need per-type notification preferences — presented as a need ("you'll also want…") rather than something the user requested.

### Assumptions about technical constraints
- That a **slow email send would block the request path** without a queue — a general claim about web request handling, not something verified against this specific app's architecture.
- That a queue-backed worker is the right delivery pattern here — stated as "the standard pattern," i.e., an appeal to convention rather than evidence from this codebase.
- That Sidekiq is suitable for this use case — assumed rather than checked (e.g., current Sidekiq version, queue configuration, existing job patterns are all unknown).

### Schema-level inferences
- The specific columns `user_id`, `type`, `payload`, `read_at` — proposed defaults, not derived from any stated requirements (e.g., we don't know if the app needs delivery timestamps, channel tracking, grouping/threading, expiry, actor IDs, etc.).
- That `payload` should be a single column (vs. structured fields or a separate table) — implicit design choice.
- That `read_at` semantics (timestamp rather than boolean) are desired — assumed.
- The index shape `(user_id, read_at) WHERE read_at IS NULL` — assumes the unread-badge use case is real and that this is the hottest query; neither has been confirmed against actual usage.
- That preferences should be keyed **only** on `user_id × type` (not, e.g., `user_id × type × channel`) — an assumption, especially given the three-channel framing.

### Things that are genuinely unknown
- What "important stuff" means in this app — no event types, triggers, or volume estimates have been given.
- Which of the three channels (in-app / email / push) are actually in scope.
- Whether there is already any notifications-adjacent code, model, or table.
- Scale: number of users, expected notifications/day, retention needs.
- Whether the app has an existing header UI, and whether an unread badge is desired there.
- Whether email infrastructure exists (SMTP, transactional provider, templates).
- Whether push infrastructure exists (APNs/FCM, device token storage).
- Read-model needs: real-time updates (WebSocket/ActionCable), polling interval, etc.
- Multi-tenancy: whether notifications are user-scoped only or also org/team-scoped.

---

## Summary

**What we actually know:** the user wants notifications, uses Postgres, and uses Sidekiq. They've asked to start with the schema.

**What has been assumed and is now baked into the design under discussion:** the three-channel model, in-app as the starting point, the specific `notifications` table shape, a `user_id × type` preferences table, an unread-badge UI requirement, and the partial index design. Each of these is a reasonable default but none has been confirmed by the user or grounded in observed code.

**Recommended next step before writing the schema:** confirm with the user (a) which channels are actually in scope, (b) whether the unread-badge assumption is correct, (c) what the initial set of notification types / trigger events is, and (d) whether there is any existing notifications-related code to reconcile with.
