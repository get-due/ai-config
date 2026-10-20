#!/usr/bin/env bash
# PreToolUse hook (Bash): block `git commit` unless the commit will be signed
# and shown as "Verified" on GitHub. Exit 2 blocks the tool call; stderr is
# shown to Claude as the reason. Checks live in scripts/verify-commit-signing.sh.
set -uo pipefail

verify="$(cd "$(dirname "$0")/../.." && pwd)/scripts/verify-commit-signing.sh"

input=$(cat)
cmd=$(jq -r '.tool_input.command // ""' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
[ -n "$cwd" ] || cwd=$PWD

# Every `git [-C dir] [-c k=v] ... commit` invocation in the command.
invocations=$(grep -oE '(^|[;&|( ])git( +-[Cc] +[^ ;&|]+)* +commit([^;&|]*)' <<<"$cmd" || true)
[ -n "$invocations" ] || exit 0

fail() {
  echo "COMMIT BLOCKED: the commit would not be Verified on GitHub." >&2
  echo "Repo: $1" >&2
  echo "Reason: $2" >&2
  echo "Fix the signing setup, then retry. Do not bypass this check." >&2
  exit 2
}

while IFS= read -r inv; do
  if grep -qE -- '--no-gpg-sign|--no-verify|(^| )-n( |$)|commit\.gpgsign=(false|0|no|off)|core\.hooksPath=' <<<"$inv"; then
    fail "-" "the command disables signing or skips git hooks: $inv"
  fi

  # Resolve the repo: `-C` path relative to the hook's cwd, or the cwd itself.
  dir=$cwd
  cdir=$(grep -oE -- '-C +[^ ;&|]+' <<<"$inv" | tail -1 | sed -E 's/^-C +//' | tr -d "\"'")
  if [ -n "$cdir" ]; then
    case $cdir in /*) dir=$cdir ;; *) dir=$cwd/$cdir ;; esac
  fi

  reason=$("$verify" "$dir" 2>&1) || fail "$dir" "$reason"
done <<<"$invocations"

exit 0
