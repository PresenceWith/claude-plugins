# system-map — Iteration 2 Benchmark

## Headline

| Configuration   | Pass Rate        | Time (s)        | Tokens          |
|-----------------|------------------|-----------------|-----------------|
| **with_skill**  | **1.00 ± 0.00**  | 94.2 ± 10.9     | 36,716 ± 695    |
| without_skill   | 0.08 ± 0.03      | 64.0 ± 13.9     | 26,493 ± 810    |
| **Δ**           | **+0.92**        | +30.2 (+47%)    | +10,223 (+39%)  |

## Per-eval

| Eval | with_skill | without_skill | Δ |
|---|---|---|---|
| 0 — external-org-standup-ritual | 16/16 (1.00) | 1/16 (0.06) | +15 |
| 1 — external-tech-monorepo-ci | 16/16 (1.00) | 2/16 (0.125) | +14 |
| 2 — meta-current-session | 17/17 (1.00) | 1/17 (0.06) | +16 |

## Iter-1 → Iter-2 Comparison

| | Iter-1 | Iter-2 | Change |
|---|---|---|---|
| Total assertions | 25 | 49 | +96% |
| with_skill pass | 25/25 (100%) | 49/49 (100%) | — |
| without_skill pass | 4/25 (16%) | 4/49 (8%) | halved (denominator grew) |
| with_skill time | 68.7s | 94.2s | +37% |
| with_skill tokens | 33.9k | 36.7k | +8% |

## Key Observations

1. **Richer skill, same 100%.** Assertion count nearly doubled (the integrations added 8 new required behaviors per eval), yet the skill still satisfies every criterion. The integrations land without overwhelming the model.

2. **New criteria all pass cleanly**: environment, constraints, positionality, stock/flow, element_count_le_5, delay labels, non-emergent contrast, maintenance mechanism, failure-leverage pairing. These are the iter-2 additions; each appears correctly in every skill run.

3. **Time cost is real**: +30s per call (94s vs 64s baseline, +47%). The three new front-matter sections (경계·환경·관찰자 / 제약 / stock-flow labeling) + richer relation annotation (delay + polarity + reason) cost time. Token overhead is smaller (+39%) because the content is structural, not verbose.

4. **Baseline pass rate halved** (16% → 8%): raising the bar made baseline's gap more visible. The only criterion baseline consistently passed was `observer_effect_acknowledged` on the meta eval — a natural instinct, not a structural discipline.

5. **Meta mode remains the widest gap**: 17/17 vs 1/17. The skill-specific behaviors (boundary-as-chosen-cut, positionality, STEP 7 self-reference capping) are things baseline never produces.

6. **Element count discipline visible**: meta eval's output explicitly notes "사전 개입 규칙은 … STEP 1.5 제약으로 흡수. 5개 초과 방지." The model is following the rule consciously, not accidentally.

7. **Anchor column uniformly hidden**: all 3 skill runs omit the anchor column. The abstraction stays clean without user prompting.

8. **Failure-leverage pairing lands well**: all 3 evals produce 2 paired points, and the meta eval closes with "(지명일 뿐, 처방 아님.)" — honoring the rule that leverage is naming, not prescription.

## Trade-off Summary

Iter-2 is strictly better on quality, worse on cost (+30s/+39% tokens). Given the 12× pass-rate gap and the fact that this is a thinking skill (used for planning/understanding, not in hot loops), the trade-off favors iter-2.
