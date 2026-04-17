# Flowchart Rendering Guide

**When to use:** Process design, sequential steps, conditional logic. The conversation is about
"what order?", "what steps?", or designing a workflow with decision points.

**Data source:** Elements typed as `process`, `decision`, `step` from the state file,
plus `precedes` and `depends-on` relations.

**Structure:** Start -> steps -> decision diamonds -> branches -> end.

## Templates

### SVG Container & Defs

```html
<div style="overflow-x: auto;">
  <svg width="100%" viewBox="0 0 {viewBoxWidth} {viewBoxHeight}"
       preserveAspectRatio="xMidYMid meet"
       style="background: #0f0f1a; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">
    <defs>
      <!-- Arrow markers -->
      <marker id="arrow-main" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#facc15"/>
      </marker>
      <marker id="arrow-alt" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#6b7280"/>
      </marker>
      <marker id="arrow-error" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#ef4444"/>
      </marker>

      <!-- Glow filters -->
      <filter id="glow-active" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
        <feFlood flood-color="#facc15" flood-opacity="0.25" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-decided" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur"/>
        <feFlood flood-color="#4ade80" flood-opacity="0.2" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>

      <style>
        .flow-node { cursor: pointer; transition: transform 0.2s ease; }
        .flow-node:hover { transform: scale(1.04); }

        /* Edge highlight on node hover — via JS */
        .flow-edge { transition: stroke-opacity 0.3s; }
        .flow-edge.dimmed { stroke-opacity: 0.15; }
        .flow-edge.highlighted { stroke-opacity: 1; }

        /* Step number badge */
        .step-badge {
          font-size: 10px; font-weight: bold; fill: #0f0f1a;
        }

        /* Fade-in */
        .flow-node, .flow-edge {
          opacity: 0; animation: flowFadeIn 0.35s ease-out forwards;
        }
        @keyframes flowFadeIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Tooltip */
        .flow-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2e; border: 1px solid #4a4a7a; border-radius: 8px;
          padding: 8px 12px; font-size: 12px; color: #e2e8f0;
          max-width: 260px; opacity: 0; transition: opacity 0.15s;
          box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }
        .flow-tooltip.visible { opacity: 1; }
      </style>
    </defs>

    <!-- Optional: Swim lane backgrounds -->
    {swimLanes}

    <!-- Edges (render before nodes so nodes overlay) -->
    {edges}

    <!-- Nodes -->
    {nodes}

    <!-- Legend -->
    {legend}
  </svg>
</div>

<div class="flow-tooltip"></div>
```

### Start Node (Stadium Shape)

```svg
<g class="flow-node start" data-id="{nodeId}" data-tooltip="{description}"
   style="animation-delay: 0s;">
  <rect x="{x}" y="{y}" width="{width}" height="40" rx="20"
        fill="#1a1a2e" stroke="#4ade80" stroke-width="2.5"
        filter="url(#glow-decided)"/>
  <text x="{cx}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#4ade80" font-size="13" font-weight="bold">{label}</text>
</g>
```

### End Node (Stadium Shape)

```svg
<g class="flow-node end" data-id="{nodeId}" data-tooltip="{description}"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="40" rx="20"
        fill="#1a1a2e" stroke="#4ade80" stroke-width="2.5"/>
  <!-- Double border for end node -->
  <rect x="{x + 3}" y="{y + 3}" width="{width - 6}" height="34" rx="17"
        fill="none" stroke="#4ade80" stroke-width="1" stroke-opacity="0.5"/>
  <text x="{cx}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#4ade80" font-size="13" font-weight="bold">{label}</text>
</g>
```

### Process Step Node

