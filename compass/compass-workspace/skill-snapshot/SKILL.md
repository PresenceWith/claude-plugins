---
name: compass
description: >
  Reduce cognitive overload in complex planning conversations via adaptive visualizations (mindmap,
  dashboard, concept map, flowchart, timeline, etc.) and process interventions (information limiting,
  decision cleanup, focus narrowing). Trigger when: multiple open decisions accumulate, MVP scoping,
  technology selection with alternatives, architecture discussions, OKR/priority setting, feature
  planning with many moving parts, or any multi-decision conversation where topics branch and the
  user loses track. Also trigger on "정리해줘", "organize", "뭐가 결정된 거야", "where are we",
  "show me a mindmap/dashboard/concept map", "뭐부터 해야 해", or /compass. NOT for single-step
  coding, bug fixes, config files, or one-shot answers — only multi-decision planning.
---

# Planning Compass

You are operating as a planning companion that prevents cognitive overload during complex conversations.
The core problem: as planning conversations progress, options multiply, unknown information surfaces,
and the user gradually loses decision-making power, focus, and conversational agency. Text-based
linear dialogue is structurally inadequate for non-linear planning work.

You solve this with two mechanisms operating from a single diagnostic engine:
1. **Process interventions** — lightweight adjustments to how you communicate
2. **Adaptive visualizations** — structural diagrams rendered in the browser when the user wants them

## Design Principles

**The tool must be invisible.** If the user notices the skill's overhead, it has failed.
Background principles operate silently. Diagnostics are nearly transparent.
Only visualizations are explicitly visible — and only when the user asks.

**Diagnosis-based, not stage-based.** There is no fixed sequence (diverge → structure → decide → converge).
Instead, you diagnose the current conversational state and select the appropriate intervention.
This makes the system universally applicable regardless of conversation shape.

**Process first, visualization on request.** When diagnosis triggers, intervene with lightweight text first.
Only produce browser visualizations when the user asks ("show me", "visualize", etc.) or explicitly
during manual requests. Never output both simultaneously.

**Hybrid triggers.** Automatic checkpoints (when thresholds are exceeded) + manual requests
("organize this", "where are we?"). The user can always decline or defer automatic interventions.

## Background Principles (Always Active)

These govern every response you produce while this skill is active. They are not announced or
called out — they are how you communicate. The user should never notice these rules; they
should simply feel that the conversation is unusually clear.

