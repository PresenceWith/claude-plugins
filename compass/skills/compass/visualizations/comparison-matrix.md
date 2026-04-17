# Comparison Matrix Rendering Guide

**When to use:** Evaluating options against criteria. The conversation involves "A vs B",
"pros and cons", or weighing multiple alternatives by specific dimensions.

**Data source:** `alternative-to` relations in the state file, plus any criteria
mentioned in the conversation.

**Structure:** Table with options as columns, criteria as rows. Cells contain ratings or notes.
Visual score summary at the bottom.

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

  /* Score summary cards */
  .score-card {
    flex: 1; border-radius: 12px; padding: 16px 18px; position: relative; overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s;
  }
  .score-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.3); }
  .score-card .card-bg {
    position: absolute; top: -25px; right: -25px; width: 90px; height: 90px; border-radius: 50%; opacity: 0.05;
  }
  .score-bar-track { height: 8px; background: #0f0f1a; border-radius: 4px; overflow: hidden; margin: 8px 0; }
  .score-bar-fill { height: 100%; border-radius: 4px; transition: width 0.8s cubic-bezier(0.4,0,0.2,1); }
  .score-breakdown { display: flex; justify-content: space-between; font-size: 11px; gap: 4px; }
  .score-tag { padding: 2px 6px; border-radius: 4px; font-weight: 600; font-size: 10px; }

  /* Table */
  .matrix-table { width: 100%; border-collapse: separate; border-spacing: 0; background: #1a1a2e; }
  .matrix-table thead th {
    padding: 16px; font-size: 13px; background: #1e1e36; position: sticky; top: 0; z-index: 5;
  }
  .matrix-table tbody tr {
    opacity: 0; animation: rowFadeIn 0.3s ease-out forwards;
    transition: background-color 0.2s;
  }
  .matrix-table tbody tr:hover { background-color: #1e1e3680; }
  @keyframes rowFadeIn {
    from { opacity: 0; transform: translateX(-4px); }
    to   { opacity: 1; transform: translateX(0); }
  }
  .matrix-table td { padding: 14px 16px; border-bottom: 1px solid #2a2a4a18; transition: background-color 0.2s; }

  /* Criterion column */
  .criterion-name { font-size: 13px; color: #e2e8f0; font-weight: 500; }
  .criterion-weight { margin-left: 6px; }
  .weight-dot { display: inline-block; width: 6px; height: 6px; border-radius: 50%; margin-right: 1px; }
  .weight-dot.filled { background: #ef4444; }
  .weight-dot.half { background: #facc15; }
  .weight-dot.empty { background: #2a2a4a; }
  .weight-label { font-size: 9px; color: #666; margin-left: 4px; }

  /* Rating cells */
  .rating-cell { text-align: center; cursor: default; position: relative; }
  .rating-cell:hover .rating-box { filter: brightness(1.15); transform: scale(1.04); }
  .rating-box {
    display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 8px;
    transition: transform 0.15s ease, filter 0.15s;
    font-size: 12px; font-weight: 500;
  }
  .rating-icon { font-weight: bold; font-size: 14px; }

  /* Winner column highlight */
  .winner-col { position: relative; }
  .winner-col::after {
    content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0;
    background: linear-gradient(180deg, #4ade8005 0%, #4ade8002 100%);
    pointer-events: none;
  }

  /* Footer row */
  .matrix-table tfoot td { padding: 16px; background: #1e1e36; border-top: 2px solid #2a2a4a; }
  .final-score { display: flex; flex-direction: column; align-items: center; gap: 6px; }
  .final-bar { width: 80%; height: 6px; background: #0f0f1a; border-radius: 3px; overflow: hidden; }
  .final-bar-fill { height: 100%; border-radius: 3px; }

  /* Tooltip — glassmorphism */
  .matrix-tooltip {
    position: fixed; pointer-events: none; z-index: 100;
    background: #1a1a2eee; border: 1px solid #4a4a7a; border-radius: 10px;
    padding: 10px 14px; font-size: 12px; color: #e2e8f0;
    max-width: 300px; opacity: 0; transition: opacity 0.2s;
    box-shadow: 0 8px 32px rgba(0,0,0,0.5); backdrop-filter: blur(8px);
  }
  .matrix-tooltip.visible { opacity: 1; }

  /* Option header interactive */
  .option-header { cursor: pointer; transition: background-color 0.2s; }
  .option-header:hover { background-color: #2a2a4a !important; }

  /* Recommendation box */
  .rec-box {
    margin-top: 16px; padding: 16px 20px; border-radius: 12px; position: relative; overflow: hidden;
    background: linear-gradient(135deg, #1a1a2e 0%, #1a2e1a 100%);
    border: 1px solid #4ade8025;
  }
  .rec-box::before {
    content: ''; position: absolute; top: -30px; right: -30px;
    width: 100px; height: 100px; border-radius: 50%;
    background: #4ade80; opacity: 0.03;
  }
</style>
```

### Full Table Container

```html
<div style="max-width: 960px; margin: 0 auto;">

  <!-- Score Summary Cards (above table) -->
  {score_summary_cards}

  <!-- Main Table -->
  <div style="overflow-x: auto; border-radius: 12px; border: 1px solid #2a2a4a; box-shadow: 0 4px 24px rgba(0,0,0,0.2);">
    <table class="matrix-table">
      <thead>
        <tr>
          <th style="text-align: left; color: #888; min-width: 180px; border-bottom: 2px solid #2a2a4a;">
            평가 기준
            <div style="font-size: 10px; font-weight: normal; color: #555; margin-top: 2px;">가중치 표시</div>
          </th>
          {option_headers}
        </tr>
      </thead>
      <tbody>
        {criteria_rows}
      </tbody>
      <tfoot>
        {score_row}
      </tfoot>
    </table>
  </div>

  <!-- Recommendation Box (optional) -->
  {recommendation_box}
</div>

<div class="matrix-tooltip"></div>
```

### Score Summary Cards (above table)

Cards are rendered one per option. The winner card uses a green-tinted gradient; non-winner cards use a neutral gradient. All cards show ranking.

```html
<div style="display: flex; gap: 12px; margin-bottom: 24px;">

  <!-- Winner card (recommended option) -->
  <div class="score-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #1a2e1a 100%); border: 1.5px solid #4ade8035;">
    <!-- Decorative bg circle -->
    <div class="card-bg" style="background: #4ade80;"></div>
    <!-- RECOMMENDED badge -->
    <div style="position: absolute; top: 8px; right: 10px; background: linear-gradient(135deg, #4ade80, #22c55e); color: #0f0f1a; font-size: 9px; font-weight: bold; padding: 3px 10px; border-radius: 5px; letter-spacing: 0.5px;">RECOMMENDED</div>
    <div style="font-size: 16px; font-weight: bold; color: #e2e8f0; margin-bottom: 2px;">{optionName}</div>
    <div style="font-size: 11px; color: #4ade80; opacity: 0.7;">종합 1위</div>
    <div class="score-bar-track">
      <div class="score-bar-fill" style="width: {scorePct}%; background: linear-gradient(90deg, #4ade80, #22c55e);"></div>
    </div>
    <div class="score-breakdown">
      <span class="score-tag" style="background: #4ade8015; color: #4ade80;">&#10003; {favorableCount}</span>
      <span class="score-tag" style="background: #facc1510; color: #facc15;">&#9651; {neutralCount}</span>
      <span class="score-tag" style="background: #ef444410; color: #ef4444;">&#10007; {unfavorableCount}</span>
    </div>
  </div>

  <!-- Non-winner card -->
  <div class="score-card" style="background: linear-gradient(135deg, #1a1a2e 0%, #1e1e38 100%); border: 1px solid #2a2a4a;">
    <div class="card-bg" style="background: #94a3b8;"></div>
    <div style="font-size: 16px; font-weight: bold; color: #e2e8f0; margin-bottom: 2px;">{optionName}</div>
    <div style="font-size: 11px; color: #888; opacity: 0.7;">종합 {rank}위</div>
    <div class="score-bar-track">
      <div class="score-bar-fill" style="width: {scorePct}%; background: linear-gradient(90deg, #94a3b8, #64748b);"></div>
    </div>
    <div class="score-breakdown">
      <span class="score-tag" style="background: #4ade8015; color: #4ade80;">&#10003; {favorableCount}</span>
      <span class="score-tag" style="background: #facc1510; color: #facc15;">&#9651; {neutralCount}</span>
      <span class="score-tag" style="background: #ef444410; color: #ef4444;">&#10007; {unfavorableCount}</span>
    </div>
  </div>

</div>
```

### Option Header: Default

```html
<th class="option-header" style="text-align: center; color: #e2e8f0; min-width: 150px; border-bottom: 2px solid #2a2a4a;"
    data-option="{optionId}">
  {option_name}
</th>
```

### Option Header: Frontrunner (highlighted)

```html
<th class="option-header winner-col" style="text-align: center; color: #4ade80; min-width: 150px; border-bottom: 2px solid #4ade80;"
    data-option="{optionId}">
  <div style="display: flex; flex-direction: column; align-items: center;">
    <span style="font-size: 15px; font-weight: bold;">{option_name}</span>
    <span style="font-size: 10px; opacity: 0.6; margin-top: 2px;">&#9733; 우세</span>
  </div>
</th>
```

### Criteria Row

```html
<tr style="animation-delay: {index * 0.04}s;">
  <td>
    <span class="criterion-name">{criterion_name}</span>
    {importance_indicator}
  </td>
  {rating_cells}
</tr>
```

### Importance Indicator (next to criterion name)

Use styled inline-block dot elements instead of Unicode dot characters. Unfilled positions use `#2a2a4a`. Each indicator includes a Korean weight label.

```html
<!-- High importance: 3 filled dots (red) -->
<span class="criterion-weight">
  <span class="weight-dot filled"></span><span class="weight-dot filled"></span><span class="weight-dot filled"></span>
  <span class="weight-label">높음</span>
</span>

<!-- Medium importance: 2 filled dots (yellow) + 1 empty -->
<span class="criterion-weight">
  <span class="weight-dot half"></span><span class="weight-dot half"></span><span class="weight-dot empty"></span>
  <span class="weight-label">중간</span>
</span>

<!-- Low importance: 1 filled dot (gray via half class) + 2 empty -->
<span class="criterion-weight">
  <span class="weight-dot half"></span><span class="weight-dot empty"></span><span class="weight-dot empty"></span>
  <span class="weight-label">낮음</span>
</span>
```

Inline-style equivalent (when classes are not available):

```html
<!-- High importance -->
<span style="margin-left: 6px;">
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #ef4444; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #ef4444; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #ef4444; margin-right: 1px;"></span>
  <span style="font-size: 9px; color: #666; margin-left: 4px;">높음</span>
</span>

<!-- Medium importance -->
<span style="margin-left: 6px;">
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #facc15; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #facc15; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #2a2a4a; margin-right: 1px;"></span>
  <span style="font-size: 9px; color: #666; margin-left: 4px;">중간</span>
</span>

<!-- Low importance -->
<span style="margin-left: 6px;">
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #facc15; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #2a2a4a; margin-right: 1px;"></span>
  <span style="display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #2a2a4a; margin-right: 1px;"></span>
  <span style="font-size: 9px; color: #666; margin-left: 4px;">낮음</span>
</span>
```

### Weight Cell (optional, if using a separate weight column)

```html
<td style="padding: 12px; text-align: center; font-size: 12px; color: #888888;">
  {weight}
</td>
```

### Rating Cell: Favorable

```html
<td class="rating-cell" title="{fullNote}">
  <div class="rating-box" style="background: #4ade8012; border: 1px solid #4ade8020;">
    <span class="rating-icon" style="color: #4ade80;">&#10003;</span>
    <span style="color: #4ade80;">{brief_note}</span>
  </div>
</td>
```

### Rating Cell: Neutral / Partial

```html
<td class="rating-cell" title="{fullNote}">
  <div class="rating-box" style="background: #facc150a; border: 1px solid #facc1515;">
    <span class="rating-icon" style="color: #facc15;">&#9651;</span>
    <span style="color: #facc15;">{brief_note}</span>
  </div>
</td>
```

### Rating Cell: Unfavorable

```html
<td class="rating-cell" title="{fullNote}">
  <div class="rating-box" style="background: #ef44440a; border: 1px solid #ef444418;">
    <span class="rating-icon" style="color: #ef4444;">&#10007;</span>
    <span style="color: #ef4444;">{brief_note}</span>
  </div>
</td>
```

### Rating Cell: Unknown / TBD

```html
<td class="rating-cell" title="아직 평가되지 않음">
  <div class="rating-box" style="background: #6b728010; border: 1px solid #6b728015;">
    <span class="rating-icon" style="color: #6b7280;">?</span>
    <span style="color: #6b7280;">TBD</span>
  </div>
</td>
```

### Score Row (table footer)

```html
<tr>
  <td style="font-weight: bold; color: #e2e8f0; font-size: 14px;">종합 점수</td>
  {score_cells}
</tr>
```

### Score Cell: Recommended

```html
<td class="winner-col">
  <div class="final-score">
    <div style="font-size: 13px; color: #4ade80; font-weight: bold;">
      <span style="background: #4ade8015; padding: 2px 6px; border-radius: 4px;">&#10003;{favorable}</span>
      <span style="background: #facc1510; padding: 2px 6px; border-radius: 4px; color: #facc15;">&#9651;{neutral}</span>
      <span style="background: #ef444410; padding: 2px 6px; border-radius: 4px; color: #ef4444;">&#10007;{unfavorable}</span>
    </div>
    <div class="final-bar">
      <div class="final-bar-fill" style="width: {scorePct}%; background: linear-gradient(90deg, #4ade80, #22c55e);"></div>
    </div>
    <div style="font-size: 11px; color: #4ade80; font-weight: bold;">&#9733; 추천</div>
  </div>
</td>
```

### Score Cell: Default

```html
<td>
  <div class="final-score">
    <div style="font-size: 13px; color: #94a3b8;">
      <span style="background: #4ade8010; padding: 2px 6px; border-radius: 4px; color: #4ade80;">&#10003;{favorable}</span>
      <span style="background: #facc1508; padding: 2px 6px; border-radius: 4px; color: #facc15;">&#9651;{neutral}</span>
      <span style="background: #ef444408; padding: 2px 6px; border-radius: 4px; color: #ef4444;">&#10007;{unfavorable}</span>
    </div>
    <div class="final-bar">
      <div class="final-bar-fill" style="width: {scorePct}%; background: linear-gradient(90deg, #94a3b8, #64748b);"></div>
    </div>
  </div>
</td>
```

### Recommendation Box (optional, below table)

Includes a strengths/weaknesses grid below the rationale text.

```html
<div class="rec-box">
  <!-- Decorative circle handled by .rec-box::before in CSS -->
  <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
    <span style="display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border-radius: 8px; background: #4ade8018; font-size: 14px; color: #4ade80;">&#9733;</span>
    <span style="font-size: 16px; font-weight: bold; color: #e2e8f0;">추천: {recommendedOption}</span>
  </div>
  <div style="font-size: 12px; color: #94a3b8; line-height: 1.6; padding-left: 38px;">{rationale}</div>

  <!-- Strengths / Weaknesses grid -->
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 14px; padding-left: 38px;">
    <div style="padding: 8px 12px; background: #4ade8008; border-radius: 8px; border: 1px solid #4ade8015;">
      <div style="font-size: 10px; color: #4ade80; font-weight: bold; margin-bottom: 2px;">강점</div>
      <div style="font-size: 11px; color: #888;">{strengths}</div>
    </div>
    <div style="padding: 8px 12px; background: #facc1508; border-radius: 8px; border: 1px solid #facc1515;">
      <div style="font-size: 10px; color: #facc15; font-weight: bold; margin-bottom: 2px;">고려사항</div>
      <div style="font-size: 11px; color: #888;">{considerations}</div>
    </div>
  </div>
</div>
```

Inline-style equivalent (when `.rec-box` class is not available):

```html
<div style="margin-top: 16px; padding: 16px 20px; border-radius: 12px; position: relative; overflow: hidden; background: linear-gradient(135deg, #1a1a2e 0%, #1a2e1a 100%); border: 1px solid #4ade8025;">
  <!-- Decorative circle -->
  <div style="position: absolute; top: -30px; right: -30px; width: 100px; height: 100px; border-radius: 50%; background: #4ade80; opacity: 0.03;"></div>

  <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
    <span style="display: inline-flex; align-items: center; justify-content: center; width: 28px; height: 28px; border-radius: 8px; background: #4ade8018; font-size: 14px; color: #4ade80;">&#9733;</span>
    <span style="font-size: 16px; font-weight: bold; color: #e2e8f0;">추천: {recommendedOption}</span>
  </div>
  <div style="font-size: 12px; color: #94a3b8; line-height: 1.6; padding-left: 38px;">{rationale}</div>

  <!-- Strengths / Weaknesses grid -->
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 14px; padding-left: 38px;">
    <div style="padding: 8px 12px; background: #4ade8008; border-radius: 8px; border: 1px solid #4ade8015;">
      <div style="font-size: 10px; color: #4ade80; font-weight: bold; margin-bottom: 2px;">강점</div>
      <div style="font-size: 11px; color: #888;">{strengths}</div>
    </div>
    <div style="padding: 8px 12px; background: #facc1508; border-radius: 8px; border: 1px solid #facc1515;">
      <div style="font-size: 10px; color: #facc15; font-weight: bold; margin-bottom: 2px;">고려사항</div>
      <div style="font-size: 11px; color: #888;">{considerations}</div>
    </div>
  </div>
</div>
```

### Tooltip Handler (JavaScript)

```javascript
const tooltip = document.querySelector('.matrix-tooltip');
document.querySelectorAll('.rating-cell[title]').forEach(cell => {
  cell.addEventListener('mouseenter', e => {
    tooltip.textContent = cell.getAttribute('title');
    tooltip.classList.add('visible');
  });
  cell.addEventListener('mousemove', e => {
    tooltip.style.left = (e.clientX + 14) + 'px';
    tooltip.style.top = (e.clientY + 14) + 'px';
  });
  cell.addEventListener('mouseleave', () => tooltip.classList.remove('visible'));
});
```

### Column Highlight on Header Hover (JavaScript)

Hovering an option header highlights the entire column in the table body.

```javascript
document.querySelectorAll('.option-header').forEach(header => {
  const idx = Array.from(header.parentElement.children).indexOf(header);
  header.addEventListener('mouseenter', () => {
    document.querySelectorAll('.matrix-table tbody tr').forEach(row => {
      const cell = row.children[idx];
      if (cell) cell.style.backgroundColor = '#2a2a4a18';
    });
  });
  header.addEventListener('mouseleave', () => {
    document.querySelectorAll('.matrix-table tbody tr').forEach(row => {
      const cell = row.children[idx];
      if (cell) cell.style.backgroundColor = '';
    });
  });
});
```

## Rules

### Table layout rules
- Container uses `max-width: 960px` with `margin: 0 auto`.
- Table wraps in a container with `overflow-x: auto`, `border-radius: 12px`, and `box-shadow: 0 4px 24px rgba(0,0,0,0.2)`.
- Table uses `border-collapse: separate; border-spacing: 0` (not `collapse`) so that container `border-radius` renders correctly.
- Table background `#1a1a2e`, header/footer rows `#1e1e36`.
- Row separators: `#2a2a4a` at low opacity (`#2a2a4a18`) for subtle separation.
- Rows fade in with staggered delay (0.04s per row).

### Score summary cards rules
- Always show summary cards above the table -- one per option.
- Winner card uses gradient background tinted green (`linear-gradient(135deg, #1a1a2e, #1a2e1a)`), a RECOMMENDED badge with gradient fill (`linear-gradient(135deg, #4ade80, #22c55e)`), and a 1.5px green border. Non-winner cards use neutral gradient (`#1a1a2e` to `#1e1e38`) with standard border.
- All cards show ranking text ("종합 N위"). Winner shows green text; others show gray.
- Each card: option name + score bar (8px height, gradient fill) + pill-style rating count tags with tinted backgrounds.
- Score bars animate with `0.8s cubic-bezier(0.4,0,0.2,1)` transition.
- Cards have hover effect: `translateY(-2px)` with `box-shadow: 0 6px 20px rgba(0,0,0,0.3)`.
- Decorative background circle (90x90px, 5% opacity) positioned at top-right of each card.

### Option header rules
- Default headers: bold, centered, `#e2e8f0`, min-width 150px.
- Frontrunner header: green `#4ade80` text + green bottom border + "&#9733; 우세" sub-label at reduced opacity.
- Headers use `cursor: pointer` and highlight on hover (`#2a2a4a`).

### Criteria row rules
- Criterion name on left, left-aligned, with importance indicator dots.
- Use styled inline-block dots (6x6px, `border-radius: 50%`) instead of Unicode dot characters. Unfilled positions use `#2a2a4a` background. Each indicator includes a Korean weight label.
- High importance: 3 red filled dots + "높음" label.
- Medium importance: 2 yellow filled dots + 1 empty dot + "중간" label.
- Low importance: 1 yellow filled dot + 2 empty dots + "낮음" label.
- Row hover highlights entire row with `background-color: #1e1e3680`.

### Weight column rules (optional)
- If criteria have different weights, include the weight column as second column.
- Display as number (e.g., "3x", "2x", "1x") or percentage.

### Rating cell rules
- Each rating wrapped in a rounded box (`border-radius: 8px`, padding `6px 14px`).
- Rating boxes have explicit borders (1px solid at low opacity) in addition to background tints. This provides better visual definition.
- Favorable: green bg `#4ade8012`, border `#4ade8020`, green text, &#10003; icon.
- Neutral: yellow bg `#facc150a`, border `#facc1515`, yellow text, &#9651; icon.
- Unfavorable: red bg `#ef44440a`, border `#ef444418`, red text, &#10007; icon.
- Unknown: gray bg `#6b728010`, border `#6b728015`, gray text, `?` icon.
- If note exceeds 3 words, truncate and put full text in `title` attribute (shown in tooltip).
- Hover effect: `filter: brightness(1.15); transform: scale(1.04)`.

### Winner column highlight rules
- Winner column cells use `.winner-col` class with a `::after` pseudo-element providing a subtle gradient overlay (`linear-gradient(180deg, #4ade8005, #4ade8002)`).
- This replaces the previous border-based approach for a more subtle effect.

### Score calculation rules
- Base score: favorable = +1, neutral = 0, unfavorable = -1, unknown = 0.
- If weights exist: multiply each rating by criterion weight.
- Score percentage = `(totalScore + maxScore) / (2 * maxScore) * 100` (normalized 0-100%).
- The option with the highest score is the recommended option.

### Score row footer rules
- Score counts displayed as pill-style tags with tinted backgrounds (matching the score card style).
- Recommended cell: green-tinted tag backgrounds, gradient score bar (`#4ade80` to `#22c55e`), "&#9733; 추천" label below.
- Default cells: lower-opacity tag backgrounds, gray gradient score bar (`#94a3b8` to `#64748b`).
- Score bar height 6px in footer row.

### Recommendation box rules
- If one option clearly leads (2+ more favorable ratings), show recommendation box below table.
- If options are close (within 1 favorable difference), show the box but note "근소한 차이" in rationale.
- If all options are equally rated, omit the recommendation box.
- Recommendation box uses gradient background (`linear-gradient(135deg, #1a1a2e, #1a2e1a)`) with decorative circle and green-tinted border.
- Star icon in a rounded square badge (28x28px, `border-radius: 8px`, green-tinted bg).
- Recommendation box includes strengths/weaknesses grid (2-column `grid`) below the rationale text. Strengths in green-tinted box (`#4ade8008` bg, `#4ade8015` border), considerations in yellow-tinted box (`#facc1508` bg, `#facc1515` border).

### Column highlight rules
- Hovering an option header highlights the entire column in the table body via JavaScript.
- Column highlight uses `backgroundColor: '#2a2a4a18'` on each body cell in that column index.
- On mouseleave, the background is cleared by setting it to empty string.

### Tooltip rules
- Cells with truncated text show full text in tooltip on hover.
- Tooltip follows cursor, max-width 300px.
- Tooltip uses glassmorphism: semi-transparent background (`#1a1a2eee`), `backdrop-filter: blur(8px)`, `border-radius: 10px`, heavy shadow (`0 8px 32px rgba(0,0,0,0.5)`).

## Known Issues & Optimization Notes

_This section is updated as the skill is used._

- With 5+ options, horizontal scrolling becomes necessary. The `overflow-x: auto` wrapper handles this, but consider rotating the matrix (options as rows, criteria as columns) when there are more options than criteria.
- Score summary cards above the table provide immediate visual comparison -- users look there first before diving into individual cells.
- Importance indicators (dot system) help users quickly identify which criteria matter most, which is critical for interpreting the overall recommendation.
- The rounded pill style for rating cells provides better visual density than flat colored backgrounds, especially when most cells are the same color.
- The RECOMMENDED badge with gradient fill (not flat) looks significantly more polished than a flat green badge.
- Rating cell borders provide essential visual definition -- without them, cells with similar background tints are hard to distinguish.
- Strengths/weaknesses grid in the recommendation box helps users understand the tradeoffs at a glance.
- Using `border-collapse: separate` instead of `collapse` is required for `border-radius` to render on the table container. Always pair with `border-spacing: 0`.
