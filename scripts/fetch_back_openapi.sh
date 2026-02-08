#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="${ROOT_DIR}/.tmp"
BACK_REPO_DIR="${TMP_DIR}/repo-back"

# Repo config (override via env in GitHub Actions)
BACK_REPO="${BACK_REPO:-Herreran903/medai-backend}"
BACK_BRANCH="${BACK_BRANCH:-main}"
BACK_REPO_URL="${BACK_REPO_URL:-https://github.com/${BACK_REPO}.git}"
BACK_REPO_TOKEN="${BACK_REPO_TOKEN:-${GH_PAT:-}}"

# Output locations inside docs repo
OUT_DIR="${ROOT_DIR}/openapi"
STATIC_OUT_DIR="${ROOT_DIR}/static/openapi"

mkdir -p "${TMP_DIR}" "${OUT_DIR}" "${STATIC_OUT_DIR}"

# If token provided, use authenticated clone (required for private repos)
rm -rf "${BACK_REPO_DIR}"
if [[ -n "${BACK_REPO_TOKEN}" ]]; then
  BACK_REPO_URL="https://x-access-token:${BACK_REPO_TOKEN}@github.com/${BACK_REPO}.git"
fi

echo "Cloning back repo: ${BACK_REPO} (${BACK_BRANCH})"
git clone --depth 1 --branch "${BACK_BRANCH}" "${BACK_REPO_URL}" "${BACK_REPO_DIR}"

# Sanity check: export script must exist
if [[ ! -f "${BACK_REPO_DIR}/scripts/export_openapi.py" ]]; then
  echo "ERROR: export script not found at scripts/export_openapi.py in back repo."
  exit 1
fi

# --- Python env + deps (CI runners don't have FastAPI installed) ---
echo "Setting up Python virtualenv"
(cd "${BACK_REPO_DIR}" && python3 -m venv .venv)
# shellcheck disable=SC1091
source "${BACK_REPO_DIR}/.venv/bin/activate"

echo "Installing backend dependencies"
python -m pip install --upgrade pip

if [[ -f "${BACK_REPO_DIR}/requirements.docs.txt" ]]; then
  pip install -r "${BACK_REPO_DIR}/requirements.docs.txt"
elif [[ -f "${BACK_REPO_DIR}/pyproject.toml" ]]; then
  # Install the package in editable mode is not required; regular install is fine.
  pip install "${BACK_REPO_DIR}"
else
  echo "ERROR: No requirements.docs.txt or pyproject.toml found in backend repo."
  exit 1
fi
# -------------------------------------------------------------------

echo "Generating OpenAPI specs via backend script"
(cd "${BACK_REPO_DIR}" && DOCS_BUILD=1 python scripts/export_openapi.py)

SPEC_DIR="${BACK_REPO_DIR}/openapi"
SPEC_FILES=(
  "gateway.json"
  "ner-transformer.json"
  "ner-bilstm.json"
  "ner-llm.json"
)

for spec in "${SPEC_FILES[@]}"; do
  if [[ ! -f "${SPEC_DIR}/${spec}" ]]; then
    echo "ERROR: Missing spec ${SPEC_DIR}/${spec}"
    exit 1
  fi

  cp "${SPEC_DIR}/${spec}" "${OUT_DIR}/${spec}"
  cp "${SPEC_DIR}/${spec}" "${STATIC_OUT_DIR}/${spec}"
done

# Legacy alias for existing docs page
if [[ -f "${BACK_REPO_DIR}/openapi.json" ]]; then
  cp "${BACK_REPO_DIR}/openapi.json" "${OUT_DIR}/backend.json"
  cp "${BACK_REPO_DIR}/openapi.json" "${STATIC_OUT_DIR}/backend.json"
else
  cp "${SPEC_DIR}/gateway.json" "${OUT_DIR}/backend.json"
  cp "${SPEC_DIR}/gateway.json" "${STATIC_OUT_DIR}/backend.json"
fi

if [[ ! -s "${OUT_DIR}/backend.json" ]]; then
  echo "ERROR: OpenAPI output is missing or empty: ${OUT_DIR}/backend.json"
  exit 1
fi

echo "OpenAPI specs ready at ${OUT_DIR}"
