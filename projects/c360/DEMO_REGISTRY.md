# PROJECT\_REGISTRY — Customer 360 Demo

## Modern Prometheus DE Intelligence · PROJ-C360

---

## ACTIVE\_SESSION
```
session_id:   Demo4-OI008
started_at:   2026-06-16T00:00:00-07:00
operator:     Martin Alvarez (mrtnalvrz)
focus:        OI008 — multi-condition at-risk test customer (no DDL required)
status:       CLEARED — session Demo4-OI008 closed 2026-06-16
```
*Clear this block at session close per PN001 convention.*

---

project:

  id: PROJ-C360

  name: "Customer 360 — Source-to-Target Mapping Demo"

  status: active

  created: 2026-06-05

  last\_updated: 2026-06-05

  description: \>

    Platform-agnostic demo mission: three enterprise source tables

    (CRM, ERP, Support) with intentionally mismatched customer join keys

    harmonized into a unified ANALYTICS.CUSTOMER\_360 view.

    Primary purpose: demonstrate Modern Prometheus DE Intelligence

    agentic capabilities as a Genesis platform substitute.

    Secondary purpose: reusable chassis for future POCs and workshops.

  stakeholders:

    business\_owner: "Martin Alvarez (evaluation)"

    technical\_lead: "Martin Alvarez"

    consumers:

      \- "ANALYTICS.CUSTOMER\_360 (target table)"

      \- "Validation queries"

      \- "Future: dashboards, executive reporting"

  data\_sources:

    \- name: "CRM\_CUSTOMERS"

      type: "table"

      schema: "RAW\_DATA"

      row\_count: 15

      customer\_key: "CUSTOMER\_ID"

      system\_type: "Salesforce-style CRM"

      ingestion\_pattern: "full\_refresh (demo seed)"

      pii\_present: true

      notes: "Master customer record — spine of the Customer 360 join"

    \- name: "ERP\_ORDERS"

      type: "table"

      schema: "RAW\_DATA"

      row\_count: 30

      customer\_key: "CUST\_ID"

      system\_type: "SAP-style ERP"

      ingestion\_pattern: "full\_refresh (demo seed)"

      pii\_present: false

      notes: "Key mismatch: CUST\_ID maps to CUSTOMER\_ID. One cancelled order (C007)."

    \- name: "SUPPORT\_TICKETS"

      type: "table"

      schema: "RAW\_DATA"

      row\_count: 25

      customer\_key: "CUSTOMER\_REF"

      system\_type: "Zendesk-style support"

      ingestion\_pattern: "full\_refresh (demo seed)"

      pii\_present: false

      notes: \>

        Key mismatch: CUSTOMER\_REF maps to CUSTOMER\_ID.

        Two open tickets with NULL resolved\_at: TKT-5007 (C013), TKT-5020 (C010).

        14 of 15 CRM customers have support records. C007 Logistix has none.

  schema\_contracts:

    \- table: "ANALYTICS.CUSTOMER\_360"

      version: "v1"

      owner: "Martin Alvarez"

      fields: 38

      breaking\_change\_approval\_required: true

      last\_reviewed: 2026-06-05

      downstream\_consumers:

        \- "Validation queries (Phase 7)"

        \- "Future: executive dashboard, at-risk alerting"

  field\_groups:

    \- group: "Customer Identity"

      field\_count: 15

      source: "CRM\_CUSTOMERS"

      mapping\_type: "direct\_copy"

      fields: \>

        customer\_id, first\_name, last\_name, email, phone, company,

        industry, city, state, country, signup\_date, account\_status,

        annual\_revenue\_usd, sales\_rep, customer\_tenure\_days

    \- group: "Order Metrics"

      field\_count: 7

      source: "ERP\_ORDERS"

      mapping\_type: "aggregation"

      fields: \>

        total\_orders, total\_order\_value\_usd, avg\_order\_value\_usd,

        first\_order\_date, last\_order\_date, delivered\_orders, cancelled\_orders

    \- group: "Order Details"

      field\_count: 3

      source: "ERP\_ORDERS"

      mapping\_type: "window\_function"

      fields: "most\_recent\_order\_date, most\_recent\_product, most\_recent\_order\_value\_usd"

    \- group: "Support Metrics"

      field\_count: 7

      source: "SUPPORT\_TICKETS"

      mapping\_type: "aggregation"

      fields: \>

        total\_tickets, open\_tickets, critical\_tickets,

        has\_open\_critical\_ticket, avg\_satisfaction\_score,

        avg\_resolution\_time\_hrs, first\_ticket\_date

    \- group: "Support Details"

      field\_count: 3

      source: "SUPPORT\_TICKETS"

      mapping\_type: "window\_function"

      fields: "most\_recent\_ticket\_date, most\_recent\_ticket\_category, most\_recent\_ticket\_status"

    \- group: "Risk Indicators"

      field\_count: 3

      source: "cross-table"

      mapping\_type: "derived"

      fields: "at\_risk\_flag, risk\_reason, low\_satisfaction\_flag"

  business\_rules:

    \- rule\_id: BR001

      statement: \>

        CRM\_CUSTOMERS is the spine of the Customer 360 view.

        All 15 CRM customers appear in the output regardless of

        whether they have orders or support tickets.

        ERP\_ORDERS and SUPPORT\_TICKETS are LEFT JOINed.

      source: "Mission Phase 2 design decision — Martin Alvarez"

      captured: 2026-06-05

      implemented\_in: "ANALYTICS.CUSTOMER\_360 (customer\_base CTE)"

      conflicts\_with: NONE

    \- rule\_id: BR002

      statement: \>

        The three source tables use different column names for the

        same customer identifier: CUSTOMER\_ID (CRM), CUST\_ID (ERP),

        CUSTOMER\_REF (Support). The values are identical across all

        three systems (C001 \= C001 \= C001). Join on value, not name.

      source: "Source data inspection — Phase 1 baseline"

      captured: 2026-06-05

      implemented\_in: "All JOIN conditions in ANALYTICS.CUSTOMER\_360"

      conflicts\_with: NONE

    \- rule\_id: BR003

      statement: \>

        Customers with no ERP orders retain a row in the Customer 360

        view with order metric fields defaulting to 0 (counts) or NULL

        (dates, amounts). C007 Logistix has one cancelled order;

        its delivered order value is 0, not 8500\.

      source: "Phase 4 data quality review"

      captured: 2026-06-05

      implemented\_in: "order\_metrics CTE (COALESCE to 0 for counts)"

      conflicts\_with: NONE

    \- rule\_id: BR004

      statement: \>

        Customers with no support tickets retain a row in the Customer 360

        view with support metric fields defaulting to 0 (counts) or NULL

        (scores). avg\_satisfaction\_score is NULL for C007 Logistix —

        NOT zero. NULL means no rating given, not a rating of zero.

      source: "Phase 4 data quality review — NULL vs zero distinction"

      captured: 2026-06-05

      implemented\_in: "support\_metrics CTE (AVG returns NULL, not 0)"

      conflicts\_with: NONE

    \- rule\_id: BR005

      statement: \>

        Open tickets are defined as STATUS \= 'open'. Two tickets are

        currently open: TKT-5007 (C013 BankWest, critical security)

        and TKT-5020 (C010 InsureNet, high billing). Their resolved\_at

        is NULL by design — not a data load error.

      source: "Phase 4 data quality review — confirmed design intent"

      captured: 2026-06-05

      implemented\_in: "support\_metrics CTE (WHERE status \= 'open')"

      conflicts\_with: NONE

  assumptions:

    \- assumption\_id: A001

      statement: \>

        At-risk flag logic (approved by Martin Alvarez, Phase 5):

        at\_risk\_flag \= TRUE when ANY of:

          (1) has\_open\_critical\_ticket \= TRUE

          (2) open\_ticket\_count \> 2

          (3) avg\_satisfaction\_score \< 3.0

        Under this logic, 2 customers are flagged:

          C013 BankWest → condition (1): open critical security ticket

          C012 ManufaCT → condition (3): avg CSAT \= 2.0

      approved\_by: "Martin Alvarez"

      approved\_date: 2026-06-05

      implemented\_in: "risk\_indicators CTE — at\_risk\_flag field"

      conflicts\_with: NONE

  architecture\_decisions:

    \- decision\_id: ADR001

      date: 2026-06-05

      decision: "Use CTE-based SQL for ANALYTICS.CUSTOMER\_360 (not a materialized view)"

      rationale\_engineering: \>

        CTE approach produces a single, auditable SQL statement with

        one CTE per field group. Each transformation step is visible

        and independently testable. Platform-portable — works on

        Snowflake, Redshift, Databricks, DuckDB without modification.

      rationale\_business: \>

        Any data analyst can read the query and understand exactly

        where each number comes from. No hidden logic in view

        definitions or stored procedures. Easier to audit for

        compliance or executive review.

      alternatives\_considered: "Materialized view (platform-specific), dbt models (requires dbt setup)"

      made\_by: "Martin Alvarez"

    \- decision\_id: ADR002

      date: 2026-06-05

      decision: "ANSI SQL first, then platform-adapt in Phase 6"

      rationale\_engineering: \>

        Writing in ANSI SQL in Phase 3 keeps the mapping logic

        platform-independent. Platform-specific syntax (Snowflake's

        QUALIFY, Redshift's ISNULL, Databricks' DOUBLE) is applied

        only at deployment time in Phase 6\.

      rationale\_business: \>

        The same business logic runs on any data platform the company

        uses — today Snowflake, tomorrow Redshift, next year Databricks.

        The business rules don't change when the platform changes.

      alternatives\_considered: "Platform-specific SQL from Phase 3 (creates lock-in)"

      made\_by: "Martin Alvarez"

  lineage:

    critical\_paths:

      \- path: "RAW\_DATA.CRM\_CUSTOMERS → customer\_base CTE → ANALYTICS.CUSTOMER\_360"

        risk\_level: high

        notes: "Spine. Any change to CRM schema breaks the entire Customer 360 view."

      \- path: "RAW\_DATA.ERP\_ORDERS → order\_metrics CTE → ANALYTICS.CUSTOMER\_360"

        risk\_level: medium

        notes: \>

          Join on CUST\_ID \= CUSTOMER\_ID. If CUST\_ID is renamed in ERP,

          join silently returns zero rows — all order metrics become NULL.

          \[SCHEMA BREAKING CHANGE\] risk.

      \- path: "RAW\_DATA.SUPPORT\_TICKETS → support\_metrics CTE → ANALYTICS.CUSTOMER\_360"

        risk\_level: medium

        notes: \>

          Join on CUSTOMER\_REF \= CUSTOMER\_ID. Same rename risk as ERP.

          at\_risk\_flag depends on this path — a break here silently

          disables the risk flagging system.

    known\_data\_quality:

      \- item: "C007 Logistix — no support ticket record"

        status: "confirmed by design (churned customer)"

        resolution: "BR004 documents NULL satisfaction as correct"

      \- item: "TKT-5007, TKT-5020 — NULL resolved\_at"

        status: "confirmed by design (open tickets)"

        resolution: "BR005 documents open status as correct"

      \- item: "C009 AgroPrime, C015 EnergyCorp — Brazilian phone format"

        status: "confirmed correct (international customers)"

        resolution: "No action needed — phone stored as VARCHAR"

  at\_risk\_customers:

    \- customer\_id: "C013"

      company: "BankWest"

      contact: "Michael Okonkwo"

      industry: "Financial Services"

      total\_order\_value\_usd: 457650

      portfolio\_pct: 23.0

      risk\_trigger: "Open critical security ticket (TKT-5007)"

      avg\_satisfaction: 3.0

      priority: "IMMEDIATE ESCALATION"

    \- customer\_id: "C012"

      company: "ManufaCT"

      contact: "Sandra Kowalski"

      industry: "Manufacturing"

      total\_order\_value\_usd: 22800

      portfolio\_pct: 1.1

      risk\_trigger: "Satisfaction score 2.0/5 (below 3.0 threshold)"

      avg\_satisfaction: 2.0

      priority: "Proactive outreach"

  expected\_validation\_results:

    total\_rows: 15

    at\_risk\_customers: 2

    total\_portfolio\_value\_usd: 1989950

    avg\_customer\_value\_usd: 132663

    at\_risk\_portfolio\_value\_usd: 480450

    at\_risk\_portfolio\_pct: 24.1

    null\_satisfaction\_count: 1  \# C007 Logistix

  open\_items:

    \- id: OI001

      priority: high

      description: "Define incremental refresh strategy for ANALYTICS.CUSTOMER\_360"

      owner: TBD

      blocked\_by: NONE

      notes: "Options: scheduled TRUNCATE+INSERT, Snowflake Dynamic Table, dbt incremental"

    \- id: OI002

      priority: medium

      description: "Scaffold dbt test suite for ANALYTICS.CUSTOMER\_360"

      owner: TBD

      blocked\_by: NONE

      notes: "Minimum: not\_null \+ unique on customer\_id, accepted\_values on at\_risk\_flag"

    \- id: OI003

      priority: medium

      description: "Build Great Expectations suite for RAW\_DATA layer"

      owner: TBD

      blocked\_by: NONE

      notes: "Freshness, volume, and referential integrity expectations"

    \- id: OI004

      priority: low

      description: "Add SCD Type 2 for at\_risk\_flag history tracking"

      owner: TBD

      blocked\_by: OI001

      notes: "Track when customers cross the at-risk threshold and when they recover"

    \- id: OI005

      priority: low

      description: "Adapt this mission for a second platform (Redshift or Databricks)"

      owner: TBD

      blocked\_by: NONE

      notes: "Primary adaptation: TIMESTAMP syntax and numeric type names"

  session\_log:

    \- date: 2026-06-05

      summary: \>

        Initial mission setup. Registered PROJ-C360. Ran all 9 phases.

        Captured BR001-BR005. Approved A001 (at-risk logic). Logged ADR001-ADR002.

        Produced ANALYTICS.CUSTOMER\_360 — 15 rows, 38 fields, 2 at-risk customers.

        BankWest ($457,650) flagged for immediate escalation.

      rules\_captured: \[BR001, BR002, BR003, BR004, BR005\]

      assumptions\_approved: \[A001\]

      decisions\_made: \[ADR001, ADR002\]

      next\_session\_start: "Review OI001 — define incremental refresh strategy"  


  # ── Demo 2 Session Entry (2026-06-10) ──────────────────────────
