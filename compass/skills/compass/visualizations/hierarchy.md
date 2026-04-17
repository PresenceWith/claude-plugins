# Hierarchy Rendering Guide

**When to use:** Classification, component breakdown, information architecture. The conversation
involves "categories", "structure", "what contains what", or decomposing a system.

**Data source:** Elements with `contains` relations from the state file. The root is typically
the goal or the broadest category.

**Structure:** Tree from top (broadest) to bottom (most specific). Org-chart style connectors.

## Templates

### SVG Container & Defs

```html
<div style="overflow-x: auto;">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}"
       style="max-width: 960px; width: 100%; background: #0f0f1a;
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">

    <defs>
      <!-- Root node gradient -->
      <linearGradient id="rootGrad" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#6366f1" stop-opacity="0.3"/>
        <stop offset="100%" stop-color="#6366f1" stop-opacity="0.08"/>
      </linearGradient>

      <!-- Root glow -->
      <filter id="rootGlow" x="-30%" y="-30%" width="160%" height="160%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
        <feFlood flood-color="#6366f1" flood-opacity="0.35" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>

      <!-- Domain glows (create per branch domain) -->
      <filter id="glow-{domainName}" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="blur"/>
        <feFlood flood-color="{domainColor}" flood-opacity="0.2" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>

      <style>
        .hier-node { cursor: pointer; transition: transform 0.2s ease; }
        .hier-node:hover { transform: scale(1.04); }
        .hier-node:hover rect { stroke-width: 2.5; }

        /* Subtree highlight on hover */
        .hier-connector { transition: stroke-opacity 0.3s; }

        /* Depth indicator line */
        .depth-line { stroke-opacity: 0.15; }

        /* Fade-in staggered by depth */
        .hier-node, .hier-connector {
          opacity: 0; animation: hierFadeIn 0.35s ease-out forwards;
        }
        @keyframes hierFadeIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Tooltip */
        .hier-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2e; border: 1px solid #4a4a7a; border-radius: 8px;
          padding: 10px 14px; font-size: 12px; color: #e2e8f0;
          max-width: 280px; opacity: 0; transition: opacity 0.15s;
          box-shadow: 0 4px 16px rgba(0,0,0,0.5);
        }
        .hier-tooltip.visible { opacity: 1; }
        .hier-tooltip .tt-path {
          font-size: 10px; color: #6366f1; margin-bottom: 4px; opacity: 0.7;
        }
      </style>
    </defs>

    <!-- Depth level indicators (subtle horizontal lines) -->
    {depth_lines}

    <!-- Connectors (render before nodes) -->
    {connectors}

    <!-- Nodes -->
    {nodes}

    <!-- Legend -->
    {legend}
  </svg>
</div>

<div class="hier-tooltip"></div>
```

### Depth Level Indicators

Subtle horizontal lines marking each tree depth level:

```svg
<g class="depth-lines">
  <line class="depth-line" x1="0" y1="{levelY}" x2="{svgWidth}" y2="{levelY}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="2,6"/>
  <text x="8" y="{levelY - 4}" fill="#4a4a7a" font-size="9">Level {depth}</text>
</g>
```

### Node: Root

```svg
<g class="hier-node root" data-id="{nodeId}" data-path="{path}"
   data-tooltip="{description}" transform="translate({x}, {y})"
   filter="url(#rootGlow)" style="animation-delay: 0s;">
  <rect width="{w}" height="{h}" rx="10" fill="url(#rootGrad)" stroke="#6366f1" stroke-width="2.5"/>
  <!-- Inner accent line at top -->
  <line x1="12" y1="2" x2="{w - 12}" y2="2" stroke="#6366f1" stroke-width="2" stroke-opacity="0.5" stroke-linecap="round"/>
  <text x="{w/2}" y="{h/2 - 6}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="14" font-weight="bold">{name}</text>
  <text x="{w/2}" y="{h/2 + 10}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{totalChildren}개 항목</text>
</g>
```

### Node: Branch (decided)

