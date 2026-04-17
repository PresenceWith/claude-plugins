# Goal
피트니스 트래킹 모바일 앱 기획 — 운동 기록, 식단 관리, 소셜, 챌린지, 코칭 AI, 웨어러블 연동, 결제, 오프라인, 다국어 지원

# Elements
- 피트니스앱 [type: concept, level: core]
- 운동기록 [type: feature, level: core]
- 식단관리 [type: feature, level: core]
- 소셜기능 [type: feature, level: core]
- 챌린지 [type: feature, level: core]
- 코칭AI [type: feature, level: core]
- 웨어러블연동 [type: feature, level: core]
- 결제시스템 [type: feature, level: core]
- 오프라인모드 [type: constraint, level: core]
- 다국어지원 [type: constraint, level: core]
- 운동종류관리 [type: feature, level: detail, parent: 운동기록]
- GPS트래킹 [type: feature, level: detail, parent: 운동기록]
- 세트/반복기록 [type: feature, level: detail, parent: 운동기록]
- 칼로리계산 [type: feature, level: detail, parent: 식단관리]
- 식단DB [type: data, level: detail, parent: 식단관리]
- 바코드스캔 [type: feature, level: detail, parent: 식단관리]
- 피드/타임라인 [type: feature, level: detail, parent: 소셜기능]
- 친구추가 [type: feature, level: detail, parent: 소셜기능]
- 운동공유 [type: feature, level: detail, parent: 소셜기능]
- 주간챌린지 [type: feature, level: detail, parent: 챌린지]
- 리더보드 [type: feature, level: detail, parent: 챌린지]
- 배지시스템 [type: feature, level: detail, parent: 챌린지]
- 운동추천 [type: feature, level: detail, parent: 코칭AI]
- 자세피드백 [type: feature, level: detail, parent: 코칭AI]
- 목표설정 [type: feature, level: detail, parent: 코칭AI]
- 심박수 [type: data, level: detail, parent: 웨어러블연동]
- HealthKit/GoogleFit [type: architecture, level: detail, parent: 웨어러블연동]
- 블루투스연결 [type: architecture, level: detail, parent: 웨어러블연동]
- 구독모델 [type: feature, level: detail, parent: 결제시스템]
- 인앱결제 [type: architecture, level: detail, parent: 결제시스템]
- 로컬DB동기화 [type: architecture, level: detail, parent: 오프라인모드]
- 캐시전략 [type: architecture, level: detail, parent: 오프라인모드]
- i18n프레임워크 [type: architecture, level: detail, parent: 다국어지원]
- RTL지원 [type: constraint, level: detail, parent: 다국어지원]

# Relations
- 운동기록 →communicates-with→ 웨어러블연동
- 운동기록 →feeds-data-to→ 코칭AI
- 식단관리 →feeds-data-to→ 코칭AI
- 소셜기능 →contains→ 챌린지
- 챌린지 →depends-on→ 소셜기능
- 코칭AI →depends-on→ 운동기록
- 코칭AI →depends-on→ 식단관리
- 웨어러블연동 →feeds-data-to→ 운동기록
- 결제시스템 →gates→ 코칭AI
- 오프라인모드 →constrains→ 운동기록
- 오프라인모드 →constrains→ 식단관리
- 다국어지원 →constrains→ 소셜기능

# Decided
(없음 — 첫 기획 단계)

# Undecided
- 기술스택: [React Native | Flutter | Swift+Kotlin] (관련: 오프라인모드, 웨어러블연동)
- 수익모델: [프리미엄 | 구독 | 하이브리드] (관련: 결제시스템, 코칭AI)
- AI모델: [온디바이스 | 클라우드 | 하이브리드] (관련: 코칭AI, 오프라인모드)
- MVP범위: [핵심3기능 | 전체기능] (관련: 전체)

# Active Discussion
- 전체 기능 범위 정리 및 브레인스토밍

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 12:00
- Conversation turns since last sync: 1
