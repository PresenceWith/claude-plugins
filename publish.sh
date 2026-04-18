#!/usr/bin/env bash
# publish.sh — auto-register new plugins, stage all changes, commit, push to origin.
# Usage: ./publish.sh ["commit message"]
# If no message is given, uses "update: <timestamp>".
#
# Auto-registration: any top-level directory containing .claude-plugin/plugin.json
# but missing from .claude-plugin/marketplace.json is appended to the manifest
# using its plugin.json's name + description. Idempotent: re-running does nothing
# once a plugin is registered.

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

# --- auto-register: append any plugin dir missing from marketplace.json ---
python3 <<'PY'
import json, glob

MANIFEST = '.claude-plugin/marketplace.json'

with open(MANIFEST) as f:
    manifest = json.load(f)

existing = {p.get('source') for p in manifest.get('plugins', [])}
added = []

for plugin_json in sorted(glob.glob('*/.claude-plugin/plugin.json')):
    plugin_dir = plugin_json.split('/', 1)[0]
    source = f'./{plugin_dir}'
    if source in existing:
        continue
    with open(plugin_json) as f:
        info = json.load(f)
    name = info.get('name')
    if not name:
        print(f"warning: {plugin_json} has no 'name' field; skipping.")
        continue
    entry = {
        'name': name,
        'source': source,
        'description': info.get('description', ''),
    }
    manifest.setdefault('plugins', []).append(entry)
    added.append(name)

if added:
    with open(MANIFEST, 'w') as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f"registered: {', '.join(added)}")
PY

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
