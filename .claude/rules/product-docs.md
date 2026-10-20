# Editing the product docs (`../docs/product/`)

- Docs are written in **English**. Conversation with the user is usually in Russian.
- **No technology** in product docs: no stack, architecture, APIs, infrastructure or vendor names. Describe product behavior instead.
- Conventions are defined in `../docs/product/README.md#conventions`. Follow them: persona IDs P1/P2/P3/X1, tiers, phases, story IDs like `M05-F2-S3`, 🔒 for security, `[Assumption]` tags.
- Describe each topic **once**. Elsewhere, link to it by file or ID instead of repeating it.
- Canonical numbers live in one place. Change them there, then grep for other mentions:
  - prices, limits, upgrade drivers → `prd/10-pricing-and-packaging.md`
  - phase scope → `roadmap/00-overview.md`
  - security promises, threat model, phase security gates → `prd/08-security-and-privacy.md` (backlog in `modules/m17-security-and-trust.md`)
  - metric targets → `prd/11-success-metrics.md`
- Keep these reconciled cross-file decisions consistent:
  - Statement files: up to 20 MB / 5,000 rows. Receipts and attachments: up to 10 MB.
  - Original statements are deleted right after import by default.
  - Support sees user data only with the user's grant, for 72 h at most.
  - Account deletion: disabled immediately, 7-day restore, purge within 30 days, backups within 90 days.
  - Incident notice to users: within 72 h.
- When the roadmap changes, update `prompts/PRODUCT_CHECKLIST.md` to match.
