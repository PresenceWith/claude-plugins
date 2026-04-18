# claim-audit — Iteration 2 Benchmark

## Summary

| Configuration | Pass rate | Mean duration | Mean tokens |
|---|---|---|---|
| **with_skill** | **39/40 (97.5%)** | 29.9s ± 10.7 | 29,788 ± 836 |
| without_skill (baseline) | 24/40 (60.0%) | 37.6s ± 1.3 | 26,038 ± 114 |
| **Delta** | **+37.5 pp** | **−7.6s (faster)** | +3,750 (+14.4%) |

## Per-eval

| Eval | with_skill | without_skill |
|---|---|---|
| 0 — bug-diagnosis-mixed-evidence | 15/16 | 9/16 |
| 1 — feature-design-thin-evidence | **17/17** ✓ | 9/17 |
| 2 — ambiguous-multi-topic-session | **7/7** ✓ | 6/7 |

## What changed from iteration 1

### Assertion set expanded and hardened
- **Iter-1**: 10+10+4 = 24 assertions, heavily structural.
- **Iter-2**: 16+17+7 = 40 assertions adding:
  - Hedge-word demotion check ("usually", "probably", "presumably" → Inference)
  - Agreement-scope disambiguation ("sounds reasonable" must pin down what was actually endorsed)
  - Specific tests that pattern-based proposals (three-channel model, notifications table, index) stay out of Facts
  - Length discipline (~30 bullets)
  - Empty-sub-section omission
  - Meta-claim exclusion
  - De-duplication
  - Correct grep-vs-file-read classification (Observed vs Verified)

### SKILL.md refined with three new sections
- **"Hedge words are a giveaway"** — explicit list of trigger words and demotion rule.
- **"Don't conflate scope of agreement"** — pin down what "sounds reasonable" actually endorsed.
- **"Make the verification action small and specific"** — GOOD/BAD examples, 1-minute executability bar.

## Where the skill wins on the new assertions

1. **Hedge-word demotion**: with_skill explicitly called out the "usually" hedge on the Stripe rate-limit claim and placed it under Pattern-based. Baseline also placed it in inferences but without the meta-commentary that ties it to the hedge word.
2. **Agreement-scope disambiguation** (eval-1): with_skill's entry line 30 — "The user's 'sounds reasonable' endorsed the full four-column schema. Verify: re-confirm... the reply literally scoped to 'we're on Postgres so that's fine'" — directly implements the new rule.
3. **Proposal-vs-fact distinction** (eval-1): baseline failed by listing "the assistant proposed X" entries under Facts. This is the exact epistemic slippage the skill is designed to block. with_skill kept all proposals in Hypothesis.

## The one remaining with_skill failure

Eval-0 with_skill placed "4 callers, all in `src/payments/`" under **Verified** when it should be **Observed** (the evidence was `grep` output, a command result). The skill's Verified-vs-Observed definitions are technically clear but the subagent treated "grep on code" as close enough to "reading code." A future refinement could add a one-line clarification: *"Any result that came from running a command — including grep, find, ls, git — is Observed. Verified is reserved for opening a file and reading its contents directly."*

## Timing / tokens

- with_skill is faster on average despite producing a more structured output — driven by eval-2, where asking "which topic?" is much shorter than writing a full audit (18.2s vs 38.7s).
- Token overhead is modest (~14%) for a substantially better-structured output with actionable per-item verifications.

## Observations

- No evidence fabrication on any run — the scenario-file approach remains reliable.
- The skill's "Omit empty sub-sections" rule is respected: eval-1 with_skill only shows Facts/Stated (no empty Verified/Observed headers).
- Eval-2's "ask instead of audit" behavior is now textbook, matching the skill's multi-topic guidance exactly.
