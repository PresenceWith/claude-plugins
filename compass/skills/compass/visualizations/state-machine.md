# State Machine Rendering Guide

**When to use:** Lifecycle, status transitions, event-driven flows. The conversation involves
state changes, user journeys, or "what happens when X triggers?"

**Data source:** Elements representing states, with relations showing transitions
(events/actions that cause state changes).

**Structure:** State nodes connected by labeled transition arrows. Supports initial indicator,
normal/active/terminal/error states, self-loops, and guard conditions.

## Templates

### SVG Container & Defs

```html
<div style="overflow-x: auto;">
  <svg width="100%" viewBox="0 0 {viewBoxWidth} {viewBoxHeight}"
       preserveAspectRatio="xMidYMid meet"
       style="background: #0f0f1a; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">
    <defs>
      <!-- Arrowheads -->
      <marker id="arrow-primary" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#facc15"/>
      </marker>
      <marker id="arrow-secondary" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#888888"/>
      </marker>
      <marker id="arrow-error" markerWidth="10" markerHeight="8"
              refX="9" refY="4" orient="auto-start-reverse">
        <polygon points="0,1 10,4 0,7" fill="#ef4444"/>
      </marker>
      <marker id="arrow-init" markerWidth="8" markerHeight="6"
              refX="7" refY="3" orient="auto-start-reverse">
        <polygon points="0,0.5 8,3 0,5.5" fill="#e2e8f0"/>
      </marker>

      <!-- Glow filters -->
      <filter id="glow-active" x="-30%" y="-30%" width="160%" height="160%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
        <feFlood flood-color="#facc15" flood-opacity="0.3" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-terminal" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="blur"/>
        <feFlood flood-color="#4ade80" flood-opacity="0.2" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-final" x="-30%" y="-30%" width="160%" height="160%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur"/>
        <feFlood flood-color="#4ade80" flood-opacity="0.25" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-error" x="-30%" y="-30%" width="160%" height="160%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur"/>
        <feFlood flood-color="#f87171" flood-opacity="0.25" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>

      <style>
        .state-node { cursor: pointer; transition: transform 0.2s ease; }
        .state-node:hover { transform: scale(1.05); }

        /* Transition highlight on state hover */
        .sm-transition { transition: stroke-opacity 0.3s, stroke-width 0.3s; }
        .sm-transition.dimmed { stroke-opacity: 0.1; }
        .sm-transition.highlighted { stroke-opacity: 1; }
        .sm-transition.highlighted path { stroke-width: 3; }

        /* Active state pulse */
        @keyframes statePulse {
          0%, 100% { stroke-opacity: 1; }
          50%      { stroke-opacity: 0.5; }
        }
        .state-node.active rect {
          animation: statePulse 2s ease-in-out infinite;
        }

        /* Fade-in */
        .state-node, .sm-transition {
          opacity: 0; animation: smFadeIn 0.35s ease-out forwards;
        }
        @keyframes smFadeIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Tooltip */
        .sm-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2e; border: 1px solid #4a4a7a; border-radius: 8px;
          padding: 10px 14px; font-size: 12px; color: #e2e8f0;
          max-width: 300px; opacity: 0; transition: opacity 0.15s;
          box-shadow: 0 4px 16px rgba(0,0,0,0.5);
        }
        .sm-tooltip.visible { opacity: 1; }
        .sm-tooltip .tt-transitions {
          margin-top: 6px; padding-top: 6px; border-top: 1px solid #2a2a4a;
          font-size: 11px; color: #888888;
        }
        .sm-tooltip .tt-transition-item {
          display: flex; align-items: center; gap: 4px; margin-top: 2px;
        }
      </style>
    </defs>

    <!-- Composite state backgrounds (optional) -->
    {composite_states}

    <!-- Happy path lane (behind main flow) -->
    {happy_path_lane}

    <!-- Transitions (render before states) -->
    {transitions}

    <!-- Initial state indicator -->
    {initial_indicator}

    <!-- State nodes -->
    {state_nodes}

    <!-- Legend -->
    {legend}
  </svg>
</div>

<div class="sm-tooltip"></div>
```

### Initial State Indicator

