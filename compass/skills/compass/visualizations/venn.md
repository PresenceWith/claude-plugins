# Venn Diagram Rendering Guide

**When to use:** Showing overlap, shared properties, scope boundaries. The conversation involves
"difference between X and Y", "what's common?", or defining scope of two competing approaches.

**Data source:** Elements grouped into 2-3 sets, with shared elements placed in overlapping regions.

**Structure:** 2-3 overlapping circles with items placed in the appropriate regions.

## Templates

### SVG Container & Defs

```html
<div style="overflow-x: auto;">
  <svg width="100%" viewBox="0 0 {viewBoxWidth} {viewBoxHeight}"
       preserveAspectRatio="xMidYMid meet"
       style="background: #0f0f1a; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;">
    <defs>
      <!-- Radial gradients for circles -->
      <radialGradient id="grad-{set1Id}" cx="40%" cy="45%" r="55%">
        <stop offset="0%" stop-color="{set1Color}" stop-opacity="0.22"/>
        <stop offset="60%" stop-color="{set1Color}" stop-opacity="0.12"/>
        <stop offset="100%" stop-color="{set1Color}" stop-opacity="0.04"/>
      </radialGradient>
      <radialGradient id="grad-{set2Id}" cx="60%" cy="45%" r="55%">
        <stop offset="0%" stop-color="{set2Color}" stop-opacity="0.22"/>
        <stop offset="60%" stop-color="{set2Color}" stop-opacity="0.12"/>
        <stop offset="100%" stop-color="{set2Color}" stop-opacity="0.04"/>
      </radialGradient>
      <!-- Overlap highlight gradient -->
      <radialGradient id="grad-overlap" cx="50%" cy="50%" r="50%">
        <stop offset="0%" stop-color="{overlapColor}" stop-opacity="0.18"/>
        <stop offset="100%" stop-color="{overlapColor}" stop-opacity="0.06"/>
      </radialGradient>

      <!-- Glow filters per set -->
      <filter id="glow-{set1Id}" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="8" result="blur"/>
        <feFlood flood-color="{set1Color}" flood-opacity="0.15" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-{set2Id}" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="8" result="blur"/>
        <feFlood flood-color="{set2Color}" flood-opacity="0.15" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="glow-shared" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur in="SourceAlpha" stdDeviation="6" result="blur"/>
        <feFlood flood-color="{overlapColor}" flood-opacity="0.2" result="color"/>
        <feComposite in="color" in2="blur" operator="in" result="shadow"/>
        <feMerge><feMergeNode in="shadow"/><feMergeNode in="SourceGraphic"/></feMerge>
      </filter>
      <filter id="card-shadow">
        <feDropShadow dx="0" dy="2" stdDeviation="4" flood-color="#000" flood-opacity="0.3"/>
      </filter>

      <!-- Clip path for overlap zone highlight -->
      <clipPath id="clip-overlap">
        <circle cx="{circle1Cx}" cy="{circle1Cy}" r="{radius}"/>
      </clipPath>

      <style>
        .venn-circle-bg { transition: all 0.4s ease; }

        /* Set hover */
        .venn-set { cursor: pointer; transition: opacity 0.3s; }

        /* Item hover */
        .venn-item {
          cursor: pointer; transition: transform 0.2s ease, filter 0.2s;
          opacity: 0; animation: vennItemIn 0.4s ease-out forwards;
        }
        .venn-item:hover { transform: scale(1.06); filter: brightness(1.2) drop-shadow(0 3px 8px rgba(0,0,0,0.4)); }

        /* Circle entrance animation */
        @keyframes vennCircleIn {
          from { opacity: 0; r: 170; }
          to { opacity: 1; r: 195; }
        }
        .venn-circle-anim {
          opacity: 0; animation: vennCircleIn 0.6s ease-out forwards;
        }

        /* Item entrance animation */
        @keyframes vennItemIn {
          from { opacity: 0; }
          to   { opacity: 1; }
        }

        /* Scope annotation pulse — CSS keyframe, not SMIL */
        @keyframes scopePulse {
          0%, 100% { stroke-opacity: 0.6; stroke-dashoffset: 0; }
          50%      { stroke-opacity: 0.25; stroke-dashoffset: 12; }
        }

        /* Region count badge fade-in */
        @keyframes countFadeIn {
          from { opacity: 0; } to { opacity: 1; }
        }
        .region-count {
          font-size: 36px; font-weight: bold; fill-opacity: 0.18;
          pointer-events: none;
          animation: countFadeIn 0.8s ease-out 0.3s forwards; opacity: 0;
        }

        /* Tooltip — glassmorphism */
        .venn-tooltip {
          position: fixed; pointer-events: none; z-index: 100;
          background: #1a1a2eee; border: 1px solid #4a4a7a; border-radius: 10px;
          padding: 12px 16px; font-size: 12px; color: #e2e8f0;
          max-width: 280px; opacity: 0; transition: opacity 0.2s;
          box-shadow: 0 8px 32px rgba(0,0,0,0.5);
          backdrop-filter: blur(8px);
        }
        .venn-tooltip.visible { opacity: 1; }
        .venn-tooltip .tt-region {
          font-size: 10px; color: #888888; margin-top: 6px; display: block;
        }
        .venn-tooltip .tt-status {
          display: inline-block; padding: 2px 8px; border-radius: 4px;
          font-size: 9px; font-weight: bold; margin-top: 4px;
        }
      </style>
    </defs>

    <!-- Circle groups (sets) -->
    {circle_groups}

    <!-- Overlap zone highlight (clipped to circle1, filled on circle2) -->
    {overlap_highlight}

    <!-- Set labels -->
    {set_labels}

    <!-- Region count badges (large faded numbers) -->
    {region_counts}

    <!-- Region labels (A only, A ∩ B, etc.) -->
    {region_labels}

    <!-- Items -->
    {items}

    <!-- Scope annotation (optional) -->
    {scope_annotation}

    <!-- Summary stats (optional) -->
    {summary_stats}

    <!-- Legend -->
    {legend}
  </svg>
</div>

<div class="venn-tooltip"></div>
```

