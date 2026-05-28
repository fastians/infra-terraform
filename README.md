# Infra Terraform Usage Guide

This directory manages Mek-Lab infrastructure with Terraform.  
Each folder in `environments/` is an independent Terraform root and state.

## Quick Start

```bash
cd infra_terraform/environments/<environment-name>
cp terraform.tfvars.example terraform.tfvars   # if file exists
# edit terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Makefile Shortcuts

From `infra_terraform/`:

```bash
make help
make fmt
make init ENV=aws-app-dev
make check ENV=aws-app-dev
make validate ENV=aws-app-dev
make plan ENV=aws-app-dev
make apply ENV=aws-app-dev
make output ENV=aws-app-dev
make destroy ENV=aws-app-dev
```

To destroy an environment:

```bash
terraform destroy
```

## Environment Naming Standard

Pattern: `<cloud>-<purpose>-<stage>`

- `aws-app-dev`
- `aws-monitoring-prod`
- `azure-app-dev`
- `gcp-app-dev`
- `oci-app-dev`
- `shared-app-staging`
- `shared-app-prod`

This format makes ownership and lifecycle obvious at a glance.

## App server tiers (GCP + AWS staging + AWS production)

| Tier | Where | Terraform | Ansible hosts | Sizing |
|------|--------|-----------|---------------|--------|
| **GCP legacy** | Google Cloud | (manual / existing) | `backend-server`, `salome-server` | Unchanged — kept |
| **AWS staging** | ap-northeast-2 | `aws-app-staging` | `backend-aws-staging`, `salome-aws-staging` | `t3.large`, 50 GiB |
| | | | EC2 `mek-lab-app-staging-backend` **3.35.138.242**, `mek-lab-app-staging-salome` **13.209.14.89** (renamed from `app-prod-*`) | |
| **AWS production** | ap-northeast-2 | `aws-app-production` | `backend-aws-prod`, `salome-aws-prod` | `m6i.2xlarge` (8 vCPU, 32 GiB), 80/100 GiB |
| | | | EC2 `mek-lab-app-production-backend` **15.164.227.138**, `mek-lab-app-production-salome` **3.34.135.134** | |
| | | | Subnet **10.2.2.0/24** in **shared VPC** with staging (`existing_vpc_id`; see env README) | |

`aws-app-prod` was renamed to **`aws-app-staging`** so existing EC2 state is not destroyed when production is created.

**Do not** run `terraform apply` on `aws-app-staging` with m6i instance types — that plan destroys/recreates staging VMs. Use **`aws-app-production`** for upgraded instances.

**DNS (production):** `api.mek-lab.com` → backend IP, `salome.mek-lab.com` → salome IP. TLS and apps are provisioned by Ansible after apply.

## Environments and Purpose

| Environment | Purpose | Notes |
|---|---|---|
| `aws-app-staging` | AWS staging app pair (backend + salome) | Existing t3 VMs; state migrated from `aws-app-prod` |
| `aws-app-production` | AWS production app pair | Shared VPC with staging; subnet 10.2.2.0/24; m6i.2xlarge (backend includes GEO) |
| `aws-app-dev` | AWS dev app host | Single VM for experiments |
| `aws-monitoring-prod` | Dedicated AWS monitoring host | Prometheus/Grafana/Loki/Alertmanager VM |
| `azure-app-dev` | Azure dev app environment | Azure VM + NSG/network resources |
| `gcp-app-dev` | GCP dev app environment | GCE instance(s) + VPC/firewall |
| `oci-app-dev` | OCI dev app environment | OCI networking/compute |

## Recommended Workflow Per Change

```bash
terraform fmt -recursive .
terraform validate
terraform plan
```

For automated scripts, prefer machine-readable outputs:

```bash
terraform output -json
```

## AWS App Dev (Most Common)

```bash
cd infra_terraform/environments/aws-app-dev
./smoke-test.sh
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output -raw public_ip
```

Useful outputs:
- `public_ip`
- `ssh_user`
- `ssh_command_example`

## AWS Monitoring Prod

```bash
cd infra_terraform/environments/aws-monitoring-prod
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output -raw public_ip
```

After apply:
- Add output IP to Ansible inventory (`monitoring-aws` host in `infra_ansible`).
- Run monitoring-related Ansible playbooks from `infra_ansible`.

## Authentication Notes

- **AWS:** use `aws configure`, environment variables, or IAM role.
- **Azure:** `az login`.
- **GCP:** `gcloud auth application-default login`.
- **OCI:** configured OCI CLI profile.

Avoid hardcoding credentials in Terraform files.

## Structure Overview

```text
infra_terraform/
├── modules/                  # Reusable modules (network, security, compute)
├── environments/             # One state per environment
├── providers/                # Shared provider snippets
└── global/                   # Global/version settings
```

### Module Standards

- `main.tf`: resources only
- `variables.tf`: all inputs with types/descriptions
- `outputs.tf`: explicit module outputs

This keeps server provisioning simple to reason about and easy to review.

For AI/automation context (tiers, plan safety, VPC sharing), see [CLAUDE.md](CLAUDE.md).