```svg
<g class="flow-node process" data-id="{nodeId}" data-tooltip="{description}"
   data-status="{status}" style="animation-delay: {delay}s;">
  <!-- Step number badge -->
  <circle cx="{x - 4}" cy="{y - 4}" r="10" fill="{statusColor}"/>
  <text class="step-badge" x="{x - 4}" y="{y - 1}" text-anchor="middle"
        dominant-baseline="central">{stepNumber}</text>

  <rect x="{x}" y="{y}" width="{width}" height="52" rx="8"
        fill="#1a1a2e" stroke="{statusColor}" stroke-width="{strokeWidth}"
        {dashAttr} {filterAttr}/>
  <!-- dashAttr: stroke-dasharray="6,3" if pending -->
  <!-- filterAttr: filter="url(#glow-active)" if active, filter="url(#glow-decided)" if decided -->

  <text x="{cx}" y="{cy - 7}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{stepName}</text>
  <text x="{cx}" y="{cy + 10}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="11">{briefDescription}</text>
</g>
```

### Decision Diamond

```svg
<g class="flow-node decision" data-id="{nodeId}" data-tooltip="{question}"
   style="animation-delay: {delay}s;">
  <rect x="{dx}" y="{dy}" width="{diamondSize}" height="{diamondSize}" rx="4"
        transform="rotate(45, {cx}, {cy})"
        fill="#1a1a2e" stroke="#facc15" stroke-width="2.5"
        filter="url(#glow-active)"/>
  <!-- Diamond label — keep short (max ~8 chars Korean, ~12 chars Latin) -->
  <text x="{cx}" y="{cy - 4}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="12" font-weight="bold">{decisionLabel}</text>
  <text x="{cx}" y="{cy + 12}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{question}</text>
</g>
```

### Parallel Fork/Join Bar

For indicating parallel execution paths:

```svg
<g class="flow-node parallel" style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="6" rx="3"
        fill="#e2e8f0"/>
  <text x="{cx}" y="{y - 8}" text-anchor="middle"
        fill="#888888" font-size="10">{label}</text>
  <!-- label: "병렬 시작" or "병렬 합류" -->
</g>
```

### Main Flow Arrow (Solid, vertical)

```svg
<path class="flow-edge main" data-from="{fromId}" data-to="{toId}"
      d="M {startX},{startY} L {startX},{midY} L {endX},{midY} L {endX},{endY}"
      stroke="#facc15" stroke-width="2" fill="none"
      marker-end="url(#arrow-main)"
      style="animation-delay: {delay}s;"/>
```

### Alternative/Branch Arrow (right-angle routed)

```svg
<path class="flow-edge alt" data-from="{fromId}" data-to="{toId}"
      d="M {startX},{startY} L {turnX},{startY} L {turnX},{endY} L {endX},{endY}"
      stroke="#6b7280" stroke-width="1.5" stroke-dasharray="6,3" fill="none"
      marker-end="url(#arrow-alt)"
      style="animation-delay: {delay}s;"/>
```

### Error Path Arrow

```svg
<path class="flow-edge error" data-from="{fromId}" data-to="{toId}"
      d="M {startX},{startY} L {turnX},{startY} L {turnX},{endY} L {endX},{endY}"
      stroke="#ef4444" stroke-width="1.5" stroke-dasharray="6,3" fill="none"
      marker-end="url(#arrow-error)"
      style="animation-delay: {delay}s;"/>
```

### Branch Label

```svg
<g class="branch-label">
  <!-- Background pill for readability -->
  <rect x="{labelX - labelWidth/2 - 6}" y="{labelY - 8}" width="{labelWidth + 12}" height="16"
        rx="4" fill="#0f0f1a" fill-opacity="0.85"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="{labelColor}" font-size="11" font-weight="bold">{branchLabel}</text>
</g>
<!-- e.g., "Yes" / "No", "성공" / "실패", option names -->
<!-- labelColor: #4ade80 for positive branch, #ef4444 for error, #888888 for neutral -->
```

### Merge Point Indicator

```svg
<circle cx="{mergeX}" cy="{mergeY}" r="6" fill="#1a1a2e" stroke="#facc15" stroke-width="2"/>
<!-- Small diamond or circle where branches reconverge -->
```

### Swim Lane Background (optional)

