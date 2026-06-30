# creedengo-common

This repository is the shared source of truth for:

- common documentation (`doc/`)
- shared utility scripts (`tools/`)
- BMad templates, catalogs and workflows (`.bmad/`)

## BMad hub

The `.bmad/` directory is the bootstrap and process hub for the Creedengo organization.

BMAD (Build More Architect Dreams) is an AI-assisted agile framework: it structures work with reusable artifacts (epics, stories, DoD, workflows) to coordinate delivery across repositories.
Official documentation: https://github.com/bmad-code-org/BMAD-METHOD

`creedengo-common` is process-only in this model: it does not provide shared runtime libraries or direct Maven dependencies for other repositories.
Technical sharing stays in:
- `creedengo-rules-specifications` (rules/spec artifacts)
- `creedengo-integration-test` (integration test artifacts)

Target future norm for SonarQube plugin repositories: all plugins should depend on both `creedengo-rules-specifications` and `creedengo-integration-test`.
Current real state is also tracked in `.bmad/catalog/dependencies.yaml` under:
- `plugins.maven_dependencies_observed_locally_from_pom_xml`
- `plugins.repositories_without_matching_pom_dependency`
- `plugins.repositories_without_pom_xml_locally`
- `plugins.repositories_observed_with_non_maven_build` (e.g. `creedengo-android-kotlin`)

### Structure

- `.bmad/catalog/repositories.yaml`: repository inventory and ownership
- `.bmad/catalog/dependencies.yaml`: cross-repository dependency map
- `.bmad/templates/`: epic/story/DoD/release-train templates
- `.bmad/workflows/`: operational flows for new rules and release trains
- `.bmad/scripts/bootstrap-repo.sh`: scaffold initializer for `.bmad/` in other repositories

### Bootstrap another repository

From this repository root:

```bash
./.bmad/scripts/bootstrap-repo.sh ../creedengo-java
```

Optional repository id:

```bash
./.bmad/scripts/bootstrap-repo.sh ../creedengo-java creedengo-java
```
