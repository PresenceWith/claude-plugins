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

- **SVG-based** (concept map, flowchart, state machine): Calculate the SVG `viewBox`
  from actual content bounds. Add 40px padding. Set `width="100%"` and
  `preserveAspectRatio="xMidYMid meet"`. Never hardcode width > 960px.
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
      padding: 24px;
      min-height: 100vh;
    }
    h1 { font-size: 20px; margin-bottom: 4px; }
    .subtitle { color: #888; font-size: 13px; margin-bottom: 24px; }
    .meta { color: #666; font-size: 11px; margin-top: 24px; text-align: right; }

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

### File Location

Save HTML files to `.compass/views/` in the project root. Use semantic filenames:
`mindmap.html`, `dashboard.html`, `concept-map.html`.

## User Override

If the user requests a specific visualization type ("show me a flowchart"), use that type
regardless of what the diagnostic engine would have selected. Announce what you're showing:
"Here's a [type] view of [what it covers]."

If the user says "different view" or "try another format", switch to the next most appropriate
type from the catalog.
