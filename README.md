# DE-Intelligence-Kit

### A Data Engineering Intelligence Platform

**Built on The Modern Prometheus Framework**

Demo 1 (Human-Relay) \+ Demo 2 (Autonomous MCP via Claude Code) \+ Demo 3 (ETL Watermarks & Concentration Risk)

Built on The Modern Prometheus framework by Anshar Seraphim — github.com/AnsharSeraphim/TheModernPrometheus

Martin Alvarez | June 2026

---

**Documentation policy** (see Section 11): this file, `README.md`, is the canonical, version-controlled source of truth for this project — updated every session. `DE-Intelligence-Kit-README.docx` is a periodically-refreshed companion presentation document, re-flowed from this file's content; it is not required to stay in lockstep. If the two ever conflict, **this file wins**.

---

## 1\. The Modern Prometheus Framework

### The Problem It Solves

Anyone who has worked with AI assistants on complex, multi-step projects has run into the same wall: the AI doesn't remember. Each new conversation starts from zero. Business rules explained last week are gone. Decisions made last month need to be re-explained. The work done to calibrate the assistant evaporates when the session ends.

For simple tasks — drafting an email, explaining a concept — this is fine. For serious work — designing a data pipeline, governing a multi-week project — it is a fundamental barrier. Anshar Seraphim identified three distinct failure modes in agentic AI workflows:

- **Session statelessness** — the AI forgets everything when the conversation ends  
- **Checklist churn** — governance artifacts get created once and never referenced again  
- **Evidence loss** — the reasoning behind a decision disappears, leaving only the decision itself

### What It Is

The Modern Prometheus is an open governance framework for deploying AI assistants as persistent, governed, multi-project agents. It was created by Anshar Seraphim — systems thinker, neurodivergent professional, and framework architect — and released as an open framework for practitioners across any domain.

The framework is not software. It does not require a server, a database, or a cloud subscription. It lives in four files you own, version, and control:

- **A behavioral constitution** — defines how the assistant thinks, communicates, and escalates; loaded automatically at the start of every session  
- **An agent roster** — a catalog of named specialist roles, each with defined capabilities and responsibilities  
- **A project registry** — a structured memory file capturing business rules, decisions, and lineage in a format that survives context window boundaries  
- **A deployment checklist** — a phase-by-phase activation guide that calibrates assistant behavior from zero to fully operational

Together, these four files turn a general-purpose AI assistant into a governed, session-persistent, domain-specific intelligence — one that remembers what matters, flags what it doesn't know, and explains its reasoning in terms both engineers and executives can understand.

### Why It Works Across Domains

The Modern Prometheus was designed to be domain-agnostic. Anshar has applied it to software development, creative production, legal document review, and data engineering. The governance architecture transfers unchanged across all of them. What changes is the content of the files — the agent roles, the business rules, the escalation conditions — not the structure that holds them together.

### Framework Credit

This project is built on The Modern Prometheus, an open governance framework created by Anshar Seraphim — systems thinker, neurodivergent professional, and framework architect. Anshar designed The Modern Prometheus to solve the core problems of agentic AI workflows: session statelessness, checklist churn, and evidence loss. Its governance architecture is domain-agnostic and has been successfully applied to software, creative production, data engineering, and beyond. Used here with Anshar's knowledge and permission.

Framework repository: github.com/AnsharSeraphim/TheModernPrometheus

---

## 2\. The DE-Intelligence-Kit

### What It Is Today

The DE-Intelligence-Kit is a self-contained deployment of The Modern Prometheus framework, purpose-built for data engineering work. It turns a Claude AI assistant into a governed data engineering intelligence capable of:

- Designing and reviewing data pipeline architecture  
- Validating and evolving database schemas  
- Tracing data lineage from source column to target field  
- Scaffolding data quality gates using industry-standard tools  
- Generating and documenting SQL transformations  
- Registering and maintaining business rules across session boundaries  
- Coordinating work across multiple concurrent data projects

Demo 1 proved the governance layer using a human-relay execution model. Demo 2 extended this with live, autonomous database execution via Claude Code and MCP — the agent now queries, tests, and deploys directly, while the same governance constitution continues to apply. Demo 3 closed two outstanding open items (ETL watermarks and portfolio concentration risk) and proved the governance layer holds under a third kind of pressure: review-process failure modes in the registry and SQL-editing workflow itself.

### Where It's Going

The DE-Intelligence-Kit is a chassis, not a finished product. With live connectivity and a multi-session registry now demonstrated, the roadmap continues toward:

- Pipeline tool integration — native awareness of Fivetran, Airbyte, and CDC tools for connector design and documentation  
- Great Expectations integration — automated expectation suite generation from registered schema contracts and business rules (OI003)  
- Multi-platform demo library — Customer 360 adapted for Redshift, Databricks, and BigQuery, now informed by two Demo 3 portability findings (backfill divergence, identifier case-folding divergence)  
- SCD Type 2 history tracking for `AT_RISK_FLAG` (OI004)  
- Multi-condition at-risk regression testing (OI008) — recommended as the next session's primary focus  
- Workshop and POC packaging — structured delivery kits for client-facing workshops and competitive evaluations

---

## 3\. How DE-Intelligence Implements The Modern Prometheus

### The Four-File Architecture

**CLAUDE.md — The Behavioral Constitution**

This is the most important file in the kit. It is loaded into the Claude Project's instructions field — not uploaded as a reference document, but injected automatically at the start of every conversation before the first message is sent.

This distinction matters: it is the difference between standing orders that govern every response, and a policy manual that might be consulted — or might not.

CLAUDE.md defines how the assistant thinks and communicates. It establishes the dual-language mandate: every significant decision must be explainable in both engineering precision and plain business language. It defines when the assistant captures a business rule (immediately, without being asked). It specifies the escalation flags that cause the assistant to stop and wait for human approval.

**AGENTS.md — The Agent Roster**

AGENTS.md defines seven named specialist roles, each with defined capabilities and a business translation mandate:

| Agent | Responsibility |
| :---- | :---- |
| Pipeline Architect | Designs ingestion topology, connector selection, load strategies |
| Schema Guardian | Validates schema changes, assesses compatibility, flags breaking changes |
| Lineage Cartographer | Traces data from source column to target field, maps dependencies |
| Quality Gatekeeper | Designs dbt test suites and Great Expectations suites |
| Transformation Scribe | Generates and documents SQL transformations and dbt models |
| Business Rule Memory | Captures, stores, and cross-references all business logic |
| Project Coordinator | Manages context switching across multiple concurrent projects |

**PROJECT\_REGISTRY.md (DEMO\_REGISTRY.md) — The Persistent Memory Layer**

The project registry survives the context window. It holds business rules with source and implementation status, architecture decisions with dual-frame rationale, schema contracts with downstream consumer lists, lineage maps with known gaps, and session logs that tell the next conversation exactly where to start. It is updated by the assistant each session and stored in version control — the human controls what is committed as memory. As of Demo 3, the registry spans three sessions across two tools (Claude Code terminal and claude.ai chat) and over 1,400 lines.

