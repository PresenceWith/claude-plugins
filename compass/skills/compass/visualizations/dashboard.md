# Status Dashboard Rendering Guide

**When to use:** Checkpoints, progress review, "where are we?". The user needs orientation
on what's been decided and what remains.

**Data source:** Decided items, undecided items, active discussion from state file.

**Structure:** Three columns — Decided (green), In Discussion (yellow), Undecided (gray).
Each item shows a brief label. The currently active topic is highlighted.

## Templates

### Global Styles (include once in `<style>`)

```html
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    background: #0f0f1a; color: #e2e8f0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    padding: 24px; min-height: 100vh;
  }

  /* Stat cards */
  .stat-card {
    flex: 1; border-radius: 12px; padding: 16px 18px; position: relative; overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s;
  }
  .stat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.3); }
  .stat-card .stat-bg {
    position: absolute; top: -20px; right: -20px; width: 80px; height: 80px; border-radius: 50%;
    opacity: 0.06;
  }
  .stat-number { font-size: 28px; font-weight: bold; line-height: 1; }
  .stat-label { font-size: 11px; color: #888; margin-top: 4px; }
  .stat-pct { font-size: 10px; opacity: 0.6; margin-top: 2px; }

  /* Progress bar with shimmer */
  .progress-track { display: flex; height: 10px; border-radius: 5px; overflow: hidden; background: #1a1a2e; }
  .progress-segment { transition: width 0.8s cubic-bezier(0.4,0,0.2,1); position: relative; }
  .progress-segment::after {
    content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
    animation: shimmer 2s ease-in-out infinite;
  }
  @keyframes shimmer { 0%,100% { transform: translateX(-100%); } 50% { transform: translateX(100%); } }

  /* Category section headers */
  .category-section {
    margin-bottom: 8px; padding: 6px 10px; border-radius: 6px;
    font-size: 10px; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase;
  }

  /* Card hover interaction */
  .dash-card {
    transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
    cursor: default;
    opacity: 0;
    animation: cardSlideIn 0.3s ease-out forwards;
  }
  .dash-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.35);
  }

  /* Fade-in animation for cards */
  @keyframes cardSlideIn {
    from { opacity: 0; transform: translateY(8px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* Stagger card animations — set via inline style: animation-delay */

  /* Column header with bottom border */
  .column-header {
    display: flex; align-items: center; gap: 8px; margin-bottom: 14px;
    padding-bottom: 10px; border-bottom: 2px solid;
  }
  .column-dot { width: 10px; height: 10px; border-radius: 50%; }

  /* Column header count badge */
  .col-count {
    display: inline-block;
    min-width: 22px; height: 22px;
    border-radius: 11px;
    font-size: 11px; font-weight: bold;
    text-align: center; line-height: 22px;
    margin-left: 6px;
  }

  /* Category badge */
  .category-badge {
    display: inline-block;
    padding: 2px 8px; border-radius: 4px;
    font-size: 9px; font-weight: bold;
    letter-spacing: 0.3px;
  }

  /* Dependency link */
  .dep-link {
    font-size: 11px; color: #666; margin-top: 6px; padding-top: 6px; border-top: 1px solid #2a2a4a;
    display: flex; align-items: center; gap: 4px;
  }
  .dep-link span { color: #4a4a7a; }

  /* Responsive: single column below 700px */
  @media (max-width: 700px) {
    .dash-grid { grid-template-columns: 1fr !important; }
    .stats-row { flex-wrap: wrap !important; }
    .stat-card { min-width: 140px; }
  }

  /* Decision order flow */
  .decision-step {
    display: inline-flex; align-items: center; gap: 6px;
    padding: 6px 12px; border-radius: 8px;
    transition: transform 0.2s; cursor: default;
  }
  .decision-step:hover { transform: scale(1.05); }
  .step-number {
    display: inline-flex; align-items: center; justify-content: center;
    width: 24px; height: 24px; border-radius: 50%;
    font-size: 11px; font-weight: bold;
  }
  .step-arrow { color: #4a4a7a; font-size: 18px; margin: 0 2px; }

  /* Tooltip — glassmorphism */
  .dash-tooltip {
    position: fixed; pointer-events: none; z-index: 100;
    background: #1a1a2eee; backdrop-filter: blur(8px); border: 1px solid #4a4a7a; border-radius: 10px;
    padding: 10px 14px; font-size: 12px; color: #e2e8f0;
    max-width: 280px; opacity: 0; transition: opacity 0.2s;
    box-shadow: 0 8px 32px rgba(0,0,0,0.5);
  }
  .dash-tooltip.visible { opacity: 1; }

  /* Pulse animation for active items */
  @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
</style>
```

