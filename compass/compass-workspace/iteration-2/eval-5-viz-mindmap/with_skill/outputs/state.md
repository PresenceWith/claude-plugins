# Goal
피트니스 트래킹 모바일 앱 기획 — 운동 기록, 식단 관리, 소셜 기능, 챌린지, 코칭 AI, 웨어러블 연동, 결제, 오프라인 모드, 다국어 지원을 포함하는 종합 피트니스 플랫폼.

# Elements
- 운동 기록 [type: feature] {core}
- 식단 관리 [type: feature] {core}
- 소셜 기능 [type: feature] {core}
- 챌린지 [type: feature] {core}
- 코칭 AI [type: feature] {core}
- 웨어러블 연동 [type: feature] {core}
- 결제 시스템 [type: feature] {core}
- 오프라인 모드 [type: constraint] {core}
- 다국어 지원 [type: constraint] {core}
- 운동 루틴 관리 [type: feature] {detail, parent: 운동 기록}
- 세트/반복 트래킹 [type: feature] {detail, parent: 운동 기록}
- GPS 러닝 트래킹 [type: feature] {detail, parent: 운동 기록}
- 칼로리 계산 [type: feature] {detail, parent: 식단 관리}
- 식단 사진 인식 [type: feature] {detail, parent: 식단 관리}
- 영양소 분석 [type: feature] {detail, parent: 식단 관리}
- 친구 피드 [type: feature] {detail, parent: 소셜 기능}
- 그룹 운동 [type: feature] {detail, parent: 소셜 기능}
- 응원/댓글 [type: feature] {detail, parent: 소셜 기능}
- 주간/월간 챌린지 [type: feature] {detail, parent: 챌린지}
- 리더보드 [type: feature] {detail, parent: 챌린지}
- 보상 시스템 [type: feature] {detail, parent: 챌린지}
- 운동 추천 [type: feature] {detail, parent: 코칭 AI}
- 식단 추천 [type: feature] {detail, parent: 코칭 AI}
- 진행 분석 [type: feature] {detail, parent: 코칭 AI}
- Apple Watch [type: feature] {detail, parent: 웨어러블 연동}
- Galaxy Watch [type: feature] {detail, parent: 웨어러블 연동}
- Fitbit/Garmin [type: feature] {detail, parent: 웨어러블 연동}
- 구독 결제 [type: feature] {detail, parent: 결제 시스템}
- 인앱 구매 [type: feature] {detail, parent: 결제 시스템}
- 무료 티어 [type: feature] {detail, parent: 결제 시스템}
- 로컬 데이터 캐싱 [type: feature] {detail, parent: 오프라인 모드}
- 동기화 큐 [type: feature] {detail, parent: 오프라인 모드}
- i18n 프레임워크 [type: feature] {detail, parent: 다국어 지원}
- RTL 지원 [type: feature] {detail, parent: 다국어 지원}

# Relations
- 운동 기록 →communicates-with→ 웨어러블 연동
- 코칭 AI →depends-on→ 운동 기록
- 코칭 AI →depends-on→ 식단 관리
- 챌린지 →depends-on→ 소셜 기능
- 챌린지 →contains→ 리더보드
- 보상 시스템 →depends-on→ 결제 시스템
- 소셜 기능 →depends-on→ 오프라인 모드
- 운동 기록 →depends-on→ 오프라인 모드
- GPS 러닝 트래킹 →communicates-with→ 웨어러블 연동
- 식단 사진 인식 →depends-on→ 코칭 AI
- 다국어 지원 →affects→ 소셜 기능
- 다국어 지원 →affects→ 결제 시스템

# Decided
(None yet — initial brainstorming phase)

# Undecided
- 기술 스택: [React Native | Flutter | Native] (Related: 오프라인 모드, 웨어러블 연동)
- 수익 모델: [프리미엄 | 구독 | 광고+인앱] (Related: 결제 시스템, 무료 티어)
- AI 엔진: [자체 개발 | 외부 API | 하이브리드] (Related: 코칭 AI)
- MVP 범위: [어떤 기능을 1차에 포함할 것인가] (Related: 전체)
- 타겟 시장: [국내 우선 | 글로벌 동시] (Related: 다국어 지원)

# Active Discussion
- 전체 기능 범위 브레인스토밍 및 구조화

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
