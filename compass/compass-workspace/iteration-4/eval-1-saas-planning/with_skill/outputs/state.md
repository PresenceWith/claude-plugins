# Goal
프리랜서 디자이너를 위한 SaaS 플랫폼 기획 — 포트폴리오 관리 + 클라이언트 소통 + 견적서 발행을 통합. 현재 단계: 전체 기능 구조와 MVP 범위 설정.

# Elements
- PortfolioManagement [type: feature]
- ClientCommunication [type: feature]
- QuoteInvoicing [type: feature]
- FreelanceDesigner [type: concept]
- TechStack [type: architecture]
- MVPScope [type: constraint]
- FeatureStructure [type: architecture]

# Relations
- PortfolioManagement →core-pillar-of→ FeatureStructure
- ClientCommunication →core-pillar-of→ FeatureStructure
- QuoteInvoicing →core-pillar-of→ FeatureStructure
- FeatureStructure →determines→ MVPScope
- MVPScope →constrains→ TechStack
- FreelanceDesigner →target-user-of→ FeatureStructure

# Decided
- Target user: 프리랜서 디자이너 (명시적 선택)
- Core pillars: 포트폴리오 관리, 클라이언트 소통, 견적서 발행 (3개 핵심 기능 영역)

# Undecided
- MVP 범위: [어떤 기능이 MVP에 포함되는가] (Related: FeatureStructure, MVPScope)
- 기술 스택: [미정] (Related: TechStack)
- 각 핵심 기능의 세부 기능: [미정] (Related: PortfolioManagement, ClientCommunication, QuoteInvoicing)
- 수익 모델: [미정] (Related: FreelanceDesigner)
- 경쟁 차별화 포인트: [미정] (Related: FeatureStructure)

# Active Discussion
- 전체 기능 구조 잡기
- MVP 범위 설정

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
