# JFrog Platform — Terraform Management

Manage JFrog Artifactory, Xray, Curation, and Projects as code. Existing platform objects stay in `existingimported.tf`. New objects are declared in YAML and created by the modules.

Terraform state is stored in S3.

## Environments

Two JPDs are managed, each from its own completely independent Terraform root module — own state file, own provider credentials, own `.tf` config, own YAML. There is no sharing between them at all; a `staging` apply cannot see, plan, or touch anything in `prod`, and vice versa.

| Environment | Directory | JPD | Imported? |
|---|---|---|---|
| `prod` | `environments/prod/` | `http://sum2.jfps.team` | Yes — `environments/prod/existingimported.tf` |
| `staging` | `environments/staging/` | `http://172.18.96.199:8082/` | No — everything there is created fresh by Terraform |

Each environment directory is a full, self-contained root module:

```
environments/<env>/
├── providers.tf          # that environment's JFrog URL + token, unaliased
├── variables.tf          # variable "jfrog_token"
├── backend.tf            # S3 backend, configured at init time
├── main.tf                # wires platform.yaml + projects/ into ../../modules/*
├── locals.tf
├── outputs.tf
├── platform.yaml
├── projects/
│   └── <project>.yaml
└── existingimported.tf   # prod only
```

Both environments call the exact same shared `modules/` at the repo root (`source = "../../modules/<name>"`) — the modules themselves have no knowledge of which environment is calling them. Run every `terraform` command from inside the relevant `environments/<env>/` directory. Adding a third JPD later means copying one of these directories, pointing its `providers.tf` at the new JPD, giving it its own `backend-configs/s3-<env>.hcl` state key, and writing its own `platform.yaml`/`projects/`.

## Overview

| Path | Purpose |
|------|---------|
| `environments/<env>/existingimported.tf` | Configuration for that environment's resources imported from JFrog. Only `prod` has one so far. Do not delete this file. |
| `environments/<env>/projects/<project>.yaml` | One file per project team, within one environment. May create new repositories, and may manage one project's custom roles and repository assignments by referencing its key. Every file under that environment's `projects/` is loaded into that environment's plan only; the directory is optional. |
| `environments/<env>/platform.yaml` | Platform-wide objects for that one environment: the JFrog projects themselves (key, display_name, admin settings), groups, users, permissions, Xray policies and watches, and curation. A project declared here is created even if no file under `projects/` manages it. Users and groups are owned by SCIM; `environments/prod/platform.yaml` only keeps the ones Terraform already manages from the import. |
| `modules/` | Turns the YAML into Terraform resources. Shared by every environment — no environment-specific logic lives here. |
| `environments/<env>/main.tf` | Passes that environment's project files and `platform.yaml` into the shared modules. |
| `example.yaml` | Reference only — Terraform never loads it. Every key either file supports, in one place, split into a `platform.yaml` section and a `projects/<project>.yaml` section. Copy what you need from it; see "Creating new resources" below for the rules in prose. |

Each environment's plan loads only that environment's `projects/*.yaml`, `platform.yaml`, and (for prod) `existingimported.tf` — nothing from the other environment is ever in scope.

## Providers

| Provider | Source | Version | Manages |
|----------|--------|---------|---------|
| artifactory | `jfrog/artifactory` | `~> 12.0` | Repositories, users |
| platform | `jfrog/platform` | `~> 2.0` | Groups, permissions, OIDC configurations, OIDC identity mappings |
| xray | `jfrog/xray` | `~> 3.1` | Xray policies, watches, curation |
| project | `jfrog/project` | `~> 1.9.9` | Projects, members, roles, environments, repository assignment |

Each environment's `providers.tf` declares all four, unaliased, pointed at that environment's own JFrog URL and reading that environment's own `var.jfrog_token`. Modules never reference a provider alias — each environment just has its own ordinary default providers, and modules use whichever one the calling root module (`environments/prod/` or `environments/staging/`) has configured.

## Repository structure