**DEPLOYMENT\_CHECKLIST.md — The Activation Guide**

Five phases of framework deployment, each with specific calibration prompts — exact text to paste into the assistant — that activate and verify specific behaviors. A spot-check verification matrix can be run at any time to confirm the assistant is operating correctly.

### The Dual-Language Mandate

Every significant recommendation is delivered in two frames:

- **The engineering frame** — implementation detail, tradeoff analysis, performance implications, failure modes  
- **The business frame** — what this means in terms stakeholders recognize, what it costs to get wrong, what decision it implies

This is not a documentation afterthought. It is a first-class requirement built into CLAUDE.md, enforced by the behavioral constitution, and demonstrated in every phase of all three demos.

### Escalation Governance

Six escalation conditions cause the assistant to stop and wait for human approval before proceeding:

- `[SCHEMA BREAKING CHANGE]` — a proposed change will affect downstream consumers  
- `[BUSINESS RULE CONFLICT]` — two sources define a metric differently  
- `[LINEAGE GAP]` — a column's origin cannot be traced  
- `[QUALITY GATE FAILURE]` — data does not meet defined expectations  
- `[CROSS-PROJECT IMPACT]` — a change in one project affects another  
- `[PII DETECTED]` — a column may contain sensitive personal data

---

## 4\. The Customer 360 Demo — First Mission (Demo 1\)

### Background and Motivation

The Customer 360 demo was designed to benchmark the DE-Intelligence-Kit against commercial agentic data engineering platforms — systems that typically run AI agents on managed cloud infrastructure (compute, AI API, and data warehouse) to execute multi-phase data engineering workflows autonomously.

The benchmark scenario replicates a nine-phase Source-to-Target Mapping workflow that commercial platforms execute using significant cloud infrastructure. The DE-Intelligence-Kit runs the same mission using only a Claude Project and a local DuckDB database — no cloud compute, no managed cluster, no third-party AI API, no infrastructure cost.

The goal was not just to replicate the output. It was to demonstrate that a well-governed Claude assistant produces the same analytical artifact with superior governance documentation — registered business rules, traced lineage, dual-language architecture decisions, and a session-persistent registry — that commercial agentic platforms typically do not produce.

### The Business Scenario

A fictional enterprise has three operational systems — CRM, ERP, and support ticketing — that have never been integrated. Each identifies customers using a different column name: `CUSTOMER_ID` in the CRM (Salesforce-style), `CUST_ID` in the ERP (SAP-style), and `CUSTOMER_REF` in the support system (Zendesk-style). The values are consistent across all three — C001 is the same customer everywhere — but the column names differ. The objective: build a unified `ANALYTICS.CUSTOMER_360` view and identify at-risk customers.

### Source Data

| Table | Rows | Key Field | Notable Characteristics |
| :---- | :---- | :---- | :---- |
| CRM\_CUSTOMERS | 15 | CUSTOMER\_ID | 15 industries, 1 churned, 1 at\_risk, revenues $1.5M–$31M |
| ERP\_ORDERS | 30 | CUST\_ID | \~2 orders per customer avg, 1 cancelled, all others delivered |
| SUPPORT\_TICKETS | 25 | CUSTOMER\_REF | 14 of 15 customers, 2 open tickets, CSAT scores 2–5 |

### Assumed Business Requirements

Before any SQL was written, the agent surfaced four clarifying questions and the following requirements were confirmed and registered as business rules — this is the 'training' input that calibrated every subsequent phase:

- CRM is the spine — every customer appears in the output exactly once via LEFT JOIN, regardless of order or ticket history (BR001)  
- The three join key columns (`CUSTOMER_ID`, `CUST_ID`, `CUSTOMER_REF`) map to identical values — join on value, not name (BR002)  
- 'Open' means `STATUS = 'open'` exactly; 'critical' means `PRIORITY = 'critical'` — a field in the data, not inferred  
- A customer is at-risk if ANY of: an open critical ticket exists, more than two open tickets exist, or average satisfaction is below 3.0 (BR003 / A001)  
- Cancelled orders contribute zero to order value totals (BR005)  
- NULL satisfaction means no rating given — not a rating of zero (BR004)  
- Output grain is one row per customer (15 rows guaranteed)

### Target Schema — 38 Fields

| Field Group | Count | Source | Mapping Type |
| :---- | :---- | :---- | :---- |
| Customer Identity | 15 | CRM\_CUSTOMERS | Direct copy |
| Order Metrics | 7 | ERP\_ORDERS | Aggregation (COUNT, SUM, AVG, MIN, MAX) |
| Order Details | 3 | ERP\_ORDERS | Most recent delivered order (window function) |
| Support Metrics | 7 | SUPPORT\_TICKETS | Aggregation |
| Support Details | 3 | SUPPORT\_TICKETS | Most recent ticket (window function) |
| Risk Indicators | 3 | Cross-table | Derived CASE logic (A001) |

### Business Rules Registered in Demo 1

| Rule ID | Statement |
| :---- | :---- |
| BR001 | CRM is the spine — every customer appears in output via LEFT JOIN architecture |
| BR002 | Join keys differ by name only — explicit mapping: CUSTOMER\_ID \= CUST\_ID \= CUSTOMER\_REF |
| BR003 | At-risk: open critical ticket OR \>2 open tickets OR avg CSAT \< 3.0 |
| BR004 | NULL vs zero distinction — NULL means no data given, not a rating of zero |
| BR005 | Cancelled orders excluded from order value totals |
| BR006 | Satisfaction score averaged on closed tickets only (revised in Demo 2 — see Section 8\) |
| BR007 | Order detail fields reflect delivered orders only (not cancelled) |
| BR008 | AVG fields rounded to 2 decimal places for display precision |

### Deployment Structure

Demo 1 established the repeatable project structure used for every subsequent demo:

| Path | Contents |
| :---- | :---- |
| framework/ | Shared across all projects — CLAUDE.md, AGENTS.md, PROJECT\_REGISTRY.md, DEPLOYMENT\_CHECKLIST.md |
| projects/c360/ | Demo 1–3 deliverables — registry, mission script, seed/deployment SQL, dbt project |
| projects/demo2/ | Demo 2 session primer and session log — the continuity bridge for Claude Code sessions |

Future projects follow this same pattern: a new folder under `projects/` containing a pre-populated registry, a mission script with natural-language prompts, platform-specific seed SQL, and a deployment SQL answer key. The `framework/` files remain shared and are updated in place as the constitution evolves — a new use case (Supply Chain 360, Patient 360, Employee 360\) reuses the same four governing files unchanged.

---

## 5\. Running Demo 1 — Phases and Lessons Learned

### Mission Structure

Nine phases, each driven by a natural-language prompt. The human runs SQL in DuckDB and pastes results back. The agent reasons about those results, generates the next SQL, registers rules, and produces governance artifacts. The agent never executes SQL itself — that is the human-in-the-loop boundary by design in Demo 1\.

