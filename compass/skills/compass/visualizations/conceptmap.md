# Concept Map Rendering Guide

**When to use:** Understanding relationships, dependencies, system architecture. The conversation
is about how things connect.

**Data source:** Elements and relations from state file.

**Structure:** Nodes (elements) connected by labeled edges (relations). Color-coded by domain.
Core elements are larger. Decided elements have a solid border, undecided have dashed.

## Templates

### SVG Container

```html
<div style="overflow-x: auto;">
  <svg width="100%" viewBox="0 0 {viewBoxWidth} {viewBoxHeight}"
       preserveAspectRatio="xMidYMid meet"
       style="background: #0f0f1a; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">
    <defs>
      {filterDefinitions}
      {arrowheadMarkers}
      {gradientDefinitions}
      <style>
        /* Node interactions */
        .node-group { cursor: pointer; transition: transform 0.2s ease, filter 0.2s ease; }
        .node-group:hover { transform: scale(1.05); }

        /* Edge highlight on connected node hover — implemented via JS */
        .edge-path { transition: stroke-opacity 0.3s, stroke-width 0.3s; }
        .edge-path.dimmed { stroke-opacity: 0.12; }
        .edge-path.highlighted { stroke-opacity: 1; stroke-width: 3; }

        /* Region hover */
        .domain-region { transition: fill-opacity 0.3s; }
        .domain-region:hover { fill-opacity: 0.15; }

        /* Fade-in animation */
        .node-group, .edge-path, .domain-region {
          opacity: 0; animation: fadeIn 0.4s ease-out forwards;
        }
        @keyframes fadeIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Tooltip */
        .concept-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2e; border: 1px solid #4a4a7a; border-radius: 8px;
          padding: 10px 14px; font-size: 12px; color: #e2e8f0;
          max-width: 280px; opacity: 0; transition: opacity 0.15s;
          box-shadow: 0 4px 16px rgba(0,0,0,0.5);
        }
        .concept-tooltip.visible { opacity: 1; }
        .concept-tooltip .tt-status {
          display: inline-block; padding: 1px 6px; border-radius: 4px;
          font-size: 10px; font-weight: bold; margin-top: 4px;
        }
        .concept-tooltip .tt-relations {
          margin-top: 6px; padding-top: 6px; border-top: 1px solid #2a2a4a;
          font-size: 11px; color: #888888;
        }
      </style>
    </defs>

    {backgroundRegions}
    {edges}
    {nodes}
    {legend}
  </svg>
</div>

<!-- Tooltip container (outside SVG) -->
<div class="concept-tooltip"></div>
```

### Gradient Definitions (per domain)

```svg
<linearGradient id="grad-{domainName}" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0%" stop-color="{domainColor}" stop-opacity="0.08"/>
  <stop offset="100%" stop-color="{domainColor}" stop-opacity="0.02"/>
</linearGradient>
```

### Background Region

```svg
<g class="domain-region" style="animation-delay: 0s;">
  <rect x="{regionX}" y="{regionY}" width="{regionWidth}" height="{regionHeight}" rx="16"
        fill="url(#grad-{domainName})" stroke="{domainColor}" stroke-opacity="0.2" stroke-width="1.5"/>
  <!-- Region label with decorative flanking lines for visibility -->
  <line x1="{regionCenterX - 70}" y1="{regionY + 22}" x2="{regionCenterX - 30}" y2="{regionY + 22}"
        stroke="{domainColor}" stroke-opacity="0.25" stroke-width="1"/>
  <text x="{regionCenterX}" y="{regionY + 26}" text-anchor="middle"
        fill="{domainColor}" fill-opacity="0.8" font-size="11" font-weight="700" letter-spacing="2">{regionName}</text>
  <line x1="{regionCenterX + 30}" y1="{regionY + 22}" x2="{regionCenterX + 70}" y2="{regionY + 22}"
        stroke="{domainColor}" stroke-opacity="0.25" stroke-width="1"/>
</g>
```

