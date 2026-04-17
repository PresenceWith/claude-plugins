# Goal
수제 공예품 전문 이커머스 플랫폼 구축. 상품 등록과 결제 기능부터 시작.

# Elements
- EcommercePlatform [type: architecture]
- ProductRegistration [type: feature]
- PaymentSystem [type: feature]
- SellerDashboard [type: feature]
- ReviewSystem [type: feature]
- SearchFunction [type: feature]
- InventoryManagement [type: feature]
- ShippingTracking [type: feature]
- CouponDiscount [type: feature]
- SettlementSystem [type: feature]
- NextJS [type: architecture]
- TossPayments [type: constraint]
- Database [type: architecture]

# Relations
- EcommercePlatform →contains→ ProductRegistration
- EcommercePlatform →contains→ PaymentSystem
- EcommercePlatform →contains→ SellerDashboard
- EcommercePlatform →contains→ ReviewSystem
- EcommercePlatform →contains→ SearchFunction
- EcommercePlatform →contains→ InventoryManagement
- EcommercePlatform →contains→ ShippingTracking
- EcommercePlatform →contains→ CouponDiscount
- EcommercePlatform →contains→ SettlementSystem
- PaymentSystem →depends-on→ TossPayments
- PaymentSystem →depends-on→ Database
- ProductRegistration →depends-on→ Database
- SellerDashboard →depends-on→ ProductRegistration
- SellerDashboard →depends-on→ InventoryManagement
- ReviewSystem →depends-on→ ProductRegistration
- ShippingTracking →depends-on→ PaymentSystem
- SettlementSystem →depends-on→ PaymentSystem
- CouponDiscount →depends-on→ PaymentSystem
- InventoryManagement →depends-on→ ProductRegistration

# Decided
- 타겟 사용자: 소규모 공예가(판매자) 약 100명 규모로 시작 (사용자 직접 명시)
- 프론트/백엔드 프레임워크: Next.js (사용자 선택)
- 결제 시스템: 토스페이먼츠 연동 (사용자 선택)
- MVP 시작 기능: 상품 등록 + 결제 (사용자 명시)

# Undecided
- DB 선택: [PostgreSQL | MongoDB] (사용자가 "나중에 생각해볼게"로 보류)
- 판매자 대시보드 범위: [미정] (언급만 됨, 구체적 논의 없음)
- 리뷰 시스템 설계: [미정] (언급만 됨)
- 검색 기능 범위: [미정] (언급만 됨)
- 재고 관리 방식: [미정] (사용자가 "어떻게 하지?"로 질문)
- 배송 추적 방식: [미정] (언급만 됨)
- 쿠폰/할인 시스템: [미정] (언급만 됨)
- 정산 시스템 설계: [미정] (언급만 됨)

# Active Discussion
- 기능 범위 정의 및 MVP 우선순위 결정 필요

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 4