```svg
<g class="swim-lane">
  <rect x="{laneX}" y="0" width="{laneWidth}" height="{svgHeight}"
        fill="{domainColor}" fill-opacity="0.03"/>
  <text x="{laneX + laneWidth/2}" y="20" text-anchor="middle"
        fill="{domainColor}" fill-opacity="0.4" font-size="11" font-weight="bold">{laneName}</text>
  <line x1="{laneX + laneWidth}" y1="0" x2="{laneX + laneWidth}" y2="{svgHeight}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="4,4"/>
</g>
```

### Legend Panel

**Preferred: HTML legend outside SVG** (uses the shared `.legend` CSS pattern from `visualization.md`).
Place below the SVG `</div>` container. Uses CSS-styled spans for node/edge type indicators:

```html
<div class="legend">
  <span class="legend-item">
    <span style="width:24px;height:14px;border:1.5px solid #4ade80;border-radius:7px;display:inline-block"></span>
    시작/종료
  </span>
  <span class="legend-item">
    <span style="width:24px;height:14px;border:1.5px solid #e2e8f0;border-radius:4px;display:inline-block"></span>
    프로세스 단계
  </span>
  <span class="legend-item">
    <span style="width:14px;height:14px;border:1.5px solid #facc15;border-radius:2px;display:inline-block;transform:rotate(45deg)"></span>
    분기 결정
  </span>
  <span class="legend-item">
    <span style="width:20px;height:0;border-top:2px solid #4ade80;display:inline-block"></span>
    완료 플로우
  </span>
  <span class="legend-item">
    <span style="width:20px;height:0;border-top:2px solid #6366f1;display:inline-block"></span>
    현재/대기 플로우
  </span>
  <span class="legend-item">
    <span style="width:20px;height:0;border-top:2px dashed #6b7280;display:inline-block"></span>
    대안 경로
  </span>
  <span class="legend-item">
    <span style="width:20px;height:0;border-top:2px dashed #f87171;display:inline-block"></span>
    에러 경로
  </span>
  <span class="legend-item">
    <span class="legend-dot" style="background:#4ade80;box-shadow:0 0 6px #4ade8060"></span>
    완료
  </span>
  <span class="legend-item">
    <span class="legend-dot" style="background:#facc15;box-shadow:0 0 6px #facc1560"></span>
    현재
  </span>
  <span class="legend-item">
    <span class="legend-dot" style="background:#6366f1"></span>
    대기
  </span>
</div>
```

The HTML legend auto-wraps at any viewport width. Avoid SVG-embedded legends — they require manual coordinate math, can clip at viewBox edges, and inline SVG shapes cause vertical stacking issues.

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.flow-tooltip');
const allEdges = document.querySelectorAll('.flow-edge');
const allNodes = document.querySelectorAll('.flow-node');

