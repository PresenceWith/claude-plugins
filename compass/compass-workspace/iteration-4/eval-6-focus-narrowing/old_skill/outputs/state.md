# Goal
SaaS 프로젝트 관리 도구의 알림 시스템 설계

# Elements
- NotificationSystem [type: architecture]
- EventSystem [type: architecture]
- EmailChannel [type: feature]
- SlackChannel [type: feature]
- InAppChannel [type: feature]
- NotificationSettingsUI [type: feature]
- NotificationTemplates [type: component]
- NotificationScheduling [type: feature]
- WebSocket [type: architecture]
- NotificationGrouping [type: feature]

# Relations
- NotificationSystem →depends-on→ EventSystem
- NotificationSystem →contains→ EmailChannel
- NotificationSystem →contains→ SlackChannel
- NotificationSystem →contains→ InAppChannel
- InAppChannel →depends-on→ WebSocket
- NotificationSystem →contains→ NotificationTemplates
- NotificationSystem →contains→ NotificationScheduling
- NotificationSystem →contains→ NotificationGrouping
- NotificationSettingsUI →depends-on→ NotificationSystem

# Decided
- 알림 채널: 이메일, 슬랙, 인앱 세 가지 (사용자가 명시적으로 결정)

# Undecided
- 이벤트 시스템 아키텍처: [이벤트 소싱 | 단순 pub/sub] (Related: EventSystem, NotificationSystem)
- 실시간 인프라: [WebSocket 도입 여부] (Related: WebSocket, InAppChannel)
- 알림 스케줄링 방식: [구체적 방식 미정] (Related: NotificationScheduling)
- 알림 그룹핑/배치 전략: [구체적 방식 미정] (Related: NotificationGrouping)
- 알림 템플릿 시스템: [구체적 방식 미정] (Related: NotificationTemplates)
- 알림 설정 UI: [구체적 방식 미정] (Related: NotificationSettingsUI)

# Active Discussion
- 이벤트 시스템 아키텍처
- 알림 스케줄링
- 알림 그룹핑/배치
- 실시간 알림 인프라
- 알림 템플릿 시스템
- 알림 설정 UI

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 00:00
- Conversation turns since last sync: 2
