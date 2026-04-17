[Context]
I am working in the field of Data Engineering — encompassing data pipeline design (ETL/ELT), storage architecture (warehouse/lake/lakehouse), workflow orchestration, data quality management, stream processing, and data modeling, along with the practical workflows connecting raw data sources through transformation to analytics-ready datasets. My current background: I am a backend developer with 3 years of experience in Python and SQL. I understand API design, CI/CD pipelines, and server deployment well, but I have no exposure to data pipelines, ETL processes, or data warehousing. I need to communicate credibly with a data engineering team and participate meaningfully in cross-team technical discussions about data infrastructure decisions — understanding their proposals, asking informed questions, and bridging backend concerns with data engineering tradeoffs. To bridge the gap between where I am and where I need to be, I want to deeply understand the tacit knowledge — the practical expertise that practitioners use instinctively but rarely explain.

[Scope]
Based on my priorities, please focus especially deeply on these areas (in order of importance): Data Pipeline Design (ETL/ELT patterns, DAGs, backfill, idempotency, data lineage), Data Quality Management (validation, schema drift, freshness, completeness, anomaly detection, data contracts), and Data Storage Architecture (warehouse vs. lake vs. lakehouse, partitioning, columnar formats, schema-on-read vs. schema-on-write). Cover other areas (workflow orchestration, stream processing, data modeling) at a lighter level for context, but invest your depth budget here.

[Task]
You are a top-tier expert who has spent 20+ years in data engineering, and a mentor who understands exactly where I'm coming from (a backend developer fluent in Python/SQL but new to data infrastructure) and where I need to go (participating credibly in data team architecture discussions and bridging backend and data engineering concerns). Please excavate the knowledge that will be most impactful for my specific purpose.

First, define the entire lifecycle or core workflow of data engineering into logical stages. For each stage, describe in detail the following elements:

Vocabulary in Context: Terms and phrases that mean different things to backend engineers versus data engineers — where miscommunication hides. For example, "schema" in a backend API context versus a data warehouse context, or "pipeline" as a CI/CD concept versus an ETL concept. Identify the specific terms where my backend vocabulary will create false confidence or misunderstanding, and explain what data engineers actually mean when they use them.

Unstated Assumptions: What data engineers assume you already know when they talk about their work — the knowledge gap that creates talking-past-each-other moments. These are the things they will never explain in a meeting because "everyone knows that." For instance, assumptions about how data freshness works, why idempotency matters differently in data contexts, or what "the pipeline broke" actually implies about the state of downstream systems.

Question Patterns: The questions that earn respect and demonstrate understanding versus the ones that immediately mark you as someone who does not understand the domain. What should I ask when reviewing a data team proposal? What questions reveal that I understand the real constraints? And equally important — what questions should I avoid because they betray fundamental misconceptions about how data systems work?

Translation Points: Where my existing backend development experience maps directly onto data engineering concepts — and critically, where the analogy breaks down and will mislead me. For example, where CI/CD thinking helps me understand orchestration, but where it will give me wrong intuitions about failure handling. Where API request/response patterns help me grasp pipeline flow, but where batch-versus-streaming thinking requires a fundamentally different mental model.

[Output Constraint]

Depth Over Volume: For each axis, prioritize concrete scenarios, specific examples, and edge cases over exhaustive listing. Three deeply-explained items are worth more than ten shallow ones.

Level Calibration: I already know Python programming, SQL queries (SELECT/JOIN/GROUP BY/subqueries), REST API design patterns, CI/CD deployment workflows, server infrastructure basics, and general software engineering practices. Don't explain these basics — start from where my knowledge ends and go deeper into data engineering territory.

Format: Use rich descriptive paragraphs with clear hierarchical structure (Heading 1, 2, 3). Avoid simple bulleted lists. Never use emojis.

Specificity: Every heuristic should include when it applies AND when it breaks down. Every pitfall should include a concrete scenario showing how it manifests in practice.

Response Language: Korean. Use this language for all explanations. Keep domain-specific technical terms in their original English form with a brief translation on first use.

Continuity: If you reach the output limit and the response is incomplete, write ">>> CONTINUE FROM HERE <<<" at the end.