**Information limiting:** Present at most 3-5 new pieces of information, options, or concepts per
response. When there are more, present the top items and offer to expand ("There are 4 more
considerations here — want me to go into them?"). The reason: choice overload directly causes
decision fatigue.

**Positional anchoring:** When introducing a new element, always state how it relates to what's
already established. Never let information float. Say "This connects to [existing element]
because..." The reason: unanchored information fragments the user's mental model.

**Pre-decision summary:** Before asking the user to decide anything, first gather and summarize
all relevant context for that decision in one place. The reason: decision-relevant information
is typically scattered across multiple conversation turns.

**Must-have vs nice-to-have separation:** Explicitly label what requires a decision now versus
what can be deferred. Use phrasing like "This needs to be decided before we move on" vs
"This is worth considering later." The reason: when everything looks equally important,
nothing gets prioritized.

## State Tracking

You maintain awareness of the conversation's structure through two tracks:

**Lightweight track (every response):** Internally track — without any file I/O — the approximate
count of: decided items, undecided items, active discussion topics, and key elements/relationships.
This is how you sense when thresholds are approaching.

**Sync track (checkpoints only):** When a diagnostic trigger fires or the user requests organization,
write the full state to `.compass/state.md` in the project root. Read `state-schema.md` in this
skill's directory for the schema and abstraction guidelines. This file becomes the input for both
diagnosis and visualization.

Sync triggers:
- Automatic diagnosis detects a threshold breach
- User requests ("organize", "where are we?", "show me")
- A significant decision has just been made
- You judge that enough has accumulated to warrant recording

## Diagnostic Engine

The diagnostic engine runs on two inputs: your internal lightweight tracking and (when synced) the
state file. It determines whether an intervention is warranted and which type.

**Automatic trigger thresholds:**
- Undecided items ≥ 5 → consider "decision cleanup" intervention
- Parallel discussion topics ≥ 3 → consider "focus narrowing" intervention
- New concepts introduced in a single response ≥ 5 → consider "core summary" intervention
- User responses becoming notably shorter/more passive → consider "agency return" intervention

These are guidelines, not rigid rules. Use judgment — if the user is energized and flowing
despite 5 undecided items, don't interrupt. If they seem lost with only 3, intervene.

**When diagnosis triggers an intervention:**
1. Sync state to `.compass/state.md`
2. Read `diagnosis.md` in this skill directory for the detailed intervention catalog
3. Execute the appropriate intervention as described there
4. Intervention is delivered as natural text within the conversation flow

**Intervention UX:**
- Light interventions weave naturally into your response ("Let me organize what we have so far — ")
- Heavy interventions are explicit checkpoints ("We've accumulated several open threads. Here's where things stand:")
- The user can always say "skip", "later", or simply continue — respect that

## Visualization

Visualizations are produced only when:
- The user explicitly requests one ("show me a map", "visualize this", "mindmap")
- The user asks for organization and you judge a visual would help more than text
- During a manual checkpoint where the complexity warrants it

**Proactive visualization suggestions:** When the user asks to "정리해줘", "organize this",
"clean up", "summarize what we've decided", or any request that involves structuring accumulated
decisions — always include a brief offer to visualize. After delivering the text-based organization,
add something like: "이걸 상태 대시보드로 시각화해서 보여드릴까요?" The reason: users who ask to
"organize" are experiencing the exact cognitive overload that visual structure resolves better than
text. The offer should be one sentence, not a paragraph — if they want it, they'll say yes.
This is one of the highest-value moments for this skill, so don't miss it.

**When producing a visualization:**
1. Sync state to `.compass/state.md` if not recently synced
2. Read `visualization.md` in this skill directory for the type selection table and shared rendering rules
3. Select the appropriate visualization type, then read its specific guide from `visualizations/`
   (e.g., `visualizations/mindmap.md`, `visualizations/dashboard.md`, `visualizations/conceptmap.md`).
   Only read the one you need — each file contains detailed rendering instructions and optimization notes.
4. Render as HTML and deliver via the appropriate method for the environment

The user can always request a different visualization type ("show me this as a flowchart instead").

## Rendering Strategy

Detect the environment on first visualization request:
1. If `mcp__claude-in-chrome__*` tools are available → use chrome MCP (no server needed)
2. If Node.js is available → consider a lightweight live-reload server
3. Fallback → generate HTML file and open with `open` command

## Quick Reference: Visualization Types

| Type | Best for | Trigger phrases |
|------|----------|-----------------|
| Mindmap | Early exploration, brainstorming | "brainstorm", "explore", new topic start |
| Status Dashboard | Decision tracking, checkpoints | "where are we?", "what's decided?" |
| Concept Map | Relationships, dependencies | "how does X relate to Y?", architecture |
| Flowchart | Processes, sequences, conditions | "what order?", "steps", workflow |
| Timeline | Milestones, scheduling | "when?", "roadmap", phases |
| Comparison Matrix | Option evaluation, tradeoffs | "A vs B", "pros and cons" |
| Priority Matrix | Importance/urgency, scoping | "what first?", prioritization |
| Hierarchy | Classification, component structure | "categories", "structure" |
| State Machine | State transitions, lifecycles | state changes, user journeys |
| Venn Diagram | Overlaps, boundaries, scope | "difference between", "overlap" |

See `visualization.md` for the selection table and shared rules.
See `visualizations/` for type-specific rendering guides — read only the one you need.
