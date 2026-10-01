# Architecture: Basic Todo List

## Recommendation

Build a small, client-side browser application with one task list and browser `localStorage` as its persistence layer. Use standard browser technologies (HTML, CSS, and JavaScript) without a server, account system, or external service. This is sufficient for the required single-user, same-browser-and-device scope and keeps the architecture focused on the core Todo capabilities.

## Components and Responsibilities

| Component | Responsibility |
|---|---|
| Task list interface | Present every stored task, including completed and incomplete tasks; expose the core task actions. |
| Task state and operations | Maintain the one in-memory task collection and apply create, completion-status changes in either direction, and deletion. |
| Browser persistence adapter | Load and save the collection using `localStorage`, so it is available after refresh and reopening in the same browser on the same device. |

Each persisted task has a unique `id`, a required string `title`, and a boolean `completed` value. New tasks start with `completed` set to `false`. Reject titles that are empty or consist only of whitespace. Do not impose an application-level maximum title length. The interface renders titles as text, never as HTML. These choices implement H4 and FR-06 through FR-11. No other task attributes are implied. Trimming or normalization of otherwise valid titles is unspecified by H4 and is not added here.

## Data Flow and Persistence

1. On application startup, the persistence adapter reads the saved task collection from `localStorage` and supplies it to task state.
2. The interface renders all tasks from that state without filtering by completion status.
3. On task creation, task state validates the title, assigns a unique identifier, and sets `completed` to `false`; completion-status changes and deletion update the same state. The updated collection is saved to `localStorage` and the interface reflects that state, rendering title values only as text.
4. On refresh or reopening in the same browser and on the same device, startup reads the saved collection, including each task's completion status.

There is one local collection and no synchronization between browsers or devices. Authentication, collaboration, a server API, and a remote database are not needed for the approved scope.

## Technology Choices

| Choice | Rationale |
|---|---|
| Client-side browser application | The requirements are browser-oriented and call for one user and one list, with no server-side or shared capabilities. |
| HTML, CSS, and JavaScript, without a required framework | These standard browser capabilities are sufficient for the small interaction and avoid adding a dependency not justified by the requirements. |
| `localStorage` | Provides persistence across refresh and reopening in the same browser/device without introducing a backend or account. Store the task collection in a serialized form. |

## Constraints and Risks

- Persistence is limited to the same browser and device. Clearing browser site data, using a different browser/profile, or moving to another device can make this locally stored list unavailable; cross-browser/device recovery is not required.
- Browser storage is finite and can be unavailable or cleared by the environment. The requirements do not define a recovery or storage-error experience.
- H4 does not specify trimming or normalization of otherwise valid titles (A-03); the architecture adds no such behavior. The application has no title-length cap, but browser storage remains finite.
- Task titles are user-provided data; rendering them as text rather than HTML avoids treating title content as executable markup.
- The architecture assumes a browser runtime. The requirements do not name a specific browser-support matrix or deployment host.

## ## Unspecified Behavior

- **Title normalization:** H4 does not specify whether otherwise valid title strings are trimmed or normalized. No normalization behavior is assumed by this architecture.

## Requirement Traceability

| Requirement | Architectural coverage |
|---|---|
| FR-01 | Task list interface and task state support creating a task in the single collection, using the approved task contract in FR-06 through FR-10. |
| FR-02 | The interface renders the full collection without filtering on completion status. |
| FR-03 | Task state supports changing completion status in both directions, and the persistence adapter stores that status. |
| FR-04 | Task state supports removing a task from the collection, and the interface reflects the updated collection. |
| FR-05 | The persistence adapter saves and reloads tasks and their completion status through `localStorage` across refresh and reopening in the same browser/device. |
| FR-06 | Task records contain a required string `title`. |
| FR-07 | Task state rejects empty and whitespace-only titles. |
| FR-08 | Each task record has a unique `id`. |
| FR-09 | Task records store completion state as a boolean. |
| FR-10 | Task creation initializes `completed` to `false`. |
| FR-11 | The interface renders titles as text, not HTML. |
| NFR-01 | The client-only, single-collection architecture has no authentication, collaboration, or multi-user component. |
| NFR-02 | The architecture includes only creating, viewing all tasks, changing completion status, and deleting tasks; it adds no categories, priorities, due dates, or task search. |
| NFR-03 | No application-level title-length limit is imposed. |

## Architecture Verification

Checked the architecture against every approved requirement ID in `requirements.md`: FR-01 through FR-11 and NFR-01 through NFR-03 are each mapped above. The persistence scope and completed-status persistence match H2 and H3. Task field, validation, initialization, rendering, and length constraints match H4. Title normalization remains unspecified as recorded in A-03. No unsupported product feature, external service, or additional task attribute is introduced.