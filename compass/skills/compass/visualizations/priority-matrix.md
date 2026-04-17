# Priority Matrix Rendering Guide

**When to use:** Deciding what to do first. The conversation involves prioritization,
"what first?", importance vs effort, or urgency vs impact.

**Data source:** Elements from the state file, positioned by two user-relevant dimensions
(e.g., importance x effort, impact x urgency).

**Structure:** 2x2 grid with items placed in quadrants. Items positioned within each
quadrant reflect their relative priority.

## Templates

### Global Styles

```html
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    background: #0f0f1a; color: #e2e8f0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    padding: 24px; min-height: 100vh;
  }

  /* Item pill interactions */
  .priority-pill {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    cursor: default;
    opacity: 0; animation: pillFadeIn 0.3s ease-out forwards;
  }
  .priority-pill:hover {
    transform: scale(1.08) !important;
    box-shadow: 0 4px 16px rgba(0,0,0,0.4) !important;
    z-index: 10;
  }

  @keyframes pillFadeIn {
    from { opacity: 0; }
    to   { opacity: 1; }
  }

  /* Quadrant hover */
  .quadrant {
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
  }
  .quadrant::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    opacity: 0;
    transition: opacity 0.3s;
  }
  .quadrant:hover::before { opacity: 1; }
  .quadrant:hover { filter: brightness(1.06); }

  /* Dependency line */
  .dep-line {
    transition: stroke-opacity 0.3s;
  }

  /* Tooltip — glassmorphism */
  .prio-tooltip {
    position: fixed; pointer-events: none; z-index: 100;
    background: #1a1a2eee; border: 1px solid #4a4a7a; border-radius: 10px;
    padding: 12px 16px; font-size: 12px; color: #e2e8f0;
    max-width: 280px; opacity: 0; transition: opacity 0.2s;
    box-shadow: 0 8px 32px rgba(0,0,0,0.5);
    backdrop-filter: blur(8px);
  }
  .prio-tooltip.visible { opacity: 1; }
  .prio-tooltip .tt-quadrant {
    font-size: 10px; font-weight: bold; margin-top: 6px; opacity: 0.7;
  }

  /* Axis labels */
  .axis-label {
    font-size: 11px; color: #64748b; font-weight: 600;
    letter-spacing: 0.5px; text-transform: uppercase;
  }
  .axis-arrow { color: #475569; font-size: 14px; }

  /* Responsive */
  @media (max-width: 600px) {
    .priority-grid { max-width: 100% !important; }
  }
</style>
```

### Full Matrix Container

```html
<div style="max-width: 960px; margin: 0 auto;">

  <!-- Summary bar -->
  {summary_bar}

  <!-- Matrix area -->
  <div style="position: relative; max-width: 680px; margin: 0 auto;">

    <!-- Top axis label -->
    <div style="text-align: center; margin-bottom: 10px;">
      <span class="axis-arrow">&#9650;</span>
      <span class="axis-label" style="margin-left: 6px;">{y_axis_high_label}</span>
    </div>

    <div style="display: flex; align-items: center; gap: 12px;">
      <!-- Left axis label (vertical) -->
      <div style="writing-mode: vertical-rl; transform: rotate(180deg);">
        <span class="axis-label">{x_axis_low_label}</span>
        <span class="axis-arrow" style="margin-top: 6px;">&#9650;</span>
      </div>

      <!-- 2x2 Grid — no forced aspect-ratio, content-driven height -->
      <div class="priority-grid" style="flex: 1; position: relative;">
        <div style="display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: auto auto; width: 100%; gap: 3px; border-radius: 14px; overflow: hidden;">
          {quadrant_do_first}
          {quadrant_plan}
          {quadrant_delegate}
          {quadrant_defer}
        </div>

        <!-- Cross axes (gradient overlay) -->
        <div style="position: absolute; top: 0; left: 50%; width: 2px; height: 100%; background: linear-gradient(to bottom, #4a4a7a00, #4a4a7a, #4a4a7a00); pointer-events: none;"></div>
        <div style="position: absolute; top: 50%; left: 0; width: 100%; height: 2px; background: linear-gradient(to right, #4a4a7a00, #4a4a7a, #4a4a7a00); pointer-events: none;"></div>

        <!-- Dependency lines (SVG overlay) -->
        <svg style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none;">
          {dependency_lines}
        </svg>
      </div>

      <!-- Right axis label -->
      <div style="writing-mode: vertical-rl;">
        <span class="axis-label">{x_axis_high_label}</span>
        <span class="axis-arrow" style="margin-top: 6px;">&#9660;</span>
      </div>
    </div>

    <!-- Bottom axis label -->
    <div style="text-align: center; margin-top: 10px;">
      <span class="axis-arrow">&#9660;</span>
      <span class="axis-label" style="margin-left: 6px;">{y_axis_low_label}</span>
    </div>
  </div>

  <!-- Action summary (below matrix) -->
  {action_summary}
</div>

<div class="prio-tooltip"></div>
```

