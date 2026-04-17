# Goal
비전공자를 위한 브라우저 기반 온라인 코딩 교육 플랫폼 구축 (파이썬 기초 과정부터 시작, 다중 언어 확장 예정)

# Elements
- CodeEditor [type: component] — Monaco Editor
- CodeExecutionEnv [type: architecture] — Docker 컨테이너 기반 코드 실행
- CourseMgmt [type: feature] — 커리큘럼/과정 관리
- AutoGrading [type: feature] — 자동 채점 시스템
- Frontend [type: architecture] — React + Monaco + WebSocket
- Backend [type: architecture] — 과정 관리 API, 코드 실행 서비스
- Infra [type: architecture] — AWS ECS Fargate
- Database [type: data] — DB 구성
- Auth [type: feature] — 인증 시스템
- Payment [type: feature] — 결제 시스템
- CourseStructure [type: concept] — 과정 구조 (모듈식/프로젝트/혼합)

# Relations
- CodeEditor →communicates-with→ Backend
- Backend →depends-on→ CodeExecutionEnv
- CodeExecutionEnv →depends-on→ Infra
- AutoGrading →depends-on→ CodeExecutionEnv
- CourseMgmt →depends-on→ Database
- Auth →depends-on→ Database
- Payment →depends-on→ Auth

# Decided
- CodeEditor: Monaco Editor (자동완성 등 기능이 풍부)
- CodeExecutionEnv: Docker 컨테이너 (다중 언어 확장 가능성)
- Infra: AWS ECS Fargate (소규모 팀에 적합 — 팀 규모 미확인이나 사용자가 동의)
- Frontend: React + Monaco Editor + WebSocket

# Undecided
- CourseStructure: [모듈식 | 프로젝트 기반 | 혼합형] (Related: CourseMgmt)
- Database: [PostgreSQL+DynamoDB+Redis 구성] (Related: CourseMgmt, Auth) — 제안됨, 확인 불명확
- Auth: [소셜 로그인 | 자체 이메일 | 둘 다] (Related: Auth)
- Payment: [구독제 | 과정별 구매 | 무료 체험 | 환불 정책] (Related: Payment)
- AutoGrading: [테스트 케이스 기반, 코드 스타일 검사, 실행 제한] — 세부 설계 미정
- TeamSize: 팀 규모 미확인 (ECS 선택 근거와 연관)

# Active Discussion
- 사용자가 "네"로만 응답 — 무엇에 동의하는지 불명확 (DB? 인증? 결제? 전부?)
- 사용자 에이전시 저하 감지: Turn 3부터 짧은 수동적 응답 패턴

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 5
