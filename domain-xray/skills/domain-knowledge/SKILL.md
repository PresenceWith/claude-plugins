---
name: domain-knowledge
description: "Execute a domain-extract prompt to generate a comprehensive tacit knowledge document. Transforms the extraction prompt into an actual knowledge artifact — the core learning material of the pipeline. Use this skill when: the user has an extract prompt and wants to generate knowledge from it, after running domain-extract, when someone says 'generate knowledge', 'run the prompt', 'create the knowledge document', 'execute the extract', or when domain-extract suggests automatic execution. Also triggers when the user says 'yes' to the 'generate knowledge now?' prompt from domain-extract."
---

# Domain Knowledge

You execute a domain-extract prompt and produce a structured tacit knowledge document. This is the step that turns the extraction prompt (a tool) into an actual knowledge artifact (a learning resource).

The extract prompt is designed around purpose-specific extraction axes. Your job is to fulfill that prompt at the highest possible depth and quality, calibrating your perspective to the learner's current state and target state.

## Workflow

### Step 1: Find the Extract Prompt and Context

Search for files in the current working directory using Glob:

1. `domain-extract-*.md` — the extraction prompt
2. `domain-orient-*.md` — the orientation map with context-spec frontmatter

**If extract found**: Read it. This file contains a complete prompt with [Context], [Task], [Output Constraint], and optionally [Scope] sections.

**If multiple found**: Present the list and ask the user which one to use.

**If not found**: Inform the user in their language: "추출 프롬프트가 없습니다. 먼저 /domain-extract를 실행해주세요." (translated). Stop here.

**If orient map found**: Read the YAML frontmatter to extract the context-spec:
- `purpose` → understand what the knowledge is for
- `current_state` → what to skip, where to start
- `target_state` → where to end, what level to reach
- `success_criteria` → the ultimate test of usefulness
- `anchor_points` → existing knowledge to connect to

### Step 2: Calibrate Framing

Before executing the prompt, determine the right expert-to-learner framing based on the context-spec. This replaces the old fixed "expert explains to beginner" frame.

**Derive the framing from current_state → target_state:**

Examples:
- current="senior backend engineer", target="data platform architecture decisions" → Frame as: "A data infrastructure architect explaining to a systems engineer who understands distributed systems, reliability, and API design — focusing on where data-domain thinking diverges from backend-domain thinking"

- current="PM with no technical background", target="participate in technical decisions" → Frame as: "A CTO explaining to a business-minded PM — skipping implementation details, focusing on decision criteria, tradeoff language, and the questions that matter"

- current="complete newcomer", target="hands-on execution" → Frame as: "An experienced practitioner explaining to someone starting from scratch — covering fundamentals through practical scenarios, building up from zero"

- current="3 years data analyst", target="lead analytics team" → Frame as: "A senior analytics leader explaining to a solid individual contributor — skipping execution basics, focusing on the leadership and strategic dimensions they haven't encountered yet"

The framing determines:
- What knowledge to skip (already known)
- What to emphasize (the gap between current and target)
- What lens to use (execution vs. decision-making vs. communication)
- What depth level (foundational vs. advanced vs. strategic)

### Step 3: Execute the Prompt

Become the expert described in the prompt. Follow its instructions precisely, but apply the calibrated framing:

- Adopt the expert role with awareness of who you're speaking to (not a generic "beginner")
- Define the domain's lifecycle or core workflow into logical stages
- For each stage, cover the extraction axes specified in the prompt (these vary by purpose — the prompt specifies which axes to use)
- Follow the [Output Constraint] section: depth over volume, rich paragraphs with hierarchical structure, no emojis, specificity with scenarios and edge cases
- **Apply Level Calibration**: The prompt's output constraints specify what the learner already knows. Don't explain those basics — start from where their knowledge ends
- Respect the `Response Language` specified in the prompt
- If a [Scope] section exists, invest depth disproportionately in the priority areas
- Connect new concepts to the learner's anchor points where possible — "You know X from your experience with Y; in this domain, the equivalent is Z, but with this critical difference..."

This is the most important step. The quality of the knowledge document is the entire value of this skill. Take the expert role seriously — draw on deep domain understanding, provide concrete scenarios, and explain not just what experts do but why.

### Step 4: Coverage Check

After generating the knowledge, verify that all extraction axes from the prompt are substantively covered. This is a self-check to ensure nothing was accidentally omitted.

Scan the generated content against each axis specified in the extract prompt. The minimum bar for each priority stage (as defined by [Scope]) is at least one concrete scenario or example per axis.

For non-priority stages (lighter coverage), at least one item across any two of the axes is sufficient.

If any priority stage falls below the minimum bar, generate supplementary content.

Append a Coverage section:

```
## Coverage

| Axis | Status |
|------|--------|
| {{Axis 1 name from prompt}} | ✓ Covered |
| {{Axis 2 name from prompt}} | ✓ Covered |
| {{Axis 3 name from prompt}} | ✓ Covered |
| {{Axis 4 name from prompt}} | ✓ Covered |
```

If any axis needed supplementation, note it: "✓ Covered (supplemented)".

### Step 5: Save and Deliver

1. Save to `domain-knowledge-{slug}.md` in the current working directory
   - Use the same slug as the extract file
   - The file contains the full knowledge document including the Coverage section

2. Present 3-5 key highlights to the user (in their language) — the most surprising or counterintuitive insights, especially those that directly address the gap between their current and target state.

3. Inform the user (in their language):
   - Where the file was saved
   - Suggest running `/domain-verify` to test whether they can apply this knowledge to their specific purpose

## Rules

- The knowledge document language follows the `Response Language` in the extract prompt
- Technical terms stay in their original English form with a brief translation on first use
- The Coverage section uses the actual axis names from the extract prompt (not hardcoded names)
- Do not modify or reinterpret the extract prompt's instructions — execute them faithfully
- Depth over volume: three deeply-explained items with concrete scenarios are worth more than ten shallow ones
- The framing calibration is critical — a knowledge document that explains basics to a senior engineer wastes their time and erodes trust. A document that skips basics for a newcomer leaves them lost. Get the level right.
- Conversation with the user is always in the user's language
