[Context]
I am a complete beginner with absolutely no knowledge in the field of Data Engineering — encompassing data pipeline design (ETL/ELT patterns, DAG construction, backfill strategies, idempotency guarantees, and data lineage tracking), data storage architecture (data warehouses, data lakes, lakehouse paradigms, partitioning strategies, columnar formats like Parquet, and schema-on-read vs schema-on-write trade-offs), workflow orchestration (scheduling, task dependency management, failure handling, retry logic, and SLA enforcement using tools like Airflow, Dagster, and Prefect), data quality management (data validation, schema drift detection, freshness monitoring, completeness checks, anomaly detection, and data contracts), stream processing (event streaming with Kafka, windowing strategies, exactly-once processing semantics, consumer groups, offset management, and back-pressure handling), and data modeling (dimensional modeling with star and snowflake schemas, fact and dimension tables, slowly changing dimensions, grain definition, and strategic denormalization) — covering the full lifecycle from raw data ingestion through transformation, storage, quality assurance, and serving layers that enable analytics and machine learning workloads, and I currently need to accomplish collaborating effectively with a data engineering team as a backend developer transitioning into data-intensive work — requiring the ability to speak the same language as data engineers during pipeline design reviews, understand why certain storage and partitioning decisions are made and their cost/performance implications, evaluate data quality issues when upstream schema changes break downstream pipelines, ask informed questions about orchestration strategies and failure recovery, bridge existing backend development mental models (API request/response flows, CI/CD deployment pipelines, Python programming, and SQL query experience) into their data engineering equivalents (batch/streaming pipelines, pipeline orchestration as "data CI/CD," PySpark and pandas for large-scale data processing, and SQL for complex transformations at scale), and make sound architectural judgments when backend systems need to feed data into or consume data from the data platform. In order to communicate clearly with experts and AI, I want to completely deconstruct and understand not superficial knowledge but the 'tacit knowledge that exists only in experts' minds' and 'practical workflows' of this field.

[Scope]
Based on my current priorities, please focus especially deeply on these areas (in order of importance): 1. Data Pipeline Design (ETL/ELT patterns, DAG construction, backfill, idempotency, data lineage), 2. Data Quality Management (validation, schema drift, freshness, completeness, anomaly detection, data contracts), 3. Data Storage Architecture (warehouse vs lake vs lakehouse, partitioning, columnar formats), 4. Data Modeling (dimensional modeling, star schema, fact/dimension tables, SCD, grain). Cover other areas (Workflow Orchestration, Stream Processing) at a lighter level for context, but invest your depth budget here.

[Task]
You are a top-tier expert who has spent 20+ years in this domain, and a mentor who perfectly understands the beginner's 'Curse of Knowledge.' Please excavate to encyclopedia-level depth the foundational knowledge that practitioners use as naturally as breathing and therefore never bother to explain — the omitted intermediate steps, the implicit preconditions.

As a beginner, I don't even know how this domain is structured. Therefore, please first define the entire lifecycle or core workflow of this work into logical stages, and for each stage, describe in detail the following elements:

Practical Terminology and Jargon: Not dictionary definitions, but the nuances and context as actually used in the field.

Hidden Preconditions: Omitted actions or foundational knowledge where experts think "they obviously did A already."

Beginner's Traps: Critical mistakes or misunderstandings beginners commonly make because they lack this tacit knowledge.

Rules of Thumb: Criteria practitioners use for decision-making that aren't found in textbooks.

[Output Constraint]

Depth Over Volume: For each axis, prioritize concrete scenarios, specific examples, and edge cases over exhaustive listing. Three deeply-explained traps are worth more than ten shallow ones.

Format: Use rich descriptive paragraphs with clear hierarchical structure (Heading 1, 2, 3). Avoid simple bulleted lists. Never use emojis.

Specificity: Every rule of thumb should include when it applies AND when it breaks down. Every trap should include a concrete scenario showing how it manifests in practice.

Response Language: Korean. Use this language for all explanations and descriptions. Keep domain-specific technical terms in their original English form with a brief translation on first use.

Continuity: If you reach the output limit and the response is incomplete, write ">>> CONTINUE FROM HERE <<<" at the end.
