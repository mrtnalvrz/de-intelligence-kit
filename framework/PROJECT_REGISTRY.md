# PROJECT_REGISTRY.md — Data Engineering Assistant
## Modern Prometheus | Session-Persistent Project Memory

---

## Registry Format

Each project entry is a self-contained block. Copy the template for each new project.
Update in-place as projects evolve. The registry is the source of truth between sessions.

---

## Template

```yaml
project:
  id: PROJ-XXX
  name: "[Human-readable project name]"
  status: active | paused | complete | blocked
  created: YYYY-MM-DD
  last_updated: YYYY-MM-DD

  description: >
    [One paragraph: what this project does and why it exists.
    Written so both an engineer and an executive can orient quickly.]

  stakeholders:
    business_owner: "[Name / Team]"
    technical_lead: "[Name]"
    consumers: ["[Team or system that uses this data]"]

  data_sources:
    - name: "[Source system name]"
      type: "database | api | file | event_stream | saas"
      connector: "[Fivetran / Airbyte / custom / etc.]"
      ingestion_pattern: "full_refresh | incremental | cdc"
      freshness_sla: "[e.g., every 6 hours]"
      pii_present: true | false
      notes: "[anything unusual]"

  schema_contracts:
    - table: "[schema.table_name]"
      version: "v1"
      owner: "[team]"
      breaking_change_approval_required: true | false
      last_reviewed: YYYY-MM-DD
      downstream_consumers:
        - "[report / dashboard / API / model name]"

  dbt_models:
    staging:
      - model: "stg_[source]__[entity]"
        materialization: view
        tests_passing: true | false
        business_rule_ids: []
    intermediate:
      - model: "int_[domain]__[transformation]"
        materialization: table | incremental
        tests_passing: true | false
        business_rule_ids: []
    marts:
      - model: "fct_[entity] | dim_[entity] | mart_[team]__[subject]"
        materialization: table
        tests_passing: true | false
        business_rule_ids: []

  quality_gates:
    ge_suite: "[project].[dataset].[layer].expectations"
    gate_placement: "[where in the DAG quality is enforced]"
    failure_behavior: "block | alert | log"
    last_run_status: passing | failing | unknown
    sla_freshness: "[max acceptable staleness]"

  business_rules:
    - rule_id: BR001
      statement: "[Exact business rule as stated by the business owner]"
      source: "[Who stated it / which document]"
      captured: YYYY-MM-DD
      implemented_in: "[model name or TBD]"
      conflicts_with: NONE | [rule_id]

  architecture_decisions:
    - decision_id: ADR001
      date: YYYY-MM-DD
      decision: "[What was decided]"
      rationale_engineering: "[Technical reasoning]"
      rationale_business: "[Business reasoning in plain language]"
      alternatives_considered: "[What else was evaluated]"
      made_by: "[Who made the call]"

  lineage:
    critical_paths:
      - path: "[source] → [staging] → [intermediate] → [mart] → [consumer]"
        risk_level: high | medium | low
        notes: "[any fragility or known issues]"
    gaps:
      - column: "[column name]"
        table: "[table name]"
        status: unresolved | under_investigation | resolved
        notes: "[context]"

  open_items:
    - id: OI001
      priority: high | medium | low
      description: "[What needs to be done]"
      owner: "[Who / TBD]"
      blocked_by: "[dependency or NONE]"

  cross_project_dependencies:
    - depends_on_project: "[project name]"
      dependency_type: "shares_source | consumes_model | shares_business_rule"
      notes: "[specifics]"

  session_log:
    - date: YYYY-MM-DD
      summary: "[What was done this session]"
      rules_captured: []
      decisions_made: []
      next_session_start: "[recommended first action]"
```

---

## Example: Populated Project Entry

