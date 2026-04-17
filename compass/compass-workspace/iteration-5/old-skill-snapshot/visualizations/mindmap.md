# Mindmap Rendering Guide

**When to use:** Early exploration, brainstorming, divergent thinking. The conversation is expanding
and the user wants to see what's on the table.

**Data source:** Elements from state file, organized by relationship proximity to the goal.

**Structure:** Central node (goal) → primary branches (core elements) → secondary branches (details).

## Layout

Use a radial layout with the goal at center and category groups arranged around it. Connect
nodes with SVG lines drawn dynamically via JavaScript.

Distribute branch groups evenly around the center. If one group has significantly fewer items than
others (e.g., 1 item vs 3), consider merging it with a related group or positioning it in a smaller
angular slice to avoid large empty areas.

## Node Styling

- Core elements: larger, brighter, solid border with category color, glow filter
- Detail elements: smaller, muted, dashed border
- Decided elements: green accent
- Undecided: gray accent
- Hover: `transform: scale(1.05)` with box-shadow transition

## Connector Lines

These are critical for readability — a mindmap with invisible lines is useless.

- Lines must be clearly visible against the `#0f0f1a` background. Use the category color at
  50-70% opacity as the stroke color (e.g., `#6366f1aa`), not near-background grays like `#2a2a4a`.
- Core element lines: `stroke-width: 2.5`. Detail element lines: `stroke-width: 1.5`, `stroke-dasharray: 4 4`.
- Use quadratic Bézier curves (`Q` in SVG path), not straight lines. This prevents line overlap
  at the center point — offset the control point perpendicular to the line direction.
- Color-code lines by their branch category so the user can visually trace which group a line belongs to.

## Cross-Branch Relationships

When the state file shows relations between elements in different branches (e.g., "운동 기록 → 웨어러블 연동"),
render these as distinct visual connections — thin dashed lines in a neutral color (`#ffffff30`) with a
small label at the midpoint. These cross-links are the most valuable part of a mindmap because they
reveal structure that a simple list cannot. Do NOT relegate cross-branch relationships to a text box
at the bottom — show them as lines on the map itself.

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- Cross-link lines at `#ffffff30` can be faint on dark backgrounds. Consider `#ffffff50` or
  using a subtle color distinct from any category (e.g., `#94a3b8` at 50%) for better contrast.
- When there are 8+ branches, 40-degree angular spacing works well. For fewer branches,
  increase spacing proportionally.
