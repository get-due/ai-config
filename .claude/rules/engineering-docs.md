# Editing the engineering docs (`../docs/engineering/`)

- Docs are written in **English**. Conversation with the user is usually in Russian.
- Engineering docs describe **how** the product is built. Product behavior stays in `../docs/product/`. Link to it by ID (`M05-F2-S3`, `NFR-R2`, `T9`, `MVP gate #8`) and never restate it. If a product rule is missing or unclear, fix the product doc first.
- Conventions are in `../docs/engineering/README.md#conventions`.
- **Every significant decision is an ADR** in `../docs/engineering/adr/`, from `0000-template.md`. Significant means expensive to reverse, spanning several services, or implementing a security or privacy promise.
  - New ADRs start as 🟡 Proposed with options and a recommendation. Only the founder moves one to 🟢 Accepted.
  - An Accepted ADR is not rewritten. A changed decision gets a new ADR that supersedes it.
  - When an ADR is added or changes status, update `adr/README.md` (index), `01-tech-stack.md` and, if components change, `00-architecture-overview.md`.
- Founder decisions so far (do not reopen without the founder):
  - Microservices by bounded context, gRPC between services, RabbitMQ for events and jobs (ADR-0002, ADR-0004). A modular monolith was offered and declined.
  - PostgreSQL (ADR-0005). Amazon S3 for files (ADR-0015). NGINX at the edge (ADR-0008). Encryption of every hop inside the cluster (ADR-0016).
  - .NET LTS backend, Next.js LTS web, Flutter iPhone app, LTS versions only (ADR-0003).
  - AWS, Kubernetes on EKS (Auto Mode), Argo CD (ADR-0008).
  - Full observability: OpenTelemetry, Prometheus, Grafana (ADR-0012). Full auditing (ADR-0013).
  - Remaining tools: mainstream US choices, delegated by the founder (ADR-0014). For a new tool, prefer the most widely used option in the US that keeps the PRD §8 privacy promise.
  - The founder builds and runs the project alone. Designs must be operable by one person.
- 🔒 Never put user financial data in logs, traces, metrics or examples. Use the canary values from ADR-0012 in examples.