```yaml
project:
  id: PROJ-001
  name: "Revenue Analytics Pipeline"
  status: active
  created: 2025-06-01
  last_updated: 2025-06-02

  description: >
    End-to-end pipeline from Salesforce CRM and Stripe billing into a unified
    revenue mart. Powers the CFO dashboard and quarterly board reporting.
    This is mission-critical — any data quality failure here reaches the board.

  stakeholders:
    business_owner: "CFO / Finance Team"
    technical_lead: "Martin"
    consumers: ["CFO Dashboard", "Board Reporting Package", "FP&A Models"]

  data_sources:
    - name: "Salesforce"
      type: saas
      connector: Fivetran
      ingestion_pattern: incremental
      freshness_sla: "every 4 hours"
      pii_present: true
      notes: "Opportunity stage history is critical — don't drop historical records"

    - name: "Stripe"
      type: api
      connector: Fivetran
      ingestion_pattern: incremental
      freshness_sla: "every 1 hour"
      pii_present: true
      notes: "Stripe events can arrive out of order — idempotency required"

  schema_contracts:
    - table: "revenue.fct_recognized_revenue"
      version: "v2"
      owner: "Finance Team"
      breaking_change_approval_required: true
      last_reviewed: 2025-05-15
      downstream_consumers:
        - "CFO Dashboard (Looker)"
        - "Board Pack (Google Slides automation)"
        - "int_finance__arr_waterfall"

  dbt_models:
    staging:
      - model: "stg_salesforce__opportunities"
        materialization: view
        tests_passing: true
        business_rule_ids: [BR001, BR002]
      - model: "stg_stripe__charges"
        materialization: view
        tests_passing: true
        business_rule_ids: [BR003]
    intermediate:
      - model: "int_revenue__recognized_by_period"
        materialization: incremental
        tests_passing: true
        business_rule_ids: [BR001, BR004]
    marts:
      - model: "fct_recognized_revenue"
        materialization: table
        tests_passing: true
        business_rule_ids: [BR001, BR002, BR003, BR004]

  quality_gates:
    ge_suite: "revenue.recognized_revenue.mart.expectations"
    gate_placement: "Post-mart build, pre-dashboard refresh"
    failure_behavior: block
    last_run_status: passing
    sla_freshness: "Mart must be no older than 6 hours at 6am ET daily"

  business_rules:
    - rule_id: BR001
      statement: >
        Revenue is recognized in the period the contract starts, not when
        it is invoiced. A deal closed in June with a July 1 start date
        counts as July revenue.
      source: "CFO (verbal, confirmed in Slack thread 2025-05-20)"
      captured: 2025-05-20
      implemented_in: "int_revenue__recognized_by_period"
      conflicts_with: NONE

    - rule_id: BR002
      statement: >
        An opportunity is 'closed-won' only when both CRM stage = 'Closed Won'
        AND a corresponding Stripe charge exists. CRM alone is insufficient.
      source: "VP Revenue Operations, 2025-05-22"
      captured: 2025-05-22
      implemented_in: "stg_salesforce__opportunities (join validation)"
      conflicts_with: NONE

    - rule_id: BR003
      statement: >
        Stripe refunds within 30 days of charge reduce the original period's
        revenue. Refunds after 30 days are recorded as a separate negative
        line item in the refund period.
      source: "Finance Policy Doc v3.2"
      captured: 2025-05-25
      implemented_in: "stg_stripe__charges"
      conflicts_with: NONE

    - rule_id: BR004
      statement: >
        ARR is calculated as MRR × 12. MRR is the sum of all active
        subscription charges in a calendar month, excluding one-time fees.
      source: "CFO Dashboard spec, 2025-04-01"
      captured: 2025-04-01
      implemented_in: "int_finance__arr_waterfall"
      conflicts_with: NONE

  architecture_decisions:
    - decision_id: ADR001
      date: 2025-05-20
      decision: "Use incremental materialization for recognized revenue intermediate model"
      rationale_engineering: >
        Historical revenue periods are immutable. Incremental with
        unique_key on (opportunity_id, period_month) prevents full scans
        of 3+ years of history on every run.
      rationale_business: >
        Reduces dashboard refresh time from ~45 minutes to ~4 minutes.
        The CFO does not want to wait 45 minutes to see yesterday's numbers.
      alternatives_considered: "Table materialization (too slow), View (no tests possible)"
      made_by: "Martin"

  lineage:
    critical_paths:
      - path: "Salesforce → stg_salesforce__opportunities → int_revenue__recognized_by_period → fct_recognized_revenue → CFO Dashboard"
        risk_level: high
        notes: "Any break here fails the board pack. Alert immediately."
      - path: "Stripe → stg_stripe__charges → int_revenue__recognized_by_period → fct_recognized_revenue"
        risk_level: high
        notes: "Stripe out-of-order events handled by deduplication in staging"
    gaps:
      - column: "opportunity.original_created_by"
        table: "stg_salesforce__opportunities"
        status: unresolved
        notes: "Salesforce API does not expose this reliably. Flagged for governance review."

  open_items:
    - id: OI001
      priority: high
      description: "Add column-level PII masking for Stripe customer email in staging"
      owner: "Martin"
      blocked_by: NONE

    - id: OI002
      priority: medium
      description: "Define Great Expectations suite for Stripe charges staging model"
      owner: TBD
      blocked_by: NONE

  cross_project_dependencies:
    - depends_on_project: "Customer Data Platform"
      dependency_type: "shares_source"
      notes: "Both projects read from Salesforce via the same Fivetran connector. Schema changes in Salesforce affect both."

  session_log:
    - date: 2025-06-01
      summary: "Initial project setup. Captured BR001-BR004. Designed pipeline topology. Created ADR001."
      rules_captured: [BR001, BR002, BR003, BR004]
      decisions_made: [ADR001]
      next_session_start: "Review Stripe staging model and scaffold Great Expectations suite (OI002)"
```
---

## Process Notes (Cross-Effort)

