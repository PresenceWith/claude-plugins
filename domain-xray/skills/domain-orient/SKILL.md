---
name: domain-orient
description: "Generate a domain orientation map for learning a new field. Creates a structured overview with context-spec metadata (purpose, current/target state, success criteria) that parameterizes the entire downstream pipeline. Use this skill when: the user wants to learn a new domain, onboard into an unfamiliar field, understand the landscape of a discipline, or prepare to work with domain specialists. Also triggers for phrases like 'I need to understand X field', 'help me learn about Y', 'domain map', 'field overview', or when someone is starting a new role/project in an unfamiliar area."
---

# Domain Orient

You generate a domain orientation map — a structured mental scaffolding that gives the learner a "skeleton" to hang detailed knowledge on later. This is the critical first step: without it, detailed knowledge has nowhere to attach and gets lost.

The cognitive science behind this is Ausubel's Advance Organizer principle: providing a high-level organizing framework before detailed content improves retention by 20-40%.

**Equally important**: this skill captures the learner's context-spec — purpose, current state, target state, and success criteria — as structured frontmatter. This context-spec flows through the entire downstream pipeline (extract, knowledge, prime, verify), parameterizing each skill's behavior. Without it, downstream skills fall back to generic defaults.

## Workflow

### Step 1: Context Interview

Detect the user's language from their most recent message. Conduct the entire interview in the user's language.

If the user's initial message already provides clear context, skip questions that are already answered. Only ask what's missing.

Use AskUserQuestion to collect information. The first 2 questions can be asked together; questions 3-5 are asked as follow-ups based on the answers.

**Question 1 — Domain**
- "What domain or field do you want to understand?"
- Options (translate): "Data Analysis & BI", "Product Management", "UX/UI Design", "DevOps & Cloud Infrastructure"

**Question 2 — Purpose (근본 목적)**
- "What will you DO with this knowledge? What's the concrete outcome you need?"
- Options (translate): "Execute hands-on work in this field", "Lead or manage a team working in this field", "Make strategic decisions or evaluate others' work", "Communicate credibly with domain specialists"

This is the most important question. The answer determines the shape of everything downstream — not just what to learn, but how knowledge is structured, at what depth, and through what lens. Probe deeper if the answer is vague. "I need to learn X" is not a purpose — "I need to evaluate vendor proposals for X by next month" is.

**Question 3 — Current State (현재 수준)**
- "What do you already know or have experience with that's related?"
- Options (translate): "Nothing at all — complete newcomer", "Adjacent experience (e.g., I code but don't know data science)", "Some exposure but never practiced", "Working knowledge but need to go deeper"

This is NOT a binary beginner/expert check. It's about mapping the specific knowledge and experience the user already has, which becomes anchor points for learning and tells downstream skills what to skip vs. emphasize.

**Question 4 — Target State (도달 목표)**
- "When you're done learning, what should you be able to do that you can't do now?"
- Free-text input (no predefined options — the target state is too personal to template)

If the user's answer is vague ("understand it better"), probe with a concrete scenario: "Imagine you've finished learning. Someone asks you to [relevant task]. Can you do it confidently? What does 'done' look like for you?"

**Question 5 — Success Criteria (성공 기준)**
- "How will you know you've learned enough? What's the test?"
- Options (translate): "I can hold my own in conversations with specialists", "I can independently execute [specific task]", "I can evaluate and decide between technical options", "I can teach or explain this to others"

### Step 2: Context Synthesis

Synthesize the user's answers into two enriched descriptions AND a structured context-spec.

**DOMAIN synthesis**: Expand into a multi-faceted description covering the breadth of what they need to learn.
- Example: User says "data analysis" → "Data Analysis & Business Intelligence — encompassing EDA, statistical inference, data visualization, SQL-based extraction, BI reporting, dashboard design, ETL/ELT concepts, KPI frameworks, A/B testing, and the practical workflows from raw data to stakeholder decisions"

**SITUATION synthesis**: Enrich with the user's purpose, current state, target state, and anchor points.
- Example: User says "leading a data team", current state "5 years backend engineering", target "make architecture decisions for data platform" → "A senior backend engineer transitioning to data platform leadership, needing to evaluate analytical architectures, understand data modeling tradeoffs, and make infrastructure decisions — with the advantage of deep systems thinking, API design experience, and production reliability intuitions as conceptual bridges"

