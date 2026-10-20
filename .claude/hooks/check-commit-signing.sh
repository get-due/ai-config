#!/usr/bin/env bash
# PreToolUse hook (Bash): block `git commit` unless the commit will be signed
# and shown as "Verified" on GitHub. Parsing and checks are in
# check-commit-signing.py. Fails closed: any error blocks the call (exit 2).
"${PYTHON:-python3}" "$(dirname "$0")/check-commit-signing.py" || {
  echo "(commit signing check failed or could not run; the command was blocked)" >&2
  exit 2
}
