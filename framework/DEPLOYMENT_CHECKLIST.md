# DEPLOYMENT_CHECKLIST.md — Modern Prometheus Data Engineering Assistant
## Genesis-Level Deployment | Starter Checklist

---

## How to Use This Checklist

Work through each phase in order. Each phase has a **Project Setup** track and an **Assistant Calibration** track running in parallel. Check boxes as you complete them. At the end of Phase 3, your assistant is fully operational.

The checklist is also a **conversation protocol** — each ✉️ item is something to say directly to your assistant to activate the corresponding capability.

---

## PHASE 1 — Foundation Setup
*Goal: Establish your operating environment and drop the core files*

### File Deployment
- [ ] Place `CLAUDE.md` in your project root (or Claude Project instructions)
- [ ] Place `AGENTS.md` alongside it
- [ ] Create `PROJECT_REGISTRY.md` in the same location
- [ ] (Optional) Create a `/projects/` folder for individual project YAML files

### Claude Project Configuration
- [ ] Create a dedicated Claude Project: **"Data Engineering Intelligence"**
- [ ] Paste the full contents of `CLAUDE.md` into the Project Instructions field
- [ ] Add `AGENTS.md` as a reference document in the project
- [ ] Add `PROJECT_REGISTRY.md` as a reference document in the project
- [ ] Upload any existing schema files, dbt `schema.yml` files, or data dictionaries

### First-Session Calibration
✉️ Say this to activate dual-language mode:
> "You are my Data Engineering Intelligence. Your operating instructions are in CLAUDE.md. Before we start any project work, confirm: you understand that every architecture decision requires both an engineering frame and a business frame, and that you will capture every business rule I state into the project registry."

- [ ] Confirm the assistant echoes back its dual-language commitment
- [ ] Confirm it acknowledges the project registry as persistent memory

---

## PHASE 2 — First Project Onboarding
*Goal: Register your first project and establish baseline memory*

### Project Registration
✉️ Say this to open a new project entry:
> "Let's register our first project. Project name: [YOUR PROJECT NAME]. Here's what it does: [1-2 sentences]. The business owner is [NAME/TEAM]. The primary data sources are [list]. The downstream consumers are [dashboards / reports / APIs]."

- [ ] Assistant creates a populated project registry entry
- [ ] `status: active` is set
- [ ] At least one `data_source` entry exists
- [ ] At least one `schema_contract` entry is identified (even if TBD)

### Business Rule Capture — First Session
✉️ For each business rule you know, say:
> "Business rule: [state the rule exactly as the business defines it]. The source for this rule is [person / document]."

- [ ] At least 3 business rules captured with `rule_id`, `statement`, `source`
- [ ] Each rule shows `implemented_in: TBD` if not yet in a model
- [ ] Conflicts checked (assistant should flag if any two rules contradict)

### Lineage Skeleton
✉️ Say:
> "Sketch the critical lineage path for this project — from raw source to the final consumer. Flag any points where lineage is currently a gap."

- [ ] Critical path documented in registry under `lineage.critical_paths`
- [ ] Any gaps documented under `lineage.gaps`
- [ ] Risk level assigned to each critical path

### First Architecture Decision
✉️ For your first real design choice, say:
> "I need to decide [design question]. Walk me through the tradeoffs in both engineering and business terms, then recommend a direction and log the decision."

- [ ] ADR001 entry created with `rationale_engineering` and `rationale_business`
- [ ] Decision maker recorded
- [ ] Decision is cross-referenced in affected model entries

---

## PHASE 3 — Quality and Governance Activation
*Goal: Stand up quality gates and activate escalation behavior*

### dbt Model Standards
✉️ Say:
> "For every new dbt model we create going forward, apply the naming convention in CLAUDE.md and generate at minimum: not_null + unique on primary key, relationships on all foreign keys, accepted_values on all enum columns, and one singular test capturing the core business rule. Confirm this is your default behavior."

- [ ] Assistant confirms default test suite behavior
- [ ] First model scaffolded with full test coverage
- [ ] Model `.yml` entry includes `business_owner` and `data_freshness_sla` meta tags

### Great Expectations Suite
✉️ Say:
> "Scaffold a Great Expectations suite for [dataset/layer]. Name it [project].[dataset].[layer].expectations. Include expectations for: schema, volume, value ranges, and freshness."

- [ ] Suite named according to convention
- [ ] All five expectation categories populated
- [ ] Failure behavior defined (block / alert / log)
- [ ] Gate placement in DAG documented in registry

### Escalation Behavior Test
✉️ Say:
> "I'm going to rename the column `opportunity_id` to `opp_id` in the Salesforce staging model. What's your assessment?"

