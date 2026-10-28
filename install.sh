#!/usr/bin/env bash
# ai-workflow-kit installer. Never overwrites existing files.
# Run ./install.sh --help for usage.
set -euo pipefail

REPO="tarektech/ai-workflow-kit"
REF="${AIWK_REF:-main}"
ARCHIVE_URL="${AIWK_ARCHIVE_URL:-https://github.com/$REPO/archive/$REF.tar.gz}"
SKILL_NAME="setup-ai-workflow"

usage() {
  cat <<EOF
Usage:
  install.sh [target-dir]       Add the workflow files to a project (default: current directory)
  install.sh --skill [options]  Install the $SKILL_NAME skill for your user

Skill options:
  --skill-dir DIR   Where to install the skill (default: ~/.claude/skills)
  --link            Symlink to this clone instead of copying (for contributors)

Existing files are never overwritten; they are listed as skipped.

From GitHub without cloning (downloads $REPO@$REF to a temp dir first):
  curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | bash -s -- --skill
EOF
}

die() { echo "Error: $*" >&2; exit 1; }

mode="project"; target=""; link=0; skill_dir="$HOME/.claude/skills"
while [ $# -gt 0 ]; do
  case "$1" in
    --skill)       mode="skill" ;;
    --link)        link=1 ;;
    --skill-dir)   [ $# -ge 2 ] || die "--skill-dir needs a value"; skill_dir="$2"; shift ;;
    --skill-dir=*) skill_dir="${1#*=}" ;;
    -h|--help)     usage; exit 0 ;;
    -*)            usage >&2; die "unknown option: $1" ;;
    *)             [ -z "$target" ] || die "only one target directory allowed"; target="$1" ;;
  esac
  shift
done

if [ "$mode" = "skill" ]; then
  [ -z "$target" ] || die "--skill takes no target directory (use --skill-dir)"
elif [ "$link" = 1 ]; then
  die "--link only applies to --skill"
fi

# Use the kit next to this script, or download it when piped from curl
kit=""
src="${BASH_SOURCE[0]:-}"
if [ -n "$src" ] && [ -f "$src" ]; then
  dir="$(cd "$(dirname "$src")" && pwd)"
  [ -f "$dir/skills/$SKILL_NAME/SKILL.md" ] && kit="$dir"
fi
if [ -z "$kit" ]; then
  [ "$link" = 0 ] || die "--link needs a local clone of $REPO"
  command -v curl >/dev/null || die "curl is required"
  command -v tar  >/dev/null || die "tar is required"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Downloading $REPO@$REF ..."
  curl -fsSL "$ARCHIVE_URL" | tar -xzf - -C "$tmp" --strip-components=1 \
    || die "download failed: $ARCHIVE_URL"
  [ -f "$tmp/skills/$SKILL_NAME/SKILL.md" ] || die "downloaded archive has no skills/$SKILL_NAME"
  kit="$tmp"
fi
SKILL_SRC="$kit/skills/$SKILL_NAME"

if [ "$mode" = "project" ]; then
  bash "$SKILL_SRC/scripts/install.sh" "${target:-$PWD}"
  cat <<EOF

Next: replace the TODOs in AGENTS.md and docs/ with your project's facts.
Or install the skill (install.sh --skill) and ask your agent to
"set up the AI workflow" so it fills them in from your codebase.
EOF
  exit 0
fi

dest="$skill_dir/$SKILL_NAME"
if [ -e "$dest" ] || [ -L "$dest" ]; then
  echo "Skipped: $dest already exists."
  echo "To upgrade, remove it and run this again."
  exit 0
fi
mkdir -p "$skill_dir"
if [ "$link" = 1 ]; then
  ln -s "$SKILL_SRC" "$dest"
  echo "Linked $dest -> $SKILL_SRC"
else
  cp -R "$SKILL_SRC" "$dest"
  echo "Installed $dest"
fi
cat <<EOF

Next: open a project in Claude Code or Cursor and say "set up the AI workflow".
EOF
