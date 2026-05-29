# aws-app-production

**AWS production** — separate state from staging.

## Deployment modes

| Mode | Terraform flag | Hosts |
|------|----------------|-------|
| **All-in-one API** (current) | `enable_split_microservices = false` | backend (API+GEO+LLM) + salome |
| **Split microservices** | `enable_split_microservices = true` | backend + geo + llm + salome |

## Recommended sizing (split mode)

| Role | Instance | vCPU | RAM | Disk |
|------|----------|------|-----|------|
| Backend API | `m7i.2xlarge` | 8 | 32 GiB | 200 GiB gp3 |
| GEO | `c7i.4xlarge` | 16 | 32 GiB | 500 GiB gp3 |
| LLM/RAG | `m7i.xlarge` | 4 | 16 GiB | 200 GiB gp3 |
| Salome/FEM | `r7i.8xlarge` | 32 | 256 GiB | 1 TiB gp3 |

**Network:** Same VPC as staging (`10.2.0.0/16`), production subnet `10.2.2.0/24`.

Ansible inventory: `backend-aws-prod`, `salome-aws-prod`, and when split: `geo-aws-prod`, `llm-aws-prod`.

## Step 1 — Terraform (split mode)

```bash
cd infra_terraform
cp environments/aws-app-production/terraform.tfvars.example environments/aws-app-production/terraform.tfvars
# edit ssh_public_key, existing_vpc_id, enable_split_microservices = true
make init ENV=aws-app-production
make plan ENV=aws-app-production
make apply ENV=aws-app-production
make output ENV=aws-app-production
```

Note `geo_private_ip` and `llm_private_ip` from outputs — needed for Ansible nginx upstreams.

## Step 2 — Ansible inventory

Update `infra_ansible/inventories/prod/hosts.ini` with public IPs from Terraform outputs.

Set private IPs in `host_vars/backend-aws-prod.yml`:

```yaml
backend_split_microservices: true
nginx_geo_upstream: "http://<geo_private_ip>:8001"
nginx_llm_upstream: "http://<llm_private_ip>:8002"
geo_server_internal_url: "http://<geo_private_ip>:8001"
llm_server_internal_url: "http://<llm_private_ip>:8002"
```

## Step 3 — Provision hosts

```bash
cd infra_ansible
# GEO + LLM dedicated hosts
ansible-playbook -i inventories/prod/hosts.ini playbooks/site-geo-apps.yml --limit geo-aws-prod
ansible-playbook -i inventories/prod/hosts.ini playbooks/site-llm-apps.yml --limit llm-aws-prod
# Backend (Nginx routes / → local, /geo/ and /llm/ → private IPs)
ansible-playbook -i inventories/prod/hosts.ini playbooks/site-backend-apps.yml --limit backend-aws-prod -e deploy_filter_systemd=backendserver
```

Public URLs stay unchanged: `https://api.mek-lab.com/`, `/geo/`, `/llm/`.
