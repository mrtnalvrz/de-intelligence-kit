# MISSION.md — Customer 360 Source-to-Target Mapping

## Modern Prometheus DE Intelligence · Demo Mission

---

## What This Is

This is the **runbook for the Customer 360 demo mission** — a natural-language-driven, nine-phase data engineering workflow executed entirely through the Modern Prometheus DE Intelligence.

No Genesis platform. No Eve. No Blueprint engine. Claude is the agent.

The mission mirrors the Genesis Source-to-Target Mapping Blueprint phase-for-phase, demonstrating that a well-governed Claude assistant can execute the same agentic DE workflow with superior explainability, persistent memory, and zero infrastructure overhead.

**Expected outcome:** A live, queryable `ANALYTICS.CUSTOMER_360` table with 38 fields, 15 rows, and 2 at-risk customers flagged — produced entirely through natural-language mission kicks.

---

## Pre-Mission Setup

Before starting, confirm:

- [ ] `00_seed_data.sql` has been run on your target platform  
- [ ] Row counts verified: CRM=15, ERP=30, SUPPORT=25  
- [ ] `ANALYTICS` schema created and empty  
- [ ] Modern Prometheus DE Intelligence Claude Project is open  
- [ ] `CLAUDE.md` is in the Project Instructions field (calibration confirmed)

---

## Mission Architecture

Phase 0 → Mission Setup        Register project, capture business rules

Phase 1 → Baseline Config      Explore source schemas, document structure

Phase 2 → Preflight Analysis   Identify target fields, map join strategy

Phase 3 → Field Mapping        Design all 38 target fields with SQL

Phase 4 → Business Questions   Surface and resolve data quality flags

Phase 5 → At-Risk Logic Review Present assumption for approval

Phase 6 → Deployment SQL       Generate production-ready CREATE \+ INSERT

Phase 7 → Validation           Verify output against expected results

Phase 8 → Session Summary      Document everything, prepare handoff

---

## PHASE 0 — Mission Setup

**What this phase does:** Registers the project in the DE Intelligence memory layer, captures business rules on first contact, and establishes the session context.

**Say this to kick off:**

I want to run a Customer 360 source-to-target mapping mission.

Here's the scenario:

We have three enterprise source tables that have never been integrated.

Each system identifies customers with a different column name — this is

the core harmonization challenge.

Source tables (all in the RAW\_DATA schema):

\- CRM\_CUSTOMERS (15 rows) — key field: CUSTOMER\_ID — Salesforce-style CRM

\- ERP\_ORDERS (30 rows) — key field: CUST\_ID — SAP-style ERP

\- SUPPORT\_TICKETS (25 rows) — key field: CUSTOMER\_REF — Zendesk-style support

The values are the same (C001 \= C001 \= C001) — only the column names differ.

Goal: Build a unified ANALYTICS.CUSTOMER\_360 view joining all three sources.

Identify at-risk customers who have open critical support tickets or

low satisfaction scores.

Register this as a new project. Capture all business rules I state.

Begin by confirming your understanding of the mission and asking

any clarifying questions before we proceed to schema exploration.

**What to look for:**

- Assistant confirms project registration with a PROJ-ID  
- It echoes back the three source tables and the join key mismatch  
- It asks at most one clarifying question (target schema name, at-risk definition)  
- It does NOT proceed to schema exploration yet — it waits for your go-ahead

**Say to proceed:**

Target schema: ANALYTICS. Table name: CUSTOMER\_360.

At-risk definition: we'll define that together in Phase 5 — 

proceed with schema exploration first.

Move to Phase 1\.

---

## PHASE 1 — Baseline Configuration

**What this phase does:** Explores the source schemas, documents column metadata, and validates join key relationships. Mirrors Genesis Phase 1\.

**Say this:**

Phase 1 — Baseline Configuration.

Explore the three source tables and give me:

1\. A full column inventory for each table — field name, type, nullable

2\. The join key relationship analysis — what % of CRM customers

   have matching records in ERP and Support?

