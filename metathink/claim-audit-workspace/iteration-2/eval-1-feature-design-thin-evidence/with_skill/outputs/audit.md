## Fact vs. Inference Audit — notifications system initial design

### Facts
**Stated**
- The app runs on Postgres — user: "we're on Postgres so that's fine"
- The app already uses Sidekiq for background jobs — user: "we use Sidekiq already"
- The user wants to add a notifications system so users get pinged when important stuff happens — user: "I want to add a notifications system to the app. Users should get pinged when important stuff happens."
- The next step the user asked for is the schema — user: "can you start with the schema?"

### Inferences
**Hypothesis**
- A `notifications` table with columns `user_id`, `type`, `payload`, `read_at` is the right shape for this app
  - **Verify:** ask the user to confirm the exact columns (especially whether `payload` should be `jsonb` vs structured, and whether timestamps beyond `read_at` like `created_at`/`delivered_at` are needed) before writing the migration
- A preferences table keyed on `user_id × type` is needed so users can control which notification types they receive
  - **Verify:** ask the user "do you want per-type opt-in/opt-out in v1, or is that deferred?" before adding the second table
- A partial index on `(user_id, read_at) WHERE read_at IS NULL` will make the unread-count query cheap
  - **Verify:** once the schema exists and there is realistic data, run `EXPLAIN ANALYZE` on the unread-count query with and without the index and compare

**Pattern-based**
- Mid-size SaaS notification systems typically break into three channels: in-app, email, push; in-app is the lowest-friction starting point
  - **Verify:** confirm with the user that in-app is actually the v1 scope (and email/push are explicitly deferred) rather than assuming the canonical breakdown applies here
- A queue-backed worker is the standard pattern for delivery so slow sends do not block the request path
  - **Verify:** confirm with the user that notification dispatch should be enqueued to Sidekiq (not sent inline) — the user endorsed "we use Sidekiq already" but not specifically this dispatch pattern

**Intent-inferred**
- The user wants an unread badge in the header
  - **Verify:** ask the user directly — "is an unread-count badge in the header part of v1 scope, or deferred?" The assistant said "presumably you want..." and the user's "makes sense" is ambiguous about whether it endorsed the badge or just the index reasoning
- The user wants in-app notifications first, with email/push later
  - **Verify:** ask the user to state the v1 channel scope explicitly before designing further
- The user's "sounds reasonable" endorsed the full four-column schema (not just Postgres compatibility)
  - **Verify:** re-confirm the specific columns with the user — the reply literally scoped to "we're on Postgres so that's fine", which only endorses DB compatibility

### Assumptions
- There is a `users` table (or equivalent) that `notifications.user_id` can foreign-key to
  - **Verify:** read the existing schema / migrations to confirm the users table name and primary key type
- The Postgres version in use supports the partial-index syntax being proposed (true for all currently supported Postgres versions, but not stated)
  - **Verify:** ask the user which Postgres major version is in production, or check the deployment config
- "Important stuff" that triggers notifications is a known, enumerable set of event types that belongs in a `type` column
  - **Verify:** ask the user to list the initial notification types for v1 (e.g. mentions, invites, billing) so the `type` column's value domain is defined
- No existing notifications/messaging table already exists in the app
  - **Verify:** search the current schema for tables named like `notifications`, `messages`, `alerts`, `inbox` before adding a new one

### Open questions
- What is the v1 channel scope — in-app only, or also email/push?
- Which notification event types exist in v1?
- Is the unread-count badge in v1 scope?
- Should notification preferences default to opt-in or opt-out per type?
- Does `payload` need a defined shape per `type`, or is an opaque `jsonb` acceptable?
