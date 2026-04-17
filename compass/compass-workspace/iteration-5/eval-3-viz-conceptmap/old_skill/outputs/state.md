# Goal
프리랜서 디자이너를 위한 SaaS 플랫폼 — 포트폴리오 관리, 클라이언트 소통, 견적서 발행을 통합하는 서비스

# Elements
- PortfolioManagement [type: feature] (core)
- ClientCommunication [type: feature] (core)
- InvoiceSystem [type: feature] (core)
- ProjectGallery [type: component]
- CaseStudyBuilder [type: component]
- CustomDomain [type: component]
- MessagingHub [type: component]
- FeedbackSystem [type: component]
- ClientPortal [type: component]
- QuoteGenerator [type: component]
- PaymentTracking [type: component]
- ContractTemplates [type: component]
- UserAuth [type: architecture]
- FileStorage [type: architecture]
- NotificationEngine [type: architecture]
- ClientDatabase [type: data]

# Relations
- PortfolioManagement →contains→ ProjectGallery
- PortfolioManagement →contains→ CaseStudyBuilder
- PortfolioManagement →contains→ CustomDomain
- ClientCommunication →contains→ MessagingHub
- ClientCommunication →contains→ FeedbackSystem
- ClientCommunication →contains→ ClientPortal
- InvoiceSystem →contains→ QuoteGenerator
- InvoiceSystem →contains→ PaymentTracking
- InvoiceSystem →contains→ ContractTemplates
- ClientCommunication →feeds-into→ InvoiceSystem
- PortfolioManagement →attracts-leads-for→ ClientCommunication
- InvoiceSystem →references→ PortfolioManagement
- ClientPortal →depends-on→ UserAuth
- MessagingHub →depends-on→ NotificationEngine
- ProjectGallery →depends-on→ FileStorage
- CaseStudyBuilder →depends-on→ FileStorage
- FeedbackSystem →depends-on→ FileStorage
- QuoteGenerator →depends-on→ ClientDatabase
- PaymentTracking →depends-on→ ClientDatabase
- ClientPortal →depends-on→ ClientDatabase
- MessagingHub →depends-on→ ClientDatabase

# Decided
(none yet — initial concept exploration)

# Undecided
- Tech stack: [미정] (Related elements: all)
- MVP scope: [3개 핵심 영역 중 우선순위] (Related elements: PortfolioManagement, ClientCommunication, InvoiceSystem)
- Monetization: [구독 모델 | 프리미엄 | 트랜잭션 기반] (Related elements: InvoiceSystem)

# Active Discussion
- 핵심 영역 간 관계와 의존성 파악

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
