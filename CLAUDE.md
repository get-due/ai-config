# CLAUDE.md

## Git

Every commit is tied to a GitHub issue. The issue number goes in the Conventional Commits scope:

```
<type>(#<issue>): <description>
```

Examples:

```
feat(#12): add currency picker to quick-add
fix(#31): keep original amount on rate correction
chore(#30): require issue reference in commit messages
```

- If there is no issue for the change, create one with `gh issue create` before committing.
- One commit references one issue. If a change spans several issues, split it into several commits.
- The PR title follows the same format as the commit.
