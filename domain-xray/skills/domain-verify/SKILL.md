---
name: domain-verify
description: "Verify your understanding of a domain through scenario-based challenges calibrated to your specific purpose and target state. Generates expert-calibrated questions that test whether you can actually apply knowledge to achieve your goals — not just recall facts. Identifies gaps in your mental model and points you back to what needs deeper study. Use this skill when: the user has read through domain knowledge and wants to test their understanding, after running domain-extract, when someone says 'quiz me', 'test my understanding', 'do I actually get this', 'verify my knowledge', or when a learner wants to check if they're ready."
---

# Domain Verify

You test whether the learner can actually apply domain knowledge to achieve their stated purpose — not just recall what they read. This is the most important learning step that most people skip.

The cognitive science: the Testing Effect (Roediger & Karpicke, 2006) shows that retrieval practice produces 2x better long-term retention than re-reading. Elaborative Interrogation — asking "why does this work?" — drives deeper understanding. And Metacognitive Monitoring helps learners accurately assess what they know vs. what they think they know.

The key design decision: **challenges are derived from the learner's success_criteria and purpose, not from a generic "do you know this?" frame.** The question is not "can you recall this fact?" but "can you use this knowledge to do what you set out to do?"

## Workflow

### Step 1: Load Context

Search for domain-xray output files in the current working directory using Glob:

1. `domain-orient-*.md` — parse YAML frontmatter for context-spec:
   - `purpose` → what the learner needs to do (determines scenario type)
   - `success_criteria` → the test of readiness (becomes scenario design targets)
   - `current_state` → where they started (calibrates difficulty floor)
   - `target_state` → where they need to be (calibrates difficulty ceiling)
   - `priority_areas` → where to focus challenges
   Also read the map body for domain structure and area relationships (scenario material).

2. `domain-extract-*.md` — what knowledge was extracted and through which axes

3. Optionally `domain-knowledge-*.md` — what knowledge was actually generated

**If orient file found**: Use the context-spec to design purpose-aligned challenges.

**If only extract file found**: Derive purpose from the prompt's [Context] section. Note that challenges will be less precisely calibrated without the full context-spec.

**If neither found**: Ask the user what domain they've been studying and what they need to be able to do. Generate challenges based on your own domain knowledge, but warn that they'll be more generic.

### Step 2: Design Challenge Types from Purpose

The challenge types are derived from the learner's purpose, not from a fixed list. Map purpose to scenario types:

**For execution purpose** ("I need to do hands-on work"):
- **Process Decision**: You're in the middle of [task]. Here's the current state. What's your next step?
- **Troubleshooting**: Something went wrong — [symptoms]. Where do you look first?
- **Tool/Method Selection**: You need to accomplish [goal]. Which approach and why?
- **Edge Case Handling**: The standard approach works for [normal case]. But here, [twist]. What changes?

**For leadership purpose** ("I need to lead/manage"):
- **Prioritization**: Your team has [constraints]. These 3 things are behind schedule. What do you deprioritize?
- **Quality Evaluation**: A team member presents [deliverable]. What's the first thing you check?
- **Delegation Judgment**: You need to decide whether to [delegate vs. review closely]. What signals tell you which?
- **Stakeholder Communication**: [Technical situation]. How do you explain the impact to [non-technical stakeholder]?

**For evaluation purpose** ("I need to evaluate/decide"):
- **Tradeoff Analysis**: Option A offers [benefits] but [costs]. Option B offers [different benefits] but [different costs]. Given [context], which?
- **Risk Assessment**: [Proposal]. What's the risk no one's talking about?
- **Maturity Evaluation**: [System/team state]. What does this tell you about readiness for [next step]?
- **Vendor/Approach Comparison**: [Two approaches]. What question should you ask to differentiate them?

**For communication purpose** ("I need to work with specialists"):
- **Vocabulary in Context**: Two specialists are discussing [topic]. They say [term]. What do they actually mean?
- **Right Question**: You're in a meeting about [topic]. What's the one question that earns credibility?
- **Translation**: You need to explain [technical concept] to [audience]. How?
- **Miscommunication Detection**: [Conversation]. Where is the misunderstanding hiding?

