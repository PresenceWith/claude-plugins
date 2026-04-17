# Goal
내부 도구 개발 프로젝트의 기술 스택과 아키텍처 결정 사항을 정리하고, 결정된 것과 미결정 사항을 명확히 구분한다.

# Elements
- 사용자인증 [type: architecture]
- 데이터베이스 [type: data]
- 프론트엔드 [type: architecture]
- 배포전략 [type: process]
- API구조 [type: architecture]
- 모니터링 [type: process]
- CI/CD파이프라인 [type: process]

# Relations
- 프론트엔드 →communicates-with→ API구조
- API구조 →depends-on→ 데이터베이스
- 사용자인증 →depends-on→ API구조
- 배포전략 →depends-on→ CI/CD파이프라인
- 모니터링 →depends-on→ 배포전략

# Decided
- 사용자인증: OAuth 방식 채택 (팀 합의)
- 프론트엔드: React 확정 (팀 합의)

# Undecided
- 데이터베이스: [PostgreSQL | MongoDB] (Related elements: API구조, 사용자인증)
- API구조: [REST | GraphQL] (Related elements: 프론트엔드, 데이터베이스, 사용자인증)
- 배포전략: 아직 논의 시작 안 함 (Related elements: CI/CD파이프라인, 모니터링)
- 모니터링: 아직 구체적 논의 없음 (Related elements: 배포전략)
- CI/CD파이프라인: 아직 구체적 논의 없음 (Related elements: 배포전략)

# Active Discussion
- 기술 스택 결정 사항 전체 정리

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
