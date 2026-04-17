# Prompt: Extracting Deep Tacit and Expert Knowledge from the Data Analysis Domain

Use this prompt in a fresh AI conversation to extract the kind of knowledge that experienced data analysts carry but rarely articulate — the intuitions, judgment calls, failure patterns, and hard-won heuristics that separate a seasoned practitioner from someone who merely knows the textbook definitions.

---

## Prompt

You are an expert data analyst with 15+ years of hands-on experience across industries (tech, finance, healthcare, e-commerce). I want you to share the deep, tacit knowledge that experienced data analysts possess but that is almost never written down in textbooks, courses, or documentation. This is the knowledge that takes years of practice to develop — the intuitions, the pattern recognition, the "smell tests," and the judgment calls that separate a senior analyst from a junior one.

I have a solid understanding of the data analysis landscape, which covers these seven areas: (1) data collection and storage, (2) data cleaning and preprocessing, (3) exploratory data analysis, (4) statistical analysis and inference, (5) data visualization, (6) BI reporting and dashboards, and (7) communicating analysis results. I already know the standard definitions and workflows. What I need from you is the layer beneath that — the stuff you only learn by doing.

Please address each of the following dimensions of tacit knowledge. For each one, give concrete, specific examples rather than abstract advice.

### 1. Perceptual Intuitions and Pattern Recognition

What do experienced data analysts "see" that beginners miss when they first look at a dataset? Describe the instant gut reactions and mental alarm bells — for example, when a distribution looks "wrong," when a join has silently duplicated rows, or when a metric is suspiciously clean. What does a trained eye notice in the first 60 seconds of looking at data?

### 2. Failure Modes and "Smell Tests"

What are the most common ways data analysis goes wrong that nobody warns you about? Not textbook errors (like confusing correlation and causation), but the subtle, real-world traps: survivorship bias in your dataset, a silently broken ETL pipeline, a metric definition that drifted over time, a stakeholder question that is actually unanswerable with available data. What are the "data smells" that signal something is off before you can prove it?

### 3. Judgment Calls That Cannot Be Automated

Where in the analysis workflow do experienced analysts rely on subjective judgment that no rule or algorithm can replace? For instance: deciding whether an outlier is an error or a genuine signal, choosing which level of granularity to present to a specific audience, knowing when "good enough" data quality is actually good enough vs. when it will silently corrupt your conclusions. Walk through the decision-making process you use internally.

### 4. The Political and Social Dimension

What do experienced analysts understand about the organizational and human dynamics around data that beginners are blind to? For example: how to handle a stakeholder who has already decided what the data should say, how to present findings that contradict a senior leader's pet initiative, when to push back on a request vs. when to just deliver what was asked, how to navigate "data ownership" turf wars. What are the unwritten rules?

### 5. Workflow and Craft Heuristics

What are the personal rituals, habits, or micro-practices that experienced analysts follow that they would never think to teach? For example: always checking row counts before and after every join, keeping a running "analysis diary" of dead ends, building a throwaway exploratory notebook before committing to an approach, having a personal library of sanity-check queries. What does your actual day-to-day process look like in a way that no course would describe?

### 6. The Art of Asking the Right Question

How do experienced analysts translate a vague business request ("tell me about churn") into a precise, answerable analytical question? What is the internal dialogue? What clarifying questions do you always ask, and what signals tell you that the requester doesn't actually know what they need? How do you handle the gap between what was asked and what should have been asked?

### 7. Knowing What You Cannot Know

What are the limits that experienced analysts are always aware of but rarely state? For example: when sample size makes a conclusion unreliable even if the p-value is significant, when the data generation process itself is biased in ways that no statistical correction can fix, when a predictive model works but for reasons that are accidental rather than causal. How do you develop the instinct for epistemic humility in data work?

### 8. Transfer Across Domains

When an experienced analyst moves from, say, e-commerce analytics to healthcare analytics, what transfers and what does not? What is the "universal analyst skill" vs. what is deeply domain-specific? How do you accelerate your ramp-up in a new domain, and what mistakes do analysts typically make when they assume their old domain knowledge applies?

---

For each dimension, please provide:
- At least 2-3 specific, concrete examples or anecdotes (real or realistic)
- The underlying principle or heuristic that the example illustrates
- How a beginner would typically get this wrong
- How long it typically takes to develop this particular intuition

Be honest about the parts of data analysis that are genuinely hard and that remain hard even with experience. Do not sanitize or simplify.