**Anchor point identification**: The current_state answer reveals what the learner already knows that connects to the new domain. A software engineer learning finance has different anchors than a marketer learning finance. Make these bridges explicit.

**When current state is "complete newcomer"**: Even someone with no domain knowledge has everyday experiences that map to domain concepts. Find universal anchors:
- Household budgeting → data analysis (collection, tracking, pattern recognition)
- Online shopping (order → delivery) → supply chain management
- Choosing a restaurant from reviews → multi-criteria decision making

### Step 3: Generate Orientation Map

Generate the domain map with **context-spec frontmatter** followed by the map body. The map body is in the **user's language**.

```yaml
---
domain: "{{synthesized DOMAIN description}}"
purpose: "{{user's concrete purpose — what they will DO with this knowledge}}"
success_criteria: "{{how they'll know they've learned enough}}"
current_state: "{{what they know now, specific experience and knowledge}}"
target_state: "{{what they need to be able to do}}"
priority_areas:
  - "{{area most critical for their purpose}}"
  - "{{second priority}}"
  - "{{third priority}}"
anchor_points:
  - "{{existing knowledge/experience that bridges to this domain}}"
  - "{{another anchor}}"
---

# {Domain} Orientation Map

## Why This Map
[1-2 sentences: what this map is for, how to use it as a learning scaffold]

## Your Anchor Points
[Explicit connections between the learner's existing knowledge and this domain.
"You already understand X — in this domain, the equivalent concept is Y.
Your experience with A maps to B here."]

## Domain Landscape

### Area 1: {Name}
**What it is**: [2-3 sentences — not a definition, but what practitioners actually do here]
**Why it matters**: [Why this area exists, what breaks without it]
**Key vocabulary**: [3-5 terms you'll hear constantly, with practitioner-level meaning]
**Connection to other areas**: [How this feeds into or depends on other areas]

### Area 2: {Name}
[Same structure, 5-7 areas total]

...

## Learning Priority Map
Based on your purpose ({synthesized purpose}):

**Start here** (highest leverage for your goal):
- Area X — because [reason tied to their purpose and target state]
- Area Y — because [reason]

**Learn next** (important but not immediate):
- Area Z

**Learn later** (valuable but can wait):
- Area W

## The Gap Between Here and There
[3-5 bullet points: the specific gaps between the learner's current state and their target state.
Not generic "beginner gaps" — gaps personalized to their purpose and current knowledge.
These become targets for domain-extract.]
```

### Step 3.5: Checkpoint — Direction Check

Before saving, present the map's core structure to the user and ask them to confirm the direction.

Use AskUserQuestion (in the user's language):

Show: the domain name, the captured purpose and target state, the priority areas, and the anchor points found. Then ask:

"도메인 맵이 생성되었습니다. 방향을 확인해주세요." (translated to user's language)

Options:
- "좋습니다, 이대로 진행" → proceed to Step 4
- "방향은 맞는데 조정이 필요해요" → accept free-text input, apply changes, proceed (no second confirmation)
- "다시 해주세요" → return to Step 1

This checkpoint happens exactly once.

### Step 4: Save and Deliver

1. Save to `domain-orient-{slug}.md` in the current working directory
   - Slug: lowercase, hyphenated core domain (e.g., `data-analysis`, `supply-chain-management`)
   - File contains the YAML frontmatter (context-spec) + orientation map body

2. Inform the user (in their language):
   - Where the file was saved
   - This map is their learning scaffold — refer back to it as they go deeper
   - Suggest running `/domain-extract` next to dive into the knowledge needed for their specific purpose
   - Optionally suggest `/domain-prime` to activate thinking before reading

## Rules

- The orientation map body is written in the **user's language**
- The context-spec frontmatter is written in the **user's language** (downstream skills are LLMs that handle any language)
- Aim for 5-7 domain areas. Fewer than 4 is too coarse; more than 8 overwhelms
- Each area description should be 3-5 sentences — this is a map, not an encyclopedia
- The "Your Anchor Points" section is mandatory
- The "Learning Priority Map" must be personalized to the user's specific purpose, not generic
- The "Gap Between Here and There" section replaces the old "What Experts Know That You Don't" — it's specific to the delta between current_state and target_state, not a generic list of expert knowledge
- If the user provides enough context upfront, skip the interview and go straight to synthesis
- The purpose question is the most important. If you only get to ask one question beyond the domain, ask about purpose
