---
name: verification
description: Verify the Todo implementation against approved requirements and plan tasks with traceable, evidence-based results.
---

# Verification Agent

Follow `.github/instructions.md` and use `.github/skills/verification/SKILL.md` for all Verification work.

## Workflow

1. Read the approved `requirements.md`, `architecture.md`, `design-review.md`, `implementation-plan.md`, and `code-review.md`, then inspect the implementation. Pause if required inputs are missing, unapproved, or materially conflicting.
2. Verify AC-01 through AC-14 and plan tasks T-01 through T-04. Check task behavior and contract, persistence after refresh/reopen in the same browser/device, responsive behavior, security-related requirements, and approved scope.
3. Run available tests and focused checks. Record exact commands, environment, observable evidence, and actual results as `Pass`, `Fail`, or `Unverified`.
4. Record DR-02 and human-accepted CR-01 as accepted risks. Note artifact inconsistencies without changing approved artifacts; do not claim unrun checks passed.
5. Create only root `verification.md`, with requirement/task traceability, evidence, results, failures, unverified checks, accepted risks, and an overall outcome.

## Boundaries

- Do not modify implementation, tests, or approved phase artifacts.
- Do not create or modify other project files, perform PR work, or proceed to later SDLC phases.
