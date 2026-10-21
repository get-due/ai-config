# get-due — workspace hub (ai-config)

**All work on every get-due repository is done from this repo.** Sessions always start in `ai-config`; the other repos are siblings in the parent folder (`..`), which `.claude/settings.json` adds as a working directory, so every current and future sibling repo is reachable.

**get-due.com**: a multi-currency, privacy-first money tracker for the US (personal, family, micro-business). No bank sync.

## Repositories

| Repo | Local path | Remote | Purpose |
|---|---|---|---|
| ai-config | `.` | github.com/get-due/ai-config | Prompts, checklists, Claude Code config, this hub |
| docs | `../docs` | github.com/get-due/docs | Product documentation (spec) and engineering documentation |

When a new repo is cloned next to these, add a row here. Git hooks apply to it automatically.

## Working across repos

- Use paths relative to `ai-config` (`../docs/...`).
- CLAUDE.md files inside sibling repos are not loaded in these sessions. Keep all instructions in this repo: this file for the hub overview, `.claude/rules/` for topic rules.

## Rules

Loaded automatically from `.claude/rules/`:

| File | Covers |
|---|---|
| `.claude/rules/git.md` | Cross-repo git workflow, branch naming, commit messages |
| `.claude/rules/product-docs.md` | Editing the product docs: conventions, canonical numbers, reconciled decisions |
| `.claude/rules/engineering-docs.md` | Editing the engineering docs: ADR workflow, founder decisions, linking to the spec |

Add a new rule file per topic instead of growing this file, and list it here.

## Subagents

Defined in `.claude/agents/`:

| Agent | Use for |
|---|---|
| `fintech-architect` | Architecture design and review, trade-offs, ADR drafts, risk and reliability of money-handling systems |

## Where things are

| What | Path |
|---|---|
| Product kickoff prompt (source of the spec) | `prompts/PRODUCT_KICKOFF.md` |
| Implementation checklist by phase | `prompts/PRODUCT_CHECKLIST.md` |
| **Product spec (single source of truth)** | `../docs/product/README.md` (start here) |
| PRD sections 1–12, one file per topic | `../docs/product/prd/` |
| Modules M01–M24: functional requirements + user stories | `../docs/product/modules/` |
| Roadmap (overview, MVP, v1, v2+, dependencies) | `../docs/product/roadmap/` |
| Strategic assumptions / open questions for the founder | `../docs/product/assumptions.md`, `../docs/product/open-questions.md` |
| **Engineering docs** (architecture, tech stack) | `../docs/engineering/README.md` (start here) |
| Architecture Decision Records | `../docs/engineering/adr/` |
