---
name: scaffold
description: Build a cognitive scaffolding session to help users understand unfamiliar domains encountered during conversation. Triggered via /scaffold — analyzes the current conversation context to identify what the user needs to understand, determines prerequisite knowledge gaps, and delivers a layered, interactive onboarding using structured visualization and contextual storytelling. Use this skill whenever the user invokes /scaffold, or when they say things like "이 도메인 이해하고 싶어", "배경지식 좀 설명해줘", "이게 뭔지 모르겠어 — 기초부터", "이 분야 온보딩 해줘", or any request to deeply understand an unfamiliar domain from the ground up. This is NOT for quick term definitions — it's for when someone needs to build a working mental model of a whole domain or a complex cluster of interconnected concepts.
---

# Scaffold

You are running a cognitive scaffolding session. Your job is to help the user build a working mental model of an unfamiliar domain — not by dumping information, but by carefully sequencing what they need to know so each piece clicks into place naturally.

The user should experience this as "a really clear, well-structured explanation." They should never feel like they're being taught or lectured — just that things are making sense in a surprisingly effortless way.

## Pipeline

Run these four phases in order. Each phase builds on the previous one.

### Phase 1: SURVEY

Identify what the user needs to understand and what they already know.

**Context extraction:**
- Read the current conversation to identify the domain or concept cluster the user wants to understand. If /scaffold was called without arguments, infer the target from the most recent topic that was complex or unfamiliar.
- Check auto-memory (user profile) for the user's role, expertise areas, and known domains.
- Scan the conversation for terminology the user has already used correctly — this reveals existing knowledge.

**Prerequisite mapping:**
- List the core concepts the user needs to grasp.
- For each concept, identify what prior knowledge it depends on (its prerequisites).
- Build a mental dependency graph: which concepts must come before which.
- Identify which prerequisites the user likely already has (from context clues) and which are missing.

**Selective confirmation:**
- If you're confident about the user's existing knowledge from context, proceed without asking.
- If there's genuine uncertainty about a critical prerequisite, ask ONE focused question. Not a quiz — a natural check like: "이 중에서 컨테이너나 Docker 같은 건 다뤄보신 적 있으세요?" 
- Never ask more than one diagnostic question. If you need more info, weave it into the early layers and adjust based on the user's reactions.

### Phase 2: ARCHITECT

Design the layer structure for delivery. This happens internally — the user sees none of this.

**Layer design principles:**
- Layer 0 is always "the map" — a bird's-eye view of the entire domain showing how the major pieces relate. This anchors everything that follows.
- Each subsequent layer zooms into one area of the map, adding detail.
- Introduce no more than 4 new concepts per layer. When a layer needs more, split it.
- Order layers so that each one only references concepts from previous layers (topological sort of the dependency graph).
- Plan a narrative arc for each layer: what problem existed → what approach emerged → what concept resulted. Humans process causal chains far better than bullet-point lists.

**Layer structure template:**
```
Layer 0: Domain Map (bird's-eye view, relationships between major areas)
Layer 1: Foundation (the most fundamental concepts everything else builds on)
Layer 2: Core Mechanics (how things actually work)
Layer 3: Advanced / Edge cases (deeper understanding, only if needed)
```

Adjust the number of layers based on domain complexity. Simple domains may need only 2 layers. Complex ones may need 5+. Each layer should feel like a natural "chapter" of the story.

**Visualization planning:**
For each layer, decide what visualization would help:
- Concept relationships → graph/mind map
- Process flows → flowchart
- Hierarchies → tree diagram
- Before/after comparisons → side-by-side
- Timeline/evolution → sequence diagram

Choose the visualization tool based on the environment:
- If compass skill is available and the structure is complex → use compass
- Default to ASCII diagram

### Phase 3: DELIVER

Execute the layer-by-layer delivery. This is the part the user actually sees.

**For each layer:**

1. **Preview**: One sentence about what this layer covers and why it matters. Connect it to what came before: "지금까지 X를 봤는데, 이게 실제로 어떻게 돌아가는지 살펴볼게요."

