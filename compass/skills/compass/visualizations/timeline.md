# Timeline Rendering Guide

**When to use:** Scheduling, milestones, phased planning. The conversation involves
"when?", "roadmap", phases, or sequencing over time.

**Data source:** Elements with temporal ordering from `precedes` relations in the state file.
Decided items provide anchor dates; undecided items show as tentative.

**Structure:** Horizontal time axis with phase backgrounds, milestone nodes, and dependency arrows.

## Templates

### SVG Container & Defs

```html
<div style="overflow-x: auto;">
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}"
       style="max-width: 960px; width: 100%; background: #0f0f1a;
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">

    <defs>
      <!-- Arrow markers -->
      <marker id="arrow-critical" viewBox="0 0 10 6" refX="10" refY="3"
              markerWidth="8" markerHeight="6" orient="auto">
        <path d="M0,0 L10,3 L0,6" fill="#facc15"/>
      </marker>
      <marker id="arrow-optional" viewBox="0 0 10 6" refX="10" refY="3"
              markerWidth="8" markerHeight="6" orient="auto">
        <path d="M0,0 L10,3 L0,6" fill="#6b7280"/>
      </marker>

      <!-- Milestone glow -->
      <filter id="glow-milestone" x="-50%" y="-50%" width="200%" height="200%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur"/>
        <feFlood flood-color="#4ade80" flood-opacity="0.3" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-active-milestone" x="-50%" y="-50%" width="200%" height="200%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="5" result="blur"/>
        <feFlood flood-color="#facc15" flood-opacity="0.35" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>

      <style>
        .milestone-group { cursor: pointer; }
        .milestone-group:hover .ms-dot { transform: scale(1.12); }
        .milestone-group:hover .ms-name { fill: #ffffff !important; }
        .ms-dot { transition: transform 0.2s ease; transform-origin: center; }

        /* Dependency arrow highlight */
        .dep-arrow { transition: stroke-opacity 0.3s; }
        .dep-arrow.dimmed { stroke-opacity: 0.05; }
        .dep-arrow.highlighted { stroke-opacity: 0.9; }

        /* Fade-in animation — opacity ONLY, no transform.
           CSS transforms on SVG elements REPLACE the SVG transform attribute,
           which would reposition milestones to origin and break the layout. */
        .milestone-anim {
          opacity: 0; animation: milestoneFadeIn 0.5s ease-out forwards;
        }
        @keyframes milestoneFadeIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Active pulse */
        @keyframes activePulse {
          0%, 100% { r: 14; opacity: 1; }
          50%      { r: 16; opacity: 0.7; }
        }

        /* Progress marker */
        .progress-marker line {
          stroke-dasharray: 4,3;
          animation: progressDash 1s linear infinite;
        }
        @keyframes progressDash {
          to { stroke-dashoffset: -7; }
        }

        /* Tooltip */
        .tl-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2e; border: 1px solid #4a4a7a; border-radius: 8px;
          padding: 10px 14px; font-size: 12px; color: #e2e8f0;
          max-width: 280px; opacity: 0; transition: opacity 0.15s;
          box-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }
        .tl-tooltip.visible { opacity: 1; }
      </style>
    </defs>

    <!-- Phase backgrounds -->
    {phase_segments}

    <!-- Timeline spine -->
    {spine}

    <!-- Progress marker (current position) -->
    {progress_marker}

    <!-- Dependency arrows (render before milestones) -->
    {dependency_arrows}

    <!-- Milestones -->
    {milestone_nodes}

    <!-- Legend -->
    {legend}
  </svg>
</div>

<div class="tl-tooltip"></div>
```

### Timeline Spine

```svg
<g class="spine">
  <!-- Main horizontal line -->
  <line x1="{spineStartX}" y1="{spineY}" x2="{spineEndX}" y2="{spineY}"
        stroke="#2a2a4a" stroke-width="2" stroke-linecap="round"/>
  <!-- Progress overlay: filled portion from start to current position -->
  <line x1="{spineStartX}" y1="{spineY}" x2="{nowX}" y2="{spineY}"
        stroke="#4ade80" stroke-width="3" stroke-linecap="round" opacity="0.6"/>
  <!-- Start cap -->
  <circle cx="{spineStartX}" cy="{spineY}" r="4" fill="#2a2a4a"/>
  <!-- End arrow -->
  <polygon points="{spineEndX},{spineY-5} {spineEndX+10},{spineY} {spineEndX},{spineY+5}"
           fill="#2a2a4a"/>
</g>
```

