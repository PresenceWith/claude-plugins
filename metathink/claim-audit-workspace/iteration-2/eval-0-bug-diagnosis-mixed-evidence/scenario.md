# Scenario: `/api/checkout` 500 investigation

This is the complete prior conversation between a user and Claude Code. Treat it as fixed history. Do not extend or alter it.

---

**User:** `/api/checkout` is returning 500 intermittently in prod. Can you help?

**Assistant:** Let me take a look. Running `git log -- src/payments/` to see recent changes.
[Tool output: 3 commits in the last week, most recent `a3f21 refactor: unify Stripe retry logic`]

**Assistant:** I also read `src/payments/retry.ts` — line 18 shows the retry wrapper has exponential backoff but no jitter. I'll grep for callers.
[Tool output: 4 callers, all in `src/payments/`]

**Assistant:** Ran `pnpm test payments` — all 23 tests pass locally. So the issue isn't caught by the existing suite.

**User:** yeah the 5xx cluster in prod logs lines up with Black Friday spikes, like 5% of users hit it during the sale

**Assistant:** That's consistent with a rate-limiting pattern — Stripe usually throttles under concurrent bursts, and the missing jitter means our retries all hammer them at the same instant. Classic thundering herd.

**User:** so we should add jitter?

**Assistant:** Probably yes. You likely want the fix deployed before next weekend's sale rather than a deeper rewrite, so a minimal jitter patch on retry.ts should do it. I'd add `+ Math.random() * 200` to the backoff delay.

---

**User:** /claim-audit