Select 5-7 challenges mixing 2-3 types from the relevant purpose category.

### Step 3: Generate and Present Challenges

Present challenges interactively via AskUserQuestion — one at a time. All in the user's language.

**Challenge structure:**
- Realistic scenario that the learner would actually face given their purpose
- 3-4 options representing different approaches
- Options should be plausible — wrong answers reflect thinking natural at the learner's current_state level, not obviously bad choices
- The correct answer reflects target_state level thinking

**Calibration**: The scenarios should test the gap between current_state and target_state — not too easy (testing what they already know) and not too hard (testing beyond their target).

### Step 4: Evaluate and Give Feedback

After each answer:

**If correct**: Briefly affirm, then deepen — ask a follow-up "why" question or present an edge case where the approach breaks down. This Elaborative Interrogation drives deeper understanding.

**If incorrect**: Don't just give the right answer. Instead:
1. Explain what the chosen answer reveals about their current mental model — connect it to their current_state ("This choice makes sense if you're thinking like a [current_state role], where [that approach works]")
2. Explain what the target_state mental model looks like on this point — "But when [purpose], practitioners think about it as [different frame] because [reason]"
3. Name the specific knowledge gap and map it to the relevant extraction axis from the extract prompt

Track which areas and challenge types show gaps.

### Step 5: Gap Analysis and Next Steps

After all challenges, synthesize a gap analysis.

Look across all incorrect answers for a **common pattern** — a shared root cause or thinking habit that explains multiple errors. This is often the most valuable insight.

```
## Your Knowledge Map

### Ready Areas
- [Areas where they demonstrated target-state level thinking]

### Gap Areas
- [Area]: [Specific gap — e.g., "You can execute the process but miss the strategic tradeoffs when choosing between approaches"]
- [Area]: [Specific gap]

### Common Pattern
[If 2+ incorrect answers share a root cause, name it. E.g., "You consistently apply execution-level thinking to leadership-level decisions — optimizing for correctness when the situation calls for optimizing for speed/risk balance." This often maps to the delta between current_state and target_state thinking.]

### Purpose Readiness
Based on your stated goal: "{{success_criteria}}"
- ✓ Ready: [aspects where they showed readiness]
- △ Developing: [aspects that need more work]
- ✗ Gap: [aspects with significant gaps]

### Recommended Next Steps
1. [Most impactful action — specific to the gaps found]
2. [Second priority]
3. [Optional: suggest re-running /domain-extract with focus on gap areas]
```

### Step 6: Save and Deliver

1. Save the full verification session (challenges, answers, feedback, gap analysis) to `domain-verify-{slug}.md` in the current working directory

2. Inform the user (in their language):
   - Where the file was saved
   - Summary of their readiness relative to their stated purpose
   - If significant gaps: suggest focused re-study or re-extraction
   - If ready: affirm they're prepared to [purpose] and suggest starting with [most ready area]

## Rules

- Challenges must be **scenarios**, not trivia. "What does ETL stand for?" is useless. "Your team's ETL pipeline shows data freshness issues — stakeholders see yesterday's numbers at 2pm. As the team lead, what's your first move?" is useful.
- All interaction is in the user's language
- The verification file is saved in the user's language
- Present challenges one at a time via AskUserQuestion
- Mix challenge types — don't do 5 of the same type
- The gap analysis must reference the learner's stated purpose and success_criteria — it's not "do you know this domain?" but "can you do what you set out to do?"
- When the learner answers incorrectly, always validate why their answer makes sense given their current_state before explaining the target_state perspective. This builds trust and learning.
- If the user gets most challenges right, acknowledge it genuinely — don't manufacture difficulty
- On re-run: search for prior `domain-verify-*.md`, read its gap analysis, and focus new challenges on previously identified gaps and common pattern. Create new scenarios — don't repeat old ones.
