# Goal
내부 도구(Internal Tool) 구축을 위한 기술 스택 및 아키텍처 의사결정

# Elements
- Authentication [type: architecture]
- Frontend [type: architecture]
- Database [type: architecture]
- APIStructure [type: architecture]
- Monitoring [type: architecture]
- CICDPipeline [type: architecture]
- DeploymentStrategy [type: architecture]

# Relations
- Frontend ->depends-on-> Authentication
- Frontend ->communicates-with-> APIStructure
- APIStructure ->depends-on-> Database
- CICDPipeline ->precedes-> DeploymentStrategy
- Monitoring ->depends-on-> DeploymentStrategy

# Decided
- Authentication: OAuth (인증 표준으로 OAuth 선택)
- Frontend: React (프론트엔드 프레임워크로 React 선택)
- Database: PostgreSQL (관계형 데이터베이스로 PostgreSQL 선택 - 방금 결정)

# Undecided
- APIStructure: [REST | GraphQL] (Related elements: Frontend, Database)
- Monitoring: 아직 논의되지 않음 (Related elements: DeploymentStrategy)
- CICDPipeline: 아직 결정되지 않음 (Related elements: DeploymentStrategy)
- DeploymentStrategy: 아직 논의되지 않음 (Related elements: CICDPipeline, Monitoring)

# Active Discussion
- APIStructure: REST vs GraphQL 비교 논의 중

# Meta
- Created: 2026-03-29
- Last sync: 2026-03-29 00:00
- Conversation turns since last sync: 0
