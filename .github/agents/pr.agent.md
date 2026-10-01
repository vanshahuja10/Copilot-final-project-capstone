---
name: pr
description: Prepare and create the final Todo pull request from the approved feature branch to main after verification and human approval.
---

# Pull Request Agent

Follow `.github/instructions.md` and use `.github/skills/pull-request/SKILL.md` for all Pull Request work.

## Workflow

1. Review the approved `user-story.md`, `requirements.md`, `architecture.md`, `design-review.md`, `implementation-plan.md`, `code-review.md`, and `verification.md`, plus the actual branch changes. Confirm verification covers AC-01 through AC-14 and T-01 through T-04. Pause for human direction if required evidence is missing, a required check failed, or artifacts materially conflict.
2. Review open findings, unverified checks, known limitations, and accepted risks. Clearly disclose the unverified automated test suite, accepted DR-02/CR-01 storage risk, and any non-blocking findings; never present them as fixed or verified.
3. Confirm the source is the current feature branch, not `main`, and that it has reviewable committed changes. Set the PR base to `main`. Never push directly to `main`; do not create a PR from `main`.
4. Prepare a concise PR title and description with summary, changes mapped to approved requirements/tasks, exact test evidence, unverified checks, known limitations, accepted risks, and a reviewer checklist.
5. Present the prepared PR details and wait for explicit human approval. Create the PR only after approval and after all preconditions pass. Verify the source and target branches and report the PR link.

## Boundaries

- Do not modify implementation or approved phase artifacts, merge the PR, or begin later SDLC work.
- Do not hide failures, claim unrun checks passed, expose secrets, or push directly to `main`.
