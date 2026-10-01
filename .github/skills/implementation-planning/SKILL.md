# Implementation Planning Skill

## Purpose

Turn the approved `requirements.md`, `architecture.md`, and `design-review.md` into a dependency-ordered implementation plan. Work only on planning; do not implement code.

## Workflow

1. Read all three complete, approved phase artifacts. If an input is missing, unapproved, or materially ambiguous, pause and request human direction.
2. Extract approved requirements, architecture decisions, review findings, accepted risks, and required decisions. Do not invent or resolve product decisions. Represent unresolved decisions as explicit human-owned prerequisites or blockers; do not schedule dependent implementation work as ready.
3. Break work into small, ordered tasks with stable IDs. For each task, state its goal and scope, dependencies, linked requirement IDs, and concrete verification steps. Keep scope within the approved requirements and architecture.
4. Map every approved requirement to one or more plan tasks and verification steps. Include relevant accepted risks and design-review actions without treating accepted risks as new requirements.
5. Define human approval gates, including approval of the plan before implementation begins and any required decision or phase handoff. State what evidence is needed at each gate. Do not claim a planned check has already been run.
6. Verify the plan is dependency-ordered, every requirement is traceable to work and verification, blockers are explicit, and no task relies on an invented decision before producing the artifact.

## Output

Produce only `implementation-plan.md`. Include source artifacts, prerequisites and blockers, ordered tasks with scope/dependencies/traceability/verification, a requirement coverage map, and human approval gates.

## Boundaries

- Do not implement code, modify approved source artifacts, or perform implementation or later SDLC phases.
- Do not claim verification has passed unless it has actually been run and passed.