```svg
<g class="hier-node branch" data-id="{nodeId}" data-path="{path}"
   data-tooltip="{description}" data-domain="{domainName}"
   transform="translate({x}, {y})"
   filter="url(#glow-{domainName})" style="animation-delay: {delay}s;">
  <rect width="{w}" height="{h}" rx="6" fill="#1a1a2e" stroke="{domainColor}" stroke-width="1.5"/>
  <!-- Color accent bar -->
  <rect x="0" y="0" width="{w}" height="4" rx="2" fill="{domainColor}" fill-opacity="0.6"/>
  <!-- Left accent bar -->
  <rect width="3" height="{h - 8}" x="0" y="4" rx="1.5" fill="{domainColor}" fill-opacity="0.6"/>
  <!-- Status badge -->
  <circle cx="{w - 10}" cy="10" r="6" fill="{badgeColor}" opacity="0.7"/>
  <text x="{w - 10}" y="12" text-anchor="middle" dominant-baseline="central" fill="white" font-size="7">{badgeIcon}</text>
  <text x="{w/2 + 2}" y="{h/2 - 4}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="12" font-weight="bold">{name}</text>
  <text x="{w/2 + 2}" y="{h/2 + 10}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{childCount}개</text>
</g>
```

### Node: Branch (undecided)

```svg
<g class="hier-node branch" data-id="{nodeId}" data-path="{path}"
   data-tooltip="{description}" data-domain="{domainName}"
   transform="translate({x}, {y})" style="animation-delay: {delay}s;">
  <rect width="{w}" height="{h}" rx="6" fill="#1a1a2e" stroke="#6b7280" stroke-width="1.5" stroke-dasharray="6,3"/>
  <!-- Color accent bar -->
  <rect x="0" y="0" width="{w}" height="4" rx="2" fill="#6b7280" fill-opacity="0.4"/>
  <rect width="3" height="{h - 8}" x="0" y="4" rx="1.5" fill="#6b7280" fill-opacity="0.4"/>
  <!-- Status badge -->
  <circle cx="{w - 10}" cy="10" r="6" fill="{badgeColor}" opacity="0.7"/>
  <text x="{w - 10}" y="12" text-anchor="middle" dominant-baseline="central" fill="white" font-size="7">{badgeIcon}</text>
  <text x="{w/2 + 2}" y="{h/2 - 4}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="12">{name}</text>
  <text x="{w/2 + 2}" y="{h/2 + 10}" text-anchor="middle" dominant-baseline="central"
        fill="#666666" font-size="10">{childCount}개</text>
</g>
```

### Node: Leaf (decided)

```svg
<g class="hier-node leaf" data-id="{nodeId}" data-path="{path}"
   data-tooltip="{description}" transform="translate({x}, {y})"
   style="animation-delay: {delay}s;">
  <rect width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#4ade80" stroke-width="1"/>
  <circle cx="{w - 8}" cy="8" r="3" fill="#4ade80"/>
  <text x="{w/2}" y="{h/2}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="11">{name}</text>
</g>
```

### Node: Leaf (undecided)

```svg
<g class="hier-node leaf" data-id="{nodeId}" data-path="{path}"
   data-tooltip="{description}" transform="translate({x}, {y})"
   style="animation-delay: {delay}s;">
  <rect width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#6b7280" stroke-width="1" stroke-dasharray="4,3"/>
  <circle cx="{w - 8}" cy="8" r="3" fill="#6b7280"/>
  <text x="{w/2}" y="{h/2}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="11">{name}</text>
</g>
```

### Collapsed Group Indicator

```svg
<g class="hier-node collapsed" data-id="{nodeId}" data-tooltip="접힌 {hiddenCount}개 항목"
   transform="translate({x}, {y})" style="animation-delay: {delay}s;">
  <!-- Stacked cards effect -->
  <rect width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#2a2a4a" stroke-width="1"
        transform="translate(4, 4)" opacity="0.3"/>
  <rect width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#2a2a4a" stroke-width="1"
        transform="translate(2, 2)" opacity="0.5"/>
  <rect width="{w}" height="{h}" rx="4" fill="#1a1a2e" stroke="#2a2a4a" stroke-width="1"/>
  <text x="{w/2}" y="{h/2}" text-anchor="middle" dominant-baseline="central"
        fill="#666666" font-size="10">+{hiddenCount} more</text>
</g>
```

### Connector: Organization-Chart Style

