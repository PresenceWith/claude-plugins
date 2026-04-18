---
name: system-map
description: Abstract a situation, conversation, or working context into a system — declare boundary and environment, name the constraints that prevent drift, name elements at the role level (not by proper noun) distinguishing stock vs flow, trace relationships as feedback loops with polarity and delay, identify emergent function that does not reduce to individual parts, state the purpose the system actually achieves and how the nominal/actual gap is maintained, and pair failure mode with leverage point. Use this skill whenever the user asks to "시스템으로 추상화", "시스템 관점으로", "구조로 추상화", "메타적 매핑", "system abstract", "systemize this", "map this as a system", "structure-level view", "meta-map", or requests a concept-level (not example-level) structural reading of a situation. Also trigger when the user names themselves or the current conversation as the target ("지금 이 대화", "우리가 지금 하는 것", "이 작업 방식", "내가 지금", "this session") — that is meta-mode. Do NOT use for concrete how-to questions, domain-specific problem solving, implementation tasks, or when the user wants a narrative explanation — this skill produces structural abstraction, not walkthroughs. Prefer triggering over under-triggering when structural abstraction is plausibly what the user wants.
---

# system-map — 상황을 시스템으로 추상화하라

## STEP 0. 모드 판정

입력을 읽고 모드와 근거를 한 줄씩.

- **외부 모드**: 분석 대상이 외부 상황·조직·사건·도메인.
- **메타 모드**: 분석 대상이 *지금 이 대화/작업/세션* 자체. 관찰자도 시스템의 한 요소.

모호하면 양쪽 경계를 제시 후 외부 모드 기본 진행.

## STEP 1. 경계·환경·관찰자

세 축을 짧게.

- **경계 (boundary)**: 무엇을 시스템 안에 두는가. 객관 사실이 아니라 *분석 목적에 따른 절단*. 그 사실을 한 줄로 명시.
- **환경 (environment)**: 경계 *바깥 중 이 시스템이 의존하는 것* 1~3개. 그냥 바깥이 아니라 *입력을 주는 바깥*. 경계 선언과 짝.
- **관찰자 위치 (positionality)**: 이 추상화를 *누가/어떤 이유로* 요청했는가 한 줄. 외부 모드면 간단히, 메타 모드면 필수.

환경 없이 경계만 있으면 시스템은 진공에 떠 있는 것처럼 보인다. 피하라.

## STEP 1.5. 제약 (constraints)

이 시스템이 *위반할 수 없는 것* 2~3개. 힘·자원이 아니라 *금지·한계·고착*이다.

- 물리적·시간적 한도: "이 회의는 15분을 넘지 않는다"
- 규칙·계약: "하위 요소는 상위 요소를 직접 수정할 수 없다"
- 역사적 고착: "이전에 선택된 규약이 현재 선택을 제한한다"

제약은 많은 구조를 *힘이 아니라 닫힘*으로 설명한다. 제약이 바뀌면 구조도 바뀐다.

## STEP 2. 요소 (elements) — 3~5개, 역할어로

역할 수준 개념어로만. 고유명사·제품명·인명 금지.

각 요소를 **stock(저장)** 또는 **flow(흐름)** 로 구분. 같은 대상이 양쪽일 수 없다.

- **stock**: 상태를 *누적·보관*하는 자리 (예: 누적 기억층, 문제 대기열)
- **flow**: 상태 사이를 *이동*하는 변화 (예: 규약 개정, 상태 보고)

| 요소 (역할어) | 유형 (stock/flow) | 역할 정의 |
|---|---|---|

요소 수는 5개를 넘지 않는다. 넘으면 묶을 여지가 있다는 뜻.

앵커(이 상황의 예시)는 **기본 비공개**. 역할어 정의만으로 의미가 통해야 한다. 통하지 않으면 이름이 아직 구체어에 오염된 상태. 사용자가 앵커를 요청할 때만 열 추가.

## STEP 3. 관계 — 피드백 루프 (극성·지연 필수)

화살표 표기에 세 가지를 의무적으로 붙인다:

- **전달물** (무엇이 오가는가): 정보/자원/권한/상태 등 한 단어
- **지연 (delay)**: `즉시` / `턴내` / `지연` — 언제 도착하는가
- **극성 (polarity)** — 루프 수준: `강화 (+)` / `상쇄 (−)`, 그리고 **왜 이 극성인가**를 한 줄로 명시. 근거 없는 극성 라벨 금지.

