#!/usr/bin/env bash
# Usage: verify-commit-signing.sh <repo-dir>
# Exits 0 if a commit in <repo-dir> will be signed and shown as "Verified" on
# GitHub; otherwise prints the reason to stderr and exits 1.
# Shared by the Claude Code hook (.claude/hooks/) and the git hooks (.githooks/).
set -uo pipefail

fail() { echo "$1" >&2; exit 1; }

repo=$(git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null) || fail "not a git repository: ${1:-.}"
g() { git -C "$repo" config --get "$1" 2>/dev/null; }

[ "$(g commit.gpgsign)" = "true" ] || fail "commit.gpgsign is not true"
format=$(g gpg.format); format=${format:-openpgp}
[ "$format" = "openpgp" ] || fail "gpg.format=$format is not supported by this check (only openpgp)"

key=$(g user.signingkey)
[ -n "$key" ] || fail "user.signingkey is not set"
email=$(g user.email)
[ -n "$email" ] || fail "user.email is not set"
gpg_bin=$(g gpg.program); gpg_bin=${gpg_bin:-gpg}

colons=$("$gpg_bin" --batch --with-colons --list-secret-keys "$key" 2>/dev/null) \
  || fail "no secret key for signing key $key"
validity=$(awk -F: '$1=="sec"{print $2; exit}' <<<"$colons")
case $validity in e|r|d|i) fail "signing key $key is expired, revoked or invalid ($validity)" ;; esac
key_ids=$(awk -F: '$1=="sec"||$1=="ssb"{print $5}' <<<"$colons")
awk -F: '$1=="uid"{print $10}' <<<"$colons" | grep -qiF "<$email>" \
  || fail "user.email $email is not a UID of signing key $key"

echo probe | "$gpg_bin" --batch --local-user "$key" --clearsign >/dev/null 2>&1 \
  || fail "test signature with key $key failed (locked agent or pinentry problem?)"

# GitHub-hosted repos: the key must be on the account, with the email verified.
remote=$(g remote.origin.url)
if grep -q 'github\.com' <<<"$remote"; then
  login=$(gh api user --jq .login 2>/dev/null) || fail "cannot reach GitHub via gh (run: gh auth status)"
  keys=$(gh api "users/$login/gpg_keys" 2>/dev/null) || fail "cannot list GPG keys of $login on GitHub"
  match=$(jq -r --arg ids "$key_ids" --arg email "$email" '
    ($ids | ascii_upcase | split("\n")) as $ids
    | .[] | select(.can_sign or ([.subkeys[]?.can_sign] | any))
    | select((.key_id | ascii_upcase) as $k | $ids | index($k)
             or ([.subkeys[]?.key_id | ascii_upcase] | any(. as $s | $ids | index($s))))
    | select(any(.emails[]; (.email | ascii_downcase) == ($email | ascii_downcase) and .verified))
    | .key_id' <<<"$keys" | head -1)
  [ -n "$match" ] || fail "key $key with verified email $email is not registered on GitHub account $login"
fi

exit 0