### Container: Full Dashboard

```html
<div style="max-width: 960px; margin: 0 auto;">

  <!-- Summary Stats Bar -->
  {summary_stats}

  <!-- Progress Bar -->
  {progress_bar}

  <!-- 3-Column Grid -->
  <div class="dash-grid" style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
    {decided_column}
    {active_column}
    {undecided_column}
  </div>

  <!-- Decision Order (optional) -->
  {decision_order}
</div>

<!-- Tooltip container -->
<div class="dash-tooltip"></div>
```

### Summary Stats Bar

```html
<div class="stats-row" style="display: flex; gap: 12px; margin-bottom: 20px;">
  <!-- Total items -->
  <div class="stat-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #1e1e38 100%); border: 1px solid #3a3a5a;">
    <div class="stat-bg" style="background: #e2e8f0;"></div>
    <div class="stat-number" style="color: #e2e8f0;">{total}</div>
    <div class="stat-label">전체 항목</div>
  </div>
  <!-- Decided -->
  <div class="stat-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #1a2e1a 100%); border: 1px solid #4ade8030;">
    <div class="stat-bg" style="background: #4ade80;"></div>
    <div class="stat-number" style="color: #4ade80;">{decided_count}</div>
    <div class="stat-label">결정됨</div>
    <div class="stat-pct" style="color: #4ade80;">{decided_pct}%</div>
  </div>
  <!-- Active -->
  <div class="stat-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #2e2a1a 100%); border: 1px solid #facc1530;">
    <div class="stat-bg" style="background: #facc15;"></div>
    <div class="stat-number" style="color: #facc15;">{active_count}</div>
    <div class="stat-label">논의 중</div>
    <div class="stat-pct" style="color: #facc15;">{active_pct}%</div>
  </div>
  <!-- Undecided -->
  <div class="stat-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #1e1e28 100%); border: 1px solid #6b728030;">
    <div class="stat-bg" style="background: #6b7280;"></div>
    <div class="stat-number" style="color: #6b7280;">{undecided_count}</div>
    <div class="stat-label">미결정</div>
    <div class="stat-pct" style="color: #6b7280;">{undecided_pct}%</div>
  </div>
</div>
```

### Progress Bar

```html
<div style="margin-bottom: 24px;">
  <div class="progress-track">
    <div class="progress-segment" style="width: {decided_pct}%; background: linear-gradient(90deg, #4ade80, #22c55e); border-radius: 5px 0 0 5px;"></div>
    <div class="progress-segment" style="width: {active_pct}%; background: linear-gradient(90deg, #facc15, #eab308);"></div>
    <div class="progress-segment" style="width: {undecided_pct}%; background: linear-gradient(90deg, #6b7280, #4b5563); border-radius: 0 5px 5px 0;"></div>
  </div>
  <div style="display: flex; justify-content: space-between; margin-top: 8px; font-size: 11px;">
    <span style="color: #4ade80;">{decided_count} 결정</span>
    <span style="color: #888;">진행률 <strong style="color: #e2e8f0;">{decided_pct}%</strong> · {total}개 항목 중 {decided_count}개 완료</span>
    <span style="color: #6b7280;">{undecided_count} 미결정</span>
  </div>
</div>
```

### Column: Decided

```html
<div>
  <div class="column-header" style="border-color: #4ade8040;">
    <div class="column-dot" style="background: #4ade80; box-shadow: 0 0 8px #4ade8060;"></div>
    <h2 style="color: #4ade80; font-size: 15px; font-weight: bold;">결정됨</h2>
    <span class="col-count" style="background: #4ade8018; color: #4ade80;">{decided_count}</span>
  </div>
  {category_sections_and_decided_cards}
</div>
```

### Column: In Discussion

```html
<div>
  <div class="column-header" style="border-color: #facc1540;">
    <div class="column-dot" style="background: #facc15; box-shadow: 0 0 8px #facc1560;"></div>
    <h2 style="color: #facc15; font-size: 15px; font-weight: bold;">논의 중</h2>
    <span class="col-count" style="background: #facc1518; color: #facc15;">{active_count}</span>
  </div>
  {active_cards}
  {insight_callout}
</div>
```