**Region label rule**: Region labels must have flanking decorative lines and use 80% opacity (not 70%). Labels should be centered with `letter-spacing: 2` and `font-weight: 700` for visibility. The gradient fill should start at 8% opacity (not 6%) and end at 2%.

### Core Node (Decided)

```svg
<g class="node-group" data-id="{nodeId}" data-tooltip="{tooltipText}" data-status="decided"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="42" rx="8"
        fill="#1a1a2e" stroke="{domainColor}" stroke-width="2.5"
        filter="url(#glow-{domainName})"/>
  <!-- Color accent bar -->
  <rect x="{x}" y="{y}" width="{width}" height="4" rx="2" fill="{domainColor}" fill-opacity="0.5"/>
  <!-- Status dot -->
  <circle cx="{x + width - 10}" cy="{y + 10}" r="4" fill="#4ade80"/>
  <text x="{textX}" y="{textY}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{label}</text>
</g>
```

### Core Node (Undecided)

```svg
<g class="node-group" data-id="{nodeId}" data-tooltip="{tooltipText}" data-status="undecided"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="42" rx="8"
        fill="#1a1a2e" stroke="{domainColor}" stroke-width="2.5"
        stroke-dasharray="6,3"
        filter="url(#glow-{domainName})"/>
  <!-- Color accent bar -->
  <rect x="{x}" y="{y}" width="{width}" height="4" rx="2" fill="{domainColor}" fill-opacity="0.5"/>
  <!-- Status dot -->
  <circle cx="{x + width - 10}" cy="{y + 10}" r="4" fill="#6b7280"/>
  <text x="{textX}" y="{textY}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{label}</text>
</g>
```

### Sub-Node

```svg
<g class="node-group" data-id="{nodeId}" data-tooltip="{tooltipText}" data-status="{status}"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="36" rx="6"
        fill="#1a1a2e" stroke="{domainColor}" stroke-width="1.5"
        {dashAttr}/>
  <!-- dashAttr: stroke-dasharray="6,3" if undecided, omit if decided -->
  <circle cx="{x + width - 8}" cy="{y + 8}" r="3" fill="{statusDotColor}"/>
  <text x="{textX}" y="{textY}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="11">{label}</text>
</g>
```

### Workflow Edge (Solid Arrow)

```svg
<path class="edge-path" data-from="{fromId}" data-to="{toId}" data-type="workflow"
      d="M {startX},{startY} C {cp1X},{cp1Y} {cp2X},{cp2Y} {endX},{endY}"
      stroke="#facc15" stroke-width="2" fill="none"
      marker-end="url(#arrow-workflow)"
      style="animation-delay: {delay}s;"/>
```

### Dependency Edge (Dashed Curve)

```svg
<path class="edge-path" data-from="{fromId}" data-to="{toId}" data-type="dependency"
      d="M {startX},{startY} C {cp1X},{cp1Y} {cp2X},{cp2Y} {endX},{endY}"
      stroke="#ef4444" stroke-width="1.5" stroke-dasharray="6,3" fill="none"
      marker-end="url(#arrow-dependency)"
      style="animation-delay: {delay}s;"/>
```

### Optional/Deferred Edge

```svg
<path class="edge-path" data-from="{fromId}" data-to="{toId}" data-type="optional"
      d="M {startX},{startY} C {cp1X},{cp1Y} {cp2X},{cp2Y} {endX},{endY}"
      stroke="#6b7280" stroke-width="1" stroke-dasharray="2,4" fill="none"
      marker-end="url(#arrow-optional)"
      style="animation-delay: {delay}s;"/>
```

### Communication Edge (Dotted Blue)

