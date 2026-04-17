# Status Dashboard Rendering Guide

**When to use:** Checkpoints, progress review, "where are we?". The user needs orientation
on what's been decided and what remains.

**Data source:** Decided items, undecided items, active discussion from state file.

**Structure:** Three columns — Decided (green), In Discussion (yellow), Undecided (gray).
Each item shows a brief label. The currently active topic is highlighted.

## Layout

Three-column CSS grid layout with items as cards.

```html
<div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
  <div>
    <h2 class="decided">Decided</h2>
    <!-- Cards for each decided item -->
  </div>
  <div>
    <h2 class="active">In Discussion</h2>
    <!-- Cards for active topics -->
  </div>
  <div>
    <h2 class="undecided">Undecided</h2>
    <!-- Cards for undecided items -->
  </div>
</div>
```

Use `max-width: 960px` with `margin: 0 auto`. Responsive: collapse to single column below 700px.

## Card Content

Each card shows:
- **Title** with status tag (결정/논의 중/미결정)
- **Decision or options** — chosen value for decided items, option pills for undecided
- **Relation hint** — which other items this connects to (e.g., "Frontend에서 의존")
- **NEW badge** on recently decided items

## Progress Bar

Include a segmented progress bar at the top:
- Green segment: decided percentage
- Yellow segment: in-discussion percentage
- Gray segment: undecided percentage
- Labels below showing counts (e.g., "3 결정됨 · 1 논의 중 · 3 미결정")
- Summary text: "N개 항목 중 M개 결정"

## Active Item Highlight

The currently discussed item gets:
- Yellow border (`border-color: #facc15`)
- Subtle glow (`box-shadow: 0 0 12px rgba(250, 204, 21, 0.1)`)
- Pulsing status indicator dot (CSS `@keyframes pulse`)

## Decision Order (Optional)

When the state file has dependency relations between undecided items, add a "권장 결정 순서"
section at the bottom showing the recommended sequence as a horizontal flow:
`① API 구조 → ② 배포 전략 → ③ CI/CD → ④ 모니터링`

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- Cards in sparsely populated columns (e.g., 1 item in "논의 중") can look visually
  light. Consider min-height on columns or centering the single card vertically.
