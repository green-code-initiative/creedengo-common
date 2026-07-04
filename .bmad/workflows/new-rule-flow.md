# Workflow - New rule flow

## Goal
Ensure one new rule is tracked as one cross-repository epic, then implemented through repository-specific stories.

## Steps
1. Create the rule proposal in `creedengo-rules-specifications`.
2. Validate Definition of Ready:
   - rule ID
   - explicit acceptance criteria
   - positive/negative examples
   - impacted repositories list
3. Create one epic using `.bmad/templates/epic.md`.
4. Create one story per impacted repository using `.bmad/templates/story.md`.
5. Implement each story in its target repository.
6. Update integration scenarios and matrix in `creedengo-integration-test`.
7. Merge stories/PRs when all local DoD checks are complete.
8. Close epic only when integration matrix is green and evidence is attached.

## Mandatory links
- Epic -> all child stories
- Story -> parent epic + PR
- Integration matrix run -> epic + release train
