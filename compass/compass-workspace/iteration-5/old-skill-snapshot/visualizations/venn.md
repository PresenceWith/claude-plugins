# Venn Diagram Rendering Guide

**When to use:** Showing overlap, shared properties, scope boundaries. The conversation involves
"difference between X and Y", "what's common?", or defining scope of two competing approaches.

**Data source:** Elements grouped into 2-3 sets, with shared elements placed in overlapping regions.

**Structure:** 2-3 overlapping circles with items placed in the appropriate regions.

## Layout

Use SVG. Position 2-3 large circles with calculated overlap.

- **2 circles:** Side by side, overlapping ~30% in the center
- **3 circles:** Classic triangular arrangement, each pair overlapping

Circle sizing: radius 150-200px depending on content. Adjust overlap
to give enough room for items in the intersection.

## Circle Styling

- Each circle: distinct color at low opacity (`fill-opacity: 0.1`), solid stroke at full color
- Circle labels: positioned at the top or outer edge of each circle, bold, in the circle's color
- Overlap regions naturally blend colors due to opacity stacking

## Item Placement

- Items unique to one set: placed in the non-overlapping area of that circle
- Items shared between two sets: placed in the overlap region
- Items shared by all sets: placed at the center intersection
- Use small cards or text labels, positioned to avoid overlap with each other

## Region Labels

For clarity, label each region:
- "A만" (only in A)
- "A ∩ B" (shared by A and B)
- "A ∩ B ∩ C" (shared by all)

Use muted text as region labels, positioned to not interfere with item labels.

## Annotations

When the purpose is scope definition (e.g., "MVP vs Full Product"), add:
- A dashed outline around the "selected scope" region
- A label like "MVP 범위" on the outline

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
