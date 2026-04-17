# Goal
피트니스 트래킹 모바일 앱 기획 — 뭐부터 해야 할지 방향 잡기

# Elements
- FitnessApp [type: product]
- 운동기록 [type: feature]
- 식단관리 [type: feature]
- 소셜기능 [type: feature]
- 챌린지 [type: feature]
- 코칭AI [type: feature]
- 웨어러블연동 [type: feature]
- 결제 [type: feature]
- 오프라인모드 [type: constraint]
- 다국어 [type: constraint]

# Relations
- FitnessApp →contains→ 운동기록
- FitnessApp →contains→ 식단관리
- FitnessApp →contains→ 소셜기능
- FitnessApp →contains→ 챌린지
- FitnessApp →contains→ 코칭AI
- FitnessApp →contains→ 웨어러블연동
- FitnessApp →contains→ 결제
- FitnessApp →contains→ 오프라인모드
- FitnessApp →contains→ 다국어
- 소셜기능 →depends-on→ 운동기록
- 챌린지 →depends-on→ 운동기록
- 챌린지 →depends-on→ 소셜기능
- 코칭AI →depends-on→ 운동기록
- 코칭AI →depends-on→ 식단관리
- 결제 →depends-on→ 챌린지
- 웨어러블연동 →depends-on→ 운동기록

# Decided
(none yet)

# Undecided
- MVP 범위: [어떤 기능을 1차에 넣을 것인가] (Related: 전체 기능)
- 기술 스택: [네이티브 | 크로스플랫폼 | 하이브리드] (Related: 오프라인모드, 웨어러블연동)
- 수익 모델: [구독 | 프리미엄 | 광고 | 하이브리드] (Related: 결제)
- 타겟 사용자: [초보자 | 중급자 | 전문가 | 전체] (Related: 코칭AI, 챌린지)
- 오프라인 범위: [전체 오프라인 | 부분 오프라인] (Related: 오프라인모드)
- AI 구현 방식: [자체 모델 | 외부 API | 규칙 기반] (Related: 코칭AI)
- 다국어 범위: [초기 지원 언어 수] (Related: 다국어)

# Active Discussion
- MVP 범위 설정 및 우선순위 정리

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
