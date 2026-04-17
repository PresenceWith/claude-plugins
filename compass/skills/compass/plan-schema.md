# Plan File Schema

## Purpose

Plan files are **durable planning artifacts** — the accumulated decisions, elements, and
relationships that represent the intellectual output of planning conversations. They survive
across sessions and are organized by planning topic, not by session.

## File Location

`.compass/plans/{goal-slug}.md` in the project root.

The `goal-slug` is derived from the Goal text: lowercase, spaces to hyphens, Korean preserved,
max 40 characters. Examples:
- "인증 시스템 설계" → `인증-시스템-설계.md`
- "Q3 product roadmap" → `q3-product-roadmap.md`
- "MVP 기능 범위 정리" → `mvp-기능-범위-정리.md`

## Schema

```markdown
# {Goal Title}

{The original goal as stated by the user. Keep stable — don't rewrite as conversations evolve.
If the user explicitly redefines the goal, update and note the change.}

## Elements
- ElementName [type: architecture|feature|data|concept|constraint|...]
- AnotherElement [type: ...]

## Relations
- ElementA →depends-on→ ElementB
- ElementC →contains→ ElementD

## Decided
- [Topic]: [Decision] (Reason) — {YYYY-MM-DD}
- [Topic]: [Decision] (Reason) — {YYYY-MM-DD}

## Deferred
- [Topic]: [Option1 | Option2 | ...] — deferred because: {reason}

## Meta
- Created: YYYY-MM-DD
- Last updated: YYYY-MM-DD
- Sessions contributed: N
```

## What Goes Into a Plan File

Plan files accumulate **confirmed, durable information** only:

- **Elements**: Named concepts that play a role in the plan. Added when identified with
  medium-to-strong signal (user names it, or it's mentioned repeatedly).
- **Relations**: Confirmed connections between elements. Only add after the user validates
  the relationship — never add inferred relations directly.
- **Decided items**: Choices that have been made. Include the reason and date.
  A decision is confirmed when the user explicitly chose, approved a recommendation,
  or built on an assumption without objection.
- **Deferred items**: Topics that were explicitly set aside ("let's come back to this",
  "not now"). Include the reason for deferral so future sessions have context.

## What Does NOT Go Into a Plan File

- Active discussion topics (session-scoped → state.md)
- Session-local undecided items that haven't been explicitly deferred
- Lightweight counters (in-memory only)
- Assumptions that haven't been validated with the user

## Update Rules

- **Append-first**: Add new elements, relations, and decisions. Don't reorganize existing
  entries unless the user asks.
- **Move, don't delete**: When a deferred item gets decided, move it from Deferred to Decided.
  When a decision is reversed, move it back to Deferred with a note.
- **Preserve history**: Don't silently remove entries. If something becomes irrelevant,
  the user should explicitly say so.
- **Increment session count**: Bump `Sessions contributed` on each session that writes to the file.
- **Goal stability**: Never modify the Goal unless the user explicitly redefines it.

## Promotion Flow

During a state sync (writing state.md), also check if any items should be promoted to the plan:

1. New decided items in state.md → append to plan's `## Decided` with date
2. Explicitly deferred items → append to plan's `## Deferred` with reason
3. New elements/relations confirmed during conversation → append to plan
4. Update plan's `Last updated` and `Sessions contributed`

This promotion happens as part of the normal sync — no separate step needed.
