# Goal
모바일 피트니스 트래킹 앱 기획 — 운동 기록, 식단 관리, 소셜 기능, 챌린지, 코칭 AI, 웨어러블 연동, 결제, 오프라인 모드, 다국어 지원을 포함하는 종합 피트니스 앱

# Elements
- FitnessApp [type: product]
- WorkoutTracking [type: feature]
- DietManagement [type: feature]
- SocialFeatures [type: feature]
- Challenges [type: feature]
- CoachingAI [type: feature]
- WearableIntegration [type: feature]
- Payment [type: feature]
- OfflineMode [type: constraint]
- Multilingual [type: constraint]
- ExerciseLog [type: component]
- ExerciseStats [type: component]
- CalorieTracking [type: component]
- MealPlanner [type: component]
- NutritionDB [type: component]
- FriendSystem [type: component]
- ActivityFeed [type: component]
- GroupWorkout [type: component]
- DailyChallenge [type: component]
- WeeklyChallenge [type: component]
- Leaderboard [type: component]
- AIFormCheck [type: component]
- PersonalizedPlan [type: component]
- ProgressAnalysis [type: component]
- HealthKit [type: component]
- GoogleFit [type: component]
- SmartWatch [type: component]
- Subscription [type: component]
- InAppPurchase [type: component]
- LocalStorage [type: component]
- SyncEngine [type: component]
- i18nFramework [type: component]

# Relations
- FitnessApp →contains→ WorkoutTracking
- FitnessApp →contains→ DietManagement
- FitnessApp →contains→ SocialFeatures
- FitnessApp →contains→ Challenges
- FitnessApp →contains→ CoachingAI
- FitnessApp →contains→ WearableIntegration
- FitnessApp →contains→ Payment
- FitnessApp →constrained-by→ OfflineMode
- FitnessApp →constrained-by→ Multilingual
- WorkoutTracking →contains→ ExerciseLog
- WorkoutTracking →contains→ ExerciseStats
- DietManagement →contains→ CalorieTracking
- DietManagement →contains→ MealPlanner
- DietManagement →contains→ NutritionDB
- SocialFeatures →contains→ FriendSystem
- SocialFeatures →contains→ ActivityFeed
- SocialFeatures →contains→ GroupWorkout
- Challenges →contains→ DailyChallenge
- Challenges →contains→ WeeklyChallenge
- Challenges →contains→ Leaderboard
- CoachingAI →contains→ AIFormCheck
- CoachingAI →contains→ PersonalizedPlan
- CoachingAI →contains→ ProgressAnalysis
- WearableIntegration →contains→ HealthKit
- WearableIntegration →contains→ GoogleFit
- WearableIntegration →contains→ SmartWatch
- Payment →contains→ Subscription
- Payment →contains→ InAppPurchase
- OfflineMode →contains→ LocalStorage
- OfflineMode →contains→ SyncEngine
- Multilingual →contains→ i18nFramework
- WorkoutTracking →depends-on→ WearableIntegration
- CoachingAI →depends-on→ WorkoutTracking
- CoachingAI →depends-on→ DietManagement
- Challenges →depends-on→ SocialFeatures
- Leaderboard →depends-on→ FriendSystem
- ProgressAnalysis →depends-on→ ExerciseStats
- SyncEngine →depends-on→ LocalStorage
- DietManagement →depends-on→ NutritionDB
- GroupWorkout →depends-on→ Challenges

# Decided
(none yet — initial brainstorming phase)

# Undecided
- Tech Stack: [React Native | Flutter | Native] (Related: OfflineMode, WearableIntegration)
- AI Provider: [On-device ML | Cloud API | Hybrid] (Related: CoachingAI, OfflineMode)
- Payment Provider: [Stripe | RevenueCat | Custom] (Related: Payment, Subscription)
- Database: [SQLite local + Cloud sync | Realm | Firebase] (Related: OfflineMode, SyncEngine)
- MVP Scope: [Which features are MVP vs Phase 2?] (Related: all features)

# Active Discussion
- Initial feature brainstorming and scope mapping

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 1
