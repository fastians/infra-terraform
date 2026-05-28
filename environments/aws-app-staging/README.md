# aws-app-staging

**AWS staging** — existing VMs (unchanged IPs).

| Old AWS Name (console) | IP | New Name |
|------------------------|-----|----------|
| `mek-lab-app-prod-backend` | **3.35.138.242** | `mek-lab-app-staging-backend` |
| `mek-lab-app-prod-salome` | **13.209.14.89** | `mek-lab-app-staging-salome` |

Ansible: `backend-aws-staging`, `salome-aws-staging`.

| Role | Instance | Disk |
|------|----------|------|
| Backend | `t3.large` | 50 GiB gp3 |
| Salome | `t3.large` | 50 GiB gp3 |

VPC `10.2.0.0/16` (console VPC name may still show `mek-lab-app-prod-vpc`; tag `Name` → `mek-lab-app-staging-vpc`).

**Do not** resize to m6i here — use `aws-app-production` for production (`15.164.227.138` / `3.34.135.134`).

```bash
cd infra_terraform
make plan ENV=aws-app-staging   # should be in-place tag tweaks only (AMI/SG pinned)
```

Terraform state directory was renamed from `aws-app-prod`.
