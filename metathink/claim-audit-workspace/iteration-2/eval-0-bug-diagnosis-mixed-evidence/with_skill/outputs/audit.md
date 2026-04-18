## Fact vs. Inference Audit — `/api/checkout` 500 intermittent in prod

### Facts
**Verified**
- The retry wrapper around Stripe calls uses exponential backoff but has no jitter — `src/payments/retry.ts:18`
- There are 4 callers of the retry wrapper, all within `src/payments/` — from grep for callers

**Observed**
- Three commits landed in `src/payments/` in the last week; most recent is `a3f21 refactor: unify Stripe retry logic` — from `git log -- src/payments/`
- `pnpm test payments` passes all 23 tests locally — from `pnpm test payments`

**Stated**
- `/api/checkout` returns 500 intermittently in prod — user: "`/api/checkout` is returning 500 intermittently in prod"
- The 5xx cluster in prod logs lines up with Black Friday spikes, hitting ~5% of users during the sale — user: "the 5xx cluster in prod logs lines up with Black Friday spikes, like 5% of users hit it during the sale"

### Inferences
**Hypothesis**
- The 500s are caused by a thundering-herd pattern: Stripe rate-limits under concurrent bursts, and the missing jitter makes all retries hammer it at the same instant
  - **Verify:** pull a sample of the prod 5xx responses during a Black Friday spike and inspect upstream Stripe status codes / headers (e.g., 429, `Retry-After`); confirm 5xx cluster timestamps coincide with synchronized retry bursts from the wrapper. The hypothesis holds if Stripe 429s (or equivalent throttle signals) dominate right before the 500s.
- Adding `+ Math.random() * 200` to the backoff delay in `retry.ts` will resolve the intermittent 500s
  - **Verify:** apply the jitter patch on a branch, then replay a recorded Black Friday-like load against staging (or a load-test harness) and confirm the 5xx rate drops to baseline; also add a unit/integration test that exercises concurrent retries so the regression is caught by `pnpm test payments`.

**Pattern-based**
- Stripe "usually" throttles under concurrent bursts (i.e., this is a generic thundering-herd story, not a project-specific observation)
  - **Verify:** check the project's own prod logs / Stripe dashboard for actual 429 or rate-limit responses from Stripe during the Black Friday window; if they're absent, the rate-limit framing is unsupported for this codebase.
- A minimal jitter patch is the right shape of fix vs. a deeper rewrite
  - **Verify:** read the other 3 callers of the retry wrapper in `src/payments/` to confirm none of them bypass or wrap the backoff in a way that would make a jitter-only change insufficient.

**Intent-inferred**
- The user wants the fix deployed before next weekend's sale rather than a deeper rewrite
  - **Verify:** ask the user directly — "is the goal a hotfix before next weekend's sale, or are you open to a broader refactor of the retry path?"
- The user's "so we should add jitter?" is a request for a recommendation, not already-granted approval to ship the patch
  - **Verify:** ask the user — "do you want me to open a PR with the jitter patch now, or review the diagnosis first?"

### Assumptions
- The recent `a3f21 refactor: unify Stripe retry logic` commit is related to (or introduced) the current 500s
  - **Verify:** read the diff of `a3f21` and check whether it changed the backoff/jitter behavior or retry concurrency vs. the prior implementation; also check whether the 5xx onset in prod aligns with the deploy time of that commit.
- The retry wrapper at `src/payments/retry.ts:18` is actually exercised on the `/api/checkout` code path in prod (i.e., the 500s route through this wrapper at all)
  - **Verify:** trace from the `/api/checkout` handler down to the Stripe call and confirm it goes through the retry wrapper; or add a temporary log/metric at `retry.ts:18` and confirm it fires during a reproduced 500.
- The prod and local environments use the same Stripe SDK / retry code (i.e., the version that passes the 23 local tests is what's running in prod)
  - **Verify:** compare the deployed commit SHA and lockfile `stripe` version against the local working tree.
- "Intermittent 500s" and "5xx cluster during Black Friday" refer to the same incident, not two separate issues
  - **Verify:** ask the user — "is the intermittent 500 you opened with the same cluster you're seeing during the Black Friday spikes, or are there 500s outside that window too?"

### Open questions
- What does Stripe actually return just before the 500 surfaces to the client (429, 5xx from Stripe, timeout)? The current diagnosis pivots on this but no prod response body / status has been cited.
- Is there a reproduction harness (load replay, staging soak) that can confirm a fix before it ships, or will verification have to wait for the next real traffic spike?