### Phase-by-Phase Summary

**Phase 0 — Mission Setup**: A single natural-language prompt described the three source tables, the mismatched join keys, and the business objective. The agent asked four clarifying questions before touching any data: the spine definition, at-risk precision, output grain, and schema ownership. Each answer became a registered business rule.

Lesson: The clarification phase prevented multiple ambiguities from reaching the SQL layer. The agent's questions were specific, consequential, and non-redundant.

**Phase 1 — Baseline Configuration**: The agent described expected findings before seeing data, then generated four queries. A schema error was caught: the agent referenced `DELIVERED_DATE` which does not exist. The correct column is `ORDER_DATE`. Logged as A-SCH-001; schema-confirmed-first discipline committed.

Lesson: Agents make schema assumptions from common patterns before seeing actual DESCRIBE output. Requiring column verification before reference is non-negotiable.

**Phase 2 — Preflight Analysis**: The complete 38-field target schema was presented for approval before any transformation SQL was written. Two architecture decisions were logged with dual-frame rationale: keep the mart lean (ADR001), include `AVG_RESOLUTION_TIME_HRS` as a zero-cost health metric (ADR002).

**Phase 3 — Field Mapping**: Six CTEs, 38 fields, every column reference from the confirmed DESCRIBE output. Every business rule labeled inline. ANSI SQL compatible with DuckDB, with platform adaptation notes commented throughout.

The inline business rule comments are not decoration — they are the governance layer embedded in the code. The SQL becomes self-documenting in a way that traditional SQL rarely is.

**Phase 4 — Data Quality Review**: Six diagnostic queries surfaced three findings: BankWest portfolio concentration risk (23% of portfolio, open critical security ticket), an order details logic error (BR007 — cancelled order appearing as most recent product), and AVG precision display issues (BR008). Both corrections were logged as business rules before the view was updated.

Both corrections were caught by reasoning about actual data output, not by pre-planned test cases. This is the Quality Gatekeeper and Lineage Cartographer operating in tandem.

**Phase 5 — At-Risk Deep Dive**: Full executive briefings produced for both at-risk customers:

|  | C013 BankWest | C012 ManufaCT |
| :---- | :---- | :---- |
| Revenue at risk | $457,650 (23% of portfolio) | $22,800 (1.1% of portfolio) |
| Risk type | Acute — open critical security ticket | Chronic — consistent low satisfaction |
| Risk trigger | HAS\_OPEN\_CRITICAL\_TICKET \= TRUE | AVG\_SATISFACTION\_SCORE \= 2.0 |
| Urgency | Immediate escalation (hours to days) | Proactive outreach (weeks to renewal) |
| Right owner | Account Executive \+ Support Lead | Customer Success Manager |

**Phase 6 — Session Summary**: Complete session summary produced: all rules captured, all decisions logged, all validation results, all open items queued, and a recommended starting point for the next session. Structured for direct paste into the project registry in YAML format.

### Key Governance Moments in Demo 1

- `DELIVERED_DATE` column reference caught before any SQL executed against a non-existent column  
- `MOST_RECENT_PRODUCT` logic error caught through data review, not pre-planned testing  
- Rounding precision issue caught through data review, not pre-planned testing  
- Both corrections logged as business rules before the view was updated  
- The at-risk approval gate was the only moment the agent stopped for explicit approval — exactly as designed

### Comparison with Commercial Agentic Data Platforms

| Capability | Commercial Platform | Modern Prometheus DE (Demo 1\) |
| :---- | :---- | :---- |
| Source schema exploration | Autonomous | Autonomous (human relay) |
| Multi-field source-to-target mapping | Autonomous | Autonomous (human relay) |
| At-risk logic design | Presented for approval | Presented for approval |
| Business rule registration | Typically not produced | BR001-BR008 registered with source |
| Dual-language output | Engineering frame only | Engineering \+ Business frame |
| Session-persistent memory | Lost on session end | Survives via project registry |
| Schema errors caught pre-execution | Not typically documented | 2 caught and logged (A-SCH-001) |
| Quality gate scaffolding | Not typically produced | Available on request |
| Infrastructure required | Cloud compute \+ AI API \+ data warehouse | Local database \+ Claude.ai only |

---

## 6\. Demo 1 — What Was Demonstrated

The Customer 360 mission demonstrated that a governed Claude assistant, operating under The Modern Prometheus framework, can execute a complex multi-phase data engineering workflow — designing a schema, mapping 38 fields, writing production SQL, identifying at-risk customers, and producing executive-ready narrative — with no cloud infrastructure, no proprietary agent platform, and no infrastructure cost.

The schema errors caught pre-execution are the clearest evidence of governance in action. Two column references were identified as incorrect before any SQL ran. In a production pipeline, those errors would have surfaced as silent failures — queries returning zero rows, metrics showing null, dashboards showing nothing without explanation.

Governance is not a tax on agentic capability. The business rule registrations, the dual-language outputs, the escalation flags, and the session-persistent registry did not slow the mission down. They made the output more valuable — auditable, explainable, and reproducible.

At the close of Demo 1, the open item queue stood at OI001 (incremental refresh strategy) through OI008. Demo 1 was deliberately limited to a human-relay execution model — the agent generated SQL, the human ran it in DuckDB and pasted results back. The next evolution, covered starting in Section 7, was to remove that relay entirely.

---

## 7\. Demo 2 — Live Database Connectivity via Claude Code

### Background and Motivation

Demo 1 proved the governance model but left a manual relay step in place: the agent generated SQL, and a human executed it in DuckDB and pasted results back for every query. Demo 2's objective was to remove that relay entirely — give the agent live, autonomous execution access to the database — while preserving every governance behavior established in Demo 1 unchanged.

The central question was architectural: which tool gives Claude live database access on a local Windows machine? Two paths were evaluated.

### Two Candidate Architectures

|  | MCP Server \+ Claude Desktop | Claude Code (CLI) |
| :---- | :---- | :---- |
| What it is | A local server process giving Claude Desktop direct database access | Anthropic's terminal-based coding agent with full local tool access |
| Interface | Chat-style desktop app | Command-line, runs in PowerShell |
| Setup | Install uv \+ mcp-server-duckdb, edit one JSON config file | Already installed on this machine (Windows Store package) |
| Capabilities | Database queries only | Database queries \+ file read/write \+ shell execution |

The original plan favored MCP \+ Claude Desktop for its familiar chat interface. In practice, the standalone Claude Desktop application could not be located on this machine — repeated installer downloads produced only the Claude-in-Chrome browser extension, which does not support MCP configuration. A direct filesystem search located Claude Code already installed via a Windows Store (MSIX) package, fully functional and with broader capabilities than the original plan. Demo 2 was re-scoped around Claude Code.

### Demo 2 Connectivity