**피드백 루프 최소 1개 필수.** 루프가 없는 구조는 시스템이 아니라 집합이다.

형식 예:
```
L1 (강화): A →[상태, 즉시]→ B →[해석, 턴내]→ A
  왜 강화인가: A의 출력 증가가 B의 해석 부담을 늘리고, 그 부담이 다시 A의 출력 형식을 단순화시켜 A의 출력을 더 증가시킨다.
```

## STEP 4. 기능 (function) — 창발

이 관계 구조에서 *개별 요소로 환원되지 않는* 것이 무엇인가.

두 축으로 검증:
- **제거 테스트**: 임의 요소 하나를 빼면 같은 기능이 유지되는가? 유지되면 창발 아님.
- **비창발 대비**: 요소 기능의 *단순 합*으로 설명되는 것을 1~2개 짧게 적고, 창발이 그것과 *무엇이 다른가*를 한 줄. 대비가 없으면 창발이 뚜렷해지지 않는다.

기능은 "무엇이 발생하는가". 평가·판정 금지.

## STEP 5. 목적 — 달성되는 것 + 유지 기제

- **명목 목적**: 공식·의도된 목표 한 줄.
- **실질 목적**: 이 구조가 *사실상 달성하고 있는* 것 한 줄.
- **간격의 구조적 원인**: 왜 둘이 어긋나는가 한 줄.
- **간격의 유지 기제**: 그 간격이 *왜 스스로 유지되는가* 한 줄. 어떤 루프가 어긋남을 매 주기 재생산하는지.

간격이 *원인만* 있고 유지 기제가 없으면 시스템 분석이 정적 스냅샷에 머문다.

기능(STEP 4)과 목적(STEP 5)을 혼동 말 것. 기능 = 발생. 목적 = 달성.

## STEP 6. 취약점·레버리지 (짝)

두 항목만. 같은 구조의 양면으로 묶어 기술한다.

- **취약점 (failure mode)**: 이 시스템이 붕괴·탈선하는 경로 1~2개. "어떤 입력/부하/변동이 이 구조를 무너뜨리는가". Requisite variety(시스템의 대응 변이 폭) 관점에서 *환경 변이가 시스템 대응 범위를 초과하는 지점*을 본다.
- **레버리지 포인트 (leverage point)**: 작은 개입으로 구조가 *질적으로* 바뀌는 지점 1~2개. 취약점의 *반대면*. 어디에 작은 비틀림을 주면 L1/L2 극성이 뒤집히거나 경계·제약이 재설정되는가.

주의: 레버리지 기술은 *처방*이 아니라 *지점의 지명*이다. "해야 한다"가 아니라 "여기가 구조적 변곡점이다".

층위·불변·동역학 같은 일반 확장은 이 스킬에서 제거. 꼭 필요하면 자유롭게 단락 추가하되 기본 골격은 위 6단계.

## STEP 7. 자기 지시 처리 (메타 모드 한정)

- 이 추상화 행위도 시스템의 한 작동임을 한 줄.
- 재귀는 1차에서 멈춘다 — 이 응답을 요소로 인정하되 "이 응답을 다시 추상화하는 행위"는 요청 시에만.
- 관찰자 효과 한 줄: 이 추상화가 다음 턴 시스템 상태에 입력된다는 사실.

---

## 출력 규약

- 개념어 1차. 앵커는 기본 숨김, 요청 시 추가.
- 표·짧은 불릿 중심. 서사 금지.
- STEP 0(모드) → STEP 1(경계·환경·관찰자) → STEP 1.5(제약) 순서로 *먼저 틀*을 세운 뒤 요소로 진입.
- 피드백 루프 극성에 "왜" 없으면 미완성. 지연 라벨 없으면 미완성.
- 마지막 한 줄: **"이 시스템 관점에서 지금 물을 수 있게 된 것"** — 한 문장.

## 실패 모드 (상위 5)

1. 요소만 있고 관계·루프 빈약 → 시스템 X, 집합 O
2. 고유명사·도구명이 요소 이름에 남음
3. 피드백 루프 극성에 *왜*가 없음, 지연 라벨이 없음
4. 기능(STEP 4)과 목적(STEP 5)이 같은 수준에서 반복
5. 경계만 있고 환경·제약 없음 — 시스템이 진공에 뜸

전체 체크리스트 10개: [references/failure-modes.md](references/failure-modes.md)

## 모드별 참고

- 메타 모드 자기 지시·경계 절단 상세: [references/meta-mode.md](references/meta-mode.md)