```svg
<g class="hier-connector" data-parent="{parentId}" style="animation-delay: {delay}s;">
  <!-- Parent to bus (vertical) -->
  <line x1="{parentCX}" y1="{parentBottom}" x2="{parentCX}" y2="{busY}"
        stroke="{connectorColor}" stroke-width="1.5" stroke-linecap="round"/>
  <!-- Horizontal bus -->
  <line x1="{firstChildCX}" y1="{busY}" x2="{lastChildCX}" y2="{busY}"
        stroke="{connectorColor}" stroke-width="1.5" stroke-linecap="round"/>
  <!-- Bus to each child (vertical) -->
  {childDropLines}
</g>
```

Where each child drop line is:
```svg
<line x1="{childCX}" y1="{busY}" x2="{childCX}" y2="{childTop}"
      stroke="{connectorColor}" stroke-width="1.5" stroke-linecap="round"/>
```

### Legend Panel

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="170" height="{legendHeight}" rx="8"
        fill="#0f0f1a" fill-opacity="0.9" stroke="#2a2a4a" stroke-width="1"/>
  <text x="12" y="18" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- Node types -->
  <rect x="12" y="30" width="24" height="12" rx="4" fill="url(#rootGrad)" stroke="#6366f1" stroke-width="1"/>
  <text x="42" y="39" fill="#888888" font-size="10">루트 노드</text>

  <rect x="12" y="48" width="24" height="12" rx="3" fill="#1a1a2e" stroke="{exampleColor}" stroke-width="1"/>
  <text x="42" y="57" fill="#888888" font-size="10">브랜치</text>

  <rect x="12" y="66" width="24" height="12" rx="2" fill="#1a1a2e" stroke="#4ade80" stroke-width="1"/>
  <text x="42" y="75" fill="#888888" font-size="10">리프 (결정)</text>

  <rect x="12" y="84" width="24" height="12" rx="2" fill="#1a1a2e" stroke="#6b7280" stroke-width="1" stroke-dasharray="3,2"/>
  <text x="42" y="93" fill="#888888" font-size="10">리프 (미결정)</text>

  <!-- Status dots -->
  <circle cx="20" cy="110" r="4" fill="#4ade80"/>
  <text x="30" y="113" fill="#888888" font-size="10">결정됨</text>
  <circle cx="90" cy="110" r="4" fill="#6b7280"/>
  <text x="100" y="113" fill="#888888" font-size="10">미결정</text>
</g>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.hier-tooltip');
const allNodes = document.querySelectorAll('.hier-node');
const allConnectors = document.querySelectorAll('.hier-connector');

// Build parent-child lookup from data-path attributes
// data-path format: "루트 > 프론트엔드 > UI 컴포넌트"
// Each node's ancestors can be derived from its path.
// Alternatively, build from connector data-parent attributes:
const childrenOf = {};  // parentId -> [childIds]
allConnectors.forEach(conn => {
  const parentId = conn.getAttribute('data-parent');
  if (!childrenOf[parentId]) childrenOf[parentId] = [];
  // Find child nodes connected by this connector
  conn.querySelectorAll('line').forEach(line => {
    // Each drop-line's x1 matches a child's cx
  });
});

// Check if candidateId is a descendant of ancestorId
function isDescendant(candidateId, ancestorId) {
  // Use data-path: if candidate's path starts with ancestor's path, it's a descendant
  const candidateNode = document.querySelector(`.hier-node[data-id="${candidateId}"]`);
  const ancestorNode = document.querySelector(`.hier-node[data-id="${ancestorId}"]`);
  if (!candidateNode || !ancestorNode) return false;
  const candidatePath = candidateNode.getAttribute('data-path') || '';
  const ancestorPath = ancestorNode.getAttribute('data-path') || '';
  return candidatePath.startsWith(ancestorPath + ' > ');
}

