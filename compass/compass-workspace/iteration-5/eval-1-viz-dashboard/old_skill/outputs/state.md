# Goal
내부 도구 개발 프로젝트의 기술 스택 및 아키텍처 결정 사항 정리. 요구사항이 계속 변경되는 상황에서 결정된 것과 미결정 항목을 명확히 구분.

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
- DeployStrategy →precedes→ CICD
- CICD →depends-on→ DeployStrategy
- Monitoring →depends-on→ DeployStrategy
- UserAuth →communicates-with→ APIStructure

# Decided
- UserAuth: OAuth (팀 합의)
- Database: PostgreSQL (방금 결정)
- Frontend: React (확정)

# Undecided
- APIStructure: [REST | GraphQL] (Related elements: Frontend, Database)
- DeployStrategy: [] (논의 미시작, Related elements: CICD, Monitoring)
- Monitoring: [] (검토 필요, Related elements: DeployStrategy)
- CICD: [] (정해야 함, Related elements: DeployStrategy)

# Active Discussion
- 전체 현황 정리 요청 (상태 대시보드)

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