```
.
├── GeneratePlatformImports.sh
├── stash-for-import.sh                  # moves an env's module config out of the way before import
├── restore-after-import.sh              # moves it back after import
├── add-repo-lifecycle.sh                # adds ignore_changes = [project_key, project_environments] to every imported repo
├── backend-configs/
│   ├── s3-prod.hcl                     # bucket, key, region — gitignored
│   ├── s3-prod.example.hcl
│   ├── s3-staging.hcl                  # gitignored
│   └── s3-staging.example.hcl
├── modules/                             # shared by every environment
│   ├── repositories/
│   ├── groups/
│   ├── users/
│   ├── permissions/
│   ├── projects/
│   ├── xray_policies/
│   ├── xray_watches/
│   ├── curation_conditions/
│   ├── curation_policies/
│   ├── oidc_configurations/
│   └── oidc_identity_mappings/
├── example.yaml                         # reference only — every supported key, not loaded by Terraform
└── environments/
    ├── prod/
    │   ├── providers.tf                 # sum2.jfps.team, var.jfrog_token
    │   ├── variables.tf
    │   ├── backend.tf
    │   ├── terraform.tfvars             # gitignored — prod JFrog token
    │   ├── main.tf
    │   ├── locals.tf
    │   ├── outputs.tf
    │   ├── existingimported.tf          # imported resources — keep this file
    │   ├── platform.yaml                # groups, users, permissions, Xray, curation, all projects
    │   └── projects/
    │       ├── fstg.yaml
    │       └── cba.yaml
    └── staging/
        ├── providers.tf                 # 172.18.96.199:8082, var.jfrog_token
        ├── variables.tf
        ├── backend.tf
        ├── terraform.tfvars             # gitignored — staging JFrog token
        ├── main.tf
        ├── locals.tf
        ├── outputs.tf
        ├── platform.yaml                # nothing imported here yet
        └── projects/                    # empty until staging has projects
```

## Prerequisites

- Terraform >= 1.5
- `curl` and `jq` for the import script
- JFrog access token with admin permissions
- An S3 bucket for state
- AWS credentials that can read and write that bucket: `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`

The JFrog token does not authenticate to S3. S3 uses AWS keys.

## Setup

Every command in this section runs from inside `environments/prod/` or `environments/staging/` — not the repo root.

### 1. Tokens and URLs

Each environment's own `providers.tf` points its (unaliased) providers at that environment's JFrog URL, reading that environment's own `var.jfrog_token`. Put the matching token in a `terraform.tfvars` inside that same environment directory:

```hcl
# environments/prod/terraform.tfvars
jfrog_token = "your-prod-access-token"
```

```hcl
# environments/staging/terraform.tfvars
jfrog_token = "your-staging-access-token"
```

Both need admin permissions on their respective JPD. Do not commit either `terraform.tfvars`.

### 2. S3 backend

```bash
cd environments/prod   # or environments/staging

export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="ap-south-1"

terraform init -backend-config=../../backend-configs/s3-prod.hcl   # or s3-staging.hcl
```

`backend-configs/s3-prod.hcl` / `s3-staging.hcl` each supply their own bucket, state key, and region — two completely separate state files, one per environment. If the modules were added after the first init, run `terraform init` again so Terraform registers them.

## Importing existing resources

This whole section applies to `environments/prod/` only — staging has nothing to import. Adding a brand-new JPD (like staging was) means skipping straight to "Creating new resources" below: write that environment's `platform.yaml` and `projects/*.yaml`, then `terraform apply` from inside its directory.

`terraform plan -generate-config-out` needs to run in a directory that does not already declare the same resources — if `main.tf` is still there wiring in the shared modules for the same objects, Terraform tries to create a second copy instead of adopting the real ones. Two scripts at the repo root automate moving that config out of the way and back, so this is a fixed, repeatable sequence rather than something to remember by hand:

