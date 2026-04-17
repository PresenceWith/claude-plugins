# Goal
프리랜서 디자이너를 위한 SaaS 플랫폼의 세 핵심 영역(포트폴리오, 클라이언트 커뮤니케이션, 견적/인보이스) 간의 관계와 의존성을 파악한다.

# Elements
- 포트폴리오관리 [type: feature]
- 프로젝트업로드 [type: feature]
- 퍼블릭페이지 [type: feature]
- 비공개링크 [type: feature]
- 조회통계 [type: feature]
- 클라이언트커뮤니케이션 [type: feature]
- 프로젝트채팅 [type: feature]
- 파일공유 [type: feature]
- 버전관리 [type: feature]
- 피드백 [type: feature]
- 승인워크플로우 [type: feature]
- 견적인보이스 [type: feature]
- 견적생성 [type: feature]
- 템플릿 [type: feature]
- 온라인서명 [type: feature]
- 인보이싱 [type: feature]
- 파일스토리지 [type: architecture]
- 인증시스템 [type: architecture]
- 알림시스템 [type: architecture]

# Relations
- 포트폴리오관리 →contains→ 프로젝트업로드
- 포트폴리오관리 →contains→ 퍼블릭페이지
- 포트폴리오관리 →contains→ 비공개링크
- 포트폴리오관리 →contains→ 조회통계
- 클라이언트커뮤니케이션 →contains→ 프로젝트채팅
- 클라이언트커뮤니케이션 →contains→ 파일공유
- 클라이언트커뮤니케이션 →contains→ 버전관리
- 클라이언트커뮤니케이션 →contains→ 피드백
- 클라이언트커뮤니케이션 →contains→ 승인워크플로우
- 견적인보이스 →contains→ 견적생성
- 견적인보이스 →contains→ 템플릿
- 견적인보이스 →contains→ 온라인서명
- 견적인보이스 →contains→ 인보이싱
- 포트폴리오관리 →precedes→ 클라이언트커뮤니케이션
- 클라이언트커뮤니케이션 →precedes→ 견적인보이스
- 포트폴리오관리 →depends-on→ 파일스토리지
- 클라이언트커뮤니케이션 →depends-on→ 인증시스템
- 클라이언트커뮤니케이션 →depends-on→ 알림시스템
- 견적인보이스 →depends-on→ 클라이언트커뮤니케이션
- 파일공유 →depends-on→ 파일스토리지
- 버전관리 →depends-on→ 파일스토리지

# Decided
- 플랫폼 구조: 세 영역(포트폴리오, 커뮤니케이션, 견적) 구분 (사용자의 핵심 워크플로우에 기반)
- 워크플로우 흐름: 포트폴리오 → 클라이언트 커뮤니케이션 → 견적/인보이스 순서 (프로젝트 라이프사이클 반영)

# Undecided
- 파일스토리지 구현: [자체 스토리지 | 클라우드 서비스(S3 등) | 하이브리드] (Related elements: 포트폴리오관리, 파일공유, 버전관리)
- 인증 방식: [자체 인증 | OAuth | SSO] (Related elements: 인증시스템, 클라이언트커뮤니케이션)
- 알림 채널: [이메일 | 푸시 | 인앱 | 복합] (Related elements: 알림시스템, 클라이언트커뮤니케이션)

# Active Discussion
- 세 영역 간의 관계와 의존성 시각화

# Meta
- Created: 2026-03-29
- Last sync: 2026-03-29 00:00
- Conversation turns since last sync: 1
