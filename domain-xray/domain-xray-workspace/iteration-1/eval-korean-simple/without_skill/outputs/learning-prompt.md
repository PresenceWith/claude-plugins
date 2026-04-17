# Deep Learning Prompt: Data Analysis

Use the following prompt with an AI assistant to extract expert-level, tacit knowledge about the data analysis field.

---

## The Prompt

You are a senior data analyst with 15+ years of experience across industries including finance, healthcare, e-commerce, and tech. You have led analytics teams, built data infrastructure from scratch, and have deep scars from production failures, misleading analyses, and hard-won successes.

I want to deeply learn data analysis — not the textbook version, but the real craft as practiced by experts. Please teach me by covering each of the following dimensions in depth. For every dimension, go beyond what tutorials teach. Share the tacit knowledge: the unwritten rules, the things you only learn by doing, the judgment calls that separate a junior analyst from a senior one.

---

### 1. The Real Workflow (Not the Textbook One)

Walk me through what a data analysis project actually looks like from start to finish in a professional setting. Cover:

- How do you actually receive and scope an analysis request? What questions do you ask the stakeholder before touching any data?
- What does "understanding the business context" really mean in practice? How do you avoid building a technically correct but strategically useless analysis?
- What does the real data exploration phase look like — the messy, iterative, dead-end-filled version?
- How do you decide when you have explored enough and it is time to commit to an approach?
- How do you handle the moment when your analysis contradicts what the stakeholder expected or wanted to hear?

---

### 2. Data Quality and Trust

This is where most analyses silently fail. Teach me:

- What are the most common ways data lies to you? Not obvious issues like missing values, but subtle ones — survivorship bias in your dataset, silent schema changes, timezone mismatches, duplicate records that look different, joins that silently multiply rows.
- What is your personal checklist or ritual when you first encounter a new dataset? What do you always check before trusting any column?
- How do you develop intuition for when numbers "feel wrong"? What does that intuition actually consist of?
- How do you handle the political situation where the data quality is poor but the organization does not want to hear that?

---

### 3. Statistical Thinking That Actually Matters

Not a statistics textbook review — the statistical concepts that practicing analysts actually use and the mistakes they actually make:

- Which statistical concepts do you use every single week, and which ones from your education have you almost never used?
- What are the most common statistical mistakes you see even experienced analysts make? (e.g., confusing correlation directions, Simpson's paradox in segmented data, p-hacking through iterative filtering)
- How do you actually think about causation vs. correlation in a business context where you rarely get to run clean experiments?
- When is "good enough" statistical rigor acceptable, and when must you be rigorous? How do you make that judgment call?

---

### 4. Tool Mastery and Hidden Productivity

Beyond knowing the syntax — the craft of being fast and reliable:

- What does expert-level SQL actually look like? What patterns, CTEs, window functions, or query structures do senior analysts use that juniors do not?
- In Python/R, what separates a data analyst who codes from a data analyst who is a proficient programmer? What libraries, patterns, or habits make the difference?
- How do you structure your analysis projects (files, notebooks, scripts) so that you can reproduce them six months later? What does your personal project template look like?
- What is your approach to version control for analyses that are not traditional software? How do you track which version of a query or notebook produced a specific result?
- What visualization choices do you make that you never see beginners make? What are the most impactful "small decisions" in chart design?

---

### 5. Communication and Influence

The part that determines whether your analysis changes anything:

- How do you structure a data presentation for executives vs. for technical peers vs. for cross-functional partners?
- What makes an analysis "actionable" vs. merely "interesting"? How do you bridge that gap?
- How do you handle the situation where someone challenges your methodology in a meeting? What is the right posture?
- What is the art of the "executive summary" — how do you compress weeks of work into 3 sentences that drive a decision?
- How do you say "the data does not support that conclusion" diplomatically when someone senior has already committed to a narrative?

---

### 6. Career and Domain Knowledge

The meta-skills that compound over a career:

- What domain knowledge has been most valuable to you, and how did you acquire it? (e.g., understanding how marketing funnels work, how financial instruments are priced, how clinical trials are structured)
- What is the difference between a data analyst who stays an individual contributor forever and one who grows into a principal/staff analyst or analytics leader? What skills matter for that transition?
- How do you stay current? What do you actually read, follow, or practice?
- What would you do differently if you were starting your data analysis career today?

---

### 7. The Failure Museum

The most educational part — real patterns of failure:

- Describe 5 archetypal analysis failures you have seen or experienced. For each one, explain what went wrong, why it was not caught, and what systemic fix prevents it.
- What are the warning signs that an analysis is going off the rails? What do you watch for in your own work?
- How do you build a personal "pre-mortem" habit — imagining how your analysis could be wrong before you present it?

---

### 8. Advanced Topics That Separate Senior from Staff-Level

For when someone has mastered the basics and wants to reach the next level:

- How do you design metrics and KPIs from scratch for a new product or business line? What makes a metric good vs. a vanity metric?
- How do you build and maintain a data model or semantic layer that the whole organization trusts?
- What does "experimentation culture" look like in practice, and what is the analyst's role in designing and interpreting A/B tests?
- How do you think about building analytical frameworks that outlast any single analysis — reusable mental models, dashboards that answer recurring questions, self-serve analytics that reduce your own bottleneck?

---

## How to Use This Prompt

1. **Paste the entire prompt above** into a conversation with an AI assistant (Claude, etc.)
2. **Ask it to address one section at a time** for depth, or all sections for breadth.
3. **Follow up aggressively** — when the AI gives a general answer, push back: "Give me a specific example," "What would that look like in code?", "What is the most common mistake here?"
4. **Apply immediately** — after each section, pick one concept and apply it to a real or practice dataset.
5. **Iterate** — revisit sections after you have more experience. The same questions yield richer answers when you bring context from your own work.

---

## Suggested Follow-Up Prompts

After working through the main prompt, use these to go deeper:

- "Show me the SQL query patterns you described in section 4, with real examples using a sample e-commerce dataset."
- "Walk me through a specific example of Simpson's paradox in business data and how you would detect and communicate it."
- "Give me a realistic messy dataset scenario and guide me through your exact data cleaning workflow, including the judgment calls."
- "Role-play: you are a stakeholder who just asked me to analyze customer churn. I will scope the project and you tell me what a senior analyst would do differently."
- "Review this analysis I did and tell me what a staff-level analyst would critique or improve."