```svg
<path class="edge-path" data-from="{fromId}" data-to="{toId}" data-type="communication"
      d="M {startX},{startY} C {cp1X},{cp1Y} {cp2X},{cp2Y} {endX},{endY}"
      stroke="#38bdf8" stroke-width="2" stroke-dasharray="3,4" fill="none" opacity="0.6"
      marker-end="url(#arrow-communication)"
      style="animation-delay: {delay}s;"/>
<!-- Label with background pill for readability -->
<rect x="{midX - labelWidth/2}" y="{midY - 10}" width="{labelWidth}" height="18" rx="9"
      fill="#0f0f1a" stroke="#38bdf830" stroke-width="0.5"/>
<text x="{midX}" y="{midY + 3}" text-anchor="middle" fill="#38bdf8" font-size="9" font-weight="500">{relationLabel}</text>
```

**Edge label pill rule**: ALL edge labels (workflow, dependency, communication) must have a background pill (`<rect>` behind `<text>`) for readability. Without pills, labels blend into the dark background and become invisible. Use `fill="#0f0f1a"` with a subtle colored stroke matching the edge color at 20% opacity. Use `rx="9"` for rounded pill shape.

### Arrowhead Marker Definitions

```svg
<marker id="arrow-workflow" markerWidth="10" markerHeight="8" refX="9" refY="4" orient="auto-start-reverse">
  <polygon points="0,1 10,4 0,7" fill="#facc15"/>
</marker>
<marker id="arrow-dependency" markerWidth="10" markerHeight="8" refX="9" refY="4" orient="auto-start-reverse">
  <polygon points="0,1 10,4 0,7" fill="#ef4444"/>
</marker>
<marker id="arrow-optional" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto-start-reverse">
  <polygon points="0,0.5 8,3 0,5.5" fill="#6b7280"/>
</marker>
<marker id="arrow-communication" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto-start-reverse">
  <polygon points="0,0.5 8,3 0,5.5" fill="#38bdf8"/>
</marker>
```

### Glow Filter Definition

```svg
<filter id="glow-{domainName}" x="-20%" y="-20%" width="140%" height="140%">
  <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
  <feFlood flood-color="{domainColor}" flood-opacity="0.2" result="color"/>
  <feComposite in="color" in2="blur" operator="in" result="shadow"/>
  <feMerge>
    <feMergeNode in="shadow"/>
    <feMergeNode in="SourceGraphic"/>
  </feMerge>
</filter>
```

### Legend Panel (bottom-right of SVG)

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="180" height="{legendHeight}" rx="8"
        fill="#0f0f1a" fill-opacity="0.9" stroke="#2a2a4a" stroke-width="1"/>
  <text x="12" y="18" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- Edge types -->
  <line x1="12" y1="34" x2="44" y2="34" stroke="#facc15" stroke-width="2"/>
  <polygon points="44,31 50,34 44,37" fill="#facc15"/>
  <text x="56" y="37" fill="#888888" font-size="10">워크플로우</text>

  <line x1="12" y1="50" x2="44" y2="50" stroke="#ef4444" stroke-width="1.5" stroke-dasharray="6,3"/>
  <polygon points="44,47 50,50 44,53" fill="#ef4444"/>
  <text x="56" y="53" fill="#888888" font-size="10">의존성</text>

  <line x1="12" y1="66" x2="44" y2="66" stroke="#6b7280" stroke-width="1" stroke-dasharray="2,4"/>
  <text x="56" y="69" fill="#888888" font-size="10">선택적</text>

  <!-- Status indicators -->
  <circle cx="20" cy="84" r="4" fill="#4ade80"/>
  <text x="30" y="87" fill="#888888" font-size="10">결정됨</text>
  <circle cx="90" cy="84" r="4" fill="#6b7280"/>
  <text x="100" y="87" fill="#888888" font-size="10">미결정</text>
