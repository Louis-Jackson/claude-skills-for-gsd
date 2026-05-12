# {{PROJECT_NAME}} — Project-Level Instructions

> Customise the placeholders below. The grill-fast / standing-indices sections
> are project-agnostic and ready to use as-is.

# Language
Always respond in zh-CN. Use zh-CN for all explanations, comments, and communications with the user. Technical terms and code identifiers should remain in their original form.

## Workflow: grill-fast over GSD discuss/research

For phases with architectural or naming decisions, **prefer the grill-fast path**:

```
/grill-with-docs            ← challenge naming/boundary, update glossary & ADR
  ▼  (writes .planning/phases/{N}/PRD.md)
/gsd-plan-phase {N} --prd .planning/phases/{N}/PRD.md --skip-research
  ▼
/gsd-execute-phase {N} → /gsd-verify-work
```

This **replaces** `gsd-discuss-phase` + `gsd-phase-researcher` + `gsd-pattern-mapper` for these phases. Rationale: those agents are slow and the output drifts from what's wanted. Grill is direct, adversarial, and codebase-aware.

### When to use which path

| Path | Use when |
|---|---|
| **grill-fast** (above) | Phase introduces new domain concepts, technology lock-in, cross-phase boundary changes, or "I haven't fully thought this through" |
| **plain GSD** (`/gsd-discuss-phase` → `/gsd-plan-phase`) | Phase is implementation-detail only, scope is concrete, no new naming |
| **gsd-fast / gsd-quick** | Trivial single-step task |
| `/improve-codebase-architecture` | End of milestone, major transition, or "code feels muddy" |
| `/zoom-out` | Lost in an unfamiliar code area; want a high-level map |
| `/grill-me` | Quick design conversation, no doc updates needed |

## Standing indices (not phases, but consulted by every skill)

Two pre-computed indices live alongside `.planning/` and are read by all 4 skills above as pre-flight context:

| Index | Origin | Refresh trigger |
|---|---|---|
| `.planning/codebase/{ARCHITECTURE,CONCERNS,CONVENTIONS,INTEGRATIONS,STACK,STRUCTURE,TESTING}.md` | `/gsd-map-codebase` (parallel mapper agents) | Major refactor / new milestone / "feels stale" |
| `.planning/graphs/{graph.json,graph.html,GRAPH_REPORT.md}` | `/graphify` (knowledge graph build) | Large file moves / module reorg / new top-level dirs |

**These do NOT appear in `ROADMAP.md`** — they're standing references, not phases. They are read; they don't drive phase ordering. Skills will silently skip them if absent.

**When to refresh:** if a skill notices the indices are meaningfully out-of-date (e.g. references files that no longer exist, or misses a recent top-level module), it should tell the user and suggest re-running `/gsd-map-codebase` or `/graphify` before continuing — but not block.

## File conventions (avoid same-name confusion)

| File | Purpose | Scope | Written by |
|---|---|---|---|
| `.planning/CONTEXT.md` | **Project domain glossary** (key terms + relationships) | Long-lived, cross-phase | `/grill-with-docs` |
| `.planning/CONTEXT-MAP.md` | Multi-context router (only if project splits into sub-contexts) | Long-lived | `/grill-with-docs` |
| `.planning/adrs/00NN-*.md` | Hard architectural decisions (3 criteria: hard-to-reverse / surprising / real trade-off) | Long-lived | `/grill-with-docs`, `/improve-codebase-architecture` |
| `.planning/phases/{N}/PRD.md` | Grilled decisions for one phase, fed to `--prd` | Phase-scoped | `/grill-with-docs` (end of session) |
| `.planning/phases/{N}/CONTEXT.md` | **Phase-scoped GSD decision record** (NOT a glossary) | Phase-scoped | `gsd-discuss-phase` or `--prd` express path |
| `.planning/phases/{N}/PLAN.md` | Task breakdown for execution | Phase-scoped | `gsd-planner` |

**Critical:** `.planning/CONTEXT.md` (glossary) and `.planning/phases/{N}/CONTEXT.md` (phase decisions) share a name but have different purposes. Do not conflate.

## Skills location

Project-level skills live in `.claude/skills/`:

- `grill-me/` — adversarial interview (no file output)
- `grill-with-docs/` — adversarial interview + maintains `.planning/CONTEXT.md` + `.planning/adrs/` + outputs PRD.md
- `zoom-out/` — "go up a layer of abstraction"
- `improve-codebase-architecture/` — find deepening opportunities (Ousterhout vocabulary)

These are local copies of [`mattpocock/skills`](https://github.com/mattpocock/skills), path-patched to use `.planning/` paths instead of root-level `CONTEXT.md` / `docs/adr/`. Installed via [`gsd-skills`](https://github.com/Louis-Jackson/gsd-skills). **Do not run `npx skills@latest add mattpocock/skills`** — it would install a different (global) copy and re-introduce the path conflicts.

---

## {{Project-specific section — customise below}}

<!-- Examples of what to put here:
  - tech stack quirks the agent should know (e.g. "we use uv, not pip")
  - product-line decisions (e.g. "v1 is being retired, all new work targets v2")
  - irreversible architectural choices that aren't yet in ADRs
  - team conventions (e.g. "commits go to dev/{name}, never main directly")
-->