Lessons about HOW sessions operate across all efforts under this 
framework — not project-specific facts (those belong in each 
effort's own registry). Log here when a session reveals something 
about process, tooling, or operating discipline that future sessions 
— in any effort — should know.

```yaml
process_notes:
  - note_id: PN001
    date: 2026-06-13
    title: "Parallel sessions against a shared live database"
    statement: >
      Running parallel chats/sessions that can execute changes 
      (not just plan) against the same live database risks 
      redundant or conflicting work. No actual conflict occurred 
      in the incident that surfaced this (one session completed 
      before the other executed anything), but it was a near-miss.
    mitigation: >
      Before starting a session that will execute changes, check 
      the relevant project registry for an active_session marker. 
      Set one at session start (chat name + timestamp), clear it 
      at session close.
    source: "Martin Alvarez — Demo 3 parallel-session incident, PROJ-C360"
    applies_to: "All efforts under Data Engineering Intelligence"
    status: >
      Adopted and validated — first real use in Demo 4 (2026-06-16, PROJ-C360).
      Marker written at session open, cleared at close. No parallel-session
      conflict, audit trail preserved in the registry, no revision needed
      to the convention itself.

  - note_id: PF-DEMO4-01
    date: 2026-06-16
    title: "Inline-composition bug in load-bearing edits"
    statement: >
      Composing edit replacement text from memory/inline within a tool
      call — rather than sourcing it from an already-verified file or
      scratch file — can silently reintroduce previously-fixed logic
      errors, even immediately after the correct version was shown and
      confirmed. Occurred identically twice in Demo 4 on the same
      test-file edit (PROJ-C360, OI008 work).
    mitigation: >
      Enforce scratch-file-first discipline for any edit where logic or
      exact-string matching is load-bearing: test assertions, registry
      YAML, SQL WHERE clauses, and similar. Write intended content to a
      scratch file, read it back to verify, then copy verbatim to the
      real target — never retype or recompose inline. This applies
      regardless of edit size; the original near-miss was on a small,
      not large, edit.
    source: "Demo 4 session, PROJ-C360, 2026-06-16"
    applies_to: "All efforts under Data Engineering Intelligence"
    related: >
      Distinct from PF-DEMO3-01/02 (display truncation / content
      duplication during registry edits) though related in spirit —
      all three are verification-discipline findings about not trusting
      freshly-composed or freshly-displayed content without a read-back
      step against a known-good source.
    status: "Logged — scratch-file-first discipline now a standing recommendation"

  - note_id: PN002
    date: 2026-06-16
    title: "projects/demoN/ continuity-bridge convention has no enforcement check"
    statement: >
      The projects/demoN/ folder convention (a primer + session log per
      demo session, mirroring projects/demo2/ and projects/demo3/) was
      followed for Demo 2 and Demo 3 but silently skipped for Demo 4 —
      no projects/demo4/ folder was created at session-close time. The
      gap was not caught by the session itself, the close-out summary,
      or the master roadmap chat's review of that summary; it surfaced
      only when starting Demo 5 and noticing the folder was missing.
    mitigation: >
      No automated enforcement exists for this convention — it depends
      entirely on the session (or its primer's close-out checklist)
      remembering to create the folder. Recommend each future session
      primer's "session close" instructions explicitly include
      "create/update projects/demoN/ with this session's primer copy
      and a session log" as its own numbered step, not just an implicit
      assumption carried over from prior demos. The master roadmap chat
      should also spot-check for the folder's existence when a session
      reports its close-out summary, rather than only checking registry
      and dashboard content.
    source: "Martin Alvarez — noticed while starting Demo 5, PROJ-C360"
    applies_to: "All efforts under Data Engineering Intelligence that adopt the projects/demoN/ pattern"
    status: "Logged — projects/demo4/ backfilled retroactively (DEMO4_SESSION_LOG.yaml + primer copy); convention not yet given an enforcement mechanism"
```

---

## Multi-Project Status Dashboard

Use this section to track all active projects at a glance.

> **Caveat:** Each row below is a point-in-time snapshot, not a live-synced
> summary. The authoritative source for any project's current state is its
> own registry (e.g., `projects/c360/DEMO_REGISTRY.md` for PROJ-C360) —
> this table will drift as soon as that registry changes and is not
> guaranteed to be current. Updating the relevant row here is a recommended
> (not mandatory) step in each session's close-out, alongside that
> project's own registry update.

```markdown
| ID       | Project Name                  | Status   | Last Updated | Critical Open Items |
|----------|-------------------------------|----------|--------------|---------------------|
| PROJ-001 | Revenue Analytics Pipeline    | active   | 2025-06-02   | OI001 (PII masking) |
| PROJ-C360| Customer 360 — Source-to-Target Mapping (DE-Intelligence-Kit) | active | 2026-06-16 | OI010 (HIGH — ETL must set LOADED_AT on UPDATE; blocks OI001 true-incremental and OI005 migration). OI008 closed Demo 4. |
```

---

*PROJECT_REGISTRY.md — Modern Prometheus Data Engineering Deployment*
*The persistent memory layer. Update this every session. It outlives the context window.*
