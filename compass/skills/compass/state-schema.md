# Working State Schema

## Purpose

The working state file (`.compass/state.md`) is **session-scoped working memory** — a snapshot
of the current session's planning context used for visualization and diagnostics. It is freely
overwritten by any session and does not need protection. Durable planning decisions are stored
separately in plan files (see `plan-schema.md`).

## File Location

`.compass/state.md` in the project root. Single file, always represents the current session.

## Schema

```markdown
# Working State

## Session
- Plan: {goal-slug} or "none"
- Started: {YYYY-MM-DD HH:MM}
- Last sync: {YYYY-MM-DD HH:MM}
- Turns since last sync: N

## Goal
{The current planning goal — mirrors the linked plan's goal, or the session's topic if no plan.}

## Elements
- ElementName [type: architecture|feature|data|concept|constraint|...]
- AnotherElement [type: ...]

## Relations
- ElementA →depends-on→ ElementB
- ElementC →contains→ ElementD

## Decided (this session only)
- [Topic]: [Decision] (Reason)
<!-- Prior decisions from the plan file are NOT duplicated here.
     They remain in the plan file and are accessed directly when needed. -->

## Undecided
- [Topic]: [Option1 | Option2 | ...] (Related elements: X, Y)

## Active Discussion
- [Current topic being discussed]
```

## Relationship to Plan Files

The working state and plan files serve different roles:

| | Working State (`state.md`) | Plan File (`plans/{slug}.md`) |
|---|---|---|
| **Scope** | Current session | Across all sessions |
| **Lifetime** | Overwritten freely | Preserved until topic concludes |
| **Contains** | Everything — decided, undecided, active | Only confirmed: decided, deferred, elements, relations |
| **Written by** | Any session, any time | Promotion during sync |
| **Used for** | Visualization input, diagnostic input | Cross-session continuity, planning artifact |

## Abstraction Logic

### Identifying Elements

An **element** is a named concept that plays a role in the plan being discussed.

- **Strong signal**: The user gives something a name. "The auth system", "the dashboard component",
  "our pricing model" — these are elements.
- **Medium signal**: Something is mentioned repeatedly across multiple turns. Repetition implies importance.
- **Weak signal**: Something is mentioned once in passing. Don't add unless it connects to other elements.

**Typing elements**: Use whatever type label is most natural. Common types: `architecture`, `feature`,
`data`, `concept`, `constraint`, `decision`, `component`, `process`, `requirement`.

**Core vs detail**: An element is "core" if removing it would change the goal. Everything else is detail.

### Identifying Relations

A **relation** is a named connection between two elements.

- "A needs B" / "A depends on B" → `A →depends-on→ B`
- "A includes B" / "A has B" → `A →contains→ B`
- "A comes before B" → `A →precedes→ B`
- "A talks to B" → `A →communicates-with→ B`
- "A replaces B" → `A →alternative-to→ B`

### Abstraction Levels

- **Level 0 (overview)**: 3-5 core elements and primary relations. Default for visualization.
- **Level 1 (expanded)**: All elements and relations.
- **Level 2 (focused)**: One element and everything connected to it.

### Deciding What's Decided

Something is "decided" when:
- The user explicitly chose it ("let's go with X")
- The user approved a recommendation ("yes, that sounds right")
- A choice was made implicitly by building on an assumption without objection

Something is "undecided" when:
- Multiple options were presented but none was chosen
- The user said "I'll think about it" or "let's come back to this"
- A question was raised but not answered

### Update Rules

- Add new elements/relations as they emerge in conversation
- Move items from Undecided to Decided when decisions are made
- Keep Active Discussion current
- Update sync timestamp and turn count on every write
- **On sync, also run the promotion flow** (see `plan-schema.md`) to push confirmed items to the plan file
