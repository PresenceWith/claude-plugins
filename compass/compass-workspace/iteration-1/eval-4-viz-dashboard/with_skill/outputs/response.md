지금까지 논의한 내용을 Status Dashboard로 정리했습니다.

## 현황 요약

**전체 7개 항목 중 3개 결정 완료 (약 43%)**

### 결정됨 (3개)
- **Authentication** — OAuth
- **Frontend** — React
- **Database** — PostgreSQL (방금 결정)

### 논의 중 (1개)
- **API Structure** — REST vs GraphQL 비교 중

### 미결정 (3개)
- **Monitoring** — 아직 논의되지 않음
- **CI/CD Pipeline** — 아직 결정되지 않음
- **Deployment Strategy** — 아직 논의되지 않음

---

대시보드를 열어서 전체 현황을 시각적으로 확인할 수 있습니다.

현재 API Structure(REST vs GraphQL) 논의가 진행 중입니다. 이 결정은 이미 결정된 Frontend(React)와 Database(PostgreSQL) 모두와 연결되어 있어서, 다음 단계로 넘어가기 전에 먼저 정리하면 좋겠습니다.

이후에는 CI/CD Pipeline → Deployment Strategy → Monitoring 순서로 결정하는 것을 추천합니다. CI/CD가 배포 전략에 선행되고, 모니터링은 배포 환경이 정해진 후에 논의하는 것이 자연스럽기 때문입니다.

API Structure에 대해 계속 논의할까요?
