# creedengo-common

This repository is the shared source of truth for:

- common documentation (`doc/`)
- shared utility scripts (`tools/`)
- BMad templates, catalogs and workflows (`.bmad/`)

## BMad hub

The `.bmad/` directory is the bootstrap and process hub for the Creedengo organization.

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
