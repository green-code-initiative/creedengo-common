#!/usr/bin/env bash
set -euo pipefail

# Bootstrap utility for Creedengo repositories.
# Purpose:
# - create a minimal `.bmad/` scaffold in a target repository
# - initialize a default `repo-context.yaml`
# - copy the shared DoD checklist from this hub repository
# The script is idempotent for generated files (it does not overwrite existing ones).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BMAD_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  bootstrap-repo.sh <target-repo-path> [repository-id]

Arguments:
  target-repo-path  Path to the repository to initialize (absolute or relative)
  repository-id     Optional repository identifier (defaults to folder name)
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

# 1) Resolve and validate target repository path.
echo "[1/5] Resolving and validating target repository path..."
TARGET_REPO_PATH="$1"
if [[ ! -d "${TARGET_REPO_PATH}" ]]; then
  echo "Error: target repository path does not exist: ${TARGET_REPO_PATH}" >&2
  exit 1
fi

TARGET_REPO_PATH="$(cd "${TARGET_REPO_PATH}" && pwd)"
REPOSITORY_ID="${2:-$(basename "${TARGET_REPO_PATH}")}"
BMAD_DIR="${TARGET_REPO_PATH}/.bmad"
echo "      Target: ${TARGET_REPO_PATH}"
echo "      Repository ID: ${REPOSITORY_ID}"
echo "      BMad dir: ${BMAD_DIR}"

# 2) Create required BMad directories.
echo "[2/5] Creating required BMad directories..."
mkdir -p "${BMAD_DIR}/backlog/stories" "${BMAD_DIR}/quality"

# 3) Generate default repo context only if it does not already exist.
echo "[3/5] Ensuring repo-context.yaml exists..."
REPO_CONTEXT_FILE="${BMAD_DIR}/repo-context.yaml"
if [[ ! -f "${REPO_CONTEXT_FILE}" ]]; then
  cat > "${REPO_CONTEXT_FILE}" <<EOF
version: 1
repository:
  id: ${REPOSITORY_ID}
  role: "Describe the repository role"
  owner: "@team"
  maintainers:
    - "@maintainer"
dependencies:
  upstream:
    - creedengo-common
    - creedengo-rules-specifications
  validation:
    - creedengo-integration-test
links:
  bmad_hub_templates: "../creedengo-common/.bmad/templates"
EOF
  echo "      Created: ${REPO_CONTEXT_FILE}"
else
  echo "      Skipped (already exists): ${REPO_CONTEXT_FILE}"
fi

# 4) Copy shared DoD template once, keeping local customizations safe.
echo "[4/5] Ensuring DoD checklist exists..."
DOD_TEMPLATE="${BMAD_ROOT}/templates/dod-checklist.md"
DOD_FILE="${BMAD_DIR}/quality/dod-checklist.md"
if [[ ! -f "${DOD_FILE}" ]]; then
  cp "${DOD_TEMPLATE}" "${DOD_FILE}"
  echo "      Copied template to: ${DOD_FILE}"
else
  echo "      Skipped (already exists): ${DOD_FILE}"
fi

# 5) Keep backlog/stories tracked in git even when empty.
echo "[5/5] Ensuring stories/.gitkeep exists..."
touch "${BMAD_DIR}/backlog/stories/.gitkeep"
echo "      Ensured: ${BMAD_DIR}/backlog/stories/.gitkeep"

echo "BMad scaffold initialized for ${REPOSITORY_ID} at ${BMAD_DIR}"
