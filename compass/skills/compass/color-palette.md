# Color Palette

Shared color definitions for all visualization types. Individual guides reference
these by semantic name rather than hardcoding hex values.

## Status Colors

Colors indicating decision state. Used across all visualization types.

| Semantic name | Hex | Opacity variants | Usage |
|---------------|-----|-----------------|-------|
| `status-decided` | `#4ade80` | `#4ade8020` (bg) | Decided items, completed milestones, favorable cells |
| `status-active` | `#facc15` | `#facc1520` (bg) | Active discussion, current step, decision diamonds |
| `status-undecided` | `#6b7280` | — | Pending items, dashed borders, muted elements |
| `status-error` | `#ef4444` | `#ef444420` (bg) | Unfavorable cells, error states, critical path |

## Domain Colors

For distinguishing categories, branches, or element groups. Use in order; wrap around if > 8.

| Index | Hex | Name | SVG region fill (10% opacity) | Stroke (30% opacity) |
|:-----:|-----|------|-------------------------------|----------------------|
| 1 | `#6366f1` | Indigo | `#6366f110` | `#6366f130` |
| 2 | `#3b82f6` | Blue | `#3b82f610` | `#3b82f630` |
| 3 | `#06b6d4` | Cyan | `#06b6d410` | `#06b6d430` |
| 4 | `#10b981` | Emerald | `#10b98110` | `#10b98130` |
| 5 | `#f59e0b` | Amber | `#f59e0b10` | `#f59e0b30` |
| 6 | `#ef4444` | Red | `#ef444410` | `#ef444430` |
| 7 | `#8b5cf6` | Violet | `#8b5cf610` | `#8b5cf630` |
| 8 | `#ec4899` | Pink | `#ec489910` | `#ec489930` |

**Connector lines by category:** Use the domain color at 50-70% opacity
(e.g., `#6366f1aa`). Never use near-background grays like `#2a2a4a` for lines
that must be visible.

## Relationship Colors

For distinguishing edge/connection types in SVG diagrams.

| Relationship | Stroke style | Color | Width |
|-------------|-------------|-------|:-----:|
| Workflow / sequence | solid | `#facc15` | 2px |
| Dependency | dashed (`6,3`) | `#ef4444` | 1.5px |
| Optional / deferred | dotted (`2,4`) | `#6b7280` | 1px |
| Cross-branch link | dashed (`4,4`) | `#94a3b8` at 50% | 1px |
| Structural connector | solid | `#4a4a7a` | 1.5px |

## Surface Colors

Background, card, and chrome colors for the dark theme.

| Semantic name | Hex | Usage |
|---------------|-----|-------|
| `bg-body` | `#0f0f1a` | Page background |
| `bg-card` | `#1a1a2e` | Card, node fill, state fill |
| `bg-card-alt` | `#1e1e36` | Alternating section (timeline phases) |
| `border-subtle` | `#2a2a4a` | Card borders, inactive separators |
| `text-primary` | `#e2e8f0` | Primary text |
| `text-muted` | `#888888` | Subtitles, secondary text |
| `text-dim` | `#666666` | Meta info, timestamps |

## Emphasis

| Effect | CSS/SVG |
|--------|---------|
| Glow (decided) | SVG `feGaussianBlur stdDeviation="5" flood-color="#4ade80" flood-opacity="0.3"` |
| Glow (active) | SVG `feGaussianBlur stdDeviation="6" flood-color="#facc15" flood-opacity="0.35"` |
| Glow (core node) | SVG `feGaussianBlur stdDeviation="5-6" flood-color="{domain}" flood-opacity="0.3"` |
| Glow (circle/region) | SVG `feGaussianBlur stdDeviation="8" flood-color="{color}" flood-opacity="0.15"` |
| Card shadow | SVG `feDropShadow dx="0" dy="2" stdDeviation="4" flood-opacity="0.25"` |
| Status dot glow | CSS `box-shadow: 0 0 6px {color}60` (for decided/active dots) |
| Hover scale | `transform: scale(1.05)` with `transition: 0.2s` |
| Pulse animation | `@keyframes pulse { 0%,100% { opacity:1 } 50% { opacity:0.5 } }` |
| NEW badge | `background: linear-gradient(135deg, #4ade80, #22c55e); color: #0f0f1a; font-size: 9px; padding: 2px 8px; border-radius: 4px;` |
| RECOMMENDED badge | `background: linear-gradient(135deg, #4ade80, #22c55e); font-size: 9px; padding: 3px 10px; border-radius: 5px; letter-spacing: 0.5px;` |

## Gradient Patterns

Common gradient patterns used across visualizations.

| Pattern | CSS/SVG | Usage |
|---------|---------|-------|
| Card/stat background | `linear-gradient(135deg, #1a1a2e, {tintedEnd})` | Stat cards, recommendation boxes |
| Region/quadrant fill | `linear-gradient(135deg, {color}0a, {color}18)` | Priority quadrants, lane fills |
| Progress/score bar | `linear-gradient(90deg, {color1}, {color2})` | Progress segments, score bars |
| Radial circle fill | `radialGradient cx="40%" cy="45%": 0%→22%, 60%→12%, 100%→4%` | Venn circles, background zones |
| Overlap highlight | `radialGradient: 0%→18%, 100%→6%` | Venn intersection zones |
| Axis lines | `linear-gradient(to bottom, transparent, {color}, transparent)` | Cross axes on matrix |
| Central node | `radialGradient cx="50%" cy="40%": #3a2a6a → #1a1a2e` | Mindmap central node |

## Glassmorphism Tooltip

All tooltips use this consistent style:

```css
background: #1a1a2eee;
border: 1px solid #4a4a7a;
border-radius: 10px;
padding: 10px 14px;
box-shadow: 0 8px 32px rgba(0,0,0,0.5);
backdrop-filter: blur(8px);
```
