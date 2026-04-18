# Fact vs. Inference Audit

## Scope note

This session has touched three topics:
1. A flaky test in billing blocking an auth middleware refactor PR
2. The auth middleware refactor itself
3. Audit log changes from sprint 14 that must not regress

The most recently discussed topic — and the one where the assistant made the
least-grounded statement — is the **audit log / sprint 14** thread. But since
the user framed the session as "look at both" (auth + billing) and then added
audit log, this audit covers all three so the fact/inference split is visible
everywhere an assumption was made.

---

## 1. Flaky billing test

### Facts (grounded in observed evidence this session)

- The user reported that the auth middleware refactor PR is blocked by a flaky
  test in billing.
- `pnpm test billing --repeat 10` was run.
- Of those 10 runs, 7 passed and 3 failed.
- All 3 failures were in `billing/invoice.spec.ts`, in the test case labeled
  `'prorates mid-cycle upgrades'`.
- `billing/invoice.spec.ts:84` uses `new Date()` inside the assertion (as stated
  by the assistant after reading the file).

### Inferences / assumptions (not yet verified)

- That the `new Date()` usage is the cause of the flake. The assistant said it
  is "very likely the flake source" — this is a hypothesis based on the code
  being time-sensitive, not a confirmed root cause. The flake has not been
  reproduced-then-fixed to prove causation.
- That `new Date()` at line 84 is the only time-sensitive element in the failing
  case. Other sources of non-determinism in that test were not ruled out.
- That a 7/10 pass rate is fully explained by this one line. The actual failure
  output / error messages from the 3 failing runs were not quoted here.

---

## 2. Auth middleware refactor

### Facts (grounded)

- The user stated the auth middleware refactor PR exists and is blocked by the
  billing flake.
- The assistant "skimmed the PR diff" for `src/auth/middleware.ts`.
- Per that skim: the refactor extracts the token resolver into a separate
  module.

### Inferences / assumptions

- That the session-renewal path is "the main risk." This is the assistant's
  judgment call about where a refactor is most likely to break something — not
  a finding derived from reading tests or running them.
- That session-renewal "may not be covered by tests." The assistant has not
  reported actually checking the test suite for renewal coverage; the wording
  was conditional ("if that's not covered by tests…").
- That the refactor could "silently break renewals." This follows from the
  previous assumption and is itself conditional.
- That no other part of the middleware is at comparable risk. Only the
  renewal path was named; other paths (e.g., initial auth, logout, error
  handling) were not evaluated.

---

## 3. Audit log / sprint 14 (current topic)

### Facts (grounded)

- The user said the audit log changes from sprint 14 must not regress.
- The assistant identified the relevant directory as `src/audit/`.
- The assistant explicitly stated: "I haven't looked at what sprint 14 changed
  there yet."

### Inferences / assumptions

- That `src/audit/` is in fact where the sprint 14 audit log changes live. The
  assistant named the path but has not shown evidence (no file listing, no
  diff, no commit history) confirming sprint 14 touched that directory or only
  that directory.
- That the audit log work is a discrete, self-contained topic separable from
  the auth refactor. Auth middleware changes often interact with audit logging
  (e.g., logging auth events), but no check for coupling has been done.

### Known unknowns for this topic

- What sprint 14 actually changed in the audit log.
- Whether there are existing regression tests for those changes.
- Whether the auth middleware refactor or the billing flake fix would touch
  code paths that feed the audit log.

---

## Summary table

| Claim | Status |
|---|---|
| PR is blocked by a billing flake | Fact (user-reported) |
| 7/10 passes, 3 failures in `billing/invoice.spec.ts` 'prorates mid-cycle upgrades' | Fact (observed test output) |
| `new Date()` appears at `billing/invoice.spec.ts:84` | Fact (assistant read the file) |
| `new Date()` is the cause of the flake | Inference ("very likely") |
| Auth refactor extracts token resolver into a separate module | Fact (from PR diff skim) |
| Session-renewal is the main risk of the auth refactor | Inference |
| Session-renewal lacks test coverage | Inference (stated conditionally) |
| Audit log code lives in `src/audit/` | Inference (asserted without evidence) |
| What sprint 14 changed in the audit log | Unknown — not yet investigated |

---

## Recommended next steps to convert inferences into facts

1. Confirm the billing flake's cause by patching `billing/invoice.spec.ts:84`
   to use a fixed / injected clock and re-running `pnpm test billing --repeat 10`.
   A clean 10/10 run is the evidence needed.
2. For the auth refactor: grep the test suite for coverage of the
   session-renewal path before claiming it's the main risk.
3. For the audit log: look at sprint 14's actual changes (commit history or PR
   list tagged to that sprint) before assuming `src/audit/` is the right and
   only place to watch.
