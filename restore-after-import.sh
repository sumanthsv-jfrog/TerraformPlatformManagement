#!/usr/bin/env bash
# =============================================================================
# restore-after-import.sh
#
# Moves an environment's module-driven config back after
# ./stash-for-import.sh <env> and a completed import (existingimported.tf
# generated, imports.tf removed, clean `terraform plan`).
#
# Usage:
#   ./restore-after-import.sh prod
# =============================================================================

set -euo pipefail

ENV="${1:?Usage: ./restore-after-import.sh <environment>   e.g. ./restore-after-import.sh prod}"
ENV_DIR="environments/${ENV}"
STASH_DIR="${ENV_DIR}/.import-stash"

if [[ ! -d "$STASH_DIR" ]]; then
  echo "Nothing to restore — ${STASH_DIR} does not exist." >&2
  echo "Did you already run this, or never run ./stash-for-import.sh ${ENV}?" >&2
  exit 1
fi

if [[ -f "${ENV_DIR}/imports.tf" ]]; then
  echo "${ENV_DIR}/imports.tf still exists." >&2
  echo "Finish the import first (terraform apply, confirm a clean terraform plan," >&2
  echo "then rm imports.tf) before restoring the module config." >&2
  exit 1
fi

CONFLICTS=0
shopt -s nullglob dotglob
for item in "$STASH_DIR"/*; do
  name="$(basename "$item")"
  if [[ -e "${ENV_DIR}/${name}" ]]; then
    echo "Conflict: ${ENV_DIR}/${name} already exists — not overwriting. Resolve by hand." >&2
    CONFLICTS=$((CONFLICTS + 1))
    continue
  fi
  mv "$item" "${ENV_DIR}/"
  echo "Restored ${ENV_DIR}/${name}"
done

if [[ "$CONFLICTS" -gt 0 ]]; then
  echo "" >&2
  echo "${CONFLICTS} item(s) left in ${STASH_DIR} due to conflicts above." >&2
  exit 1
fi

rmdir "$STASH_DIR"

cat <<EOF

Done. Now run:

  cd ${ENV_DIR}
  terraform init
  terraform plan

That plan should report no changes until new entries are added to
platform.yaml or projects/*.yaml. Leave any already-imported names out of
those files — they already exist in existingimported.tf.

EOF
