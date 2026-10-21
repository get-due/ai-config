# Git: repos, branches and commits

Same rules in every get-due repo.

## Working across repos

- Run git for another repo with `git -C ../<repo> ...`. Each repo has its own branches, commits and PRs, so never mix changes from two repos in one commit.
- Before reporting git state, check each repo touched in the session.
- Every commit must be signed and show as **Verified** on GitHub. Checks live in `scripts/verify-commit-signing.sh` and run twice:
  - Claude Code `PreToolUse` hook `.claude/hooks/check-commit-signing.sh` blocks Claude's `git commit` (also rejects `--no-gpg-sign`, `--no-verify`).
  - Git hooks in `.githooks/` (`pre-commit`, `pre-merge-commit`) block the user's terminal commits. `core.hooksPath` is set for every repo under `~/Workspaces/github-com/get-due/`, existing or future, by `~/.config/git/get-due.config` (an `includeIf` in `~/.gitconfig`). No per-repo setup. On a new machine, recreate those two config entries.
- When a check blocks a commit, report the reason to the user and stop. Never bypass it.
- Don't commit or push unless the user asks. When asked only for a proposal, give branch names and commit messages per repo.

## Branches

`<type>/<short-description>`

- `<type>` is one of the commit types below.
- `<short-description>` is lowercase kebab-case, 2–5 words, no ticket numbers unless one exists: `docs/pricing-tiers`, `chore/claude-settings`.
- Branch off an up-to-date `main`. One topic per branch. Never commit directly to `main`.

## Commits

[Conventional Commits](https://www.conventionalcommits.org/), scope required. **Subject line only**: no body, no footers, no trailers (including `Co-Authored-By`). Commit with a single `-m`.

```
<type>(<scope>): <summary>
```

- Types:
  - `docs`: product documentation content
  - `feat`: new capability (code repos)
  - `fix`: bug fix, or correcting a wrong fact or number in docs
  - `refactor`: restructuring without changing meaning or behavior (moving sections, splitting files)
  - `chore`: config, tooling, repo housekeeping
  - `ci`: CI/CD pipelines
- Scopes: the area touched. In `docs`: `product`, `prd`, `modules`, `roadmap`, `engineering`, `adr`. In `ai-config`: `claude`, `prompts`, `hub`. Use `init` only for a repo's first commit.
- Summary: imperative mood, lowercase start, no trailing period, ≤ 72 characters. `docs(prd): add family tier limits`, not `Added family tier limits.`
- Context that doesn't fit the summary (reasons, cross-file updates) goes in the PR description, not the commit.
- Breaking changes (renamed IDs, removed modules or stories): add `!` after the scope (`docs(modules)!: renumber M05 stories`) and describe the impact in the PR description.
- One logical change per commit. A change that spans repos gets a commit in each repo with matching summaries.
