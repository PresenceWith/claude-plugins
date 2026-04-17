# Supply Chain Management & Logistics System Planning: Deep Expert Knowledge Extraction Prompt

## Context

I have been suddenly assigned to plan and design a logistics SCM (Supply Chain Management) system at my company. I have zero prior knowledge in this domain and need to rapidly build enough understanding to communicate with SCM specialists, ask the right questions, and make informed planning decisions. I need you to act as a senior SCM consultant with 20+ years of experience across manufacturing, retail, and 3PL environments who has implemented multiple WMS, TMS, and ERP-integrated SCM systems.

---

## Part 1: Foundational Mental Model

Before diving into details, help me build the right mental model.

1. **Explain the end-to-end supply chain as a flow of five parallel streams**: material, information, money, risk, and decisions. For each stream, describe what moves, who controls it, where bottlenecks typically form, and what happens when one stream gets out of sync with the others.

2. **Draw the canonical supply chain topology** (supplier tiers -> inbound logistics -> manufacturing/assembly -> distribution centers -> outbound logistics -> last mile -> customer -> reverse logistics). For each node, tell me:
   - What data is generated there
   - What decisions are made there
   - What systems typically run there
   - What the "nightmare scenario" is if that node fails

3. **Explain the fundamental trade-offs** that every SCM system must balance:
   - Cost vs. service level
   - Inventory holding vs. stockout risk
   - Centralization vs. responsiveness
   - Visibility vs. complexity
   - Automation vs. flexibility

---

## Part 2: The Vocabulary That Gatekeeps Conversations

SCM experts use terminology that acts as a shibboleth. If I do not know these terms, I will be immediately identified as an outsider and lose credibility. Teach me the following clusters of terms with *precise* definitions, real usage examples, and common misunderstandings:

### Inventory & Demand
- SKU, UOM, lot/batch, serial number
- Safety stock, reorder point (ROP), economic order quantity (EOQ)
- Lead time (and its many subtypes: manufacturing LT, procurement LT, delivery LT, cumulative LT)
- ABC/XYZ analysis, demand sensing vs. demand shaping
- Bullwhip effect -- why it happens and how systems try to dampen it
- FIFO, LIFO, FEFO -- when each is used and why

### Warehousing & Fulfillment
- WMS (Warehouse Management System) -- what it actually controls tick by tick
- Pick/pack/ship cycle, wave picking vs. waveless picking, zone picking, batch picking
- Put-away logic, slotting optimization
- Cross-docking -- when it works and when it does not
- Dock scheduling, yard management
- Cycle counting vs. physical inventory

### Transportation & Logistics
- TMS (Transportation Management System)
- FTL, LTL, parcel, milk run, hub-and-spoke vs. point-to-point
- Freight class, dimensional weight, accessorial charges
- Bill of Lading (BOL), proof of delivery (POD)
- Carrier rate shopping, lane optimization, load consolidation
- Incoterms (EXW, FOB, CIF, DDP) -- which ones shift risk and cost to whom

### Planning & Execution
- S&OP (Sales & Operations Planning) -- the monthly ritual that runs supply chains
- MRP (Material Requirements Planning) vs. MRP II vs. APS (Advanced Planning & Scheduling)
- ATP (Available to Promise) vs. CTP (Capable to Promise)
- MPS (Master Production Schedule)
- Kanban, JIT, JIS (Just in Sequence)

---

## Part 3: Tacit Knowledge -- What Experts Know but Never Write Down

This is the most critical section. I need you to share the unwritten rules, hidden practices, and hard-won lessons that SCM professionals carry in their heads.

### 3.1 The Real Decision-Making Process
- When a planner looks at their screen on Monday morning, what are they actually checking first, second, third? Walk me through the mental workflow.
- What "smells" tell an experienced planner that something is about to go wrong before any alert fires?
- How do experienced SCM professionals handle the gap between what the system recommends and what they actually do? Give me specific examples of when they override the system and why.

