# MASTER ROADMAP — Data Engineering Intelligence (Umbrella)

## Genesis-Scale Personal Intelligence | Three-Effort Map

*Maintained by: Martin Alvarez | Last updated: 2026-06-14*

---

## 0\. Purpose of This Document

This is a **thin, top-level roadmap** sitting above three active efforts. It does not duplicate any effort's detailed registry or session logs. Its job is to answer three questions:

1. How do the three efforts relate to each other and to the long-term vision?  
2. What's shared across efforts vs. effort-specific?  
3. What are the genuine cross-effort dependencies — and what isn't one?

Each effort keeps its own source-of-truth registry. This document points to those registries rather than absorbing them.

---

## 1\. The Long-Term Vision

A Genesis.AI-like platform: eventually, something other users could use to solve data engineering problems via AI agents, end-to-end — schema discovery, mapping, transformation, testing, deployment, and governance documentation, with minimal human relay.

**Near-term goal (today):** personal tooling for Martin's own analysis and POC work, centered on Fivetran (EL) and dbt (T) — i.e., a realistic, governed pipeline stack Martin can use and extend, not a product to ship.

The three efforts below represent three different *angles of attack* on that vision, run roughly in parallel over the same Customer 360 dataset shape (CRM/ERP/Support, mismatched join keys, at-risk logic) — which makes them comparable without being the same project.

---

## 2\. The Three Efforts at a Glance

