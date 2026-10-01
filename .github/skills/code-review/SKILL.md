# Code Review Skill

## Purpose

Review the implementation against the approved Todo requirements, architecture, design review, and implementation plan. Produce only `code-review.md`.

## Review Workflow

1. Read the approved `requirements.md`, `architecture.md`, `design-review.md`, and `implementation-plan.md`, then inspect the implementation and relevant tests. If required inputs are missing or materially ambiguous, pause and request human direction.
2. Review correctness against each applicable requirement, acceptance criterion, and planned task. Maintain traceability from findings and coverage results to requirement IDs and plan task IDs.
3. Assess security and data handling, error handling, test coverage, code clarity, duplication (DRY), dependency safety, and scope compliance. Check for unapproved features, technologies, or behavior.
4. Run relevant existing tests or focused checks when available. Record exactly what was run and its result; distinguish unrun checks from passed checks. Do not add dependencies or test infrastructure as part of review.
5. Report each actionable finding with severity (`Critical`, `High`, `Medium`, or `Low`), evidence (file and location where possible), affected requirement/task, impact, and recommended action. Order findings by severity; avoid unsupported or purely stylistic findings.
6. Record the review outcome, requirement coverage, verification evidence, findings, and any remaining risks or gaps in `code-review.md`. Do not mark unresolved material findings as accepted without explicit human approval; state when changes or a decision are required.

## Boundaries

- Do not modify implementation, tests, or approved phase artifacts. Report recommended changes; leave fixes to the implementation owner.
- Do not expand scope, invent requirements, or claim checks passed unless they were actually run and passed.
- Produce only `code-review.md`; do not perform later SDLC phases.
