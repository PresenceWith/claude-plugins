# Concept Map Rendering Guide

**When to use:** Understanding relationships, dependencies, system architecture. The conversation
is about how things connect.

**Data source:** Elements and relations from state file.

**Structure:** Nodes (elements) connected by labeled edges (relations). Color-code by domain.
Core elements are larger. Decided elements have a solid border, undecided have dashed.

## Layout

Use SVG for nodes and edges. Group related nodes inside translucent background regions.
Position nodes using a layered layout:
- **Top row:** Core domain nodes with glow filters
- **Middle rows:** Sub-nodes within each domain region
- **Bottom row:** Shared infrastructure / dependencies

SVG must use `width="100%"` with `viewBox` and `preserveAspectRatio="xMidYMid meet"`.
Wrap in a container with `overflow-x: auto`.

## Node Rules

- Color-code node borders by domain/category. Use glow filters on core nodes for visual emphasis.
- Decided elements: solid 2.5px border. Undecided elements: dashed border (`stroke-dasharray: 6,3`).
- Each node must have enough width for its text content. Measure text length and set rect width
  accordingly — never let text overflow or get truncated. A safe minimum is: `(character count × 8) + 40px`.
- Sub-nodes within a group must not overlap. Space them with at least 16px gap between rects.
  Calculate x positions sequentially: `nextX = prevX + prevWidth + gap`.

## Edge Rules

- Differentiate edge types visually: workflow edges as solid colored arrows, dependency edges as
  dashed colored curves. Use distinct colors (e.g., yellow for workflow, red for dependency).
- Use curved paths (`C` or `Q` in SVG) for edges that cross regions, not straight lines. Route
  curves to avoid crossing other nodes when possible.
- **Label deduplication**: When multiple edges share the same relation type (e.g., 5 "depends-on"
  edges), do NOT label each edge individually. Instead, include the relation type in the legend
  and style the edges distinctively (color + dash pattern). Only add individual labels when edges
  have *different* relation types that need disambiguation.
- When many dependency edges converge on the same target area, bundle them: route through a shared
  intermediate waypoint to reduce visual spaghetti.

## Background Regions

Group related nodes inside translucent rectangles:
```svg
<rect x="30" y="80" width="300" height="340" rx="16"
      fill="#3b82f610" stroke="#3b82f630" stroke-width="1"/>
<text x="180" y="106" text-anchor="middle"
      fill="#3b82f680" font-size="11" font-weight="bold">영역 이름</text>
```

## Hover Tooltips

Add `data-tooltip` attributes to node groups. Include a short description (what the element is,
its status, and key relations). Render tooltips via a shared JS handler — follow cursor position.

```javascript
document.querySelectorAll('.node-group').forEach(node => {
  node.addEventListener('mouseenter', e => {
    tooltip.textContent = node.getAttribute('data-tooltip');
    tooltip.classList.add('visible');
  });
  node.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });
  node.addEventListener('mouseleave', () => tooltip.classList.remove('visible'));
});
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- With many dependency edges (6+), the bottom area can still look busy even with bundling.
  Consider grouping infrastructure nodes closer to the domains they serve rather than
  placing all infrastructure in a single row.
- The "핵심 인사이트" annotation box (see iteration-2 eval-6) is a nice touch — consider
  including it when the state file reveals a central connecting entity.
