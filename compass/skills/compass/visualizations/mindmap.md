# Mindmap Rendering Guide

**When to use:** Early exploration, brainstorming, divergent thinking. The conversation is expanding
and the user wants to see what's on the table.

**Data source:** Elements from state file, organized by relationship proximity to the goal.

**Structure:** Central node (goal) -> primary branches (core elements) -> secondary branches (details).

## Templates

### SVG Defs (include once at top of SVG)

```svg
<defs>
  <!-- Glow filter per domain — create one per branch category -->
  <filter id="glow-{domainName}" x="-30%" y="-30%" width="160%" height="160%">
    <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
    <feFlood flood-color="{categoryColor}" flood-opacity="0.3" result="color"/>
    <feComposite in="color" in2="blur" operator="in" result="shadow"/>
    <feMerge>
      <feMergeNode in="shadow"/>
      <feMergeNode in="SourceGraphic"/>
    </feMerge>
  </filter>

  <!-- Center glow — slightly stronger blur -->
  <filter id="glow-center" x="-30%" y="-30%" width="160%" height="160%">
    <feGaussianBlur in="SourceAlpha" stdDeviation="6" result="blur"/>
    <feFlood flood-color="{goalColor}" flood-opacity="0.35" result="color"/>
    <feComposite in="color" in2="blur" operator="in" result="shadow"/>
    <feMerge>
      <feMergeNode in="shadow"/>
      <feMergeNode in="SourceGraphic"/>
    </feMerge>
  </filter>

  <!-- General node shadow for detail nodes -->
  <filter id="node-shadow">
    <feDropShadow dx="0" dy="2" stdDeviation="4" flood-color="#000" flood-opacity="0.25"/>
  </filter>

  <!-- Central node radial gradient — top-lit effect -->
  <radialGradient id="center-grad" cx="50%" cy="40%" r="55%">
    <stop offset="0%" stop-color="#3a2a6a"/>
    <stop offset="100%" stop-color="#1a1a2e"/>
  </radialGradient>

  <!-- Arrowhead for cross-links -->
  <marker id="cross-arrow" markerWidth="8" markerHeight="6" refX="8" refY="3" orient="auto">
    <polygon points="0,0 8,3 0,6" fill="#94a3b8" fill-opacity="0.6"/>
  </marker>

  <!-- Animated entry — apply to each branch group via class -->
  <style>
    .branch-group {
      opacity: 0;
      transform-origin: center;
      animation: branchFadeIn 0.5s ease-out forwards;
    }
    .branch-group:nth-child(1) { animation-delay: 0.1s; }
    .branch-group:nth-child(2) { animation-delay: 0.2s; }
    .branch-group:nth-child(3) { animation-delay: 0.3s; }
    .branch-group:nth-child(4) { animation-delay: 0.4s; }
    .branch-group:nth-child(5) { animation-delay: 0.5s; }
    .branch-group:nth-child(6) { animation-delay: 0.6s; }
    .branch-group:nth-child(7) { animation-delay: 0.7s; }
    .branch-group:nth-child(8) { animation-delay: 0.8s; }

    @keyframes branchFadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    .central-node {
      animation: centralPulseIn 0.6s ease-out;
    }
    @keyframes centralPulseIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    /* Hover interactions */
    .node-group { cursor: pointer; transition: transform 0.2s ease, filter 0.2s ease; }
    .node-group:hover { transform: scale(1.06); }
    .node-group:hover rect, .node-group:hover circle {
      stroke-width: 3;
    }

    /* Branch dimming — applied via JS, not CSS :has() for cross-browser safety */
    .branch-group { transition: opacity 0.3s; }
    .branch-group.dimmed { opacity: 0.25; }

    /* Cross-link highlight on hover */
    .cross-link { opacity: 0.4; transition: opacity 0.3s; }
    .cross-link:hover { opacity: 1; }
    .cross-link:hover path { stroke-width: 2; }

    /* Tooltip — glassmorphism */
    .mindmap-tooltip {
      position: fixed; pointer-events: none; z-index: 100;
      background: #1a1a2eee; border: 1px solid #4a4a7a; border-radius: 10px;
      padding: 10px 14px; font-size: 12px; color: #e2e8f0;
      max-width: 260px; opacity: 0; transition: opacity 0.2s;
      box-shadow: 0 8px 32px rgba(0,0,0,0.5); backdrop-filter: blur(8px);
    }
    .mindmap-tooltip.visible { opacity: 1; }
    .mindmap-tooltip .status-tag {
      display: inline-block; padding: 2px 8px; border-radius: 4px;
      font-size: 10px; font-weight: bold; margin-top: 6px;
    }
  </style>
</defs>
```

