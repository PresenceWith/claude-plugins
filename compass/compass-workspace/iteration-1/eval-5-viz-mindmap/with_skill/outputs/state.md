# Goal
건강에 관심이 많은 밀레니얼 세대를 위한 피트니스 트래킹 모바일 앱을 만든다.

# Elements
- ExerciseLogging [type: feature] {core}
- DietManagement [type: feature] {core}
- SocialFeatures [type: feature] {core}
- Challenges [type: feature]
- AICoaching [type: feature] {core}
- WearableIntegration [type: feature]
- Payments [type: feature]
- OfflineMode [type: constraint]
- MultilingualSupport [type: constraint]

# Relations
- ExerciseLogging →communicates-with→ WearableIntegration
- ExerciseLogging →feeds-into→ AICoaching
- DietManagement →feeds-into→ AICoaching
- SocialFeatures →contains→ Challenges
- AICoaching →depends-on→ ExerciseLogging
- AICoaching →depends-on→ DietManagement
- Challenges →depends-on→ SocialFeatures
- Payments →enables→ AICoaching
- OfflineMode →constrains→ ExerciseLogging
- OfflineMode →constrains→ DietManagement
- MultilingualSupport →constrains→ SocialFeatures

# Decided
(없음)

# Undecided
- 기술 스택: [React Native | Flutter | Native] (관련: OfflineMode, WearableIntegration)
- 수익 모델: [구독 | 프리미엄 | 광고] (관련: Payments)
- AI 코칭 범위: [기본 추천 | 개인화 코칭 | 실시간 피드백] (관련: AICoaching)
- 웨어러블 지원 범위: [Apple Watch만 | 다수 기기] (관련: WearableIntegration)
- 소셜 기능 범위: [친구 피드 | 그룹 | 커뮤니티] (관련: SocialFeatures, Challenges)

# Active Discussion
- 브레인스토밍 단계: 전체 기능 아이디어 시각화 요청

# Meta
- Created: 2026-03-29
- Last sync: 2026-03-29 00:00
- Conversation turns since last sync: 1
