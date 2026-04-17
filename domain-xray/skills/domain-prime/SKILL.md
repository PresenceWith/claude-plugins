---
name: domain-prime
description: "Activate your thinking before diving into domain knowledge — a metacognitive priming session based on your orientation map. Generates prediction-based questions calibrated to the gap between your current and target state, creating curiosity gaps that make subsequent knowledge absorption significantly more effective. Use this skill when: the user has an orient map and is about to read knowledge material, when someone wants to prepare their mind before studying, after domain-orient, when the user says 'prime me', 'prepare me', 'warm up my thinking', 'get me ready to learn', or when knowledge is being generated in the background and the user has idle time."
---

# Domain Prime

You activate the learner's thinking before they encounter new knowledge. This is not a quiz — there are no right or wrong answers. The goal is to create mental "hooks" that make subsequent knowledge absorption dramatically more effective.

The cognitive science: when you make a prediction before encountering information, your brain enters a tracking mode — "was I right?" This Prediction → Curiosity Gap → Enhanced Encoding cycle means you encode the actual answer 2-3x more deeply than if you'd just read it passively. The Hypercorrection Effect adds another layer: confident predictions that turn out wrong produce the strongest learning of all.

Your job is to activate this cycle using the learner's orient map, calibrating question difficulty to sit just beyond their current knowledge — in their Zone of Proximal Development (ZPD).

## Workflow

### Step 1: Find the Orient Map

Search for `domain-orient-*.md` in the current working directory using Glob.

**If found**: Read it. Parse the YAML frontmatter (context-spec) to extract:
- `current_state` → the learner's starting point (determines question floor)
- `target_state` → where they're going (determines question ceiling)
- `purpose` → what they need this for (determines question focus)
- `anchor_points` → existing knowledge to build from
- `priority_areas` → where to focus questions

Also read the map body: domain landscape (area names and relationships), anchor points, priority areas.

**If multiple found**: Use the most recently modified one.

**If not found**: Inform the user in their language: "오리엔트 맵이 없습니다. 먼저 /domain-orient를 실행해주세요." (translated). Stop here.

### Step 2: Calibrate Difficulty

Before generating questions, determine the right difficulty zone from the context-spec:

- **current_state = "complete newcomer"**: Questions should challenge basic intuitions about the domain. Use anchor points to frame questions in terms the learner already understands. The gap to probe: "What you'd assume based on common sense vs. what's actually true in this domain."

- **current_state = "adjacent experience"**: Questions should probe where their existing mental models break down in the new domain. The gap: "Where your experience helps vs. where it misleads you."

- **current_state = "some exposure"**: Questions should probe the difference between surface understanding and practitioner intuition. The gap: "What you think you know vs. what practitioners actually do."

- **current_state = "working knowledge"**: Questions should target the strategic/leadership dimensions they haven't encountered. The gap: "What you know how to do vs. what you need to decide or evaluate."

The purpose further adjusts focus: leadership-focused learners get questions about judgment and delegation; execution-focused learners get questions about process and technique; evaluation-focused learners get questions about criteria and tradeoffs.

### Step 3: Questions — 3 rounds, sequential

Start immediately — no "would you like to try?" preamble.

Present each question via AskUserQuestion, one at a time. Each question activates a different thinking axis:

**Q1 — Prediction** (activates hypotheses about domain structure)
Draw from the orient map's priority areas. Ask the learner to predict something about how this domain actually works — calibrated to their level.

Format: scenario + 3 options (A/B/C). All options should be plausible — the "wrong" ones should reflect thinking patterns natural at the learner's current level, not obviously silly choices.

For a newcomer: "In [priority area], what would a practitioner consider the most important factor?"
For someone with adjacent experience: "Your experience with [anchor point] might suggest X. In [priority area], how does this actually play out?"
For someone with working knowledge: "When making a strategic decision about [priority area], experienced leaders weight which factor most heavily?"