### Branch Background Zones

Render these **before** branch groups. Each branch area gets a subtle colored circle for visual grouping:

```svg
<!-- Branch background zone — one per branch, rendered before branch groups -->
<circle cx="{branchX}" cy="{branchY}" r="{branchSpread}"
        fill="{categoryColor}" fill-opacity="0.03"/>
```

### Central Goal Node

```svg
<g class="central-node" data-tooltip="{goalDescription}" data-status="{goalStatus}">
  <circle cx="{centerX}" cy="{centerY}" r="56"
          fill="url(#center-grad)" stroke="{goalColor}" stroke-width="3"
          filter="url(#glow-center)"/>
  <!-- Depth rings -->
  <circle cx="{centerX}" cy="{centerY}" r="64"
          fill="none" stroke="{goalColor}" stroke-width="0.8" stroke-opacity="0.25"/>
  <circle cx="{centerX}" cy="{centerY}" r="70"
          fill="none" stroke="{goalColor}" stroke-width="0.4" stroke-opacity="0.12"/>
  <text x="{centerX}" y="{centerY - 6}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="15" font-weight="bold">{goalLabel}</text>
  <text x="{centerX}" y="{centerY + 14}" text-anchor="middle" dominant-baseline="central"
        fill="{goalColor}" font-size="10">{goalSubLabel}</text>
</g>
```

### Primary Branch Node (Core Element)

```svg
<g class="node-group core" data-tooltip="{elementDescription}" data-status="{status}">
  <rect x="{x}" y="{y}" width="{width}" height="40" rx="10"
        fill="#1a1a2e" stroke="{categoryColor}" stroke-width="2.5"
        filter="url(#glow-{domainName})"/>
  <!-- Left accent bar -->
  <rect x="{x}" y="{y}" width="4" height="40" rx="2" fill="{categoryColor}"/>
  <!-- Status dot with ring -->
  <circle cx="{x + width - 8}" cy="{y + 8}" r="5"
          fill="{statusDotColor}" stroke="{statusDotColor}40" stroke-width="2"/>
  <!-- statusDotColor: #4ade80 (decided), #facc15 (active), #6b7280 (undecided) -->
  <text x="{textX}" y="{textY}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{label}</text>
</g>
```

### Secondary Branch Node (Detail Element)

```svg
<g class="node-group detail" data-tooltip="{elementDescription}" data-status="{status}">
  <rect x="{x}" y="{y}" width="{width}" height="32" rx="8"
        fill="#1a1a2e" stroke="{categoryColor}" stroke-width="1.5"
        stroke-dasharray="5 4" filter="url(#node-shadow)"/>
  <!-- Status dot with ring for decided/active -->
  <circle cx="{x + width - 6}" cy="{y + 6}" r="4"
          fill="{statusDotColor}" stroke="{statusDotColor}40" stroke-width="2"/>
  <text x="{textX}" y="{textY}" text-anchor="middle" dominant-baseline="central"
        fill="#a0a0b0" font-size="11">{label}</text>
</g>
```

### Branch Connector Line (Core Element)

Use tapered paths — thicker at root, thinner at node end — for organic look:

```svg
<path d="M {centerX},{centerY} Q {controlX},{controlY} {nodeX},{nodeY}"
      stroke="{categoryColor}" stroke-opacity="0.6" stroke-width="3.5" fill="none"
      stroke-linecap="round">
  <!-- Taper via stroke-width animation along path is optional;
       a fixed 3.5px width with rounded caps gives a clean organic feel -->
</path>
```

### Branch Connector Line (Detail Element)

```svg
<path d="M {parentCX},{parentCY} Q {controlX},{controlY} {childCX},{childCY}"
      stroke="{categoryColor}" stroke-opacity="0.4" stroke-width="2"
      stroke-dasharray="5 4" fill="none" stroke-linecap="round"/>
```

### Cross-Branch Relationship Line