</g>
```

### Insight Annotation (optional)

When the state file reveals a central connecting entity or critical insight:

```svg
<g class="insight-box" transform="translate({insightX}, {insightY})">
  <rect x="0" y="0" width="{insightWidth}" height="{insightHeight}" rx="8"
        fill="#facc1508" stroke="#facc15" stroke-width="1" stroke-dasharray="4,4"/>
  <text x="12" y="18" fill="#facc15" font-size="11" font-weight="bold">&#9889; 핵심 인사이트</text>
  <text x="12" y="34" fill="#888888" font-size="11">{insightText}</text>
</g>
```

### Hover Interaction Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.concept-tooltip');
const allEdges = document.querySelectorAll('.edge-path');
const allNodes = document.querySelectorAll('.node-group');

allNodes.forEach(node => {
  const nodeId = node.getAttribute('data-id');

  node.addEventListener('mouseenter', e => {
    // Show tooltip
    const desc = node.getAttribute('data-tooltip');
    const status = node.getAttribute('data-status');
    const statusLabel = { decided: '결정됨', active: '논의 중', undecided: '미결정' }[status] || '';
    const statusColor = { decided: '#4ade80', active: '#facc15', undecided: '#6b7280' }[status] || '#6b7280';

    // Find connected edges
    const connected = new Set();
    allEdges.forEach(edge => {
      const from = edge.getAttribute('data-from');
      const to = edge.getAttribute('data-to');
      if (from === nodeId || to === nodeId) {
        edge.classList.add('highlighted');
        edge.classList.remove('dimmed');
        connected.add(from); connected.add(to);
      } else {
        edge.classList.add('dimmed');
        edge.classList.remove('highlighted');
      }
    });

    // Dim unconnected nodes
    allNodes.forEach(n => {
      const nId = n.getAttribute('data-id');
      n.style.opacity = connected.has(nId) || nId === nodeId ? '1' : '0.3';
    });

    // Build relations text
    let relText = '';
    allEdges.forEach(edge => {
      if (edge.getAttribute('data-from') === nodeId || edge.getAttribute('data-to') === nodeId) {
        const type = edge.getAttribute('data-type');
        const other = edge.getAttribute('data-from') === nodeId
          ? edge.getAttribute('data-to') : edge.getAttribute('data-from');
        relText += `<div>→ ${other} (${type})</div>`;
      }
    });

    tooltip.innerHTML = `
      <div style="font-weight:bold;margin-bottom:4px;">${desc}</div>
      <span class="tt-status" style="background:${statusColor}20;color:${statusColor}">${statusLabel}</span>
      ${relText ? `<div class="tt-relations">${relText}</div>` : ''}
    `;
    tooltip.classList.add('visible');
  });

  node.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  node.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allEdges.forEach(edge => { edge.classList.remove('highlighted', 'dimmed'); });
    allNodes.forEach(n => { n.style.opacity = '1'; });
  });
});
```

## Rules

### SVG container rules
- SVG must use `width="100%"` with `viewBox` and `preserveAspectRatio="xMidYMid meet"`
- Wrap in a container with `overflow-x: auto`
- Background color `#0f0f1a` set on SVG element

### Node sizing rules
- CJK-aware width: `(wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34) + 36px`
- Core nodes: height 42px, rx 8
- Sub-nodes: height 36px, rx 6
- Minimum node width: 80px

### Node styling rules
- If element is **core** -> larger node (42px), glow filter, domain-color border, bold text
- If element is **sub-node** -> smaller node (36px), muted text, domain-color border at lower emphasis
- If element is **decided** -> solid border, `stroke-width: 2.5`, green status dot
- If element is **undecided** -> dashed border (`stroke-dasharray: 6,3`), gray status dot
- Color-code node borders by domain/category (see color-palette.md -> domain colors)

### Node spacing rules
- Sub-nodes within a group must not overlap -> minimum 16px gap between rects
- Calculate x positions sequentially: `nextX = prevX + prevWidth + gap`

