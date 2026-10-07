# JFrog Platform — Terraform Management

Manage JFrog Artifactory, Xray, Curation, and Projects as code. Existing platform objects stay in `existingimported.tf`. New objects are declared in YAML and created by the modules.

The JFrog instance is `https://jfrog_url.jfrog.io`. Terraform state is stored in S3.

## Branches

Keep staging and prod on separate GitHub branches. The staging `existingimported.tf` belongs on `staging` only. Do not merge it into `prod`. Prod gets its own import and its own S3 state key, so a staging apply cannot change production.

Use a separate clone for each branch. Switching branches in one working tree leaves `terraform.tfvars` and `backend-configs/s3.hcl` in place.

## Overview

| Path | Purpose |
|------|---------|
| `existingimported.tf` | Configuration for the resources imported from JFrog. Do not delete this file. |
| `environments/staging.yaml` | New staging resources. Read when `environment` is `staging`. |
| `environments/prod.yaml` | New production resources. Read when `environment` is `prod`. |
| `modules/` | Turns the YAML into Terraform resources. |
| `main.tf` | Passes the selected YAML into the modules. |

`terraform.tfvars` selects the YAML file:

```hcl
environment = "staging"
```

Production plan:

```bash
terraform plan -var="environment=prod"
```

Both plans also include every resource in `existingimported.tf`. On a shared checkout that file is the staging import, which is why staging and prod should be separate branches.

## Providers

| Provider | Source | Version | Manages |
|----------|--------|---------|---------|
| artifactory | `jfrog/artifactory` | `~> 12.0` | Repositories, users |
| platform | `jfrog/platform` | `~> 2.0` | Groups, permissions |
| xray | `jfrog/xray` | `~> 3.1` | Xray policies, watches, curation |
| project | `jfrog/project` | `~> 1.9.9` | Projects, members, roles, environments, repository assignment |

## Repository structure

```
.
├── providers.tf
├── variables.tf
├── terraform.tfvars              # gitignored — JFrog token and environment
├── backend.tf                    # S3 backend
├── backend-configs/s3.hcl        # bucket, key, region — gitignored
├── GeneratePlatformImports.sh
├── existingimported.tf           # imported resources — keep this file
├── main.tf
├── locals.tf
├── outputs.tf
├── modules/
│   ├── repositories/
│   ├── groups/
│   ├── users/
│   ├── permissions/
│   ├── projects/
│   ├── xray_policies/
│   ├── xray_watches/
│   ├── curation_conditions/
│   └── curation_policies/
└── environments/
    ├── staging.yaml
    └── prod.yaml
```

## Prerequisites

- Terraform >= 1.5
- `curl` and `jq` for the import script
- JFrog access token with admin permissions
- An S3 bucket for state
- AWS credentials that can read and write that bucket: `s3:ListBucket`, `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`

The JFrog token does not authenticate to S3. S3 uses AWS keys.

## Setup

### 1. Token and URL

`providers.tf` points all four providers at `https://jfrog_url.jfrog.io` and reads `var.jfrog_token`.

```hcl
jfrog_token = "your-access-token"
environment = "staging"
```

Do not commit `terraform.tfvars`.

### 2. S3 backend

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="ap-south-1"

terraform init -backend-config=backend-configs/s3.hcl
```

`backend-configs/s3.hcl` supplies the bucket, state key, and region. Give the prod branch a different key from staging. If the modules were added after the first init, run `terraform init` again so Terraform registers them.

## Importing existing resources

Run this in a directory that does not yet contain `main.tf`. A `main.tf` that declares the same names will try to create them a second time.

### 1. Generate import blocks

```bash
export ARTIFACTORY_URL="https://jfrog_url.jfrog.io"
export ARTIFACTORY_TOKEN="your-access-token"

chmod +x GeneratePlatformImports.sh
./GeneratePlatformImports.sh
```

This writes `imports.tf`. Repository keys that differ only by `.`, `-`, and `_` collapse to the same Terraform name. The script keeps the first and skips the rest.

Package types with no Terraform resource are skipped. Virtual Cargo is one of those. Release Bundles and BuildInfo repositories are skipped because they are system-managed.

### 2. Generate the configuration and import

```bash
terraform init -backend-config=backend-configs/s3.hcl
terraform plan -generate-config-out=existingimported.tf
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

### 4. Add the modules

Copy `main.tf`, `locals.tf`, `outputs.tf`, and `modules/` in after the import. Leave `environments/staging.yaml` and `environments/prod.yaml` empty of names that are already in `existingimported.tf`.

Run `terraform init` again, then `terraform plan`. It should still show no changes until new YAML entries are added.

## Creating new resources

Add the object to `environments/staging.yaml` or `environments/prod.yaml`. Do not add a second `.tf` file for it, and do not copy an imported name into the YAML. The modules would treat that name as a new object and JFrog would return "already exists".

```bash
terraform plan
terraform apply
```

A staging file can declare repositories, groups, users, permissions, Xray policies, watches, curation conditions, curation policies, and projects. Users need a password. The import does not contain passwords, so imported users stay in `existingimported.tf`.

### Project

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
    roles:
      - name: uploader
        environments:
          - UPLOADS
        actions:
          - READ_REPOSITORY
          - ANNOTATE_REPOSITORY
          - DEPLOY_CACHE_REPOSITORY
    groups:
      - name: fstg-developers
        roles:
          - uploader
    users:
      - name: fstg-alice
        roles:
          - uploader
    repositories:
      - Fortescue-uploads
```

JFrog stores a custom project environment as `<project key>-<name>`. The YAML uses the short name `UPLOADS`. The projects module sends `Fortescue-UPLOADS` on the role. `DEV` and `PROD` are not prefixed.

An existing repository can be assigned even when its key does not start with the project key. Assigning it moves that repository into the project. On the matching resource in `existingimported.tf`, ignore `project_key` and `project_environments` so the next plan does not undo the assignment.


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

```bash
terraform state list | wc -l
terraform plan
terraform apply
terraform init -upgrade
```

## State

State is in S3, configured by `backend.tf` and `backend-configs/s3.hcl`. Export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` before init, plan, and apply. Use a different state key on the prod branch than on staging.

Local state is used only if the `backend "s3"` block in `backend.tf` is commented out and Terraform is initialized again.

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
```

## References

- [JFrog Artifactory Terraform Provider](https://registry.terraform.io/providers/jfrog/artifactory/latest/docs)
- [JFrog Platform Terraform Provider](https://registry.terraform.io/providers/jfrog/platform/latest/docs)
- [JFrog Xray Terraform Provider](https://registry.terraform.io/providers/jfrog/xray/latest/docs)
- [JFrog Project Terraform Provider](https://registry.terraform.io/providers/jfrog/project/latest/docs)
- [Terraform import blocks](https://developer.hashicorp.com/terraform/language/import)
- [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