```svg
<g class="initial-indicator" style="animation-delay: 0s;">
  <circle cx="{ix}" cy="{iy}" r="8" fill="#e2e8f0"/>
  <path d="M {ix + 10},{iy} L {firstStateEdgeX},{firstStateEdgeY}"
        stroke="#e2e8f0" stroke-width="2" fill="none"
        marker-end="url(#arrow-init)"/>
</g>
```

### Happy Path Lane

```svg
<rect x="40" y="{laneY}" width="{laneWidth}" height="110" rx="8" fill="#6366f103"/>
<text x="{laneCenterX}" y="{laneY - 4}" text-anchor="middle" fill="#6366f130" font-size="10"
      font-weight="500" letter-spacing="3">HAPPY PATH</text>
```

Include a subtle happy path lane highlight behind the main flow. This immediately communicates which states are on the expected path vs error branches. The lane spans from the initial indicator to the terminal state, vertically centered on the main flow row.

### Normal State Node

```svg
<g class="state-node normal" data-id="{stateId}" data-tooltip="{stateDescription}"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="54" rx="12"
        fill="#1a1a2e" stroke="{stateColor}" stroke-width="2"/>
  <!-- State name -->
  <text x="{cx}" y="{cy - 6}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{stateName}</text>
  <!-- Detail line -->
  <text x="{cx}" y="{cy + 12}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{stateDetail}</text>
</g>
```

### Active/Current State Node

```svg
<g class="state-node active" data-id="{stateId}" data-tooltip="{stateDescription}"
   style="animation-delay: {delay}s;">
  <!-- Pulse ring -->
  <rect x="{x - 4}" y="{y - 4}" width="{width + 8}" height="62" rx="14"
        fill="none" stroke="#facc15" stroke-width="1" stroke-opacity="0.2">
    <animate attributeName="stroke-opacity" values="0.2;0.05;0.2" dur="2s" repeatCount="indefinite"/>
  </rect>
  <rect x="{x}" y="{y}" width="{width}" height="54" rx="12"
        fill="#1a1a2e" stroke="#facc15" stroke-width="3"
        filter="url(#glow-active)"/>
  <!-- Active indicator badge -->
  <rect x="{cx - 16}" y="{y - 8}" width="32" height="14" rx="4" fill="#facc15"/>
  <text x="{cx}" y="{y - 1}" text-anchor="middle" dominant-baseline="central"
        fill="#0f0f1a" font-size="9" font-weight="bold">현재</text>
  <text x="{cx}" y="{cy - 2}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="13" font-weight="bold">{stateName}</text>
  <text x="{cx}" y="{cy + 14}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{stateDetail}</text>
</g>
```

### Terminal/End State Node (Double-Circle Final)

```svg
<g class="state-node terminal" data-id="{stateId}" data-tooltip="{stateDescription}"
   style="animation-delay: {delay}s;">
  <g filter="url(#glow-final)">
    <circle cx="{cx}" cy="{cy}" r="36" fill="#1a1a2e" stroke="#4ade80" stroke-width="3"/>
    <circle cx="{cx}" cy="{cy}" r="28" fill="none" stroke="#4ade80" stroke-width="1.5" opacity="0.5"/>
  </g>
  <text x="{cx}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#4ade80" font-size="13" font-weight="bold">{stateName}</text>
</g>
```

### Terminal Error State Node (Double-Circle Error)

```svg
<g class="state-node terminal-error" data-id="{stateId}" data-tooltip="{stateDescription}"
   style="animation-delay: {delay}s;">
  <g filter="url(#glow-error)">
    <circle cx="{cx}" cy="{cy}" r="32" fill="#1a1a2e" stroke="#f87171" stroke-width="2.5"/>
    <circle cx="{cx}" cy="{cy}" r="24" fill="none" stroke="#f87171" stroke-width="1" opacity="0.4"/>
  </g>
  <text x="{cx}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#f87171" font-size="13" font-weight="bold">{stateName}</text>
</g>
```

Final states (both success and terminal error) use double-circle pattern -- outer circle with full stroke, inner circle at 50% opacity. Combined with glow filter, this reads clearly at any zoom level.

### Error State Node

```svg
<g class="state-node error" data-id="{stateId}" data-tooltip="{stateDescription}"
   style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="54" rx="12"
        fill="#1a1a2e" stroke="#ef4444" stroke-width="2"/>
  <!-- Error indicator stripe -->
  <rect x="{x}" y="{y}" width="{width}" height="4" rx="2" fill="#f87171" fill-opacity="0.4"/>
  <!-- Error icon -->
  <text x="{x + 14}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#ef4444" font-size="14">&#9888;</text>
  <text x="{cx + 8}" y="{cy}" text-anchor="middle" dominant-baseline="central"
        fill="#ef4444" font-size="13" font-weight="bold">{stateName}</text>
</g>
```

