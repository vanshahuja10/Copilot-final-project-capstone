# Pull Request Skill

## Purpose

Prepare and create the final pull request for the approved Todo project. Follow `.github/instructions.md` and treat approved phase artifacts as the source of truth.

## Preconditions

1. Review the approved `user-story.md`, `requirements.md`, `architecture.md`, `design-review.md`, `implementation-plan.md`, `code-review.md`, and `verification.md` together with the implementation.
2. Do not create the PR until verification is complete. Confirm the verification report covers AC-01 through AC-14 and plan tasks T-01 through T-04, and that no required check is failed or silently unverified. Disclose any unverified checks and require human approval for any unresolved gate or blocker.
3. Confirm code-review findings are resolved or explicitly accepted. Carry forward known limitations, accepted risks, and non-blocking findings transparently. Pause for human direction if approved artifacts materially conflict; do not edit them in this phase.
4. Confirm the current source branch is the designated feature branch, never `main`. The PR base/target must be `main`. Never push directly to `main` or create a PR from `main`.
5. Obtain required human approval at the PR gate before creating the PR.

## Pull Request Content

Include:

- A concise summary of the Todo change and the approved scope.
- The changes made, tied to requirements or plan tasks.
- Exact test and verification evidence, including checks that were not run.
- Known limitations and open non-blocking findings.
- Accepted risks, including DR-02 and accepted CR-01, without presenting them as fixed.
- A reviewer checklist for requirement traceability, create/view/complete/reopen/delete behavior, same-browser/device persistence, title validation and text rendering, responsive behavior, and verification evidence.

## Completion

Create only the pull request after all preconditions are satisfied. Verify that its source is the feature branch and its target is `main`; report the PR link and any remaining unverified checks. Do not merge it or begin another SDLC phase.

## Boundaries

- Do not modify implementation or approved phase artifacts as part of PR preparation.
- Do not expand scope, hide failures, claim unrun checks passed, push directly to `main`, or perform merge/release work.
