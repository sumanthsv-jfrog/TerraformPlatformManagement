#!/usr/bin/env bash
# =============================================================================
# migrate_to_modules.sh
# Reads existingimported.tf and generates:
#   1. moved.tf       — moved {} blocks to rename state addresses
#   2. migration.yaml — YAML entries to add to dev.yaml
#
# Usage:
#   ./migrate_to_modules.sh [existingimported.tf]
#
# After running:
#   1. Review moved.tf and migration.yaml
#   2. Append migration.yaml content to your dev.yaml
#   3. Run: terraform plan  (must show 0 to add, 0 to change, 0 to destroy)
#   4. Run: terraform apply
#   5. Delete existingimported.tf and moved.tf
# =============================================================================

set -euo pipefail

INPUT="${1:-existingimported.tf}"
MOVED_FILE="moved.tf"
YAML_FILE="migration.yaml"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

if [[ ! -f "$INPUT" ]]; then
  echo "Error: $INPUT not found"
  exit 1
fi

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║    Module Migration Generator                    ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Input  : ${INPUT}"
echo -e "Outputs: ${MOVED_FILE}, ${YAML_FILE}"
echo ""

# ── Init output files ─────────────────────────────────────────────────────────
cat > "$MOVED_FILE" << 'EOF'
# =============================================================================
# moved.tf
# Tells Terraform that resources have moved from flat blocks into modules.
# No resources are destroyed or recreated — only state addresses change.
#
# After terraform apply succeeds:
#   1. Delete existingimported.tf
#   2. Delete this moved.tf
# =============================================================================

EOF

cat > "$YAML_FILE" << 'EOF'
# =============================================================================
# migration.yaml
# Copy these entries into your dev.yaml under the appropriate top-level keys.
# =============================================================================

EOF

# ── Counters ──────────────────────────────────────────────────────────────────
repos=0; users=0; groups=0; perms=0
xray_sec=0; xray_lic=0; xray_opr=0; watches=0
cur_conds=0; cur_pols=0; skipped=0

# ── Function: process one resource block ──────────────────────────────────────
process_resource() {
  local rtype="$1"
  local tf_name="$2"
  local key="$3"

  case "$rtype" in

    # ── Repositories ──────────────────────────────────────────────────────────
    artifactory_local_docker_v2_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_docker_v2_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_maven_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_maven_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_npm_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_npm_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_pypi_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_pypi_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_helm_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_helm_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_go_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_go_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_generic_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_local_generic_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_local_*_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.${rtype}.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_remote_npm_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_remote_npm_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_remote_maven_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_remote_maven_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_remote_docker_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_remote_docker_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_remote_generic_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_remote_generic_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_remote_*_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.${rtype}.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_virtual_npm_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_virtual_npm_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_virtual_maven_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_virtual_maven_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_virtual_docker_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_virtual_docker_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_virtual_generic_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.artifactory_virtual_generic_repository.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    artifactory_virtual_*_repository | artifactory_federated_*_repository)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = ${rtype}.${tf_name}
  to   = module.repositories.${rtype}.this["${key}"]
}

MOVED
      ((repos++)) || true ;;

    # ── Users ─────────────────────────────────────────────────────────────────
    artifactory_unmanaged_user)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = artifactory_unmanaged_user.${tf_name}
  to   = module.users.artifactory_unmanaged_user.this["${key}"]
}

MOVED
      ((users++)) || true ;;

    # ── Groups ────────────────────────────────────────────────────────────────
    platform_group)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = platform_group.${tf_name}
  to   = module.groups.platform_group.this["${key}"]
}

MOVED
      ((groups++)) || true ;;

    # ── Permissions ───────────────────────────────────────────────────────────
    platform_permission)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = platform_permission.${tf_name}
  to   = module.permissions.platform_permission.this["${key}"]
}

MOVED
      ((perms++)) || true ;;

    # ── Xray Policies ─────────────────────────────────────────────────────────
    xray_security_policy)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_security_policy.${tf_name}
  to   = module.xray_policies.xray_security_policy.this["${key}"]
}

MOVED
      ((xray_sec++)) || true ;;

    xray_license_policy)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_license_policy.${tf_name}
  to   = module.xray_policies.xray_license_policy.this["${key}"]
}

MOVED
      ((xray_lic++)) || true ;;

    xray_operational_risk_policy)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_operational_risk_policy.${tf_name}
  to   = module.xray_policies.xray_operational_risk_policy.this["${key}"]
}

MOVED
      ((xray_opr++)) || true ;;

    # ── Xray Watches ──────────────────────────────────────────────────────────
    xray_watch)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_watch.${tf_name}
  to   = module.xray_watches.xray_watch.this["${key}"]
}

MOVED
      ((watches++)) || true ;;

    # ── Curation Conditions ───────────────────────────────────────────────────
    xray_custom_curation_condition)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_custom_curation_condition.${tf_name}
  to   = module.curation_conditions.xray_custom_curation_condition.this["${key}"]
}