allNodes.forEach(node => {
  const nodeId = node.getAttribute('data-id');
  const path = node.getAttribute('data-path');

  node.addEventListener('mouseenter', e => {
    const desc = node.getAttribute('data-tooltip');
    tooltip.innerHTML = `
      ${path ? `<div class="tt-path">${path}</div>` : ''}
      <div>${desc}</div>
    `;
    tooltip.classList.add('visible');

    // Highlight this node's subtree connectors, dim everything else
    allConnectors.forEach(conn => {
      const parentId = conn.getAttribute('data-parent');
      const isSubtree = parentId === nodeId || isDescendant(parentId, nodeId);
      conn.style.strokeOpacity = isSubtree ? '1' : '0.15';
    });

    // Dim unrelated nodes
    allNodes.forEach(n => {
      const nId = n.getAttribute('data-id');
      const nPath = n.getAttribute('data-path') || '';
      const isRelated = nId === nodeId || nPath.startsWith(path + ' > ') || path.startsWith(nPath + ' > ');
      n.style.opacity = isRelated ? '1' : '0.3';
    });
  });

  node.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  node.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allConnectors.forEach(conn => conn.style.strokeOpacity = '');
    allNodes.forEach(n => n.style.opacity = '');
  });
});
```

### Summary Stats Box

```svg
<rect x="{boxX}" y="{boxY}" width="380" height="100" rx="12"
      fill="#1a1a2e" stroke="#2a2a4a" stroke-width="1"/>
<text x="{boxCenterX}" y="{boxY + 25}" text-anchor="middle" fill="#e2e8f0" font-size="12" font-weight="bold">구조 요약</text>
<!-- Stats as large numbers with small labels -->
<text x="{stat1X}" y="{boxY + 50}" text-anchor="middle" fill="#4ade80" font-size="20" font-weight="bold">{decidedCount}</text>
<text x="{stat1X}" y="{boxY + 68}" text-anchor="middle" fill="#888" font-size="9">결정됨</text>
<line x1="{divider1X}" y1="{boxY + 38}" x2="{divider1X}" y2="{boxY + 78}" stroke="#2a2a4a" stroke-width="1"/>
<text x="{stat2X}" y="{boxY + 50}" text-anchor="middle" fill="#facc15" font-size="20" font-weight="bold">{undecidedCount}</text>
<text x="{stat2X}" y="{boxY + 68}" text-anchor="middle" fill="#888" font-size="9">미결정</text>
<line x1="{divider2X}" y1="{boxY + 38}" x2="{divider2X}" y2="{boxY + 78}" stroke="#2a2a4a" stroke-width="1"/>
<text x="{stat3X}" y="{boxY + 50}" text-anchor="middle" fill="#818cf8" font-size="20" font-weight="bold">{levelCount}</text>
<text x="{stat3X}" y="{boxY + 68}" text-anchor="middle" fill="#888" font-size="9">깊이</text>
<line x1="{divider3X}" y1="{boxY + 38}" x2="{divider3X}" y2="{boxY + 78}" stroke="#2a2a4a" stroke-width="1"/>
<text x="{stat4X}" y="{boxY + 50}" text-anchor="middle" fill="#e2e8f0" font-size="20" font-weight="bold">{domainCount}</text>
<text x="{stat4X}" y="{boxY + 68}" text-anchor="middle" fill="#888" font-size="9">도메인</text>
```

## Rules

### Node styling rules
- **Root**: gradient fill (`#6366f1` 30% -> 8%), glow filter, top accent line, bold 14px text, total child count
- **Branch (decided)**: `#1a1a2e` fill, domain-color border solid, left accent bar in domain color, green status dot
- **Branch (undecided)**: `#1a1a2e` fill, gray border dashed `6,3`, gray accent bar, gray status dot
- **Leaf (decided)**: small rect, green border solid, green status dot
- **Leaf (undecided)**: small rect, gray border dashed `4,3`, gray status dot
- Branch nodes show child count; root shows total descendant count
- **Level 3+ nodes**: minimum width 44px, minimum height 40px, border-radius 5px, font-size 9px for name, 8px for status. These nodes represent implementation detail — visually receded but still legible.
- **Status badges on branch nodes**: `badgeColor` is `#4ade80` with `badgeIcon` = ✓ for fully-decided branches (all descendants decided), `#facc15` with `badgeIcon` = ! for partially-decided branches (some descendants undecided)

### Domain color rules
- Each top-level branch gets a distinct domain color from the palette (see color-palette.md)
- The domain color cascades to all descendants of that branch
- Connector lines use the parent's domain color at 60% opacity
- This color-coding makes it easy to visually identify which branch an item belongs to

