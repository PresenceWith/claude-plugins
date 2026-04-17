---
name: domain-extract
description: "Extract deep tacit knowledge from any domain — the hidden expertise that practitioners use instinctively but never explain. Generates a structured prompt with extraction axes dynamically chosen based on the learner's purpose (hands-on work, leadership, evaluation, etc.). Use this skill when: the user wants to deeply learn a domain, extract expert knowledge, understand what practitioners actually think, get beyond textbook knowledge, or after running domain-orient. Triggers for: 'tacit knowledge', 'expert knowledge', 'what do practitioners actually do', 'hidden knowledge', 'domain deep dive', or any request to understand a field at a practitioner level."
---

# Domain Extract

You generate precision-crafted prompts that extract deep tacit knowledge — the kind that lives only in practitioners' heads and never makes it into textbooks. The output is a prompt designed for use in a fresh AI conversation to maximize output tokens.

The key design decision: **extraction axes are chosen based on the learner's purpose, not hardcoded.** Someone learning to execute hands-on work needs different knowledge structures than someone learning to lead a team or evaluate proposals. The purpose (captured in the orient-map's context-spec) determines which axes produce the most useful knowledge.

## Extraction Axis Sets

Each purpose maps to a set of 4 extraction axes optimized for that knowledge need:

**Hands-on Execution** (purpose: execute work, build, implement)
- **Practical Terminology & Jargon**: Nuances as actually used, not textbook definitions
- **Hidden Preconditions**: Omitted steps where experts think "they obviously did this already"
- **Common Pitfalls**: Critical mistakes at the learner's level due to lacking tacit knowledge
- **Rules of Thumb**: Decision heuristics practitioners use that aren't found in textbooks

**Leadership & Management** (purpose: lead teams, manage projects, direct work)
- **Decision Frameworks**: How experts choose between options — the criteria and their weights
- **Delegation Judgment**: What to check vs. what to trust — how to evaluate others' work without doing it yourself
- **Risk Signals**: Early warning signs that something is going wrong — what experienced leaders watch for
- **Communication Frames**: How to talk about this domain credibly — the language that earns trust vs. exposes ignorance

**Strategic Evaluation** (purpose: evaluate, architect, make strategic choices)
- **Tradeoff Structures**: What's actually being traded against what — the hidden costs and constraints
- **Failure Modes**: How systems/approaches break down — not just what fails but why and when
- **Design Principles**: The deep "why" behind best practices — when to follow them and when to break them
- **Evaluation Criteria**: How experts assess quality, maturity, and readiness — what they look for

**Cross-Domain Communication** (purpose: communicate with specialists, bridge domains)
- **Vocabulary in Context**: Terms that mean different things to different groups — where miscommunication hides
- **Unstated Assumptions**: What specialists assume you know — the knowledge gap that creates talking-past-each-other
- **Question Patterns**: The questions that earn respect vs. the ones that mark you as an outsider
- **Translation Points**: Where your existing domain maps onto this one — and where the analogy breaks

**Exploratory Learning** (purpose: general curiosity, broad understanding)
- **Core Concepts**: The fundamental building blocks — what everything else rests on
- **Counter-Intuitive Realities**: What's true in practice but surprising to outsiders
- **Common Misconceptions**: What most people get wrong and why
- **Foundational Principles**: The deep patterns that explain surface-level complexity

If the purpose doesn't clearly map to one set, default to **Hands-on Execution** — it's the most general.

## Workflow

### Step 1: Check for Orientation Map

Look for a `domain-orient-*.md` file in the current working directory using Glob.

**If found**: Read it. Parse the YAML frontmatter (context-spec) to extract:
- `purpose` → determines which extraction axis set to use
- `current_state` → calibrates the depth and starting point
- `target_state` → defines the endpoint
- `priority_areas` → scoping
- `anchor_points` → enriches the context

Also read the map body for domain structure, area relationships, and key vocabulary. Use all of this to enrich the prompt.

**If not found**: Conduct a context interview:

Use AskUserQuestion in the user's language:

**Question 1 — Domain**
- "What domain do you want to extract expert knowledge from?"
- Options: "Data Analysis & BI", "Product Management", "UX/UI Design", "DevOps & Cloud Infrastructure"

**Question 2 — Purpose**
- "What will you DO with this knowledge?"
- Options: "Execute hands-on work", "Lead or manage a team", "Make strategic decisions or evaluate", "Communicate with specialists", "General exploration"

**Question 3 — Current Level**
- "What do you already know about this domain?"
- Options: "Complete newcomer", "Adjacent experience", "Some exposure", "Working knowledge — going deeper"

### Step 2: Context Synthesis

**If orient map exists**: Use the context-spec directly. Enhance the DOMAIN description with sub-areas from the map body. Enhance the GOAL description with anchor points and priority areas.

**If no orient map**: Synthesize from interview answers.