**Q2 — Connection** (activates anchor point ↔ new domain mapping)
Draw from the orient map's anchor points. Ask how their existing experience maps (or fails to map) to a domain concept.

For a newcomer: "Your experience with [everyday anchor] is most similar to which aspect of [domain area]?"
For adjacent experience: "Your [professional anchor] experience suggests [assumption]. In this domain, that assumption is..."
For working knowledge: "The principle you use for [known task] applies to [new area], but with what critical modification?"

**Q3 — Relationship** (activates cross-area causal reasoning)
Draw from two different areas in the domain landscape. Ask about the causal relationship or downstream impact between them — at a level appropriate to the learner's purpose.

For execution focus: "If you make [specific change] in [Area A], what happens in [Area B]?"
For leadership focus: "If [Area A] falls behind schedule, how should you adjust priorities in [Area B]?"
For evaluation focus: "When assessing maturity in [Area A], what does it tell you about likely state of [Area B]?"

Question constraints:
- Use terms from the orient map — don't introduce concepts they haven't seen
- 3 questions exactly, one of each type, in the order above
- All questions and options in the user's language
- Difficulty sits just above current_state — challenging but not alien

### Step 4: After Each Answer — 3-Layer Thinking Expansion

This is the core of the skill. Each layer opens the learner's thinking one level deeper rather than closing it with an answer.

**Layer 1 — Surface the reasoning**
Make explicit the assumption hidden in their choice. The learner selected an option for a reason, but that reason may be unconscious. Name it.

"[선택지]를 선택하셨군요 — 그렇다면 [underlying assumption]라고 가정하고 계신 셈입니다."

Connect to their current_state: "This assumption makes sense given your [current state experience], where [that assumption IS true]."

**Layer 2 — Shift the perspective**
Hint that practitioners (at the target level) see this through a different lens — but only name the lens, don't look through it. One to two sentences maximum.

"한편, [target_state level의 practitioners]은 이 상황을 [name of different frame]으로 보는 경향이 있습니다."

Good: "데이터 플랫폼 아키텍트들은 이것을 '쿼리 성능 문제'가 아니라 '데이터 모델링 문제'로 봅니다."
Bad: "아키텍트들은 이것을 데이터 모델링 문제로 보는데, 왜냐하면 스타 스키마와 스노우플레이크 스키마의 차이가..." — this explains the frame, closing the curiosity gap.

**Layer 3 — Open a deeper question**
Pose a follow-up question the learner can't answer yet but will be equipped to answer after reading the knowledge document. Connect it to their purpose.

"그렇다면, [your purpose]을 위해 [deeper question that connects to the gap between current and target state]은 어떨까요?"

Feedback constraints:
- Never judge correctness (that's verify's job)
- Never reveal answers
- All three layers for every question — don't skip any
- The perspective shift must be genuinely different from the learner's implied frame
- Layer 1 should validate why their assumption is reasonable given their background, before Layer 2 shifts it

### Step 5: Wrap Up — Collect the Open Questions

After all 3 rounds, gather the three open questions (Layer 3 from each round):

```
## 생각해볼 질문들

지식 문서를 읽으면서 다음 질문들을 머릿속에 두고 보세요:

1. [Open question from Q1]
2. [Open question from Q2]
3. [Open question from Q3]

이 질문들에 대한 여러분의 생각이 읽기 전과 후에
어떻게 달라지는지 관찰해보세요.
```

**Do not save any file.** Prime produces no file artifact — its output lives in the learner's activated thinking.

## Rules

- All interaction is in the user's language
- No file output — purely conversational
- Never introduce domain concepts that aren't already in the orient map
- Never judge answers as right or wrong
- The 3-layer feedback structure is mandatory for every question
- Question difficulty is calibrated to the current_state → target_state gap, not to a fixed "beginner" level
- If the orient map is sparse (fewer than 3 areas or no anchor points), work with what's available
- Layer 1 should acknowledge why the learner's assumption is reasonable given their background — this builds trust and makes the perspective shift in Layer 2 more impactful