- Method: MCP server (mcp-server-duckdb), invoked via Claude Code's built-in MCP support  
- Registration: `claude mcp add duckdb uvx mcp-server-duckdb -- --db-path <path to mp_demo.db>`  
- Agent can execute: SELECT queries, file reads/writes, and shell commands autonomously  
- Human approval required: all DDL (CREATE/ALTER/DROP) and any INSERT/UPDATE/DELETE

### The Continuity Bridge — DEMO2\_SESSION\_PRIMER.md

Claude Code sessions share no memory with claude.ai Projects — no uploaded documents, no project registry, nothing persists between terminal launches. To solve this, a single session primer file was created combining three layers:

- Part 1 — the CLAUDE.md behavioral constitution (dual-language mandate, business rule capture, escalation flags, operating model)  
- Part 2 — the full Demo 1 project state (BR001-BR008, A001, ADR001-ADR002, validated benchmarks, all open items)  
- Part 3 — Demo 2-specific operating instructions (what changes with live execution, connectivity details, session objectives)

The primer is loaded at the start of any Claude Code session with a single command:

Get-Content DEMO2\_SESSION\_PRIMER.md | claude

This is The Modern Prometheus's session-persistence principle applied across a tooling boundary, not just a time boundary. The same pattern that bridges Monday's session to Wednesday's session also bridges claude.ai to a terminal tool. The registry format is the portable asset — the interface is interchangeable.

### Deployment Structure for Demo 2

| Path | Contents |
| :---- | :---- |
| G:\\Projects\\DE-Intelligence\\ | Working sandbox — mp\_demo.db, dbt/, session primer; where Claude Code runs |
| projects/demo2/DEMO2\_SESSION\_PRIMER.md | Continuity bridge — paste-ready constitution \+ Demo 1 context \+ Demo 2 instructions |
| projects/demo2/DEMO2\_SESSION\_LOG.yaml | Structured session output — written by the agent, appended to DEMO\_REGISTRY.md |
| projects/c360/dbt/ | Full dbt project — models, tests, schema documentation |

Future sessions follow the same two-step pattern regardless of which open item is being addressed: (1) seed or confirm the working database in the sandbox directory, (2) pipe the relevant session primer into Claude Code to restore full project context before issuing the first instruction.

---

## 8\. Running Demo 2 — Phases and Lessons Learned

### Operating Model Change

The governance constitution carried over unchanged from Demo 1: dual-language output, business rule registration on first mention, escalation flags before destructive actions, and a session summary at close. What changed was execution — the agent now runs queries, writes files, and executes shell commands directly, with human approval required only for DDL/DML and business-rule decisions.

### Phase 0 — Autonomous Database Introspection

After loading the session primer, the agent confirmed its operating model in one sentence, then — without being told what exists — discovered both schemas (RAW\_DATA, ANALYTICS), all four objects (3 source tables plus the CUSTOMER\_360 view), exact row counts (15/30/25/15), and column structures via its own DESCRIBE queries.

It then re-validated all five Demo 1 benchmarks directly against the live database:

| Metric | Expected (Demo 1\) | Live Result (Demo 2\) | Status |
| :---- | :---- | :---- | :---- |
| total\_rows | 15 | 15 | Pass |
| at\_risk\_count | 2 | 2 | Pass |
| portfolio\_value | $1,986,450 | $1,986,450.00 | Pass |
| null\_satisfaction\_count | 1 | 1 | Pass |
| at\_risk customers | C013 BankWest, C012 ManufaCT | C013 BankWest, C012 ManufaCT | Pass |

Zero relay overhead. What took a back-and-forth of pasted query results in Demo 1 took under 10 seconds of autonomous tool calls in Demo 2 — same governance output, dramatically faster execution. The agent also recommended its own next step: OI002 (dbt test suite) before OI001 (incremental refresh), reasoning that tests create the regression safety net needed before changing the refresh architecture.

### OI002 — Autonomous dbt Test Suite

Before writing a single test, the agent independently queried actual status values in the source data (discovering they are all lowercase) and re-read the deployed view SQL to verify how BR006 was actually implemented — finding the view used `STATUS != 'open'`, while the registry described the rule as 'closed tickets only'. This discrepancy was surfaced before any test was written.

| Deliverable | Detail |
| :---- | :---- |
| Project config | dbt\_project.yml, profiles.yml (dbt-duckdb adapter), packages.yml (dbt\_utils) |
| Sources | models/sources.yml — 4 sources declared (3 RAW\_DATA tables \+ ANALYTICS.CUSTOMER\_360) |
| Generic tests | 18 tests — not\_null, unique, accepted\_values across sources and the view |
| Singular tests | 17 tests — one or more per business rule, BR001 through BR008 |
| Test result | 17 / 17 singular tests pass against live DuckDB on first run |

The agent caught a documentation/implementation drift (BR006) purely as a side effect of doing the work it was asked to do. The act of writing tests forces a verification pass over every prior assumption, surfacing drift that nobody was specifically looking for. This is a strong argument for building the test suite early in any pipeline's lifecycle.

### BR006 Revision and Live Redeployment

Presented with the choice between `STATUS != 'open'` (permissive — automatically includes any future status) and `STATUS = 'resolved'` (explicit opt-in), the decision was made for `= 'resolved'`: satisfaction scores should reflect only completed interactions, and any new ticket status (escalated, in\_progress) should require a deliberate decision to include, not silent inclusion.

The agent then, in sequence: registered a formal BR006 revision (explicitly superseding the original, with source, date, and rationale), updated the view SQL and the corresponding dbt test, announced the DDL operation (`CREATE OR REPLACE VIEW`) before executing it, redeployed the view, and re-ran all 35 tests plus the five Demo 1 benchmarks — all passing.

The escalation-flag discipline held even for a routine-seeming change: the agent explicitly announced the DDL operation before executing it, per the constitution's approval requirements. 'Announce before DDL' is a small ritual that becomes very valuable the day a DDL change is not routine.

### OI001 — Incremental Refresh Strategy

The agent queried all three source tables for update-frequency signals and found a critical gap: none of the three RAW\_DATA tables has an ETL ingestion timestamp. `SIGNUP_DATE`, `ORDER_DATE`, and `CREATED_AT`/`RESOLVED_AT` are all business event dates, not load times — meaning an in-place update to an existing record (e.g., a ticket status changing from open to resolved) would be invisible to any watermark-based incremental strategy.

| Option | Approach | Verdict |
| :---- | :---- | :---- |
| A | Keep as live VIEW — always correct, zero infrastructure | Fine at current scale; expensive at large scale |
| B | Materialize as TABLE, full refresh on schedule, add REFRESHED\_AT | RECOMMENDED — correct at any scale up to \~1M rows, adds freshness signal |
| C | True incremental with source watermarks | Correct long-term architecture; was blocked — required OI009 (LOADED\_AT columns) |

Option B was approved with an hourly refresh cadence and a 65-minute freshness SLA (1-hour cycle plus a 5-minute processing buffer). The agent delivered:

