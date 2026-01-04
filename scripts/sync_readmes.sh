#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="${ROOT_DIR}/.tmp"

FRONT_REPO_DIR="${FRONT_REPO_DIR:-${TMP_DIR}/repo-front}"
BACK_REPO_DIR="${BACK_REPO_DIR:-${TMP_DIR}/repo-back}"

FRONT_REPO="${FRONT_REPO:-Herreran903/medai-frontend}"
BACK_REPO="${BACK_REPO:-Herreran903/medai-backend}"

FRONT_REF="${FRONT_REF:-}"
BACK_REF="${BACK_REF:-}"

OUT_DIR="${ROOT_DIR}/docs/overview"
OUT_FRONT="${OUT_DIR}/frontend.md"
OUT_BACK="${OUT_DIR}/backend.md"

mkdir -p "${OUT_DIR}"

readme_from_repo() {
  local repo_dir="$1"
  local repo_label="$2"
  local readme_path="${repo_dir}/README.md"

  if [[ ! -f "${readme_path}" ]]; then
    echo "ERROR: ${repo_label} README not found at ${readme_path}"
    exit 1
  fi

  echo "${readme_path}"
}

github_repo_from_url() {
  local url="$1"
  url="${url%.git}"
  if [[ "${url}" == git@github.com:* ]]; then
    echo "${url#git@github.com:}"
    return
  fi
  if [[ "${url}" == https://github.com/* ]]; then
    echo "${url#https://github.com/}"
    return
  fi
  if [[ "${url}" == http://github.com/* ]]; then
    echo "${url#http://github.com/}"
    return
  fi
  echo ""
}

resolve_repo_meta() {
  local repo_dir="$1"
  local fallback_repo="$2"
  local fallback_ref="$3"

  local origin_url=""
  if origin_url="$(git -C "${repo_dir}" config --get remote.origin.url 2>/dev/null)"; then
    :
  else
    origin_url=""
  fi

  local repo_slug=""
  if [[ -n "${origin_url}" ]]; then
    repo_slug="$(github_repo_from_url "${origin_url}")"
  fi
  if [[ -z "${repo_slug}" ]]; then
    repo_slug="${fallback_repo}"
  fi

  local repo_ref=""
  if [[ -n "${fallback_ref}" ]]; then
    repo_ref="${fallback_ref}"
  else
    repo_ref="$(git -C "${repo_dir}" rev-parse HEAD 2>/dev/null || true)"
  fi

  if [[ -z "${repo_slug}" || -z "${repo_ref}" ]]; then
    echo "ERROR: Could not resolve repo metadata for ${repo_dir}."
    echo "Set FRONT_REPO/BACK_REPO and FRONT_REF/BACK_REF if needed."
    exit 1
  fi

  printf "%s|%s\n" "${repo_slug}" "${repo_ref}"
}

render_markdown() {
  local input_path="$1"
  local output_path="$2"
  local title="$3"
  local label="$4"
  local desc="$5"
  local repo_slug="$6"
  local repo_ref="$7"

  local blob_base="https://github.com/${repo_slug}/blob/${repo_ref}/"
  local raw_base="https://raw.githubusercontent.com/${repo_slug}/${repo_ref}/"

  python3 - "${input_path}" "${output_path}" "${title}" "${label}" "${desc}" "${blob_base}" "${raw_base}" <<'PY'
import re
import sys

input_path, output_path, title, label, desc, blob_base, raw_base = sys.argv[1:]

with open(input_path, "r", encoding="utf-8") as f:
    text = f.read()

lines = text.splitlines()
if lines and lines[0].strip() == "---":
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            text = "\n".join(lines[i + 1 :])
            break

def rewrite_links(pattern, is_image):
    def repl(match):
        prefix = match.group(1)
        target = match.group(2).strip()
        if target.startswith(("http://", "https://", "mailto:", "tel:", "#", "/")):
            return match.group(0)
        if target.startswith("data:"):
            return match.group(0)
        path, frag = (target.split("#", 1) + [""])[:2]
        base = raw_base if is_image else blob_base
        new_target = base + path.lstrip("./")
        if frag:
            new_target += "#" + frag
        return f"{prefix}({new_target})"

    return pattern.sub(repl, text)

image_pattern = re.compile(r"(!\[[^\]]*\])\(([^)]+)\)")
link_pattern = re.compile(r"(?<!\!)(\[[^\]]*\])\(([^)]+)\)")

text = rewrite_links(image_pattern, True)
text = rewrite_links(link_pattern, False)

ref_def_pattern = re.compile(r"^(\[[^\]]+\]:)\s*(\S+)", re.MULTILINE)
def rewrite_ref_defs(match):
    prefix = match.group(1)
    target = match.group(2).strip()
    if target.startswith(("http://", "https://", "mailto:", "tel:", "#", "/")):
        return match.group(0)
    if target.startswith("data:"):
        return match.group(0)
    path, frag = (target.split("#", 1) + [""])[:2]
    new_target = blob_base + path.lstrip("./")
    if frag:
        new_target += "#" + frag
    return f"{prefix} {new_target}"

text = ref_def_pattern.sub(rewrite_ref_defs, text)

frontmatter = (
    "---\n"
    f"title: {title}\n"
    f"sidebar_label: {label}\n"
    f"description: {desc}\n"
    "---\n\n"
)

with open(output_path, "w", encoding="utf-8") as f:
    f.write(frontmatter + text.lstrip())
PY
}

FRONT_README="$(readme_from_repo "${FRONT_REPO_DIR}" "frontend")"
BACK_README="$(readme_from_repo "${BACK_REPO_DIR}" "backend")"

FRONT_META="$(resolve_repo_meta "${FRONT_REPO_DIR}" "${FRONT_REPO:-}" "${FRONT_REF}")"
BACK_META="$(resolve_repo_meta "${BACK_REPO_DIR}" "${BACK_REPO:-}" "${BACK_REF}")"

FRONT_REPO_SLUG="${FRONT_META%%|*}"
FRONT_REPO_REF="${FRONT_META##*|}"
BACK_REPO_SLUG="${BACK_META%%|*}"
BACK_REPO_REF="${BACK_META##*|}"

render_markdown \
  "${FRONT_README}" \
  "${OUT_FRONT}" \
  "Frontend" \
  "Frontend" \
  "Frontend repository README" \
  "${FRONT_REPO_SLUG}" \
  "${FRONT_REPO_REF}"

render_markdown \
  "${BACK_README}" \
  "${OUT_BACK}" \
  "Backend" \
  "Backend" \
  "Backend repository README" \
  "${BACK_REPO_SLUG}" \
  "${BACK_REPO_REF}"

echo "README sync complete:"
echo "- ${OUT_FRONT}"
echo "- ${OUT_BACK}"
