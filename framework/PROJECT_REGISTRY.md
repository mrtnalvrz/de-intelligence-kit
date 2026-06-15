# PROJECT\_REGISTRY.md — Data Engineering Assistant

## Modern Prometheus | Session-Persistent Project Memory

---

## Registry Format

Each project entry is a self-contained block. Copy the template for each new project. Update in-place as projects evolve. The registry is the source of truth between sessions.

---

## Template

project:

  id: PROJ-XXX

  name: "\[Human-readable project name\]"

  status: active | paused | complete | blocked

  created: YYYY-MM-DD

  last\_updated: YYYY-MM-DD

  description: \>

    \[One paragraph: what this project does and why it exists.

    Written so both an engineer and an executive can orient quickly.\]

  stakeholders:

    business\_owner: "\[Name / Team\]"

    technical\_lead: "\[Name\]"

    consumers: \["\[Team or system that uses this data\]"\]

  data\_sources:

    \- name: "\[Source system name\]"

      type: "database | api | file | event\_stream | saas"

      connector: "\[Fivetran / Airbyte / custom / etc.\]"

      ingestion\_pattern: "full\_refresh | incremental | cdc"

      freshness\_sla: "\[e.g., every 6 hours\]"

      pii\_present: true | false

      notes: "\[anything unusual\]"

  schema\_contracts:

    \- table: "\[schema.table\_name\]"

      version: "v1"

      owner: "\[team\]"

      breaking\_change\_approval\_required: true | false

      last\_reviewed: YYYY-MM-DD

      downstream\_consumers:

        \- "\[report / dashboard / API / model name\]"

  dbt\_models:

    staging:

      \- model: "stg\_\[source\]\_\_\[entity\]"

        materialization: view

        tests\_passing: true | false

        business\_rule\_ids: \[\]

    intermediate:

      \- model: "int\_\[domain\]\_\_\[transformation\]"

        materialization: table | incremental

        tests\_passing: true | false

        business\_rule\_ids: \[\]

    marts:

      \- model: "fct\_\[entity\] | dim\_\[entity\] | mart\_\[team\]\_\_\[subject\]"

        materialization: table

        tests\_passing: true | false

        business\_rule\_ids: \[\]

  quality\_gates:

    ge\_suite: "\[project\].\[dataset\].\[layer\].expectations"

    gate\_placement: "\[where in the DAG quality is enforced\]"

    failure\_behavior: "block | alert | log"

    last\_run\_status: passing | failing | unknown

    sla\_freshness: "\[max acceptable staleness\]"

  business\_rules:

    \- rule\_id: BR001

      statement: "\[Exact business rule as stated by the business owner\]"

      source: "\[Who stated it / which document\]"

      captured: YYYY-MM-DD

      implemented\_in: "\[model name or TBD\]"

      conflicts\_with: NONE | \[rule\_id\]

  architecture\_decisions:

    \- decision\_id: ADR001

      date: YYYY-MM-DD

      decision: "\[What was decided\]"

      rationale\_engineering: "\[Technical reasoning\]"

      rationale\_business: "\[Business reasoning in plain language\]"

      alternatives\_considered: "\[What else was evaluated\]"

      made\_by: "\[Who made the call\]"

  lineage:

    critical\_paths:

      \- path: "\[source\] → \[staging\] → \[intermediate\] → \[mart\] → \[consumer\]"

        risk\_level: high | medium | low

        notes: "\[any fragility or known issues\]"

    gaps:

      \- column: "\[column name\]"

        table: "\[table name\]"

        status: unresolved | under\_investigation | resolved

        notes: "\[context\]"

  open\_items:

    \- id: OI001

      priority: high | medium | low

      description: "\[What needs to be done\]"

      owner: "\[Who / TBD\]"

      blocked\_by: "\[dependency or NONE\]"

  cross\_project\_dependencies:

    \- depends\_on\_project: "\[project name\]"

      dependency\_type: "shares\_source | consumes\_model | shares\_business\_rule"

      notes: "\[specifics\]"

  session\_log:

    \- date: YYYY-MM-DD

      summary: "\[What was done this session\]"

      rules\_captured: \[\]

      decisions\_made: \[\]

      next\_session\_start: "\[recommended first action\]"

---

## Example: Populated Project Entry

