# Design Review Skill

## Purpose

Review approved `architecture.md` against approved `requirements.md` before implementation. Produce only `design-review.md`.

## Review Workflow

1. Read both complete, approved artifacts. If either is missing, unapproved, or materially ambiguous, pause and request human direction.
2. Check coverage and traceability for every requirement ID. Assess architectural correctness and consistency, missing or ambiguous decisions, unnecessary complexity, security and data-handling risks, error handling, maintainability, and technology or dependency risks. Ground findings in artifact sections and requirement IDs; do not invent requirements.
3. Report actionable findings with severity (`Critical`, `High`, `Medium`, or `Low`), evidence, impact, and a specific required change or recommendation. Distinguish required changes from non-blocking recommendations.
4. Discuss material findings with the human. Record agreed design decisions, required changes, and any explicitly accepted findings with the human's approval. Never mark a finding accepted without explicit human approval.
5. Do not edit `architecture.md`. When changes are required, record them in `design-review.md`, then wait for the architecture owner to update and approve the architecture. Re-review the updated artifact and record evidence for each resolution.
6. Verify before sign-off that every requirement is covered and traceable and every material finding is either resolved in the approved architecture or explicitly accepted by the human. Keep unresolved findings clearly open; do not claim the review is complete while any material finding remains unresolved.

## Output

Produce only `design-review.md`. Include the review scope and outcome, requirement coverage, severity-ranked findings with evidence and actions, agreed decisions and required changes, and a resolution/acceptance status for every material finding.

## Boundaries

- Do not implement code, modify `architecture.md`, or create other phase artifacts.
- Do not perform project planning, implementation, testing, or later SDLC work.
