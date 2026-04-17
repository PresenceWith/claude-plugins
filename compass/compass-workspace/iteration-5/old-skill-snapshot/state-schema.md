# State File Schema & Abstraction Logic

## File Location

`.compass/state.md` in the project root. Create the `.compass/` directory if it doesn't exist.

## Schema

```markdown
# Goal
{The original goal or purpose of this planning conversation, as stated by the user.
Keep this stable — don't rewrite it as the conversation evolves.}

# Elements
- ElementName [type: architecture|data|feature|concept|constraint|...]
- AnotherElement [type: ...]

# Relations
- ElementA →depends-on→ ElementB
- ElementC →contains→ ElementD
- ElementE →precedes→ ElementF

# Decided
- [Topic]: [Decision] (Reason)
- [Topic]: [Decision] (Reason)

# Undecided
- [Topic]: [Option1 | Option2 | ...] (Related elements: X, Y)

# Active Discussion
- [Current topic being discussed]

# Meta
- Created: YYYY-MM-DD
- Last sync: YYYY-MM-DD HH:MM
- Conversation turns since last sync: N
```

## Abstraction Logic — How to Extract Structure from Conversation

### Identifying Elements

An **element** is a named concept that plays a role in the plan being discussed.

- **Strong signal**: The user gives something a name. "The auth system", "the dashboard component",
  "our pricing model" — these are elements.
- **Medium signal**: Something is mentioned repeatedly across multiple turns. Repetition implies importance.
- **Weak signal**: Something is mentioned once in passing. Don't add it unless it connects to other elements.

**Typing elements**: Use whatever type label is most natural. Common types: `architecture`, `feature`,
`data`, `concept`, `constraint`, `decision`, `component`, `process`, `requirement`. Don't overthink this —
the type is a hint for visualization, not a formal taxonomy.

**Core vs detail**: An element is "core" if removing it would change the goal. Everything else is detail.
When in doubt, fewer elements is better — you can always add more.

### Identifying Relations

A **relation** is a named connection between two elements.

- "A needs B" / "A depends on B" / "without B, A won't work" → `A →depends-on→ B`
- "A includes B" / "A has B" / "B is part of A" → `A →contains→ B`
- "A comes before B" / "first A, then B" → `A →precedes→ B`
- "A talks to B" / "A sends data to B" → `A →communicates-with→ B`
- "A replaces B" / "A is an alternative to B" → `A →alternative-to→ B`

Use any relation label that's natural. The above are common patterns, not an exhaustive list.

### Abstraction Levels

When visualizing, show structure at the right granularity:

- **Level 0 (overview)**: 3-5 core elements and their primary relations. This is the default.
- **Level 1 (expanded)**: All elements and relations. Show when the user wants detail.
- **Level 2 (focused)**: One element and everything connected to it. Show when diving deep.

When a single element has more than 5 sub-items, group them. For example, if "Auth System" has
7 sub-features, group into "Core Auth" (login, logout, session) and "Extended Auth" (OAuth, SSO,
2FA, recovery).

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

- Never modify the Goal section unless the user explicitly redefines it
- Add new elements/relations as they emerge in conversation
- Move items from Undecided to Decided when decisions are made, preserving the reason
- Remove elements only if the user explicitly says they're out of scope
- Keep Active Discussion current — it should reflect what's being talked about right now
- Update the sync timestamp and turn count on every write