3\. Any data quality flags you notice just from the schema

   (don't query the data yet — schema only for now)

4\. A preliminary estimate of how many target fields we'll need

Document this in the project registry as Phase 1 baseline.

**What to look for:**

- Full schema inventory for all 3 tables (41 total columns)  
- Join key analysis: CRM↔ERP \= 100%, CRM↔Support \= 93% (14/15)  
- At least 2 data quality flags spotted (NULL resolved\_at, mismatched keys)  
- Target field estimate: 35-40  
- `[LINEAGE GAP]` flag if any column origin is ambiguous

**Expected engineering frame output:**

- 3 tables, 41 source columns  
- Join keys: CUSTOMER\_ID / CUST\_ID / CUSTOMER\_REF map to same values  
- One CRM customer (C007 Logistix) has no support ticket record

**Expected business frame output:**

- "Three departments built their systems independently — no one agreed on what to call the customer ID field. The data values are consistent; only the labels differ."  
- "One customer in your CRM — Logistix Co — has no support history, which may indicate a churned relationship or a gap in ticket logging."

---

## PHASE 2 — Preflight Analysis

**What this phase does:** Designs the target schema, defines the 38 fields, establishes the join strategy, and identifies field groupings. Mirrors Genesis Phase 2\.

**Say this:**

Phase 2 — Preflight Analysis.

Now query the actual data. I want:

1\. Sample data from each table (5 rows each)

2\. Row counts and distinct key counts per table

3\. A proposed target schema for ANALYTICS.CUSTOMER\_360 —

   organize the 38 fields into logical groups

4\. The join strategy: which table is the spine? How do we handle

   customers with no orders or no tickets?

5\. Flag any fields that will require aggregation vs direct copy

Capture the proposed field groups as a business rule in the registry.

**What to look for:**

- 6 field groups identified: Customer Identity, Order Metrics, Order Details, Support Metrics, Support Details, Risk Indicators  
- Spine identified as CRM\_CUSTOMERS (LEFT JOIN to both ERP and Support)  
- NULL handling decision: counts default to 0, scores stay NULL when no tickets  
- 15 direct-copy fields \+ 23 aggregated fields called out

**Business rule to capture (watch for it):**

BR001 — The spine of the Customer 360 view is CRM\_CUSTOMERS.

Every customer row comes from CRM. ERP and Support data is

LEFT JOINed — customers with no orders or no tickets still

appear in the output with NULL or zero values.

Source: Mission Phase 2 design decision.

**Business frame to listen for:**

- "Every customer appears exactly once. If they've never placed an order, their order columns show zero. If they have no support history, their satisfaction score is blank — not zero, which would imply they rated us poorly."

---

## PHASE 3 — Field Mapping

**What this phase does:** Maps all 38 target fields to their source columns with SQL expressions. The core engineering phase. Mirrors Genesis Phase 3 (29 tool calls in Eve's run).

**Say this:**

Phase 3 — Field Mapping.

Design the complete SQL for ANALYTICS.CUSTOMER\_360.

Use a CTE-based approach — one CTE per field group.

For each field, show:

\- Target field name

\- Source table and column

\- SQL expression (direct copy, aggregation, or derived)

\- Confidence: HIGH / MEDIUM / LOW

Flag any field where the mapping requires a business assumption

that I should approve before deployment.

Write this in standard ANSI SQL — I'll adapt it to the target

platform after review. Include comments for every business

rule embedded in the SQL.

**What to look for:**

- 6 CTEs produced (customer\_base, order\_metrics, order\_details, support\_metrics, support\_details, risk\_indicators)  
- All 38 fields listed with source mapping  
- Business rule comments in SQL: `-- BUSINESS RULE: [rule]`  
- Assumption flags: at-risk logic is flagged for Phase 5 approval  
- 100% HIGH confidence (all fields have clear source columns)  
- `[SCHEMA BREAKING CHANGE]` NOT fired (no schema changes proposed)

**The SQL pattern to look for:**

\-- BUSINESS RULE: BR001 — CRM is the spine. LEFT JOINs preserve all customers.

WITH customer\_base AS (

    SELECT

        customer\_id,

        first\_name,

        last\_name,

        ...

    FROM RAW\_DATA.CRM\_CUSTOMERS

),

order\_metrics AS (

    SELECT

        cust\_id AS customer\_id,  \-- ASSUMPTION: cust\_id \= customer\_id

        COUNT(order\_id)          AS total\_orders,

        SUM(total\_amount\_usd)    AS total\_order\_value\_usd,

        ...

    FROM RAW\_DATA.ERP\_ORDERS

    GROUP BY cust\_id

),

...

---

## PHASE 4 — Business Questions

**What this phase does:** Surfaces data quality findings from the actual data and flags items requiring your decision. Mirrors Genesis Phase 4\.

**Say this:**

Phase 4 — Business Questions.

Before I approve the mapping, I want you to run the actual data

and surface any anomalies or questions. Specifically:

1\. Are there any ERP order records with no matching CRM customer?

2\. Are there any support tickets with no matching CRM customer?

3\. What is the breakdown of account\_status values?

4\. Are there any customers with open critical tickets right now?

5\. Are there any customers with satisfaction scores below 3?

Flag each finding with its business implication in plain language.

**Expected findings and flags:**

| Finding | Flag | Business Implication |
| :---- | :---- | :---- |
| C007 Logistix has 1 order (cancelled) but no support tickets | `[LINEAGE GAP]` | Churned customer — data is correct, not a gap |
| TKT-5007 and TKT-5020 have NULL resolved\_at | Data quality note | Open tickets — correct by design, not load errors |
| C013 BankWest has 1 open critical security ticket | Business alert | Highest-value customer ($31M ARR) with unresolved critical issue |
| C012 ManufaCT has CSAT=2 and account\_status=at\_risk | Business alert | Already flagged at-risk in CRM; support data confirms it |
| C009 and C015 have Brazilian phone format | Schema note | International customers — correct data, not errors |

**Business frame to listen for:**

- "Your highest-value customer — BankWest at $31M annual revenue — has an open security ticket that nobody has resolved. That's a board-level risk hiding in a support queue."

---

## PHASE 5 — At-Risk Logic Review

**What this phase does:** Presents the at-risk flag logic for your approval before deployment. This is the only human-in-the-loop gate in the mission. Mirrors Genesis Phase 5 (user approval of A001-A003).

**The assistant should present this assumption unprompted** — but if it doesn't, say:

Phase 5 — I need to approve the at-risk logic before deployment.

Show me the proposed CASE WHEN logic for the at\_risk\_flag field

and explain what each condition catches in plain language.

**Expected assumption presented:**

\-- ASSUMPTION A001: At-Risk Flag Logic — REQUIRES USER APPROVAL

at\_risk\_flag \= CASE

    WHEN has\_open\_critical\_ticket \= TRUE   THEN TRUE  \-- open unresolved critical ticket

    WHEN open\_ticket\_count \> 2             THEN TRUE  \-- volume of open issues

    WHEN avg\_satisfaction\_score \< 3.0      THEN TRUE  \-- low CSAT threshold

    ELSE FALSE

END

\-- Under this logic, 2 customers are flagged:

\-- C013 BankWest     → has\_open\_critical\_ticket \= TRUE (TKT-5007)

\-- C012 ManufaCT     → avg\_satisfaction\_score \= 2.0

**Business frame to expect:**

- "This logic flags a customer as at-risk if they have any unresolved critical ticket, more than 2 open issues at once, or if their average satisfaction rating across all tickets falls below 3 out of 5\. Under these rules, two customers are flagged: BankWest because of the open security ticket, and ManufaCT because of persistently low satisfaction scores."

**Your approval response:**

At-risk logic approved as defined. The thresholds look right.

Proceed to deployment.

---

## PHASE 6 — Deployment SQL

**What this phase does:** Generates the final, platform-adapted CREATE TABLE \+ INSERT SQL for `ANALYTICS.CUSTOMER_360`. Mirrors Genesis Phase 6-7.

**Say this:**

Phase 6 — Generate the deployment SQL.

I need two SQL statements:

1\. CREATE TABLE for ANALYTICS.CUSTOMER\_360 with all 38 fields,

   correct data types, and a comment on each column describing

   what it represents in business terms.

2\. INSERT INTO ANALYTICS.CUSTOMER\_360 using the CTE structure

   from Phase 3, incorporating the approved at-risk logic from Phase 5\.

Write it for \[SNOWFLAKE / REDSHIFT / DATABRICKS — pick your platform\].

Include platform-specific syntax notes as SQL comments.

After generating, tell me what to expect when I run it:

rows, at-risk count, and any nulls by design.

**What to look for:**

- Complete DDL with business-readable column comments  
- Full CTE-based INSERT referencing all 3 source tables  
- Approved A001 at-risk logic embedded with `-- BUSINESS RULE` comment  
- Pre-flight expectations: 15 rows, 2 at-risk, C007 satisfaction \= NULL by design

---

## PHASE 7 — Validation

**What this phase does:** Verifies the deployed table against expected results. Mirrors Genesis Phase 7-8.

**After running the SQL, say this:**

Phase 7 — Validate the deployment.

Give me the validation queries to confirm:

1\. Total row count (expect 15\)

2\. At-risk customers (expect 2: BankWest and ManufaCT)

3\. Total portfolio value

4\. The customer with the highest order value

5\. Any NULL satisfaction scores (expect 1: C007 Logistix)

6\. Industry breakdown with at-risk count per industry

Then tell me what the results mean in business terms.

**Expected validation results:**

| Check | Expected | Business Meaning |
| :---- | :---- | :---- |
| Total rows | 15 | One row per customer — no duplicates, no missing |
| At-risk customers | 2 (C013, C012) | BankWest (critical ticket) \+ ManufaCT (low CSAT) |
| Portfolio value | $1,989,950 | Total delivered order value across all customers |
| Highest value customer | C013 BankWest ($457,650) | Also the highest-risk — immediate escalation needed |
| NULL satisfaction | 1 (C007 Logistix) | Churned — no ticket history, correct by design |
| Financial Services at-risk | 1 of 2 (50%) | BankWest is the critical one |

**The business frame that seals the demo:**

- "Your highest-value customer and your highest-risk customer are the same person. BankWest represents 23% of your total delivered order value, and they have an open security ticket that no one has resolved. This view makes that visible in a single query."

---

## PHASE 8 — Session Summary

**What this phase does:** Documents everything into the project registry for session-persistence. The Modern Prometheus differentiator — Eve didn't do this.

**Say this:**

Phase 8 — Generate a session summary.

Capture:

\- All business rules registered in this session (with rule IDs)

\- All architecture decisions made (with rationale in both frames)

\- The final schema of ANALYTICS.CUSTOMER\_360 (field count, groups)

\- The at-risk logic approved (A001)

\- Open items for future sessions

\- Recommended next steps

This summary goes into the project registry. Format it for pasting

into PROJECT\_REGISTRY.md under PROJ-C360.

**What to look for:**

- BR001 through BR00X captured with source attribution  
- A001 (at-risk logic) logged with approval noted  
- ADR001 (spine decision) logged with dual-frame rationale  
- Lineage documented: CRM → customer\_base CTE → ANALYTICS.CUSTOMER\_360  
- Open items: incremental refresh strategy, SCD Type 2 for historical tracking, alert triggers for new at-risk crossings  
- Session log entry ready to paste into registry

---

## Demo Comparison: Modern Prometheus vs Genesis Eve

| Capability | Genesis Eve | Modern Prometheus DE |
| :---- | :---- | :---- |
| Source schema exploration | ✅ Autonomous | ✅ Autonomous |
| Join key harmonization | ✅ Autonomous | ✅ Autonomous |
| 38-field mapping | ✅ 100% confidence | ✅ 100% confidence |
| At-risk logic design | ✅ Presented for approval | ✅ Presented for approval |
| Production SQL deployment | ✅ Executed | ✅ Generated (you execute) |
| Business rule registration | ❌ Not captured | ✅ All rules registered with source |
| Dual-language output | ❌ Engineering only | ✅ Engineering \+ Business frame |
| Session-persistent memory | ❌ Lost on session end | ✅ Survives via PROJECT\_REGISTRY |
| Quality gate scaffolding | ❌ Not produced | ✅ dbt tests \+ GX suite on request |
| Lineage documentation | ❌ Not produced | ✅ Traced to column level |
| Infrastructure cost | EC2 \+ Bedrock \+ Redshift | Zero (Claude Project only) |
| Rate limit risk | Yes (Eve hit Bedrock limits) | No (Claude.ai) |

---

## Adapting This Mission to Other Platforms

The mission script is platform-agnostic. To adapt:

**Snowflake:** Use `00_seed_data.sql` as-is. In Phase 6, specify "Snowflake syntax."

**Redshift:** Replace `TIMESTAMP` with `TIMESTAMP WITHOUT TIME ZONE`. Replace `NUMERIC` with `DECIMAL`. Use `ISNULL()` instead of `COALESCE()` for Redshift-specific style.

**Databricks:** Replace schema syntax with `CREATE SCHEMA`. Use `DOUBLE` instead of `NUMERIC`. Window functions are identical.

**DuckDB (local testing):** Run `00_seed_data.sql` with `duckdb mp_demo.db < 00_seed_data.sql`. No cloud account needed — ideal for local exploration.

**BigQuery:** Replace `NUMERIC` with `FLOAT64`. Use backtick identifiers. TIMESTAMP syntax is identical.

---

## Adapting This Mission to Other Use Cases

The **chassis** is reusable. To swap the use case:

1. Replace the three source tables with your domain's data  
2. Update the join key mismatch (the harmonization challenge)  
3. Update the target table name and field groups  
4. Update the at-risk logic for your domain (churn risk, fraud risk, compliance risk, etc.)

The nine-phase structure, the natural-language mission kick, the dual-language output, and the session-persistent registry all transfer unchanged.

---

*MISSION.md — Modern Prometheus Customer 360 Demo* *Platform-agnostic · Audience-adaptable · Repeatable*  
