#!/usr/bin/env bash
# Copies the workflow templates into a target repo without overwriting anything.
# Usage: bash install.sh [target-dir]   (default: current directory)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES="$SCRIPT_DIR/../assets/templates"
TARGET="${1:-$PWD}"

[ -d "$TEMPLATES" ] || { echo "Templates not found at $TEMPLATES" >&2; exit 1; }
[ -d "$TARGET" ]    || { echo "Target directory not found: $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"

created=(); skipped=()

while IFS= read -r -d '' src; do
  rel="${src#"$TEMPLATES"/}"
  dest="$TARGET/$rel"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    skipped+=("$rel")
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    created+=("$rel")
  fi
done < <(find "$TEMPLATES" -type f -print0 | sort -z)

# Adapter: Claude Code reads .claude/skills, so point it at .agents/skills
link_note=""
if [ -L "$TARGET/.claude/skills" ]; then
  link_note=".claude/skills already a symlink (kept)"
elif [ -e "$TARGET/.claude/skills" ]; then
  link_note="WARNING: .claude/skills already exists as a real folder. Not replaced. Merge it into .agents/skills manually."
else
  mkdir -p "$TARGET/.claude"
  if ln -s ../.agents/skills "$TARGET/.claude/skills" 2>/dev/null; then
    link_note="created symlink .claude/skills -> ../.agents/skills"
  else
    cp -r "$TARGET/.agents/skills" "$TARGET/.claude/skills"
    link_note="symlink failed; COPIED .agents/skills to .claude/skills. Re-copy after editing skills."
  fi
fi

# Keep personal/local files out of Git
GI="$TARGET/.gitignore"
touch "$GI"
# Don't glue our first entry onto a last line that has no trailing newline
if [ -s "$GI" ] && [ -n "$(tail -c 1 "$GI")" ]; then echo >> "$GI"; fi
for line in "CLAUDE.local.md" ".claude/settings.local.json"; do
  grep -qxF "$line" "$GI" || echo "$line" >> "$GI"
done

echo "Created (${#created[@]}):"
for f in "${created[@]:-}"; do [ -n "$f" ] && echo "  + $f"; done
echo "Skipped, already exist (${#skipped[@]}):"
for f in "${skipped[@]:-}"; do [ -n "$f" ] && echo "  = $f"; done
echo "Adapter: $link_note"
echo "Ensured .gitignore contains CLAUDE.local.md and .claude/settings.local.json"
