#!/usr/bin/env bash
# Install GSD-compatible mattpocock-derived skills into the current project.
#
# Usage:
#   cd ~/MyProject
#   bash /path/to/claude-skills-for-gsd/install.sh
#
# or one-shot from GitHub:
#   curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | bash
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || pwd)"
TARGET="${1:-$(pwd)}"
cd "$TARGET"

# ── Sanity checks ─────────────────────────────────────────────────────────────
[[ -d .git ]] || { echo "error: '$TARGET' is not a git repo"; exit 1; }

if [[ ! -d .planning ]]; then
  echo "warn: .planning/ not found — these skills are tuned for GSD workflow."
  echo "      Without GSD, paths like .planning/CONTEXT.md will be created from scratch."
  read -rp "      Continue anyway? [y/N] " ans
  [[ "$ans" =~ ^[yY] ]] || exit 1
fi

# ── Detect installation source ────────────────────────────────────────────────
# Curl|bash sets SCRIPT_DIR to PWD (target), which is wrong. If skills/ dir is
# missing relative to SCRIPT_DIR, fall back to a fresh clone in /tmp.
if [[ ! -d "$SCRIPT_DIR/skills" ]]; then
  TMP=$(mktemp -d -t claude-skills-for-gsd.XXXXXX)
  echo "fetching claude-skills-for-gsd via git clone → $TMP"
  REPO_URL="${GSD_SKILLS_REPO:-https://github.com/Louis-Jackson/claude-skills-for-gsd.git}"
  git clone --depth 1 "$REPO_URL" "$TMP" >/dev/null 2>&1
  SCRIPT_DIR="$TMP"
fi

# ── Backup existing .claude/skills/ ───────────────────────────────────────────
if [[ -d .claude/skills ]]; then
  ts=$(date +%Y%m%d-%H%M%S)
  mv .claude/skills ".claude/skills.bak.$ts"
  echo "✓ backed up existing .claude/skills/ → .claude/skills.bak.$ts"
fi

# ── Copy skills ───────────────────────────────────────────────────────────────
mkdir -p .claude/skills
cp -r "$SCRIPT_DIR/skills/"* .claude/skills/
N=$(find .claude/skills -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "✓ installed $N skills under .claude/skills/"

# ── Patch .gitignore to unignore .claude/skills/ ──────────────────────────────
if [[ -f .gitignore ]]; then
  if grep -qE '^\.claude/?\s*$' .gitignore && ! grep -qE '^!\.claude/skills/' .gitignore; then
    awk '
      /^\.claude\/?\s*$/ {
        print ".claude/*"
        print "!.claude/skills/"
        print "!.claude/skills/**"
        next
      }
      { print }
    ' .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore
    echo "✓ patched .gitignore: .claude/skills/ is now tracked"
  else
    echo "  .gitignore: no patch needed (already permissive or already patched)"
  fi
else
  cat > .gitignore <<'EOF'
.claude/*
!.claude/skills/
!.claude/skills/**
EOF
  echo "✓ created .gitignore with .claude/skills/ tracked"
fi

# ── CLAUDE.md scaffold ────────────────────────────────────────────────────────
if [[ ! -f CLAUDE.md ]]; then
  cp "$SCRIPT_DIR/templates/CLAUDE.md.tpl" CLAUDE.md
  echo "✓ created CLAUDE.md from template (review and customize)"
else
  echo "  CLAUDE.md exists — leaving alone. See $SCRIPT_DIR/templates/CLAUDE.md.tpl for reference."
fi

# ── Done ──────────────────────────────────────────────────────────────────────
cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 claude-skills-for-gsd installed.

 Next:
   1. /clear (or restart Claude Code) to register new skills
   2. Optional: run /gsd-map-codebase + /graphify so skills get pre-flight context
   3. Try /grill-with-docs on your next architectural phase
   4. Commit: git add .claude/skills CLAUDE.md .gitignore
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