- `dbt/models/marts/customer_360_mart.sql` — full-refresh model, wraps the existing view, adds `REFRESHED_AT`  
- `dbt/models/marts/schema.yml` — 39-column documentation in plain business language  
- `dbt/tests/freshness_mart_refreshed_within_65_minutes.sql` — fails if `REFRESHED_AT` exceeds the SLA  
- ADR003 — materialized mart over live view, with full dual-language rationale  
- `dbt_project.yml` updated with scheduler guidance (Windows Task Scheduler now, cron for future platforms)  
- OI009 logged (**CLOSED in Demo 3** — see Section 9\) — `LOADED_AT TIMESTAMP` required on all three source tables before true incremental is possible

The original view `ANALYTICS.CUSTOMER_360` was preserved unchanged as a fallback — the mart is additive, not a replacement, eliminating cutover risk. After creating `ANALYTICS.CUSTOMER_360_MART`, the agent re-ran all 36 tests (35 \+ the new freshness test) against the mart: 36/36 pass.

'The simplest correct option' beat 'the most sophisticated option'. A full hourly refresh of 15 rows is essentially free; a watermark-based incremental scheme without ingestion timestamps would have been actively wrong — silently stale data with no way to detect it. The agent's engineering judgment correctly prioritized correctness over architectural sophistication, while explicitly logging the prerequisite (OI009) for when incremental does become the right choice.

### Closing the Session — Verified File Output and Git Commit

To avoid the terminal-truncation copy errors observed earlier in the session (long lines displayed with leading characters cut off), the agent wrote its full session summary directly to `DEMO2_SESSION_LOG.yaml`, read the file back to confirm completeness at three checkpoints (header join, mid-file block, final line), and appended it to `DEMO_REGISTRY.md` — bringing the registry to 952 lines covering both demo sessions.

Before committing, the agent explicitly verified which directory was the actual git repository (`C:\Users\...\de-intelligence-kit`) versus the working sandbox (`G:\Projects\DE-Intelligence`), copied all new and changed files into the correct repo location, and committed: 27 files, 1,510 insertions, pushed to origin as `cf70f7f`.

Two reusable habits: (1) for any output longer than a terminal line, write to file and read back — never hand-transcribe from a truncated display; (2) before any git operation, verify which directory is the actual repo versus the working scratch directory. These were different paths and conflating them would have either failed silently or committed nothing.

### Demo 1 vs Demo 2 — Operating Model Comparison

| Capability | Demo 1 (Human Relay) | Demo 2 (Autonomous MCP) |
| :---- | :---- | :---- |
| Schema discovery | Human ran DESCRIBE, pasted results | Agent ran autonomously |
| Query execution | Human ran SQL, pasted results | Agent executes directly |
| File creation | Claude generated text, human saved files | Agent wrote 24+ files directly to disk |
| Governance gap detection | Human caught BR007, BR008 via review | Agent caught BR006 drift via its own work |
| Test execution | N/A (no test suite in Demo 1\) | 36/36 tests run autonomously |
| Dual-language output | Present | Present, unchanged |
| Business rule registration | Present | Present, including formal revisions |
| Escalation flags before DDL | N/A (no DDL in Demo 1\) | Present — announced before CREATE OR REPLACE |

---

## 9\. Demo 3 — ETL Watermarks and Portfolio Concentration Risk

### Background and Motivation

Demo 2 closed with two open items at the top of the queue: OI009 (a newly-discovered HIGH-priority schema gap — no source table carried an ETL ingestion timestamp) and OI006 (a MEDIUM-priority, business-facing concentration-risk flag requiring no DDL). Demo 3's objective was to close both, continuing the autonomous Claude Code \+ claude.ai chat operating model established in Demo 2 — Claude Code executes against the live database, claude.ai chat provides governance review and approval gating for every DDL and registry write.

Demo 3 also tested the framework's resilience to a class of problem neither Demo 1 nor Demo 2 had encountered: terminal-display truncation of long, whitespace-aligned SQL and YAML content during chat-based review, and a genuine content-duplication defect during an iterative registry edit. Both are documented below as governance process findings in their own right.

### Demo 3 Connectivity

- Method: unchanged from Demo 2 — Claude Code (MCP \+ autonomous shell), governed via claude.ai chat review  
- Continuity bridge: `DEMO3_SESSION_PRIMER.md` (Parts 1-2 unchanged constitution \+ Demo 1/2 state; Part 8 session-start instructions for Demo 3\)  
- Human approval obtained explicitly for: all `ALTER TABLE` statements, `CREATE OR REPLACE VIEW`, `DROP TABLE`, and every `DEMO_REGISTRY.md` write

### OI009 — ETL Watermark Columns (CLOSED)

Three `ALTER TABLE` statements were approved in a single batch and executed against all three RAW\_DATA source tables:

- `ALTER TABLE RAW_DATA.CRM_CUSTOMERS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP`  
- `ALTER TABLE RAW_DATA.ERP_ORDERS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP`  
- `ALTER TABLE RAW_DATA.SUPPORT_TICKETS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP`

Backfill verification confirmed zero NULLs across all 70 existing rows (15 \+ 30 \+ 25), with each table receiving a single identical backfill timestamp — confirming DuckDB evaluates `CURRENT_TIMESTAMP` once at ALTER execution time rather than per row.

| Table | Rows | LOADED\_AT Populated | Nulls | Backfill Timestamp |
| :---- | :---- | :---- | :---- | :---- |
| CRM\_CUSTOMERS | 15 | 15 | 0 | 2026-06-13 14:53:48.692 |
| ERP\_ORDERS | 30 | 30 | 0 | 2026-06-13 14:53:48.708 |
| SUPPORT\_TICKETS | 25 | 25 | 0 | 2026-06-13 14:53:48.712 |

