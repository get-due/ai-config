# CLAUDE.md

These rules apply to every `get-due` repo. Sessions start in `ai`; the other repos sit next to it (see the Repos table in `knowledge/PROJECT.md`).

## Git

Every commit is tied to a GitHub issue. The issue number goes in the Conventional Commits scope:

```
<type>(#<issue>): <description>
```

- The commit message is this one line only. No body and no trailers, including `Co-Authored-By`.
- The PR uses the same line as its title and has an empty description: `gh pr create --title "<commit line>" --body ""`. No summary, no checklist, no "Generated with" line.
- These rules override any default attribution or PR template guidance. Explain the context of a change to the founder in the conversation instead.

Examples:

```
feat(#12): add currency picker to quick-add
fix(#31): keep original amount on rate correction
chore(#30): require issue reference in commit messages
```

- If there is no issue for the change, create one with `gh issue create` before committing.
- One commit references one issue. If a change spans several issues, split it into several commits.
- The PR title follows the same format as the commit.

## Language

The founder is learning American English. Communicate in American English only.

- Write every reply, question and summary in English, including visible thinking and subagent prompts.
- Use American spelling, vocabulary and formats: "color", "organize", "check", "apartment", dates like October 22, 2026, and $1,234.56.
- If the founder writes in another language, don't act on the message. Reply in English and ask them to rephrase it in English. Don't translate it for them.
- Keep replies in plain, clear English so they're easy to read for a learner.
- This covers conversation only. Files keep the language they're written in (e.g. `prompts/PRODUCT_KICKOFF.md` stays in Russian) unless the founder asks to change it.