### Circle (Set) — with radial gradient fill and glow filter

```svg
<g class="venn-set" data-set="{setId}">
  <circle class="venn-circle-anim" cx="{cx}" cy="{cy}" r="{radius}"
          fill="url(#grad-{setId})"
          stroke="{setColor}" stroke-width="2" stroke-opacity="0.6"
          filter="url(#glow-{setId})" style="animation-delay: {delay}s;"/>
  <!-- Inner ring for depth -->
  <circle cx="{cx}" cy="{cy}" r="{radius - 10}" fill="none"
          stroke="{setColor}" stroke-width="0.5" stroke-opacity="0.15"/>
</g>
```

### Overlap Zone Highlight (clipPath-based)

Render the second circle's area clipped to the first circle, filled with the overlap gradient.
This makes the intersection zone visually distinct from either circle alone.

```svg
<circle cx="{circle2Cx}" cy="{circle2Cy}" r="{radius}"
        fill="url(#grad-overlap)" clip-path="url(#clip-overlap)"/>
```

### Set Label (positioned at outer edge, with bordered pill)

```svg
<g class="set-label">
  <!-- Bordered background pill with colored stroke -->
  <rect x="{labelX - labelW/2 - 8}" y="{labelY - 12}" width="{labelW + 16}" height="28"
        rx="8" fill="{setColor}" fill-opacity="0.12"
        stroke="{setColor}" stroke-opacity="0.3" stroke-width="1"/>
  <text x="{labelX}" y="{labelY}" text-anchor="middle" dominant-baseline="central"
        fill="{setColor}" font-size="15" font-weight="bold">{setName}</text>
  <!-- Item count -->
  <text x="{labelX}" y="{labelY + 20}" text-anchor="middle"
        fill="{setColor}" fill-opacity="0.5" font-size="11">{totalCount}개 기능</text>
</g>
```

### Region Count Badge (large faded number + region name)

```svg
<text class="region-count" x="{regionCenterX}" y="{regionCenterY}"
      text-anchor="middle" dominant-baseline="central"
      fill="{regionColor}">{itemCount}</text>
<!-- Region name label below the count -->
<text x="{regionCenterX}" y="{regionCenterY + 27}" text-anchor="middle"
      fill="{regionColor}" fill-opacity="0.35" font-size="11" font-weight="500">{regionLabel}</text>
```

### Item Card (in a region)

```svg
<g class="venn-item" data-tooltip="{itemDescription}" data-region="{regionName}"
   data-status="{statusKey}" style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="30" rx="7"
        fill="#1a1a2e" stroke="{regionColor}" stroke-width="1.5"
        filter="url(#card-shadow)"/>
  <!-- Status dot -->
  <circle cx="{x + width - 8}" cy="{y + 8}" r="4" fill="{statusColor}"/>
  <text x="{x + width/2}" y="{y + 16}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="11">{itemLabel}</text>
</g>
```

