#!/usr/bin/env bash
# =============================================================================
# stash-for-import.sh
#
# Temporarily moves an environment's module-driven config out of the way
# before generating Terraform import blocks for its existing JFrog resources.
#
# terraform plan -generate-config-out writes a plain, standalone copy of
# every resource it imports. If main.tf is still present and already
# declares those same objects (via the shared modules), Terraform tries to
# create them a second time instead of adopting the real ones. So main.tf,
# locals.tf, outputs.tf, platform.yaml, and projects/ all need to be out of
# the directory for the import step, then back afterwards.
#
# providers.tf, variables.tf, and backend.tf are left alone — the import
# step still needs them to connect to this environment's JPD and S3 state.
#
# Usage:
#   ./stash-for-import.sh prod
#
# Undo with:
#   ./restore-after-import.sh prod
# =============================================================================

set -euo pipefail

ENV="${1:?Usage: ./stash-for-import.sh <environment>   e.g. ./stash-for-import.sh prod}"
ENV_DIR="environments/${ENV}"
STASH_DIR="${ENV_DIR}/.import-stash"

if [[ ! -d "$ENV_DIR" ]]; then
  echo "No such environment directory: ${ENV_DIR}" >&2
  exit 1
fi

if [[ -d "$STASH_DIR" ]]; then
  echo "${STASH_DIR} already exists." >&2
  echo "Either an import is already in progress, or a previous run didn't finish." >&2
  echo "Run ./restore-after-import.sh ${ENV} first if that's left over from before." >&2
  exit 1
fi

mkdir -p "$STASH_DIR"

MOVED=0
for item in main.tf locals.tf outputs.tf platform.yaml projects; do
  if [[ -e "${ENV_DIR}/${item}" ]]; then
    mv "${ENV_DIR}/${item}" "${STASH_DIR}/"
    echo "Stashed ${ENV_DIR}/${item} -> ${STASH_DIR}/${item}"
    MOVED=$((MOVED + 1))
  fi
done

if [[ "$MOVED" -eq 0 ]]; then
  echo "Nothing to stash — ${ENV_DIR} had none of main.tf/locals.tf/outputs.tf/platform.yaml/projects/." >&2
  rmdir "$STASH_DIR"
  exit 1
fi

cat <<EOF

Done. ${ENV_DIR} now has no module wiring in it — safe to generate imports:

  cd ${ENV_DIR}
  export ARTIFACTORY_URL="..."
  export ARTIFACTORY_TOKEN="..."
  ../../GeneratePlatformImports.sh
  terraform init -backend-config=../../backend-configs/s3-${ENV}.hcl
  terraform plan -generate-config-out=existingimported.tf
  terraform apply
  terraform plan   # should report no changes
  rm imports.tf
  terraform plan   # should still report no changes

When that's clean, from the repo root run:

  ./restore-after-import.sh ${ENV}

EOF
