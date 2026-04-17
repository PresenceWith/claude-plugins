# Visualization Index & Shared Rendering

When producing a visualization, use this file to select the type and find the detailed
rendering guide. Each visualization type has its own file in the `visualizations/` directory
with specific rendering instructions and accumulated optimization notes.

## Selecting the Right Visualization

| Type | When to use | Rendering guide |
|------|-------------|-----------------|
| Mindmap | Brainstorming, exploring ideas, divergent thinking | `visualizations/mindmap.md` |
| Status Dashboard | Checkpoints, "where are we?", progress review | `visualizations/dashboard.md` |
| Concept Map | Relationships, dependencies, architecture | `visualizations/conceptmap.md` |
| Flowchart | Process design, sequential steps, conditions | `visualizations/flowchart.md` |
| Timeline | Scheduling, milestones, phased planning | `visualizations/timeline.md` |
| Comparison Matrix | Option evaluation, tradeoffs | `visualizations/comparison-matrix.md` |
| Priority Matrix | Importance/urgency, what to do first | `visualizations/priority-matrix.md` |
| Hierarchy | Classification, component structure | `visualizations/hierarchy.md` |
| State Machine | State transitions, lifecycles | `visualizations/state-machine.md` |
| Venn Diagram | Overlaps, boundaries, scope | `visualizations/venn.md` |

**How to use:** Select the type, then read the corresponding file in `visualizations/`
for detailed rendering instructions. Only read the file you need — don't load all of them.
Each file has a "Known Issues & Optimization Notes" section that accumulates rendering
lessons learned over time.

## Shared Rendering Rules

These apply to ALL visualization types. Individual type guides inherit these.
For consistent colors across all visualizations, read `color-palette.md` in this skill directory.

### Environment Detection

```
1. Are mcp__claude-in-chrome__* tools available?
   → Yes: Use Chrome MCP. Navigate to a new tab or reuse existing.
   → No: Continue to 2.

2. Is a live-reload server already running?
   → Yes: Write HTML to the watched directory.
   → No: Generate HTML file, open with: open <filepath>
```

### Viewport & Sizing

Visualizations must display fully without clipping or horizontal scrolling.

- **SVG-based** (mindmap, concept map, flowchart, hierarchy, state machine, venn, timeline):
  Calculate the SVG `viewBox` from actual content bounds. Add 40px padding. Set `width="100%"`
  and `preserveAspectRatio="xMidYMid meet"`. Never hardcode width > 960px.
- **HTML-based** (dashboard, matrix): Use `max-width: 960px` with `margin: 0 auto`.
- **Always** wrap in a container with `overflow-x: auto` as a safety net.

