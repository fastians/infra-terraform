# aws-app-production

**AWS production** — new stack, separate state from staging.

| Role | Instance | Disk |
|------|----------|------|
| Backend (includes GEO) | `m6i.2xlarge` (8 vCPU, 32 GiB) | 80 GiB gp3 |
| Salome | `m6i.2xlarge` (8 vCPU, 32 GiB) | 100 GiB gp3 |

**Network:** Uses the **same VPC as staging** (`10.2.0.0/16`) with a dedicated subnet `10.2.2.0/24` (staging uses `10.2.1.0/24`). This avoids creating a 6th VPC when the AWS account is at the VPC quota limit. Staging and production remain separate EC2 instances and security groups.

Ansible: `backend-aws-prod`, `salome-aws-prod` (uncomment in `infra_ansible/inventories/prod/hosts.ini` after apply).

```bash
cd infra_terraform
cp environments/aws-app-production/terraform.tfvars.example environments/aws-app-production/terraform.tfvars
# edit ssh_public_key
make init ENV=aws-app-production
make plan ENV=aws-app-production
make apply ENV=aws-app-production
make output ENV=aws-app-production
```

Then set `ansible_host` from outputs and enable `[backend_production]` / `[salome_production]` in inventory.
