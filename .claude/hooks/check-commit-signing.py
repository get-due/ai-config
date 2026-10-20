"""Parse a Bash tool call and verify every `git commit` in it.

Called by check-commit-signing.sh with the hook JSON on stdin. Exit 0 allows
the call; any other exit blocks it (the wrapper maps it to 2), with the reason
on stderr. Checks live in scripts/verify-commit-signing.sh.
"""
import json
import os
import re
import shlex
import subprocess
import sys

VERIFY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..",
                      "scripts", "verify-commit-signing.sh")
SEPARATORS = {";", "&&", "||", "|", "&", "(", ")", "\n"}
# git global options that take the next token as their value.
GLOBAL_WITH_VALUE = {"-C", "-c", "--git-dir", "--work-tree", "--namespace",
                     "--exec-path", "--config-env", "--super-prefix"}
BAD_CONFIG = re.compile(r"^(commit\.gpgsign=(false|0|no|off)|core\.hookspath=.*)$", re.I)


def block(repo, reason):
    print("COMMIT BLOCKED: the commit would not be Verified on GitHub.", file=sys.stderr)
    print(f"Repo: {repo}", file=sys.stderr)
    print(f"Reason: {reason}", file=sys.stderr)
    print("Fix the signing setup, then retry. Do not bypass this check.", file=sys.stderr)
    sys.exit(1)


def segments(command):
    lexer = shlex.shlex(command, posix=True, punctuation_chars=";&|()")
    lexer.whitespace_split = True
    lexer.commenters = ""
    current = []
    for tok in lexer:
        if tok in SEPARATORS or set(tok) <= set(";&|()"):
            if current:
                yield current
            current = []
        else:
            current.append(tok)
    if current:
        yield current


def resolve(base, path):
    return os.path.normpath(os.path.join(base, os.path.expanduser(path)))


def check_commit(tokens, cwd):
    """tokens start at `git`. Returns None if it's not a commit."""
    i, repo_dir = 1, cwd
    while i < len(tokens) and tokens[i].startswith("-"):
        opt = tokens[i]
        name, _, inline = opt.partition("=")
        if name in GLOBAL_WITH_VALUE and "=" not in opt:
            value = tokens[i + 1] if i + 1 < len(tokens) else ""
            i += 2
        else:
            value = inline
            i += 1
        if name == "-C":
            repo_dir = resolve(repo_dir, value)
        elif name == "--git-dir":
            repo_dir = resolve(repo_dir, value)
        elif name == "--work-tree":
            repo_dir = resolve(repo_dir, value)
        elif name == "-c" and BAD_CONFIG.match(value):
            block("-", f"the command overrides {value}")
    if i >= len(tokens) or tokens[i] != "commit":
        return
    for arg in tokens[i + 1:]:
        if arg in ("--no-gpg-sign", "--no-verify"):
            block("-", f"the command uses {arg}")
        # Short-option cluster such as -n or -anm; options after -m/-F/-C/-c take values.
        if re.fullmatch(r"-[a-zA-Z]+", arg):
            for ch in arg[1:]:
                if ch == "n":
                    block("-", f"the command skips git hooks ({arg})")
                if ch in "mFCcSt":
                    break
    result = subprocess.run([VERIFY, repo_dir], capture_output=True, text=True)
    if result.returncode != 0:
        block(repo_dir, result.stderr.strip() or "verification failed")


def main():
    data = json.load(sys.stdin)
    command = (data.get("tool_input") or {}).get("command") or ""
    cwd = data.get("cwd") or os.getcwd()
    if "git" not in command:
        return
    try:
        segs = list(segments(command))
    except ValueError as e:
        if "commit" in command:
            block("-", f"cannot parse the command to check it ({e})")
        return
    for seg in segs:
        # Skip leading env assignments: FOO=bar git commit ...
        while seg and re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*=.*", seg[0]):
            seg = seg[1:]
        if not seg:
            continue
        if seg[0] in ("cd", "pushd") and len(seg) > 1:
            cwd = resolve(cwd, seg[1])
        elif os.path.basename(seg[0]) == "git":
            check_commit(seg, cwd)


if __name__ == "__main__":
    main()