- [ ] Assistant fires `[SCHEMA BREAKING CHANGE]` flag
- [ ] It identifies downstream consumers
- [ ] It explains impact in business terms
- [ ] It does NOT proceed without your explicit approval

✉️ Say:
> "New business rule: revenue is recognized when the invoice is sent, not when the contract starts."

- [ ] If BR001 (or equivalent) exists in registry, assistant fires `[BUSINESS RULE CONFLICT]`
- [ ] It identifies the conflict and its source
- [ ] It asks for resolution before proceeding

### Session Summary Protocol
✉️ At the end of your first real work session, say:
> "Generate a session summary."

- [ ] Summary includes: projects touched, rules captured, decisions logged, open items, next session start recommendation
- [ ] You paste this summary into `PROJECT_REGISTRY.md` under `session_log`

---

## PHASE 4 — Multi-Project Expansion
*Goal: Activate concurrent project management*

### Project 2+ Onboarding
- [ ] Repeat Phase 2 for each additional project
- [ ] Cross-project dependencies identified and documented
- [ ] Multi-project status dashboard updated in registry

### Context Switch Protocol
✉️ Practice the switch:
> "Switch to project [PROJECT NAME]."

- [ ] Assistant announces the switch explicitly
- [ ] It confirms which project is now active
- [ ] It surfaces any open items or pending decisions for that project

### Cross-Project Impact Check
✉️ Say:
> "I'm changing the Salesforce connector refresh schedule from every 4 hours to every 12 hours. Which projects are affected?"

- [ ] Assistant scans all registered projects with Salesforce as a source
- [ ] It fires `[CROSS-PROJECT IMPACT]` if multiple projects are affected
- [ ] It explains the business impact (SLA misses, freshness degradation) in plain language

---

## PHASE 5 — Operational Steady State
*Goal: Embed this into your daily workflow*

### Daily Workflow Triggers
- [ ] Start each session: "What are the open items across all active projects?"
- [ ] Before any schema change: run it by the assistant first
- [ ] Before any new model: get the naming convention and test scaffold
- [ ] Before any business rule implementation: confirm it's in the registry
- [ ] End each session: "Generate a session summary" → paste into registry

### Monthly Registry Audit
- [ ] Review all `business_rules` — are any implemented_in: TBD still unresolved?
- [ ] Review `lineage.gaps` — has any gap been resolved or escalated?
- [ ] Review `open_items` — close resolved items, re-prioritize remaining
- [ ] Review `schema_contracts` — any contracts due for review?
- [ ] Archive completed projects (set `status: complete`)

### Stakeholder Communication Templates
✉️ Ask your assistant to generate:
> "Write me a non-technical explanation of why [pipeline design decision / quality gate failure / schema change] matters to [CFO / VP of Sales / Product team]."

- [ ] Template saved for recurring stakeholder updates

---

## Capability Verification Matrix

Run this spot-check anytime you want to verify the assistant is fully operational:

| Capability | Test Prompt | Expected Response |
|---|---|---|
| Dual-language | "Why did we choose incremental materialization?" | Engineering + Business frame both present |
| Rule capture | "Revenue excludes refunds over 90 days" | Rule ID assigned, registry entry created |
| Rule conflict | State a rule that contradicts an existing one | `[BUSINESS RULE CONFLICT]` fired |
| Schema governance | "Let's rename a primary key column" | `[SCHEMA BREAKING CHANGE]` fired, stops for approval |
| Lineage tracing | "What does this model feed?" | Full downstream chain identified |
| Quality scaffolding | "Create a new staging model" | Test suite generated automatically |
| Project switching | "Switch to Project X" | Explicit announcement, context confirmed |
| Session summary | "Generate a session summary" | Structured summary with all required fields |
| Business translation | "Explain our CDC ingestion approach" | Plain-language version included |
| Cross-project impact | Change shared source | All affected projects identified |

---

## Quick Reference: Key Invocations

```
Register project     → "Register a new project: [name + context]"
Capture rule         → "Business rule: [statement]. Source: [person/doc]."
Log decision         → "Log the decision to [choice] and explain it in both frames"
Schema review        → "Review this schema change: [proposed change]"
Lineage trace        → "Trace the lineage for [column/table]"
Quality scaffold     → "Scaffold tests for [model name]"
GE suite             → "Create a GE suite for [dataset.layer]"
Switch project       → "Switch to project [name]"
Status check         → "What are the open items across all projects?"
Session summary      → "Generate a session summary"
Business translation → "Explain [technical thing] for [audience]"
Conflict check       → "Does this rule conflict with anything in the registry?"
Impact analysis      → "What breaks if I change [thing]?"
```

---

*DEPLOYMENT_CHECKLIST.md — Modern Prometheus Data Engineering Deployment*
*Complete Phase 1-3 for a fully operational assistant. Phases 4-5 are operational maturity.*