### Shared HTML Template

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Planning Compass — {Type}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      background: #0f0f1a;
      color: #e2e8f0;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      padding: 32px;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    h1 { font-size: 20px; margin-bottom: 4px; text-align: center; }
    .subtitle { color: #888; font-size: 13px; margin-bottom: 28px; text-align: center; }
    .container { overflow-x: auto; width: 100%; max-width: 1100px; }
    svg { width: 100%; height: auto; }
    .meta { color: #666; font-size: 11px; margin-top: 20px; text-align: right; width: 100%; max-width: 1100px; }

    /* Legend — use this pattern for all visualizations */
    .legend {
      display: flex;
      gap: 24px;
      margin-top: 24px;
      padding: 12px 20px;
      background: #1a1a2e;
      border-radius: 10px;
      border: 1px solid #2a2a4a;
      flex-wrap: wrap;
      justify-content: center;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: 7px;
      font-size: 12px;
      color: #a0a0b0;
      white-space: nowrap;
    }
    .legend-dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      display: inline-block;
      flex-shrink: 0;
    }

    /* Status colors */
    .decided { color: #4ade80; }
    .active { color: #facc15; }
    .undecided { color: #888; }

    /* Common components */
    .card {
      background: #1a1a2e;
      border-radius: 10px;
      padding: 16px;
      margin: 8px 0;
      border: 1px solid #2a2a4a;
    }
    .tag {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 10px;
      font-size: 10px;
      font-weight: bold;
    }

    /* Shared tooltip — glassmorphism style.
       Individual guides may use their own class name (.venn-tooltip, etc.)
       but must follow this base pattern */
    .compass-tooltip {
      position: fixed;
      pointer-events: none;
      z-index: 100;
      background: #1a1a2eee;
      border: 1px solid #4a4a7a;
      border-radius: 10px;
      padding: 10px 14px;
      font-size: 12px;
      color: #e2e8f0;
      max-width: 280px;
      opacity: 0;
      transition: opacity 0.2s;
      box-shadow: 0 8px 32px rgba(0,0,0,0.5);
      backdrop-filter: blur(8px);
    }
    .compass-tooltip.visible { opacity: 1; }
  </style>
</head>
<body>
  <h1>Planning Compass — {Type}</h1>
  <p class="subtitle">{Description}</p>

  <!-- Visualization content -->

  <div class="meta">
    Last updated: {timestamp} · Planning Compass
  </div>
</body>
</html>
```

### Shared Glow Filter Pattern (SVG)

All SVG-based visualizations use this filter structure for glow effects.
Replace `{color}` and `{opacity}` per use case.

```svg
<filter id="glow-{name}" x="-30%" y="-30%" width="160%" height="160%">
  <feGaussianBlur in="SourceAlpha" stdDeviation="{blur}" result="blur"/>
  <feFlood flood-color="{color}" flood-opacity="{opacity}" result="color"/>
  <feComposite in="color" in2="blur" operator="in" result="shadow"/>
  <feMerge>
    <feMergeNode in="shadow"/>
    <feMergeNode in="SourceGraphic"/>
  </feMerge>
</filter>
```

Typical values:
- Core node glow: `stdDeviation="5-6"`, `flood-opacity="0.3"`
- Active node glow: `stdDeviation="6-8"`, `flood-opacity="0.35"`
- Subtle glow: `stdDeviation="4"`, `flood-opacity="0.2"`
- Circle/region glow: `stdDeviation="8"`, `flood-opacity="0.15"`

Additionally, use `feDropShadow` for card/node depth:
```svg
<filter id="card-shadow">
  <feDropShadow dx="0" dy="2" stdDeviation="4" flood-color="#000" flood-opacity="0.25"/>
</filter>
```

### CJK Text Sizing (SVG)

SVG `<text>` has no auto-layout. Estimate node width before rendering:

```
function nodeWidth(label, fontSize):
    // Count wide characters (Korean, CJK ideographs)
    wideChars = count chars in U+AC00..U+D7AF, U+3130..U+318F, U+1100..U+11FF, CJK Unified
    latinChars = len(label) - wideChars

    textWidth = (wideChars * fontSize * 0.58) + (latinChars * fontSize * 0.34)
    return textWidth + paddingX
```

Padding varies by visualization type:
- Mindmap nodes: +36px (18px each side)
- Concept map / hierarchy: +32px (16px each side)
- Flowchart process nodes: +40px (20px each side), minimum 140px
- State machine states: +40px (20px each side), minimum 120px
- Venn items: +24px (12px each side)

### Shared Interaction Patterns

All visualization types share these interaction principles:

1. **Hover highlight**: On node hover, connected elements brighten and unconnected elements dim (opacity 0.3 or 0.15). Implemented via JavaScript class toggles (`.highlighted`, `.dimmed`).
2. **Tooltip**: Follow cursor at `+14px` offset. Show on `mouseenter`, update on `mousemove`, hide on `mouseleave`. Max-width 280px.
3. **Fade-in animation**: Staggered entry via `animation-delay`. Keep total animation under 1s.
4. **Scale on hover**: `transform: scale(1.04-1.08)` with `transition: 0.2s ease`.

### Visual Quality Rules (Cross-Cutting)

These rules apply to all SVG-based visualizations. They are the result of iterative visual
testing and capture patterns that dramatically improve readability on dark backgrounds.

**1. Label Background Pills (Critical)**
All text labels on edges, transitions, branches, and annotations must have a background pill
(`<rect>` behind `<text>`). Without pills, labels on dark backgrounds become invisible.
- Pill fill: `#0f0f1a` (matches body background)
- Pill stroke: edge/context color at 20-30% opacity
- Pill shape: `rx="9"` for rounded pill, `rx="8"` for badge style
- Font minimum: 9px for labels, 8px for guard conditions
- Example: `<rect x="{x}" y="{y}" width="{w}" height="18" rx="9" fill="#0f0f1a" stroke="{color}30" stroke-width="0.5"/>`

**2. Node Color Accent Bars**
Add a 4px left accent bar on rectangular nodes. This creates instant visual
hierarchy and domain identification, and is consistent across all visualization types.
- Width: 4px, full node height, `rx="2"`
- Fill: node's domain/status color at full opacity
- Position: left edge of node rect (same x, same y, same height)
- Applied to: mindmap branch nodes, dashboard cards, priority pills, process nodes

**3. Gradient Fills**
Use gradients aggressively — they are the primary tool for visual depth on dark backgrounds.
- **Region/lane backgrounds**: `linearGradient` at 135deg, from `{color}0a` to `{color}18`
- **Radial gradients for circles**: Center at 22% opacity, edge at 4%. Use `cx="40%" cy="45%"` for subtle top-left lighting
- **Progress bars**: Linear gradient between two shades (e.g., `#4ade80` to `#22c55e`)
- **Score bars**: Same gradient pattern as progress bars
- **Stat cards**: `linear-gradient(135deg, #1a1a2e, {tintedEndpoint})`
- Flat fills below 10% are invisible; gradients create visible depth even at low opacity

**4. Edge Opacity Minimums**
- Primary edges (workflow, main transitions): opacity ≥ 0.7
- Secondary edges (dependencies, error paths): opacity ≥ 0.5
- Tertiary edges (optional, communication): opacity ≥ 0.45
- Below these thresholds, edges become invisible on `#0f0f1a` background

**5. Connector/Line Opacity Minimums**
- Primary connectors (L0→L1): color at 50-80% opacity, stroke-width ≥ 2
- Secondary connectors (L1→L2): color at 40-50% opacity, stroke-width ≥ 1.5
- Tertiary connectors (L2→L3): color at 30-35% opacity, stroke-width ≥ 1

**6. Status Badge Circles**
Use filled circles with border rings for emphasis:
- Decided/active dots: `fill="{color}" stroke="{color}40" stroke-width="2"` (r=4-5)
- Undecided dots: `fill="#6b7280"` without ring
- Dots with `box-shadow: 0 0 6px {color}60` for decided/active states (CSS) or glow filter (SVG)
- This ring+glow pattern makes status instantly scannable

**7. Animated Active Indicators**
Active/current elements should have a pulsing animation:
```svg
<circle cx="{x}" cy="{y}" r="5" fill="#facc15">
  <animate attributeName="opacity" values="1;0.3;1" dur="2s" repeatCount="indefinite"/>
</circle>
```

### Render-Validate Loop

After rendering a visualization, optionally verify the output with a single screenshot:

1. Render HTML via the environment method (Chrome MCP / `open`)
2. If Chrome MCP is available, capture **one** screenshot to spot-check for:
   - Text clipping or overflow
   - Invisible or barely visible connector lines
   - Node overlap or crowding
3. If a **concrete defect** is visible in the screenshot, fix it and re-render once.
   Do not iterate further — the rendering guides and CJK sizing rules are designed
   to produce correct output on the first pass. A second screenshot after fixing is
   sufficient; do not keep looking for more issues.
4. If Chrome MCP is unavailable, skip this step entirely. The guides are reliable
   enough without visual validation.

### File Location

Save HTML files to `.compass/views/` in the project root. Use semantic filenames:
`mindmap.html`, `dashboard.html`, `concept-map.html`.

## Adding New Visualization Types

When creating a new visualization type, add a file in `visualizations/` following this structure:

```markdown
# {Type} Rendering Guide

**When to use:** ...
**Data source:** ...
**Structure:** ...

## Templates
SVG/HTML code blocks with `{placeholder}` variables.
Include: container & defs, node types, edge types, legend, tooltip handler JS.

## Rules
Conditional rules: "if X then Y" format. Include spacing, sizing, styling, interaction rules.

## Layout Algorithm (if SVG-based)
Include coordinate calculation formulas when the visualization requires manual
positioning (i.e., not handled by CSS auto-layout). Determine need by asking:
- Does this type use SVG with absolute x/y positioning? → formulas needed
- Does this type use CSS grid/flexbox for layout? → formulas not needed

## Known Issues & Optimization Notes
_Start empty. Accumulate rendering lessons as the skill is used._
```

After creating the file, add it to the selection table above and to SKILL.md's
Quick Reference table.

## User Override

If the user requests a specific visualization type ("show me a flowchart"), use that type
regardless of what the diagnostic engine would have selected. Announce what you're showing:
"Here's a [type] view of [what it covers]."

If the user says "different view" or "try another format", switch to the next most appropriate
type from the catalog.