- `./stash-for-import.sh <env>` — moves `main.tf`, `locals.tf`, `outputs.tf`, `platform.yaml`, and `projects/` out of `environments/<env>/` into `environments/<env>/.import-stash/` (gitignored, never read by Terraform since it's a subdirectory Terraform doesn't scan). `providers.tf`, `variables.tf`, and `backend.tf` are left in place — the import step still needs them.
- `./restore-after-import.sh <env>` — moves those same files back. It refuses to run while `imports.tf` still exists, so it can't be run too early by mistake.

Run both from the repo root. Everything below runs with `prod` as `<env>`.

### 0. Stash the module config

```bash
./stash-for-import.sh prod
```

### 1. Generate import blocks

```bash
cd environments/prod

export ARTIFACTORY_URL="http://sum2.jfps.team"
export ARTIFACTORY_TOKEN="your-prod-access-token"

../../GeneratePlatformImports.sh
```

This writes `imports.tf` in `environments/prod/`. Repository keys that differ only by `.`, `-`, and `_` collapse to the same Terraform name. The script keeps the first and skips the rest.

Package types with no Terraform resource are skipped. Virtual Cargo is one of those. Release Bundles and BuildInfo repositories are skipped because they are system-managed.

### 2. Generate the configuration and import

Still inside `environments/prod/`:

```bash
terraform init -backend-config=../../backend-configs/s3-prod.hcl
terraform plan -generate-config-out=existingimported.tf
```

`-generate-config-out` only ever writes real attribute values — it never adds a `lifecycle` block. Every `artifactory_*_repository` resource it just wrote hardcodes `project_key`/`project_environments` as they are right now (usually `null`/`[]`), and without `ignore_changes` on those two, the next plan after you assign that repo to a project would try to silently revert it. From the repo root, before applying:

```bash
cd ../..
./add-repo-lifecycle.sh prod
cd environments/prod
```

This adds `lifecycle { ignore_changes = [project_key, project_environments] }` to every repository resource in `existingimported.tf` that doesn't already have one — safe to re-run any time (including after a later re-import regenerates this file and drops the blocks again).

```bash
terraform apply
terraform plan
```

The last plan should report no changes. The apply adopts existing objects. It does not create a second copy. A small number of in-place updates can appear when generated values differ from what JFrog returns.

### 3. Remove the import blocks

After a clean plan, delete `imports.tf` only.

```bash
rm imports.tf
terraform plan
```

Keep `existingimported.tf`. That file is the configuration. S3 state only records which objects Terraform owns. Deleting `existingimported.tf` makes the next plan destroy every imported object.

### 4. Bring the module config back

From the repo root:

```bash
./restore-after-import.sh prod
```