### Connector rules
- Organization-chart style: parent-to-bus (vertical) -> horizontal bus -> bus-to-child (vertical)
- Connector color: parent's domain color (or `#4a4a7a` for root-level connectors)
- `stroke-width: 1.5`, `stroke-linecap: round`
- All connector segments are solid lines (no dashes)
- Connector opacity fades with depth, but must stay visible:
  - Level 0→1: `#4a4a7a` at 2px, 50% opacity
  - Level 1→2: domain color at 50% opacity, 1.5px
  - Level 2→3: domain color at 35% opacity, 1px

### Depth indicator rules
- Subtle dashed horizontal lines at each tree depth level
- "Level N" label at far left in dim color
- Helps users understand the hierarchical depth at a glance

### Collapsed group rules
- If a branch has more than 6 children, show the first 5 and a collapsed "+N more" indicator
- Collapsed indicator uses stacked-cards visual effect (3 offset rectangles)

### Animation rules
- Nodes fade in with staggered delay based on depth: `delay = depth * 0.15s`
- Connectors animate at the same time as their parent node
- Root appears first, then Level 1 branches, then Level 2, etc.
- **Important**: The fade-in animation must only animate `opacity`, not `transform`. Using `translateY` in CSS keyframes conflicts with SVG `transform="translate()"` attributes and causes nodes to render at wrong positions. Use `from { opacity: 0 } to { opacity: 1 }` only.

### Tooltip rules
- Show **breadcrumb path** at top of tooltip (e.g., "프로젝트 > 프론트엔드 > UI 컴포넌트")
- Below path: node description
- On hover: highlight the entire subtree's connectors, dim everything else

### Legend rules
- Include at bottom-right: node types and status dots. Do NOT include domain color swatches — each branch already shows its domain color through border and accent bar styling, so repeating them in the legend is redundant

### Summary stats box rules
- Always include a summary stats box at the bottom showing: decided count (green `#4ade80`), undecided count (yellow `#facc15`), depth/levels (indigo `#818cf8`), and domain count (white `#e2e8f0`). Separate each stat with vertical divider lines.

## Layout Algorithm

Top-down tree with children centered under their parent. All values in px.

```
// --- Configuration ---
levelGap = 80           // vertical distance between levels
siblingGap = 24         // horizontal gap between sibling nodes within same branch
branchGap = 48          // horizontal gap between top-level branch subtrees (root's children)
rootHeight = 56         // root node height
branchHeight = 48       // branch node height
leafHeight = 36         // leaf node height (36px, not 32 — keeps text legible)
minNodeWidth = 80       // minimum node width

// --- Step 1: Calculate node dimensions ---
for node in allNodes:
    node.width = max(minNodeWidth, nodeWidth(node.label, node.fontSize))
    node.height = rootHeight if node.isRoot else (branchHeight if node.hasChildren else leafHeight)

// --- Step 2: Calculate subtree widths (bottom-up) ---
function subtreeWidth(node):
    if node has no visible children: return node.width
    // "visible children" = first 5 if > 6 children, plus collapsed indicator
    visibleChildren = node.children[:5] if len(node.children) > 6 else node.children
    if len(node.children) > 6:
        visibleChildren.append(collapsedIndicator(len(node.children) - 5))

    childrenTotalWidth = sum(subtreeWidth(c) for c in visibleChildren)
                       + siblingGap * (len(visibleChildren) - 1)
    return max(node.width, childrenTotalWidth)

// --- Step 3: Position nodes (top-down) ---
function position(node, x, y):
    stw = subtreeWidth(node)
    node.x = x + (stw - node.width) / 2     // center node in its subtree
    node.y = y

    if not node.visibleChildren: return

    childX = x
    childY = y + node.height + levelGap

    gap = branchGap if node.isRoot else siblingGap
    for child in node.visibleChildren:
        position(child, childX, childY)
        childX += subtreeWidth(child) + gap

// Start layout
position(root, 40, 40)

// --- Step 4: Build breadcrumb paths (for data-path attribute) ---
function buildPaths(node, parentPath):
    node.path = parentPath ? parentPath + ' > ' + node.label : node.label
    for child in node.visibleChildren:
        buildPaths(child, node.path)

buildPaths(root, '')
// Example: root.path = "프로젝트", child.path = "프로젝트 > 프론트엔드"

// --- Step 5: Assign domain colors ---
for i, topBranch in enumerate(root.children):
    domainColor = domainColors[i % 8]  // from color-palette.md
    assignColor(topBranch, domainColor)  // recursive cascade to all descendants

// --- Step 6: Calculate bus-line connectors ---
for node in nodesWithChildren:
    busY = node.y + node.height + levelGap / 2
    parentCX = node.x + node.width / 2
    children = node.visibleChildren

    // Vertical from parent bottom to bus
    line(parentCX, node.y + node.height, parentCX, busY)
    // Horizontal bus
    firstCX = children[0].x + children[0].width / 2
    lastCX = children[-1].x + children[-1].width / 2
    line(firstCX, busY, lastCX, busY)
    // Drops to each child
    for child in children:
        childCX = child.x + child.width / 2
        line(childCX, busY, childCX, child.y)

// --- Step 7: Position depth lines ---
for depth in range(maxDepth):
    levelY = 40 + depth * (branchHeight + levelGap)
    // Horizontal dashed line at this Y

// --- Step 8: Calculate viewBox and legend position ---
allNodes = flatten tree
minX = min(n.x for n in allNodes) - 40
maxX = max(n.x + n.width for n in allNodes) + 40 + 180  // +180 for legend
maxY = max(n.y + n.height for n in allNodes) + 40
viewBoxWidth = maxX - minX
viewBoxHeight = maxY

// Legend position: bottom-right, outside content area
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
// legendHeight depends on content (base ~90 + 18 per legend entry)
```