### Phase Segment: Completed

```svg
<g class="phase-segment">
  <rect x="{phaseX}" y="0" width="{phaseWidth}" height="{svgHeight}"
        fill="#4ade8006" stroke="#4ade8015"/>
  <!-- Phase header -->
  <text x="{phaseCX}" y="22" text-anchor="middle"
        fill="#4ade80" font-size="13" font-weight="bold">{phaseName}</text>
  <text x="{phaseCX}" y="38" text-anchor="middle"
        fill="#888888" font-size="10">{phaseDuration}</text>
  <!-- Phase separator -->
  <line x1="{phaseEndX}" y1="0" x2="{phaseEndX}" y2="{svgHeight}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="4,4"/>
</g>
```

### Phase Segment: Active

```svg
<g class="phase-segment">
  <rect x="{phaseX}" y="0" width="{phaseWidth}" height="{svgHeight}"
        fill="#facc1506" stroke="#facc1515"/>
  <text x="{phaseCX}" y="22" text-anchor="middle"
        fill="#facc15" font-size="13" font-weight="bold">{phaseName}</text>
  <text x="{phaseCX}" y="38" text-anchor="middle"
        fill="#888888" font-size="10">{phaseDuration}</text>
  <line x1="{phaseEndX}" y1="0" x2="{phaseEndX}" y2="{svgHeight}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="4,4"/>
</g>
```

### Phase Segment: Future (odd)

```svg
<g class="phase-segment">
  <rect x="{phaseX}" y="0" width="{phaseWidth}" height="{svgHeight}"
        fill="#6366f106"/>
  <text x="{phaseCX}" y="22" text-anchor="middle"
        fill="#e2e8f0" font-size="13" font-weight="bold">{phaseName}</text>
  <text x="{phaseCX}" y="38" text-anchor="middle"
        fill="#888888" font-size="10">{phaseDuration}</text>
  <line x1="{phaseEndX}" y1="0" x2="{phaseEndX}" y2="{svgHeight}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="4,4"/>
</g>
```

### Phase Segment: Future (even)

```svg
<g class="phase-segment">
  <rect x="{phaseX}" y="0" width="{phaseWidth}" height="{svgHeight}"
        fill="#8b5cf606"/>
  <text x="{phaseCX}" y="22" text-anchor="middle"
        fill="#e2e8f0" font-size="13" font-weight="bold">{phaseName}</text>
  <text x="{phaseCX}" y="38" text-anchor="middle"
        fill="#888888" font-size="10">{phaseDuration}</text>
  <line x1="{phaseEndX}" y1="0" x2="{phaseEndX}" y2="{svgHeight}"
        stroke="#2a2a4a" stroke-width="1" stroke-dasharray="4,4"/>
</g>
```

### Milestone: Decided

Labels alternate above/below the spine for readability.

**Important:** Use a wrapper `<g>` for SVG positioning and an inner `<g>` for CSS animation.
CSS transforms on SVG elements replace (not compose with) the SVG `transform` attribute.
If you put the CSS animation class on the same element as `transform="translate()"`, the
milestone will render at origin instead of its intended position.

```svg
<!-- Outer g: SVG positioning only, no CSS classes -->
<g transform="translate({cx}, {spineY})">
  <!-- Inner g: CSS animation (opacity only) + interactivity -->
  <g class="milestone-group milestone-anim" data-id="{nodeId}" data-tooltip="{description}"
     style="animation-delay: {delay}s;">
    <!-- Connecting stem -->
    <line x1="0" y1="{stemStart}" x2="0" y2="{stemEnd}" stroke="#4ade80" stroke-width="2" stroke-opacity="0.6"/>
    <!-- Main dot -->
    <g class="ms-dot"><circle r="14" fill="#4ade80" filter="url(#glow-milestone)"/></g>
    <!-- Inner checkmark icon -->
    <text x="0" y="2" text-anchor="middle" dominant-baseline="central"
          fill="#0f0f1a" font-size="12" font-weight="bold">&#10003;</text>
    <!-- Label (above or below spine, determined by labelSide) -->
    <text class="ms-name" x="0" y="{labelY}" text-anchor="middle"
          fill="#e2e8f0" font-size="13" font-weight="600">{milestoneName}</text>
    <text x="0" y="{descY}" text-anchor="middle"
          fill="#94a3b8" font-size="10">{briefDescription}</text>
  </g>
</g>
```