This moves `main.tf`, `locals.tf`, `outputs.tf`, `platform.yaml`, and `projects/` back into `environments/prod/`, refusing to run if `imports.tf` is still there or if any of those files already exist in `environments/prod/` (a conflict it won't silently overwrite). Leave `platform.yaml` and `projects/` empty of names that are already in `existingimported.tf`.

```bash
cd environments/prod
terraform init
terraform plan
```

That plan should still show no changes until new YAML entries are added.

## Creating new resources

See `example.yaml` at the repo root for every key below shown as a working, validated example — including every repository type, all four `oidc_configurations` provider types, and `oidc_identity_mappings` with several different claim and scope shapes (`sub`, `aud`, `repository`, `repository_owner`, `workflow_ref`, user/groups/roles scopes, `username_pattern`, `groups_pattern`). It's a reference only; Terraform never loads it. Everything below is per environment — run `terraform plan`/`apply` from inside `environments/prod/` or `environments/staging/`, and the `platform.yaml`/`projects/` paths below are relative to that directory.

Two files between them declare everything new. `platform.yaml` holds objects that are platform-wide or exist independently of any one project, for that environment. `projects/<project>.yaml` — one file per project team — holds one project's own roles, role assignments, repository assignments, and any new repositories that team owns.

### What goes in `platform.yaml`

| Key | Declares |
|-----|----------|
| `projects` | Every JFrog project's `key`, `display_name`, `admin_privileges`, and custom `environments`. A project is created as soon as it is in this list, whether or not a file under `projects/` manages it. |
| `projects[].roles`, `.users`, `.groups`, `.repositories` | *Optional, per project.* That project's custom roles, its role assignments for already-existing users and groups, and which repositories it owns — declared directly here instead of in a file under `projects/`. See "Project" below. |
| `repositories` | Repositories owned by no single project — shared across teams, or not yet assigned to one. |
| `groups`, `users` | Only the ones Terraform already manages from the import. Groups and users are owned by SCIM — do not add new people or groups here. |
| `permissions` | |
| `xray_security_policies`, `xray_license_policies`, `xray_operational_risk_policies` | |
| `xray_watches` | Watches not scoped to any one project. A watch here has no `project_key` — see `xray_watches` under `projects/<project>.yaml` below for a project-scoped watch instead. |
| `curation_conditions`, `curation_policies` | |
| `oidc_configurations` | OIDC identity provider configurations (`GitHub`, `GitHubEnterprise`, `Azure`, or `generic`). `platform.yaml` only — not available under `projects/<project>.yaml`. |
| `oidc_identity_mappings` | Maps an OIDC configuration's claims to a JFrog token scope. Same shape as `oidc_identity_mappings` under `projects/<project>.yaml` below. |

### What goes in `projects/<project>.yaml`

| Key | Declares |
|-----|----------|
| `repositories` | New repositories this project team owns. Each name must start with `<project key>-`. Automatically assigned to this file's `project` — no need to repeat them under `project.repositories`. |
| `project.key` | Which project this file manages. That project's `key`, `display_name`, and admin settings must already exist in `platform.yaml`'s `projects:` list, in this same environment. |
| `project.roles` | Custom roles for this project. |
| `project.users`, `project.groups` | Assigns an already-existing user or group one of this project's roles, or a built-in role (`Developer`, `Contributor`, `Viewer`, `Project Admin`). SCIM still owns creating the user or group itself — this only assigns a role to one that already exists. |
| `project.repositories` | Existing or imported repository keys to assign to this project, beyond the ones this file creates itself. |
| `xray_watches` | Xray watches this project team owns. Same shape as `xray_watches` in `platform.yaml`, with one difference: a watch declared here is automatically scoped to this file's `project.key` — every repository or build it watches must already be assigned to that project. A watch name must be unique across `platform.yaml` and every file under `projects/`, within this environment. Not available for `xray_security_policies`, `xray_license_policies`, or `xray_operational_risk_policies` — those stay in `platform.yaml` only. |
| `oidc_identity_mappings` | Maps an OIDC configuration's claims to a JFrog token scope — `provider_name` references an `oidc_configurations` entry from `platform.yaml` (that resource itself cannot be declared here). What actually scopes a mapping to a project is `token_spec.scope` set to `applied-permissions/roles:<project key>:"<role>"`, not which file declares it — a mapping with a `user`/`admin`/`groups` scope stays global no matter which file it's in. A mapping name must be unique across `platform.yaml` and every file under `projects/`, within this environment. |

A project's roles, user/group role assignments, and repository assignment live in exactly one of those two places, within one environment — directly on its entry in `platform.yaml`, or in its file under `projects/` — never both. The plan fails if a project already managed by a file under `projects/` also declares `roles`, `users`, `groups`, or `repositories` directly in `platform.yaml`.

A repository a project team owns belongs in that project's file under `projects/` — either an existing project's file or a new one named for that project. Do not add a second `.tf` file for it, and do not copy an imported name into the YAML. The modules would treat that name as a new object and JFrog would return "already exists".

A file under `projects/` may declare only `repositories`, `project`, `xray_watches`, and `oidc_identity_mappings` at the top level — nothing else. The plan fails if it declares anything else, if a repository, watch, or identity mapping name is also declared in another file under `projects/` or in `platform.yaml`, if more than one file manages the same project key, or if a file manages a project key that `platform.yaml` does not declare. All of this is scoped to one environment's own Terraform state — the same name can be reused between `environments/prod/` and `environments/staging/` with zero risk of collision, since they're entirely separate configurations. A repository several projects need lives in its own file under `projects/` (for example `projects/shared.yaml`) so it is declared once.

A repository created in a file that also has a `project:` block must have a name starting with `<project key>-`, for example `fstg-npm-local` in `environments/prod/projects/fstg.yaml`. The plan fails otherwise. A file with no `project:` block (a shared repositories file) has no such restriction.

```bash
terraform plan
terraform apply
```

Users need a password. The import does not contain passwords, so imported users stay in `existingimported.tf`.

### Project

The project itself goes in that environment's `platform.yaml` (for example `environments/prod/platform.yaml`):

```yaml
projects:
  - key: Fortescue
    display_name: Fortescue Uploads
    description: Project for the Fortescue-uploads repository
    email_notification: true
    admin_privileges:
      manage_members: true
      manage_resources: true
      manage_remote_repository: true
      index_resources: true
    environments:
      - UPLOADS
```

Its roles, role assignments, and repository assignments go in that same environment's `projects/fortescue.yaml`, referencing the same key:

```yaml
repositories:
  - name: Fortescue-uploads
    package_type: generic
    repo_type: local

project:
  key: Fortescue
  roles:
    - name: uploader
      environments: [UPLOADS]
      actions: [READ_REPOSITORY, ANNOTATE_REPOSITORY, DEPLOY_CACHE_REPOSITORY]
  # Assigns an already-existing user or group one of this project's roles
  # (or a built-in role: Developer, Contributor, Viewer, Project Admin).
  # SCIM still owns creating the user or group itself.
  groups:
    - name: fstg-developers
      roles: [uploader]
  users:
    - name: fstg-alice
      roles: [uploader]
```

A repository this file creates in its own `repositories:` list is assigned to this file's project automatically — `Fortescue-uploads` does not need to be repeated under `project.repositories`. Put a repository key there only when this file does not create it itself: it already exists, was imported, or is created by another file.

The same `roles`/`users`/`groups`/`repositories` shape works directly on a project's entry in `platform.yaml` instead, for a project with no file under `projects/` — for example, to skip `projects/fortescue.yaml` above entirely:

```yaml
projects:
  - key: Fortescue
    display_name: Fortescue Uploads
    admin_privileges: { manage_members: true, manage_resources: true, manage_remote_repository: true, index_resources: true }
    environments: [UPLOADS]
    roles:
      - name: uploader
        environments: [UPLOADS]
        actions: [READ_REPOSITORY, ANNOTATE_REPOSITORY, DEPLOY_CACHE_REPOSITORY]
    groups:
      - name: fstg-developers
        roles: [uploader]
    users:
      - name: fstg-alice
        roles: [uploader]
    repositories: [Fortescue-uploads]
```

JFrog stores a custom project environment as `<project key>-<name>`. The YAML uses the short name `UPLOADS`. The projects module sends `Fortescue-UPLOADS` on the role. `DEV` and `PROD` are not prefixed.

An existing repository can be assigned even when its key does not start with the project key. Assigning it moves that repository into the project. Every repository resource in `existingimported.tf` should already have a `lifecycle { ignore_changes = [project_key, project_environments] }` block (added by `./add-repo-lifecycle.sh <env>` — see "Importing existing resources" step 2) so assigning one to a project — or moving it to a different project later — never gets undone by the next plan. If a repository resource was added by hand instead of through that script, give it the same `lifecycle` block before assigning it.


Curation policies whose scope is `specific_groups` cannot be represented by the Xray provider. Those policies were left out of the import. Permissions, Xray policies, watches, and the other curation policies are in `existingimported.tf`. The modules can create new ones from YAML.

## Import script coverage

| Resource | Provider | Import ID | Notes |
|----------|----------|-----------|-------|
| Repositories | artifactory | repo key | Package types the provider supports |
| Users | artifactory | username | Skips `admin` and `anonymous` |
| Groups | platform | group name | |
| Permissions | platform | permission name | |
| Xray policies | xray | policy name | security, license, operational_risk |
| Xray watches | xray | watch name | |
| Curation conditions | xray | numeric id | Custom conditions only |
| Curation policies | xray | numeric id | `specific_groups` is not supported |
| Projects | project | — | Not imported. Create them from YAML. |
| Release Bundles | — | — | System-managed, skipped |
| BuildInfo repos | — | — | System-managed, skipped |

## Known provider fixes

Apply these to `existingimported.tf` when `terraform plan -generate-config-out` produces a file that will not plan.

On macOS, `sed -i ''` is required. On Linux, use `sed -i` without the extra argument.

```bash
# Xray policy description null is rejected
sed -i '' '/resource "xray_.*_policy"/,/^}$/ s/  description = null/  description = ""/g' existingimported.tf

# min_severity "unknown" is rejected
sed -i '' 's/min_severity = "unknown"/min_severity = "All severities"/g' existingimported.tf

# "All severities" is not valid inside an sast block
awk '
/sast \{/ { in_sast=1 }
/\}/ { in_sast=0 }
in_sast && /min_severity = "All severities"/ {
    sub(/min_severity = "All severities"/, "min_severity = \"High\"")
}
{ print }
' existingimported.tf > existingimported_fixed.tf && mv existingimported_fixed.tf existingimported.tf
```

| Error | Fix |
|-------|-----|
| `description` was null, but now `""` | Set `description = ""` on Xray policies |
| `min_severity = "unknown"` | Replace with `"All severities"` |
| `"All severities"` inside `sast` | Replace with `"High"` in that block only |
| `tag_retention` must be >= 1 | Replace `tag_retention = 0` with `tag_retention = 1` |
| Role environment `UPLOADS` rejected | The module sends `<project key>-UPLOADS` |
| `specific_groups` curation scope | Leave that policy out of Terraform |
| Module not installed | Run `terraform init` again after adding `modules/` |
| Repository already exists | The name is already in `existingimported.tf`. Do not add it to YAML |

## Useful commands

Run these from inside `environments/prod/` or `environments/staging/` — each environment is its own independent configuration, so there's no `-target`-based cross-environment scoping needed. A plan in one directory can never see or affect the other.

```bash
cd environments/prod   # or environments/staging

terraform state list | wc -l
terraform plan
terraform apply
terraform init -upgrade
```

## State

Each environment has its own S3 state file, configured by that environment's `backend.tf` plus `backend-configs/s3-prod.hcl` / `s3-staging.hcl`. Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` before init, plan, and apply — same AWS credentials can read/write both state objects, but the state objects themselves are completely separate, at different keys in the bucket. A staging `apply` cannot see or change prod's state, and vice versa.

Local state is used only if the `backend "s3"` block in that environment's `backend.tf` is commented out and Terraform is initialized again.

## .gitignore

```
terraform.tfvars
terraform.tfstate
terraform.tfstate.backup
.terraform/
*.tfvars
.terraform.tfstate.lock.info
backend-configs/*.hcl
!backend-configs/*.example.hcl
!backend-configs/s3-prod.hcl
!backend-configs/s3-staging.hcl
```

`*.tfvars` and `.terraform/` match at any depth, so `environments/prod/terraform.tfvars` and `environments/staging/.terraform/` are both covered without extra rules. `s3-prod.hcl`/`s3-staging.hcl` are explicitly un-ignored — these are non-sensitive bucket/key/region settings (a shared "TEST key" originally), not credentials, so they stay tracked. Real secrets (JFrog tokens, AWS keys) only ever live in each environment's own `terraform.tfvars` or in CI secrets — never in these files.

## References

- [JFrog Artifactory Terraform Provider](https://registry.terraform.io/providers/jfrog/artifactory/latest/docs)
- [JFrog Platform Terraform Provider](https://registry.terraform.io/providers/jfrog/platform/latest/docs)
- [JFrog Xray Terraform Provider](https://registry.terraform.io/providers/jfrog/xray/latest/docs)
- [JFrog Project Terraform Provider](https://registry.terraform.io/providers/jfrog/project/latest/docs)
- [Terraform import blocks](https://developer.hashicorp.com/terraform/language/import)
- [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
