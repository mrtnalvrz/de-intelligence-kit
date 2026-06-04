# INSTALL.md — Modern Prometheus Data Engineering Assistant
## Step-by-Step Setup Guide

---

## What You're Installing

A Data Engineering Intelligence that lives inside a Claude Project — a persistent, session-aware assistant that remembers your business rules, tracks pipeline decisions, enforces schema governance, and speaks both engineering and executive language. No servers. No code to run. Four files and a Claude Project.

**Time to first use:** ~20 minutes  
**Prerequisites:** Claude.ai account (Pro or Team plan required for Projects)

---

## Overview

```
Step 1 → Create your GitHub repo (version control for your framework)
Step 2 → Download the four framework files
Step 3 → Create a Claude Project
Step 4 → Load the framework into Claude
Step 5 → Run the calibration sequence
Step 6 → Register your first project
Step 7 → Verify everything is working
```

---

## Step 1 — Create Your Private GitHub Repo

This gives you version control over your framework so it evolves as you do.

**1.1** Go to [github.com/new](https://github.com/new)

**1.2** Configure the repo:
```
Repository name:  de-intelligence-kit
Visibility:       Private
Initialize with:  README (check this box)
.gitignore:       None
License:          None
```

**1.3** Click **Create repository**

**1.4** Clone it to your machine:
```bash
git clone https://github.com/YOUR_USERNAME/de-intelligence-kit.git
cd de-intelligence-kit
```

**1.5** Create the folder structure:
```bash
mkdir -p framework projects docs
touch framework/CLAUDE.md
touch framework/AGENTS.md
touch framework/PROJECT_REGISTRY.md
touch framework/DEPLOYMENT_CHECKLIST.md
touch docs/INSTALL.md
```

Your structure should look like:
```
de-intelligence-kit/
├── framework/
│   ├── CLAUDE.md               ← behavioral constitution
│   ├── AGENTS.md               ← agent role definitions
│   ├── PROJECT_REGISTRY.md     ← persistent memory layer
│   └── DEPLOYMENT_CHECKLIST.md ← deployment guide
├── projects/
│   └── (one .md file per active project, eventually)
├── docs/
│   └── INSTALL.md              ← this file
└── README.md
```

---

## Step 2 — Add the Framework Files

**2.1** Copy the content of each file from the files you downloaded into the matching file in `framework/`. The four files are:
- `CLAUDE.md`
- `AGENTS.md`
- `PROJECT_REGISTRY.md`
- `DEPLOYMENT_CHECKLIST.md`

**2.2** Commit them:
```bash
git add .
git commit -m "feat: initial Modern Prometheus framework deployment"
git push origin main
```

**2.3** Update `README.md` with a brief description:
```markdown
# DE Intelligence Kit

Personal Data Engineering Intelligence framework built on the Modern Prometheus methodology.

## What's here
- `framework/` — the four core files that define the assistant's behavior
- `projects/` — one registry file per active data project
- `docs/` — setup and operational guides

## How to use
See docs/INSTALL.md for setup. Load framework files into a Claude Project per the instructions there.
```

Commit and push:
```bash
git add README.md
git commit -m "docs: add README"
git push origin main
```

---

## Step 3 — Create a Claude Project

**3.1** Go to [claude.ai](https://claude.ai)

**3.2** In the left sidebar, click **+ New Project**

**3.3** Name it:
```
Data Engineering Intelligence
```

**3.4** (Optional but recommended) Add a description:
```
Modern Prometheus DE Assistant — pipeline architecture, schema governance, lineage tracking, dbt/GX quality gates, business rule memory. Multi-project, session-persistent.
```

**3.5** Click **Create Project** — you'll land inside the project view.

---

## Step 4 — Load the Framework into Claude

This is the most important step. The order matters.

### 4.1 — Set the Project Instructions (CLAUDE.md)

Inside your new project:

1. Click **Edit project instructions** (or the settings/pencil icon near the top)
2. Open `framework/CLAUDE.md` from your repo
3. **Select all** the content and **paste it** into the instructions field
4. Click **Save**

> ⚠️ This is the behavioral constitution. Everything the assistant does flows from this. Don't abbreviate it.

### 4.2 — Upload Reference Documents

Still inside the project, find the **Add content** or **Upload files** option (typically a paperclip or document icon in the project panel).

Upload these files in this order:
1. `framework/AGENTS.md`
2. `framework/PROJECT_REGISTRY.md`
3. `framework/DEPLOYMENT_CHECKLIST.md`

> You can also upload any existing files that are relevant to your data work: dbt `schema.yml` files, data dictionaries, ERDs, existing pipeline documentation, or a copy of your current tech stack diagram. The assistant will use these as context.

### 4.3 — Confirm the Load

Open a new chat inside the project (not a general Claude chat — make sure you're inside the project). You'll see the project name displayed.

Send this message to confirm the files are loaded:
```
What documents do you have access to in this project?
```

The assistant should list AGENTS.md, PROJECT_REGISTRY.md, and DEPLOYMENT_CHECKLIST.md (and any other files you uploaded). If it doesn't see them, re-upload and try again.

---

## Step 5 — Run the Calibration Sequence

These prompts activate specific behaviors. Run them in order in your first project chat.

### Calibration Prompt 1 — Identity and Operating Mode
```
You are my Data Engineering Intelligence. Your operating instructions are in CLAUDE.md.
Before we start any project work, confirm: you understand that every architecture
decision requires both an engineering frame and a business frame, and that you will
capture every business rule I state into the project registry without being asked.
```

**Expected response:** The assistant should confirm dual-language mode and proactive rule capture. If it hedges or gives a generic response, paste the CLAUDE.md content directly into the chat as a follow-up.

### Calibration Prompt 2 — Escalation Behavior
```
I'm going to rename the primary key column in our main facts table from
`opportunity_id` to `opp_id`. What's your assessment?
```

**Expected response:** The assistant should immediately fire `[SCHEMA BREAKING CHANGE]`, identify that downstream consumers will be affected, explain the risk in business terms, and stop for your approval before proceeding. If it just says "sure, here's the SQL" — calibration failed, re-check that CLAUDE.md is loaded in the project instructions.

### Calibration Prompt 3 — Business Rule Memory
```
Business rule: an active user is defined as anyone who has logged in within the
last 30 calendar days. The source for this rule is our product analytics spec,
confirmed by the VP of Product on June 1st.
```

**Expected response:** The assistant should create a structured registry entry with `rule_id: BR001`, `statement`, `source`, `captured` date, `implemented_in: TBD`, and `conflicts_with: NONE`. It should not just acknowledge the rule conversationally — it should format it for the registry.

---

## Step 6 — Register Your First Project

Once calibration passes, register your first real project:

```
Let's register our first project. 

Project name: [YOUR PROJECT NAME]

What it does: [1-2 sentences describing the pipeline or dataset]

Business owner: [name or team]

Data sources: [list your sources — Salesforce, Snowflake, Stripe, custom, etc.]

Downstream consumers: [dashboards, reports, APIs, models that depend on this]

Primary freshness requirement: [how stale can the data get before it's a problem]
```

The assistant will generate a populated PROJECT_REGISTRY entry. Copy that output and:

1. Paste it into `projects/[project-name].md` in your repo
2. Commit it:
```bash
git add projects/
git commit -m "feat: register [project name] in project registry"
git push origin main
```

---

## Step 7 — Verify Full Functionality

Run this spot-check to confirm all capabilities are live:

| Check | What to say | What to look for |
|---|---|---|
| Dual-language | "Why would we use incremental over full-refresh?" | Both 🔧 and 📊 frames present |
| Rule capture | State any business definition | Structured registry entry with rule_id |
| Rule conflict | State a rule that contradicts BR001 | `[BUSINESS RULE CONFLICT]` fired |
| Schema gate | "Let's drop the `created_at` column" | `[SCHEMA BREAKING CHANGE]` fired, stops for approval |
| Quality scaffold | "Create a staging model for our orders table" | dbt test suite generated automatically |
| Session summary | "Generate a session summary" | Structured summary with all fields |
| Business translation | "Explain CDC ingestion to a CFO" | Plain-language explanation, no jargon |

If all seven pass — you're fully operational.

---

## Ongoing Workflow

### Starting each session
```
What are the open items across all active projects?
```

### Ending each session
```
Generate a session summary.
```
Copy the output into the relevant `projects/[name].md` under `session_log`, then commit:
```bash
git add projects/
git commit -m "session: [project name] — [date] — [one-line summary]"
git push origin main
```

### Adding a new project
Repeat Step 6 for each new project. Each gets its own file in `projects/`.

### Updating the framework
When you refine CLAUDE.md or AGENTS.md based on what you learn:
1. Update the file in `framework/`
2. Re-paste the updated CLAUDE.md into your Claude Project instructions
3. Re-upload any changed reference documents
4. Commit:
```bash
git commit -am "refine: [what you changed and why]"
git push origin main
```

---

## Troubleshooting

**Assistant isn't firing escalation flags**
→ CLAUDE.md may not be in the Project Instructions (not just uploaded as a file — it must be in the instructions field). Re-paste it.

**Assistant doesn't remember between sessions**
→ The PROJECT_REGISTRY.md needs to be updated and re-uploaded after each session, OR you paste your updated registry content at the start of the next session. Claude Projects don't auto-update uploaded files.

**Assistant gives single-frame answers**
→ Re-run Calibration Prompt 1. If the behavior persists, check that CLAUDE.md is the full file (not truncated).

**Rule conflicts aren't being caught**
→ Make sure you've accumulated at least a few rules in the registry. The conflict detection only works once there are rules to conflict with. Try stating a rule that directly contradicts an existing one.

**Project context confusion**
→ If working across multiple projects, always start each conversation with: `"We're working on project [NAME] today."` The assistant will anchor to that context.

---

## File Reference

| File | Where it lives | What it does | Update frequency |
|---|---|---|---|
| `CLAUDE.md` | Claude Project Instructions field | Behavioral constitution | Rarely (major framework updates) |
| `AGENTS.md` | Uploaded reference document | Agent role definitions | Rarely |
| `PROJECT_REGISTRY.md` | Uploaded reference + your repo | Master memory layer | Every session |
| `DEPLOYMENT_CHECKLIST.md` | Uploaded reference + your repo | Activation guide | Once (then archive) |
| `projects/[name].md` | Your repo only | Per-project memory | Every session |

---

*INSTALL.md — Modern Prometheus Data Engineering Assistant*
*From zero to operational in 20 minutes.*
