# Goal
수제 공예품 전문 이커머스 플랫폼 구축. 소규모 공예가(판매자) 대상, 상품 등록과 결제 기능부터 시작.

# Elements
- EcommercePlatform [type: architecture]
- ProductRegistration [type: feature]
- PaymentSystem [type: feature]
- TossPayments [type: constraint]
- NextJS [type: architecture]
- Database [type: architecture]
- SellerDashboard [type: feature]
- ReviewSystem [type: feature]
- SearchFunction [type: feature]
- InventoryManagement [type: feature]
- ShippingTracking [type: feature]
- CouponDiscount [type: feature]
- SettlementSystem [type: feature]

# Relations
- EcommercePlatform →contains→ ProductRegistration
- EcommercePlatform →contains→ PaymentSystem
- PaymentSystem →depends-on→ TossPayments
- EcommercePlatform →depends-on→ NextJS
- EcommercePlatform →depends-on→ Database
- SellerDashboard →depends-on→ InventoryManagement
- SellerDashboard →depends-on→ SettlementSystem
- ShippingTracking →depends-on→ PaymentSystem
- SettlementSystem →depends-on→ PaymentSystem
- CouponDiscount →depends-on→ PaymentSystem
- ReviewSystem →depends-on→ ProductRegistration
- SearchFunction →depends-on→ ProductRegistration

# Decided
- 타겟 사용자: 소규모 공예가 ~100명으로 시작 (사용자 지정)
- 프론트엔드/백엔드: Next.js (사용자 선택)
- 결제 연동: 토스페이먼츠 (사용자 선택)

# Undecided
- DB 선택: PostgreSQL | MongoDB (사용자가 "나중에 생각해볼게"로 보류)
- MVP 범위: 7개 기능 중 우선순위 미정 (Related: SellerDashboard, ReviewSystem, SearchFunction, InventoryManagement, ShippingTracking, CouponDiscount, SettlementSystem)
- 판매자 대시보드 상세 기능: 미정 (Related: SellerDashboard)
- 리뷰 시스템 구조: 미정 (Related: ReviewSystem)
- 검색 기능 범위: 미정 (Related: SearchFunction)
- 재고 관리 방식: 미정 (Related: InventoryManagement)
- 배송 추적 연동 방식: 미정 (Related: ShippingTracking)

# Active Discussion
- 전체 현황 정리 요청 (사용자: "뭐가 결정된 거야? 좀 정리해줘")

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 4
