# Architecture Skill

## Purpose

Use approved `requirements.md` to produce a simple, traceable solution architecture in `architecture.md`. Work only on the Architecture phase.

## Workflow

1. Review the complete, approved `requirements.md`. If it is missing, unapproved, or materially ambiguous, pause and request human direction; do not invent requirements.
2. Recommend the simplest suitable architecture that satisfies the requirements. Avoid unnecessary technologies, components, integrations, and features.
3. Identify the architecture's components and each component's responsibility. Describe the data flow between them and how required data, including persistence, is handled.
4. Document technology choices with concise rationale tied to requirements and known project constraints. Mark unknowns as open decisions rather than assuming them.
5. Identify relevant constraints, dependencies, and material technical risks, without expanding product scope.
6. Maintain traceability by mapping every approved requirement ID to the component or architectural decision that satisfies it. Before producing `architecture.md`, verify that every approved requirement is addressed and that no unsupported feature or technology has been introduced.

## Output

Produce only `architecture.md` as the phase artifact. Include the architecture recommendation, components and responsibilities, data flow and persistence, technology choices and rationale, constraints and risks, and a requirement traceability map.

## Boundaries

- Do not implement code or modify other phase artifacts.
- Do not perform design review, project planning, or work belonging to later SDLC phases.
- Do not claim requirement coverage unless each approved requirement has been checked against the architecture.
