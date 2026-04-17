# Goal
비전공자 대상 온라인 코딩 교육 플랫폼 구축 (파이썬 기초부터, 브라우저에서 코드 실행)

# Elements
- CodeEditor [type: component] — Monaco Editor 선택됨
- CodeExecutionEnv [type: architecture] — Docker 컨테이너 기반
- CourseMgmt [type: feature] — 커리큘럼 구조, 진도 추적
- AutoGrading [type: feature] — 코드 제출 + 자동 채점
- Frontend [type: architecture] — React + Monaco + WebSocket
- Backend [type: architecture] — 과정 관리 API, 코드 실행 서비스
- Infra [type: architecture] — AWS ECS Fargate
- DB [type: data] — PostgreSQL, DynamoDB/S3, Redis 제안됨
- Auth [type: feature] — 소셜/자체 이메일 미결정
- Payment [type: feature] — 구독제/과정별 미결정

# Relations
- Frontend →depends-on→ CodeEditor
- Frontend →communicates-with→ Backend
- Backend →depends-on→ CodeExecutionEnv
- CodeExecutionEnv →depends-on→ Infra
- AutoGrading →depends-on→ CodeExecutionEnv
- CourseMgmt →contains→ AutoGrading
- Backend →depends-on→ DB
- Auth →depends-on→ DB

# Decided
- 코드 에디터: Monaco Editor (자동완성 우수)
- 코드 실행 환경: Docker 컨테이너 (다중 언어 확장 고려)
- 인프라: AWS ECS Fargate (소규모 팀 적합 — 단, 팀 규모 확인 안 됨)
- 대상 사용자: 비전공자 입문자
- 첫 과정: 파이썬 기초

# Undecided
- 과정 구조: 모듈식 | 프로젝트 기반 | 혼합형 (Related: CourseMgmt)
- DB 선택: PostgreSQL+DynamoDB+Redis 조합 확정 여부 (Related: DB, Backend)
- 인증 방식: 소셜 로그인 | 자체 이메일 | 둘 다 (Related: Auth)
- 결제 모델: 구독제 | 과정별 구매 (Related: Payment)
- 팀 규모: 미확인 (Related: Infra)
- 자동 채점 설계: 테스트 케이스/코드 스타일/리소스 제한 세부 사항 (Related: AutoGrading)
- 컨테이너 보안 정책: 격리, 시간 제한 세부 사항 (Related: CodeExecutionEnv)

# Active Discussion
- Turn 4에서 여러 주제 동시 제시됨 (DB, 인증, 결제) — 사용자가 "네"로만 응답
- Agency Return 개입 필요: Turn 3부터 응답이 점점 짧아지고 수동적

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 5
