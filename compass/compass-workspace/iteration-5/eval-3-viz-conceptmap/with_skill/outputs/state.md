# Goal
프리랜서 디자이너를 위한 SaaS 플랫폼 구축 — 포트폴리오 관리, 클라이언트 소통, 견적서 발행을 통합하는 올인원 서비스.

# Elements
- 포트폴리오 관리 [type: feature, core]
- 프로젝트 갤러리 [type: feature, core]
- 작업물 업로드 [type: feature]
- 카테고리/태그 관리 [type: feature]
- 공개 프로필 페이지 [type: feature]
- 클라이언트 소통 [type: feature, core]
- 메시징 시스템 [type: feature, core]
- 피드백 수집 [type: feature]
- 프로젝트 진행 공유 [type: feature]
- 파일 공유 [type: feature]
- 견적서 발행 [type: feature, core]
- 견적서 생성 [type: feature, core]
- 템플릿 관리 [type: feature]
- 결제 연동 [type: feature]
- 계약서 관리 [type: feature]
- 통합 플랫폼 코어 [type: architecture, core]
- 사용자 인증 [type: architecture, core]
- 클라이언트 DB [type: data]
- 알림 시스템 [type: architecture]
- 대시보드 [type: feature]

# Relations
- 포트폴리오 관리 →contains→ 프로젝트 갤러리
- 포트폴리오 관리 →contains→ 작업물 업로드
- 포트폴리오 관리 →contains→ 카테고리/태그 관리
- 포트폴리오 관리 →contains→ 공개 프로필 페이지
- 클라이언트 소통 →contains→ 메시징 시스템
- 클라이언트 소통 →contains→ 피드백 수집
- 클라이언트 소통 →contains→ 프로젝트 진행 공유
- 클라이언트 소통 →contains→ 파일 공유
- 견적서 발행 →contains→ 견적서 생성
- 견적서 발행 →contains→ 템플릿 관리
- 견적서 발행 →contains→ 결제 연동
- 견적서 발행 →contains→ 계약서 관리
- 공개 프로필 페이지 →feeds-into→ 클라이언트 소통
- 클라이언트 소통 →precedes→ 견적서 발행
- 피드백 수집 →depends-on→ 프로젝트 진행 공유
- 견적서 생성 →depends-on→ 클라이언트 DB
- 메시징 시스템 →depends-on→ 클라이언트 DB
- 견적서 생성 →depends-on→ 템플릿 관리
- 결제 연동 →depends-on→ 계약서 관리
- 프로젝트 진행 공유 →feeds-into→ 포트폴리오 관리
- 알림 시스템 →supports→ 메시징 시스템
- 알림 시스템 →supports→ 견적서 발행
- 사용자 인증 →supports→ 포트폴리오 관리
- 사용자 인증 →supports→ 클라이언트 소통
- 사용자 인증 →supports→ 견적서 발행
- 클라이언트 DB →supports→ 포트폴리오 관리
- 클라이언트 DB →supports→ 클라이언트 소통
- 대시보드 →aggregates→ 포트폴리오 관리
- 대시보드 →aggregates→ 클라이언트 소통
- 대시보드 →aggregates→ 견적서 발행
- 파일 공유 →depends-on→ 작업물 업로드

# Decided
- (No decisions made yet — this is the initial conceptualization)

# Undecided
- 기술 스택: [미정] (Related: 통합 플랫폼 코어, 사용자 인증)
- 결제 시스템: [Stripe | Toss Payments | 직접 구현] (Related: 결제 연동)
- 호스팅/인프라: [AWS | Vercel | 기타] (Related: 통합 플랫폼 코어)
- MVP 범위: [전체 기능 | 코어만 먼저] (Related: 포트폴리오 관리, 클라이언트 소통, 견적서 발행)

# Active Discussion
- 핵심 영역 간 관계와 의존성 파악 (컨셉트맵)

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
