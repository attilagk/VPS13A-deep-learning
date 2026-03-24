#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

NOTEBOOK_PATH="notebooks/2026-03-20-VPS13A-map-variants.ipynb"
OUTPUT_HTML_PATH="docs/index.html"
CONDA_ENV_NAME="${CONDA_ENV_NAME:-structure-viz}"

if [[ $# -gt 0 ]]; then
  COMMIT_MESSAGE="$*"
else
  COMMIT_MESSAGE="Update $(date +%c): publish VPS13A map variants notebook to GitHub Pages"
fi

if ! command -v conda >/dev/null 2>&1; then
  echo "Error: conda is not available on PATH."
  exit 1
fi

cd "${REPO_ROOT}"

if [[ ! -f "${NOTEBOOK_PATH}" ]]; then
  echo "Error: notebook not found at ${NOTEBOOK_PATH}"
  exit 1
fi

mkdir -p "$(dirname "${OUTPUT_HTML_PATH}")"

conda run -n "${CONDA_ENV_NAME}" jupyter nbconvert \
  --to html \
  "${NOTEBOOK_PATH}" \
  --output "$(basename "${OUTPUT_HTML_PATH}")" \
  --output-dir "$(dirname "${OUTPUT_HTML_PATH}")"

git add -- "${NOTEBOOK_PATH}" "${OUTPUT_HTML_PATH}"

if git diff --cached --quiet; then
  echo "No changes to commit for ${NOTEBOOK_PATH} and ${OUTPUT_HTML_PATH}."
  exit 0
fi

git commit -m "${COMMIT_MESSAGE}"

CURRENT_BRANCH="$(git branch --show-current)"
git push origin "${CURRENT_BRANCH}"

echo "Published ${OUTPUT_HTML_PATH} from ${NOTEBOOK_PATH} on branch ${CURRENT_BRANCH}."