### Column: Undecided

```html
<div>
  <div class="column-header" style="border-color: #6b728040;">
    <div class="column-dot" style="background: #6b7280;"></div>
    <h2 style="color: #6b7280; font-size: 15px; font-weight: bold;">미결정</h2>
    <span class="col-count" style="background: #6b728018; color: #6b7280;">{undecided_count}</span>
  </div>
  {undecided_cards}
</div>
```

### Category Section Header (optional, per column)

```html
<div class="category-section" style="background: {domainColor}08; color: {domainColor};">
  {categoryName}
</div>
```

### Card: Decided Item

```html
<div class="dash-card" style="background: #1a1a2e; border: 1px solid #4ade8040; border-left: 3px solid #4ade80; border-radius: 8px; padding: 12px 14px; margin-bottom: 8px; animation-delay: {index * 0.05}s;"
     data-tooltip="{fullDescription}">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <strong style="color: #e2e8f0; font-size: 13px;">{title}</strong>
    <div style="display: flex; align-items: center; gap: 4px;">
      {new_badge}
      <span style="font-size: 10px; color: #4ade80; opacity: 0.7;">결정</span>
    </div>
  </div>
  <div style="font-size: 12px; color: #4ade80; margin-top: 6px; opacity: 0.7;">{decision_value}</div>
  {category_badge}
  {relation_hint}
</div>
```

### Card: Active Item (highlighted)

```html
<div class="dash-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #2a261e 100%); border: 1.5px solid #facc1560; border-left: 3px solid #facc15; border-radius: 8px; padding: 12px 14px; margin-bottom: 8px; box-shadow: 0 0 20px rgba(250,204,21,0.06); animation-delay: {index * 0.05}s;"
     data-tooltip="{fullDescription}">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <strong style="color: #e2e8f0; font-size: 13px;">{title}</strong>
    <span style="font-size: 10px; color: #facc15; animation: pulse 2s infinite;">논의 중</span>
  </div>
  <!-- Option chips instead of pipe-separated text -->
  <div style="display: flex; gap: 6px; margin-top: 8px;">
    <!-- Leading option (highlighted) -->
    <span style="font-size: 11px; padding: 3px 8px; border-radius: 4px; background: #facc1510; color: #facc15; border: 1px solid #facc1520;">{option1}</span>
    <!-- Other options (muted) -->
    <span style="font-size: 11px; padding: 3px 8px; border-radius: 4px; background: #1a1a2e; color: #888; border: 1px solid #2a2a4a;">{option2}</span>
  </div>
  {category_badge}
  {relation_hint}
</div>
```

### Card: Undecided Item

```html
<div class="dash-card" style="background: #1a1a2e; border: 1px dashed #6b728050; border-left: 3px solid #6b7280; border-radius: 8px; padding: 12px 14px; margin-bottom: 8px; animation-delay: {index * 0.05}s;"
     data-tooltip="{fullDescription}">
  <div style="display: flex; justify-content: space-between; align-items: center;">
    <strong style="color: #e2e8f0; font-size: 13px;">{title}</strong>
    <span style="font-size: 10px; color: #6b7280;">미결정</span>
  </div>
  <div style="font-size: 11px; color: #666; margin-top: 6px;">{options}</div>
  {category_badge}
  {relation_hint}
</div>
```

### NEW Badge (for recently decided items)

```html
<span style="background: linear-gradient(135deg, #4ade80, #22c55e); color: #0f0f1a; font-size: 9px; padding: 2px 8px; border-radius: 4px; font-weight: bold;">NEW</span>
```

### Category Badge (optional, per card)

```html
<span class="category-badge" style="background: {domainColor}10; color: {domainColor}; margin-top: 8px;">{categoryName}</span>
```

### Relation Hint (optional, per card)

```html
<div class="dep-link">
  <span>&#8627;</span> {relation_hint}
</div>
```

### Insight Callout (optional, for active column)

```html
<div style="background: #facc1508; border: 1px dashed #facc1530; border-radius: 8px; padding: 10px 12px; margin-top: 8px;">
  <div style="font-size: 10px; color: #facc15; font-weight: bold; margin-bottom: 4px;">INSIGHT</div>
  <div style="font-size: 11px; color: #888; line-height: 1.5;">{insightText}</div>
</div>
```

