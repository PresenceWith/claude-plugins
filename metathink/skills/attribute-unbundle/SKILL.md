---
name: attribute-unbundle
description: Decomposes a pile of observations, notes, interview transcripts, requirement fragments, or sensory descriptions into a three-layer Perspective → Entity → Dimension·Value structure, separating tangled attribute axes from their values and isolating ambiguous/causal statements. Use this skill whenever the user has raw observations that need structural unpacking — including phrases like "축으로 분해", "속성별로 정리", "관점 잡고 풀어봐", "해상도 올려", "decompose into dimensions", "axis breakdown", "unpack observations", "break this down by attribute", or when tangled adjective-noun phrases like "은은한 주황색 조명" need their attributes separated. Trigger this after exploratory reading or research when raw notes need a structural pass, or when the user wants to raise the resolution of their observations so each attribute becomes an independently manipulable unit. Do NOT trigger for meta-analysis of conversation framing (use frame-break instead), for decision-making, for causal modeling across axes, or when no clear Perspective can be stated — in that last case the skill will gate and ask first.
---

내용에서 **Perspective**(왜 보는가) 아래의 **Entity**(무엇을)를 찾고, 각 Entity를 **Dimension**(`<Entity>의 <속성>`)과 **Value**로 분해한 뒤 사고를 확장한다. Perspective가 불명확하면 먼저 질문합니다.

> `분위기 좋은 카페` 관점에서 `조명` → `색깔=주황`, `세기=은은함` ("은은한 주황색 조명" 한 관측의 복수 차원은 분리)

## Output

**Perspective**: …

Entity마다 아래 블록을 반복한다.

### Entity: `<이름>`
| 원문 | Dimension | Value |
|---|---|---|

**추가 Dimension** — 같은 관점에서 뻗을 축
**Value 스펙트럼** — 각 Dimension의 대안값
**모호성** — 복수 해석 가능한 관측·관계 (해당 시)

## Rules
- Dimension은 속성 축만. Value 금지. ❌`따뜻한 조명` ✅`조명의 색온도=따뜻함`
- 관측이 인과·종속 관계를 품으면 병렬 행으로 접지 말고 모호성에 명시. 예: "사람이 없어서 조용함"은 `밀도→소음` 인과.
