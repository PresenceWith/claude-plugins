# State Machine Rendering Guide

**When to use:** Lifecycle, status transitions, event-driven flows. The conversation involves
state changes, user journeys, or "what happens when X triggers?"

**Data source:** Elements representing states, with relations showing transitions
(events/actions that cause state changes).

**Structure:** State circles connected by labeled transition arrows.

## Layout

Use SVG. Position states in a logical flow — typically left-to-right or following
the natural lifecycle order.

- **Initial state:** Small filled circle (●) with arrow to first state
- **States:** Rounded rectangles or large circles with state name inside
- **Final state:** Double circle (◉) or a state marked with "End"
- **Transitions:** Curved arrows between states, labeled with the trigger event

## State Styling

- Current/active state: highlighted border + glow filter + pulsing animation
- Normal states: solid border, dark fill (`#1a1a2e`)
- Terminal/end states: double border or distinctive icon
- Error states: red-tinted border

Each state shows:
- State name (bold, centered)
- Optional: brief description of what's true in this state (small, muted)

## Transition Arrows

- Labeled with the event/trigger that causes the transition (e.g., "사용자 승인", "결제 완료")
- Use curved paths to avoid overlapping with other transitions
- Self-transitions (state → same state): loop arrow above or beside the state
- Arrow labels: small text (`10-11px`), positioned at the midpoint of the curve
- Distinguish primary path (thicker, brighter) from error/edge paths (thinner, dashed)

## Guard Conditions

If a transition has conditions, show them in brackets on the label:
`결제 완료 [금액 > 0]`

## Known Issues & Optimization Notes

_This section is updated as the skill is used._
