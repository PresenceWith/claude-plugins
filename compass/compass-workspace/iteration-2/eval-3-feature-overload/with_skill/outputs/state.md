# Goal
모바일 피트니스 트래킹 앱 기획 — 운동 기록, 식단 관리, 소셜, 챌린지, 코칭 AI, 웨어러블 연동, 결제, 오프라인 모드, 다국어 지원을 포함하는 종합 피트니스 앱.

# Elements
- 운동기록 [type: feature, core]
- 식단관리 [type: feature, core]
- 소셜기능 [type: feature]
- 챌린지 [type: feature]
- 코칭AI [type: feature]
- 웨어러블연동 [type: feature]
- 결제 [type: infrastructure]
- 오프라인모드 [type: infrastructure]
- 다국어지원 [type: infrastructure]

# Relations
- 챌린지 →depends-on→ 운동기록
- 챌린지 →depends-on→ 소셜기능
- 코칭AI →depends-on→ 운동기록
- 코칭AI →depends-on→ 식단관리
- 웨어러블연동 →communicates-with→ 운동기록
- 결제 →enables→ 코칭AI
- 소셜기능 →depends-on→ 운동기록

# Decided
(none yet)

# Undecided
- 핵심 기능 범위: [운동기록의 구체적 범위 | 식단관리의 구체적 범위] (Related: 운동기록, 식단관리)
- 차별화 전략: [코칭AI 중심 | 소셜/챌린지 중심 | 웨어러블 중심] (Related: 코칭AI, 소셜기능, 챌린지, 웨어러블연동)
- 수익 모델: [구독 | 프리미엄 | 인앱결제 | 광고] (Related: 결제)
- 오프라인 범위: [전체 기능 오프라인 | 핵심만 오프라인 | 읽기만 오프라인] (Related: 오프라인모드)
- 다국어 범위: [출시 시 지원 언어 | 지역화 수준] (Related: 다국어지원)
- 기술 스택: [네이티브 | 크로스플랫폼 | 하이브리드] (Related: all)
- 타겟 사용자: [초보자 | 중급자 | 전문가 | 전체] (Related: all)
- MVP 범위: [어떤 기능까지 1차 출시에 포함할지] (Related: all)
- 개발 우선순위: [기능 개발 순서] (Related: all)

# Active Discussion
- 9개 기능의 우선순위 정리 — 핵심/차별화/인프라로 분류 완료, 사용자에게 핵심 기능(운동기록 vs 식단관리) 중 탐색 시작점 선택을 요청한 상태

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
- Diagnostic triggers fired: Focus Narrowing, Core Summary, Information Limiting
- Interventions applied: 9개 기능을 3개 층으로 그룹화(정보 제한), 핵심 2개로 초점 축소(포커스 내로잉), 사용자에게 선택권 반환(에이전시 보존)
