# Goal
피트니스 트래킹 모바일 앱 기획 — 운동 기록, 식단 관리, 소셜, 챌린지, AI 코칭, 웨어러블, 결제, 오프라인, 다국어를 포함하는 종합 피트니스 플랫폼.

# Elements
- 운동기록 [type: feature]
- 식단관리 [type: feature]
- 소셜기능 [type: feature]
- 챌린지 [type: feature]
- 코칭AI [type: feature]
- 웨어러블연동 [type: feature]
- 결제시스템 [type: feature]
- 오프라인모드 [type: constraint]
- 다국어지원 [type: constraint]

# Relations
- 챌린지 →depends-on→ 소셜기능
- 코칭AI →depends-on→ 운동기록
- 코칭AI →depends-on→ 식단관리
- 웨어러블연동 →communicates-with→ 운동기록
- 결제시스템 →precedes→ 챌린지
- 오프라인모드 →affects→ 운동기록
- 오프라인모드 →affects→ 식단관리

# Decided
(없음)

# Undecided
- 앱의 핵심 가치: [운동 중심 | 식단 중심 | 소셜 중심 | 종합] (전체 방향 결정 필요)
- 우선순위 기준: [사용자 가치 | 기술 난이도 | 시장 차별화] (무엇을 기준으로 순서를 정할지)
- MVP 범위: [최소 기능 | 중간 | 전체] (첫 출시에 어디까지 넣을지)
- 타겟 사용자: [초보자 | 중급자 | 전문가 | 전체] (Related elements: 모든 기능)
- 기술 스택: 미정 (Related elements: 오프라인모드, 웨어러블연동)

# Active Discussion
- 전체 기능 목록 정리 및 우선순위 결정

# Meta
- Created: 2026-03-29
- Last sync: 2026-03-29 00:00
- Conversation turns since last sync: 1
