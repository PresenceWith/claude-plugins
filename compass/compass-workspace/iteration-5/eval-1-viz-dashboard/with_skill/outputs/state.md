# Goal
내부 도구 개발 프로젝트의 요구사항 및 기술 결정 사항을 정리하고 추적한다.

# Elements
- UserAuth [type: architecture]
- Database [type: data]
- Frontend [type: architecture]
- DeployStrategy [type: process]
- APIStructure [type: architecture]
- Monitoring [type: process]
- CICDPipeline [type: process]

# Relations
- Frontend ->depends-on-> APIStructure
- APIStructure ->depends-on-> Database
- DeployStrategy ->depends-on-> CICDPipeline
- Monitoring ->depends-on-> DeployStrategy
- UserAuth ->communicates-with-> APIStructure

# Decided
- UserAuth: OAuth (팀 합의)
- Database: PostgreSQL (방금 결정)
- Frontend: React (확정)

# Undecided
- APIStructure: [REST | GraphQL] (Related elements: Frontend, Database)
- DeployStrategy: 아직 논의 시작 전 (Related elements: CICDPipeline, Monitoring)
- Monitoring: 미정 (Related elements: DeployStrategy)
- CICDPipeline: 미정 (Related elements: DeployStrategy)

# Active Discussion
- APIStructure: REST vs GraphQL 결정 필요

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