### Item Card: Shared/Intersection (brighter, with glow filter)

```svg
<g class="venn-item shared" data-tooltip="{itemDescription}" data-region="{regionName}"
   data-status="{statusKey}" style="animation-delay: {delay}s;">
  <rect x="{x}" y="{y}" width="{width}" height="30" rx="7"
        fill="#1e1a30" stroke="{overlapColor}" stroke-width="2"
        filter="url(#glow-shared)"/>
  <circle cx="{x + width - 8}" cy="{y + 8}" r="4" fill="{statusColor}"/>
  <text x="{x + width/2}" y="{y + 16}" text-anchor="middle" dominant-baseline="central"
        fill="#e2e8f0" font-size="11" font-weight="bold">{itemLabel}</text>
</g>
```

### Scope Annotation Outline (CSS animation, no SMIL)

```svg
<g class="scope-annotation">
  <circle cx="{scopeCx}" cy="{scopeCy}" r="{scopeRadius}"
          fill="none" stroke="#facc15" stroke-width="2" stroke-dasharray="10,5"
          style="animation: scopePulse 3s ease-in-out infinite;"/>
  <!-- Label with background pill -->
  <rect x="{scopeLabelX - labelW/2 - 6}" y="{scopeLabelY - 9}" width="{labelW + 12}" height="22"
        rx="6" fill="#facc15" fill-opacity="0.12" stroke="#facc15" stroke-opacity="0.4" stroke-width="1"/>
  <text x="{scopeLabelX}" y="{scopeLabelY}" text-anchor="middle" dominant-baseline="central"
        fill="#facc15" font-size="12" font-weight="bold">{scopeLabel}</text>
</g>
```

### Summary Stats (enhanced bar with color-coded blocks and percentage)

```svg
<g class="venn-summary" transform="translate({summaryX}, {summaryY})">
  <rect x="0" y="0" width="{summaryWidth}" height="52" rx="10"
        fill="#1a1a2e" stroke="#2a2a4a" stroke-width="1"/>

  <!-- Region 1 block -->
  <rect x="16" y="12" width="140" height="28" rx="6" fill="{color1}" fill-opacity="0.08"/>
  <text x="30" y="29" fill="{color1}" font-size="16" font-weight="bold">{uniqueCount1}</text>
  <text x="48" y="29" fill="{color1}" fill-opacity="0.6" font-size="11">{set1Name}만</text>

  <!-- Overlap block with percentage -->
  <rect x="172" y="12" width="140" height="28" rx="6" fill="{overlapColor}" fill-opacity="0.1"/>
  <text x="186" y="29" fill="{overlapColor}" font-size="16" font-weight="bold">{overlapCount}</text>
  <text x="204" y="29" fill="{overlapColor}" fill-opacity="0.6" font-size="11">공통</text>
  <text x="248" y="29" fill="{overlapColor}" fill-opacity="0.35" font-size="10">({overlapPct}%)</text>

  <!-- Region 2 block -->
  <rect x="328" y="12" width="140" height="28" rx="6" fill="{color2}" fill-opacity="0.08"/>
  <text x="342" y="29" fill="{color2}" font-size="16" font-weight="bold">{uniqueCount2}</text>
  <text x="360" y="29" fill="{color2}" fill-opacity="0.6" font-size="11">{set2Name}만</text>

  <!-- Total -->
  <text x="492" y="29" fill="#666666" font-size="10">전체 {totalUniqueItems}개</text>
</g>
```

### Legend Panel