allNodes.forEach(node => {
  const nodeId = node.getAttribute('data-id');

  node.addEventListener('mouseenter', e => {
    const desc = node.getAttribute('data-tooltip');
    if (!desc) return;
    const status = node.getAttribute('data-status');
    const statusLabel = { active: '현재', completed: '완료', pending: '대기' }[status] || '';
    const statusColor = { active: '#facc15', completed: '#4ade80', pending: '#6b7280' }[status] || '#888888';

    tooltip.innerHTML = `<div style="font-weight:bold;margin-bottom:4px;">${desc}</div>` +
      (statusLabel ? `<span style="display:inline-block;padding:1px 6px;border-radius:4px;font-size:10px;font-weight:bold;background:${statusColor}20;color:${statusColor}">${statusLabel}</span>` : '');
    tooltip.classList.add('visible');

    // Highlight connected edges
    allEdges.forEach(edge => {
      if (edge.getAttribute('data-from') === nodeId || edge.getAttribute('data-to') === nodeId) {
        edge.classList.add('highlighted'); edge.classList.remove('dimmed');
      } else {
        edge.classList.add('dimmed'); edge.classList.remove('highlighted');
      }
    });
  });

  node.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  node.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allEdges.forEach(edge => edge.classList.remove('highlighted', 'dimmed'));
  });
});
```

## Rules

### Layout direction
- Use SVG with **top-to-bottom** flow — vertical orientation reads more naturally for processes
- The happy/main path always flows straight down the center column
- Alternative branches go to the left or right
- Add a subtle vertical guide rail down the center to reinforce the main flow axis:
  ```svg
  <line x1="{centerX}" y1="50" x2="{centerX}" y2="{totalHeight - 40}" stroke="#1e1e36" stroke-width="1" stroke-dasharray="4,8"/>
  ```
  Render this line before edges so it sits behind all content.

### Node type rules
- If node is **start or end** -> stadium shape (large `rx` = half of height)
- End node additionally has a double border (inner rect at 50% opacity)
- If node is **process step** -> rectangle with `rx="8"`, step number badge in top-left
- If node is **decision point** -> rotated square (diamond) via `transform="rotate(45)"`, yellow border
- If node is **parallel fork/join** -> thick horizontal bar (6px height, rounded)

### Step numbering rules
- Number process steps sequentially along the main path: 1, 2, 3...
- Step badge: colored circle (10px radius) with number text at node's top-left corner
- Badge color matches node status color
- Additionally, add subtle step numbers to the left of each process node. Use `text-anchor='end'`, `fill='#4a4a7a'` for completed/pending steps, `fill='#facc1580'` for the active step. Font-size 10px, bold.

### Node status rules (three-state visual system)
- **Completed** -> solid green border `#4ade80`, stroke-width `2`, opacity `0.85`, green checkmark circle inside the node (small `<circle>` + `<text>✓</text>` at top-right), `filter="url(#glow-decided)"`, step badge green
- **Active/Current** -> yellow border `#facc15`, stroke-width `2.5`, `filter="url(#glow-active)"`, gradient fill on the node body, pulsing dot animation near the step badge (use a `<circle>` with CSS `@keyframes pulse`), step badge yellow
- **Pending** -> dashed gray border `#6b7280`, stroke-width `1.5`, `stroke-dasharray="6,3"`, no glow filter, step badge gray
- Decision diamonds always use yellow border `#facc15`

### Decision branch rules
- From a decision diamond -> draw two or more labeled branches
- Label each branch with a background pill for readability
- Positive/success branch label in green `#4ade80`
- Error/failure branch label in red `#ef4444`
- Neutral branch labels in gray `#888888`
- Keep primary/happy path centered -> alternatives branch to the sides
- If branches reconverge -> show merge point indicator (small circle)

### Arrow styling rules
- **Main flow** -> solid stroke, 2px, yellow `#facc15`, arrowhead
- **Alternative path** -> dashed stroke, 1.5px, gray `#6b7280`, `stroke-dasharray: 6,3`
- **Error path** -> dashed stroke, 1.5px, red `#ef4444`, `stroke-dasharray: 6,3`
- All arrows -> use right-angle routing (L-shaped or U-shaped) for clean appearance
- Right-angle routing: vertical segment -> horizontal segment -> vertical segment

### Swim lane rules (optional)
- If process involves distinct actors/domains -> add vertical swim lane backgrounds
- Each lane: subtle fill at 3% domain color, lane name at top, dashed separator line
- Nodes positioned within their respective lanes

### Legend rules
- Always include legend panel at bottom-right
- Show node types, edge types, and status indicators
- **Important:** Never use inline SVG elements (e.g. `<rect>`, `<circle>`, `<line>`) inside HTML legend items -- they cause vertical stacking layout issues. Use CSS-styled spans with dot/border classes instead:
  ```html
  <span class='legend-item'><span class='legend-dot' style='background:#4ade80'></span> 완료</span>
  ```
  For edge types, use `border-top` styles on spans:
  ```html
  <span style='width:20px;height:0;border-top:2px dashed #f87171;display:inline-block'></span>
  ```

