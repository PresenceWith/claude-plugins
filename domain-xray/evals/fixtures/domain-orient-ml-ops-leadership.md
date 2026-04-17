---
domain: "MLOps & ML Infrastructure — encompassing model training pipelines, experiment tracking, model serving and deployment, feature stores, monitoring and observability for ML systems, CI/CD for ML, and the operational practices bridging data science experimentation to production ML systems"
purpose: "Lead the MLOps team — make architecture decisions, evaluate tool choices, set technical direction, and ensure the team delivers reliable ML infrastructure"
success_criteria: "Can evaluate the team's technical proposals, make informed architecture decisions between competing approaches, and explain MLOps tradeoffs to both data scientists and engineering leadership"
current_state: "8-year senior data scientist. Deep expertise in model development, feature engineering, and experimentation. Have used MLflow and basic model deployment, but never designed or operated ML infrastructure at scale. No experience managing infrastructure teams."
target_state: "Make strategic MLOps decisions — which tools to adopt, how to architect the platform, when to build vs. buy, and how to prioritize infrastructure work against data science requests"
priority_areas:
  - "Model Serving & Deployment Architecture"
  - "ML Pipeline Orchestration"
  - "Monitoring & Observability for ML"
anchor_points:
  - "Deep model development experience — understands what data scientists need from infrastructure"
  - "MLflow experiment tracking — familiar with the experimentation side of MLOps"
  - "Feature engineering expertise — knows the data transformation requirements firsthand"
  - "Research paper reading habit — can evaluate technical approaches from literature"
---

# MLOps & ML Infrastructure Orientation Map

## Why This Map
이 맵은 데이터 사이언티스트에서 MLOps 팀 리더로 전환하는 과정에서 필요한 인프라·운영 관점의 지식 구조를 제공합니다. 모델을 만드는 입장에서 모델을 서빙하고 운영하는 시스템을 설계·관리하는 입장으로의 시야 전환이 핵심입니다.

## Your Anchor Points
- **모델 개발 경험**: 데이터 사이언티스트로서 "인프라가 이래서 불편했다"는 경험이 곧 팀이 해결해야 할 과제 목록입니다.
- **MLflow 사용 경험**: 실험 추적의 사용자 관점을 알고 있으므로, 이를 조직 전체로 확장할 때의 과제를 직관적으로 이해할 수 있습니다.
- **피처 엔지니어링 전문성**: 피처 스토어 설계 시 실제 사용 패턴을 알고 있다는 것은 큰 장점입니다.

## Domain Landscape

### Area 1: 모델 서빙 & 배포 아키텍처 (Model Serving & Deployment)
**What it is**: 학습된 모델을 프로덕션 환경에서 실시간 또는 배치로 예측을 제공하도록 배포하고 관리합니다.
**Why it matters**: 모델이 노트북에서만 동작하면 비즈니스 가치가 없습니다. 서빙 아키텍처가 모델의 실제 임팩트를 결정합니다.
**Key vocabulary**: model registry, canary deployment, A/B testing in production, latency SLA, model versioning, shadow mode
**Connection to other areas**: 파이프라인의 최종 단계이며, 모니터링의 주요 대상입니다.

### Area 2: ML 파이프라인 오케스트레이션 (ML Pipeline Orchestration)
**What it is**: 데이터 수집→전처리→학습→평가→배포의 전체 흐름을 자동화하고 관리합니다.
**Why it matters**: 수동 학습 프로세스는 재현 불가능하고 확장 불가능합니다. 팀이 커질수록 오케스트레이션이 생산성을 결정합니다.
**Key vocabulary**: training pipeline, retraining trigger, pipeline versioning, Kubeflow, Vertex AI Pipelines
**Connection to other areas**: 모든 영역을 연결하는 접착제 역할입니다.

### Area 3: ML 모니터링 & 관측성 (Monitoring & Observability)
**What it is**: 프로덕션 모델의 성능 저하, 데이터 드리프트, 인프라 이상을 감지하고 대응합니다.
**Why it matters**: 모델은 배포 순간부터 성능이 저하됩니다. 모니터링 없이는 언제 재학습이 필요한지 알 수 없습니다.
**Key vocabulary**: data drift, concept drift, model decay, prediction monitoring, feature attribution shift
**Connection to other areas**: 서빙 아키텍처에서 메트릭을 수집하고, 파이프라인에 재학습을 트리거합니다.

### Area 4: 피처 스토어 (Feature Store)
**What it is**: 학습과 서빙에 공통으로 사용되는 피처를 중앙에서 관리·제공합니다.
**Why it matters**: 피처 중복 계산, 학습/서빙 불일치(training-serving skew)를 방지합니다.
**Key vocabulary**: online store, offline store, feature freshness, training-serving skew, point-in-time correctness
**Connection to other areas**: 파이프라인의 입력이자 서빙의 의존성입니다.

### Area 5: ML을 위한 CI/CD (CI/CD for ML)
**What it is**: 코드뿐 아니라 데이터와 모델까지 포함하는 지속적 통합/배포 체계입니다.
**Why it matters**: 소프트웨어 CI/CD와 달리 데이터 검증, 모델 성능 검증이 추가됩니다.
**Key vocabulary**: model validation gate, data validation, automated retraining, rollback strategy
**Connection to other areas**: 파이프라인과 서빙을 자동화하고, 모니터링과 연동됩니다.

## Learning Priority Map
Based on your purpose (MLOps 팀 리딩, 아키텍처 의사결정):

**Start here** (highest leverage for your goal):
- Area 1: 모델 서빙 & 배포 — 팀의 가장 가시적인 산출물이자, 아키텍처 결정의 핵심
- Area 3: 모니터링 — 프로덕션 안정성의 핵심, 리더로서 가장 먼저 질문받는 영역

**Learn next**:
- Area 2: 파이프라인 오케스트레이션
- Area 4: 피처 스토어

**Learn later**:
- Area 5: CI/CD for ML

## The Gap Between Here and There
- 모델 정확도와 시스템 안정성은 다른 축이다 — 99% 정확도 모델도 서빙 레이턴시가 SLA를 초과하면 실패
- "최고의 모델"보다 "안정적으로 배포 가능한 모델"이 프로덕션에서 더 가치 있다 — 이 판단을 팀에 설명할 수 있어야 함
- 인프라 팀 리딩은 개인의 기술적 깊이보다 기술적 판단력(어떤 문제를 먼저 풀 것인가)이 핵심
- 데이터 사이언티스트 출신 리더의 가장 큰 위험: 인프라 안정성보다 모델 성능에 과도하게 집중하는 것
