# Domain Prime — Simulated Session
**Orient map**: domain-orient-data-engineering.md
**Learner**: 백엔드 개발자, 데이터팀 협업 필요

---

## Q1 — Prediction

데이터 파이프라인 설계에서 경험 많은 데이터 엔지니어가 백엔드 출신 초보의 **가장 흔한 실수**로 꼽을 것은 무엇일까요?

- **A.** SQL 쿼리 최적화를 소홀히 해서 파이프라인이 느려지는 것
- **B.** 파이프라인 실패 시 복구 전략 없이 "성공 경로"만 설계하는 것
- **C.** ETL과 ELT의 차이를 모르고 잘못된 패턴을 선택하는 것

---

### User picks: B

### 3-Layer Thinking Expansion

**Layer 1 — Surface the reasoning**

B를 선택하셨군요 — 그렇다면 파이프라인의 핵심 난이도가 "정상 작동"이 아니라 "실패 대응"에 있다고 가정하고 계신 셈입니다. 백엔드에서 에러 핸들링의 중요성을 체감하셨기에 이 선택이 자연스러웠을 겁니다.

**Layer 2 — Shift the perspective**

전문가들은 이것을 '에러 핸들링 문제'가 아니라 'idempotency 설계 문제'로 봅니다.

**Layer 3 — Open a deeper question**

그렇다면, 파이프라인이 중간에 실패했을 때 "처음부터 다시 돌려도 결과가 같으려면" 각 단계가 어떤 속성을 가져야 할까요?

---

## Q2 — Connection

당신의 **백엔드 API 설계** 경험 — 요청/응답 흐름, 입력 검증, 에러 처리 — 이 **데이터 품질 관리**와 가장 닮은 점은 무엇일까요?

- **A.** API에서 입력값을 validation하듯, 데이터도 각 단계에서 스키마와 값을 검증한다
- **B.** API 모니터링(응답 시간, 에러율)처럼, 데이터도 freshness와 completeness를 모니터링한다
- **C.** API 버전 관리처럼, 데이터도 schema drift를 관리해야 한다

---

### User picks: A

### 3-Layer Thinking Expansion

**Layer 1 — Surface the reasoning**

A를 선택하셨군요 — 그렇다면 데이터 품질의 핵심이 "입구에서 나쁜 것을 걸러내는 것"이라고 가정하고 계신 셈입니다. API에서 request validation이 첫 번째 방어선이었던 경험이 이 직관을 만들었을 겁니다.

**Layer 2 — Shift the perspective**

전문가들은 이것을 '검증 문제'가 아니라 'data contract 문제'로 봅니다.

**Layer 3 — Open a deeper question**

그렇다면, 데이터를 보내는 쪽(upstream)이 예고 없이 스키마를 바꿔버렸을 때 — API와 달리 "400 Bad Request"를 돌려보낼 수 없는 상황에서 — 파이프라인은 어떻게 스스로를 보호할 수 있을까요?

---

## Q3 — Relationship

**데이터 스토리지 아키텍처**(Area 2)에서의 잘못된 선택이 **실시간 데이터 처리**(Area 5)에 미치는 가장 큰 영향은 무엇일까요?

- **A.** 잘못된 파티셔닝 전략이 실시간 쿼리 성능을 수십 배 저하시킨다
- **B.** 배치 중심 스토리지(예: Parquet)를 선택하면 실시간 처리 결과를 저장할 적절한 곳이 없어진다
- **C.** schema-on-write를 선택하면 스트리밍 데이터의 유연한 스키마 변화를 수용하지 못한다

---

### User picks: C

### 3-Layer Thinking Expansion

**Layer 1 — Surface the reasoning**

C를 선택하셨군요 — 그렇다면 스토리지와 스트리밍의 충돌 지점이 "스키마 유연성"이라고 가정하고 계신 셈입니다. 백엔드에서 DB 마이그레이션의 고통을 겪어보셨기에, 엄격한 스키마가 빠르게 변하는 데이터와 충돌할 것이라는 직관이 작동한 것 같습니다.

**Layer 2 — Shift the perspective**

전문가들은 이것을 '스키마 유연성 문제'가 아니라 '저장 계층 분리(lambda/kappa architecture) 문제'로 봅니다.

**Layer 3 — Open a deeper question**

그렇다면, 같은 데이터가 실시간으로도 배치로도 처리되어야 할 때, 두 경로의 결과가 "결국 같은 답"을 내도록 보장하려면 스토리지를 어떻게 설계해야 할까요?

---

## 생각해볼 질문들

지식 문서를 읽으면서 다음 질문들을 머릿속에 두고 보세요:

1. 파이프라인이 중간에 실패했을 때 "처음부터 다시 돌려도 결과가 같으려면" 각 단계가 어떤 속성을 가져야 할까요?
2. 데이터를 보내는 쪽(upstream)이 예고 없이 스키마를 바꿔버렸을 때 — API와 달리 "400 Bad Request"를 돌려보낼 수 없는 상황에서 — 파이프라인은 어떻게 스스로를 보호할 수 있을까요?
3. 같은 데이터가 실시간으로도 배치로도 처리되어야 할 때, 두 경로의 결과가 "결국 같은 답"을 내도록 보장하려면 스토리지를 어떻게 설계해야 할까요?

이 질문들에 대한 여러분의 생각이 읽기 전과 후에
어떻게 달라지는지 관찰해보세요.
