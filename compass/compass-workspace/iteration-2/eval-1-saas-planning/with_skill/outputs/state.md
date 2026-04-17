# Goal
프리랜서 디자이너 대상 SaaS 플랫폼 구축 — 포트폴리오 관리 + 클라이언트 소통 + 견적서 발행 통합. 현재 단계: 전체 기능 구조 정의 및 MVP 범위 설정.

# Elements
- Portfolio [type: feature] — 작업물 관리 및 전시 기능
- ClientCommunication [type: feature] — 클라이언트와의 소통 채널
- Invoicing [type: feature] — 견적서/청구서 발행 및 관리
- Platform [type: architecture] — 세 기능을 통합하는 SaaS 플랫폼
- FreelanceDesigner [type: concept] — 타겟 사용자 페르소나
- TechStack [type: architecture] — 기술 스택 (미정)
- MVPScope [type: constraint] — MVP에 포함할 범위

# Relations
- Platform →contains→ Portfolio
- Platform →contains→ ClientCommunication
- Platform →contains→ Invoicing
- FreelanceDesigner →uses→ Platform
- MVPScope →constrains→ Platform
- TechStack →enables→ Platform
- ClientCommunication →depends-on→ Portfolio
- Invoicing →depends-on→ ClientCommunication

# Decided
- [타겟 사용자]: 프리랜서 디자이너 (사용자가 명시)
- [핵심 기능 축]: 포트폴리오 + 클라이언트 소통 + 견적서 발행의 3축 통합 (사용자가 명시)
- [제품 형태]: SaaS 플랫폼 (사용자가 명시)

# Undecided
- [MVP 핵심 진입점]: 포트폴리오 중심 | 비즈니스 도구 중심 | 기타 (Related elements: Portfolio, ClientCommunication, Invoicing, MVPScope)
- [기술 스택]: 미정 (Related elements: TechStack, Platform)
- [수익 모델]: 미논의 (Related elements: Platform)
- [각 축의 구체 기능 목록]: 미정의 (Related elements: Portfolio, ClientCommunication, Invoicing)

# Active Discussion
- MVP 진입점 방향 결정: 포트폴리오 중심 vs 비즈니스 도구 중심

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
