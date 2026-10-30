#!/usr/bin/env bash
# End-to-end checks for install.sh. Run from anywhere: bash tests/smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

pass=0
ok()   { pass=$((pass + 1)); echo "ok   $*"; }
fail() { echo "FAIL $*" >&2; exit 1; }
quiet() { "$@" >"$WORK/out.log" 2>&1 || { cat "$WORK/out.log" >&2; fail "command failed: $*"; }; }

# 1. Fresh project gets every template, the symlink and .gitignore entries
P="$WORK/project"; mkdir -p "$P"
quiet bash "$ROOT/install.sh" "$P"
for f in AGENTS.md CLAUDE.md docs/workflow.md docs/review-checklist.md \
         docs/decisions/0001-adopt-ai-assisted-workflow.md \
         .agents/skills/plan-task/SKILL.md .agents/skills/finalize-task/SKILL.md; do
  [ -f "$P/$f" ] || fail "missing $f"
done
ok "templates installed"
[ -L "$P/.claude/skills" ] || fail ".claude/skills is not a symlink"
[ -f "$P/.claude/skills/plan-task/SKILL.md" ] || fail ".claude/skills does not resolve"
ok ".claude/skills -> .agents/skills"
grep -qxF "CLAUDE.local.md" "$P/.gitignore" || fail ".gitignore entry missing"
ok ".gitignore entries added"

# 2. Re-running creates nothing and changes nothing
quiet bash "$ROOT/install.sh" "$P"
grep -q "^Created (0)" "$WORK/out.log" || fail "second run created files"
[ "$(grep -cxF "CLAUDE.local.md" "$P/.gitignore")" = 1 ] || fail ".gitignore entry duplicated"
ok "idempotent"

# 3. Existing files are never overwritten, and a .gitignore without trailing newline stays intact
E="$WORK/existing"; mkdir -p "$E"
echo "my rules" > "$E/AGENTS.md"
printf 'node_modules' > "$E/.gitignore"
quiet bash "$ROOT/install.sh" "$E"
[ "$(cat "$E/AGENTS.md")" = "my rules" ] || fail "AGENTS.md was overwritten"
grep -q "= AGENTS.md" "$WORK/out.log" || fail "AGENTS.md not reported as skipped"
ok "existing files kept"
grep -qxF "node_modules" "$E/.gitignore" || fail ".gitignore last line was mangled"
ok ".gitignore without trailing newline"

# 4. Skill install (copy), then skip on re-run
S="$WORK/skills"
quiet bash "$ROOT/install.sh" --skill --skill-dir "$S"
if ! { [ -f "$S/setup-ai-workflow/SKILL.md" ] && [ ! -L "$S/setup-ai-workflow" ]; }; then fail "skill not copied"; fi
quiet bash "$ROOT/install.sh" --skill --skill-dir "$S"
grep -q "already exists" "$WORK/out.log" || fail "skill re-install did not skip"
ok "skill install + skip"

# 5. Skill install (link)
L="$WORK/linked"
quiet bash "$ROOT/install.sh" --skill --link --skill-dir="$L"
[ -L "$L/setup-ai-workflow" ] || fail "skill not linked"
ok "skill --link"

# 6. Piped from curl: downloads the archive (served from a local tarball here)
mkdir -p "$WORK/archive"
tar -czf "$WORK/archive/kit.tar.gz" -C "$(dirname "$ROOT")" \
  --exclude .git "$(basename "$ROOT")"
C="$WORK/curl-project"; mkdir -p "$C"
(cd "$C" && AIWK_ARCHIVE_URL="file://$WORK/archive/kit.tar.gz" quiet bash -s < "$ROOT/install.sh")
if ! { [ -f "$C/AGENTS.md" ] && [ -L "$C/.claude/skills" ]; }; then fail "piped install did not install templates"; fi
(AIWK_ARCHIVE_URL="file://$WORK/archive/kit.tar.gz" quiet bash -s -- --skill --skill-dir "$WORK/curl-skills" < "$ROOT/install.sh")
[ -f "$WORK/curl-skills/setup-ai-workflow/scripts/install.sh" ] || fail "piped skill install failed"
ok "piped install (project + skill)"

# 7. Bad arguments fail
if bash "$ROOT/install.sh" --nope >/dev/null 2>&1; then fail "unknown option accepted"; fi
if bash "$ROOT/install.sh" --link "$P" >/dev/null 2>&1; then fail "--link accepted without --skill"; fi
if bash "$ROOT/install.sh" "$WORK/does-not-exist" >/dev/null 2>&1; then fail "missing target accepted"; fi
ok "bad arguments rejected"

echo "All $pass checks passed."
