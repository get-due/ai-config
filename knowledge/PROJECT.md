# Project knowledge
<!-- Shared facts for every agent. Maintained by fintech-orchestrator from the agents' Knowledge updates. -->

> **Missing sources (2026-10-24):** the `docs` files and PR cited below (`docs/product/mvp-0-scope.md`, `backlog-*.md`, `docs/engineering/architecture-mvp-0.md`, docs PR #20) don't exist in `get-due/docs`. The decisions stand as founder statements; don't cite these files as evidence until they are written or restored. Tracked in get-due/docs#1.

## Glossary
- Full glossaries: `docs/product/backlog-app.md` §2, `backlog-landing.md` §2, `backlog-infra.md` §2. Key terms: base currency (changeable, ABR-47), original / account / base amount (base = stored derived projection), pivot quote (units per 1 USD, OXR), reference rate vs "your rate" (override stored with its own currency), rate date (UTC), latest rate ("as of"), gap = possible hidden fee, fee found, balance check/adjustment, IOU, operator, step-up, feature flag, synthetic user, DSAR, size profile (beta/scale). **(source not found, 2026-10-24)**

## Business rules
- Source of truth: `docs/product/mvp-0-scope.md` (IDs final; never edit it). Scope changes in docs PR #20 (worldwide sign-up, AS-10, AS-17, AS-19 beta wording, AS-33, SEC-14, L-06 widened, L-13 sanctions, L-14 age) are treated as final (2026-10-23). **(source not found, 2026-10-24)**
- Derived rules: ABR-xx (`backlog-app.md` §4, incl. ABR-47 base change, ABR-48 residence/age) and LBR-xx (`backlog-landing.md` §3, incl. LBR-14 age 14+, LBR-15 persona). "Assumption" rows are unverified. **(source not found, 2026-10-24)**
- Money math: exact rational, round once half away from zero; architecture vectors T1–T9 are mandatory tests; QA fixture = pivot quotes in `backlog-app-02-currency-accounts.md`. **(source not found, 2026-10-24)**
- Free product, four $0 plans, one engineer, no dates, 10k MAU target, metrics tracked not gated.

## Systems and data ownership
- Architecture decided: `docs/engineering/architecture-mvp-0.md` rev 3 (all AQ-01–26 answered). .NET 10 modular monolith (`api`/`worker`/`ops-api`) + Next.js 16 `web`, PostgreSQL 18 on RDS, EKS Auto Mode, AWS us-east-2, SES, Open Exchange Rates, Cloudflare Turnstile, first-party analytics. **(source not found, 2026-10-24)**
- Production is the only cloud environment; prod smoke tests with a synthetic user; feature flags for dark launches.
- Daily development and QA run on a local Kubernetes cluster in Docker Desktop on the founder's Mac (INF-00, founder request 2026-10-24): same Kustomize base and arm64 images via the `local` overlay in `app` (task APP-01.4), bootstrap in `infra/local/`, `make up/down/redeploy/logs/psql/reset/test-e2e/smoke/parity`. AQ-27 – AQ-29 answered: Docker Desktop kind provisioner pinned to EKS minor 1.36 (version check in `make up`, registry `localhost:5001`), standalone kind + Calico as the CI gate, Traefik v3 + mkcert, Docker Compose removed (Testcontainers stays), `ASPNETCORE_ENVIRONMENT=Production` everywhere with adapters chosen by config keys, 10-item parity allow-list.
- Waitlist owned by `api` module Waitlist; invite redeemed inside `CompleteSignUp`.

## Roles and permissions
- User (own data only; others → 404). Operator = founder via ops console (port-forward + IAM Identity Center MFA): invites, notices, metrics, flags, DSAR log, waitlist lookup; no ledger grants. Emergency access: break-glass role, disclosure queued first, alerted.

## Repos
- Stories have a **Repo** field: `app`, `infra` or `docs`; issues live in the repo where the commit lands. Agent definitions and this file live in `ai`.

## Decisions
- 2026-10-24 founder: all agents run on Opus; revisit the model choice after the first 5 stories.
- 2026-10-24 founder: two phases. Phase A "Local" = INF-00 + all landing/app build stories accepted on the local stand and CI; Phase B "AWS" = INF-01–15, APP-01.3, APP-04.2, APP-70.2, all "Prod check" rows, landing go-live, beta. Every story has a **Phase** field (A, B or A/B). Phase B entry criterion is defined in `backlog-app.md` §1.
- 2026-10-23 founder: FQ-01 = yes (persona, LP-11 Should); FQ-02 = yes (base change, APP-68); worldwide sign-up with sanctions block and min age max(14, country override); no staging; repos `app` and `infra` approved.
- Pending founder confirmation (reported as conflicts): MON-06 wording for base change, weekend rates "as published", Q1 options for non-US waitlist visitors.

## Changelog
- 2026-10-24: Linked the missing sources to get-due/docs#1.
- 2026-10-24: Marked the missing `docs` sources.
- 2026-10-24: Created from the analyst's Project knowledge section (first filled 2026-10-23, updated through 2026-10-24); added the model decision.