### Summary Bar (above matrix)

```html
<div style="display: flex; gap: 10px; margin-bottom: 24px; max-width: 680px; margin-left: auto; margin-right: auto;">
  <div style="flex: 1; text-align: center; padding: 12px 8px; background: linear-gradient(135deg, #4ade8008 0%, #4ade8015 100%); border-radius: 10px; border: 1px solid #4ade8025;">
    <div style="font-size: 22px; font-weight: bold; color: #4ade80;">{doFirstCount}</div>
    <div style="font-size: 10px; color: #4ade80; opacity: 0.7; font-weight: 500;">Do First</div>
  </div>
  <div style="flex: 1; text-align: center; padding: 12px 8px; background: linear-gradient(135deg, #3b82f608 0%, #3b82f615 100%); border-radius: 10px; border: 1px solid #3b82f625;">
    <div style="font-size: 22px; font-weight: bold; color: #3b82f6;">{planCount}</div>
    <div style="font-size: 10px; color: #3b82f6; opacity: 0.7; font-weight: 500;">Plan</div>
  </div>
  <div style="flex: 1; text-align: center; padding: 12px 8px; background: linear-gradient(135deg, #facc1508 0%, #facc1515 100%); border-radius: 10px; border: 1px solid #facc1525;">
    <div style="font-size: 22px; font-weight: bold; color: #facc15;">{delegateCount}</div>
    <div style="font-size: 10px; color: #facc15; opacity: 0.7; font-weight: 500;">Delegate</div>
  </div>
  <div style="flex: 1; text-align: center; padding: 12px 8px; background: linear-gradient(135deg, #6b728008 0%, #6b728015 100%); border-radius: 10px; border: 1px solid #6b728025;">
    <div style="font-size: 22px; font-weight: bold; color: #6b7280;">{deferCount}</div>
    <div style="font-size: 10px; color: #6b7280; opacity: 0.7; font-weight: 500;">Defer</div>
  </div>
</div>
```

### Quadrant: Do First (top-left)

```html
<div class="quadrant" style="background: linear-gradient(135deg, #4ade800a 0%, #4ade8018 100%); border-radius: 14px 0 0 0; padding: 16px 18px; min-height: 160px;">
  <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
    <div>
      <div style="font-size: 14px; font-weight: bold; color: #4ade80; display: flex; align-items: center; gap: 6px;">
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 5px; background: #4ade8018; font-size: 10px;">&#9889;</span>
        Do First
      </div>
      <div style="font-size: 10px; color: #4ade80; opacity: 0.5; margin-top: 2px; margin-left: 26px;">지금 하기</div>
    </div>
    <span style="font-size: 24px; font-weight: bold; color: #4ade80; opacity: 0.15;">{count}</span>
  </div>
  <div style="display: flex; flex-direction: column; gap: 8px;">
    {items}
  </div>
</div>
```

### Quadrant: Plan (top-right)

```html
<div class="quadrant" style="background: linear-gradient(135deg, #3b82f60a 0%, #3b82f618 100%); border-radius: 0 14px 0 0; padding: 16px 18px; min-height: 160px;">
  <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
    <div>
      <div style="font-size: 14px; font-weight: bold; color: #3b82f6; display: flex; align-items: center; gap: 6px;">
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 5px; background: #3b82f618; font-size: 10px;">&#128197;</span>
        Plan
      </div>
      <div style="font-size: 10px; color: #3b82f6; opacity: 0.5; margin-top: 2px; margin-left: 26px;">계획 세우기</div>
    </div>
    <span style="font-size: 24px; font-weight: bold; color: #3b82f6; opacity: 0.15;">{count}</span>
  </div>
  <div style="display: flex; flex-direction: column; gap: 8px;">
    {items}
  </div>
</div>
```

### Quadrant: Delegate (bottom-left)

```html
<div class="quadrant" style="background: linear-gradient(135deg, #facc1508 0%, #facc1512 100%); border-radius: 0 0 0 14px; padding: 16px 18px; min-height: 130px;">
  <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
    <div>
      <div style="font-size: 14px; font-weight: bold; color: #facc15; display: flex; align-items: center; gap: 6px;">
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 5px; background: #facc1518; font-size: 10px;">&#128101;</span>
        Delegate
      </div>
      <div style="font-size: 10px; color: #facc15; opacity: 0.5; margin-top: 2px; margin-left: 26px;">위임하기</div>
    </div>
    <span style="font-size: 24px; font-weight: bold; color: #facc15; opacity: 0.15;">{count}</span>
  </div>
  <div style="display: flex; flex-direction: column; gap: 8px;">
    {items}
  </div>
</div>
```