```svg
<g class="cross-link" data-relation="{relationType}">
  <path d="M {startX},{startY} Q {controlX},{controlY} {endX},{endY}"
        stroke="#94a3b8" stroke-opacity="0.45" stroke-width="1.5"
        stroke-dasharray="6 4" fill="none"
        marker-end="url(#cross-arrow)"/>
  <!-- Label with bordered rect background -->
  <rect x="{midX - labelWidth/2 - 6}" y="{midY - 10}" width="{labelWidth + 12}" height="18"
        rx="5" fill="#1a1a2e" fill-opacity="0.9" stroke="#94a3b8" stroke-width="0.5" stroke-opacity="0.3"/>
  <text x="{midX}" y="{midY}" text-anchor="middle" dominant-baseline="central"
        fill="#94a3b8" font-size="10">{relationLabel}</text>
</g>
```

### Legend Panel (bottom-right of SVG)

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="170" height="{legendHeight}" rx="10"
        fill="#1a1a2eee" stroke="#2a2a4a" stroke-width="1"/>
  <text x="14" y="20" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- Status indicators with rings -->
  <circle cx="22" cy="38" r="5" fill="#4ade80" stroke="#4ade8040" stroke-width="2"/>
  <text x="34" y="41" fill="#94a3b8" font-size="10">결정됨</text>

  <circle cx="90" cy="38" r="5" fill="#facc15" stroke="#facc1540" stroke-width="2"/>
  <text x="102" y="41" fill="#94a3b8" font-size="10">논의 중</text>

  <circle cx="22" cy="58" r="5" fill="#6b7280"/>
  <text x="34" y="61" fill="#94a3b8" font-size="10">미결정</text>

  <!-- Node types -->
  <line x1="14" y1="76" x2="52" y2="76" stroke="{exampleColor}" stroke-width="3" stroke-linecap="round"/>
  <text x="60" y="79" fill="#94a3b8" font-size="10">핵심 요소</text>

  <line x1="14" y1="92" x2="52" y2="92" stroke="{exampleColor}" stroke-width="2" stroke-dasharray="5 4" stroke-linecap="round"/>
  <text x="60" y="95" fill="#94a3b8" font-size="10">세부 요소</text>

  <!-- Cross-link -->
  <line x1="14" y1="105" x2="52" y2="105" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="6 4"/>
  <text x="60" y="108" fill="#94a3b8" font-size="10">교차 연결</text>
</g>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.mindmap-tooltip');
const allBranches = document.querySelectorAll('.branch-group');

document.querySelectorAll('.node-group, .central-node').forEach(node => {
  node.addEventListener('mouseenter', e => {
    // Tooltip
    const desc = node.getAttribute('data-tooltip');
    const status = node.getAttribute('data-status');
    const statusLabel = { decided: '결정됨', active: '논의 중', undecided: '미결정' }[status] || '';
    const statusColor = { decided: '#4ade80', active: '#facc15', undecided: '#6b7280' }[status] || '#6b7280';
    tooltip.innerHTML = `${desc}${statusLabel ? `<br><span class="status-tag" style="background:${statusColor}18;color:${statusColor}">${statusLabel}</span>` : ''}`;
    tooltip.classList.add('visible');

    // Branch dimming: dim all branches except the one containing this node
    const parentBranch = node.closest('.branch-group');
    if (parentBranch) {
      allBranches.forEach(b => {
        b.classList.toggle('dimmed', b !== parentBranch);
      });
    }
  });

  node.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  node.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allBranches.forEach(b => b.classList.remove('dimmed'));
  });
});
```

## Rules

### Node type rules
- If element is **core** -> use larger node (40px height, rx 10), domain-color border, glow filter, bold text, left accent bar (4px wide in domain color)
- If element is **detail** -> use smaller node (32px height, rx 8), dashed border (`stroke-dasharray: 5 4`), muted text (`#a0a0b0`), node-shadow filter
- Every node shows a **status indicator dot** in the top-right corner:
  - `#4ade80` for decided (see color-palette.md -> status-decided)
  - `#facc15` for active (see color-palette.md -> status-active)
  - `#6b7280` for undecided (see color-palette.md -> status-undecided)
- Status dots use border rings (stroke at 40% opacity, stroke-width: 2) for decided and active states, giving them more visual weight
- Primary branch nodes have a 4px left accent bar in the domain color for consistent visual language across all visualization types

### Central node rules
- Central node uses 3 concentric rings (solid at r=56, thin at r=64 at 25% opacity, thinnest at r=70 at 12% opacity) for depth. Sub-label in domain color below main label.
- Radial gradient uses `stop-color="#3a2a6a"` at 0% and `stop-color="#1a1a2e"` at 100%, with center at `cx="50%" cy="40%"` for subtle top-lit effect
- Goal label is bold 15px, centered, shifted up 6px. Sub-label is 10px in goal color, shifted down 14px

