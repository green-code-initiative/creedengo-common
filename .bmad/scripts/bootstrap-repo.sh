#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BMAD_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  bootstrap-repo.sh <target-repo-path> [repository-id]

Arguments:
  target-repo-path  Path to the repository to initialize
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

TARGET_REPO_PATH="$1"
if [[ ! -d "${TARGET_REPO_PATH}" ]]; then
  echo "Error: target repository path does not exist: ${TARGET_REPO_PATH}" >&2
  exit 1
fi

TARGET_REPO_PATH="$(cd "${TARGET_REPO_PATH}" && pwd)"
REPOSITORY_ID="${2:-$(basename "${TARGET_REPO_PATH}")}"
BMAD_DIR="${TARGET_REPO_PATH}/.bmad"

mkdir -p "${BMAD_DIR}/backlog/stories" "${BMAD_DIR}/quality"

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
fi

DOD_TEMPLATE="${BMAD_ROOT}/templates/dod-checklist.md"
DOD_FILE="${BMAD_DIR}/quality/dod-checklist.md"
if [[ ! -f "${DOD_FILE}" ]]; then
  cp "${DOD_TEMPLATE}" "${DOD_FILE}"
fi

touch "${BMAD_DIR}/backlog/stories/.gitkeep"

echo "BMad scaffold initialized for ${REPOSITORY_ID} at ${BMAD_DIR}"
