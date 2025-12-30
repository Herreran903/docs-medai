#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="${ROOT_DIR}/.tmp"
BACK_REPO_DIR="${TMP_DIR}/repo-back"

BACK_OPENAPI_URL="${BACK_OPENAPI_URL:-}"
BACK_OPENAPI_PATH="${BACK_OPENAPI_PATH:-openapi.json}"
BACK_REPO="${BACK_REPO:-ORG/repo-back}"
BACK_REF="${BACK_REF:-main}"
BACK_REPO_URL="${BACK_REPO_URL:-https://github.com/${BACK_REPO}.git}"
BACK_REPO_TOKEN="${BACK_REPO_TOKEN:-${GH_PAT:-}}"

OUT_DIR="${ROOT_DIR}/openapi"
OUT_FILE="${OUT_DIR}/backend.json"

mkdir -p "${TMP_DIR}" "${OUT_DIR}"

if [[ -n "${BACK_OPENAPI_URL}" ]]; then
  echo "Downloading OpenAPI spec from URL"
  curl -fsSL "${BACK_OPENAPI_URL}" -o "${OUT_FILE}"
else
  rm -rf "${BACK_REPO_DIR}"
  if [[ -n "${BACK_REPO_TOKEN}" ]]; then
    BACK_REPO_URL="https://x-access-token:${BACK_REPO_TOKEN}@github.com/${BACK_REPO}.git"
  fi

  echo "Cloning back repo: ${BACK_REPO} (${BACK_REF})"
  git clone --depth 1 --branch "${BACK_REF}" "${BACK_REPO_URL}" "${BACK_REPO_DIR}"

  if [[ ! -f "${BACK_REPO_DIR}/${BACK_OPENAPI_PATH}" ]]; then
    echo "ERROR: OpenAPI file not found at ${BACK_OPENAPI_PATH} in back repo."
    exit 1
  fi

  cp "${BACK_REPO_DIR}/${BACK_OPENAPI_PATH}" "${OUT_FILE}"
fi

if [[ ! -s "${OUT_FILE}" ]]; then
  echo "ERROR: OpenAPI output is missing or empty: ${OUT_FILE}"
  exit 1
fi

echo "OpenAPI spec ready at ${OUT_FILE}"