### Quadrant: Defer (bottom-right)

```html
<div class="quadrant" style="background: linear-gradient(135deg, #6b728006 0%, #6b72800e 100%); border-radius: 0 0 14px 0; padding: 16px 18px; min-height: 130px;">
  <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
    <div>
      <div style="font-size: 14px; font-weight: bold; color: #6b7280; display: flex; align-items: center; gap: 6px;">
        <span style="display: inline-flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 5px; background: #6b728018; font-size: 10px;">&#128337;</span>
        Defer
      </div>
      <div style="font-size: 10px; color: #6b7280; opacity: 0.5; margin-top: 2px; margin-left: 26px;">나중에</div>
    </div>
    <span style="font-size: 24px; font-weight: bold; color: #6b7280; opacity: 0.15;">{count}</span>
  </div>
  <div style="display: flex; flex-direction: column; gap: 8px;">
    {items}
  </div>
</div>
```

### Item Pill: Core Element

```html
<div class="priority-pill" data-id="{itemId}" data-tooltip="{description}"
     data-quadrant="{quadrantName}"
     style="background: #1a1a2e; border: 1.5px solid {quadrantColor}60; border-left: 3px solid {statusColor}; border-radius: 8px; padding: 8px 12px; font-size: 12px; color: #e2e8f0; position: relative; animation-delay: {delay}s; box-shadow: 0 2px 8px rgba({quadrantColorRGB},0.06);">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <span>
      <span style="display: inline-block; width: 7px; height: 7px; border-radius: 50%; background: {statusColor}; margin-right: 6px; vertical-align: middle; box-shadow: 0 0 6px {statusColor}60;"></span>
      {item_name}
    </span>
    <span style="font-size: 9px; color: {statusColor}; opacity: 0.6;">{statusLabel}</span>
  </div>
</div>
```

### Item Pill: Detail Element

```html
<div class="priority-pill" data-id="{itemId}" data-tooltip="{description}"
     data-quadrant="{quadrantName}"
     style="background: #1a1a2e; border: 1px dashed {quadrantColor}40; border-left: 3px solid #6b7280; border-radius: 8px; padding: 8px 12px; font-size: 11px; color: #94a3b8; position: relative; animation-delay: {delay}s;">
  <span>
    <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #6b7280; margin-right: 6px; vertical-align: middle;"></span>
    {item_name}
  </span>
</div>
```

### Dependency Line (SVG overlay)

```svg
<line class="dep-line" x1="{fromPctX}%" y1="{fromPctY}%"
      x2="{toPctX}%" y2="{toPctY}%"
      stroke="#94a3b8" stroke-width="1" stroke-opacity="0.3"
      stroke-dasharray="4,4" marker-end="url(#dep-arrow)"/>
```

### Action Summary (below matrix)

```html
<div style="max-width: 680px; margin: 24px auto 0; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
  <!-- Do First actions -->
  <div style="background: #1a1a2e; border-radius: 10px; padding: 14px 16px; border-left: 4px solid #4ade80; box-shadow: 0 2px 12px rgba(74,222,128,0.04);">
    <div style="font-size: 13px; font-weight: bold; color: #4ade80; margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
      <span style="display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; border-radius: 4px; background: #4ade8015; font-size: 9px;">&#9889;</span>
      즉시 실행
    </div>
    <ol style="font-size: 12px; color: #94a3b8; padding-left: 18px; line-height: 1.8;">
      {doFirstActionItems}
    </ol>
  </div>
  <!-- Plan actions -->
  <div style="background: #1a1a2e; border-radius: 10px; padding: 14px 16px; border-left: 4px solid #3b82f6; box-shadow: 0 2px 12px rgba(59,130,246,0.04);">
    <div style="font-size: 13px; font-weight: bold; color: #3b82f6; margin-bottom: 8px; display: flex; align-items: center; gap: 6px;">
      <span style="display: inline-flex; align-items: center; justify-content: center; width: 18px; height: 18px; border-radius: 4px; background: #3b82f615; font-size: 9px;">&#128197;</span>
      계획 필요
    </div>
    <ol style="font-size: 12px; color: #94a3b8; padding-left: 18px; line-height: 1.8;">
      {planActionItems}
    </ol>
  </div>
</div>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.prio-tooltip');
document.querySelectorAll('.priority-pill').forEach(pill => {
  pill.addEventListener('mouseenter', e => {
    const desc = pill.getAttribute('data-tooltip');
    const quad = pill.getAttribute('data-quadrant');
    tooltip.innerHTML = `${desc}<div class="tt-quadrant">${quad}</div>`;
    tooltip.classList.add('visible');
  });
  pill.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });
  pill.addEventListener('mouseleave', () => tooltip.classList.remove('visible'));
});
```

