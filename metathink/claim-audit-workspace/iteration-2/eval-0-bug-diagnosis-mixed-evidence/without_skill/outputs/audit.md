# Fact vs. Inference: `/api/checkout` 500 Investigation

Separating what we actually know from what we've inferred about the current topic (the intermittent 500s on `/api/checkout` and the proposed jitter fix).

---

## Facts (directly established in the conversation)

These come from explicit user statements or tool output observed so far.

- **Reported symptom:** `/api/checkout` is returning 500s intermittently in production. *(user statement)*
- **Recent code activity:** `git log -- src/payments/` shows 3 commits in the last week, with the most recent being `a3f21 refactor: unify Stripe retry logic`. *(tool output)*
- **Retry implementation detail:** In `src/payments/retry.ts`, line 18, the retry wrapper uses exponential backoff with no jitter. *(observed from reading the file)*
- **Caller scope:** A grep found 4 callers of the retry wrapper, all within `src/payments/`. *(tool output)*
- **Local test status:** `pnpm test payments` passes all 23 tests locally. *(tool output)*
- **Production timing correlation:** The 5xx cluster in prod logs lines up with Black Friday traffic spikes. *(user statement)*
- **Production error rate:** Roughly 5% of users hit the error during the sale. *(user statement)*

---

## Inferences / Assumptions (not yet verified)

These are plausible claims the assistant made, but they go beyond what the evidence in the conversation actually establishes.

- **Cause attribution — rate limiting:** The claim that the 500s are caused by Stripe throttling/rate-limiting under concurrent bursts. The traffic-spike correlation is consistent with this, but consistency is not confirmation. No Stripe error codes, response bodies, or prod log lines have actually been examined in the conversation.
- **Thundering herd mechanism:** The claim that the missing jitter is causing retries to hammer Stripe "at the same instant." This is a mechanism hypothesis — it follows logically from "no jitter" but hasn't been demonstrated against real retry timing data.
- **Causal link between the recent refactor and the bug:** The recent `a3f21 refactor: unify Stripe retry logic` commit is suggestive, but nothing in the conversation shows the bug began after that commit, nor that the commit introduced the lack of jitter (it may have always been absent).
- **Test suite relevance:** "The issue isn't caught by the existing suite" assumes the existing suite *should* be able to catch it. A concurrency/rate-limit issue under real Stripe load is the kind of thing unit tests typically can't catch, so the passing tests don't really tell us much either way.
- **That the proposed fix will resolve the 500s:** Adding `+ Math.random() * 200` to the backoff delay is being recommended as *the* fix, but this assumes the rate-limiting-plus-thundering-herd theory is correct. If the real cause is something else (e.g., a timeout, a downstream dependency, a bug introduced in the refactor unrelated to jitter), jitter will not help.
- **That 200ms of jitter is the right magnitude:** The specific value `Math.random() * 200` is a guess. Appropriate jitter magnitude depends on Stripe's rate-limit window, our concurrency, and retry count — none of which have been measured.
- **Urgency framing:** "You likely want the fix deployed before next weekend's sale" is an assumption about the user's deployment timeline and risk tolerance; the user hasn't stated a deadline.
- **Preference for minimal patch over deeper rewrite:** Same — the user hasn't expressed a preference between a quick patch and a more thorough fix.

---

## Notable gaps (things we'd want before committing to the fix)

- The actual error messages / status codes from the 500 responses (are they Stripe 429s? Timeouts? Something else entirely?).
- Whether the bug predates or postdates commit `a3f21`.
- What the retry count and current backoff schedule look like in `retry.ts` beyond the "no jitter" observation.
- Whether the 5% error rate is concentrated in retries specifically, or also hitting first-attempt requests.
- Stripe's side of the story — any correlated alerts, rate-limit headers, or support signal.

---

## Short version

**We know:** 500s are intermittent in prod, correlate with Black Friday spikes, hit ~5% of users; `retry.ts` line 18 has exponential backoff without jitter; local tests pass; a recent commit refactored Stripe retry logic.

**We're inferring:** that the cause is a Stripe-rate-limit thundering herd, that jitter will fix it, and that `Math.random() * 200` is the right amount. None of those have been verified against production data yet.