```svg
<g class="legend" transform="translate({legendX}, {legendY})">
  <rect x="0" y="0" width="160" height="{legendHeight}" rx="10"
        fill="#1a1a2eee" stroke="#2a2a4a" stroke-width="1"/>
  <text x="14" y="20" fill="#888888" font-size="10" font-weight="bold">범례</text>

  <!-- Set colors -->
  <circle cx="22" cy="38" r="7" fill="{color1}" fill-opacity="0.15" stroke="{color1}" stroke-width="1.5"/>
  <text x="36" y="41" fill="#94a3b8" font-size="10">{set1Name}</text>

  <circle cx="22" cy="58" r="7" fill="{color2}" fill-opacity="0.15" stroke="{color2}" stroke-width="1.5"/>
  <text x="36" y="61" fill="#94a3b8" font-size="10">{set2Name}</text>

  {set3LegendEntry}

  <!-- Status -->
  <circle cx="22" cy="{statusY}" r="4" fill="#4ade80"/>
  <text x="32" y="{statusY + 3}" fill="#94a3b8" font-size="10">결정됨</text>
  <circle cx="82" cy="{statusY}" r="4" fill="#facc15"/>
  <text x="92" y="{statusY + 3}" fill="#94a3b8" font-size="10">논의 중</text>

  <!-- Scope -->
  <line x1="14" y1="{scopeY}" x2="32" y2="{scopeY}" stroke="#facc15" stroke-width="2" stroke-dasharray="5,3"/>
  <text x="38" y="{scopeY + 3}" fill="#94a3b8" font-size="10">범위 표시</text>
</g>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.venn-tooltip');
document.querySelectorAll('.venn-item').forEach(item => {
  item.addEventListener('mouseenter', e => {
    const desc = item.getAttribute('data-tooltip');
    const region = item.getAttribute('data-region');
    const status = item.getAttribute('data-status');
    const statusLabel = { decided: '결정됨', active: '논의 중', undecided: '미결정' }[status] || '';
    const statusColor = { decided: '#4ade80', active: '#facc15', undecided: '#6b7280' }[status] || '#6b7280';
    tooltip.innerHTML = `${desc}<span class="tt-region">${region}</span>${statusLabel ? `<span class="tt-status" style="background:${statusColor}18;color:${statusColor}">${statusLabel}</span>` : ''}`;
    tooltip.classList.add('visible');
  });
  item.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });
  item.addEventListener('mouseleave', () => tooltip.classList.remove('visible'));
});

// Set hover: dim other sets
document.querySelectorAll('.venn-set').forEach(set => {
  set.addEventListener('mouseenter', () => {
    document.querySelectorAll('.venn-set').forEach(s => {
      if (s !== set) s.style.opacity = '0.3';
    });
  });
  set.addEventListener('mouseleave', () => {
    document.querySelectorAll('.venn-set').forEach(s => s.style.opacity = '');
  });
});
```

## Rules

### Circle styling rules
- Each circle uses a radial gradient fill (center 22% opacity fading to 4% at edges) with an SVG glow filter (stdDeviation: 8, flood-opacity: 0.15). Add an inner ring at radius-10 for depth.
- Use `mix-blend-mode: screen` on circles if needed for natural color blending in overlap zones
- Circle labels positioned at outer edge (top or side), with bordered pill background using colored stroke
- Each label includes item count below the set name

### Circle sizing rules
- **2 circles**: side by side, overlapping ~30% in the center
- **3 circles**: equilateral triangle arrangement, each pair overlapping ~25%
- Base radius: 160-200px depending on item count
- Adjust overlap to give enough room for items in intersections

### Overlap zone rules
- Render the overlap zone with a dedicated radial gradient using clipPath for explicit visual distinction
- The clipPath clips circle2 to circle1's boundary, producing a filled intersection area
- Overlap gradient: center at 18% opacity fading to 6% at edges using the overlap blend color

### Item placement rules
- **Unique to one set**: place in the non-overlapping area of that circle
- **Shared between two sets**: place in the overlap region
- **Shared by all sets (3-circle)**: place at the center intersection
- Items shared between sets use brighter borders, bold text, and the `glow-shared` filter to emphasize intersection
- Each item has a status dot (green = decided, yellow = active/discussing, gray = undecided)

### Item collision avoidance
- Items within the same region are arranged in rows, flowing left-to-right, wrapping as needed
- Minimum 6px gap between items in the same region
- If region space is tight, reduce item font to 9px before overlapping
- **Vertical bounds check**: all items must stay within the circle boundary. For a circle at (cx, cy) with radius r, items in its unique region must have their bottom edge (y + height) < cy + r - 10. If items would overflow, apply these steps in order:
  1. Reduce item height to 28px and font to 10px
  2. Reduce vertical gap to 4px (item pitch = 32px)
  3. If still overflowing, use 2-column layout (split items into two columns side by side)
  4. Last resort: show first 5 items + a "+N more" indicator card

### Item card rules
- Cards use feDropShadow filter for depth, 30px height, rx=7
- Shared/intersection cards use the `glow-shared` filter instead of `card-shadow` for stronger visual emphasis
- Status dot radius: 4px, positioned at top-right of card

### Region count badge rules
- Large 36px faded numbers at 18% opacity -- the primary density indicator
- Each count badge has a region name label below (11px, 35% opacity, font-weight 500)
- Provides at-a-glance density information before users read any item labels
- Uses countFadeIn animation with 0.3s delay for staggered entrance

