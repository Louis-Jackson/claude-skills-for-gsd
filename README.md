# claude-skills-for-gsd

Personal companion to [GSD](https://github.com/coreysnyder04/get-shit-done) (Get Shit Done) — a small bundle of [mattpocock/skills](https://github.com/mattpocock/skills) re-pathed for the GSD `.planning/` convention.

The grill-fast pipeline these enable:

```
/grill-with-docs            adversarial interview, updates glossary + ADRs
  → writes .planning/phases/{N}/PRD.md
/gsd-plan-phase {N} --prd .planning/phases/{N}/PRD.md --skip-research
  → skips gsd-discuss-phase + gsd-phase-researcher + gsd-pattern-mapper
/gsd-execute-phase {N}
```

This replaces the slower `gsd-discuss-phase → gsd-phase-researcher → gsd-pattern-mapper` chain when a phase introduces new domain concepts, technology lock-in, or boundary changes.

## What's inside

| Skill | Origin | Purpose |
|---|---|---|
| `grill-me` | mattpocock, verbatim | Adversarial interview, no file output |
| `grill-with-docs` | mattpocock, path-patched | Adversarial interview + maintains `.planning/CONTEXT.md` glossary + `.planning/adrs/` + outputs PRD.md |
| `zoom-out` | mattpocock, path-patched | "Go up a layer of abstraction" |
| `improve-codebase-architecture` | mattpocock, path-patched | Find deepening opportunities (Ousterhout vocabulary) |

All four are configured to read `.planning/codebase/STRUCTURE.md`, `.planning/codebase/ARCHITECTURE.md`, and `.planning/graphs/GRAPH_REPORT.md` as pre-flight context when those exist, so they don't re-walk what `/gsd-map-codebase` and `/graphify` already mapped.

## Install (in any GSD project)

```bash
cd ~/MyProject
bash <(curl -fsSL https://raw.githubusercontent.com/Louis-Jackson/claude-skills-for-gsd/main/install.sh)
```

Or clone-and-run:

```bash
git clone --depth 1 https://github.com/Louis-Jackson/claude-skills-for-gsd.git /tmp/claude-skills-for-gsd
bash /tmp/claude-skills-for-gsd/install.sh ~/MyProject
```

The installer:

1. Refuses if the target isn't a git repo
2. Warns (but doesn't block) if `.planning/` doesn't exist — these skills are tuned for GSD
3. Backs up any existing `.claude/skills/` to `.claude/skills.bak.{timestamp}`
4. Copies the 4 skills into `.claude/skills/`
5. Patches `.gitignore` so `.claude/skills/` is tracked while `.claude/settings.local.json` and `.claude/worktrees/` stay ignored
6. Scaffolds `CLAUDE.md` from the template **only if it doesn't already exist**

After installation:

- `/clear` or restart Claude Code so the new skills register
- Optional: run `/gsd-map-codebase` and `/graphify` so the pre-flight context exists
- Commit: `git add .claude/skills CLAUDE.md .gitignore && git commit`

## Path differences from upstream

| Concept | mattpocock default | This fork |
|---|---|---|
| Domain glossary | `CONTEXT.md` (repo root) | `.planning/CONTEXT.md` |
| ADRs | `docs/adr/` | `.planning/adrs/` |
| Multi-context map | `CONTEXT-MAP.md` | `.planning/CONTEXT-MAP.md` |

Everything else is identical to upstream (verbatim or with the location-string substitution above).

## Upgrading

Re-run the installer. Existing `.claude/skills/` is backed up before overwrite.

## Why a fork instead of `npx skills@latest add mattpocock/skills`?

mattpocock's installer writes to its own conventions (`docs/adr/`, root `CONTEXT.md`). In a GSD project that creates two parallel decision-record trees and two parallel glossaries — confusing and lossy. This fork bakes the GSD convention in.

If you're not using GSD, install upstream directly with the mattpocock installer instead.

## License

Skill content derives from [mattpocock/skills](https://github.com/mattpocock/skills); refer to that repo for the underlying license. Patches in this repo are released under the same terms.