|  | Effort 1 — DE-Intelligence-Kit | Effort 2 — Fivetran Demo | Effort 3 — Genesis.AI Demo |
| :---- | :---- | :---- | :---- |
| **Role in the vision** | The governance framework / chassis | The real-data POC environment | The platform-vision prototype |
| **What it proves** | A *governed Claude assistant* (Modern Prometheus framework) can do production-grade DE work with session-persistent memory, dual-language output, and escalation discipline | A real EL/CDC pipeline (Fivetran) feeding real warehouses (Snowflake, Databricks) and an open lake (S3 Iceberg) — the actual "near-term goal" stack | What a *fully autonomous* agentic DE platform (Genesis/Eve) looks like when given AWS-native infrastructure (Redshift \+ Bedrock) |
| **Data** | DuckDB, seeded CSV-equivalent (same C360 shape: CRM/ERP/Support, 15/30/25 rows) | RDS Aurora PostgreSQL, live WAL-based CDC, real `customers`/`orders`/`products` schema | Redshift Serverless, same seeded C360 dataset (15/30/25 rows) loaded via S3 |
| **AI operating model** | Claude in claude.ai chat (Demo 1, human relay) → Claude Code \+ MCP (Demo 2/3, autonomous) | Human-operated (Martin as SE, demoing Fivetran's own product — no AI agent in the loop) | Genesis agent "Eve" on Amazon Bedrock (Claude 4.5 Sonnet), fully autonomous Blueprint execution |
| **Governance model** | Modern Prometheus (CLAUDE.md, AGENTS.md, DEMO\_REGISTRY.md, escalation flags, dual-language) | None — this is a vendor capability demo (Fivetran SE interview prep), not a governed agent project | Genesis's own Blueprint/Mission/phase structure — no Modern Prometheus governance layer |
| **Primary artifact** | `ANALYTICS.CUSTOMER_360` / `CUSTOMER_360_MART` in DuckDB, 39 cols, dbt-tested (64 tests) | Live Fivetran connectors \+ dbt models on Snowflake/Databricks/S3 | `analytics.customer_360` in Redshift, 38 cols, deployed in one continuous session |
| **Status as of 2026-06-13/14** | Demo 1–3 complete. OI009 (ETL watermarks) and OI006 (HIGH\_VALUE\_FLAG/BR011) closed. OI010 open (HIGH). | Demo built and rehearsed for Fivetran SE interview (May 11–13, 2026); lessons-learned and final demo script complete | AWS evaluation complete (May 1, 2026): 9/9 phases, 38/38 fields, 100% confidence, production-deployed |
| **Registry / source of truth** | `DEMO_REGISTRY.md` (PROJ-C360) — **not duplicated here** | No formal registry — `Fivetran_LessonsLearned_May2026.docx` \+ `Fivetran_DemoScript_Final_May13.docx` serve as the working record | No formal registry — `Genesis_AWS_Final_Report_May2026.docx` \+ `Genesis_AWS_Demo_Report_May2026.docx` \+ lab exercises serve as the working record |

---

## 3\. Effort 1 — DE-Intelligence-Kit (Modern Prometheus / PROJ-C360)

**What it is:** A governance framework (CLAUDE.md behavioral constitution, AGENTS.md seven-agent roster, DEMO\_REGISTRY.md persistent memory, DEPLOYMENT\_CHECKLIST.md) deployed against a Customer 360 demo dataset in DuckDB. The framework is domain-agnostic; the C360 demo is the proving ground.

**Trajectory so far:**

- **Demo 1** (human relay): 9-phase Source-to-Target Mapping, BR001–BR008 registered, ADR001–002, 38-field view, 2 at-risk customers (C013 BankWest, C012 ManufaCT).  
- **Demo 2** (autonomous via Claude Code \+ MCP): introspection, 36-test dbt suite, BR006 revision (documentation/implementation drift caught), `CUSTOMER_360_MART` materialized (ADR003), OI009 opened (no ETL watermarks).  
- **Demo 3** (current baseline, 2026-06-13): OI009 **closed** (`LOADED_AT` columns added to all 3 RAW\_DATA tables via approved ALTER TABLE, zero NULLs across 70 rows); OI006 **closed** via BR011 (`HIGH_VALUE_FLAG`, \>15% portfolio threshold) — view v3, 39 cols, mart 40 cols, 64/64 tests passing, **3 customers flagged** (C013 BankWest 23.0%, C004 FinServ Corp 15.6%, C010 InsureNet 15.3% \= 54.9% of portfolio). OI010 **opened** (HIGH, OPEN): ETL must set `LOADED_AT` on UPDATE not just INSERT — external coordination item, now the binding constraint on OI005 (multi-platform migration). Two platform-portability findings logged against OI005 (backfill divergence: DuckDB/Oracle/Snowflake vs. Redshift/Aurora; identifier case-folding divergence: DuckDB/Redshift/Postgres lowercase vs. Snowflake/Oracle uppercase).

**Current open items:** OI003 (Great Expectations), OI004 (SCD Type 2), OI005 (multi-platform, blocked by OI010), OI007 (BI filter guidance), OI008 (multi-condition at-risk test case — recommended next), OI010 (ETL coordination, HIGH).

**This is the chassis.** Its value is the *governance pattern* (registry-first memory, dual-language output, escalation discipline, write-then-read-back verification) — proven to transfer across tooling boundaries (claude.ai chat ↔ Claude Code terminal) and now, per the conversation that produced this roadmap, intended to scale across *effort* boundaries too (this master roadmap chat is itself a Modern-Prometheus-flavored artifact sitting above PROJ-C360's registry).

**Registry pointer:** `DEMO_REGISTRY.md` (PROJ-C360) is the authoritative, session-persistent source of truth for this effort. This roadmap does not restate its business rules, architecture decisions, or open items beyond the summary above — consult the registry directly.

---

## 4\. Effort 2 — Fivetran Demo (Aurora PostgreSQL → Snowflake / Databricks / S3 Iceberg)

**What it is:** A real, live EL (Extract-Load) pipeline built for a Fivetran Solutions Engineer interview process (May 11–13, 2026). Source is Amazon RDS Aurora PostgreSQL with a Customer 360-shaped dataset (`customers`, `orders`, `products` — same conceptual entity as Effort 1's CRM/ERP/Support, but a different concrete schema). Fivetran replicates via WAL-based CDC to three destinations simultaneously: Snowflake, Databricks, and S3 (Iceberg format).

**What it demonstrates:**

- WAL-based CDC with zero source-database impact, three independent replication slots (one per destination) off a shared publication.  
- Schema drift propagation (an `ALTER TABLE ... ADD COLUMN sales_region` propagates to Snowflake and Databricks within \~18 seconds, no manual DDL).  
- dbt staging/marts models on top of raw Fivetran tables (filtering `_fivetran_deleted`, renaming, casting — the medallion pattern).  
- Multi-cloud/multi-destination architecture and the "no vendor lock-in" story via S3 Iceberg.  
- A substantial lessons-learned corpus: Lake Formation as a silent Glue-access blocker, Athena v2/v3 DDL incompatibilities, replication-slot database-context bugs, Databricks trial-expiry recovery (self-healing CDC, zero data loss).

**Relationship to the vision:** This is the **real-data POC environment** — it's the actual EL/dbt stack named in the near-term goal ("personal tooling... centered on Fivetran (EL) and dbt (T)"). Unlike Effort 1 (DuckDB, seeded data, AI-governed) and Effort 3 (Redshift, AI-autonomous), Effort 2 has **no AI agent in the loop at all** — it's Martin operating Fivetran's UI directly, with dbt Cloud doing transformation. It is the most "production-realistic" of the three in terms of infrastructure (live CDC, real cloud warehouses, real IAM/networking complexity) but the least automated.

**Source of truth:** No formal registry exists for this effort (it was built for an interview, not as an ongoing project). `Fivetran_LessonsLearned_May2026.docx` and `Fivetran_DemoScript_Final_May13.docx` are the working record. If this effort continues as personal tooling, it would benefit from its own lightweight registry — see Section 6\.

---

## 5\. Effort 3 — Genesis.AI Demo (Redshift Serverless \+ Amazon Bedrock)

**What it is:** An evaluation of Genesis Computing's autonomous agent platform ("Eve") running the same Source-to-Target Mapping Blueprint as Effort 1's Demo 1, but against Redshift Serverless, powered by Amazon Bedrock (Claude 4.5 Sonnet via IAM role, no API keys), using the *same seeded Customer 360 dataset* (15 CRM / 30 ERP / 25 Support rows, same mismatched-key challenge: `CUSTOMER_ID` / `CUST_ID` / `CUSTOMER_REF`).

**What it demonstrates:**

- A **fully autonomous** 9-phase mission: schema discovery → mapping → at-risk logic → deployment, completed in a single continuous session with **zero business questions** and **100% mapping confidence** (38/38 fields, 0 critical gaps).  
- Only one human-in-the-loop moment: approval of the at-risk threshold logic (A001) — the same logical content as Effort 1's A001, independently arrived at.  
- Bedrock-vs-direct-API as an enterprise deployment question: IAM-role auth, VPC-private traffic, CloudTrail audit, no Anthropic rate-limit interruptions (vs. multiple interruptions on a prior Snowflake/direct-API attempt that never completed Phase 0).  
- A context-window-exceeded interruption at Phase 4 (29 tool calls in Phase 3 alone) — resolved by starting a new thread, not a logic failure.  
- Output: `analytics.customer_360` deployed to Redshift, 15 rows, 38 fields, 2 at-risk customers (C013 BankWest $457,650/23% of portfolio with an open critical ticket; C012 ManufaCT, CSAT 2.0) — **the same two at-risk customers Effort 1 identified independently**, via a completely different agent/platform/database.

**Relationship to the vision:** This is the **platform-vision prototype** — the closest existing analog to "a Genesis.AI-like platform... that other users could use." It shows what full autonomy looks like *without* the Modern Prometheus governance layer: no persistent cross-session registry (state lives in a Git repo per mission, not a registry file), no explicit dual-language mandate (though Eve's output happens to be business-readable), and no formal escalation-flag taxonomy beyond "ask when a business threshold is needed."

**Source of truth:** No formal registry. `Genesis_AWS_Final_Report_May2026.docx` (production outcome), `Genesis_AWS_Demo_Report_May2026.docx` (evaluation detail, including the Phase 4 context-window interruption), `Genesis_Laymans_Guide_Data_Engineers.docx` (conceptual walkthrough), and `Genesis_Lab_Exercises_AWS_Edition.docx` (lab/workshop structure) are the working record.

---

## 6\. What's Shared vs. Effort-Specific

### Shared across all three (conceptually, not as files)

- **The Customer 360 problem shape**: three sources, mismatched join keys (`CUSTOMER_ID`/`CUST_ID`/`CUSTOMER_REF` in Efforts 1 & 3; `id`/`customer_id`/`product_id` in Effort 2's PostgreSQL schema), at-risk-customer identification as the payoff.  
- **At-risk logic convergence**: Effort 1 and Effort 3, run independently on the same seed data, arrived at the *same two at-risk customers* (BankWest, ManufaCT) via the *same threshold logic shape* (open critical ticket OR excess open tickets OR low CSAT). This is a useful cross-effort validation point, not a dependency.  
- **The CLAUDE.md / AGENTS.md framing**: per the Option C structural decision, these shared framework files apply *conceptually* across efforts, but only Effort 1 currently has them instantiated as actual governing files. Efforts 2 and 3 don't use them (Effort 2 has no agent; Effort 3 uses Genesis's own Blueprint framework instead).  
- **Documentation convention (canonical vs. companion)**: Effort 1 has established a two-document pattern — a plain-text, version-controlled `README.md` updated every session (canonical, wins on conflict) and a periodically-refreshed `.docx` companion for presentation/learning purposes (re-flowed from the README, not required to stay in lockstep). See Section 10 for the full policy. If Efforts 2 or 3 ever produce both a working-record document and a presentation deck/doc, this same canonical/companion split is the recommended pattern — though adoption there is not yet decided (see Section 11).  
- **Per-demo continuity-bridge folders (`projects/demoN/`)**: Effort 1 has, since Demo 2, created a `projects/demoN/` folder for each demo session — containing a `DEMON_SESSION_PRIMER.md` (paste-ready constitution \+ prior-state context \+ session-specific instructions) and a structured session log. This is distinct from both `README.md` (narrative, cumulative) and `DEMO_REGISTRY.md` (living registry state): the `projects/demoN/` folders are point-in-time, per-session snapshots used to bootstrap a fresh Claude Code session with full context. Demo 3 extended this convention (commit `ff5297e`, `projects/demo3/`). If Efforts 2 or 3 ever run multi-session work with the same "fresh session needs full context" problem, this three-tier pattern (narrative / living registry / per-session bootstrap snapshot) is the template — not yet adopted there.

### Dashboard caveat (Multi-Project Status Dashboard, `framework/PROJECT_REGISTRY.md`)

The Multi-Project Status Dashboard's PROJ-C360 row (status, last-updated date, critical open item) is a **point-in-time snapshot**, not a live-synced summary. It will drift the moment any per-effort registry changes (e.g., Demo 4 closing OI008 changes both the "last updated" date and the "critical open item" string). It is **not** a second source of truth for PROJ-C360 — `projects/c360/DEMO_REGISTRY.md` remains authoritative, and the dashboard row should be treated as informational/best-effort. Updating this row is a recommended (not mandatory) step in each Demo-N session's close-out, alongside `DEMO_REGISTRY.md` itself.

### Effort-specific (lives in each effort's own space)

- Effort 1: `DEMO_REGISTRY.md`, dbt project (`projects/c360/dbt/`), session primers — all PROJ-C360-specific, **not duplicated here**.  
- Effort 2: Fivetran connector configs, replication slots, dbt Cloud project (`fivetran_fundamentals`), the lessons-learned and demo-script docs.  
- Effort 3: Genesis Git repository (`customer-360---source-to-target-mapping`), CloudFormation stack (`genesis-ec2-stack.yaml`), Bedrock model configuration.

---

## 7\. Genuine Cross-Effort Dependencies (and Non-Dependencies)

It's tempting to over-connect three projects that share a dataset shape. Most apparent connections are **parallels** (useful for comparison) rather than **dependencies** (one blocks or feeds the other). This section is deliberately conservative.

### Genuine dependencies

- **None currently block each other.** Effort 1's OI010 (ETL must set `LOADED_AT` on UPDATE) is an *external ETL-pipeline-owner* coordination item — it doesn't depend on or block Effort 2 or 3\.  
- **Effort 1 → Effort 2/3 (potential, not yet acted on):** Effort 1's two Demo 3 platform-portability findings (ALTER TABLE backfill divergence between DuckDB/Snowflake/Oracle vs. Redshift/Aurora-Postgres; identifier case-folding divergence) are directly relevant *if* Effort 1's OI005 (multi-platform migration to Redshift/Databricks) is ever pursued — and Effort 3 already runs on Redshift, Effort 2 already runs on Aurora Postgres \+ Databricks. If OI005 work resumes, the Demo 3 findings should be checked against what Efforts 2/3 actually observed on those platforms (neither currently documents an `ALTER ... ADD COLUMN ... DEFAULT` backfill test, so this isn't yet a confirmed cross-check — just a candidate one).

### Non-dependencies (explicitly called out to prevent false linkage)

- Effort 2's dbt models and Effort 1's dbt suite are **separate dbt projects** on separate data, despite both being "dbt on a Customer 360-shaped dataset." No shared models, no shared registry.  
- Effort 3's Genesis/Eve has no relationship to Effort 1's Claude-Code-based agent beyond "both are Claude 4.5/4.6 under the hood." Different harness, different governance (or lack thereof), different state-persistence model.  
- The at-risk-customer convergence (Section 6\) is a validation curiosity, not a technical dependency — neither effort reads the other's output.

---

## 8\. Cross-Effort Process Notes

This section tracks operational/process lessons that apply across efforts — distinct from the technical findings in Section 7\. The first entry comes from Effort 1 but is logged here because the underlying risk (concurrent sessions acting on shared live infrastructure) applies to all three efforts as they scale.

### PN001 — Parallel Session Near-Miss (logged 2026-06-13, Effort 1\)

**What happened:** A claude.ai chat session ("Demo 3 — OI009") was independently planning the same OI009 work (ETL watermark columns) that a parallel Claude Code session completed first — OI009 and OI006/BR011 both closed, OI010 opened, dbt suite grown to 64 tests, all in the same working session. No actual conflict occurred (the faster session's changes simply became the new state, and the slower session's drafted `ALTER TABLE` statements were never executed), but the duplication of planning effort was avoidable.

**Resolution:** The "Demo 3 — OI009" chat is closed — its purpose was completed elsewhere. Logged as PN001 in `framework/PROJECT_REGISTRY.md`, in a new "Process Notes (Cross-Effort)" section (placed between the Example Project Entry and the Multi-Project Status Dashboard).

**Recommendation (not yet adopted):** An `active_session` marker convention — chat name \+ timestamp, set at session start and cleared at close — for any session that will **execute** changes against a shared live database. This is a soft convention, not enforced tooling.

**Why this is cross-effort:** Right now, only Effort 1 (PROJ-C360 / DuckDB) has multiple concurrent AI-driven sessions touching the same database. But Effort 2 (Fivetran/Aurora) and Effort 3 (Genesis/Redshift) both involve live cloud infrastructure that could, in principle, be touched by more than one session or tool (e.g., a Claude Code session and a Genesis Eve mission both pointed at the same Redshift cluster). PN001's `active_session` convention — if adopted — would apply identically: any session about to run DDL/DML against shared infrastructure announces itself, any session that finds another active session for the same target treats it as a signal to check in before proceeding.

**Status:** Awareness-level only. No formal adoption across any effort yet. Revisit if/when Efforts 2 or 3 become active again with multiple-session usage patterns.

---

## 9\. What Belongs Where, Going Forward

**This chat / this roadmap document:**

- Maintains this top-level map.  
- Hosts cross-effort comparisons and any future cross-effort findings (e.g., if OI005 work surfaces a Redshift/Databricks finding that should be checked against Effort 1's portability notes, that synthesis happens here).  
- Is the place to decide *whether* a new effort or major pivot warrants its own project space.

**Future Demo-N sessions for PROJ-C360 (Effort 1):**

- Continue in **PROJ-C360's own space**, using `DEMO_REGISTRY.md` as the working memory, per the existing Modern Prometheus pattern (session primers, Claude Code continuity bridge, etc.).  
- This roadmap is referenced *for cross-effort context only* (e.g., "is this schema-portability question relevant to Effort 2/3?") — not for PROJ-C360's own business rules, ADRs, or open items, which remain in `DEMO_REGISTRY.md`.

**Effort 2 (Fivetran) and Effort 3 (Genesis):**

- Both currently lack a formal registry. If either becomes ongoing personal tooling (rather than a completed interview/eval artifact), it should get its own lightweight registry file (even a simple `*_REGISTRY.md` following the BR/ADR/OI pattern from Effort 1, without adopting the full Modern Prometheus agent roster unless useful). That decision is **deferred** — not made by this roadmap — until one of those efforts becomes active again.  
- Until then, their `*_LessonsLearned*`, `*_DemoScript*`, and `*_Final_Report*` documents remain their working record, referenced from here.

---

## 10\. Documentation Policy (Effort 1 — registered 2026-06-14)

For Effort 1 (DE-Intelligence-Kit / PROJ-C360), the following documentation hierarchy is now in effect:

- **`README.md`** is the canonical, version-controlled source of truth — plain text, updated **every session**. If `README.md` and `DE-Intelligence-Kit-README.docx` ever conflict, **`README.md` wins**.  
- **`DE-Intelligence-Kit-README.docx`** is a companion presentation document — refreshed **periodically** (e.g., every 1–2 demos, not every session) by re-flowing `README.md`'s current content into its visual structure. It is not auto-generated and not required to stay in lockstep.  
- **`DEMO_REGISTRY.md`** remains the structured BR/ADR/OI/A-\#\#\# memory layer — `README.md` is the human-readable narrative companion at the whole-project level, summarizing what the registry tracks in detail without replacing it.  
- **Default action for future sessions:** update `README.md`. The docx is optional/periodic.

This policy is specific to Effort 1's documentation set. It is recorded here (the cross-effort roadmap) in addition to `README.md` itself, so that any future session — whether it starts from this roadmap or from PROJ-C360's own space — knows which file to update by default.

**Status (2026-06-14):** The immediate gap (`README.md` being Demo-1-only) has been closed — `README.md` was updated to cover Demo 2 and Demo 3, originally sourced from Sections 7–10 of a `DE-Intelligence-Kit-README_3.docx` uploaded to this chat, and includes this policy as its own Section 11\. **Reconciliation:** the Demo 3/Claude Code session independently produced its own updated docx (new Section 9 for Demo 3, renumbered Section 10\) as a local, uncommitted output — a second, divergent Demo 3 narrative. `README.md` has since been corrected to include a detail that session had and this one initially lacked (commit `ff5297e` / `projects/demo3/` continuity-bridge folder), making this `README.md` the single reconciled canonical version per the policy. The Demo 3 session's docx output should not be committed; any future docx refresh should be re-derived from this `README.md`. `README.md` is ready to replace the existing version in the repo and in Project Knowledge.

**Separate action — now confirmed:** This roadmap's Section 3 summary of Effort 1 reflects the Demo 3 baseline (OI009/OI006 closed, OI010 open, BR011/`HIGH_VALUE_FLAG`, 64/64 tests, two platform-portability findings). `DEMO_REGISTRY.md` (PROJ-C360's own registry) was confirmed on 2026-06-14 to already be current through Demo 3 — written directly by the Demo 3 session itself, including the full `oi009_etl_watermarks`, `oi006_high_value_flag`/`br011_high_value_flag`, `c010_insurenet_observation`, `side_effect_case_mismatch`, and `next_session` (recommending OI008) blocks. No append action was needed. `framework/PROJECT_REGISTRY.md`'s PN001 entry and the PROJ-C360 dashboard row (Section 8 / earlier this session) remain the only registry-side updates from this roadmap.

---

## 11\. Open Questions for Next Roadmap Review

- Does OI005 (Effort 1, multi-platform migration, currently blocked by OI010) ever get unblocked, and if so, do Effort 2 (Aurora/Databricks) or Effort 3 (Redshift) become the *target* platform for that migration — turning a non-dependency into a real one?  
- Is Effort 2 (Fivetran) going to continue as personal EL tooling per the near-term goal, or was it a one-time interview artifact? This determines whether it needs its own registry.  
- Is Effort 3 (Genesis) something Martin intends to keep evaluating, or was the AWS eval a closed chapter? If ongoing, does its Blueprint/Mission state ever need to interoperate with Modern Prometheus governance (e.g., could Genesis's Git-repo-per-mission output be *read into* a PROJ-C360-style registry)?

