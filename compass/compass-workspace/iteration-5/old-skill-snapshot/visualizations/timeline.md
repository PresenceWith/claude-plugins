# Timeline Rendering Guide

**When to use:** Scheduling, milestones, phased planning. The conversation involves
"when?", "roadmap", phases, or sequencing over time.

**Data source:** Elements with temporal ordering from `precedes` relations in the state file.
Decided items provide anchor dates; undecided items show as tentative.

**Structure:** Horizontal time axis with milestone nodes. Dependencies shown as arrows.

## Layout

Use SVG with a horizontal timeline as the spine.

- **Timeline spine:** Horizontal line at vertical center, full width
- **Phase segments:** Background rectangles spanning each phase, with phase labels above
- **Milestone nodes:** Circles or rounded rects positioned along the spine
- **Dependency arrows:** Curved lines between milestones showing order constraints

## Phase Segments

Divide the timeline into phases with alternating background fills for visual separation:
```
Phase 1 (#1a1a2e)  |  Phase 2 (#1e1e36)  |  Phase 3 (#1a1a2e)
```

Each phase gets:
- A label at the top (phase name, e.g., "MVP", "Beta", "Launch")
- An estimated duration below the label (e.g., "8-12주")
- A subtle vertical separator line at phase boundaries

## Milestone Styling

- Decided milestones: solid circle with green fill, milestone name below
- Undecided/tentative: dashed circle outline, muted color
- Current/active: pulsing animation, highlighted
- Each milestone shows its name and optionally a 1-line description

## Dependencies

- Show with curved arrows between milestone nodes
- Critical path: thicker line (2.5px), distinct color (yellow or red)
- Optional dependencies: thinner dashed lines

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
