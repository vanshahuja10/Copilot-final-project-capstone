# Verification Skill

## Purpose

Verify the implemented Todo application against the approved requirements and implementation plan. Produce only `verification.md`.

## Verification Workflow

1. Read the approved `requirements.md`, `architecture.md`, `design-review.md`, `implementation-plan.md`, and `code-review.md`. If a required artifact is missing, unapproved, or materially conflicting, pause and request human direction.
2. Verify each acceptance criterion AC-01 through AC-14 and each plan task T-01 through T-04. Maintain traceability from every result to its requirement, criterion, or task ID.
3. Run available project tests and focused checks. Verify task create/view/complete/reopen/delete behavior, title validation and data shape, persistence across refresh and reopening in the same browser/device, and responsive behavior at relevant desktop and mobile viewports.
4. Verify security-related requirements, including rendering titles as text rather than HTML, absence of unapproved features or dependencies, and the approved single-user/no-auth scope. Check the application-level title-length rule and accepted storage risks against the approved artifacts; do not invent additional controls or recovery behavior.
5. Record exact commands, browser/environment details, and observable evidence. Mark each check `Pass`, `Fail`, or `Unverified`; distinguish an executed failure from a check that could not be run. Never claim a check passed unless it was actually run and passed.
6. Summarize failures, coverage gaps, and accepted risks. In particular, record DR-02 and its accepted CR-01 malformed-storage case as accepted risks, not as newly discovered requirements. Leave failed or unverified checks visible; do not silently waive them.

## Output

Produce only `verification.md`, with source artifacts, an ID-based results matrix, exact verification evidence, failures and unverified checks, accepted risks, and an overall verification outcome.

## Boundaries

- Do not modify implementation, tests, or approved phase artifacts. Report defects and gaps for the implementation owner.
- Do not create or modify other project files, invent requirements, or perform PR work or later SDLC phases.
