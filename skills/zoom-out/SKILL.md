---
name: zoom-out
description: Tell the agent to zoom out and give broader context or a higher-level perspective. Use when you're unfamiliar with a section of code or need to understand how it fits into the bigger picture.
disable-model-invocation: true
---

I don't know this area of code well. Go up a layer of abstraction. Give me a map of all the relevant modules and callers, using the project's domain glossary vocabulary (`.planning/CONTEXT.md` if it exists).

**Start from `.planning/codebase/STRUCTURE.md` and `.planning/graphs/GRAPH_REPORT.md` if they exist** — those are pre-computed maps. Walk the codebase fresh only when the map is missing or stale.