### Milestone: Undecided / Tentative

```svg
<g transform="translate({cx}, {spineY})">
  <g class="milestone-group milestone-anim" data-id="{nodeId}" data-tooltip="{description}"
     style="animation-delay: {delay}s;">
    <line x1="0" y1="{stemStart}" x2="0" y2="{stemEnd}" stroke="#6b7280" stroke-width="1.5" stroke-opacity="0.5"
          stroke-dasharray="3,3"/>
    <g class="ms-dot"><circle r="14" fill="none" stroke="#94a3b8" stroke-width="2.5" stroke-dasharray="4,3"/></g>
    <text x="0" y="2" text-anchor="middle" dominant-baseline="central"
          fill="#94a3b8" font-size="12">?</text>
    <text class="ms-name" x="0" y="{labelY}" text-anchor="middle"
          fill="#c8d0da" font-size="13">{milestoneName}</text>
    <text x="0" y="{descY}" text-anchor="middle"
          fill="#94a3b8" font-size="10">{briefDescription}</text>
  </g>
</g>
```

### Milestone: Active / Current

```svg
<g transform="translate({cx}, {spineY})">
  <g class="milestone-group milestone-anim" data-id="{nodeId}" data-tooltip="{description}"
     style="animation-delay: {delay}s;">
    <line x1="0" y1="{stemStart}" x2="0" y2="{stemEnd}" stroke="#facc15" stroke-width="2" stroke-opacity="0.7"/>
    <!-- Pulse ring -->
    <circle r="26" fill="none" stroke="#facc15" stroke-width="1.5" stroke-opacity="0.2">
      <animate attributeName="r" values="24;30;24" dur="2s" repeatCount="indefinite"/>
      <animate attributeName="stroke-opacity" values="0.2;0.06;0.2" dur="2s" repeatCount="indefinite"/>
    </circle>
    <!-- Main dot -->
    <g class="ms-dot">
      <circle r="18" fill="#facc15" filter="url(#glow-active-milestone)">
        <animate attributeName="opacity" values="1;0.75;1" dur="2s" repeatCount="indefinite"/>
      </circle>
    </g>
    <text x="0" y="2" text-anchor="middle" dominant-baseline="central"
          fill="#0f0f1a" font-size="13" font-weight="bold">&#9654;</text>
    <text class="ms-name" x="0" y="{labelY}" text-anchor="middle"
          fill="#facc15" font-size="14" font-weight="bold">{milestoneName}</text>
    <text x="0" y="{descY}" text-anchor="middle"
          fill="#94a3b8" font-size="10">{briefDescription}</text>
  </g>
</g>
```

### NOW Marker

```svg
<line x1="{nowX}" y1="130" x2="{nowX}" y2="{totalHeight - 80}" stroke="#facc15" stroke-width="1" stroke-dasharray="3,5" opacity="0.4"/>
<rect x="{nowX - 20}" y="128" width="40" height="18" rx="9" fill="#facc15"/>
<text x="{nowX}" y="139" text-anchor="middle" dominant-baseline="central" fill="#0f0f1a" font-size="9" font-weight="bold">NOW</text>
```

### Milestone Detail Card

```svg
<rect x="{cardX}" y="{cardY}" width="170" height="80" rx="8"
      fill="#1a1a2e" stroke="#facc1530" stroke-width="1"/>
<text x="{cardCenterX}" y="{cardY + 20}" text-anchor="middle" fill="#facc15" font-size="10" font-weight="bold">{milestoneTitle}</text>
```

### Progress Marker (Current Position)

A vertical dashed line showing "now" on the timeline:

```svg
<g class="progress-marker">
  <line x1="{nowX}" y1="50" x2="{nowX}" y2="{svgHeight - 20}"
        stroke="#facc15" stroke-width="1.5" stroke-dasharray="4,3" stroke-opacity="0.6"/>
  <text x="{nowX}" y="{svgHeight - 8}" text-anchor="middle"
        fill="#facc15" font-size="10" font-weight="bold">현재</text>
</g>
```