### Region labeling rules
- Each region gets a muted label showing the region name (e.g., "MVP만", "공통", "Full만")
- Labels are rendered below the count badge numbers, not as separate italic text
- Labels positioned at the visual center of each region

### Scope annotation rules
- If the purpose is scope definition (e.g., "MVP vs Full Product"), add a dashed outline around the selected scope
- Scope circle uses CSS `@keyframes scopePulse` animation (stroke-opacity oscillation + stroke-dashoffset shift) -- do NOT use SMIL `<animate>` elements
- Label on background pill with colored stroke: e.g., "MVP 범위"
- **Label placement**: The scope label pill must be in empty space outside the circle boundaries. Place it at the top of the viewBox, above the circles, connected by a short leader line (1px stroke, 50% opacity) from the scope circle's top edge to the label. Never place it where it overlaps set labels, item cards, or region count badges. If the scope annotation encircles the left set + overlap, position the label at the top-center or top-right of the annotation outline, above the set labels.

### Summary stats rules (optional)
- If showing 2 sets, include an enhanced stats bar below with color-coded blocks per region
- Each block: colored background rect at low opacity, bold count number, region label, and overlap percentage display
- Helps quantify the relationship between sets at a glance

### Set hover rules
- Hovering a set circle dims other sets to 30% opacity
- Transition: opacity 0.3s

### Tooltip rules
- Glassmorphism styling: `backdrop-filter: blur(8px)`, `background: #1a1a2eee`, border-radius 10px
- Enhanced box-shadow: `0 8px 32px rgba(0,0,0,0.5)`
- Display status tag in tooltip: inline-block pill with status-colored background at low opacity and status-colored text
- Status labels: decided = "결정됨", active = "논의 중", undecided = "미결정"

### Legend rules
- Always include: set colors, status dots (decided + active/discussing), scope annotation indicator
- Dynamic entries based on number of sets
- Legend container: rx=10, fill `#1a1a2eee`

## Layout Algorithm

Circle positioning with item placement. All values in px.

```
// --- Configuration ---
centerX = viewBoxWidth / 2
centerY = viewBoxHeight / 2 - 20   // shift up slightly for summary stats below
radius = 180                        // base circle radius
overlapRatio = 0.30                 // 30% overlap

// --- 2-circle layout ---
offset = radius * (1 - overlapRatio)   // distance from center to each circle center
circle1.cx = centerX - offset
circle2.cx = centerX + offset
circle1.cy = circle2.cy = centerY

// --- 3-circle layout ---
triRadius = radius * 0.65  // distance from viewBox center to each circle center
for i in [0, 1, 2]:
    angle = (i * 120) - 90  // start from top
    circle[i].cx = centerX + triRadius * cos(angle * PI / 180)
    circle[i].cy = centerY + triRadius * sin(angle * PI / 180)

// --- Calculate region centers ---
// 2-circle regions:
leftOnlyCenter  = (circle1.cx - radius * 0.4, centerY)
rightOnlyCenter = (circle2.cx + radius * 0.4, centerY)
intersectionCenter = (centerX, centerY)

// 3-circle regions:
// Each unique region: center of the non-overlapping arc area
// Each pairwise intersection: midpoint between two circle centers, offset outward
// Triple intersection: centroid of the three circle centers
tripleCenter = (
    (circle[0].cx + circle[1].cx + circle[2].cx) / 3,
    (circle[0].cy + circle[1].cy + circle[2].cy) / 3
)

// --- Item placement within regions ---
function placeItemsInRegion(items, regionCenterX, regionCenterY, availableWidth):
    itemGap = 6
    currentX = regionCenterX - availableWidth / 2
    currentY = regionCenterY - (estimatedRows * 32) / 2  // 32 = itemHeight(30) + gap
    rowStartX = currentX
    maxRowWidth = availableWidth

    for item in items:
        item.width = max(60, nodeWidth(item.label, 11))

        if currentX + item.width > rowStartX + maxRowWidth:
            // Wrap to next row
            currentX = rowStartX
            currentY += 32  // item height + gap

        item.x = currentX
        item.y = currentY
        currentX += item.width + itemGap

// Available width per region (approximate):
// Unique region: radius * 0.6
// Intersection (2 circles): offset * 0.8
// Triple intersection: triRadius * 0.5

// Available vertical space per region:
// maxItemsHeight = radius * 1.2  (items should occupy ~60% of circle diameter)
// If itemCount * itemPitch > maxItemsHeight, apply overflow rules:
//   1. Reduce itemHeight to 28, fontSize to 10, itemPitch to 32
//   2. If still overflowing, reduce itemPitch to 30
//   3. If still overflowing, show first 5 + "+N" indicator

// --- Scope annotation positioning ---
if scopeAnnotation:
    // Scope circle centered on the region(s) it covers
    // Radius = just large enough to contain all items in scope + 20px padding
    scopeItemBounds = boundingBox(scopeItems)
    scopeRadius = max(scopeItemBounds.width, scopeItemBounds.height) / 2 + 30
    scopeCx = scopeItemBounds.centerX
    scopeCy = scopeItemBounds.centerY

    // Scope label: place above circles in empty space
    // Leader line from scope circle top (scopeCx, scopeCy - scopeRadius) up to label
    scopeLabelX = scopeCx + scopeRadius * 0.5   // offset right to avoid set labels
    scopeLabelY = min(circle1.cy - radius - 30, scopeCy - scopeRadius - 20)  // above circles
    // If scopeLabelY < 30, clamp to 40 and ensure viewBox top has room

// --- Summary stats positioning ---
summaryX = centerX - summaryWidth / 2
summaryY = centerY + radius + 40

// --- ViewBox and legend position ---
viewBoxWidth = max(circle positions + radius) * 2 + 120 + 180  // +180 for legend
viewBoxHeight = summaryY + 80                                  // room for summary + legend
// If scope annotation exists, add 60px at top for scope label + leader line
// Shift centerY down by 30 to make room, or increase viewBoxHeight accordingly

// Legend position: bottom-right, outside content area
legendX = viewBoxWidth - 190                   // 10px inset from right edge
legendY = viewBoxHeight - legendHeight - 10    // 10px inset from bottom edge
// legendHeight depends on content (base ~80 + 18 per set entry)
```

