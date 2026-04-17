# Goal
피트니스 트래킹 모바일 앱 기획 — 운동 기록, 식단 관리, 소셜 기능, 챌린지, 코칭 AI, 웨어러블 연동, 결제, 오프라인 모드, 다국어 지원

# Elements
- 운동기록 [type: feature]
- 식단관리 [type: feature]
- 소셜기능 [type: feature]
- 챌린지 [type: feature]
- 코칭AI [type: feature]
- 웨어러블연동 [type: feature]
- 결제 [type: feature]
- 오프라인모드 [type: constraint]
- 다국어지원 [type: constraint]

# Relations
- 챌린지 →depends-on→ 소셜기능
- 코칭AI →depends-on→ 운동기록
- 코칭AI →depends-on→ 식단관리
- 웨어러블연동 →communicates-with→ 운동기록
- 결제 →depends-on→ (미정: 어떤 기능이 유료인지)

# Decided
(없음)

# Undecided
- MVP 범위: [9개 기능 중 어디까지가 1차 출시?] (전체 기능 목록 관련)
- 타겟 사용자: [초보자 | 중급자 | 전문가 | 전체] (앱 방향성 결정에 영향)
- 플랫폼: [iOS | Android | 둘 다 | 크로스플랫폼] (기술 스택 결정에 영향)
- 수익 모델: [구독 | 프리미엄 | 광고 | 혼합] (결제 기능 범위에 영향)
- 기술 스택: [네이티브 | React Native | Flutter | 기타] (오프라인/웨어러블 구현에 영향)

# Active Discussion
- 전체 기능 목록 나열 완료, 우선순위 미정

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
