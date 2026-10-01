# Requirements: Basic Todo List

## Source and Traceability

- **US** refers to the approved `user-story.md`.
- **H1**: Human confirmation that `user-story.md` is the approved source of truth.
- **H2**: Human clarification that persistence applies to the same browser and device.
- **H3**: Human clarification that completed/incomplete status persists across refresh and reopen.
- **H4**: Human-approved task contract (2026-10-01): required string title; reject empty or whitespace-only titles; no maximum title length; unique identifier; boolean `completed`; new tasks start incomplete; render titles as text, not HTML.
- Requirement IDs (`FR`, `NFR`), acceptance-criterion IDs (`AC`), assumption IDs (`A`), and out-of-scope IDs (`OOS`) are stable identifiers for this artifact.

## Functional Requirements

| ID | Requirement | Source |
|---|---|---|
| FR-01 | The application shall allow the user to create a task in the single task list. | US: User Story; Core Capabilities 1; Constraints: one task list. H1 |
| FR-02 | The application shall display all tasks in the task list, including tasks marked complete and incomplete. | US: Core Capabilities 2-4; Expected Outcome. H1 |
| FR-03 | The application shall allow the user to mark a task complete and to mark a completed task incomplete. | US: Core Capabilities 3-4; Expected Outcome. H1 |
| FR-04 | The application shall allow the user to delete a task from the task list. | US: Core Capabilities 5; Expected Outcome. H1 |
| FR-05 | The application shall retain tasks and each task's completed/incomplete status across a browser refresh and after the application is reopened in the same browser on the same device. | US: Constraints: tasks remain available on refresh/reopen; Expected Outcome. H2, H3 |
| FR-06 | Each task shall have a required string title. | H4 |
| FR-07 | The application shall reject a title that is empty or consists only of whitespace. | H4 |
| FR-08 | Each task shall have a unique identifier. | H4 |
| FR-09 | Each task's `completed` value shall be a boolean. | H4 |
| FR-10 | A newly created task shall have `completed` set to `false`. | H4 |
| FR-11 | The application shall render task titles as text and shall not interpret them as HTML. | H4 |

## Non-Functional Requirements

| ID | Requirement | Source |
|---|---|---|
| NFR-01 | The application shall support a single user and one task list; authentication and collaboration or multi-user functionality are not required. | US: Constraints. H1 |
| NFR-02 | The application shall remain focused on the core Todo functionality: creating, viewing, completing, reopening, and deleting tasks. | US: Core Capabilities; Constraints: simple and focused; Expected Outcome. H1 |
| NFR-03 | The application shall not impose an application-level maximum title length. | H4 |

## Acceptance Criteria

| ID | Requirement(s) | Given / When / Then | Source |
|---|---|---|---|
| AC-01 | FR-01 | Given the task list is available, when the user creates a task, then that task is present in the task list. | US: Core Capabilities 1; Expected Outcome |
| AC-02 | FR-02 | Given one or more tasks exist in the list, when the user views the list, then every task still in the list is displayed, regardless of its completed/incomplete status. | US: Core Capabilities 2-4 |
| AC-03 | FR-03 | Given an incomplete task, when the user marks it complete, then it is marked complete; when the user marks that completed task incomplete, then it is marked incomplete. | US: Core Capabilities 3-4 |
| AC-04 | FR-04 | Given a task exists in the list, when the user deletes it, then it is no longer present in the list. | US: Core Capabilities 5 |
| AC-05 | FR-05 | Given a task exists in the list, when the user refreshes the browser, then the task and its current status remain available. | US: Constraints: refresh; H2, H3 |
| AC-06 | FR-05 | Given a task exists in the list, when the user closes and reopens the application in the same browser on the same device, then the task and its current status remain available. | US: Constraints: reopen; Expected Outcome; H2, H3 |
| AC-07 | NFR-01 | Given a user opens the application, when they use the core task capabilities, then no authentication is required and the application provides one task list without collaboration or multi-user functionality. | US: Constraints |
| AC-08 | NFR-02 | When the application's supported capabilities are reviewed, then they are limited to creating tasks, viewing all tasks, changing completion status, and deleting tasks; categories, priorities, due dates, and task search are not provided. | US: Core Capabilities; Constraints |
| AC-09 | FR-06 | Given a task is created with a valid title, when its task record is stored, then its title value is a string. | H4 |
| AC-10 | FR-07 | Given a title is empty or contains only whitespace, when the user submits it, then the application rejects it and creates no task. | H4 |
| AC-11 | FR-08 | Given multiple tasks exist, when their records are inspected, then each has an identifier and no two tasks share the same identifier. | H4 |
| AC-12 | FR-09, FR-10 | Given a task is created and then changed between completion states, when its record is inspected at each state, then `completed` is a boolean and its initial value was `false`. | H4 |
| AC-13 | FR-11 | Given a title contains characters that resemble HTML markup, when the task is displayed, then the title appears as text and is not interpreted as markup. | H4 |
| AC-14 | NFR-03 | Given a title is within available browser storage capacity, when the user creates a title longer than any ordinary short title, then the application does not reject or truncate it because of an application-defined length limit. | H4 |

## Assumptions

| ID | Assumption / clarification | Source or approval |
|---|---|---|
| A-01 | Persistence is required within the same browser and on the same device; cross-browser or cross-device persistence is not implied. | H2; clarification supplied for this requirements phase. |
| A-02 | A task's completed/incomplete status is part of the persisted task data and must survive both refresh and reopen. | H3; clarification supplied for this requirements phase. |
| A-03 | No trimming or normalization behavior for otherwise valid, non-empty titles is specified; no such behavior is assumed. | H4 does not specify title normalization. |

## Out of Scope

| ID | Exclusion | Source |
|---|---|---|
| OOS-01 | Authentication. | US: Constraints: no authentication required. |
| OOS-02 | Collaboration and multi-user functionality. | US: Constraints. |
| OOS-03 | Categories, priorities, due dates, and task search. | US: Constraints. |
| OOS-04 | Task-list functionality beyond the single list. | US: Constraints: only one task list is required. |

## Approved Open Questions

No material task-contract questions remain after H4. Title normalization for otherwise valid titles remains unspecified as recorded in A-03; no additional behavior is assumed.