# Flowchart Rendering Guide

**When to use:** Process design, sequential steps, conditional logic. The conversation is about
"what order?", "what steps?", or designing a workflow with decision points.

**Data source:** Elements typed as `process`, `decision`, `step` from the state file,
plus `precedes` and `depends-on` relations.

**Structure:** Start → steps → decision diamonds → branches → end.

## Layout

Use SVG with a top-to-bottom flow. Vertical orientation reads more naturally for processes.

- **Start/End nodes:** Rounded rectangles or stadium shapes (large border-radius)
- **Process steps:** Rectangles with rounded corners (`rx="8"`)
- **Decision points:** Rotated squares (diamonds) — use `transform="rotate(45)"`
- **Arrows:** Vertical/horizontal lines with arrowhead markers, routed to avoid crossing

Keep consistent spacing: 60px vertical gap between steps, 40px horizontal gap between branches.

## Node Styling

- Active/current step: highlighted border color + glow filter
- Completed steps: solid green border, slightly muted fill
- Pending steps: dashed gray border
- Decision diamonds: yellow/amber border to draw attention

Each node contains:
- Step name (bold, 13px)
- Brief description or question for decisions (11px, muted)

## Decision Branches

From a decision diamond, draw two or more labeled branches:
- Label each branch on the arrow (e.g., "Yes" / "No", or the option names)
- Branches that reconverge should merge back into a single flow
- Keep the primary/happy path centered, alternatives branching to the sides

## Arrows

- Main flow: solid stroke, 2px, with arrowhead marker
- Alternative/error paths: dashed stroke, 1.5px
- Use right-angle routing (not diagonal) for clean appearance
- Minimum 3 control points for L-shaped or U-shaped routes

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
