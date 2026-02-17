# Infra Terraform

Multi-cloud modular Terraform structure for infrastructure management.

## Project Structure

```text
infra-terraform/
├── modules/                ← Reusable building blocks
│   ├── network/
│   ├── compute-instance/
│   ├── security-rules/
│   └── monitoring-host/
├── environments/           ← Environment-specific deployments
│   ├── dev/                ← Oracle Cloud
│   ├── aws-dev/            ← AWS
│   ├── gcp-dev/            ← Google Cloud
│   ├── azure-dev/          ← Azure
│   └── ...
├── providers/              ← Provider configurations (AWS, GCP, Oracle)
│   ├── aws.tf
│   ├── gcp.tf
│   └── oracle.tf
└── global/                 ← Global settings and versions
    └── versions.tf
```

## Creating instances seamlessly (any cloud)

Every cloud dev environment creates the **same logical setup**:

- **2 instances:** `dev-monitor`, `monitoring-server`
- **Image:** Ubuntu 22.04
- **Firewall:** SSH (22), Grafana (3000), Loki (3100), Prometheus (9090), Alertmanager (9093)
- **Outputs:** `public_ip`, `monitor_public_ip`, `monitoring_server_public_ip`

**Same workflow for Oracle, AWS, GCP, or Azure:**

```bash
cd environments/<cloud>-dev    # dev (Oracle), aws-dev, gcp-dev, azure-dev
cp terraform.tfvars.example terraform.tfvars   # if present
# Edit terraform.tfvars with your values (see table below)
terraform init
terraform plan
terraform apply
```

| Environment   | Required variables              | Auth |
|----------------|----------------------------------|------|
| **dev** (Oracle) | `tenancy_ocid`, `compartment_ocid`, `ssh_public_key`, `subnet_ocid` | OCI CLI config |
| **aws-dev**   | `ssh_public_key` (+ optional `aws_region`, `key_name`) | `aws configure` or env |
| **gcp-dev**   | `gcp_project_id`, `ssh_public_key` (+ optional `gcp_region`) | `gcloud auth application-default login` |
| **azure-dev** | `ssh_public_key` (+ optional `azure_region`, `resource_group_name`) | `az login` |

Use one `ssh_public_key` (e.g. contents of `~/.ssh/id_rsa.pub`) everywhere. Optional `ingress_source_cidr` (default `0.0.0.0/0`) restricts monitoring ports to your IP.

## Usage

Each environment in `environments/` manages its own state and can consume modules defined in `modules/`.

### Providers

Configurations for each cloud provider are located in `providers/`. Authenticate with the respective CLI before running Terraform (OCI, AWS CLI, gcloud, az).
