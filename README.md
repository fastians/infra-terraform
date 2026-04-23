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
make validate ENV=aws-app-dev
make plan ENV=aws-app-dev
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

## Environments and Purpose

| Environment | Purpose | Notes |
|---|---|---|
| `aws-app-dev` | Main AWS dev app host | Ubuntu EC2, SSH + app/monitoring ports |
| `aws-monitoring-prod` | Dedicated AWS production monitoring host | Prometheus/Grafana/Loki/Alertmanager VM |
| `azure-app-dev` | Azure dev app environment | Azure VM + NSG/network resources |
| `gcp-app-dev` | GCP dev app environment | GCE instance(s) + VPC/firewall |
| `oci-app-dev` | OCI dev app environment | OCI networking/compute |
| `shared-app-staging` | Placeholder staging root | Currently minimal scaffold |
| `shared-app-prod` | Placeholder prod root | Currently minimal scaffold |

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
