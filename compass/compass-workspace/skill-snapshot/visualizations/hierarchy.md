# Hierarchy Rendering Guide

**When to use:** Classification, component breakdown, information architecture. The conversation
involves "categories", "structure", "what contains what", or decomposing a system.

**Data source:** Elements with `contains` relations from the state file. The root is typically
the goal or the broadest category.

**Structure:** Tree from top (broadest) to bottom (most specific).

## Layout

Use SVG with a top-down tree layout. Each level is a horizontal row of nodes.

- **Root node:** Centered at top, largest, most visually prominent
- **Branch nodes:** Medium size, positioned in rows below
- **Leaf nodes:** Smallest, at the bottom

Vertical spacing: 80px between levels. Horizontal spacing: calculated to avoid overlap —
distribute children evenly under their parent.

## Node Styling

- Root: large rect with gradient fill, bold text, glow filter
- Branch: medium rect with solid category-colored border
- Leaf: small rect with dashed border, muted color
- Decided nodes: solid border, green accent
- Undecided: dashed border, gray accent

Each node shows:
- Name (bold)
- Type label or count of children (small, muted)

## Connectors

- Vertical lines from parent to a horizontal bus line, then down to each child
- This "organization chart" style is cleaner than individual diagonal lines
- Use a consistent connector color (`#4a4a7a`) with 1.5px stroke
- Parent-to-bus: solid. Bus-to-child: solid.

```
     [Parent]
        │
    ┌───┼───┐
    │   │   │
  [A] [B] [C]
```

## Collapsible Groups (Optional)

When a branch has more than 5 children, consider showing a collapsed indicator
("+3 more") with the option to expand. This prevents the tree from becoming too wide.

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
