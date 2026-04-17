# Goal
내부 도구 개발 — 팀 내부에서 사용할 도구를 만드는 프로젝트. 요구사항이 유동적인 상황에서 기술 스택과 인프라 결정을 정리하고 확정해 나가는 것이 현재 목표.

# Elements
- UserAuth [type: architecture] (core)
- Database [type: data] (core)
- Frontend [type: architecture] (core)
- APIStructure [type: architecture] (core)
- DeployStrategy [type: architecture] (core)
- Monitoring [type: architecture]
- CICDPipeline [type: architecture]

# Relations
- Frontend →depends-on→ APIStructure
- APIStructure →depends-on→ Database
- UserAuth →communicates-with→ APIStructure
- DeployStrategy →depends-on→ CICDPipeline
- Monitoring →depends-on→ DeployStrategy
- CICDPipeline →precedes→ DeployStrategy

# Decided
- UserAuth: OAuth 방식 채택 (팀 합의)
- Frontend: React 확정 (팀 합의)

# Undecided
- Database: [PostgreSQL | MongoDB] (Related elements: APIStructure)
- APIStructure: [REST | GraphQL] (Related elements: Frontend, Database)
- DeployStrategy: 아직 논의 시작 전 (Related elements: CICDPipeline, Monitoring)
- Monitoring: 아직 논의 시작 전 (Related elements: DeployStrategy)
- CICDPipeline: 아직 논의 시작 전 (Related elements: DeployStrategy)

# Active Discussion
- 전체 의사결정 현황 정리 (Decision Cleanup)

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