### Dependency Arrow: Critical Path

```svg
<path class="dep-arrow" data-from="{fromId}" data-to="{toId}"
      d="M {x1} {arcStartY} C {cx1} {cy1}, {cx2} {cy2}, {x2} {arcEndY}"
      fill="none" stroke="#facc15" stroke-width="2.5"
      marker-end="url(#arrow-critical)"
      style="animation-delay: {delay}s;"/>
```

### Dependency Arrow: Optional

```svg
<path class="dep-arrow" data-from="{fromId}" data-to="{toId}"
      d="M {x1} {arcStartY} C {cx1} {cy1}, {cx2} {cy2}, {x2} {arcEndY}"
      fill="none" stroke="#6b7280" stroke-width="1" stroke-dasharray="2,4"
      marker-end="url(#arrow-optional)"
      style="animation-delay: {delay}s;"/>
```

### Legend Panel

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="160" height="120" rx="8"
        fill="#0f0f1a" fill-opacity="0.9" stroke="#2a2a4a" stroke-width="1"/>
  <text x="12" y="18" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- Milestone types -->
  <circle cx="20" cy="34" r="5" fill="#4ade80"/>
  <text x="30" y="37" fill="#888888" font-size="10">완료/결정됨</text>

  <circle cx="20" cy="52" r="5" fill="#facc15"/>
  <text x="30" y="55" fill="#888888" font-size="10">현재 진행</text>

  <circle cx="20" cy="70" r="5" fill="none" stroke="#6b7280" stroke-width="1.5" stroke-dasharray="3,2"/>
  <text x="30" y="73" fill="#888888" font-size="10">미결정</text>

  <!-- Dependency types -->
  <line x1="12" y1="90" x2="40" y2="90" stroke="#facc15" stroke-width="2"/>
  <text x="46" y="93" fill="#888888" font-size="10">핵심 경로</text>

  <line x1="12" y1="106" x2="40" y2="106" stroke="#6b7280" stroke-width="1" stroke-dasharray="2,4"/>
  <text x="46" y="109" fill="#888888" font-size="10">선택적</text>
</g>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.tl-tooltip');
const allArrows = document.querySelectorAll('.dep-arrow');
const allMilestones = document.querySelectorAll('.milestone-group');

allMilestones.forEach(ms => {
  const msId = ms.getAttribute('data-id');

  ms.addEventListener('mouseenter', e => {
    const desc = ms.getAttribute('data-tooltip');
    tooltip.innerHTML = desc;
    tooltip.classList.add('visible');

    // Highlight connected arrows
    allArrows.forEach(arrow => {
      if (arrow.getAttribute('data-from') === msId || arrow.getAttribute('data-to') === msId) {
        arrow.classList.add('highlighted');
      } else {
        arrow.classList.add('dimmed');
      }
    });
  });

  ms.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });

  ms.addEventListener('mouseleave', () => {
    tooltip.classList.remove('visible');
    allArrows.forEach(a => a.classList.remove('highlighted', 'dimmed'));
  });
});
```

## Rules

### Milestone styling rules
- If decided -> solid green `#4ade80` filled circle with checkmark, glow filter
- If undecided/tentative -> dashed circle outline `#94a3b8`, `?` indicator
- If active/current -> yellow `#facc15` filled circle with pulse animation ring, play icon
- Milestone dots: decided = 14px radius, active = 18px, undecided = 14px
- Undecided label text uses `#c8d0da` (brighter than default muted) for readability on dark backgrounds

### Label placement rules
- Alternate milestone labels **above and below** the spine to prevent overlap
- Even-indexed milestones (0, 2, 4, ...): labels above (negative Y offset)
- Odd-indexed milestones (1, 3, 5, ...): labels below (positive Y offset)
- Stem line connects the milestone dot to its label
- Stem starts at the dot edge (±15px from spine) and extends to ±68px
- Label name at ±78px, description at ±62px (above) or ±84px/±100px (below)

### Dependency arrow rules
- Critical path: thicker `2.5px`, yellow `#facc15`, arrowhead
- Optional: thin `1px`, gray `#6b7280`, dashed `2,4`, arrowhead
- Arrows use curved paths (cubic Bezier) routed **above** the spine for critical, **below** for optional
- This separation prevents arrow overlap