MOVED
      ((cur_conds++)) || true ;;

    # ── Curation Policies ─────────────────────────────────────────────────────
    xray_curation_policy)
      cat >> "$MOVED_FILE" <<MOVED
moved {
  from = xray_curation_policy.${tf_name}
  to   = module.curation_policies.xray_curation_policy.this["${key}"]
}

MOVED
      ((cur_pols++)) || true ;;

    *)
      echo -e "   ${YELLOW}⚠️  Skipping unsupported type: ${rtype}${NC}"
      ((skipped++)) || true ;;
  esac
}

# ── Parse resource blocks ─────────────────────────────────────────────────────
current_type=""
current_tf_name=""
current_key=""
brace_depth=0

while IFS= read -r line; do
  # Match resource declaration
  if [[ "$line" =~ ^resource[[:space:]]+\"([^\"]+)\"[[:space:]]+\"([^\"]+)\" ]]; then
    current_type="${BASH_REMATCH[1]}"
    current_tf_name="${BASH_REMATCH[2]}"
    current_key=""
    brace_depth=0
    continue
  fi

  if [[ -n "$current_type" ]]; then
    # Track brace depth to detect end of top-level block
    opens=$(echo "$line" | tr -cd '{' | wc -c)
    closes=$(echo "$line" | tr -cd '}' | wc -c)
    ((brace_depth += opens - closes)) || true

    # Extract key = "..."
    if [[ -z "$current_key" ]] && [[ "$line" =~ ^[[:space:]]+key[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      current_key="${BASH_REMATCH[1]}"
    fi
    # Extract name = "..." (for users, groups, policies, watches)
    if [[ -z "$current_key" ]] && [[ "$line" =~ ^[[:space:]]+name[[:space:]]*=[[:space:]]*\"([^\"]+)\" ]]; then
      current_key="${BASH_REMATCH[1]}"
    fi

    # End of top-level block
    if [[ "$brace_depth" -le 0 ]] && [[ "$line" == "}" ]]; then
      if [[ -n "$current_key" && -n "$current_type" ]]; then
        process_resource "$current_type" "$current_tf_name" "$current_key"
      fi
      current_type=""
      current_tf_name=""
      current_key=""
      brace_depth=0
    fi
  fi
done < "$INPUT"

# ── Generate YAML via Python ──────────────────────────────────────────────────
python3 - "$INPUT" "$YAML_FILE" << 'PYEOF'
import re, sys

input_file = sys.argv[1]
yaml_file  = sys.argv[2]
content = open(input_file).read()
blocks = re.split(r'\n(?=resource ")', content)

repos=[]; users=[]; groups=[]; perms=[]
xray_pols=[]; watches=[]; cur_conds=[]; cur_pols=[]

def gf(block, field):
    m = re.search(rf'^\s+{field}\s*=\s*"([^"]*)"', block, re.MULTILINE)
    return m.group(1) if m else ''

def gb(block, field, default=False):
    m = re.search(rf'^\s+{field}\s*=\s*(true|false)', block, re.MULTILINE)
    return (m.group(1) == 'true') if m else default

for block in blocks:
    m = re.match(r'resource "([^"]+)" "([^"]+)"', block)
    if not m:
        continue
    rtype, tf_name = m.group(1), m.group(2)
    key  = gf(block,'key') or gf(block,'name')
    desc = gf(block,'description')

    if '_local_' in rtype and '_repository' in rtype and 'federated' not in rtype:
        pkg = rtype.replace('artifactory_local_','').replace('_repository','').replace('docker_v2','docker')
        repos.append(f'  - name: "{key}"\n    pkg_type: "{pkg}"\n    repo_type: "local"\n    description: "{desc}"\n    xray_index: {str(gb(block,"xray_index")).lower()}')

    elif '_remote_' in rtype and '_repository' in rtype:
        pkg = rtype.replace('artifactory_remote_','').replace('_repository','')
        url = gf(block,'url')
        repos.append(f'  - name: "{key}"\n    pkg_type: "{pkg}"\n    repo_type: "remote"\n    description: "{desc}"\n    url: "{url}"\n    xray_index: {str(gb(block,"xray_index")).lower()}')

    elif '_virtual_' in rtype and '_repository' in rtype:
        pkg = rtype.replace('artifactory_virtual_','').replace('_repository','')
        rm = re.search(r'repositories\s*=\s*\[([^\]]*)\]', block, re.DOTALL)
        reps = re.findall(r'"([^"]+)"', rm.group(1)) if rm else []
        repos_list = '\n'.join(f'      - "{r}"' for r in reps) if reps else '      []'
        repos.append(f'  - name: "{key}"\n    pkg_type: "{pkg}"\n    repo_type: "virtual"\n    description: "{desc}"\n    repositories:\n{repos_list}')

    elif rtype == 'artifactory_unmanaged_user':
        email = gf(block,'email')
        users.append(f'  - name: "{key}"\n    email: "{email}"\n    admin: {str(gb(block,"admin")).lower()}')

    elif rtype == 'platform_group':
        groups.append(f'  - name: "{key}"\n    description: "{desc}"\n    auto_join: {str(gb(block,"auto_join")).lower()}')

    elif rtype == 'platform_permission':
        perms.append(f'  # TODO: manually add permission "{key}" to dev.yaml\n  # (permission structure is complex — review existingimported.tf)')

    elif rtype == 'xray_security_policy':
        sev = re.search(r'min_severity\s*=\s*"([^"]+)"', block)
        sev = sev.group(1) if sev else 'High'
        blk = gb(block,'active')
        xray_pols.append(f'  - name: "{key}"\n    type: "security"\n    min_severity: "{sev}"\n    block: {str(blk).lower()}')

    elif rtype == 'xray_license_policy':
        lics_m = re.search(r'banned_licenses\s*=\s*\[([^\]]*)\]', block, re.DOTALL)
        lics = re.findall(r'"([^"]+)"', lics_m.group(1)) if lics_m else []
        lics_yaml = '\n'.join(f'      - "{l}"' for l in lics) if lics else '      []'
        xray_pols.append(f'  - name: "{key}"\n    type: "license"\n    banned_licenses:\n{lics_yaml}')

    elif rtype == 'xray_operational_risk_policy':
        risk = re.search(r'op_risk_min_risk\s*=\s*"([^"]+)"', block)
        risk = risk.group(1) if risk else 'High'
        xray_pols.append(f'  - name: "{key}"\n    type: "operational_risk"\n    min_severity: "{risk}"\n    block: false')

    elif rtype == 'xray_watch':
        pol  = re.search(r'assigned_policy\s*\{[^}]*name\s*=\s*"([^"]+)"', block, re.DOTALL)
        ptyp = re.search(r'assigned_policy\s*\{[^}]*type\s*=\s*"([^"]+)"', block, re.DOTALL)
        watches.append(f'  - name: "{key}"\n    description: "{desc}"\n    policy_name: "{pol.group(1) if pol else ""}"\n    policy_type: "{ptyp.group(1) if ptyp else "security"}"')

    elif rtype == 'xray_custom_curation_condition':
        tmpl = re.search(r'condition_template_id\s*=\s*"([^"]+)"', block)
        tmpl = tmpl.group(1) if tmpl else 'CVECVSSRange'
        cur_conds.append(f'  - name: "{key}"\n    template: "{tmpl}"')

    elif rtype == 'xray_curation_policy':
        cid   = re.search(r'condition_id\s*=\s*"([^"]+)"', block)
        scope = gf(block,'scope') or 'all_repos'
        act   = gf(block,'policy_action') or 'block'
        waiv  = gf(block,'waiver_request_config') or 'forbidden'
        cur_pols.append(f'  - name: "{key}"\n    condition_id: "{cid.group(1) if cid else ""}"\n    scope: "{scope}"\n    action: "{act}"\n    waiver: "{waiv}"')

out = []
if repos:       out += ['repositories:'] + repos + ['']
if users:       out += ['users:']        + users + ['']
if groups:      out += ['groups:']       + groups + ['']
if perms:       out += ['permissions:']  + perms + ['']
if xray_pols:   out += ['xray_policies:']+ xray_pols + ['']
if watches:     out += ['xray_watches:'] + watches + ['']
if cur_conds:   out += ['curation_conditions:'] + cur_conds + ['']
if cur_pols:    out += ['curation_policies:']   + cur_pols + ['']

with open(yaml_file, 'a') as f:
    f.write('\n'.join(out))

print(f"YAML: repos={len(repos)} users={len(users)} groups={len(groups)} perms={len(perms)} xray_pols={len(xray_pols)} watches={len(watches)} cur_conds={len(cur_conds)} cur_pols={len(cur_pols)}")
PYEOF

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}════════════════════════════════════════════════════${NC}"
echo -e "  ${BOLD}moved.tf blocks generated:${NC}"
echo -e "  Repositories         : ${repos}"
echo -e "  Users                : ${users}"
echo -e "  Groups               : ${groups}"
echo -e "  Permissions          : ${perms}"
echo -e "  Xray Security Policy : ${xray_sec}"
echo -e "  Xray License Policy  : ${xray_lic}"
echo -e "  Xray OpRisk Policy   : ${xray_opr}"
echo -e "  Xray Watches         : ${watches}"
echo -e "  Curation Conditions  : ${cur_conds}"
echo -e "  Curation Policies    : ${cur_pols}"
[[ $skipped -gt 0 ]] && echo -e "  ${YELLOW}Skipped (unsupported) : ${skipped}${NC}"
echo -e "${BOLD}${CYAN}════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. Review moved.tf and migration.yaml"
echo "  2. Append migration.yaml entries to your dev.yaml"
echo "  3. terraform plan   ← must show 0 to add, 0 to change, 0 to destroy"
echo "  4. terraform apply"
echo "  5. rm existingimported.tf moved.tf migration.yaml"
echo ""