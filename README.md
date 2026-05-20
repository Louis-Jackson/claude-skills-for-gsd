# claude-skills-for-gsd

A curated bundle of Claude Code skills for the [GSD](https://github.com/gsd-build/get-shit-done) (Get Shit Done) workflow — combining [mattpocock/skills](https://github.com/mattpocock/skills) (re-pathed for `.planning/`) with a trimmed GSD skill set (12 of 67, the ones that matter).

## The workflow these enable

```
/grill-with-docs            adversarial interview, updates glossary + ADRs
  -> writes .planning/phases/{N}/PRD.md
/gsd-plan-phase {N} --prd .planning/phases/{N}/PRD.md --skip-research
  -> creates PLAN.md files from your grilled decisions
/gsd-execute-phase {N}
  -> wave-based execution with subagents
/gsd-verify-work
  -> UAT validation
```

This replaces the slower `gsd-discuss-phase -> gsd-phase-researcher -> gsd-pattern-mapper` chain when a phase introduces new domain concepts, technology lock-in, or boundary changes.

## What's inside

### Grill skills (mattpocock-derived, path-patched for `.planning/`)

| Skill | Purpose |
|---|---|
| `grill-me` | Adversarial interview, no file output |
| `grill-with-docs` | Adversarial interview + maintains `.planning/CONTEXT.md` glossary + `.planning/adrs/` + outputs PRD.md |
| `zoom-out` | "Go up a layer of abstraction" — high-level codebase orientation |
| `improve-codebase-architecture` | Find deepening opportunities (Ousterhout vocabulary) |

### GSD skills (curated from `get-shit-done-cc`, 12 of 67)

| Skill | Purpose |
|---|---|
| `gsd-plan-phase` | Research -> plan -> verify. Accepts `--prd` + `--skip-research` |
| `gsd-execute-phase` | Wave-based execution with subagents |
| `gsd-verify-work` | UAT validation |
| `gsd-discuss-phase` | Gather implementation decisions (for phases without a PRD) |
| `gsd-map-codebase` | Parallel mapper agents -> `.planning/codebase/` indices |
| `gsd-graphify` | Knowledge graph -> `.planning/graphs/` |
| `gsd-progress` | Check status + advance workflow |
| `gsd-quick` | Single-task with state tracking |
| `gsd-fast` | Trivial inline task |
| `gsd-phase` | Add/edit/remove phases in ROADMAP.md |
| `gsd-help` | Reference |
| `gsd-update` | Keep GSD current |

### When to use which

| Path | Use when |
|---|---|
| **grill-fast** (`/grill-with-docs` -> `/gsd-plan-phase --prd` -> `/gsd-execute-phase`) | Phase introduces new domain concepts, technology lock-in, or boundary changes |
| **plain GSD** (`/gsd-discuss-phase` -> `/gsd-plan-phase`) | Phase is implementation-detail only, scope is concrete, no new naming |
| `/gsd-quick` or `/gsd-fast` | Trivial single-step task |
| `/improve-codebase-architecture` | End of milestone, v1->v2 transition, or "code feels muddy" |
| `/zoom-out` | Lost in an unfamiliar code area; want a high-level map |
| `/grill-me` | Quick design conversation, no doc updates needed |

## Install

### Into a project (project-local skills in `.claude/skills/`)

```bash
cd ~/MyProject
bash <(curl -fsSL https://raw.githubusercontent.com/Louis-Jackson/claude-skills-for-gsd/main/install.sh)
```

Or clone-and-run:

```bash
git clone --depth 1 https://github.com/Louis-Jackson/claude-skills-for-gsd.git /tmp/claude-skills-for-gsd
bash /tmp/claude-skills-for-gsd/install.sh ~/MyProject
```

### Globally (all projects)

```bash
git clone --depth 1 https://github.com/Louis-Jackson/claude-skills-for-gsd.git /tmp/claude-skills-for-gsd
cp -r /tmp/claude-skills-for-gsd/skills/* ~/.claude/skills/
```

The installer:
1. Refuses if the target isn't a git repo
2. Warns (but doesn't block) if `.planning/` doesn't exist
3. Backs up any existing `.claude/skills/` to `.claude/skills.bak.{timestamp}`
4. Copies all 16 skills into `.claude/skills/`
5. Patches `.gitignore` so `.claude/skills/` is tracked
6. Scaffolds `CLAUDE.md` from the template **only if it doesn't already exist**

After installation: `/clear` or restart Claude Code so the new skills register.

## Why not just `npx get-shit-done-cc@latest`?

The full GSD install ships 67 skills. Most are noise for day-to-day work. This bundle keeps the 12 that matter and drops the 55 you'll never use (audit pipelines, namespace routers, profiling, sketching, etc.).

## Why not just `npx skills@latest add mattpocock/skills`?

mattpocock's installer writes to its own conventions (`docs/adr/`, root `CONTEXT.md`). In a GSD project that creates two parallel decision-record trees and two parallel glossaries — confusing and lossy. This fork bakes the GSD `.planning/` convention in.

## Path differences from upstream mattpocock

| Concept | mattpocock default | This fork |
|---|---|---|
| Domain glossary | `CONTEXT.md` (repo root) | `.planning/CONTEXT.md` |
| ADRs | `docs/adr/` | `.planning/adrs/` |
| Multi-context map | `CONTEXT-MAP.md` | `.planning/CONTEXT-MAP.md` |

## Upgrading

Re-run the installer. Existing `.claude/skills/` is backed up before overwrite.

## License

Skill content derives from [mattpocock/skills](https://github.com/mattpocock/skills) and [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done); refer to those repos for the underlying licenses.