### NOW marker rules
- Always include a NOW marker at the current temporal position. It provides the single most important piece of context: where are we right now?
- Place the NOW marker at the X position of the active milestone (or interpolated between milestones based on date)
- The marker spans from just below the phase header to near the bottom of the SVG

### Phase rules
- Phase backgrounds are color-coded by status, not alternating gray:
  - Completed phases: green tint (`fill="#4ade8006" stroke="#4ade8015"`, header text `#4ade80`)
  - Active phase: yellow tint (`fill="#facc1506" stroke="#facc1515"`, header text `#facc15`)
  - Future phases: indigo/purple tint (`fill="#6366f106"` / `fill="#8b5cf606"`, alternating)
- Phase boundaries: dashed vertical separators `#2a2a4a`
- Each phase header: name in bold (13px) + duration below in muted color (10px) at top

### Milestone detail card rules
- For active milestones, include detail cards below the timeline showing sub-tasks, responsible team, and progress percentage
- Cards use dark background `#1a1a2e` with yellow border `#facc1530`, rounded corners `rx="8"`
- Card title in `#facc15` bold 10px, centered horizontally

### Progress marker rules
- If an active milestone exists, place a vertical "현재" (now) dashed line at its X position
- Line uses animated dash pattern for subtle movement
- Overlay a second line on the spine from start to the current position using `#4ade80` 3px at 60% opacity. This immediately communicates how far along the plan is.

### Timeline spine rules
- Horizontal line at vertical center, full width
- Start cap: small filled circle
- End cap: small arrow indicating continuation

### Responsive rules
- SVG uses `max-width: 960px` with `width: 100%`
- Wrap in `overflow-x: auto` container for horizontal scrolling on small screens

### Legend rules
- Always include legend at bottom-right
- Show milestone types and dependency types

## Layout Algorithm

Horizontal timeline with phase segments. All values in px.

