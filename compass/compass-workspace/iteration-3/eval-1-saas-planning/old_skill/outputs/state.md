# Goal
프리랜서 디자이너 대상 SaaS 플랫폼 — 포트폴리오 관리 + 클라이언트 소통 + 견적서 발행 통합. 전체 기능 구조와 MVP 범위를 정의하는 것이 목표.

# Elements
- PortfolioManagement [type: feature]
- ClientCommunication [type: feature]
- QuoteInvoicing [type: feature]
- FreelanceDesigners [type: constraint]
- MVPScope [type: decision]
- TechStack [type: undecided]

# Relations
- PortfolioManagement →core-pillar→ Platform
- ClientCommunication →core-pillar→ Platform
- QuoteInvoicing →core-pillar→ Platform
- FreelanceDesigners →constrains→ Platform
- TechStack →depends-on→ MVPScope

# Decided
(none yet)

# Undecided
- MVP 범위: [어떤 기능을 1차에 포함할지] (Related: PortfolioManagement, ClientCommunication, QuoteInvoicing)
- 기술 스택: [미정] (Related: TechStack, MVPScope)
- 핵심 차별점: [기존 솔루션 대비 어떤 가치를 제공할지] (Related: FreelanceDesigners)

# Active Discussion
- 전체 기능 구조 정리
- MVP 범위 설정

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 0
