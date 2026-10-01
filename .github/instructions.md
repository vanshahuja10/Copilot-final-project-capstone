# Global SDLC Instructions

- Treat the approved user story and approved phase artifacts as the source of truth. If required inputs are missing or conflict, pause and ask for human direction; do not invent scope.
- For each phase, use its designated skill and produce only that phase's requested outputs. Keep the Todo application simple and within the approved scope.
- Obtain human approval at required phase gates. Verify each phase's outputs against its criteria before proceeding; do not advance past a gate without approval.
- Maintain traceability across artifacts by linking requirements, decisions, designs, implementation, and verification evidence.
- Never expose, commit, or reproduce secrets. Use approved secure handling for credentials and sensitive values.
- Never work directly on `main`. Perform all development work on the designated feature branch. The final pull request must target `main`.
- Report verification accurately: claim a check passed only when it was run and passed. State unverified items, failures, and blockers plainly.
- Do not modify an already approved phase artifact unless the current phase identifies a necessary change and human approval is obtained.