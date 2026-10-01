# Requirements Analysis Skill

## Purpose

Translate the approved `user-story.md` into clear, testable requirements in `requirements.md`. Work only on requirements analysis.

## Workflow

1. Read the complete `user-story.md` and identify its actors, goals, workflows, constraints, and stated outcomes. Treat it as the source of truth.
2. Identify ambiguous, missing, or conflicting details that affect scope or testability. Ask the human concise clarification questions before resolving them; do not silently assume answers. Pause requirements finalization until material questions are answered.
3. Define functional requirements for observable system behavior and non-functional requirements for stated quality attributes or constraints. Make each requirement specific, singular, and verifiable. Do not add requirements unsupported by the story or human clarification.
4. Define testable acceptance criteria for the requirements. List assumptions separately and label their source or approval. Record explicit out-of-scope items; do not use this section to introduce new product decisions.
5. Maintain traceability by assigning stable requirement IDs and referencing the relevant user-story statement or section for each requirement and acceptance criterion.
6. Before producing `requirements.md`, verify that all story goals and stated constraints are covered, each requirement has a source and a way to verify it, acceptance criteria are testable, and assumptions and exclusions are explicit. Flag unresolved gaps rather than filling them in.

## Output
Produce only `requirements.md` as the phase artifact; do not modify other project files.
, with sections for functional requirements, non-functional requirements, acceptance criteria, assumptions, out-of-scope items, and any approved open questions. Use stable IDs and source references throughout.

## Boundaries

- Never invent requirements, scope, or user-story details. Seek human clarification when needed.
- Never implement code or perform design, planning, or testing-phase work.
- Do not claim completeness while material ambiguities or traceability gaps remain.
