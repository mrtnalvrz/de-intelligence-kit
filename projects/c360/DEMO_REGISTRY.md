# PROJECT\_REGISTRY — Customer 360 Demo

## Modern Prometheus DE Intelligence · PROJ-C360

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

  session_log:
    - date: 2026-06-05
      summary: >
        Pre-mission registry setup. Registered PROJ-C360. Pre-populated
        business rules BR001-BR005, assumption A001, decisions ADR001-ADR002
        based on Genesis demo design. Established expected validation targets.
      rules_captured: [BR001, BR002, BR003, BR004, BR005]
      assumptions_approved: [A001]
      decisions_made: [ADR001, ADR002]
      next_session_start: "Run full mission against live DuckDB seed"

    - date: 2026-06-07
      summary: >
        Full Customer 360 mission executed end-to-end across 8 phases.
        Seeded DuckDB with 15 CRM / 30 ERP / 25 support rows.
        Produced ANALYTICS.CUSTOMER_360 — 15 rows, 38 fields, 6 CTE groups.
        Two at-risk customers identified: C013 BankWest (open critical security
        ticket TKT-5007, $457,650 portfolio value, 23% of total) and C012
        ManufaCT (avg CSAT 2.0, chronic low satisfaction, $22,800).
        Two schema errors caught pre-execution via A-SCH-001.
        View corrected twice during mission: BR007 (delivered orders only for
        order details CTE) and BR008 (AVG fields rounded to 2dp).
        All validation checks passed on final view v2.
        Executive narrative produced for both at-risk customers.
      rules_captured: [BR001, BR002, BR003, BR004, BR005, BR006, BR007, BR008]
      assumptions_approved: [A001, A-SCH-001]
      decisions_made: [ADR001, ADR002]
      validation_results:
        total_rows: 15
        at_risk_count: 2
        portfolio_value_usd: 1986450.00
        null_satisfaction_count: 1
        view_version: v2
      open_items_logged: [OI001, OI002, OI003, OI004, OI005, OI006, OI007, OI008]
      next_session_start: "OI001 — define incremental refresh strategy, or OI002 — scaffold dbt test suite"