```
// --- Configuration ---
phaseHeaderHeight = 55       // space for phase name + duration pill at top
milestoneLabelOffset = 68    // distance from spine center to stem end
minMilestoneGap = 80         // minimum horizontal gap between milestones
spineMarginY = 80            // vertical margin above and below spine

// --- Step 1: Calculate phase widths ---
totalMilestones = count of all milestones
phases = group milestones by phase

minPhaseWidth = 160
for phase in phases:
    // Width proportional to number of milestones in this phase
    phase.milestoneCount = len(phase.milestones)
    phase.width = max(minPhaseWidth, phase.milestoneCount * minMilestoneGap + 60)

totalWidth = sum(p.width for p in phases)

// --- Step 2: Calculate dimensions and position phases ---
svgWidth = totalWidth
svgHeight = phaseHeaderHeight + spineMarginY + milestoneLabelOffset + 60 + spineMarginY + milestoneLabelOffset + 60
// Explanation: header + margin + space for above-labels + margin + space for below-labels
spineY = phaseHeaderHeight + spineMarginY + milestoneLabelOffset + 60
// spineY is now a fixed value derived from known constants — no circular dependency

currentX = 0
for phase in phases:
    phase.x = currentX
    phase.cx = currentX + phase.width / 2
    currentX += phase.width

// --- Step 3: Position milestones ---
globalIndex = 0
for phase in phases:
    milestoneGap = phase.width / (phase.milestoneCount + 1)
    for i, milestone in enumerate(phase.milestones):
        milestone.cx = phase.x + milestoneGap * (i + 1)

        // Alternate labels above/below
        // stemStart/End: gap between dot edge and stem end
        if globalIndex % 2 == 0:
            milestone.labelSide = 'above'
            milestone.stemStart = -15   // start just above dot
            milestone.stemEnd = -milestoneLabelOffset  // -68
            milestone.labelY = -milestoneLabelOffset - 10  // -78 (name)
            milestone.descY = -milestoneLabelOffset + 6    // -62 (description)
        else:
            milestone.labelSide = 'below'
            milestone.stemStart = 15
            milestone.stemEnd = milestoneLabelOffset    // 68
            milestone.labelY = milestoneLabelOffset + 16   // 84 (name)
            milestone.descY = milestoneLabelOffset + 32    // 100 (description)

        globalIndex += 1

// --- Step 4: Route dependency arrows ---
for dep in dependencies:
    fromMs = getMilestone(dep.from)
    toMs = getMilestone(dep.to)

    if dep.type == 'critical':
        // Route above spine
        arcHeight = -40 - (10 * overlapIndex)  // stack arcs if multiple
        cp1 = (fromMs.cx + (toMs.cx - fromMs.cx) * 0.3, spineY + arcHeight)
        cp2 = (fromMs.cx + (toMs.cx - fromMs.cx) * 0.7, spineY + arcHeight)
    else:
        // Route below spine
        arcHeight = 40 + (10 * overlapIndex)
        cp1 = (fromMs.cx + (toMs.cx - fromMs.cx) * 0.3, spineY + arcHeight)
        cp2 = (fromMs.cx + (toMs.cx - fromMs.cx) * 0.7, spineY + arcHeight)

// --- Step 5: Position progress marker ---
activeMs = find milestone with status == 'active'
if activeMs:
    nowX = activeMs.cx

// --- Step 6: Position legend ---
legendX = svgWidth - 180
legendY = svgHeight - 140
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- With 10+ milestones, alternating above/below prevents label collision, but very long milestone names can still overlap horizontally. Truncate names to ~12 Korean chars and put full name in tooltip.
- When multiple critical-path arrows overlap, stack their arc heights (increment by 10px per arrow) to prevent visual confusion.
- The animated progress marker ("현재") gives a strong visual anchor for "where we are now" — always include it when an active milestone exists.
- Phase widths proportional to milestone count prevent empty space in phases with few milestones and crowding in phases with many.
- The NOW marker is the most valuable element — always include it even when exact dates aren't decided.
- Phase color differentiation works better than alternating gray backgrounds.
- Detail cards for active milestones reduce the need for users to ask about status.
- The progress overlay on the spine provides at-a-glance progress without counting milestones.
- **Phase background gradients**: Use `linearGradient` fills starting at 6% opacity and fading to 1% (not flat 6% fills which are invisible). The gradient creates depth and makes phases visually distinct without being heavy. Always use `stroke-width="1.5"` on phase boundaries (not 1).
- **Phase duration badges**: Wrap duration text (e.g., "4주 · 완료") in a pill with `rx="9"`, background at 12% phase color, and stroke at 30% phase color. Raw text below phase headers is too dim to read.
- **Detail card stem lines**: Connect detail cards to their milestone with a thin line (`stroke-width: 1`, phase color at 30% opacity) so users can trace which card belongs to which milestone. Without stems, cards float ambiguously.
- **Detail card accent bars**: Add a 4px colored bar across the top of detail cards (matching milestone color) to distinguish between different card types (active=yellow, critical=red, info=indigo).
- **Progress bars in detail cards**: When a milestone has a completion percentage, show an actual progress bar inside the detail card (background `#2a2a4a`, fill in phase color at 70% opacity). Textual percentages alone are less effective.
- **Milestone minimum radius**: Completed milestones r≥12, active milestones r≥16, major future milestones r≥14. Smaller radii (r=10) make future milestones nearly invisible.
- **Critical path arrow opacity**: Minimum opacity 0.5 for critical path, 0.35 for optional. Below these thresholds, dependency arrows become invisible on the dark background.
- **Milestone label collision resolution**: When alternating above/below still produces overlapping labels (common with 3+ milestones in a short time span), apply horizontal staggering: shift overlapping labels 20-30px left or right along the spine axis, and use angled connector lines (not vertical) to maintain the connection to the spine point. Never let two label boxes share the same vertical column if their vertical distance is less than the label height + 8px padding.
- **CRITICAL — CSS transforms vs SVG transforms**: CSS `transform` properties (including those in `@keyframes` animations) **replace** the SVG `transform` attribute on the same element — they do not compose. If a milestone `<g>` has both `transform="translate(x, y)"` (SVG positioning) and a CSS animation that uses `transform: translateY()`, the CSS transform will override the SVG translate, repositioning the milestone to origin (0,0) and making labels invisible. **Fix**: Use a wrapper `<g>` for SVG positioning and an inner `<g>` for CSS animation. The CSS animation must use `opacity` only, never `transform`. See the milestone templates above for the correct two-`<g>` pattern.
- **Undecided milestone visibility**: Use `stroke="#94a3b8"` (not `#6b7280`) for undecided milestone circles and `fill="#c8d0da"` for their label names. The darker gray values are nearly invisible against the dark background at typical SVG scaling.