### Decision Order Section

```html
<div style="margin-top: 24px; padding: 18px 22px; background: linear-gradient(135deg, #1a1a2e 0%, #1e1e38 100%); border-radius: 12px; border: 1px solid #2a2a4a;">
  <h3 style="font-size: 13px; color: #e2e8f0; margin-bottom: 14px; display: flex; align-items: center; gap: 8px;">
    <span style="display: inline-flex; align-items: center; justify-content: center; width: 22px; height: 22px; border-radius: 6px; background: #facc1518; font-size: 12px;">&#9654;</span>
    권장 결정 순서
  </h3>
  <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 6px;">
    <div class="decision-step" style="background: {color}10; border: 1px solid {color}25;">
      <span class="step-number" style="background: {color}20; color: {color};">{number}</span>
      <span style="color: #e2e8f0; font-size: 13px;">{stepName}</span>
    </div>
    <span class="step-arrow">&#8594;</span>
    <!-- ... repeat for each step ... -->
  </div>
  <div style="font-size: 11px; color: #666; margin-top: 10px; line-height: 1.5; padding-left: 30px; border-left: 2px solid #2a2a4a;">
    {rationale}
  </div>
</div>
```

Step color sequence: `#4ade80` (green) -> `#3b82f6` (blue) -> `#06b6d4` (cyan) -> `#f59e0b` (amber) -> repeat.

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.dash-tooltip');
document.querySelectorAll('.dash-card[data-tooltip]').forEach(card => {
  card.addEventListener('mouseenter', e => {
    tooltip.textContent = card.getAttribute('data-tooltip');
    tooltip.classList.add('visible');
  });
  card.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });
  card.addEventListener('mouseleave', () => tooltip.classList.remove('visible'));
});
```

## Rules

### Layout rules
- Container uses `max-width: 960px` with `margin: 0 auto`.
- Below 700px viewport, collapse `grid-template-columns` from `1fr 1fr 1fr` to `1fr` (single column) via CSS media query. Stats row wraps with `min-width: 140px` per card.
- Each column has a `column-header` with bottom border for visual separation.

### Stat card rules
- Always show the 4-stat bar at the top: total, decided, active, undecided.
- Stat cards use gradient backgrounds tinted toward their status color (e.g., `linear-gradient(135deg, #1a1a2e, #1a2e1a)` for decided green tint).
- Decorative background circle (`.stat-bg`, opacity 0.06) positioned at top-right adds depth without distraction.
- Numbers are large (28px bold), labels are small (11px) and muted.
- Percentage shown for non-total cards (decided, active, undecided) using `.stat-pct` at 10px with 0.6 opacity.
- On hover: `translateY(-2px)` with `box-shadow: 0 8px 24px rgba(0,0,0,0.3)`.

### Progress bar rules
- Progress bar is 10px height with gradient fills for each segment (e.g., `linear-gradient(90deg, #4ade80, #22c55e)` for decided).
- Shimmer animation (`::after` pseudo-element) adds polish with a translucent gradient sweep every 2 seconds.
- Segments use CSS transition (`width 0.8s cubic-bezier(0.4,0,0.2,1)`) for smooth rendering.
- Show left/right counts beside the centered progress text: decided count (green, left), progress percentage (center), undecided count (gray, right).
- Green `#4ade80` -> `#22c55e` (decided), yellow `#facc15` -> `#eab308` (active), gray `#6b7280` -> `#4b5563` (undecided).

### Column header rules
- Each column header uses `.column-header` with a 2px bottom border in the status color at 40% opacity (e.g., `#4ade8040`).
- Colored dot indicator (`.column-dot`, 10px) with `box-shadow: 0 0 8px {color}60` glow for decided and active columns. Undecided dot has no glow.
- Title is 15px bold in the status color.
- Count badge uses the status color at 18% opacity background (e.g., `#4ade8018`).

### Category section rules
- When a column has 3+ items across multiple categories, group them with category section headers.
- Category sections use uppercase text at 10px, `font-weight: 600`, `letter-spacing: 0.5px`.
- Background uses domain color at 08% opacity (e.g., `#6366f108`), text in the domain color.
- Placed directly above the cards they group, with `margin-bottom: 8px`.

### Card styling rules
- All cards have a left accent border (3px solid) in their status color for quick scan.
- Decided cards: solid border `#4ade8040`, left accent `#4ade80`.
- Active cards: gradient background (`linear-gradient(135deg, #1a1a2e 0%, #2a261e 100%)`), solid border `#facc1560`, left accent `#facc15`, subtle glow `box-shadow: 0 0 20px rgba(250,204,21,0.06)`.
- Undecided cards: dashed border `#6b728050`, left accent `#6b7280`.
- Cards animate in with staggered `cardSlideIn` (0.05s delay per index).
- On hover: `translateY(-2px)` with `box-shadow: 0 6px 20px rgba(0,0,0,0.35)`.

### Card content rules
- Title: bold, 13px, `#e2e8f0`.
- Decision value (decided cards only): 12px, `#4ade80` at opacity 0.7.
- Category badge: optional, uses domain color at 10% bg, `margin-top: 8px`.
- Relation hint: uses `.dep-link` class with `#666` text, top border separator, and `#4a4a7a` arrow icon.

### Option chips rules
- Active discussion cards show options as styled chips instead of pipe-separated text.
- Leading option (most favored or first listed) uses highlighted chip: `background: #facc1510`, `color: #facc15`, `border: 1px solid #facc1520`.
- Alternative options use muted chip: `background: #1a1a2e`, `color: #888`, `border: 1px solid #2a2a4a`.
- Chips are displayed in a flex row with `gap: 6px`, `margin-top: 8px`.
- Each chip: `font-size: 11px`, `padding: 3px 8px`, `border-radius: 4px`.
- Undecided cards still use middot-separated text (e.g., "RBAC · ABAC · 커스텀") since they lack a leading option.

### Insight callout rules
- If the active column has a pattern (e.g., all items are tech-stack related, or share a common dependency), show an insight callout box at the bottom of the active column.
- Uses `background: #facc1508`, `border: 1px dashed #facc1530`, `border-radius: 8px`.
- Header: "INSIGHT" in 10px bold `#facc15`.
- Body: 11px `#888` with `line-height: 1.5`.
- This is optional — only add when there is a genuine pattern worth highlighting.

### NEW badge rules
- If an item was decided since the last visualization render, add the NEW badge.
- Badge uses gradient background `linear-gradient(135deg, #4ade80, #22c55e)`, dark text `#0f0f1a`, 9px bold, `border-radius: 4px`.

### Decision order rules
- Only render if undecided/active items have dependency relations between them.
- Container uses gradient background `linear-gradient(135deg, #1a1a2e, #1e1e38)`, `border-radius: 12px`, `border: 1px solid #2a2a4a`.
- Each step rendered as a bordered pill (`.decision-step`) with `background: {color}10`, `border: 1px solid {color}25`, `padding: 6px 12px`, `border-radius: 8px`.
- Step number uses `.step-number`: 24px circle with `{color}20` background and `{color}` text.
- Steps connected by `.step-arrow` characters (`&#8594;`).
- Steps have hover scale effect (`transform: scale(1.05)`).
- Include left-bordered rationale text below (`padding-left: 30px`, `border-left: 2px solid #2a2a4a`).
- Color sequence for steps: green `#4ade80` -> blue `#3b82f6` -> cyan `#06b6d4` -> amber `#f59e0b`.

### Tooltip rules
- Cards with additional context get `data-tooltip` attribute.
- Tooltip uses glassmorphism: `background: #1a1a2eee`, `backdrop-filter: blur(8px)`, `border-radius: 10px`.
- Enhanced shadow: `box-shadow: 0 8px 32px rgba(0,0,0,0.5)`.
- Follows cursor, max-width 280px.

## Known Issues & Optimization Notes

_This section is updated as the skill is used. Add rendering lessons learned here._

- Cards in sparsely populated columns (e.g., 1 item in "논의 중") can look visually light. The column header bottom border helps anchor the column but consider centering the single card vertically.
- The summary stats bar works well for quick glance — users consistently notice it first before diving into columns.
- Left accent borders (3px) provide faster visual scanning than uniform borders when there are 10+ cards across columns.
- `animation-delay` stagger should cap at 0.5s total (10 cards * 0.05s) to avoid feeling sluggish.
- Option chips in active cards provide much better UX than pipe-separated text — users can visually compare alternatives at a glance.
- The shimmer animation on progress bars adds perceived polish with minimal performance cost.
- Insight callout is optional — only add when there's a genuine pattern worth highlighting. Forced insights feel artificial and reduce trust.
