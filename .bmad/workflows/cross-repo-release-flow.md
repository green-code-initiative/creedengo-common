# Workflow - Cross-repo release flow

## Goal
Coordinate a multi-repository release train with explicit gates and ownership.

## Entry criteria
- Target epics are in progress with linked stories.
- Impacted repositories are identified in epic scope.

## Steps
1. Create release train document from `.bmad/templates/release-train.md`.
2. Freeze scope for the train.
3. Collect repository readiness status:
   - implementation merged
   - CI quality gates green
   - documentation updated
4. Run compatibility matrix validation in `creedengo-integration-test`.
5. Resolve blockers and rerun validations as needed.
6. Hold Go/No-Go review with maintainers.
7. Announce release and archive train notes.

## Exit criteria
- All mandatory quality gates are green.
- Compatibility matrix is green for included plugins.
- Epic statuses are updated and traceable.