### CJK Node Width

```
function nodeWidth(label, fontSize):
    wideChars = count Korean/CJK characters
    latinChars = len(label) - wideChars
    textWidth = (wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return textWidth + 32  // 16px padding each side
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- With deeply nested trees (5+ levels), the vertical space can become extreme. Consider using `levelGap = 60` for trees deeper than 4 levels.
- Domain color cascading is the most impactful visual feature — it lets users instantly identify which top-level branch any deep leaf belongs to without tracing connectors.
- The breadcrumb path in tooltips ("프로젝트 > 프론트엔드 > UI") eliminates the need to visually trace the tree upward — very useful for deep/wide trees.
- Stacked-cards effect for collapsed groups is more visually informative than a plain "+N more" text block — users immediately understand there's hidden content.
- `stroke-linecap: round` on connectors gives a softer, more polished appearance than the default butt caps.
- The color accent bar on branch nodes makes domain scanning instant — always include it.
- Status badges (corner ✓/!) provide at-a-glance health without reading every node.
- Level 3+ nodes should never go below 48px wide or 10px font — unreadable nodes are worse than omitted ones. Level 3 text should be `#b0b0c0` (not `#a0a0b0` which is too dim).
- The summary stats box answers "where are we?" at a glance.
- **Depth level zone shading**: Add very subtle alternating horizontal rect backgrounds behind each depth level (`#6366f103` for odd, `#ffffff02` for even). This creates visual lanes that help users maintain their reading position in wide trees.
- **Depth level labels**: Add small labels on the far left edge (e.g., "ROOT", "L1 · 도메인", "L2 · 컴포넌트", "L3 · 세부") at 70% opacity, font-size 9px. These anchor the viewer's sense of depth without cluttering the tree.
- **Connector line opacity minimums**: Root→L1 connectors at 50% domain color opacity, L1→L2 at 50%, L2→L3 at 35%. Previous values (25-40%) made connectors invisible. Use `stroke-width: 2` for root level, 1.5 for L1→L2, 1 for L2→L3.
- **Bus line styling**: The horizontal bus line connecting siblings should use the parent's domain color at 40% opacity (not `#4a4a7a` structural gray). This reinforces the domain association.
- **Status badge circles**: Use `fill="{statusColor}20" stroke="{statusColor}"` circles (r=8) instead of plain filled dots. The outlined style is more readable at small sizes.
- **Summary box divider**: Add a horizontal line (`stroke="#2a2a4a"`) between the title and stats to separate them visually. Use `font-size: 22` for stat numbers (not 20) and `#94a3b8` for stat labels (not `#888`).
- **CDN-type narrow nodes**: When a node label is very short (≤3 chars), enforce a minimum width of 64px to prevent nodes that are too narrow to click or read.