project:

  id: PROJ-001

  name: "Revenue Analytics Pipeline"

  status: active

  created: 2025-06-01

  last\_updated: 2025-06-02

  description: \>

    End-to-end pipeline from Salesforce CRM and Stripe billing into a unified

    revenue mart. Powers the CFO dashboard and quarterly board reporting.

    This is mission-critical — any data quality failure here reaches the board.

  stakeholders:

    business\_owner: "CFO / Finance Team"

    technical\_lead: "Martin"

    consumers: \["CFO Dashboard", "Board Reporting Package", "FP\&A Models"\]

  data\_sources:

    \- name: "Salesforce"

      type: saas

      connector: Fivetran

      ingestion\_pattern: incremental

      freshness\_sla: "every 4 hours"

      pii\_present: true

      notes: "Opportunity stage history is critical — don't drop historical records"

    \- name: "Stripe"

      type: api

      connector: Fivetran

      ingestion\_pattern: incremental

      freshness\_sla: "every 1 hour"

      pii\_present: true

      notes: "Stripe events can arrive out of order — idempotency required"

  schema\_contracts:

    \- table: "revenue.fct\_recognized\_revenue"

      version: "v2"

      owner: "Finance Team"

      breaking\_change\_approval\_required: true

      last\_reviewed: 2025-05-15

      downstream\_consumers:

        \- "CFO Dashboard (Looker)"

        \- "Board Pack (Google Slides automation)"

        \- "int\_finance\_\_arr\_waterfall"

  dbt\_models:

    staging:

      \- model: "stg\_salesforce\_\_opportunities"

        materialization: view

        tests\_passing: true

        business\_rule\_ids: \[BR001, BR002\]

      \- model: "stg\_stripe\_\_charges"

        materialization: view

        tests\_passing: true

        business\_rule\_ids: \[BR003\]

    intermediate:

      \- model: "int\_revenue\_\_recognized\_by\_period"

        materialization: incremental

        tests\_passing: true

        business\_rule\_ids: \[BR001, BR004\]

    marts:

      \- model: "fct\_recognized\_revenue"

        materialization: table

        tests\_passing: true

        business\_rule\_ids: \[BR001, BR002, BR003, BR004\]

  quality\_gates:

    ge\_suite: "revenue.recognized\_revenue.mart.expectations"

    gate\_placement: "Post-mart build, pre-dashboard refresh"

    failure\_behavior: block

    last\_run\_status: passing

    sla\_freshness: "Mart must be no older than 6 hours at 6am ET daily"

  business\_rules:

    \- rule\_id: BR001

      statement: \>

        Revenue is recognized in the period the contract starts, not when

        it is invoiced. A deal closed in June with a July 1 start date

        counts as July revenue.

      source: "CFO (verbal, confirmed in Slack thread 2025-05-20)"

      captured: 2025-05-20

      implemented\_in: "int\_revenue\_\_recognized\_by\_period"

      conflicts\_with: NONE

    \- rule\_id: BR002

      statement: \>

        An opportunity is 'closed-won' only when both CRM stage \= 'Closed Won'

        AND a corresponding Stripe charge exists. CRM alone is insufficient.

      source: "VP Revenue Operations, 2025-05-22"

      captured: 2025-05-22

      implemented\_in: "stg\_salesforce\_\_opportunities (join validation)"

      conflicts\_with: NONE

    \- rule\_id: BR003

      statement: \>

        Stripe refunds within 30 days of charge reduce the original period's

        revenue. Refunds after 30 days are recorded as a separate negative

        line item in the refund period.

      source: "Finance Policy Doc v3.2"

      captured: 2025-05-25

      implemented\_in: "stg\_stripe\_\_charges"

      conflicts\_with: NONE

    \- rule\_id: BR004

      statement: \>

        ARR is calculated as MRR × 12\. MRR is the sum of all active

        subscription charges in a calendar month, excluding one-time fees.

      source: "CFO Dashboard spec, 2025-04-01"

      captured: 2025-04-01

      implemented\_in: "int\_finance\_\_arr\_waterfall"

      conflicts\_with: NONE

  architecture\_decisions:

    \- decision\_id: ADR001

      date: 2025-05-20

      decision: "Use incremental materialization for recognized revenue intermediate model"

      rationale\_engineering: \>

        Historical revenue periods are immutable. Incremental with

        unique\_key on (opportunity\_id, period\_month) prevents full scans

        of 3+ years of history on every run.

      rationale\_business: \>

        Reduces dashboard refresh time from \~45 minutes to \~4 minutes.

        The CFO does not want to wait 45 minutes to see yesterday's numbers.

      alternatives\_considered: "Table materialization (too slow), View (no tests possible)"

      made\_by: "Martin"

  lineage:

    critical\_paths:

      \- path: "Salesforce → stg\_salesforce\_\_opportunities → int\_revenue\_\_recognized\_by\_period → fct\_recognized\_revenue → CFO Dashboard"

        risk\_level: high

        notes: "Any break here fails the board pack. Alert immediately."

      \- path: "Stripe → stg\_stripe\_\_charges → int\_revenue\_\_recognized\_by\_period → fct\_recognized\_revenue"

        risk\_level: high

        notes: "Stripe out-of-order events handled by deduplication in staging"

    gaps:

      \- column: "opportunity.original\_created\_by"

        table: "stg\_salesforce\_\_opportunities"

        status: unresolved

        notes: "Salesforce API does not expose this reliably. Flagged for governance review."

  open\_items:

    \- id: OI001

      priority: high

      description: "Add column-level PII masking for Stripe customer email in staging"

      owner: "Martin"

      blocked\_by: NONE

    \- id: OI002

      priority: medium

      description: "Define Great Expectations suite for Stripe charges staging model"

      owner: TBD

      blocked\_by: NONE

  cross\_project\_dependencies:

    \- depends\_on\_project: "Customer Data Platform"

      dependency\_type: "shares\_source"

      notes: "Both projects read from Salesforce via the same Fivetran connector. Schema changes in Salesforce affect both."

  session\_log:

    \- date: 2025-06-01

      summary: "Initial project setup. Captured BR001-BR004. Designed pipeline topology. Created ADR001."

      rules\_captured: \[BR001, BR002, BR003, BR004\]

      decisions\_made: \[ADR001\]

      next\_session\_start: "Review Stripe staging model and scaffold Great Expectations suite (OI002)"

