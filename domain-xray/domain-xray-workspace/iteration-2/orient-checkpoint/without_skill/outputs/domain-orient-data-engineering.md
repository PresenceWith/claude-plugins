# 데이터 엔지니어링 도메인 오리엔테이션 가이드

> 대상: 백엔드 개발 3년차, Python/SQL 사용 가능, 데이터 파이프라인/ETL 경험 없음
> 목적: 데이터팀과의 협업을 위한 기초 이해

---

## 1. 데이터 엔지니어링이란?

데이터 엔지니어링은 **데이터를 수집, 변환, 저장, 전달하는 시스템을 설계하고 운영하는 분야**다. 데이터 분석가나 데이터 사이언티스트가 "깨끗한 데이터"를 쓸 수 있도록 뒤에서 인프라를 만드는 역할이다.

백엔드 개발자로 비유하면:
- 백엔드 개발자가 **사용자 요청을 처리하는 시스템**을 만든다면
- 데이터 엔지니어는 **데이터 요청을 처리하는 시스템**을 만든다

---

## 2. 핵심 영역 지도

### 2.1 데이터 파이프라인 (Data Pipeline)

데이터가 A 지점에서 B 지점으로 흐르는 전체 경로를 말한다.

```
[소스] → [수집] → [변환] → [저장] → [서빙]
 DB        Kafka    Spark    BigQuery   Dashboard
 API       Airflow  dbt      S3         ML Model
 로그       Fivetran Python   Snowflake  API
```

**백엔드 개발자 관점에서의 매핑:**
- 소스(Source): 너의 백엔드 서버가 만드는 DB 레코드, 로그, 이벤트
- 수집(Ingestion): API 호출해서 데이터 가져오는 것과 비슷
- 변환(Transformation): 비즈니스 로직을 데이터에 적용하는 과정
- 저장(Storage): DB에 넣는 것과 비슷하지만, 분석에 최적화된 저장소 사용
- 서빙(Serving): 최종 사용자(분석가, 대시보드)에 데이터 전달

### 2.2 ETL vs ELT

| 구분 | ETL | ELT |
|------|-----|-----|
| 순서 | Extract → Transform → Load | Extract → Load → Transform |
| 변환 위치 | 파이프라인 중간 | 데이터 웨어하우스 안에서 |
| 대표 도구 | Informatica, Talend | dbt, Snowflake |
| 최근 트렌드 | 레거시 | 현대적 접근 |

현재는 **ELT**가 주류다. 클라우드 데이터 웨어하우스(BigQuery, Snowflake)의 연산 능력이 충분히 강력해져서, 일단 원본 데이터를 적재한 뒤 SQL로 변환하는 방식이 더 효율적이기 때문이다.

### 2.3 배치(Batch) vs 스트리밍(Streaming)

| 구분 | 배치 처리 | 스트리밍 처리 |
|------|-----------|---------------|
| 주기 | 시간/일 단위 | 실시간 또는 준실시간 |
| 도구 | Airflow, Spark | Kafka, Flink, Spark Streaming |
| 용도 | 일일 리포트, 월간 집계 | 실시간 대시보드, 이상 탐지 |
| 복잡도 | 상대적으로 낮음 | 높음 |

대부분의 회사에서 **배치 처리가 80% 이상**을 차지한다. 스트리밍은 필요한 경우에만 도입한다.

---

## 3. 주요 기술 스택

### 3.1 오케스트레이션 (워크플로우 관리)

파이프라인의 실행 순서와 스케줄을 관리하는 도구.

- **Apache Airflow**: 업계 표준. Python으로 DAG(방향성 비순환 그래프)를 정의
- **Dagster**: 최신 대안. 데이터 자산(asset) 중심의 접근
- **Prefect**: Airflow보다 간단한 API

```python
# Airflow DAG 예시 (개념 이해용)
from airflow import DAG
from airflow.operators.python import PythonOperator

with DAG('daily_sales_pipeline', schedule='@daily') as dag:
    extract = PythonOperator(task_id='extract', python_callable=extract_sales)
    transform = PythonOperator(task_id='transform', python_callable=transform_sales)
    load = PythonOperator(task_id='load', python_callable=load_to_warehouse)

    extract >> transform >> load
```

### 3.2 데이터 변환

- **dbt (data build tool)**: SQL 기반 변환 도구. 가장 중요한 도구 중 하나
- **Spark (PySpark)**: 대용량 분산 처리. Python/SQL 모두 사용 가능
- **Pandas**: 소규모 데이터 변환에 적합 (이미 알고 있을 수 있음)

### 3.3 데이터 저장소

| 유형 | 설명 | 예시 |
|------|------|------|
| 데이터 웨어하우스 | 구조화된 분석용 저장소 | BigQuery, Snowflake, Redshift |
| 데이터 레이크 | 원본 데이터를 그대로 저장 | S3, GCS, Azure Blob |
| 데이터 레이크하우스 | 웨어하우스 + 레이크 결합 | Databricks, Delta Lake |

### 3.4 수집/스트리밍

