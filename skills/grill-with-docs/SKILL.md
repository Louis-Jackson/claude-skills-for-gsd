---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (.planning/CONTEXT.md, .planning/adrs/) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions. Output is a markdown decision summary suitable to feed `/gsd-plan-phase --prd`.
---

> 所有面向用户的输出使用**简体中文**。技术术语（代码、路径、CLI 命令、专有名词）保持英文。

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

**At end of session:** offer to write `.planning/phases/{N}/PRD.md` capturing the resolved decisions in a format GSD's `--prd` express path can consume.

</what-to-do>

<supporting-info>

## Pre-flight reading

Before questioning, if these files exist read them once (skip silently if absent):

- `.planning/codebase/STRUCTURE.md` — file tree + entry points
- `.planning/codebase/ARCHITECTURE.md` — system shape and module boundaries
- `.planning/graphs/GRAPH_REPORT.md` — key modules + dependency summary from the knowledge graph

These are pre-computed indices of the current codebase. Use them as a map before doing your own exploration — don't re-walk what's already mapped. If a file looks stale (last commit count diverges meaningfully from the snapshot), tell the user and suggest re-running `/gsd-map-codebase` or `/graphify` before continuing.

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure (MatchMate convention)

```
/
├── .planning/
│   ├── CONTEXT.md                ← project-wide domain glossary
│   ├── adrs/
│   │   ├── 0001-event-sourced-orders.md
│   │   └── 0002-postgres-for-write-model.md
│   ├── phases/
│   │   └── 10-auth/
│   │       ├── PRD.md            ← output of this skill (fed to --prd)
│   │       └── CONTEXT.md        ← phase-scoped decisions (created later by gsd)
│   └── ...
└── src/
```

If `.planning/CONTEXT-MAP.md` exists at the planning root, the repo has multiple contexts. The map points to where each one lives:

```
.planning/
├── CONTEXT-MAP.md
├── adrs/                         ← system-wide decisions
└── contexts/
    ├── ordering/CONTEXT.md
    └── billing/CONTEXT.md
```

Create files lazily — only when you have something to write. If no `.planning/CONTEXT.md` exists, create one when the first term is resolved. If no `.planning/adrs/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `.planning/CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update .planning/CONTEXT.md inline

When a term is resolved, update `.planning/CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Don't couple `.planning/CONTEXT.md` to implementation details. Only include terms that are meaningful to domain experts.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md). ADRs go in `.planning/adrs/` (MatchMate convention; do NOT create `docs/adr/`).

## Handoff to GSD

At end of session, when decisions feel stable, propose writing:

```
.planning/phases/{N}/PRD.md
```

Format: plain markdown with sections like `## Phase Boundary`, `## Decisions`, `## Open Questions`, `## Canonical References`. No fixed template — GSD's `--prd` express path parses requirements freely. Reference the `.planning/adrs/` entries that were created or invoked.

Then suggest:

```
/gsd-plan-phase {N} --prd .planning/phases/{N}/PRD.md --skip-research
```

This skips `gsd-discuss-phase` and `gsd-phase-researcher` entirely — your grilled decisions are the authoritative source.

</supporting-info>
