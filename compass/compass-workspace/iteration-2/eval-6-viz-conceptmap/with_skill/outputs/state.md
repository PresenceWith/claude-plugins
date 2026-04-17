# Goal
프리랜서 디자이너를 위한 SaaS 플랫폼 구축 — 포트폴리오 관리, 클라이언트 소통, 견적서 발행을 하나의 통합 환경으로 제공한다.

# Elements
- 포트폴리오 관리 [type: feature, core]
- 프로젝트 갤러리 [type: feature]
- 작업물 업로드 [type: feature]
- 공개 포트폴리오 페이지 [type: feature]
- 커스텀 도메인 [type: feature]
- 클라이언트 소통 [type: feature, core]
- 메시지/채팅 [type: feature]
- 피드백 수집 [type: feature]
- 파일 공유 [type: feature]
- 프로젝트 진행 상태 [type: feature]
- 견적서 발행 [type: feature, core]
- 견적서 생성 [type: feature]
- 청구서 발행 [type: feature]
- 결제 연동 [type: feature]
- 계약서 관리 [type: feature]
- 프로젝트 (중심 엔티티) [type: data, core]
- 클라이언트 DB [type: data, core]
- 사용자 인증 [type: architecture]
- 파일 스토리지 [type: architecture]
- 알림 시스템 [type: architecture]

# Relations
- 포트폴리오 관리 →contains→ 프로젝트 갤러리
- 포트폴리오 관리 →contains→ 작업물 업로드
- 포트폴리오 관리 →contains→ 공개 포트폴리오 페이지
- 포트폴리오 관리 →contains→ 커스텀 도메인
- 클라이언트 소통 →contains→ 메시지/채팅
- 클라이언트 소통 →contains→ 피드백 수집
- 클라이언트 소통 →contains→ 파일 공유
- 클라이언트 소통 →contains→ 프로젝트 진행 상태
- 견적서 발행 →contains→ 견적서 생성
- 견적서 발행 →contains→ 청구서 발행
- 견적서 발행 →contains→ 결제 연동
- 견적서 발행 →contains→ 계약서 관리
- 포트폴리오 관리 →depends-on→ 프로젝트 (중심 엔티티)
- 포트폴리오 관리 →depends-on→ 파일 스토리지
- 클라이언트 소통 →depends-on→ 프로젝트 (중심 엔티티)
- 클라이언트 소통 →depends-on→ 클라이언트 DB
- 클라이언트 소통 →depends-on→ 알림 시스템
- 견적서 발행 →depends-on→ 프로젝트 (중심 엔티티)
- 견적서 발행 →depends-on→ 클라이언트 DB
- 파일 공유 →depends-on→ 파일 스토리지
- 피드백 수집 →depends-on→ 파일 스토리지
- 작업물 업로드 →depends-on→ 파일 스토리지
- 결제 연동 →depends-on→ 사용자 인증
- 포트폴리오 관리 →feeds→ 클라이언트 소통
- 클라이언트 소통 →feeds→ 견적서 발행
- 견적서 발행 →feeds→ 포트폴리오 관리
- 프로젝트 (중심 엔티티) →links→ 클라이언트 DB

# Decided
- (대화 초기 — 아직 결정 없음)

# Undecided
- 기술 스택: [미정] (Related: 전체 아키텍처)
- 수익 모델: [구독제 | 프리미엄 | 거래 수수료] (Related: 견적서 발행, 결제 연동)
- MVP 범위: [3개 기능 모두 | 포트폴리오+소통 먼저] (Related: 전체)
- 결제 수단: [Stripe | Toss Payments | ...] (Related: 결제 연동)

# Active Discussion
- 핵심 영역 간 관계와 의존성 파악 (컨셉트맵 생성)

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
