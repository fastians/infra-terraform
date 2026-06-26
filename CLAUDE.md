# CLAUDE.md - Terraform Platform Conventions

This document defines how infrastructure changes are made in `infra_terraform`.

## Engineering Principles

- Prefer small, reviewable changes over broad rewrites.
- Keep each environment in `environments/` as an isolated Terraform root/state.
- Favor reusable modules (`network`, `compute-instance`, `security-rules`).
- Treat security defaults seriously: narrow CIDRs, IMDSv2, encrypted gp3 roots.
- Never hardcode cloud credentials or private keys in code.

## App server layout (GCP + AWS staging + AWS production)

| Tier | Terraform env | State | EC2 naming (Name tag) | Sizing |
|------|---------------|-------|------------------------|--------|
| GCP legacy | — | — | (existing) | Unchanged |
| **AWS staging** | `aws-app-staging` | **Existing VMs** — do not resize via TF | `mek-lab-app-staging-*` | `t3.large`, 50 GiB |
| **AWS production** | `aws-app-production` | **Separate state** — new VMs | `mek-lab-app-production-*` | backend/salome: `m6i.xlarge`+; GEO (split): `t3.large`; 80–500 GiB |

**Critical:** `aws-app-staging` was renamed from `aws-app-prod`. Applying **m6i** instance types to staging **replaces** instances (plan: destroy/create). All staging sizing changes stay on `t3.large` in `aws-app-staging/terraform.tfvars`.

**Critical:** Create production only via `aws-app-production`. Never “upgrade” staging in place when the goal is a new prod stack.

### Staging (reference)

| Role | Public IP | Subnet |
|------|-----------|--------|
| backend | `3.35.138.242` | `10.2.1.0/24` |
| salome | `13.209.14.89` | `10.2.1.0/24` |

VPC: `10.2.0.0/16` (`mek-lab-app-staging-vpc` / legacy `mek-lab-app-prod-vpc` name in console).

### Production (reference)

| Role | Public IP | Subnet |
|------|-----------|--------|
| backend | `15.164.227.138` | `10.2.2.0/24` |
| salome | `3.34.135.134` | `10.2.2.0/24` |

Production uses **`existing_vpc_id`** (same VPC as staging) because the AWS account hit the **VPC quota (5/5)**. Only a new subnet + SG + EC2s are created in `aws-app-production` state. See `environments/aws-app-production/README.md`.

Public DNS (when cut over): `api.mek-lab.com` → backend, `salome.mek-lab.com` → salome.

## Directory Intent

- `environments/<name>/`: isolated roots and state (`.terraform/`, `terraform.tfstate` per env).
- `modules/`: reusable building blocks.
- `providers/`, `global/`: shared references.

## Required Workflow

From repository root:

```bash
terraform fmt -recursive infra_terraform
make -C infra_terraform init ENV=aws-app-production
make -C infra_terraform plan ENV=aws-app-production
make -C infra_terraform apply ENV=aws-app-production
make -C infra_terraform output ENV=aws-app-production
```

Or:

```bash
cd infra_terraform/environments/<env>
terraform init
terraform plan
terraform apply
terraform output -json
```

After **production** apply:

1. Update `infra_ansible/inventories/prod/hosts.ini` with `backend_public_ip` / `salome_public_ip`.
2. Run Ansible (see `infra_ansible/CLAUDE.md`).

## Network module (`modules/network`)

- **New VPC** (default): set `vpc_cidr` + `public_subnet_cidr`; leave `existing_vpc_id` empty.
- **Existing VPC** (production): set `existing_vpc_id`, `public_subnet_cidr` (must not overlap other subnets, e.g. staging `10.2.1.0/24` → prod `10.2.2.0/24`).

## Style and Structure Rules

- Typed variables with descriptions and validation.
- `locals.name_prefix = "${var.project_name}-${var.environment}"` drives resource names.
- `common_tags` merged into modules; `Environment` tag reflects `var.environment` (`app-staging` vs `app-production`).
- Keep `terraform.tfvars.example` in sync with variables.
- `terraform.tfvars` is gitignored — copy from `.example` per environment.

## Security Baseline

- Root volume: `gp3`, encrypted, `metadata_http_tokens = "required"`.
- Restrict `allowed_ssh_cidrs` in production when possible.
- App SG opens 22, 80, 443, 8000–8002, 9100, 9080 (tighten monitoring CIDRs in prod).
- Do not commit `ssh_public_key` in tfvars to git; use `.example` placeholders.

## Plan expectations

| Environment | Typical plan |
|-------------|----------------|
| `aws-app-staging` | Tag/name tweaks only if tfvars still `t3.large` and pinned AMI — **no** destroy/recreate |
| `aws-app-production` | **Create** new subnet, SG, key pair, 2 EC2s — **no** changes to staging resources |

If staging plan shows **2 to destroy, 2 to add** for instance type change, **stop** — wrong env or wrong tfvars.

## Ansible alignment

| Terraform output | Ansible host |
|------------------|----------------|
| `backend_public_ip` | `backend-aws-staging` or `backend-aws-prod` |
| `salome_public_ip` | `salome-aws-staging` or `salome-aws-prod` |

Terraform does **not** install Postgres, apps, or TLS — Ansible does.

## PR Checklist

- [ ] Change scoped to one environment/module.
- [ ] `terraform fmt`, `validate`, `plan` for affected env.
- [ ] `terraform.tfvars.example` updated.
- [ ] Staging vs production impact understood (no accidental staging destroy).
- [ ] Security group / CIDR implications reviewed.
- [ ] `infra_terraform/README.md` and this file updated if tiers or workflow change.
