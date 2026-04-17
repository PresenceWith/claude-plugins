#!/usr/bin/env bash
# publish.sh — stage all changes, commit, push to origin.
# Usage: ./publish.sh ["commit message"]
# If no message is given, uses "update: <timestamp>".

set -euo pipefail

cd "$(dirname "$0")"

# --- sanity: must be a git repo ---
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "error: not a git repo. run 'git init' first." >&2
  exit 1
fi

# --- sanity: marketplace manifest must exist and parse ---
if [[ ! -f .claude-plugin/marketplace.json ]]; then
  echo "error: .claude-plugin/marketplace.json missing." >&2
  exit 1
fi
if ! python3 -m json.tool .claude-plugin/marketplace.json >/dev/null 2>&1; then
  echo "error: .claude-plugin/marketplace.json is not valid JSON." >&2
  exit 1
fi

# --- validate every per-plugin plugin.json referenced in marketplace ---
while IFS= read -r src; do
  manifest="${src#./}/.claude-plugin/plugin.json"
  if [[ ! -f "$manifest" ]]; then
    echo "error: missing $manifest (referenced in marketplace.json)." >&2
    exit 1
  fi
  if ! python3 -m json.tool "$manifest" >/dev/null 2>&1; then
    echo "error: $manifest is not valid JSON." >&2
    exit 1
  fi
done < <(python3 -c "
import json
with open('.claude-plugin/marketplace.json') as f:
    data = json.load(f)
for p in data.get('plugins', []):
    src = p.get('source', '')
    if src.startswith('./'):
        print(src)
")

# --- stage all changes ---
git add -A

# --- nothing to commit? bail gracefully ---
if git diff --cached --quiet; then
  echo "nothing to commit."
  exit 0
fi

# --- commit ---
msg="${1:-update: $(date +%Y-%m-%d\ %H:%M:%S)}"
git commit -m "$msg"

# --- push ---
branch="$(git rev-parse --abbrev-ref HEAD)"
if ! git remote get-url origin >/dev/null 2>&1; then
  echo ""
  echo "warning: no 'origin' remote configured. commit made locally."
  echo "to push, run:"
  echo "  git remote add origin <your-repo-url>"
  echo "  git push -u origin $branch"
  exit 0
fi

# first push on this branch? set upstream.
if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
  git push
else
  git push -u origin "$branch"
fi

echo "done."