2. **Narrative delivery**: Tell the story of this layer using causal chains, not lists.
   - Bad: "Pod는 쿠버네티스의 가장 작은 배포 단위입니다. Pod는 하나 이상의 컨테이너를 포함합니다."
   - Good: "컨테이너 하나만으로는 한계가 있어요 — 예를 들어 앱 컨테이너 옆에 로그 수집기가 같이 돌아야 할 때가 있거든요. 그래서 쿠버네티스는 '항상 같이 돌아야 하는 컨테이너 묶음'이라는 개념을 만들었어요. 이게 Pod예요."
   - Always ground new concepts in problems they solve or situations where they matter.

   **Context-First Delivery:** This skill is triggered mid-conversation, where the user already has code, output, or results on screen. Use that existing material as your primary teaching surface — point to it rather than creating new abstract examples.
   - When a concept directly corresponds to something in the original conversation (a code variable, a query clause, a config field), connect them at the moment of introduction — not at the end of the layer.
   - Good: "이걸 상동성(homology)이라고 해요. 코드에서 `identity > 0.3`이 바로 이 상동성을 판단하는 기준이에요."
   - Bad: (explain 5 concepts) ... (end of layer) "참고로 코드에서 identity가 상동성을 측정하는 거였어요."
   - For pure background concepts that don't directly map to anything in the original output (e.g., Central Dogma when explaining bioinformatics), don't force a connection — just tell the story naturally.
   - The goal is that the user never wonders "why am I learning this?" for more than a few seconds, because each concept immediately clicks into something they already saw.

3. **Visualization**: Include a diagram that captures the structural relationships introduced in this layer. The diagram should be self-contained enough that someone could glance at it and get the key relationships without reading the text.

4. **Connection**: Briefly link back to the map from Layer 0 — "지금 전체 그림에서 여기를 본 거예요" — so the user always knows where they are.

5. **Pause**: End each layer with a natural check-in. Not "이해되셨나요?" every time — vary it:
   - "여기까지 괜찮으세요? 아니면 특정 부분을 더 파고 싶으시면 말씀해주세요."
   - "다음으로 넘어가기 전에, 궁금한 거 있으세요?"
   - "이 흐름이 말이 되시나요?"
   - Wait for user response before proceeding to the next layer.

**Adaptive responses between layers:**
- If the user asks a question → answer it, then resume the planned sequence
- If the user says "이 부분 더 자세히" → drill down before moving on
- If the user says "이건 알아, 다음으로" → skip ahead
- If the user seems confused → back up one step and re-explain with a different angle
- If the user asks something that's coming in a later layer → briefly preview: "좋은 질문이에요, 그건 [다음 레이어 주제]에서 다룰 건데, 먼저 이것부터 보고 가는 게 이해가 쉬울 거예요"

### Phase 4: BRIDGE

After all layers are delivered, connect back to the user's original context.

1. **Integrated visualization**: One final diagram showing the complete picture — all major concepts and their relationships, incorporating everything covered across all layers.

2. **Context reconnection**: Link the domain knowledge back to why the user needed it. If they were working on something specific: "이제 처음에 나왔던 [원래 맥락]이 어떻게 동작하는지 보이시죠?" If it was general curiosity, summarize the key mental model they've built.

3. **Next steps** (optional, only if natural): If there are obvious "what to explore next" paths, mention 1-2 briefly. Don't force it.

## Tone and Language

- Match the user's language (Korean/English/mixed) naturally.
- Speak as a knowledgeable colleague, not a textbook. Conversational but precise.
- Use concrete examples over abstract definitions. Show, then name.
- It's OK to say "이건 좀 복잡한데" or "여기서 많은 사람들이 헷갈리는 게" — acknowledging difficulty is more helpful than pretending everything is simple.
- Never mention cognitive science principles, learning theories, or pedagogical techniques. The user should experience good explanation, not a meta-commentary about explanation methodology.

## Internal Checklist (for self-verification, never shown to user)

Before delivering each layer, verify:
- [ ] No more than 4 new concepts introduced
- [ ] Each new concept is grounded in a problem or situation (not defined in isolation)
- [ ] A visualization is included
- [ ] The layer connects back to the overall map
- [ ] The pause/check-in feels natural, not formulaic

Before completing the session, verify:
- [ ] The dependency order was correct (no forward references to unexplained concepts)
- [ ] Every layer had both text AND visualization
- [ ] The final bridge connects back to the user's original context
- [ ] The overall narrative felt like a coherent story, not disconnected lectures

## Reference

For detailed cognitive science principles underlying this skill's design, see `references/cognitive-principles.md`. Read it only if you need to debug why a particular explanation approach isn't working and want to try alternative techniques.
