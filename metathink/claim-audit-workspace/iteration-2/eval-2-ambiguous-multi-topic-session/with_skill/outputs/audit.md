Three topics are genuinely active in this session and an audit that covers all of them would be too noisy to be useful. Which one should I audit?

- **A. Billing flaky test** — `billing/invoice.spec.ts` 'prorates mid-cycle upgrades' failing 3/10.
- **B. Auth middleware refactor** — `src/auth/middleware.ts` extracting the token resolver; session-renewal coverage risk.
- **C. Audit log sprint-14 regression** — `src/audit/` changes from sprint 14 that must not regress.

Reply with A, B, C, or "all three" and I'll produce the audit.
