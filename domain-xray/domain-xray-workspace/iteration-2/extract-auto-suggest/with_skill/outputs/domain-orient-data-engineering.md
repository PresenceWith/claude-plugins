# 데이터 엔지니어링 Orientation Map

## Why This Map
이 맵은 데이터 엔지니어링이라는 광범위한 분야를 학습 가능한 구조로 정리한 것입니다. 백엔드 개발 경험을 가진 학습자가 데이터팀과 협업하기 위해 필요한 핵심 영역과 우선순위를 제공합니다.

## Your Anchor Points
- **Python 프로그래밍**: 당신이 이미 사용하는 Python은 데이터 엔지니어링의 주력 언어입니다. pandas, PySpark 등 데이터 처리 라이브러리의 기반이 됩니다.
- **SQL 쿼리 경험**: SELECT/JOIN/GROUP BY를 아는 것은 데이터 엔지니어링의 절반입니다. 여기서는 이를 대규모 데이터셋과 복잡한 변환에 적용하는 방법을 배웁니다.
- **백엔드 API 설계**: API 요청/응답 흐름을 이해한다면, 데이터 파이프라인의 입력/변환/출력 흐름도 같은 패턴입니다. 차이점은 배치 처리와 실시간 스트리밍입니다.
- **서버 배포 경험**: CI/CD를 통한 배포 경험이 있다면, 데이터 파이프라인의 오케스트레이션(Airflow 등)은 "데이터 버전의 CI/CD"로 이해할 수 있습니다.

## Domain Landscape

### Area 1: 데이터 파이프라인 설계 (Data Pipeline Design)
**What it is**: 원시 데이터를 수집하여 사용 가능한 형태로 변환하는 전체 흐름을 설계하고 구현하는 일입니다. ETL(Extract-Transform-Load) 또는 ELT 패턴을 사용합니다.
**Why it matters**: 파이프라인이 없으면 데이터는 흩어진 원석에 불과합니다. 모든 분석과 ML 모델은 잘 설계된 파이프라인 위에서 동작합니다.
**Key vocabulary**: ETL/ELT, DAG (Directed Acyclic Graph), backfill, idempotency, data lineage
**Connection to other areas**: 스토리지 아키텍처의 입력이 되고, 데이터 품질 관리와 직결됩니다.

### Area 2: 데이터 스토리지 아키텍처 (Storage Architecture)
**What it is**: 데이터를 어디에, 어떤 형식으로, 어떤 구조로 저장할지 결정합니다. 데이터 웨어하우스, 데이터 레이크, 레이크하우스 중 선택합니다.
**Why it matters**: 잘못된 스토리지 선택은 쿼리 성능 10-100배 차이, 비용 폭발, 데이터 접근성 저하로 이어집니다.
**Key vocabulary**: data warehouse, data lake, lakehouse, partitioning, columnar format (Parquet), schema-on-read vs schema-on-write
**Connection to other areas**: 파이프라인의 목적지이자 분석/서빙의 출발점입니다.

### Area 3: 워크플로우 오케스트레이션 (Workflow Orchestration)
**What it is**: 여러 파이프라인 작업의 실행 순서, 스케줄링, 실패 처리, 재시도를 관리합니다. Airflow, Dagster, Prefect 같은 도구를 사용합니다.
**Why it matters**: 파이프라인 하나는 스크립트로 충분하지만, 수십 개의 상호 의존적 파이프라인은 오케스트레이터 없이 관리 불가능합니다.
**Key vocabulary**: DAG, task dependency, scheduler, sensor, backfill, SLA
**Connection to other areas**: 모든 파이프라인의 실행 제어를 담당합니다.

### Area 4: 데이터 품질 관리 (Data Quality)
**What it is**: 데이터가 정확하고, 완전하고, 일관되며, 시의적절한지 검증하고 모니터링합니다.
**Why it matters**: "Garbage in, garbage out" — 품질이 보장되지 않은 데이터로 내린 비즈니스 결정은 위험합니다.
**Key vocabulary**: data validation, schema drift, freshness, completeness, anomaly detection, data contract
**Connection to other areas**: 파이프라인의 모든 단계에 걸쳐 적용됩니다.

### Area 5: 실시간 데이터 처리 (Stream Processing)
**What it is**: 배치가 아닌 실시간으로 들어오는 데이터를 처리합니다. Kafka, Flink, Spark Streaming 등을 사용합니다.
**Why it matters**: 실시간 대시보드, 이상 탐지, 추천 시스템 등 지연 시간이 중요한 유스케이스에 필수입니다.
**Key vocabulary**: event streaming, consumer group, offset, windowing, exactly-once processing, back-pressure
**Connection to other areas**: 배치 파이프라인과 상호 보완적이며, 스토리지 아키텍처에 영향을 줍니다.

### Area 6: 데이터 모델링 (Data Modeling)
**What it is**: 비즈니스 개념을 테이블과 관계로 구조화합니다. 분석 최적화를 위한 dimensional modeling(star schema, snowflake)이 핵심입니다.
**Why it matters**: 좋은 모델링은 복잡한 비즈니스 질문을 단순한 쿼리로 바꿉니다. 나쁜 모델링은 매번 조인 지옥을 만듭니다.
**Key vocabulary**: fact table, dimension table, star schema, slowly changing dimension (SCD), grain, denormalization
**Connection to other areas**: 스토리지 설계의 논리적 기반이며, 파이프라인이 구현합니다.

## Learning Priority Map
Based on your situation (백엔드 개발자, 데이터팀 협업 필요):

**Start here** (highest leverage for your goal):
- Area 1: 데이터 파이프라인 설계 — 협업 시 가장 자주 논의되는 주제이고, 백엔드 경험과 가장 자연스럽게 연결됩니다
- Area 4: 데이터 품질 관리 — 데이터팀과의 대화에서 "이 데이터 믿을 수 있어?"는 가장 흔한 질문입니다

**Learn next** (important but not urgent):
- Area 2: 데이터 스토리지 아키텍처
- Area 6: 데이터 모델링

**Learn later** (valuable but can wait):
- Area 3: 워크플로우 오케스트레이션
- Area 5: 실시간 데이터 처리

## What Experts Know That You Don't (Yet)
- 파이프라인은 "코드"가 아니라 "시스템"이다 — 실패는 정상이고, 복구 설계가 핵심
- 스키마 변경은 데이터 엔지니어의 가장 큰 적이다 — upstream이 바뀌면 모든 것이 깨진다
- "정확한 데이터"보다 "언제 기준의 데이터인지"가 더 중요한 질문이다
- 데이터 엔지니어는 코드를 짜는 시간보다 디버깅과 모니터링에 더 많은 시간을 쓴다
- 완벽한 파이프라인보다 관찰 가능한(observable) 파이프라인이 프로덕션에서 살아남는다
