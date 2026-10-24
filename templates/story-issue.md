# Story issue template

The issue description is the story's spec. `../docs` keeps only cross-story documents: MVP scope, architecture, ADRs and the glossary.

## Rules

- Each section has one owner. Edit only the text between your own marker and the next marker. Never touch another agent's section.
- Read the current description (`gh issue view <n> --repo get-due/<repo> --json body -q .body`) right before you edit it, change your section, and write the whole body back with `gh issue edit <n> --repo get-due/<repo> --body-file <file>`. `--body` replaces the entire description, so never write from an old copy.
- The orchestrator never runs two agents that edit the same issue's description at the same time.
- A section that is still to come says `(pending)`. A section the workflow skips says `(not needed)`.
- Plans and specs go in the description. Results (review findings, security findings, test results) go in issue comments.
- The product lead creates the issue with all five sections: Product filled in, the rest `(pending)`.

## Body

```markdown
<!-- section:product -->
## Product
_Owner: fintech-product-lead_

Problem, goal and metric, scope (in / out), priority, phase (A / B), repo.

<!-- section:requirements -->
## Requirements
_Owner: fintech-analyst_

(pending)

<!-- section:technical -->
## Technical
_Owner: fintech-architect_

(pending)

<!-- section:security -->
## Security
_Owner: fintech-security_

(pending)

<!-- section:testing -->
## Testing
_Owner: fintech-qa_

(pending)
```

## What goes in each section

| Section | Owner | Contents |
|---|---|---|
| Product | `fintech-product-lead` | Problem, goal and metric, scope in / out, priority, phase, repo, links to the PRD if any |
| Requirements | `fintech-analyst` | User story, business rules, acceptance criteria (Given/When/Then), edge cases, UI notes, analytics events, dependencies, developer notes (endpoints, errors, idempotency, events) |
| Technical | `fintech-architect` | Design, API and data contracts, migrations, NFRs, risks, ADR links. `(not needed)` when no architect is involved |
| Security | `fintech-security` | Threats and required controls. `(not needed)` when the story doesn't touch money, auth, PII, integrations or infrastructure |
| Testing | `fintech-qa` | Risk table, test cases, test data, regression areas |