---

## Process Notes (Cross-Effort)

Lessons about HOW sessions operate across all efforts under this framework — not project-specific facts (those belong in each effort's own registry). Log here when a session reveals something about process, tooling, or operating discipline that future sessions — in any effort — should know.

process\_notes:

  \- note\_id: PN001

    date: 2026-06-13

    title: "Parallel sessions against a shared live database"

    statement: \>

      Running parallel chats/sessions that can execute changes 

      (not just plan) against the same live database risks 

      redundant or conflicting work. No actual conflict occurred 

      in the incident that surfaced this (one session completed 

      before the other executed anything), but it was a near-miss.

    mitigation: \>

      Before starting a session that will execute changes, check 

      the relevant project registry for an active\_session marker. 

      Set one at session start (chat name \+ timestamp), clear it 

      at session close.

    source: "Martin Alvarez — Demo 3 parallel-session incident, PROJ-C360"

    applies\_to: "All efforts under Data Engineering Intelligence"

    status: "Logged — active\_session convention not yet formally adopted"

---

## Multi-Project Status Dashboard

Use this section to track all active projects at a glance.

**Caveat:** Each row below is a point-in-time snapshot, not a live-synced summary. The authoritative source for any project's current state is its own registry (e.g., `projects/c360/DEMO_REGISTRY.md` for PROJ-C360) — this table will drift as soon as that registry changes and is not guaranteed to be current. Updating the relevant row here is a recommended (not mandatory) step in each session's close-out, alongside that project's own registry update.

| ID       | Project Name                  | Status   | Last Updated | Critical Open Items |

|----------|-------------------------------|----------|--------------|---------------------|

| PROJ-001 | Revenue Analytics Pipeline    | active   | 2025-06-02   | OI001 (PII masking) |

| PROJ-C360| Customer 360 — Source-to-Target Mapping (DE-Intelligence-Kit) | active | 2026-06-13 | OI010 (HIGH — ETL must set LOADED\_AT on UPDATE; blocks OI001 true-incremental and OI005 migration) |

---

*PROJECT\_REGISTRY.md — Modern Prometheus Data Engineering Deployment* *The persistent memory layer. Update this every session. It outlives the context window.*  