### Branch background rules
- Each branch area has a subtle background circle (fill-opacity: 0.03) in the branch's domain color, rendered behind the branch group for visual zone grouping
- Background zones are positioned at the branch's primary node coordinates with radius equal to the branch's spread

### Hover behavior
- On hover -> `transform: scale(1.06)` with 0.2s transition (CSS-based, not inline)
- Hovering a node dims all other branches to 25% opacity (JS-based via `.dimmed` class toggle on `.branch-group`)
- Cross-links brighten to full opacity on hover

### Connector line rules
- Lines **must** be clearly visible against the `#0f0f1a` background
- Core element connectors -> `stroke-width: 3.5`, solid, rounded caps (`stroke-linecap: round`), stroke-opacity 0.6
- Detail element connectors -> `stroke-width: 2`, `stroke-dasharray: 5 4`, rounded caps, stroke-opacity 0.4
- All connectors -> domain color at 40-60% opacity for stroke
- All connectors -> quadratic Bezier curves (`Q`); offset the control point **perpendicular** to the line direction by 30-50px to prevent overlap at center
- Color-code lines by branch category for visual grouping

### Cross-branch relationship rules
- Cross-branch links render as dashed lines (`#94a3b8` at 45%, stroke-width 1.5) with arrowhead markers (markerWidth 8, markerHeight 6)
- Labels use bordered rect backgrounds (`fill: #1a1a2e` at 90%, `stroke: #94a3b8` at 0.5px and 30% opacity, rx 5) for definition against overlapping elements
- Label font-size is 10px (up from 9px) for readability
- These cross-links must be rendered as lines on the map itself — never in a separate text box
- Cross-links are the most valuable part of a mindmap because they reveal non-obvious structure
- **Routing**: Route cross-link curves around the central node — use control points that arc outward rather than cutting through the center area. When connecting nodes on opposite sides, offset the control point laterally by 150-200px to create a wide arc. Place the label at the midpoint of the arc, not near the center node, so it doesn't overlap with the central label or primary connectors

### Glow filter rules
- Branch glow filters use `stdDeviation="5"` for consistent soft glow
- Center glow uses `stdDeviation="6"` for slightly stronger emphasis
- Detail nodes use the `node-shadow` filter (`feDropShadow` with stdDeviation 4) instead of glow filters

### Branch distribution rules
- Distribute branch groups evenly around the center
- Allocate angular slices **proportional to child count** — a branch with 4 children gets twice the angular space of a branch with 2
- Minimum angular slice per branch: 30 degrees (prevents cramping with many branches)

### Legend rules
- Always include the legend panel at the bottom-right of the SVG
- Legend uses rounded rect border (rx 10, fill `#1a1a2eee`, stroke `#2a2a4a`) matching other viz styles
- Legend lists: status colors with rings (결정됨/논의 중/미결정), node types (핵심/세부), cross-links
- Legend text uses `#94a3b8` for readability
- Legend background is semi-transparent to not occlude content
- Do NOT include branch/domain color swatches — each branch already shows its domain through border colors, accent bars, and background zone circles, so repeating them in the legend is redundant

### Tooltip rules
- Tooltip uses glassmorphism styling: `background: #1a1a2eee`, `backdrop-filter: blur(8px)`, `border-radius: 10px`
- Box shadow is deeper: `0 8px 32px rgba(0,0,0,0.5)`
- Transition duration is 0.2s for smooth appearance

### Animation rules
- Central node enters with a scale-up pulse (0 -> 1.08 -> 1.0)
- Each branch group fades in with staggered delay (0.1s per branch)
- Keep animations subtle — they orient the eye, not distract

## Layout Algorithm

Radial distribution with adaptive spacing. All values in px.