### Edge styling rules
- **Workflow/sequence** -> solid yellow `#facc15`, 2px, arrowhead
- **Dependency** -> dashed red `#ef4444`, 1.5px, `stroke-dasharray: 6,3`, arrowhead
- **Optional/deferred** -> dotted gray `#6b7280`, 1px, `stroke-dasharray: 2,4`, small arrowhead
- **Communication** -> dotted blue `#38bdf8`, 1.8px, `stroke-dasharray: 4,4`, arrowhead. Label inline at midpoint (font-size 8px, edge color at 30% opacity)
- Use cubic Bezier curves (`C`) for edges crossing regions
- Route curves to avoid crossing other nodes when possible

### Edge interaction rules
- On node hover, connected edges brighten (full opacity, +1px width) and unconnected edges dim to 12% opacity
- Transition is 0.3s for smooth effect

### Edge label deduplication rules
- If 3+ edges share the same relation type -> do NOT label each individually; include the type in the legend and use distinctive styling (color + dash pattern)
- Only add individual labels when edges have *different* relation types needing disambiguation

### Edge bundling rules
- If 3+ dependency edges converge on the same target area -> bundle through a shared intermediate waypoint to reduce visual clutter

### Background region rules
- Group related nodes inside translucent rectangles with `rx="16"`
- Fill with vertical gradient (12% -> 4% domain color opacity)
- Region title at top-left with item count at top-right
- Hover increases fill-opacity to 15%

### Legend rules
- Always include legend panel at bottom-right
- Show: edge types (workflow, dependency, optional) and status indicators. Do NOT include domain color swatches — domain names are already displayed as region labels, so repeating them in the legend is redundant
- Legend background is semi-transparent `#0f0f1a` at 90%

### Insight annotation rules
- If the state file reveals a central connecting entity or critical dependency pattern, include an insight box
- Positioned near the relevant cluster, with a dashed yellow border

### Animation rules
- Nodes and edges fade in with staggered delays (0.05s increments)
- Regions animate first, then nodes, then edges (layered appearance)

## Layout Algorithm

Layered layout with nodes distributed inside domain regions. All values in px.