- **Apache Kafka**: 이벤트 스트리밍 플랫폼. 메시지 큐와 비슷하지만 더 강력
- **Fivetran / Airbyte**: 외부 소스에서 데이터를 자동으로 가져오는 관리형 도구

---

## 4. 백엔드 개발자가 이미 알고 있는 것과의 연결

| 백엔드에서 아는 개념 | 데이터 엔지니어링 대응 |
|----------------------|----------------------|
| REST API | 데이터 수집(Ingestion) 소스 |
| 크론잡(Cron) | Airflow DAG 스케줄링 |
| ORM / 쿼리 빌더 | dbt 모델 (SQL 기반) |
| 마이크로서비스 | 파이프라인의 각 태스크 |
| 로그 수집 (ELK 등) | 데이터 파이프라인의 일종 |
| DB 마이그레이션 | 스키마 진화(Schema Evolution) |
| CI/CD | 데이터 파이프라인 테스트 + 배포 |
| 모니터링/알림 | 데이터 품질 모니터링(Data Observability) |

---

## 5. 데이터팀 협업 시 알아야 할 용어

- **스키마(Schema)**: 테이블 구조 정의. 백엔드 DB 스키마와 동일 개념
- **파티셔닝(Partitioning)**: 대용량 테이블을 날짜 등으로 분할 저장
- **이디엄포턴시(Idempotency)**: 같은 파이프라인을 여러 번 실행해도 결과가 같음. 재실행 안전성
- **백필(Backfill)**: 과거 데이터를 소급해서 다시 처리하는 작업
- **SLA**: 데이터가 준비되어야 하는 시간 약속 (예: "매일 오전 9시까지")
- **데이터 리니지(Lineage)**: 데이터가 어디서 와서 어떻게 변환되었는지 추적
- **데이터 카탈로그**: 조직의 데이터 자산 목록. 어떤 테이블에 무슨 데이터가 있는지
- **CDC (Change Data Capture)**: DB 변경분만 캡처해서 전달. 백엔드 DB → 데이터 웨어하우스 동기화에 자주 사용

---

## 6. 학습 우선순위 로드맵

데이터팀 협업이 목적이라면, 아래 순서로 학습하는 것이 효율적이다.

### Phase 1: 즉시 필요 (1-2주)

1. **SQL 심화** — 윈도우 함수, CTE, 집계 함수를 자유자재로 쓸 수 있어야 한다
2. **데이터 웨어하우스 기본 개념** — 칼럼형 저장, 파티셔닝, 스타 스키마
3. **dbt 기초** — SELECT 문으로 데이터 변환 모델을 작성하는 방법

### Phase 2: 협업 역량 (2-4주)

4. **Airflow 기초** — DAG 읽고 이해하기, 간단한 DAG 작성
5. **데이터 모델링** — 차원 모델링(Kimball), 정규화 vs 비정규화 트레이드오프
6. **데이터 품질** — 테스트 작성, 이상치 감지, 모니터링 개념

### Phase 3: 심화 (필요 시)

7. **Kafka/이벤트 스트리밍** — 실시간 데이터 처리가 필요할 때
8. **Spark/분산 처리** — 데이터 규모가 단일 머신으로 처리 불가능할 때
9. **데이터 거버넌스** — 접근 제어, 개인정보 처리, 규정 준수

---

## 7. 추천 학습 자료

### 책
- *Fundamentals of Data Engineering* (Joe Reis, Matt Housley) — 데이터 엔지니어링 전체를 조망하는 최고의 입문서
- *The Data Warehouse Toolkit* (Ralph Kimball) — 차원 모델링의 바이블

### 온라인
- **dbt Learn** (courses.getdbt.com) — dbt 공식 무료 강의
- **Airflow 공식 튜토리얼** — 기본 개념과 첫 DAG 작성
- **DataTalksClub Data Engineering Zoomcamp** — 무료, 실습 중심 부트캠프

### 실습
- 자신의 백엔드 서비스 DB에서 데이터를 추출해서 간단한 분석용 테이블을 만들어보기
- dbt로 간단한 프로젝트 하나 만들어보기 (로컬 PostgreSQL + dbt Core)

---

## 8. 데이터팀과 일할 때 실전 팁

1. **이벤트 설계를 함께 하자**: 백엔드에서 발생하는 이벤트/로그가 데이터팀의 원재료다. 어떤 필드가 필요한지 미리 논의하면 나중에 재작업을 줄일 수 있다.

2. **스키마 변경은 미리 알려라**: 테이블 칼럼을 바꾸거나 삭제하면 데이터 파이프라인이 깨질 수 있다. 마이그레이션 전에 데이터팀에 공유하자.

3. **API 응답 형태를 일관되게 유지하라**: 데이터팀이 API에서 데이터를 수집한다면, 응답 스키마의 breaking change는 파이프라인 장애로 이어진다.

4. **타임스탬프는 UTC로 통일하라**: 시간대 혼란은 데이터 분석에서 가장 흔한 버그 원인 중 하나다.

5. **삭제보다 소프트 딜리트를 고려하라**: 데이터팀은 과거 데이터도 분석에 사용한다. 하드 딜리트는 데이터 유실로 이어질 수 있다.
