# Implementation Skill

## Purpose

Implement only the tasks in the approved `implementation-plan.md`, using approved `requirements.md`, `architecture.md`, and `design-review.md` as constraints. Follow `.github/instructions.md`.

## Workflow

1. Read all four approved artifacts. Confirm the plan approval gate and prerequisites are satisfied. If an input is missing, unapproved, conflicting, or blocked, pause and ask for human direction.
2. Implement tasks in dependency order and within their stated scope. Trace each change and its verification to the linked requirement IDs. Do not add features, technologies, dependencies, or product behavior not approved by those artifacts.
3. Follow the architecture and repository conventions. Keep changes small and maintainable; avoid unnecessary abstractions and dependencies. Work only on the feature branch, never directly on `main`.
4. Preserve the approved task contract: required string `title`; reject empty or whitespace-only titles; assign a unique `id`; store boolean `completed`; initialize new tasks as incomplete; render titles as text, never HTML; impose no application-level title-length cap. Do not trim or normalize otherwise valid titles unless an approved decision specifies it.
5. Handle errors according to approved requirements and architecture. DR-02 accepts that browser storage may be unavailable or cleared without requiring a recovery flow; do not invent one. If a new material error decision is needed, pause for human approval.
6. Run focused verification for each task and the planned acceptance checks AC-01 through AC-14. Use existing project tooling; request approval before adding dependencies or test infrastructure not in the plan. Report actual commands, outcomes, failures, and unrun checks accurately.
7. Before handoff, verify requirement traceability, task scope, tests, and the plan's completion gate. Do not proceed to a later phase without required human approval.

## Boundaries

- Do not change approved requirements, architecture, design-review, or implementation-plan artifacts without necessary human approval.
- Do not expose or commit secrets, claim unrun checks passed, or expand scope to resolve unspecified behavior.