## Layout Algorithm

Top-to-bottom flow with automatic branching. All values in px.

```
// --- Configuration ---
nodeWidth = 180          // default process node width
nodeHeight = 52          // process node height
diamondSize = 56         // decision diamond side length
verticalGap = 60         // vertical gap between nodes
horizontalGap = 80       // horizontal gap between parallel branches
startY = 40              // top padding
centerX = viewBoxWidth / 2

// --- Step 1: Build flow graph ---
// Parse state file into a directed graph of nodes with edges.
// Identify: startNode, endNode, decision nodes, merge points.

// --- Step 2: Identify main path ---
// The main path is the longest path from start to end.
// Place main path nodes on the center column.

mainPathX = centerX - nodeWidth / 2
currentY = startY

for node in mainPath:
    node.x = mainPathX
    node.y = currentY
    node.cx = mainPathX + nodeWidth / 2
    node.cy = currentY + nodeHeight / 2

    if node.type == 'decision':
        // Diamond is square, rotated 45 degrees
        node.x = centerX - diamondSize / 2
        node.y = currentY
        node.cx = centerX
        node.cy = currentY + diamondSize / 2
        currentY += diamondSize + verticalGap
    else:
        currentY += nodeHeight + verticalGap

// --- Step 3: Position branch nodes ---
// For each decision node, position alternative branches to the side.

for decisionNode in decisionNodes:
    mainBranch = decisionNode.branches[0]     // first branch stays centered
    altBranches = decisionNode.branches[1:]   // others go left/right

    for i, branch in altBranches:
        // Alternate sides: odd to right, even to left
        side = 1 if (i % 2 == 0) else -1
        offsetX = (floor(i / 2) + 1) * (nodeWidth + horizontalGap) * side

        branchX = centerX + offsetX - nodeWidth / 2
        branchY = decisionNode.y + diamondSize + verticalGap

        for j, branchNode in branch.nodes:
            branchNode.x = branchX
            branchNode.y = branchY + j * (nodeHeight + verticalGap)
            branchNode.cx = branchX + nodeWidth / 2
            branchNode.cy = branchNode.y + nodeHeight / 2

// --- Step 4: Handle merge points ---
// When branches reconverge, find the merge target node.
// All branch endpoints connect back to the merge node.

for mergeNode in mergeNodes:
    // mergeNode is already on the main path at its calculated Y
    // Add merge indicator at mergeNode.y - 12

// --- Step 5: Route edges ---
function routeEdge(fromNode, toNode, type):
    startX = fromNode.cx
    startY = fromNode.y + fromNode.height

    endX = toNode.cx
    endY = toNode.y

    if startX == endX:
        // Straight vertical line (main path)
        return "M {startX},{startY} L {endX},{endY}"
    else:
        // Right-angle routing
        // Go down halfway, then horizontal, then down to target
        midY = (startY + endY) / 2
        return "M {startX},{startY} L {startX},{midY} L {endX},{midY} L {endX},{endY}"

// --- Step 6: Position branch labels ---
// Labels sit on the edge, near the decision node
function labelPosition(decisionNode, branchDirection):
    if branchDirection == 'down':
        return (decisionNode.cx, decisionNode.cy + diamondSize/2 + 16)
    elif branchDirection == 'right':
        return (decisionNode.cx + diamondSize/2 + 20, decisionNode.cy)
    elif branchDirection == 'left':
        return (decisionNode.cx - diamondSize/2 - 20, decisionNode.cy)

// --- Step 7: Calculate viewBox and legend position ---
allNodes = all positioned nodes
minX = min(n.x for n in allNodes) - 60
maxX = max(n.x + n.width for n in allNodes) + 60 + 180  // +180 for legend
minY = 0
maxY = max(n.y + n.height for n in allNodes) + 60
viewBoxWidth = maxX - minX
viewBoxHeight = maxY - minY

// Legend position: bottom-right, outside content area
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
// legendHeight depends on content (base ~100 + 18 per legend entry)
```

