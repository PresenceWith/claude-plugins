# Goal
내부 도구 개발 프로젝트의 기술 스택과 아키텍처 결정 사항을 정리하고, 결정된 것과 미결정 사항을 명확히 구분한다.

# Elements
- UserAuth [type: architecture]
- Database [type: data]
- Frontend [type: architecture]
- DeployStrategy [type: process]
- APIStructure [type: architecture]
- Monitoring [type: process]
- CICD [type: process]

# Relations
- Frontend →depends-on→ APIStructure
- APIStructure →depends-on→ Database
- UserAuth →communicates-with→ APIStructure
- DeployStrategy →depends-on→ CICD
- Monitoring →depends-on→ DeployStrategy

# Decided
- 사용자 인증: OAuth 방식 채택 (팀 합의)
- 프론트엔드: React 확정 (팀 합의)

# Undecided
- 데이터베이스: [PostgreSQL | MongoDB] (Related elements: Database, APIStructure)
- API 구조: [REST | GraphQL] (Related elements: APIStructure, Frontend, UserAuth)
- 배포 전략: [미정 — 아직 논의 시작 전] (Related elements: DeployStrategy, CICD)
- 모니터링: [미정 — 검토 필요] (Related elements: Monitoring, DeployStrategy)
- CI/CD 파이프라인: [미정 — 정해야 함] (Related elements: CICD, DeployStrategy)

# Active Discussion
- 전체 기술 스택 현황 정리 및 의사결정 상태 파악

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