### Composite State (group of sub-states)

```svg
<g class="composite-state">
  <rect x="{groupX}" y="{groupY}" width="{groupWidth}" height="{groupHeight}" rx="16"
        fill="{domainColor}" fill-opacity="0.04"
        stroke="{domainColor}" stroke-width="1" stroke-opacity="0.2" stroke-dasharray="8,4"/>
  <text x="{groupX + 12}" y="{groupY + 18}" fill="{domainColor}" fill-opacity="0.6"
        font-size="11" font-weight="bold">{groupName}</text>
</g>
```

### Transition Arrow: Primary Path

```svg
<g class="sm-transition primary" data-from="{fromId}" data-to="{toId}"
   style="animation-delay: {delay}s;">
  <path d="M {startX},{startY} Q {controlX},{controlY} {endX},{endY}"
        stroke="#facc15" stroke-width="2" fill="none"
        marker-end="url(#arrow-primary)"/>
  <!-- Label with background pill -->
  <rect x="{labelX - labelW/2 - 5}" y="{labelY - 8}" width="{labelW + 10}" height="16"
        rx="4" fill="#0f0f1a" fill-opacity="0.85"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="10">{triggerEvent}</text>
  {guard_condition}
</g>
```

### Transition Arrow: Secondary/Edge Path

```svg
<g class="sm-transition secondary" data-from="{fromId}" data-to="{toId}"
   style="animation-delay: {delay}s;">
  <path d="M {startX},{startY} Q {controlX},{controlY} {endX},{endY}"
        stroke="#888888" stroke-width="1.5" stroke-dasharray="6,3" fill="none"
        marker-end="url(#arrow-secondary)"/>
  <rect x="{labelX - labelW/2 - 5}" y="{labelY - 8}" width="{labelW + 10}" height="16"
        rx="4" fill="#0f0f1a" fill-opacity="0.85"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{triggerEvent}</text>
  {guard_condition}
</g>
```

### Transition Arrow: Error Path

```svg
<g class="sm-transition error-path" data-from="{fromId}" data-to="{toId}"
   style="animation-delay: {delay}s;">
  <path d="M {startX},{startY} Q {controlX},{controlY} {endX},{endY}"
        stroke="#ef4444" stroke-width="1.5" stroke-dasharray="6,3" fill="none"
        marker-end="url(#arrow-error)"/>
  <rect x="{labelX - labelW/2 - 5}" y="{labelY - 8}" width="{labelW + 10}" height="16"
        rx="4" fill="#0f0f1a" fill-opacity="0.85"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="#ef4444" font-size="10">{triggerEvent}</text>
  {guard_condition}
</g>
```

### Self-Transition (Loop Arrow)

```svg
<g class="sm-transition self-loop" data-from="{stateId}" data-to="{stateId}"
   style="animation-delay: {delay}s;">
  <!-- Loop positioned based on available space: top, right, or left of state -->
  <path d="M {loopStartX},{loopStartY} C {cp1X},{cp1Y} {cp2X},{cp2Y} {loopEndX},{loopEndY}"
        stroke="{transitionColor}" stroke-width="1.5" fill="none"
        marker-end="url(#arrow-primary)"/>
  <rect x="{labelX - labelW/2 - 4}" y="{labelY - 8}" width="{labelW + 8}" height="16"
        rx="4" fill="#0f0f1a" fill-opacity="0.85"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="#888888" font-size="10">{triggerEvent}</text>
</g>
```

### Guard Condition (appended to transition label)

```svg
<text x="{labelX}" y="{labelY + 14}" text-anchor="middle" dominant-baseline="central"
      fill="#666666" font-size="9" font-style="italic">[{guardCondition}]</text>
<!-- e.g., [금액 > 0], [재고 있음] -->
```

