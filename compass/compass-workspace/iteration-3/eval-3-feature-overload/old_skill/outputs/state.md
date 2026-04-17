# Goal
피트니스 트래킹 모바일 앱 기획 — 운동 기록, 식단 관리, 소셜, 챌린지, AI 코칭, 웨어러블 연동, 결제, 오프라인 모드, 다국어 지원 포함. 우선순위와 시작점을 찾아야 함.

# Elements
- ExerciseTracking [type: feature] — 운동 기록 (핵심)
- DietManagement [type: feature] — 식단 관리 (핵심)
- SocialFeatures [type: feature] — 소셜 기능
- Challenges [type: feature] — 챌린지 시스템
- CoachingAI [type: feature] — AI 코칭
- WearableIntegration [type: feature] — 웨어러블 연동
- Payments [type: feature] — 결제 시스템
- OfflineMode [type: constraint] — 오프라인 모드 지원
- Multilingual [type: constraint] — 다국어 지원
- MVPScope [type: decision] — MVP에 포함할 기능 범위
- Platform [type: decision] — 플랫폼 선택 (iOS/Android/크로스플랫폼)
- TechStack [type: decision] — 기술 스택

# Relations
- ExerciseTracking →core-of→ MVPScope
- DietManagement →core-of→ MVPScope
- SocialFeatures →depends-on→ ExerciseTracking
- Challenges →depends-on→ SocialFeatures
- CoachingAI →depends-on→ ExerciseTracking
- CoachingAI →depends-on→ DietManagement
- WearableIntegration →depends-on→ ExerciseTracking
- Payments →depends-on→ Challenges
- OfflineMode →constrains→ TechStack
- Multilingual →constrains→ TechStack

# Decided
(없음)

# Undecided
- MVP 범위: [전체 기능 | 핵심만 | 단계별 출시] (Related: MVPScope, 모든 feature)
- 플랫폼: [iOS | Android | 크로스플랫폼] (Related: Platform, TechStack)
- 기술 스택: [React Native | Flutter | Swift+Kotlin | ...] (Related: TechStack, OfflineMode)
- 수익 모델: [구독 | 인앱결제 | 프리미엄 | 광고] (Related: Payments)
- 타겟 사용자: [초보자 | 중급자 | 전문가 | 전체] (Related: 모든 feature)
- 출시 시장: [국내 | 글로벌] (Related: Multilingual)

# Active Discussion
- 전체 기능 범위와 우선순위 설정

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
