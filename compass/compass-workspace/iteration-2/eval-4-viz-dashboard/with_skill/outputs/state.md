# Goal
내부 도구 개발 — 팀에서 만들고 있는 내부 도구의 기술 스택과 인프라 구성을 결정한다.
요구사항이 계속 변경되고 있어 결정된 사항과 미결 사항을 명확히 정리하는 것이 핵심.

# Elements
- UserAuth [type: architecture]
- Database [type: data]
- Frontend [type: architecture]
- APIStructure [type: architecture]
- DeployStrategy [type: process]
- Monitoring [type: architecture]
- CICDPipeline [type: process]

# Relations
- Frontend →communicates-with→ APIStructure
- APIStructure →depends-on→ Database
- APIStructure →depends-on→ UserAuth
- DeployStrategy →depends-on→ CICDPipeline
- Monitoring →depends-on→ DeployStrategy

# Decided
- 사용자 인증: OAuth 방식 채택 (팀 합의)
- 데이터베이스: PostgreSQL 확정 (방금 결정)
- 프론트엔드: React 확정 (기존 합의)

# Undecided
- API 구조: REST | GraphQL (관련 요소: Frontend, Database, UserAuth) — 현재 논의 중
- 배포 전략: 미정 (관련 요소: CICDPipeline, Monitoring) — 논의 시작 전
- 모니터링: 미정 (관련 요소: DeployStrategy) — 논의 시작 전
- CI/CD 파이프라인: 미정 (관련 요소: DeployStrategy) — 논의 시작 전

# Active Discussion
- API 구조 (REST vs GraphQL) 결정

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