```
regionPadding = 20       // padding inside region rect
nodeGap = 20             // horizontal gap between nodes in same row
rowGap = 16              // vertical gap between rows in same region
coreHeight = 42          // core node height
subHeight = 36           // sub-node height

// --- Step 1: Calculate node widths ---
for node in allNodes:
    node.width = max(80, nodeWidth(node.label, node.fontSize))

// --- Step 2: Arrange nodes inside each region ---
function layoutRegion(region, nodes):
    x = region.x + regionPadding
    y = region.y + 36                    // below region title + padding
    rowStartX = x
    maxRowHeight = 0
    maxRowRight = x

    for node in nodes:
        nodeH = coreHeight if node.isCore else subHeight
        if x + node.width > region.x + region.width - regionPadding:
            // wrap to next row
            x = rowStartX
            y += maxRowHeight + rowGap
            maxRowHeight = 0
        node.x = x
        node.y = y
        x += node.width + nodeGap
        maxRowHeight = max(maxRowHeight, nodeH)
        maxRowRight = max(maxRowRight, x)

    // Adjust region height to fit content
    region.height = (y + maxRowHeight + regionPadding) - region.y

// --- Step 3: Position regions in layers ---
// Sort regions by dependency order: upstream regions at top, downstream at bottom
// Typical arrangement: 2-3 rows of regions
topRowY = 40
regionGap = 48

// Estimate max row width: fit 2-3 regions per row
// Use 960px as target max width (matching max-width constraint)
maxRowWidth = 960

currentRowY = topRowY
currentRowX = 40
maxRowHeight = 0

for region in sortedRegions:
    if currentRowX + region.width > maxRowWidth - 40:
        // Wrap to next row of regions
        currentRowY += maxRowHeight + regionGap
        currentRowX = 40
        maxRowHeight = 0

    region.x = currentRowX
    region.y = currentRowY
    layoutRegion(region, region.nodes)  // re-layout with final position
    currentRowX += region.width + regionGap
    maxRowHeight = max(maxRowHeight, region.height)

// --- Step 4: Route edges ---
for edge in allEdges:
    sourceNode = getNode(edge.from)
    targetNode = getNode(edge.to)

    // Determine connection points (top/bottom/left/right of node)
    // Prefer vertical connections between regions (top/bottom)
    // Prefer horizontal connections within same region (left/right)
    startX, startY = getConnectionPoint(sourceNode, targetNode)
    endX, endY = getConnectionPoint(targetNode, sourceNode)

    // Control points for cubic Bezier
    if sameRegion(sourceNode, targetNode):
        // Simple horizontal curve
        midX = (startX + endX) / 2
        cp1 = (midX, startY)
        cp2 = (midX, endY)
    else:
        // Vertical curve between regions
        midY = (startY + endY) / 2
        cp1 = (startX, midY)
        cp2 = (endX, midY)

// --- Step 5: Edge bundling ---
// Group edges by target region
for targetRegion in regions:
    incomingEdges = edges where target is in targetRegion
    if len(incomingEdges) >= 3:
        // Route through shared waypoint
        waypointX = (mean(source.cx) + targetRegion.cx) / 2
        waypointY = targetRegion.y - 30
        // Fan from waypoint to individual targets

// --- Step 6: Calculate viewBox and legend position ---
allBounds = all region rects + all node rects + edge extents
contentRight = max(allBounds.right) + 60
viewBoxWidth = contentRight + 200              // +200 for legend
viewBoxHeight = max(allBounds.bottom) + 60

// Legend sits outside the content area, at bottom-right
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
// legendHeight depends on number of domain entries (base ~100 + 18 per domain)
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- **Edge label placement**: Labels must not overlap with nodes, region boundaries, or other labels. Place each label at the midpoint of its edge's curve, then nudge it perpendicular to the edge direction (toward empty space) by 10-15px. Verify there is no collision with region borders, node rects, or other labels. When in doubt, place labels in the open space between regions rather than inside them.
- **Insight annotation placement**: Position the insight box in empty space outside the main content area (e.g., top-right corner or right margin), not between nodes or overlapping edges. It should never compete with edges for attention.
- With many dependency edges (6+), the bottom area can still look busy even with bundling. Group infrastructure nodes closer to the domains they serve rather than placing all infrastructure in a single row.
- The "핵심 인사이트" annotation box is a valuable addition when the state file reveals a central connecting entity — include it when one node has 4+ connections.
- The hover-to-highlight-connections interaction is the most useful interactive feature — it lets users trace dependencies without following spaghetti lines manually.
- For 12+ nodes, increase `nodeGap` to 24px and `regionGap` to 56px to prevent visual density.
- Edge bundling waypoints should be positioned at least 30px above/below region boundaries to keep routing clean.
- Communication edges benefit from inline labels — always use background pills (rect behind text) for readability. Labels at low opacity without pills are invisible on dark backgrounds.
- The color accent bar on core nodes is a high-value, low-cost visual element — always include it.
- Route dependency edges along the outer perimeter rather than through the center to reduce crossing.
- **Workflow edge animated dashes**: Use `stroke-dasharray="8,4"` with `@keyframes dash-flow { to { stroke-dashoffset: -20; } }` and `animation: dash-flow 1.5s linear infinite` to convey directional flow.
- **Connection port dots**: Add small circles (r=4, domain color at 50% opacity) at node edge connection points to clarify where edges attach.
- **Dependency count badges**: When a node has 4+ incoming dependencies, add a small red circle badge (r=10) with a white count number to surface hub nodes at a glance.
- **Region label decorative lines**: Flanking horizontal lines on region labels significantly improve their visibility versus text alone.
- Edge opacity minimums: workflow ≥0.7, dependency ≥0.5, communication ≥0.5. Below these, edges become invisible.