### Legend Panel

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="180" height="{legendHeight}" rx="8"
        fill="#0f0f1a" fill-opacity="0.9" stroke="#2a2a4a" stroke-width="1"/>
  <text x="12" y="18" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- State types -->
  <circle cx="20" cy="34" r="5" fill="#e2e8f0"/>
  <text x="32" y="37" fill="#888888" font-size="10">초기 상태</text>

  <rect x="12" y="46" width="16" height="10" rx="4" fill="#1a1a2e" stroke="#e2e8f0" stroke-width="1"/>
  <text x="34" y="54" fill="#888888" font-size="10">일반 상태</text>

  <rect x="12" y="62" width="16" height="10" rx="4" fill="#1a1a2e" stroke="#facc15" stroke-width="1.5"/>
  <text x="34" y="70" fill="#888888" font-size="10">현재 상태</text>

  <rect x="12" y="78" width="16" height="10" rx="4" fill="#1a1a2e" stroke="#4ade80" stroke-width="1"/>
  <rect x="13" y="79" width="14" height="8" rx="3" fill="none" stroke="#4ade80" stroke-width="0.5"/>
  <text x="34" y="86" fill="#888888" font-size="10">종료 상태</text>

  <rect x="12" y="94" width="16" height="10" rx="4" fill="#1a1a2e" stroke="#ef4444" stroke-width="1"/>
  <text x="34" y="102" fill="#888888" font-size="10">에러 상태</text>

  <!-- Transition types -->
  <line x1="12" y1="118" x2="28" y2="118" stroke="#facc15" stroke-width="2"/>
  <text x="34" y="121" fill="#888888" font-size="10">주요 전이</text>

  <line x1="12" y1="134" x2="28" y2="134" stroke="#888888" stroke-width="1.5" stroke-dasharray="4,3"/>
  <text x="34" y="137" fill="#888888" font-size="10">부차 전이</text>

  <line x1="12" y1="150" x2="28" y2="150" stroke="#ef4444" stroke-width="1.5" stroke-dasharray="4,3"/>
  <text x="34" y="153" fill="#888888" font-size="10">에러 전이</text>
</g>
```

### Current State Info Box

```svg
<rect x="{boxX}" y="{boxY}" width="180" height="100" rx="10"
      fill="#1a1a2e" stroke="#facc1520" stroke-width="1"/>
<text x="{boxCenterX}" y="{boxY + 22}" text-anchor="middle" fill="#facc15" font-size="10" font-weight="bold">현재 상태: {stateName}</text>
<line x1="{boxX + 20}" y1="{boxY + 32}" x2="{boxX + 160}" y2="{boxY + 32}" stroke="#2a2a4a" stroke-width="1"/>
<text x="{boxCenterX}" y="{boxY + 50}" text-anchor="middle" fill="#a0a0b0" font-size="10">가능한 전이:</text>
<!-- List available transitions -->
```

Include a current state info box showing the active state and available transitions. This answers "where are we and what can happen next?" Position near the active state or in a consistent corner of the diagram.

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.sm-tooltip');
const allTransitions = document.querySelectorAll('.sm-transition');
const allStates = document.querySelectorAll('.state-node');

allStates.forEach(state => {
  const stateId = state.getAttribute('data-id');

  state.addEventListener('mouseenter', e => {
    const desc = state.getAttribute('data-tooltip');

    // Find connected transitions
    let transText = '';
    allTransitions.forEach(t => {
      const from = t.getAttribute('data-from');
      const to = t.getAttribute('data-to');
      if (from === stateId) {
        const label = t.querySelector('text')?.textContent || '';
        transText += `<div class="tt-transition-item"><span style="color:#facc15;">&#8594;</span> ${to}: ${label}</div>`;
        t.classList.add('highlighted'); t.classList.remove('dimmed');
      } else if (to === stateId) {
        const label = t.querySelector('text')?.textContent || '';
        transText += `<div class="tt-transition-item"><span style="color:#94a3b8;">&#8592;</span> ${from}: ${label}</div>`;
        t.classList.add('highlighted'); t.classList.remove('dimmed');
      } else {
        t.classList.add('dimmed'); t.classList.remove('highlighted');
      }
    });

    tooltip.innerHTML = `<div style="font-weight:bold;margin-bottom:4px;">${desc}</div>
      ${transText ? `<div class="tt-transitions">${transText}</div>` : ''}`;
    tooltip.classList.add('visible');
  });

  state.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  state.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allTransitions.forEach(t => t.classList.remove('highlighted', 'dimmed'));
  });
});
```

## Rules

### Layout direction
- Position states following the natural lifecycle — typically left-to-right for linear flows, or in a circular/grid arrangement for cyclical flows
- Initial state indicator at the far left, terminal states at the far right

### State type rules
- **Initial** -> small filled circle (8px radius, white) with arrow to first state
- **Normal** -> rounded rectangle (54px height, `rx="12"`), dark fill, domain-color border
- **Active/current** -> yellow border 3px + glow filter + pulse animation + "현재" badge at top
- **Terminal/end** -> double border (inner at 40% opacity) + terminal glow filter, green color
- **Error** -> red border `#ef4444` + warning icon &#9888;