## Rules

### Quadrant rules
- Top-left = Do First (urgent + important), green `#4ade80`
- Top-right = Plan (important, not urgent), blue `#3b82f6`
- Bottom-left = Delegate (urgent, not key), yellow `#facc15`
- Bottom-right = Defer (neither), gray `#6b7280`
- If the two axes are not importance/urgency, adapt labels to fit actual dimensions while keeping 4-quadrant structure
- Quadrant backgrounds use gradient (`linear-gradient` 135deg, from `0a` to `18` opacity). Each quadrant header has an icon (&#9889; Do First, &#128197; Plan, &#128101; Delegate, &#128337; Defer), English name, Korean sub-label, and faded count (`font-size: 24px; opacity: 0.15`) in the top-right corner
- Top-row quadrants use `min-height: 160px`; bottom-row quadrants use `min-height: 130px`

### Summary bar rules
- Always show above the matrix — one card per quadrant with count
- Use English quadrant names: "Do First", "Plan", "Delegate", "Defer"
- Gradient backgrounds (`linear-gradient` 135deg, from `08` to `15` opacity) and colored borders (`{color}25`)
- Count numbers at `22px`, labels colored to match quadrant with `opacity: 0.7` and `font-weight: 500`

### Item pill rules
- Core items: solid border `1.5px` at `{quadrantColor}60`, `font-size: 12px`, white text, with `box-shadow: 0 2px 8px` for subtle depth
- Core items have left accent border (`3px solid`) in status color for quick visual scanning
- Detail items: dashed border `1px` at `{quadrantColor}40`, `font-size: 11px`, muted text (`#94a3b8`), left accent border `3px solid #6b7280`
- Each core pill has a status dot (`7px`) with `box-shadow: 0 0 6px {statusColor}60` glow for decided/active states. Detail pills use a smaller dot (`6px`) without glow
- Core pills show a right-aligned status label (`font-size: 9px; opacity: 0.6`)
- Status colors: green `#4ade80` (decided), yellow `#facc15` (active/discussing), gray `#6b7280` (undecided)
- Pills fade in with staggered delay
- Items within a quadrant placed by priority: higher-priority items first

### Dependency line rules
- If items have `depends-on` relations, render as dashed lines in the SVG overlay
- Lines use percentage-based coordinates (`x1="%"`) so they scale with the grid
- Lines are subtle (`stroke-opacity: 0.3`) to not overwhelm the layout

### Axis rules
- Labels use uppercase styling (`text-transform: uppercase`) with `0.5px` letter-spacing, color `#64748b`, `font-weight: 600`
- Arrows use `&#9650;` (&#9650;) and `&#9660;` (&#9660;) symbols, color `#475569`, `font-size: 14px`
- Side labels use `writing-mode: vertical-rl` (left label also applies `transform: rotate(180deg)`)
- Axis lines use gradient (`linear-gradient`, transparent to `#4a4a7a` to transparent) for softer appearance, `2px` width

### Action summary rules
- If the "Do First" or "Plan" quadrants have items, show action summary below the matrix
- Enhanced cards with `border-left: 4px solid`, `border-radius: 10px`, and subtle `box-shadow`
- Icon headers using inline-flex spans matching quadrant icons
- Numbered list (`<ol>`) format at `font-size: 12px`, `line-height: 1.8` for concrete next steps

### Responsive rules
- Matrix max-width `680px`, centered — no forced `aspect-ratio`; grid rows use `auto` height
- Below 600px: grid fills full width, pills may wrap more aggressively

### Tooltip rules
- Glassmorphism styling: `background: #1a1a2eee`, `backdrop-filter: blur(8px)`, `border-radius: 10px`, `box-shadow: 0 8px 32px rgba(0,0,0,0.5)`
- Each pill shows description + quadrant name on hover
- Tooltip follows cursor, max-width `280px`

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- With 8+ items in a single quadrant, pills can overflow. The `flex-wrap: wrap` / `flex-direction: column` handles this, but consider showing only the top 6 per quadrant and using a "+N more" indicator for the rest.
- The summary bar provides the quickest orientation — users immediately see the distribution across quadrants before reading individual items.
- Dependency lines are most useful when items in "Do First" depend on items in other quadrants (reveals potential blockers), but can be distracting if there are too many. Cap at 5-6 visible lines.
- Action summary converts the visual into concrete next steps — this is the most actionable part for users who want to know "ok, so what do I do now?"
- Removing `aspect-ratio: 1` and using `min-height` instead allows quadrants to accommodate varying item counts without wasted space or overflow. Top-row quadrants (Do First, Plan) get more minimum space (`160px`) since they typically hold the most actionable items.