### CJK Item Width

```
function nodeWidth(label, fontSize = 11):
    wideChars = count Korean/CJK characters
    latinChars = len(label) - wideChars
    textWidth = (wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return textWidth + 24  // 12px padding each side
```

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- Radial gradients on circles give much better visual depth than flat fill-opacity. The gradient center offset (40%, 45%) creates a subtle 3D lighting effect.
- The overlap zone highlight with clipPath-based gradient is essential -- without it, the intersection zone is visually ambiguous.
- The `mix-blend-mode: screen` on circles creates natural color blending in overlap zones, but the effect is subtle on the dark `#0f0f1a` background. The radial gradient approach is the primary visual differentiation; blend mode is supplementary.
- With 8+ items in a single region, the region can get crowded. For heavily populated regions, reduce item font to 9px and gap to 4px. If still crowded, show only the first 5 with a "+N" indicator.
- Region count badges (large faded numbers at 36px) are the fastest way for users to understand the distribution -- they see "3" in the overlap zone before reading any item labels.
- The scope annotation with CSS-animated pulse is very effective for "MVP vs Full" discussions -- it immediately draws attention to the selected boundary. Use CSS `@keyframes scopePulse` instead of SMIL `<animate>` for better browser compatibility.
- For 3-circle Venn diagrams, the triple intersection zone is small. Keep item labels in that zone very short (max 6 Korean chars) or use abbreviations.
- Set hover dimming helps isolate which items belong to which set -- especially useful when items in overlap zones are ambiguous.
- The glassmorphism tooltip with `backdrop-filter: blur(8px)` and status tag display provides richer context on hover than plain text tooltips.
- **Scope annotation label placement**: The scope annotation label pill must be placed in empty space outside the circle boundaries — best position is above the circles at the top of the viewBox, connected by a short leader line. Never place it where it overlaps with set labels, item text, region count badges, or intersection labels. If the annotation outline is tight around circles, extend the label outward with a short leader line (1px, 50% opacity) rather than placing it on top of circle content. Tested: placing the label at top-right with leader line from the scope circle's upper arc works well and avoids all collisions.
- **Asymmetric item counts**: When one region has significantly more items than others (e.g., 7 vs 3), the larger region's items can overflow the circle boundary. Use reduced item height (28px), font size (10px), and tighter vertical gap (34px pitch) for regions with 6+ items. This was validated with a 3/4/7 item distribution across MVP/shared/full regions.
- **Region center placement for unique-only regions**: The formula `circle.cx + radius * 0.4` places the region center too far outward for the right-only region, causing items to extend past the circle edge. Use `circle.cx + radius * 0.35` instead, and ensure item width doesn't exceed `radius * 0.55` for unique regions.