### State content rules
- State name: bold 13px, centered
- State detail: muted 10px, below name (describes what's true in this state)
- Active state: "현재" badge in yellow above the state

### Composite state rules
- If multiple states form a logical group (e.g., "결제 프로세스"), wrap them in a dashed rounded rectangle
- Composite fill at 4% domain color, dashed border at 20% opacity
- Group name at top-left inside the composite

### Transition arrow rules
- All transitions use curved paths (quadratic Bezier `Q`) with the control point offset at least 30px perpendicular to the direct line between states — this ensures the curve arc is visible and the label has room to sit above/below without overlapping state rects
- **Three-color system for transitions:**
  - Indigo `#6366f1` = forward progress (happy path)
  - Red `#f87171` = error transitions (dashed)
  - Blue `#38bdf8` = self-transitions / loops
- Success transition to final state uses green `#4ade80` at 2.5px
- **Primary path** -> solid yellow `#facc15`, 2px
- **Secondary/edge path** -> dashed gray `#888888`, 1.5px, `stroke-dasharray: 6,3`
- **Error path** -> dashed red `#ef4444`, 1.5px, `stroke-dasharray: 6,3`
- Labels sit on background pills (`#0f0f1a` at 85%) for readability
- Place a small background rect behind each transition label to prevent text from overlapping with other elements:
  ```svg
  <rect x="{labelX - 25}" y="{labelY - 12}" width="50" height="17" rx="4" fill="#0f0f1a"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" fill="#6366f180" font-size="9">{label}</text>
  ```
- When two states have transitions in both directions, offset the curves to opposite sides (one above, one below the direct line) to prevent overlap

### Self-transition rules
- Render as loop arrow **above, to the right, or to the left** of the state depending on available space
- Default to above; if space is occupied by another element, use the right side
- Loop control points should extend 40-50px from the state border

### Guard condition rules
- If a transition has conditions, show below the trigger label in italic, bracketed: `[금액 > 0]`
- Font: 9px, color `#666666`

### Legend rules
- Always include at bottom-right
- Show: state types (initial, normal, active, terminal, error), transition types (primary, secondary, error)

## Layout Algorithm

Force-directed-inspired positioning for state machines. All values in px.

```
// --- Configuration ---
stateWidth = 140         // default state node width
stateHeight = 54         // state node height
horizontalGap = 100      // minimum horizontal gap between states
verticalGap = 80         // minimum vertical gap between rows
initialIndicatorOffset = 60  // space before first state for initial indicator

// --- Step 1: Determine state ordering ---
// Topological sort based on transitions (BFS from initial state)
orderedStates = topologicalSort(states, transitions)

// --- Step 2: Assign rows and columns ---
// Linear flow: single row
// Branching flow: multiple rows

// Identify the main path (longest path from initial to terminal)
mainPath = longestPath(initialState, terminalStates)

// Main path goes in the center row
row = 0
col = 0
for state in mainPath:
    state.row = 0
    state.col = col
    col += 1

// Off-main-path states go above or below
for state in orderedStates:
    if state not in mainPath:
        // Find which main-path state leads to this one
        parentInMain = findClosestMainPathAncestor(state)
        state.col = parentInMain.col + 1
        // Alternate above and below
        state.row = nextAvailableRow(state.col)

// --- Step 3: Calculate positions ---
for state in allStates:
    state.width = max(stateWidth, nodeWidth(state.name, 13))
    state.x = initialIndicatorOffset + state.col * (stateWidth + horizontalGap)
    state.y = centerY + state.row * (stateHeight + verticalGap)
    state.cx = state.x + state.width / 2
    state.cy = state.y + stateHeight / 2

// Center everything vertically
minY = min(s.y for s in allStates)
maxY = max(s.y + stateHeight for s in allStates)
totalHeight = maxY - minY
offset = (viewBoxHeight - totalHeight) / 2 - minY
for state in allStates:
    state.y += offset

// --- Step 4: Route transition arrows ---
for transition in transitions:
    fromState = getState(transition.from)
    toState = getState(transition.to)

    if transition.from == transition.to:
        // Self-loop
        routeSelfLoop(fromState, transition)
        continue

    // Determine connection points
    if fromState.col < toState.col:
        // Forward: right edge -> left edge
        startX = fromState.x + fromState.width
        startY = fromState.cy
        endX = toState.x
        endY = toState.cy
    elif fromState.col > toState.col:
        // Backward: left edge -> right edge (loop back)
        startX = fromState.x
        startY = fromState.cy
        endX = toState.x + toState.width
        endY = toState.cy
    else:
        // Same column: top/bottom
        if fromState.row < toState.row:
            startX = fromState.cx; startY = fromState.y + stateHeight
            endX = toState.cx; endY = toState.y
        else:
            startX = fromState.cx; startY = fromState.y
            endX = toState.cx; endY = toState.y + stateHeight

    // Check for bidirectional transitions (A->B and B->A)
    hasBidirectional = existsTransition(toState, fromState)
    if hasBidirectional:
        // Offset curves in opposite directions
        perpOffset = 25  // perpendicular offset for bidirectional
    else:
        perpOffset = 0

    // Control point for Bezier curve
    midX = (startX + endX) / 2
    midY = (startY + endY) / 2
    // Perpendicular to line direction
    dx = endX - startX; dy = endY - startY
    len = sqrt(dx*dx + dy*dy)
    // Base offset of 35px ensures curves are visibly arced (not nearly flat)
    controlX = midX + (-dy / len) * (35 + perpOffset)
    controlY = midY + (dx / len) * (35 + perpOffset)

    // Label position at midpoint of curve
    transition.labelX = (startX + 2*controlX + endX) / 4
    transition.labelY = (startY + 2*controlY + endY) / 4

// --- Step 5: Route self-loops ---
function routeSelfLoop(state, transition):
    // Check available space
    spaceAbove = no other state at (state.col, state.row - 1)
    if spaceAbove:
        // Loop above
        loopStartX = state.cx - 15; loopStartY = state.y
        loopEndX = state.cx + 15; loopEndY = state.y
        cp1X = state.cx - 35; cp1Y = state.y - 50
        cp2X = state.cx + 35; cp2Y = state.y - 50
        labelX = state.cx; labelY = state.y - 48
    else:
        // Loop to the right
        loopStartX = state.x + state.width; loopStartY = state.cy - 12
        loopEndX = state.x + state.width; loopEndY = state.cy + 12
        cp1X = state.x + state.width + 50; cp1Y = state.cy - 30
        cp2X = state.x + state.width + 50; cp2Y = state.cy + 30
        labelX = state.x + state.width + 48; labelY = state.cy

// --- Step 6: Position composite states ---
for group in compositeGroups:
    memberStates = group.states
    groupX = min(s.x for s in memberStates) - 20
    groupY = min(s.y for s in memberStates) - 30
    groupWidth = max(s.x + s.width for s in memberStates) - groupX + 20
    groupHeight = max(s.y + stateHeight for s in memberStates) - groupY + 20

// --- Step 7: Calculate viewBox and legend position ---
allBounds = state rects + transition extents + self-loop extents + composite rects
viewBoxWidth = max(allBounds.right) + 60 + 200  // +200 for legend
viewBoxHeight = max(allBounds.bottom) + 60
minX = min(allBounds.left) - 60
minY = min(allBounds.top) - 60

// Legend position: bottom-right, outside content area
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
// legendHeight depends on content (base ~100 + 18 per legend entry)
```

### CJK Node Width

```
function nodeWidth(label, fontSize = 13):
    wideChars = count Korean/CJK characters
    latinChars = len(label) - wideChars
    textWidth = (wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return max(120, textWidth + 40)  // minimum 120px for state nodes
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- Bidirectional transitions (A->B and B->A) need perpendicular offset to prevent overlapping arrows. The 20px offset works for most cases; increase to 30px if there are also labels.
- Self-loops positioned above the state are preferred — right-side loops can interfere with outgoing transitions if the next state is directly to the right.
- The "현재" badge on the active state gives immediate orientation — users' eyes are drawn to it first, then they trace outgoing transitions to understand available actions.
- For state machines with 8+ states, the topological layout can produce a wide SVG. Consider wrapping to 2-3 rows using the row assignment in Step 2.
- Transition label background pills are critical for readability — without them, labels on curved arrows blend into the background or overlap with other elements.
- The double-circle pattern for final states is standard UML convention. Use it consistently for both success (green `#4ade80`) and terminal error (red `#f87171`) states.
- The happy path lane provides context without competing with node styling. Keep fill opacity extremely low (`#6366f103`) so it reads as a subtle environmental cue.
- Self-transition loops should use blue `#38bdf8` to create the three-color system (indigo for forward, red for error, blue for loops).
- Transition label backgrounds prevent visual collision between arrow labels and other elements. Always include a background rect behind label text.
- The current state info box is high-value for complex state machines — it immediately answers "where are we?" and "what can happen next?" without requiring the user to trace arrows.
- **Happy path lane must be visible**: Use `linearGradient` fill from 6% to 1% opacity (not flat 3%). Add a subtle `stroke="#6366f110"` border and a styled pill badge for the "HAPPY PATH" label (`fill="#6366f10c" stroke="#6366f120" rx="9"`). The text should use `font-weight: 600`, `letter-spacing: 2`, at 70% opacity. Previous flat fill at 3% was invisible.
- **Transition label pill styling**: All transition labels must use pill backgrounds with `rx="9"`, `fill="#0f0f1a"`, and a colored stroke matching the transition color at 30% opacity. Font-size must be at least 10px (not 9). Without pills, labels on curved arrows are unreadable.
- **Guard condition badges**: Guard conditions (e.g., `[금액 > 0]`, `[시도 < 3]`) should use styled badge pills with `fill="{color}10" stroke="{color}25"` and `rx="8"`. Font-size at least 8px with `font-weight: 600`. The old approach of tiny text at 7px was unreadable.
- **Arrow stroke widths**: Main path transitions should use `stroke-width: 2.5` (not 2). Error transitions use 2 for primary errors, 1.5 for secondary. Success transitions use 2.5. Self-loops use 2. These widths ensure arrows are clearly visible against the dark background.
- **Initial state node**: Use `r=14` outer circle with 15% fill and `stroke-width: 2`, plus `r=5` inner filled circle. This is more prominent than the old `r=12` and makes the entry point immediately visible.
- **Error state accent bar**: Add a 5px colored bar across the top of error state nodes (`fill="#f87171" opacity="0.4"`) to visually distinguish them from normal states even without reading the label.
- **Current state info box**: Add a 4px accent bar across the top (`fill="#facc15" opacity="0.3"`) and use `#c0c0d0` for secondary text (not `#a0a0b0`). The box border should be `stroke="#facc1525"` with `stroke-width: 1.5`.
- **Transition label collision avoidance**: After computing the label position at the curve midpoint (using the 1/4-point formula), verify the label rect does not overlap with any state rect or composite state boundary. If it does, nudge the label 15-20px perpendicular to the curve direction toward the nearest empty space. For self-loop labels, place them consistently above the state node to avoid collisions with incoming/outgoing transition labels.
- **Forward transition curve visibility**: When connecting adjacent states horizontally, the quadratic Bezier control point must be offset at least 30px above the direct line (e.g., `Q midX, startY - 30`). A perpendicular offset of only 15-20px produces curves that are nearly flat and invisible at normal zoom. The arrow + label should form a visible arc above the states, not a subtle bump. For long horizontal runs (5+ states in a row), consistent 30px offset creates a clean visual rhythm.
- **Uniform horizontal spacing**: When laying out the main path, calculate `stateWidth` per node using the CJK width formula, then use a consistent gap between every pair of adjacent states. Avoid hardcoding positions that lead to uneven spacing — states toward the right end of a long row tend to get squeezed. The gap between any two adjacent states on the main path should be at least `horizontalGap` (100px).
- **Secondary transition stroke**: Secondary/edge transitions (gray dashed `#888888`) can be hard to trace against the dark background. Use `stroke-width: 2` instead of 1.5, and consider `stroke-opacity: 0.8` with `stroke-dasharray: 8,4` (longer dashes) for better visibility on long diagonal paths.
