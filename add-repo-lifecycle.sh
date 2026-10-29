#!/usr/bin/env bash
# =============================================================================
# add-repo-lifecycle.sh
#
# terraform plan -generate-config-out never writes lifecycle blocks -- it
# only writes real attribute values. So every artifactory_*_repository
# resource it generates into existingimported.tf hardcodes whatever
# project_key / project_environments that repo had at import time (usually
# null / []). Without a lifecycle block ignoring those two attributes, the
# next terraform plan after you assign that repo to a project (in
# platform.yaml or projects/<project>.yaml) would try to silently revert
# the assignment back to null.
#
# Run this once after every `terraform plan -generate-config-out=
# existingimported.tf` (step 2 of "Importing existing resources" in the
# README) -- including re-runs later when importing newly discovered
# repos, since -generate-config-out overwrites the whole file and drops
# any lifecycle blocks added by a previous run of this script.
#
# Idempotent: a repository resource that already has a lifecycle block is
# left untouched, so re-running this is always safe.
#
# Usage:
#   ./add-repo-lifecycle.sh prod
# =============================================================================

set -euo pipefail

ENV="${1:?Usage: ./add-repo-lifecycle.sh <environment>   e.g. ./add-repo-lifecycle.sh prod}"
FILE="environments/${ENV}/existingimported.tf"

if [[ ! -f "$FILE" ]]; then
  echo "No such file: ${FILE}" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required (used only for reliable brace-depth matching)." >&2
  exit 1
fi

python3 - "$FILE" <<'PYEOF'
import re
import sys

path = sys.argv[1]
with open(path) as f:
    lines = f.readlines()

header_re = re.compile(r'^resource "artifactory_[A-Za-z0-9_]*_repository" "[A-Za-z0-9_]+" \{')
lifecycle_re = re.compile(r'^\s*lifecycle\s*\{')

out = []
i = 0
n = len(lines)
added = 0
skipped = 0

while i < n:
    line = lines[i]
    out.append(line)
    if header_re.match(line):
        depth = line.count('{') - line.count('}')
        block = []
        has_lifecycle = False
        i += 1
        while depth > 0:
            l = lines[i]
            if lifecycle_re.match(l):
                has_lifecycle = True
            depth += l.count('{') - l.count('}')
            if depth == 0:
                if has_lifecycle:
                    skipped += 1
                else:
                    block.append('  lifecycle {\n')
                    block.append('    ignore_changes = [project_key, project_environments]\n')
                    block.append('  }\n')
                    added += 1
                block.append(l)
            else:
                block.append(l)
            i += 1
        out.extend(block)
        continue
    i += 1

with open(path, 'w') as f:
    f.writelines(out)

print(f"Added lifecycle block to {added} repository resource(s); {skipped} already had one.")
PYEOF