Before execution, the dbt environment itself required a fresh install (dbt-core 1.11.11, dbt-duckdb 1.10.1) — dbt was not previously present in this Python environment, despite Demo 2's results being committed as passing. This was confirmed as a new-install, not a regression: Demo 2's results were validated in a different environment. The full suite was re-run post-DDL: 60 of 61 tests passed, with the single failure being the expected freshness-SLA alarm (the mart had not been refreshed since Demo 2, and the scheduler remains unconfigured per ADR003's open note).

#### Key Finding — Platform Backfill Divergence (OI005 impact)

A significant platform-portability finding emerged directly from the backfill verification. `ALTER TABLE ... ADD COLUMN ... DEFAULT CURRENT_TIMESTAMP` does not behave identically across platforms:

| Platform | Existing-Row Backfill Behavior |
| :---- | :---- |
| DuckDB | Backfills all existing rows with CURRENT\_TIMESTAMP evaluated once at ALTER time |
| Oracle | Same as DuckDB — evaluates DEFAULT at ALTER time |
| Snowflake | Same as DuckDB — backfills existing rows with the DEFAULT value |
| Redshift | Leaves existing rows NULL — DEFAULT applies only to future INSERTs. Requires a post-ALTER UPDATE pass. |
| Aurora PostgreSQL | Same as Redshift — existing rows NULL, requires post-ALTER UPDATE pass |

**This is now documented against OI005:** any future Redshift or Aurora PostgreSQL migration must include an explicit `UPDATE ... SET LOADED_AT = CURRENT_TIMESTAMP WHERE LOADED_AT IS NULL` pass after the ALTER, which DuckDB/Oracle/Snowflake targets do not need.

#### OI010 — New Open Item (HIGH priority, opened this session)

The DEFAULT clause only fires on INSERT. If an existing record is later updated — for example, TKT-5007 (C013 BankWest's open critical security ticket) finally being resolved — its `LOADED_AT` will not automatically refresh unless the ETL pipeline explicitly sets it. OI010 registers this as a coordination item for the ETL pipeline owner: the ETL process must explicitly set `LOADED_AT = CURRENT_TIMESTAMP` on every UPDATE, not just INSERT. This is out of scope for schema DDL and blocks both OI001's true-incremental form and OI005 (platform migration).

### OI006 — HIGH\_VALUE\_FLAG / BR011 (CLOSED)

**BR011** (approved by Martin Alvarez): `HIGH_VALUE_FLAG = TRUE` when a customer's `TOTAL_ORDER_VALUE_USD` exceeds 15% of total portfolio value (sum across all customers). This is a concentration-risk signal. The 15% threshold is defined as a named constant in a dedicated `high_value_threshold` CTE — a single change point if the threshold is revised in future.

#### Implementation — View v3

`02_customer_360_view_v3.sql` adds two new CTEs ahead of the final SELECT:

- CTE 7 — `portfolio_total`: a scalar aggregate, `SUM(TOTAL_ORDER_VALUE_USD)` across all customers, serving as the concentration denominator  
- CTE 8 — `high_value_threshold`: a scalar constant (0.15), joined via CROSS JOIN alongside `portfolio_total`

`HIGH_VALUE_FLAG` was added as a fourth field in the existing Risk Indicators group (alongside `AT_RISK_FLAG`, `RISK_REASON`, `LOW_SATISFACTION_FLAG`), bringing the view from 38 to 39 columns. `CREATE OR REPLACE VIEW` was executed against `ANALYTICS.CUSTOMER_360` after explicit approval, with the live view preserved as the ADR003 fallback throughout.

#### Implementation — Mart and Tests

The mart model (`dbt/models/marts/customer_360_mart.sql`) uses an explicit column list rather than `SELECT *` — `high_value_flag` was added manually between `low_satisfaction_flag` and the `refreshed_at` metadata column, bringing the mart to 40 columns. `schema.yml` gained `not_null` and `accepted_values` tests for the new column, and a new singular regression test (`br011_known_high_value_customer.sql`) anchors the three known high-value customers, mirroring the existing `br003_known_at_risk_customers` pattern.

#### Side-Effect Fix — Mart Case Mismatch

During the rebuild, `dbt run` failed with a compilation error. Root cause: `ANALYTICS.CUSTOMER_360_MART` had been created in Demo 2 as an uppercase table (`"ANALYTICS"."CUSTOMER_360_MART"`), while dbt's configured target schema is lowercase (`"analytics"."customer_360_mart"`). DuckDB treats quoted identifiers as case-sensitive, so these were distinct objects to the database even though they referred to 'the same' table conceptually.

The fix — `DROP TABLE ANALYTICS.CUSTOMER_360_MART` followed immediately by `dbt run --select customer_360_mart` — was reviewed and approved as a DDL operation. dbt recreated the table atomically under its expected lowercase name with all 40 columns; the live view `ANALYTICS.CUSTOMER_360` was untouched throughout, so there was no consumer-facing gap.

#### Key Finding — Identifier Case-Folding Divergence (OI005 impact)

| Platform | Unquoted Identifier Default |
| :---- | :---- |
| DuckDB | Preserves creation case in information\_schema; dbt targets lowercase by convention |
| Snowflake | Folds unquoted identifiers to UPPERCASE by default |
| Redshift / PostgreSQL | Folds unquoted identifiers to lowercase by default |
| Oracle | Folds unquoted identifiers to UPPERCASE by default |

**This is now documented against OI005:** before any second-platform migration, dbt's configured schema/table casing must be validated against that platform's identifier-folding default to avoid recreating the exact class of mismatch found here.

#### Result — Three Customers Flagged, Not One

The original scope anticipated only C013 BankWest (23.0% of portfolio, already known from Demo 1's at-risk analysis). The full V4 verification query against all 15 customers surfaced two additional accounts crossing the 15% threshold:

| Customer ID | Company | Total Order Value (USD) | % of Portfolio | HIGH\_VALUE\_FLAG |
| :---- | :---- | :---- | :---- | :---- |
| C013 | BankWest | $457,650 | 23.0% | TRUE |
| C004 | FinServ Corp | $309,200 | 15.6% | TRUE |
| C010 | InsureNet | $304,300 | 15.3% | TRUE |
| C005 | HealthSys | $160,250 | 8.1% | false |

Together, the three flagged customers represent 54.9% of total portfolio revenue ($1,071,150 of $1,986,450). The drop from C010 InsureNet (15.3%) to C005 HealthSys (8.1%) is steep — nearly halving — confirming the 15% threshold is stable: minor data shifts will not accidentally add a fourth flagged customer.

#### Cross-Risk Observation — C010 InsureNet (logged, not a new business rule)

C010 InsureNet now carries both `HIGH_VALUE_FLAG = TRUE` (15.3%, $304,300) and an open high-priority billing ticket (TKT-5020). It does not currently cross `AT_RISK_FLAG`: the ticket's priority is 'high' (condition (a) requires 'critical'), its open-ticket count is 1 (condition (b) requires \>2), and it has no resolved tickets yet to produce a CSAT score (condition (c) cannot evaluate). This combination — meaningful portfolio concentration plus an unresolved support issue — is not currently captured by `AT_RISK_FLAG` alone. The registry recommends periodic review: if TKT-5020 escalates to critical priority, or InsureNet accrues a resolved ticket with CSAT below 3.0, `AT_RISK_FLAG` will fire on an account already representing over 15% of the portfolio.

#### Test Results

The full dbt suite ran clean post-implementation: 64 of 64 tests passing, including the freshness test (the mart had just been rebuilt, well within the 65-minute SLA) and the three new BR011-related tests (`not_null` and `accepted_values` on `HIGH_VALUE_FLAG`, plus the `br011_known_high_value_customer` regression anchor).

### Process Findings — Verification Discipline

Two distinct failure modes surfaced during registry and SQL file review this session, both resolved using a scratch-file write-then-read-back pattern:

- **Display truncation (false positive):** Long, whitespace-aligned SQL lines (column aliases pushed far right for visual alignment) and long YAML prose lines were wrapped or cut off in chat-pasted terminal previews, initially appearing as missing column aliases, missing commas, or truncated identifiers (e.g., "AS AT\_" instead of "AS AT\_RISK\_FLAG,"). Resolved by writing the content to a scratch file, reading it back in full, and in one case cross-checking against direct screenshots of the source file at specific line numbers.  
    
- **Genuine content duplication (true positive):** One `DEMO_REGISTRY.md` edit attempt resulted in two versions of the `next_session` block (pre-OI006 and post-OI006 state) being concatenated rather than one replacing the other, with duplicate YAML keys (`recommended_first` appearing twice with conflicting values). This recurred across multiple edit attempts and was only resolved by writing the complete intended replacement to a scratch file, verifying it read back clean, and then applying it as a full block replacement — followed by a final read-back confirming a single, internally-consistent `next_session` block and a clean end-of-file.

Both failure modes are now documented as known patterns for future sessions: the first is a chat-display artifact requiring file read-back to resolve; the second is a genuine editing defect requiring scratch-file verification and full-block replacement rather than incremental string-replace.

### Closing the Session — Git Commits

Demo 3's deliverables were committed to the same repository as Demo 1/2 (`C:\Users\jmalv\projects\de-intelligence-kit`, branch main) across two commits. One mechanical obstacle was resolved along the way: a full commit message exceeded PowerShell's command-line parser limit (965 bytes) twice — once as a heredoc, once as a `Set-Content -Value` string — and was ultimately written via a direct file-create tool to `COMMIT_MSG.txt`, then committed with `git commit -F`.

**Commit `76e1249`** — code deliverables, within the existing `projects/c360/` structure (continuing the Demo 1/2 convention rather than splitting code across per-demo folders):

| File | Change |
| :---- | :---- |
| 02\_customer\_360\_view\_v3.sql | New — view v3, 39 columns, CTEs 7+8 (portfolio\_total, high\_value\_threshold), HIGH\_VALUE\_FLAG |
| dbt/models/marts/customer\_360\_mart.sql | high\_value\_flag column added; header comment updated to v3 / 39 fields |
| dbt/models/marts/schema.yml | HIGH\_VALUE\_FLAG column documentation \+ not\_null and accepted\_values tests |
| dbt/tests/br011\_known\_high\_value\_customer.sql | New — regression anchor for C013, C004, C010 |
| DEMO\_REGISTRY.md | OI009 closure, OI010 registration, BR011 registration, OI006 closure, C010 observation, case-mismatch finding, updated open items \+ next-session block |

**Commit `ff5297e`** — a new `projects/demo3/` continuity-bridge folder, mirroring the `projects/demo2/` pattern established in Demo 2: `DEMO3_SESSION_PRIMER.md` and a structured Demo 3 session log. This extends the per-demo continuity-bridge convention (primer \+ session log per demo, used to restore full context in a fresh Claude Code session) to Demo 3 — see Section 11 (Documentation Policy) for how this convention relates to `README.md`/`DEMO_REGISTRY.md`.

Working tree confirmed clean after both commits — the temporary `COMMIT_MSG.txt` was deleted before pushing and was not included in either commit.

### Demo 3 — Updated Registry State

| Item | Status | Note |
| :---- | :---- | :---- |
| OI001 | CLOSED (Demo 2\) | Incremental refresh — full-refresh mart (ADR003) |
| OI002 | CLOSED (Demo 2\) | dbt test suite — 36 tests at close of Demo 2 |
| OI003 | OPEN | Great Expectations suite for RAW\_DATA source layer |
| OI004 | OPEN | SCD Type 2 history tracking for AT\_RISK\_FLAG |
| OI005 | OPEN, blocked by OI010 | Multi-platform migration — two new platform-portability notes added this session |
| OI006 | CLOSED (Demo 3\) | HIGH\_VALUE\_FLAG / BR011 — view v3, mart 40 cols, 64/64 tests |
| OI007 | OPEN | ACCOUNT\_STATUS filter guidance for BI layer |
| OI008 | OPEN — recommended next | Multi-condition at-risk test customer (RISK\_REASON concatenation, untested) |
| OI009 | CLOSED (Demo 3\) | LOADED\_AT on all 3 RAW\_DATA tables — unblocks incremental and migration prerequisites |
| OI010 | OPEN — new (Demo 3\) | ETL must set LOADED\_AT on UPDATE, not just INSERT — external coordination item |

Benchmarks confirmed stable throughout: 15 rows, 2 at-risk customers (C013 BankWest, C012 ManufaCT), $1,986,450 portfolio value, C007 Logistix null satisfaction (correct by design, BR004).

---

## 10\. Updated Conclusions and the Road Ahead

### What Demo 2 Proved

Demo 2 demonstrated that the governance layer established in Demo 1 is independent of the execution model. The same constitution — dual-language output, business rule registration, escalation flags, session-persistent registry — governed an agent that now executes SQL, writes files, and runs tests directly, with no loss of rigor and a dramatic reduction in relay overhead.

More importantly, autonomous execution did not just go faster — it found a real defect (the BR006 documentation/implementation drift) that human relay in Demo 1 had not surfaced. Giving the agent more capability, within the same governance boundaries, produced a net increase in correctness, not a decrease.

Two open items closed in a single session (OI001, OI002), one business rule formally revised (BR006), one architecture decision accepted (ADR003), and a materialized mart deployed with a documented freshness SLA — all while the original view remained untouched as a zero-risk fallback.

### What Demo 3 Proved

Demo 3 demonstrated that the governance layer holds under a different kind of pressure: not new capability, but new failure modes in the review process itself. The constitution's emphasis on schema-confirmed-first and write-then-read-back discipline — established in Demo 1 for SQL — generalized cleanly to registry editing, where a genuine content-duplication defect was caught and corrected only because the file was verified rather than trusted from a chat preview.

Substantively, two open items closed (OI009, OI006), one new HIGH-priority item opened with a clear external owner (OI010), one new business rule registered (BR011), and one architecture-adjacent defect fixed as a useful side effect (the Demo 2 mart case-mismatch). Two platform-portability findings — backfill divergence and identifier case-folding divergence — were captured against OI005 before any second-platform work begins, meaning a future migration starts with two fewer surprises.

Equally important: OI006's scope expanded organically from "flag BankWest" to "flag whichever accounts cross 15%, whoever they turn out to be" — and the implementation surfaced two previously-uncalled-out accounts (FinServ Corp, InsureNet) representing an additional 30.9% of portfolio value. This is the same pattern as Demo 2's BR006 discovery: building the thing correctly surfaces information that asking the question directly would not have.

### Updated Open Items Status

| ID | Priority | Status | Note |
| :---- | :---- | :---- | :---- |
| OI001 | HIGH | CLOSED | Materialized mart (CUSTOMER\_360\_MART), hourly refresh, 65-min freshness SLA |
| OI002 | MEDIUM | CLOSED | dbt test suite — grew to 64 tests by end of Demo 3, all passing |
| OI009 | HIGH | CLOSED (Demo 3\) | LOADED\_AT timestamps on all 3 source tables, zero nulls, backfilled |
| OI006 | MEDIUM | CLOSED (Demo 3\) | HIGH\_VALUE\_FLAG / BR011 — 3 customers flagged, 54.9% of portfolio |
| OI010 | HIGH | OPEN (new, Demo 3\) | ETL must set LOADED\_AT on UPDATE — blocks true incremental and migration |
| OI003 | MEDIUM | Open | Great Expectations suite for RAW\_DATA layer |
| OI004 | LOW | Open | SCD Type 2 history tracking for AT\_RISK\_FLAG |
| OI005 | LOW | Open — blocked by OI010 | Multi-platform migration; two new portability notes captured (backfill, case-folding) |
| OI007 | LOW | Open | ACCOUNT\_STATUS filter guidance for BI layer |
| OI008 | MEDIUM | Open — recommended next | Multi-condition at-risk test customer for RISK\_REASON concatenation |

### Updated Roadmap — Multi-Platform Path

OI010 is now the binding constraint on the multi-platform path, having taken over from OI009. Unlike OI009, OI010 is not a schema-design decision the assistant can resolve — it is a process commitment from whoever owns the ETL pipeline. Until that commitment exists, `LOADED_AT` is correct for new records and silently stale for updated ones, which would make any incremental or migration work built on it unreliable in exactly the way OI001's original analysis warned against.

- OI010 — secure ETL-owner commitment to set `LOADED_AT = CURRENT_TIMESTAMP` on every UPDATE, not just INSERT (external coordination, not engineering work)  
- OI005 (after OI010) — apply the two Demo 3 portability findings up front: add a post-ALTER backfill UPDATE pass for Redshift/Aurora targets, and validate dbt's configured schema/table casing against the target platform's identifier-folding default before deploying  
- OI008 — recommended as the next session's primary focus regardless of OI005 timing: validates RISK\_REASON concatenation for a multi-condition at-risk customer, a code path that has existed since Demo 1 but has never been exercised against live data  
- OI003 — Great Expectations suite for RAW\_DATA remains a good alternative entry point: complements the existing dbt test suite with freshness/volume/referential-integrity expectations at the source layer, and requires no DDL

### Areas to Improve

- PII governance — EMAIL and PHONE fields require masking before any non-local deployment; flagged but not yet implemented  
- Multi-condition at-risk testing (OI008) — RISK\_REASON concatenation for customers triggering 2+ conditions simultaneously has never been exercised with live data — unchanged priority after Demo 3  
- Scheduler implementation — the hourly refresh for CUSTOMER\_360\_MART is documented (Windows Task Scheduler / cron) but not yet wired up; the freshness test continues to fail between manual refreshes as designed  
- dbt source freshness — scaffolded but inactive pending OI009's downstream OI010; activate `loaded_at_field` blocks in sources.yml once `LOADED_AT` is trustworthy on updates, not just inserts  
- Workshop packaging — the mission scripts need facilitator notes, timing guidance, and a slide deck for client-facing delivery  
- Second platform validation — Redshift/Databricks/Aurora adaptation now has two documented gotchas (backfill divergence, case-folding divergence) to design around from the start, once OI010 unblocks the work  
- **Registry edit verification** — new this session — large registry edits should be scratch-file-verified before being applied to `DEMO_REGISTRY.md`, given the content-duplication defect encountered in Demo 3\. Recommend this become a standing practice for any multi-hundred-line registry edit, not just an ad-hoc fix.

### The Bigger Picture

Three sessions, two execution models, one unbroken governance thread. Demo 1 proved the framework works through careful human-relay interaction. Demo 2 proved the same framework holds when the agent is given direct, autonomous access to execute — and that autonomy surfaces real defects rather than introducing new risk, because the governance constitution travels with the agent regardless of which tool it is running in. Demo 3 proved the framework holds under a third kind of pressure: review-process failure modes (display truncation, content duplication) that have nothing to do with the data engineering work itself, but that the same write-verify-confirm discipline resolves just as cleanly as a schema error.

The registry — now spanning three sessions across two tools (Claude Code terminal and claude.ai chat) and over 1,400 lines — remains the portable asset. A single file carried full project context across a browser-based chat, a terminal agent, a Python environment rebuild, a schema change, a business rule revision, a new risk signal, and a registry-editing defect, without losing coherence at any point. That portability is not an accident of file format; it is The Modern Prometheus working exactly as designed.

The framework is The Modern Prometheus. The architect is Anshar Seraphim.

---

## 11\. Documentation Policy

This policy governs how project documentation is maintained going forward.

- **README.md (this file)** is the canonical, version-controlled source of truth. It is plain text, updated **every session** as part of session close, and reflects the current state of the project at all times. **If README.md and the docx ever conflict, README.md wins.**  
    
- **DE-Intelligence-Kit-README.docx** is a separate companion document — a polished learning/presentation narrative for people reading the project end-to-end. It is refreshed **periodically, not every session**, by re-flowing README.md's current content into its visual structure (tables, callouts, cover page). It is **not auto-generated** and is **not required to stay in lockstep** with README.md. Its next refresh is due whenever README.md has drifted meaningfully again (e.g., after Demo 4–5, not necessarily every demo).  
    
- **Default action for future sessions:** update README.md. The docx is optional/periodic and should only be touched when a refresh is explicitly requested or when drift has become substantial.  
    
- **DEMO\_REGISTRY.md** remains the structured, machine-/agent-readable memory layer (BR\#\#\#, ADR\#\#\#, OI\#\#\#, A-\#\#\#) for PROJ-C360 specifically. README.md is the human-readable narrative companion at the whole-project level — it summarizes and contextualizes what the registry tracks in detail, but does not replace it.  
    
- **projects/demoN/ continuity-bridge folders** (e.g., `projects/demo2/`, `projects/demo3/`) are a third tier, distinct from both README.md and DEMO\_REGISTRY.md. Each contains a `DEMON_SESSION_PRIMER.md` (paste-ready constitution \+ prior-state context \+ session-specific instructions) and a structured session log, used to restore full context in a fresh Claude Code session at the start of that demo. They are point-in-time, per-session artifacts — not updated after the fact. README.md narrates what happened across demos; DEMO\_REGISTRY.md is the living registry state; `projects/demoN/` is the historical record of how each session was kicked off and what it logged at close. All three can coexist without conflict because they answer different questions (current state vs. narrative vs. session-start snapshot).  
    
- **Reconciliation note (2026-06-14):** Two parallel sessions each produced Demo 3 documentation — this session's README.md (re-flowed from a `DE-Intelligence-Kit-README_3.docx` uploaded here) and the Demo 3/Claude Code session's own updated docx (Section 9 Demo 3 content, not yet committed). Per this policy, **this README.md is the reconciled canonical version** — it has been corrected to include the `projects/demo3/` continuity-bridge detail (commit `ff5297e`) that the Demo 3 session had and this session initially lacked. The Demo 3 session's updated docx should not be committed as the new companion document until/unless it is re-derived from this README.md, to avoid the companion becoming more current than the canonical file.

---

*DE-Intelligence-Kit | Martin Alvarez | June 2026 | Built on The Modern Prometheus by Anshar Seraphim*  