**DOMAIN** — Expand into a rich, multi-faceted description:
- User says "data analysis" → "Data Analysis & Business Intelligence — encompassing exploratory data analysis (EDA), statistical inference, data visualization, SQL-based extraction, BI reporting, dashboard design, ETL/ELT concepts, KPI frameworks, A/B testing, and the practical workflows from raw data to stakeholder decisions"

**GOAL** — Synthesize from purpose + current_state + target_state:
- Example with orient context: purpose="lead data platform team", current="senior backend engineer", target="make architecture decisions for data infrastructure" → "leading a data platform team as a senior backend engineer transitioning into data infrastructure leadership, needing to evaluate analytical architectures, understand data modeling tradeoffs, and make infrastructure decisions — leveraging deep systems thinking and production reliability experience as bridges"

**Select the extraction axis set** based on the purpose.

### Step 3: Prompt Generation

Build the prompt using the synthesized context and the selected axis set.

**Template:**

```
[Context]
I am working in the field of {{DOMAIN}}. My current background: {{CURRENT_STATE}}. I need to {{GOAL}}. To bridge the gap between where I am and where I need to be, I want to deeply understand the tacit knowledge — the practical expertise that practitioners use instinctively but rarely explain.

[Task]
You are a top-tier expert who has spent 20+ years in this domain, and a mentor who understands exactly where I'm coming from ({{CURRENT_STATE_BRIEF}}) and where I need to go ({{TARGET_STATE_BRIEF}}). Please excavate the knowledge that will be most impactful for my specific purpose.

First, define the entire lifecycle or core workflow of this domain into logical stages. For each stage, describe in detail the following elements:

{{AXIS_1_NAME}}: {{AXIS_1_DESCRIPTION}}

{{AXIS_2_NAME}}: {{AXIS_2_DESCRIPTION}}

{{AXIS_3_NAME}}: {{AXIS_3_DESCRIPTION}}

{{AXIS_4_NAME}}: {{AXIS_4_DESCRIPTION}}

[Output Constraint]

Depth Over Volume: For each axis, prioritize concrete scenarios, specific examples, and edge cases over exhaustive listing. Three deeply-explained items are worth more than ten shallow ones.

Level Calibration: I already know {{SKIP_AREAS}}. Don't explain these basics — start from where my knowledge ends and go deeper.

Format: Use rich descriptive paragraphs with clear hierarchical structure (Heading 1, 2, 3). Avoid simple bulleted lists. Never use emojis.

Specificity: Every heuristic should include when it applies AND when it breaks down. Every pitfall should include a concrete scenario showing how it manifests in practice.

Response Language: {{LANGUAGE}}. Use this language for all explanations. Keep domain-specific technical terms in their original English form with a brief translation on first use.

Continuity: If you reach the output limit and the response is incomplete, write ">>> CONTINUE FROM HERE <<<" at the end.
```

**If orient map has priority areas**, insert after the [Context] paragraph:

```
[Scope]
Based on my priorities, please focus especially deeply on these areas (in order of importance): {{PRIORITY_AREAS}}. Cover other areas at a lighter level for context, but invest your depth budget here.
```

**Template variable resolution:**
- `{{CURRENT_STATE}}` — from context-spec or interview
- `{{CURRENT_STATE_BRIEF}}` — one-phrase summary (e.g., "a backend engineer with no data science experience")
- `{{TARGET_STATE_BRIEF}}` — one-phrase summary (e.g., "making data platform architecture decisions")
- `{{SKIP_AREAS}}` — knowledge the user already has (derived from current_state and anchor_points)
- `{{AXIS_N_NAME/DESCRIPTION}}` — from the selected axis set
- `{{LANGUAGE}}` — detected from user's conversation language

### Step 4: Save and Deliver

1. Save to `domain-extract-{slug}.md` in the current working directory
   - Same slug convention as orient (lowercase, hyphenated)
   - File contains only the prompt — no wrapper text

2. Inform the user (in their language):
   - Where the file was saved
   - Which extraction axis set was selected and why
   - This prompt is designed for use in a **fresh conversation** with a capable AI model, or can be executed via `/domain-knowledge`
   - If the response gets cut off at ">>> CONTINUE FROM HERE <<<", paste that marker to request continuation
   - **Offer automatic execution**: "이 프롬프트를 바로 실행하여 지식 문서를 생성하시겠습니까?" (translated)
     - Option A: "네, 바로 생성해주세요" → guide the user to run `/domain-knowledge`
     - Option B: "아니요, 프롬프트만 사용할게요" → remind them the prompt works in any AI model

## Rules

- The prompt file is always in **English**, regardless of conversation language
- `{{LANGUAGE}}` is detected from the user's conversation language
- The extraction axes are determined by purpose — this is the core differentiator from the previous version
- Conversation with the user is always in the user's language
- Invest real effort in synthesis. Richer DOMAIN and GOAL descriptions produce better extraction
- If the user provides enough context (or an orient map exists), skip the interview entirely
- The Level Calibration output constraint is critical — it prevents the prompt from producing content the user already knows
