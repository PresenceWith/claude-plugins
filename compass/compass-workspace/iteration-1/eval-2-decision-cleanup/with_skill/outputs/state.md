# Goal
내부 도구 개발 프로젝트의 기술 의사결정 정리 — 무엇이 확정되었고, 무엇이 미결인지 명확히 구분하여 팀의 의사결정 역량을 회복한다.

# Elements
- 사용자인증 [type: architecture]
- 데이터베이스 [type: data]
- 프론트엔드 [type: architecture]
- API구조 [type: architecture]
- 배포전략 [type: process]
- 모니터링 [type: process]
- CI/CD파이프라인 [type: process]

# Relations
- 프론트엔드 →communicates-with→ API구조
- API구조 →depends-on→ 데이터베이스
- API구조 →depends-on→ 사용자인증
- 배포전략 →depends-on→ CI/CD파이프라인
- 모니터링 →depends-on→ 배포전략

# Decided
- 사용자인증: OAuth 방식 채택 (팀 합의)
- 프론트엔드: React 확정 (팀 합의)

# Undecided
- 데이터베이스: [PostgreSQL | MongoDB] (Related elements: API구조)
- API구조: [REST | GraphQL] (Related elements: 프론트엔드, 데이터베이스)
- 배포전략: 아직 논의 미시작 (Related elements: CI/CD파이프라인, 모니터링)
- 모니터링: 도구/전략 미정 (Related elements: 배포전략)
- CI/CD파이프라인: 도구/전략 미정 (Related elements: 배포전략)

# Active Discussion
- 전체 의사결정 현황 정리 및 우선순위 설정

# Meta
- Created: 2026-03-29
- Last sync: 2026-03-29 00:00
- Conversation turns since last sync: 1