### 3.2 The Politics of Supply Chain
- Which departments typically fight with supply chain, and over what? (Sales wanting to promise everything, finance wanting zero inventory, manufacturing wanting long stable runs, etc.)
- How does an experienced SCM leader navigate the S&OP meeting when sales forecasts are clearly inflated?
- What are the unspoken power dynamics between procurement, logistics, warehouse operations, and planning?

### 3.3 Dirty Data and Workarounds
- What master data problems plague every SCM implementation? (Wrong UOMs, duplicate suppliers, inaccurate BOMs, phantom inventory, etc.)
- What Excel spreadsheets and shadow systems exist alongside every "integrated" ERP? Why do they persist?
- What manual processes survive every automation attempt, and why?

### 3.4 Failure Patterns
- What are the top 5 ways SCM system implementations fail? Not the textbook answers -- the real ones that consultants whisper about.
- What happens in the first week after go-live that nobody plans for?
- What are the most common "it worked in testing but not in production" surprises?

### 3.5 Metrics That Actually Matter vs. Metrics That Look Good on Slides
- Which KPIs do operational people actually use daily vs. which ones exist only for executive dashboards?
- How do experienced managers game metrics, and what does that gaming tell you about system design flaws?
- What is the real relationship between perfect order rate, OTIF (On Time In Full), fill rate, and customer satisfaction?

---

## Part 4: System Architecture -- What the IT Team Needs to Know

### 4.1 Integration Landscape
- Draw the typical integration map: ERP <-> WMS <-> TMS <-> OMS <-> Carrier systems <-> Supplier portals <-> Customer portals. For each integration:
  - What data flows in which direction and how frequently?
  - What format is typical (EDI, API, flat file, etc.)?
  - What breaks most often and why?
  - What is the recovery procedure when an integration fails at 2 AM?

### 4.2 Data Architecture
- What are the core master data entities (item master, location master, customer master, supplier master, BOM, routing)?
- What transactional data volumes should we plan for? (orders/day, shipments/day, inventory transactions/day)
- What are the critical data latency requirements? (real-time for what, near-real-time for what, batch is fine for what)
- What reporting/analytics layer is expected? (operational dashboards, tactical planning views, strategic analytics)

### 4.3 Critical Non-Functional Requirements
- What uptime is expected for each system component? What is the cost per hour of downtime for a WMS vs. TMS vs. planning system?
- What are the peak load patterns? (end of month, holiday season, promotional events)
- What audit trail and compliance requirements exist? (lot traceability, customs documentation, hazmat handling)

---

## Part 5: Questions I Should Ask in My First Meetings

Generate a list of 20 high-signal questions I should ask the SCM specialists and stakeholders in my first meetings. These should be questions that:
- Demonstrate I understand the domain well enough to be taken seriously
- Uncover the real pain points (not the official ones)
- Reveal scope, constraints, and hidden assumptions
- Expose political dynamics and competing priorities

For each question, explain *why* it is powerful and what the answer will reveal.

---

## Part 6: Red Flags and Landmines

List the top 15 things that could derail this project, including:
- Scope creep patterns specific to SCM implementations
- Vendor promises that are technically true but practically misleading
- Organizational resistance patterns unique to logistics/warehouse teams
- Data migration traps
- Integration complexity that is routinely underestimated
- Change management failures specific to shift-based warehouse workers

---

## Part 7: Quick Reference -- If I Only Have 48 Hours

If I only have 48 hours before my first serious meeting with SCM specialists, give me:
1. A prioritized reading list (3 books, 5 articles/resources)
2. The 30 most important terms I must know cold
3. A one-page cheat sheet of how a typical order flows from customer click to delivery
4. The 5 most impressive questions I can ask to earn instant credibility
5. The 3 things I must absolutely NOT say or assume

---

## Response Format

Please respond in a structured, detailed manner. Use concrete examples from real industries (retail, manufacturing, food/beverage, electronics) rather than abstract theory. When you describe a process, describe it as a specific person doing a specific thing at a specific time -- not as a flowchart abstraction. Prioritize the knowledge that is hardest to find in textbooks and easiest to get wrong.