```
centerX = viewBoxWidth / 2
centerY = viewBoxHeight / 2

// --- Step 1: Calculate angular allocation per branch ---
branchCount = number of top-level branches
totalChildren = sum of child counts across all branches

for i, branch in branches:
    // Proportional angle based on number of children
    childRatio = max(branch.childCount, 1) / max(totalChildren, 1)
    branch.angularSlice = max(childRatio * 360, 30)  // minimum 30 degrees

// Normalize so slices sum to 360
sliceSum = sum(b.angularSlice for b in branches)
for branch in branches:
    branch.angularSlice = branch.angularSlice * 360 / sliceSum

// --- Step 2: Position primary branch nodes ---
baseRadius = clamp(160 + branchCount * 15, 180, 300)
// More branches -> wider radius to avoid crowding

currentAngle = -90  // start from 12 o'clock
for branch in branches:
    midAngle = currentAngle + branch.angularSlice / 2
    branch.angle = midAngle
    branch.x = centerX + baseRadius * cos(midAngle * PI / 180)
    branch.y = centerY + baseRadius * sin(midAngle * PI / 180)
    currentAngle += branch.angularSlice

// --- Step 3: Position secondary nodes (children) ---
for branch in branches:
    childCount = len(branch.children)
    if childCount == 0: continue

    spreadAngle = min(branch.angularSlice * 0.7, childCount * 22)
    // Use 70% of allocated slice, cap per-child angle at 22 degrees

    childRadius = baseRadius + clamp(100 + childCount * 10, 110, 180)
    // More children -> push further out to make room

    startChildAngle = branch.angle - spreadAngle / 2
    childAngleStep = spreadAngle / max(childCount - 1, 1)

    for j, child in branch.children:
        childAngle = startChildAngle + j * childAngleStep
        child.x = centerX + childRadius * cos(childAngle * PI / 180)
        child.y = centerY + childRadius * sin(childAngle * PI / 180)

// --- Step 4: Calculate connector control points ---
for branch in branches:
    // Primary connector: from center to branch node
    dx = branch.x - centerX
    dy = branch.y - centerY
    perpX = -dy * 0.15   // perpendicular offset = 15% of distance
    perpY = dx * 0.15
    branch.controlX = (centerX + branch.x) / 2 + perpX
    branch.controlY = (centerY + branch.y) / 2 + perpY

    // Secondary connectors: from branch to each child
    for child in branch.children:
        dx2 = child.x - branch.x
        dy2 = child.y - branch.y
        perpX2 = -dy2 * 0.12
        perpY2 = dx2 * 0.12
        child.controlX = (branch.x + child.x) / 2 + perpX2
        child.controlY = (branch.y + child.y) / 2 + perpY2

// --- Step 5: Calculate viewBox ---
allNodes = [center] + branches + all children
minX = min(n.x - n.width/2 for n in allNodes) - 80   // 80px padding
minY = min(n.y - n.height/2 for n in allNodes) - 80
maxX = max(n.x + n.width/2 for n in allNodes) + 80
maxY = max(n.y + n.height/2 for n in allNodes) + 80
// Add extra 180px to bottom-right for legend panel
maxX = max(maxX, maxX + 180)
viewBoxWidth = maxX - minX
viewBoxHeight = maxY - minY

// Legend position: bottom-right, outside content area
// legendHeight = 20 (title) + 20 (status row 1) + 20 (status row 2) + 18 * lineTypeCount
// Standard legend with 3 status rows + 3 line types (핵심/세부/교차) = ~118px
legendHeight = 118
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
```

### Node Width Calculation (CJK-aware)

```
function nodeWidth(label, fontSize):
    koreanChars = count characters in Unicode range U+AC00..U+D7AF, U+3130..U+318F, U+1100..U+11FF
    cjkChars = count characters in CJK Unified Ideographs range
    latinChars = len(label) - koreanChars - cjkChars
    wideCount = koreanChars + cjkChars

    textWidth = (wideCount * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return textWidth + 36  // 18px padding each side
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- Cross-link labels at `#ffffff30` can be faint on dark backgrounds. Use `#94a3b8` at 50% with a bordered background rect for contrast.
- When there are 8+ branches, the proportional angular allocation is critical — without it, small branches get the same space as large ones, wasting visual real estate.
- Branch dimming uses JS class toggles (`.dimmed`) rather than CSS `:has()` for reliable cross-browser behavior. The JS approach via `node.closest('.branch-group')` works in all modern browsers.
- `stroke-linecap: round` on connector paths gives a more organic, hand-drawn feel that suits brainstorming context.
- When total node count exceeds 25, increase `baseRadius` by 20% to prevent crowding in the inner ring.
- Branch background zones (fill-opacity: 0.03) create subtle visual grouping without interfering with the actual branch elements. Essential for 5+ branches.
- The 3-ring central node creates a focal point that draws the eye — the outermost ring at 12% opacity acts as a subtle halo.
- Cross-link labels placed near the center node tend to overlap with primary connector lines. Position labels at the arc midpoint, well away from the center.
- The legend must include the cross-link line entry (교차 연결) — this is easy to forget but important for users to understand the dashed gray lines.
