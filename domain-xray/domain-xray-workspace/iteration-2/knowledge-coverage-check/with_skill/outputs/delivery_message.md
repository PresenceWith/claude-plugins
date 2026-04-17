# Delivery Message

## 핵심 인사이트 (가장 반직관적인 발견들)

1. **분석용 데이터 모델링에서 정규화는 미덕이 아니라 장애물이다.** 백엔드에서 배운 3NF 정규화를 웨어하우스에 그대로 적용하면, 단순한 "월별 카테고리별 매출" 질문에 7개 테이블 JOIN이 필요해지고, 분석가마다 다른 숫자를 내놓는 혼란이 발생한다. 의도적 비정규화(denormalization)가 분석 세계의 설계 원칙이다.

2. **파이프라인의 "시간"은 최소 세 가지이다.** Event time, processing time, ingestion time이 수 시간에서 수일까지 차이 날 수 있다. "어제 데이터를 처리한다"의 기준이 모호하면 데이터 누락과 중복이 동시에 발생한다.

3. **Full refresh가 가능하면 증분 처리보다 full refresh부터 시작하라.** 증분 처리는 복잡하고 버그가 숨기 쉽다. `updated_at` 컬럼의 신뢰성 문제로 6주간 데이터 누락을 모르고 지나가는 실사례가 이를 증명한다.

4. **데이터 품질 문제의 80%는 단 세 가지 — null, 중복, 타이밍.** 정교한 검증 시스템을 구축하기 전에 이 세 가지에 대한 체크만 넣어도 대부분의 사고를 예방할 수 있다.

5. **Grain 정의가 모호하면 모든 숫자가 틀린다.** Fact 테이블에서 "한 행이 무엇을 의미하는가"를 먼저 정하지 않으면, SUM(amount)이 주문 총액을 중복 합산하는 식의 치명적 오류가 조용히 발생한다.

## 파일 저장 위치

`domain-knowledge-data-engineering.md` — 전체 지식 문서 (Coverage 섹션 포함)

저장 경로: `/Users/presence/dev/4_Active/claude-plugins/domain-xray/domain-xray-workspace/iteration-2/knowledge-coverage-check/with_skill/outputs/`

## 다음 단계

문서를 읽은 후 `/domain-verify`를 실행하면, 시나리오 기반 문제를 통해 암묵지를 실제로 내면화했는지 점검할 수 있습니다.
