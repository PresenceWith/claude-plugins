# Goal
SaaS 프로젝트 관리 도구의 알림 시스템 설계

# Elements
- NotificationSystem [type: architecture]
- EmailChannel [type: channel]
- SlackChannel [type: channel]
- InAppChannel [type: channel]
- EventSystem [type: architecture]
- NotificationSettings [type: feature]
- NotificationTemplates [type: feature]
- NotificationScheduling [type: feature]
- NotificationGrouping [type: feature]
- WebSocket [type: infrastructure]

# Relations
- NotificationSystem →contains→ EmailChannel
- NotificationSystem →contains→ SlackChannel
- NotificationSystem →contains→ InAppChannel
- NotificationSystem →depends-on→ EventSystem
- InAppChannel →depends-on→ WebSocket
- NotificationScheduling →depends-on→ EventSystem
- NotificationGrouping →relates-to→ NotificationScheduling

# Decided
- [알림 채널]: 이메일, 슬랙, 인앱 3가지 (사용자가 직접 선택)

# Undecided
- [이벤트 시스템 패턴]: 이벤트 소싱 | Pub/Sub (Related: EventSystem, NotificationSystem)
- [알림 설정 UI]: 구체적 설계 미정 (Related: NotificationSettings)
- [알림 템플릿 시스템]: 구조 미정 (Related: NotificationTemplates)
- [알림 스케줄링 방식]: 마감 기준 스케줄링 구조 미정 (Related: NotificationScheduling)
- [실시간 알림 인프라]: WebSocket 지원 여부 미확인 (Related: WebSocket, InAppChannel)
- [알림 그룹핑/배치]: 그룹핑 전략 미정 (Related: NotificationGrouping)

# Active Discussion
- 이벤트 시스템 패턴 선택
- 알림 설정 UI
- 알림 템플릿 시스템
- 알림 스케줄링
- 실시간 알림 인프라
- 알림 그룹핑/배치

# Meta
- Created: 2026-03-30
- Last sync: 2026-03-30 10:00
- Conversation turns since last sync: 2