### CJK Node Width Calculation

```
function nodeWidth(label, fontSize = 13):
    wideChars = count Korean/CJK characters
    latinChars = len(label) - wideChars
    textWidth = (wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return max(140, textWidth + 40)  // minimum 140px for process nodes
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- Decision diamond text can overflow if the label is too long. Keep diamond labels under 8 Korean characters or 12 Latin characters. Put the full question in the smaller description text below.
- Right-angle routing produces cleaner flowcharts than curved paths for this visualization type — curves can look chaotic when there are many branches.
- When 4+ branches emerge from a single decision, stack them alternating left-right. First alternative goes right, second goes left, third goes further right, etc.
- Swim lanes are most useful when the process crosses 3+ domains. For 2 or fewer domains, skip swim lanes and use node border colors instead.
- Inline SVG shapes (`<rect>`, `<circle>`, `<line>`) inside HTML legend items cause vertical stacking. Always use CSS-styled span dots instead.
- Step numbers provide orientation in complex flows — always include them.
- The vertical guide rail subtly reinforces flow direction and should always be rendered behind edges and nodes.
- **Step number badges must be prominent**: Use colored circle badges (r=13) with a subtle fill matching the status color at 15% and a stroke at 60% opacity. Number text should be 11px bold. Gray badges for pending steps are nearly invisible — use the status color for the circle border even on pending steps (use `#6366f1` for pending instead of gray).
- **Progress rail background**: Add a faint rectangle (`fill: linear-gradient from #4ade80 at 12% to 3%`) behind completed steps to visually separate the "done" zone from the "pending" zone.
- **Node color accent bars**: Add a 5px-tall colored rectangle across the top of each process step node (`fill="{statusColor}" opacity="0.5"`) for visual hierarchy. This echoes the concept map pattern and dramatically improves scannability.
- **Branch label pills with colored tints**: Branch labels should use tinted pill backgrounds that match their meaning: `fill="#4ade8018" stroke="#4ade8030"` for positive, `fill="#f8717118" stroke="#f8717130"` for error, `fill="#6366f118" stroke="#6366f130"` for neutral. The `rx="8"` rounded pill shape improves readability over flat rectangles.
- **Arrow color should reflect completion**: Arrows between completed steps should use green `#4ade80` markers and stroke. Arrows on the main path from active onward use indigo `#6366f1`. Error paths use red `#f87171`. This makes the flow state instantly scannable.
- **Error path label pills**: Error path annotations ("재입력 요청", etc.) must have background pills matching the error color at 18% opacity. Without these, labels on red dashed lines are unreadable.
- **Branch label placement**: Place branch labels at the midpoint of the edge path, then nudge 10-15px perpendicular to the edge direction toward empty space. Labels must not overlap with node rects, step number badges, or other branch labels. When a decision node has 3+ outgoing branches, spread labels evenly around the node rather than clustering them.
- **Loop-back edge routing**: When a branch loops back to an earlier step (e.g., validation failure -> re-enter input), route the edge: right from branch node -> further right -> vertically back to target Y -> left into target node. This creates a clear "return loop" shape on the right side. Add a descriptive label on the vertical segment (e.g., "이메일 재입력", "재발송 (최대 3회)") with a tinted pill matching the edge color.
- **Legend placement**: Use the shared HTML legend pattern (outside SVG, centered below the chart) rather than an SVG-embedded legend. SVG legends require manual coordinate math and can clip at edges. The HTML legend auto-wraps and stays readable at any viewport width.
- **ViewBox sizing**: Calculate viewBox tightly from actual node positions. Add 40px padding on all sides plus extra right margin (120-140px) for loop-back labels. Do not set viewBox height larger than the content — excess whitespace creates a dead zone between the chart and the legend.
- **Left accent bars on branch nodes**: Error/alt branch nodes should also have a 4px left accent bar in their path color (red for error, gray for alt). This maintains visual consistency with main-path nodes and adds quick scannability.