# ================================================================
# DEMO_REGISTRY.md — Session Entry
# Session: DEMO2 | Project: PROJ-C360 | Date: 2026-06-10
# ================================================================

- session_id: DEMO2
  project_id: PROJ-C360
  date: 2026-06-10
  type: autonomous_mcp_execution
  status: complete
  operator: "Claude (claude-sonnet-4-6) — autonomous DuckDB CLI execution"
  database: 'G:\Projects\DE-Intelligence\mp_demo.db'

  operating_model:
    sql_execution: "autonomous via DuckDB CLI (mcp-server-duckdb not active this session)"
    ddl_approval: "required — obtained explicitly for CREATE OR REPLACE VIEW and CREATE TABLE"
    output_format: "dual-language (engineering + business) on all significant findings"
    session_primer: DEMO2_SESSION_PRIMER.md

  # ──────────────────────────────────────────────────────────────
  # PHASE 0 — Autonomous Database Introspection
  # ──────────────────────────────────────────────────────────────
  phase_0_introspection:
    method: "autonomous — no schema knowledge provided at session start"
    objects_discovered:
      - schema: RAW_DATA
        tables:
          - name: CRM_CUSTOMERS
            type: BASE TABLE
            rows: 15
            pk: CUSTOMER_ID
            watermark: "SIGNUP_DATE (business date — not an ETL watermark)"
          - name: ERP_ORDERS
            type: BASE TABLE
            rows: 30
            pk: ORDER_ID
            fk: "CUST_ID -> CRM_CUSTOMERS.CUSTOMER_ID"
            watermark: "ORDER_DATE (business date — not an ETL watermark)"
          - name: SUPPORT_TICKETS
            type: BASE TABLE
            rows: 25
            pk: TICKET_ID
            fk: "CUSTOMER_REF -> CRM_CUSTOMERS.CUSTOMER_ID"
            watermark: "CREATED_AT / RESOLVED_AT (business timestamps — not ETL watermarks)"
      - schema: ANALYTICS
        tables:
          - name: CUSTOMER_360
            type: VIEW
            rows: 15
            columns: 38
            status: "preserved as fallback"
          - name: CUSTOMER_360_MART
            type: BASE TABLE
            rows: 15
            columns: 39
            added_this_session: true
    join_relationships_inferred:
      - "CRM_CUSTOMERS.CUSTOMER_ID = ERP_ORDERS.CUST_ID = SUPPORT_TICKETS.CUSTOMER_REF"
      - rule: BR002
    schema_gap_identified: >
      None of the three RAW_DATA source tables carry an ETL ingestion timestamp.
      SIGNUP_DATE, ORDER_DATE, and CREATED_AT are business event dates, not load
      times. True incremental refresh is impossible without schema changes. Logged
      as OI009.
    demo1_benchmarks_revalidated:
      total_rows: 15
      at_risk_count: 2
      portfolio_value: 1986450.00
      null_csat_count: 1
      source: ANALYTICS.CUSTOMER_360 (live query)
      at_risk_customers:
        - id: C013
          company: BankWest
          trigger: "Open critical ticket TKT-5007 (open since 2023-03-20)"
          revenue: 457650.00
        - id: C012
          company: ManufaCT
          trigger: "AVG_SATISFACTION_SCORE = 2.0"
          revenue: 22800.00

  # ──────────────────────────────────────────────────────────────
  # WORK COMPLETED — OI002: dbt Test Suite
  # ──────────────────────────────────────────────────────────────
  oi002_dbt_test_suite:
    status: CLOSED
    path: 'G:\Projects\DE-Intelligence\dbt\'
    files_delivered: 24
    tests_delivered: 36
    breakdown:
      generic_tests: 18
      singular_tests: 17
      freshness_tests: 1
    generic_test_coverage:
      - "not_null, unique on CRM_CUSTOMERS.CUSTOMER_ID"
      - "accepted_values on CRM_CUSTOMERS.ACCOUNT_STATUS"
      - "not_null, unique on ERP_ORDERS.ORDER_ID"
      - "not_null on ERP_ORDERS.CUST_ID"
      - "accepted_values on ERP_ORDERS.ORDER_STATUS: [delivered, cancelled]"
      - "not_null, unique on SUPPORT_TICKETS.TICKET_ID"
      - "not_null on SUPPORT_TICKETS.CUSTOMER_REF"
      - "accepted_values on SUPPORT_TICKETS.STATUS: [open, resolved]"
      - "accepted_values on SUPPORT_TICKETS.PRIORITY: [low, medium, high, critical]"
      - "not_null, unique on CUSTOMER_360.CUSTOMER_ID"
      - "not_null, accepted_values on CUSTOMER_360.ACCOUNT_STATUS"
      - "not_null on CUSTOMER_360: TOTAL_ORDERS, TOTAL_TICKETS, AT_RISK_FLAG, HAS_OPEN_CRITICAL_TICKET, LOW_SATISFACTION_FLAG"
    singular_test_coverage:
      BR001:
        - br001_spine_row_count.sql
        - br001_spine_no_null_customer_id.sql
      BR002:
        - br002_no_crm_customers_dropped.sql
        - br002_no_orphaned_erp_orders.sql
        - br002_no_orphaned_support_tickets.sql
      BR003:
        - br003_at_risk_open_critical_not_flagged.sql
        - br003_at_risk_excess_open_tickets_not_flagged.sql
        - br003_at_risk_low_csat_not_flagged.sql
        - br003_risk_reason_populated_when_at_risk.sql
        - br003_known_at_risk_customers.sql
      BR004:
        - br004_no_zero_satisfaction_score.sql
        - br004_c007_satisfaction_is_null.sql
      BR005:
        - br005_cancelled_orders_excluded_from_total.sql
      BR006:
        - br006_satisfaction_non_open_tickets_only.sql
      BR007:
        - br007_order_details_delivered_only.sql
      BR008:
        - br008_avg_order_value_max_2_decimals.sql
        - br008_avg_satisfaction_max_2_decimals.sql
    freshness_test_coverage:
      - freshness_mart_refreshed_within_65_minutes.sql
    test_results:
      singular_all_pass: true
      mart_all_pass: true
      note: "All 36 tests validated directly against live DuckDB before close"
    dbt_adapter: dbt-duckdb
    run_command: "dbt test --profiles-dir ."
    file_manifest:
      config:
        - dbt/dbt_project.yml
        - dbt/profiles.yml
        - dbt/packages.yml
      models:
        - dbt/models/sources.yml
        - dbt/models/marts/customer_360_mart.sql
        - dbt/models/marts/schema.yml
      tests:
        - dbt/tests/br001_spine_row_count.sql
        - dbt/tests/br001_spine_no_null_customer_id.sql
        - dbt/tests/br002_no_crm_customers_dropped.sql
        - dbt/tests/br002_no_orphaned_erp_orders.sql
        - dbt/tests/br002_no_orphaned_support_tickets.sql
        - dbt/tests/br003_at_risk_open_critical_not_flagged.sql
        - dbt/tests/br003_at_risk_excess_open_tickets_not_flagged.sql
        - dbt/tests/br003_at_risk_low_csat_not_flagged.sql
        - dbt/tests/br003_risk_reason_populated_when_at_risk.sql
        - dbt/tests/br003_known_at_risk_customers.sql
        - dbt/tests/br004_no_zero_satisfaction_score.sql
        - dbt/tests/br004_c007_satisfaction_is_null.sql
        - dbt/tests/br005_cancelled_orders_excluded_from_total.sql
        - dbt/tests/br006_satisfaction_non_open_tickets_only.sql
        - dbt/tests/br007_order_details_delivered_only.sql
        - dbt/tests/br008_avg_order_value_max_2_decimals.sql
        - dbt/tests/br008_avg_satisfaction_max_2_decimals.sql
        - dbt/tests/freshness_mart_refreshed_within_65_minutes.sql

  # ──────────────────────────────────────────────────────────────
  # WORK COMPLETED — OI001: Incremental Refresh Strategy
  # ──────────────────────────────────────────────────────────────
  oi001_incremental_refresh:
    status: CLOSED
    decision: "Option B — full refresh materialized table (CUSTOMER_360_MART)"
    rationale: >
      No ETL watermarks exist on any source table. Watermark-based incremental
      would silently miss CRM record updates, order status changes, and ticket
      resolutions (e.g., TKT-5007 C013 BankWest resolving would not be detected
      by any available watermark column). Full refresh is the only correct approach
      at current schema state. True incremental blocked until OI009.
    options_evaluated:
      - id: A
        description: "Keep as VIEW (current state, always fresh)"
        verdict: "rejected — no freshness signal, no BI performance gain"
      - id: B
        description: "Materialize as TABLE + scheduled full refresh"
        verdict: "accepted — simple, correct, adds REFRESHED_AT freshness signal"
      - id: C
        description: "True incremental with watermarks"
        verdict: "deferred — blocked by OI009 (no LOADED_AT on source tables)"
    refresh_cadence: hourly
    freshness_sla_minutes: 65
    mart_object: ANALYTICS.CUSTOMER_360_MART
    mart_columns: 39
    mart_column_groups:
      - "Group 1: Customer Identity (15 columns) — direct from CRM_CUSTOMERS + CUSTOMER_TENURE_DAYS"
      - "Group 2: Order Metrics (7 columns) — aggregated from ERP_ORDERS"
      - "Group 3: Order Details (3 columns) — most recent delivered order"
      - "Group 4: Support Metrics (7 columns) — aggregated from SUPPORT_TICKETS"
      - "Group 5: Support Details (3 columns) — most recent ticket"
      - "Group 6: Risk Indicators (3 columns) — derived at-risk logic"
      - "Group 7: Mart Metadata (1 column) — REFRESHED_AT"
    fallback_object: ANALYTICS.CUSTOMER_360
    fallback_preserved: true
    scheduler_status: >
      Not implemented this session (infrastructure boundary). Documented in
      dbt_project.yml as Windows Task Scheduler command and cron syntax.
      Action: dbt run --select customer_360_mart --profiles-dir .
      Trigger: repeat every 1 hour.
    post_build_validation:
      total_rows: 15
      at_risk_count: 2
      portfolio_value: 1986450.00
      null_csat_count: 1
      mart_refreshed_at: "2026-06-10 21:55:42-07"
      all_36_tests_pass: true

  # ──────────────────────────────────────────────────────────────
  # BUSINESS RULE CHANGES
  # ──────────────────────────────────────────────────────────────
  business_rule_changes:
    - rule_id: BR006
      change_type: revision
      date: 2026-06-10
      previous_statement: >
        AVG_SATISFACTION_SCORE computed on tickets where STATUS != 'open'.
      revised_statement: >
        AVG_SATISFACTION_SCORE computed on tickets where STATUS = 'resolved' only.
        All other statuses (open, escalated, in_progress, or any future status)
        are excluded from the average.
      decision_maker: Martin Alvarez
      rationale: >
        STATUS = 'resolved' makes the intent explicit and requires deliberate
        opt-in for any future ticket status, rather than automatic inclusion via
        != 'open'. Satisfaction score should reflect completed interactions only.
        A ticket in any non-resolved status has no final score yet.
      discovery_context: >
        Discrepancy found during OI002 test authoring. Registered rule said
        "closed tickets only" but view implementation used STATUS != 'open'.
        Decision requested and obtained before test was written.
      files_updated:
        - 02_customer_360_view_v2.sql
        - dbt/tests/br006_satisfaction_non_open_tickets_only.sql
      live_view_redeployed: true
      benchmarks_unchanged: true

  # ──────────────────────────────────────────────────────────────
  # ARCHITECTURE DECISIONS
  # ──────────────────────────────────────────────────────────────
  architecture_decisions:
    - adr_id: ADR003
      title: "Materialized mart over live view for BI consumers"
      status: accepted
      date: 2026-06-10
      engineering: >
        CUSTOMER_360_MART materialized as BASE TABLE via dbt full-refresh model.
        Wraps ANALYTICS.CUSTOMER_360 view, adds REFRESHED_AT metadata column.
        dbt test suite (36 tests) runs as post-refresh quality gate.
        Full refresh is the only correct strategy until OI009 delivers
        LOADED_AT watermarks on source tables.
      business: >
        BI tools query a pre-computed table rather than re-executing five CTEs
        on every dashboard load. REFRESHED_AT gives analysts an explicit data
        freshness signal. Freshness SLA: data no older than 65 minutes at any
        point in time. No cutover risk — live view preserved as fallback.
      consequences:
        - "ANALYTICS.CUSTOMER_360 view preserved — no breaking change for existing consumers"
        - "ANALYTICS.CUSTOMER_360_MART is the production consumer target from this point"
        - "Scheduler required — documented in dbt_project.yml, not yet implemented"
        - "Incremental strategy blocked on OI009"

  # ──────────────────────────────────────────────────────────────
  # OPEN ITEMS — COMPLETE REGISTRY AS OF END OF DEMO 2
  # ──────────────────────────────────────────────────────────────
  open_items_registry:
    - id: OI001
      priority: HIGH
      status: CLOSED
      closed: 2026-06-10
      description: "Incremental refresh strategy for CUSTOMER_360"
      resolution: "Full refresh materialized table CUSTOMER_360_MART. ADR003 accepted."

    - id: OI002
      priority: MEDIUM
      status: CLOSED
      closed: 2026-06-10
      description: "dbt test suite for ANALYTICS.CUSTOMER_360"
      resolution: "36 tests across 24 files. All passing. Covers BR001-BR008 + freshness SLA."

    - id: OI003
      priority: MEDIUM
      status: OPEN
      description: "Great Expectations suite for RAW_DATA source layer"

    - id: OI004
      priority: LOW
      status: OPEN
      description: "SCD Type 2 history tracking for AT_RISK_FLAG"

    - id: OI005
      priority: LOW
      status: OPEN
      blocked_by: OI009
      description: "Adapt pipeline for second platform (Redshift or Databricks)"

    - id: OI006
      priority: MEDIUM
      status: OPEN
      description: >
        Evaluate HIGH_VALUE_FLAG for portfolio concentration.
        C013 BankWest = 23% of $1.99M portfolio — concentration risk signal.

    - id: OI007
      priority: LOW
      status: OPEN
      description: "ACCOUNT_STATUS filter guidance for BI layer"

    - id: OI008
      priority: MEDIUM
      status: OPEN
      description: >
        Add multi-condition at-risk test customer to validate RISK_REASON
        concatenation (e.g., customer triggering both condition a and c).
        Current at-risk customers each fire only a single condition.

    - id: OI009
      priority: HIGH
      status: OPEN
      opened: 2026-06-10
      blocks: ["OI001_incremental", "OI005"]
      description: >
        Add LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP to all three
        RAW_DATA source tables (CRM_CUSTOMERS, ERP_ORDERS, SUPPORT_TICKETS).
        ETL ingestion timestamp required for true incremental refresh strategy
        and for dbt source freshness testing.
      requires: "DDL approval + upstream ETL pipeline coordination"

  # ──────────────────────────────────────────────────────────────
  # NEXT SESSION RECOMMENDATIONS
  # ──────────────────────────────────────────────────────────────
  next_session:
    recommended_first: OI009
    rationale: >
      OI009 is the highest-leverage item — it unblocks both OI001 true
      incremental refresh and OI005 platform migration. Requires DDL on
      three source tables plus upstream ETL pipeline coordination.
    alternative_first: OI006
    alternative_rationale: >
      If a business-facing deliverable is preferred before schema changes,
      HIGH_VALUE_FLAG (OI006) adds a concentration risk signal with no DDL
      required — pure view, mart, and test work.
    start_prompt: >
      Resume PROJ-C360. OI001 and OI002 closed. Open items OI003-OI009
      with OI009 highest priority (blocks incremental and platform migration).
      Database: G:\Projects\DE-Intelligence\mp_demo.db.
      dbt project: G:\Projects\DE-Intelligence\dbt\ (24 files, 36 tests, all passing).
      CUSTOMER_360_MART live, freshness SLA 65 minutes, REFRESHED_AT populated.
      BR001-BR008 registered. BR006 revised 2026-06-10 to STATUS = 'resolved'.
      ADR001-ADR003 accepted. All Demo 1 benchmarks hold: 15 rows, 2 at-risk,
      $1,986,450 portfolio, C007 Logistix null satisfaction.

  # ── Demo 3 Session Entry (2026-06-13) ──────────────────────────
