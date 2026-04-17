# Priority Matrix Rendering Guide

**When to use:** Deciding what to do first. The conversation involves prioritization,
"what first?", importance vs effort, or urgency vs impact.

**Data source:** Elements from the state file, positioned by two user-relevant dimensions
(e.g., importance × effort, impact × urgency).

**Structure:** 2×2 grid with items placed in quadrants.

## Layout

Use SVG or HTML/CSS hybrid. The matrix is a square divided into 4 quadrants.

## Quadrant Labels

Standard Eisenhower-style (adapt labels to context):

```
         High Importance
              │
  Do First    │    Plan
  (urgent +   │    (important but
   important) │     not urgent)
──────────────┼──────────────
  Delegate    │    Defer
  (urgent but │    (neither urgent
   not key)   │     nor important)
              │
         Low Importance
```

Each quadrant gets:
- A background color: Do First (green-tint), Plan (blue-tint), Delegate (yellow-tint), Defer (gray-tint)
- A label at the top of the quadrant
- An action hint (e.g., "지금 하기", "계획 세우기", "위임하기", "나중에")

## Item Placement

- Items are small cards/pills placed within their quadrant
- Position reflects relative priority within the quadrant (higher/more-right = higher on both axes)
- Core elements: solid border, larger
- Detail elements: dashed border, smaller

## Axes

- Draw X and Y axes through the center
- Label each axis end (e.g., "긴급 →", "↑ 중요")
- Subtle grid lines or just the two crossing axes

## Interactive (Optional)

If the environment supports it, items could be repositioned via drag.
For static HTML, just place them based on the conversation context.

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