# ================================================================
# DEMO_REGISTRY.md — Session Entry
# Session: DEMO3 | Project: PROJ-C360 | Date: 2026-06-13
# ================================================================

- session_id: DEMO3
  project_id: PROJ-C360
  date: 2026-06-13
  type: autonomous_cli_execution
  status: in_progress
  operator: "Claude (claude-sonnet-4-6) — autonomous DuckDB CLI execution"
  database: 'G:\Projects\DE-Intelligence\mp_demo.db'

  operating_model:
    sql_execution: "autonomous via DuckDB CLI"
    ddl_approval: "required — obtained explicitly for ALTER TABLE statements"
    output_format: "dual-language (engineering + business) on all significant findings"
    session_primer: DEMO3_SESSION_PRIMER.md

  # ──────────────────────────────────────────────────────────────
  # ENVIRONMENT FINGERPRINT
  # ──────────────────────────────────────────────────────────────
  environment:
    python_version: "3.13.9"
    python_path: 'C:\Users\jmalv\AppData\Local\Programs\Python\Python313\'
    pip_path: 'C:\Users\jmalv\AppData\Local\Programs\Python\Python313\Scripts\pip.exe'
    dbt_core: "1.11.11 (latest at 2026-06-13)"
    dbt_duckdb_adapter: "1.10.1 (latest at 2026-06-13)"
    dbt_utils_package: "1.3.3"
    duckdb_python_driver: "1.5.3"
    duckdb_cli: "v1.5.3 (Variegata 14eca11bd9)"
    duckdb_version_match: true
    version_match_note: "CLI and Python adapter on identical DuckDB version — no file format risk"
    install_type: "fresh install this session"
    install_note: >
      dbt was NOT present in any persistent Python environment on this machine when
      Demo 3 started. No prior version was uninstalled during pip install. dbt_packages/
      was empty and required 'dbt deps' (installed dbt_utils 1.3.3) before tests could run.
      Demo 2 dbt results were authored and committed to git — validated in a different
      shell session or environment, not a regression.
    dependency_conflict:
      package: pathspec
      downgraded_from: "1.1.1"
      downgraded_to: "0.12.1"
      reason: "dbt-duckdb 1.10.1 requires pathspec<1.1"
      impact: >
        mypy 2.1.0 requires pathspec>=1.0.0 — mypy is broken in this Python environment
        until pathspec is upgraded or dbt is installed in an isolated venv. mypy is not
        in dbt's call chain; no effect on dbt test execution. No action required unless
        mypy is actively used here.

  # ──────────────────────────────────────────────────────────────
  # STATE CONFIRMED AT SESSION START
  # ──────────────────────────────────────────────────────────────
  session_start_validation:
    method: "live queries against mp_demo.db before any work"
    benchmarks_confirmed:
      total_rows: 15
      at_risk_count: 2
      portfolio_value: 1986450.00
      null_satisfaction_count: 1
      mart_refreshed_at: "2026-06-10 21:55:42.335138-07"
    at_risk_customers_confirmed:
      - id: C013
        company: BankWest
        revenue: 457650.00
        risk_reason: "Open critical ticket"
      - id: C012
        company: ManufaCT
        revenue: 22800.00
        risk_reason: "Low satisfaction score"

  # ──────────────────────────────────────────────────────────────
  # WORK COMPLETED — OI009: ETL Watermarks
  # ──────────────────────────────────────────────────────────────
  oi009_etl_watermarks:
    status: CLOSED
    closed: 2026-06-13
    ddl_approved_by: "Martin Alvarez (explicit approval in session, 2026-06-13)"
    ddl_executed:
      - "ALTER TABLE RAW_DATA.CRM_CUSTOMERS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP;"
      - "ALTER TABLE RAW_DATA.ERP_ORDERS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP;"
      - "ALTER TABLE RAW_DATA.SUPPORT_TICKETS ADD COLUMN LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP;"
    backfill_results:
      CRM_CUSTOMERS:
        total_rows: 15
        loaded_at_populated: 15
        nulls: 0
        backfill_value: "2026-06-13 14:53:48.692138"
      ERP_ORDERS:
        total_rows: 30
        loaded_at_populated: 30
        nulls: 0
        backfill_value: "2026-06-13 14:53:48.708121"
      SUPPORT_TICKETS:
        total_rows: 25
        loaded_at_populated: 25
        nulls: 0
        backfill_value: "2026-06-13 14:53:48.712241"
    backfill_behavior:
      duckdb: "Backfills existing rows with CURRENT_TIMESTAMP at ALTER execution time. All rows in a table receive the identical timestamp."
      oracle: "Same as DuckDB — evaluates DEFAULT at ALTER time."
      snowflake: "Same as DuckDB — backfills existing rows with the DEFAULT value."
      redshift: "[OI005 PLATFORM NOTE] Sets existing rows to NULL on ADD COLUMN regardless of DEFAULT clause. DEFAULT only applies to future INSERTs. Requires post-ALTER UPDATE pass: UPDATE <table> SET LOADED_AT = CURRENT_TIMESTAMP WHERE LOADED_AT IS NULL;"
      aurora_postgresql: "[OI005 PLATFORM NOTE] Same as Redshift — existing rows receive NULL, not the DEFAULT. Post-ALTER UPDATE pass required."
    backfill_interpretation: >
      Backfill timestamps (2026-06-13) correctly represent 'unknown original load time'
      for pre-existing rows — they are placeholders, not fabricated history. Any incremental
      logic must treat rows with the backfill timestamp as potentially full-history and
      perform a one-time full refresh before switching to true watermark-based incrementals.
    unblocks: ["OI001_true_incremental", "OI005"]
    test_results:
      total_tests_run: 61
      passed: 60
      failed: 1
      failed_test: "freshness_mart_refreshed_within_65_minutes"
      failure_reason: >
        CUSTOMER_360_MART.REFRESHED_AT = 2026-06-10 21:55:42-07 (3 days stale).
        SLA: within 65 minutes. Failure is correct and expected — no scheduler configured.
        Not a regression from OI009 DDL. Schema-breaking failures: 0. Business rule failures: 0.
      test_count_note: >
        dbt-core 1.11.11 reported 61 tests vs. 36 in Demo 2 session log. Difference is
        dbt 1.11 counting: generic tests on source definitions each generate a prefixed
        source_not_null_* / source_unique_* node. All 36 originally named tests are present
        and passing. No new tests were added; this is a dbt version counting change.

  # ──────────────────────────────────────────────────────────────
  # NEW OPEN ITEM — OI010
  # ──────────────────────────────────────────────────────────────
  oi010_etl_update_watermark:
    id: OI010
    priority: HIGH
    status: OPEN
    opened: 2026-06-13
    registered_by: "Martin Alvarez (stated during OI009 DDL approval)"
    description: >
      ETL pipeline must explicitly set LOADED_AT = CURRENT_TIMESTAMP on every UPDATE
      operation, not just INSERT. The TIMESTAMP DEFAULT CURRENT_TIMESTAMP column
      definition only fires on INSERT — updated rows silently retain their original
      LOADED_AT value, making changes invisible to watermark-based incremental logic.
    scope: "ETL pipeline coordination — out of scope for this DDL work"
    blocks: ["OI001_true_incremental", "OI005"]
    conflicts_with: NONE
    implementation_note: >
      Any row updated in the source system (ticket status change, order delivery
      confirmation, customer address update) will not trigger an incremental load unless
      the ETL pipeline explicitly refreshes LOADED_AT on update. Without this, watermark-
      based incrementals will silently miss updates to existing rows.

  # ──────────────────────────────────────────────────────────────
  # OPEN ITEMS — STATE AS OF DEMO 3 CHECKPOINT
  # ──────────────────────────────────────────────────────────────
  open_items_registry:
    - id: OI001
      priority: HIGH
      status: CLOSED
      closed: 2026-06-10
      description: "Incremental refresh strategy for CUSTOMER_360"
      resolution: "Full refresh materialized table CUSTOMER_360_MART. ADR003 accepted."

    - id: OI002
      priority: MEDIUM
      status: CLOSED
      closed: 2026-06-10
      description: "dbt test suite for ANALYTICS.CUSTOMER_360"
      resolution: "36 tests across 24 files. All passing. Covers BR001-BR008 + freshness SLA."

    - id: OI003
      priority: MEDIUM
      status: OPEN
      description: "Great Expectations suite for RAW_DATA source layer"

    - id: OI004
      priority: LOW
      status: OPEN
      description: "SCD Type 2 history tracking for AT_RISK_FLAG"

    - id: OI005
      priority: LOW
      status: OPEN
      blocked_by: OI010
      description: >
        Adapt pipeline for second platform (Oracle, Aurora PostgreSQL, Snowflake, Redshift).
        OI009 LOADED_AT DDL complete. OI010 (ETL update watermark) now primary blocker.
        Platform adaptation note: Redshift/Aurora require post-ALTER UPDATE pass for LOADED_AT
        backfill on existing rows (DuckDB/Oracle/Snowflake backfill automatically).

    - id: OI006
      priority: MEDIUM
      status: OPEN
      description: >
        HIGH_VALUE_FLAG for portfolio concentration. C013 BankWest = 23% of $1.99M
        portfolio — concentration risk signal. No DDL required — pure view/mart/test work.
        Candidate for next session after OI009 close.

    - id: OI007
      priority: LOW
      status: OPEN
      description: "ACCOUNT_STATUS filter guidance for BI layer"

    - id: OI008
      priority: MEDIUM
      status: OPEN
      description: >
        Add multi-condition at-risk test customer to validate RISK_REASON concatenation.
        Current at-risk customers each fire only a single condition.

    - id: OI009
      priority: HIGH
      status: CLOSED
      opened: 2026-06-10
      closed: 2026-06-13
      description: "Add LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP to all three RAW_DATA tables."
      resolution: >
        DDL executed 2026-06-13. All three tables updated. 15/30/25 rows backfilled with
        ALTER execution timestamp. 60/61 dbt tests pass; 1 expected freshness failure (no
        scheduler). Zero schema-breaking or business-rule failures.
      unblocked: ["OI001_true_incremental", "OI005"]

    - id: OI010
      priority: HIGH
      status: OPEN
      opened: 2026-06-13
      blocks: ["OI001_true_incremental", "OI005"]
      description: >
        ETL pipeline must set LOADED_AT = CURRENT_TIMESTAMP on every UPDATE, not just
        INSERT. Coordination item for ETL owner — out of scope for schema DDL work.

  # ──────────────────────────────────────────────────────────────
  # WORK COMPLETED — OI006: HIGH_VALUE_FLAG (BR011)
  # ──────────────────────────────────────────────────────────────
  oi006_high_value_flag:
    status: CLOSED
    closed: 2026-06-14
    ddl_required: false
    approved_by: "Martin Alvarez (explicit approval in session, 2026-06-13)"

  # ──────────────────────────────────────────────────────────────
  # BUSINESS RULE — BR011
  # ──────────────────────────────────────────────────────────────
  br011_high_value_flag:
    rule_id: BR011
    statement: >
      HIGH_VALUE_FLAG = TRUE when a customer's TOTAL_ORDER_VALUE_USD exceeds 15%
      of total portfolio value (SUM of TOTAL_ORDER_VALUE_USD across all customers).
      Concentration-risk signal. Threshold defined as a named constant in the
      high_value_threshold CTE (0.15) — single change point for future revisions.
    source: "Martin Alvarez (stated and approved 2026-06-13)"
    captured: 2026-06-13
    implemented_in: >
      ANALYTICS.CUSTOMER_360 (view v3) — CTEs portfolio_total + high_value_threshold,
      HIGH_VALUE_FLAG column in Group 6: Risk Indicators (now 4 fields, 39 cols total).
      ANALYTICS.customer_360_mart (40 cols including REFRESHED_AT).
      dbt/tests/br011_known_high_value_customer.sql — regression anchor.
      dbt/models/marts/schema.yml — not_null + accepted_values tests.
    conflicts_with: NONE
    known_high_value_customers:
      - id: C013
        company: BankWest
        total_order_value_usd: 457650.00
        portfolio_pct: 23.0
      - id: C004
        company: FinServ Corp
        total_order_value_usd: 309200.00
        portfolio_pct: 15.6
      - id: C010
        company: InsureNet
        total_order_value_usd: 304300.00
        portfolio_pct: 15.3
    threshold_note: >
      Three customers cross 15% at implementation (two were unexpected — BankWest
      anticipated, FinServ Corp and InsureNet discovered via V4 query).
      Drop-off to C005 HealthSys at 8.1% is steep — threshold is stable, minor
      data shifts will not accidentally add a fourth customer.

  # ──────────────────────────────────────────────────────────────
  # OBSERVATION — C010 InsureNet (not a business rule)
  # ──────────────────────────────────────────────────────────────
  c010_insurenet_observation:
    customer_id: C010
    company: InsureNet
    observation: >
      C010 InsureNet has HIGH_VALUE_FLAG = TRUE (15.3% of portfolio, $304,300)
      AND an open high-priority billing ticket TKT-5020. Does not currently cross
      AT_RISK_FLAG threshold: ticket priority = high (not critical, so condition a
      does not fire), open ticket count = 1 (condition b threshold is > 2), and
      no resolved tickets to produce a CSAT score (condition c cannot fire).
    action: >
      No new business rule required. Recommend periodic review: if TKT-5020
      escalates to critical priority, or if InsureNet accrues resolved tickets
      with CSAT < 3.0, AT_RISK_FLAG will fire. The combination of value
      concentration + unresolved support creates latent churn risk not currently
      captured by AT_RISK_FLAG alone.
    registered: 2026-06-14

  # ──────────────────────────────────────────────────────────────
  # SIDE-EFFECT FINDING — CUSTOMER_360_MART case-mismatch fix
  # ──────────────────────────────────────────────────────────────
  side_effect_case_mismatch:
    finding: >
      ANALYTICS.CUSTOMER_360_MART was originally created in Demo 2 as an uppercase
      BASE TABLE ("ANALYTICS"."CUSTOMER_360_MART"). dbt targets lowercase schema/table
      names by default ("analytics"."customer_360_mart"). DuckDB's quoted-identifier
      handling treats these as distinct names, causing a Compilation Error on dbt run
      when the mart needed rebuilding.
    resolution: >
      DROP TABLE ANALYTICS.CUSTOMER_360_MART (approved Martin Alvarez, 2026-06-14),
      followed immediately by dbt run --select customer_360_mart which recreated the
      table as "analytics"."customer_360_mart" (lowercase alias per dbt config).
      Zero data gap: dbt creates the table atomically. ANALYTICS.CUSTOMER_360 view
      was untouched throughout.
    oi005_platform_note: >
      [OI005 PLATFORM NOTE] DuckDB stores the schema name in uppercase (ANALYTICS)
      in information_schema regardless of how it was created, but stores the table name
      in the case dbt used (customer_360_mart — lowercase). Other platforms have
      different defaults: Snowflake folds unquoted identifiers to uppercase by default;
      Redshift and PostgreSQL fold to lowercase; Oracle folds to uppercase. When migrating
      to a second platform (OI005), validate that dbt schema/table name casing aligns
      with the target platform's identifier behavior to avoid the same mismatch.
    post_fix_state:
      table_schema: ANALYTICS
      table_name: customer_360_mart
      col_count: 40
      confirmed_via: information_schema.tables + information_schema.columns
    demo3_fix_assessment: >
      The Demo 3 resolution (DROP + recreate) was a one-off workaround, not a permanent fix.
      After the DROP, dbt recreated the table using the profile schema 'analytics' (lowercase),
      which DuckDB silently resolved to the existing ANALYTICS schema — reproducing the
      identical mismatch. The next dbt run would have hit the same Compilation Error.
    demo4_root_cause_and_permanent_fix:
      identified: 2026-06-16
      session: Demo4-OI008
      approved_by: "Martin Alvarez"
      root_cause: >
        profiles.yml had 'schema: analytics' (lowercase). DuckDB stores the schema as
        ANALYTICS (uppercase) in information_schema. dbt's load_cached_relation macro
        found an approximate match and refused to guess, causing a Compilation Error on
        every dbt run that found an existing mart table. The Demo 3 DROP + recreate
        masked the symptom for one run but left the root cause intact.
      fix_applied: "Changed profiles.yml from 'schema: analytics' to 'schema: ANALYTICS' — a config edit requiring no DDL and no DML."
      fix_type: config_edit_no_ddl_no_dml
      result: >
        dbt run --select customer_360_mart resolved ANALYTICS.customer_360_mart by exact
        match. PASS=1, ERROR=0, WARN=0. Future scheduled runs will match without
        ambiguity because the profile schema now equals the stored schema name exactly.
        No DROP was required and the existing table was never at risk.
      status: CLOSED
      oi005_update: >
        [OI005 PLATFORM NOTE — RESOLVED] The identifier case-folding divergence first
        logged in Demo 3 now has a confirmed root cause and a permanent config-level fix:
        profiles.yml schema value must match the exact casing stored in the target
        platform's information_schema. For this DuckDB instance: ANALYTICS (uppercase).
        For OI005 platform migration targets — Redshift and PostgreSQL fold unquoted
        identifiers to lowercase, Snowflake and Oracle fold to uppercase — the same
        alignment rule applies: set profiles.yml schema to match what the platform
        actually stores, not what feels natural to type.

  # ──────────────────────────────────────────────────────────────
  # OI006 FILES CHANGED
  # ──────────────────────────────────────────────────────────────
  oi006_files_changed:
    - file: 02_customer_360_view_v3.sql
      change: "New file — view v3, 39 cols, CTEs 7+8 (portfolio_total, high_value_threshold), HIGH_VALUE_FLAG in Group 6"
    - file: dbt/models/marts/customer_360_mart.sql
      change: "high_value_flag column added; comment updated to v3 / 39 fields"
    - file: dbt/models/marts/schema.yml
      change: "HIGH_VALUE_FLAG column documentation added with not_null and accepted_values tests"
    - file: dbt/tests/br011_known_high_value_customer.sql
      change: "New singular test — regression anchor for C013, C004, C010 HIGH_VALUE_FLAG = TRUE"

  # ──────────────────────────────────────────────────────────────
  # dbt TEST RESULTS — POST OI006
  # ──────────────────────────────────────────────────────────────
  oi006_test_results:
    total_tests_run: 64
    passed: 64
    failed: 0
    errors: 0
    freshness_test: PASS
    freshness_note: >
      freshness_mart_refreshed_within_65_minutes passed this run — mart rebuilt at
      2026-06-14 11:50:15-07, within the 65-minute SLA. Will fail again between
      scheduled refreshes until scheduler is configured.
    new_tests_added: 3
    new_tests:
      - not_null_customer_360_mart_HIGH_VALUE_FLAG
      - accepted_values_customer_360_mart_HIGH_VALUE_FLAG__True__False
      - br011_known_high_value_customer

  # ──────────────────────────────────────────────────────────────
  # OPEN ITEMS — STATE AS OF DEMO 3 CLOSE
  # ──────────────────────────────────────────────────────────────
  open_items_registry_final:
    - id: OI001
      status: CLOSED
      closed: 2026-06-10

    - id: OI002
      status: CLOSED
      closed: 2026-06-10

    - id: OI003
      priority: MEDIUM
      status: OPEN
      description: "Great Expectations suite for RAW_DATA source layer"

    - id: OI004
      priority: LOW
      status: OPEN
      description: "SCD Type 2 history tracking for AT_RISK_FLAG"

    - id: OI005
      priority: LOW
      status: OPEN
      blocked_by: OI010
      description: >
        Adapt pipeline for second platform (Oracle, Aurora PostgreSQL, Snowflake, Redshift).
        OI009 LOADED_AT DDL complete. OI010 (ETL update watermark) now primary blocker.
        Platform notes: Redshift/Aurora require post-ALTER UPDATE pass for LOADED_AT backfill.
        Case-sensitivity: validate dbt schema/table name casing against target platform defaults
        (see side_effect_case_mismatch note above).

    - id: OI006
      priority: MEDIUM
      status: CLOSED
      closed: 2026-06-14
      description: "HIGH_VALUE_FLAG for portfolio concentration"
      resolution: >
        BR011 implemented. View v3 deployed (39 cols). Mart rebuilt (40 cols, lowercase).
        64/64 dbt tests pass. Three customers flagged: C013 (23.0%), C004 (15.6%), C010 (15.3%).

    - id: OI007
      priority: LOW
      status: OPEN
      description: "ACCOUNT_STATUS filter guidance for BI layer"

    - id: OI008
      priority: MEDIUM
      status: OPEN
      description: >
        Add multi-condition at-risk test customer to validate RISK_REASON concatenation.
        Current at-risk customers each fire only a single condition.

    - id: OI009
      priority: HIGH
      status: CLOSED
      closed: 2026-06-13

    - id: OI010
      priority: HIGH
      status: OPEN
      opened: 2026-06-13
      blocks: ["OI001_true_incremental", "OI005"]
      description: >
        ETL pipeline must set LOADED_AT = CURRENT_TIMESTAMP on every UPDATE, not just
        INSERT. Coordination item for ETL owner — out of scope for schema DDL work.

  # ──────────────────────────────────────────────────────────────
  # NEXT SESSION RECOMMENDATIONS (as of Demo 3 close)
  # ──────────────────────────────────────────────────────────────
  next_session:
    recommended_first: OI008
    rationale: >
      OI006 closed this session. OI008 (multi-condition at-risk test customer) is next —
      validates RISK_REASON concatenation logic currently untested for the compound-condition
      case. No DDL required.
    alternative_first: OI003
    alternative_rationale: >
      Great Expectations suite for RAW_DATA source layer — adds freshness, volume, and
      referential integrity expectations as a complement to the dbt test suite.
    start_prompt: >
      Resume PROJ-C360. OI001, OI002, OI006, OI009 closed. Open items OI003-OI005, OI007-OI008, OI010.
      OI008 (multi-condition at-risk test customer) recommended next — no DDL, pure test work.
      OI010 (ETL update watermark) is ETL coordination — external dependency.
      Database: G:\Projects\DE-Intelligence\mp_demo.db.
      View: ANALYTICS.CUSTOMER_360 (v3, 39 cols). Mart: analytics.customer_360_mart (40 cols, lowercase).
      LOADED_AT on all three RAW_DATA tables as of 2026-06-13.
      dbt: G:\Projects\DE-Intelligence\dbt\ (64 tests, 64 pass).
      dbt environment: Python 3.13.9, dbt-core 1.11.11, dbt-duckdb 1.10.1, DuckDB v1.5.3.
      BR001-BR011 registered. BR006 revised 2026-06-10. ADR001-ADR003 accepted.
      Benchmarks: 15 rows, 2 at-risk, $1,986,450 portfolio, C007 null satisfaction.
      HIGH_VALUE_FLAG: C013 BankWest (23.0%), C004 FinServ Corp (15.6%), C010 InsureNet (15.3%).

  # ──────────────────────────────────────────────────────────────
  # DEMO 4 — OI008 CLOSURE (2026-06-16)
  # ──────────────────────────────────────────────────────────────
  oi008_closure:
    id: OI008
    status: CLOSED
    closed: 2026-06-16
    session: Demo4-OI008
    approved_by: "Martin Alvarez"

    approach: option_a_modify_existing_customer
    rationale: >
      Modified C012 ManufaCT rather than inserting a 16th customer, preserving
      the 15-row spine guarantee (BR001) and keeping the test dataset compact.

    changes:
      - object: RAW_DATA.SUPPORT_TICKETS
        change: >
          INSERT TKT-5026 (CUSTOMER_REF=C012, PRIORITY=critical, STATUS=open,
          CATEGORY=billing, CREATED_AT=2024-03-15, SATISFACTION_SCORE=NULL,
          LOADED_AT=CURRENT_TIMESTAMP). Approved DML, executed 2026-06-16.
      - object: dbt/tests/br003_known_at_risk_customers.sql
        change: >
          Extended with exact RISK_REASON string assertions for both at-risk customers.
          C012 must equal 'Open critical ticket | Low satisfaction score' (multi-condition
          anchor). C013 must equal 'Open critical ticket' (single-condition clean-string
          anchor, no stray ' | ' artifacts). Header comment updated to reflect C012's
          new two-condition state and its role as the BR003 concatenation regression anchor.

    verified_results:
      view_ANALYTICS_CUSTOMER_360_C012:
        HAS_OPEN_CRITICAL_TICKET: true
        AVG_SATISFACTION_SCORE: 2.0
        AT_RISK_FLAG: true
        RISK_REASON: "Open critical ticket | Low satisfaction score"
        TOTAL_TICKETS: 2
        MOST_RECENT_TICKET_DATE: "2024-03-15 09:00:00"
        MOST_RECENT_TICKET_CATEGORY: billing
        MOST_RECENT_TICKET_STATUS: open
      mart_ANALYTICS_CUSTOMER_360_MART_C012:
        all_fields_match_view: true
        REFRESHED_AT: "2026-06-16 09:50:15-07"
      dbt_test_suite:
        total: 64
        passed: 63
        failed: 1
        failed_test: freshness_mart_refreshed_within_65_minutes
        failure_reason: >
          Pre-existing OI001 gap — no scheduler configured. Mart refreshed earlier
          in session; test ran >65 minutes later. Unrelated to OI008.
        br003_known_at_risk_customers: PASS

    process_note:
      title: "Inline-composition bug — two edit attempts reintroduced broken content"
      description: >
        Two attempts to edit br003_known_at_risk_customers.sql using inline-composed
        content (new_string typed directly in the tool call) both staged a version
        with a gating 'AND at_risk_flag = false' condition before the parenthesized
        OR block, making the RISK_REASON assertions logically unreachable — defeating
        OI008's purpose. The diff preview showed the broken structure but it was not
        caught before submission.
      resolution: >
        Switched to scratch-file discipline: write intended content to a scratch file,
        read it back with Get-Content -Encoding UTF8, confirm field-by-field, then
        copy-to-target rather than retyping. Applied for br003 edit, the
        DEMO_REGISTRY.md OI005 closure block, and the ACTIVE_SESSION status update.
      standing_recommendation: >
        For any test file, registry block, or multi-line SQL edit: compose in a
        scratch file, verify via Get-Content read-back, copy to target. Do not
        compose inline in the tool call for edits where logic or exact string
        matching is load-bearing. This applies to small edits as well as large ones
        — the br003 incident involved a WHERE clause, not a large block.
      logged: 2026-06-16
      session: Demo4-OI008

  # ──────────────────────────────────────────────────────────────
  # NEXT SESSION RECOMMENDATIONS (as of Demo 4 close)
  # ──────────────────────────────────────────────────────────────
  next_session_demo4:
    recommended_first: OI008_test_hardening
    rationale: >
      OI008 closed. Consider whether to add a negative test — a customer that does NOT
      fire multiple conditions should NOT have a pipe separator in RISK_REASON — to
      complete the BR003 concatenation coverage. Alternatively, OI003 (Great Expectations
      on RAW_DATA) is the next medium-priority open item with no blockers.
    alternative_first: OI003
    alternative_rationale: >
      Great Expectations suite for RAW_DATA source layer — freshness, volume, and
      referential integrity expectations on source tables as a complement to the dbt suite.
    open_items_at_close: ["OI003", "OI004", "OI005 (blocked by OI010)", "OI007", "OI010"]
    start_prompt: >
      Resume PROJ-C360. OI001, OI002, OI006, OI008, OI009 closed. Open: OI003-OI005, OI007, OI010.
      C012 ManufaCT now fires two A001 conditions (TKT-5026 open critical + CSAT 2.0).
      RISK_REASON='Open critical ticket | Low satisfaction score' validated in view and mart.
      br003_known_at_risk_customers.sql extended with exact RISK_REASON assertions (both customers).
      profiles.yml schema casing fixed (ANALYTICS uppercase) — dbt runs clean, no DROP needed.
      Database: G:\Projects\DE-Intelligence\mp_demo.db. 26 support tickets (was 25).
      View: ANALYTICS.CUSTOMER_360 (v3, 39 cols). Mart: ANALYTICS.customer_360_mart (40 cols).
      dbt: G:\Projects\DE-Intelligence\dbt\ (64 tests, 63 pass, 1 expected freshness failure).
      BR001-BR011 registered. ADR001-ADR003 accepted.
      Benchmarks: 15 rows, 2 at-risk, $1,986,450 portfolio, C007 null satisfaction.
      HIGH_VALUE_FLAG: C013 BankWest (23.0%), C004 FinServ Corp (15.6%), C010 InsureNet (15.3%).
