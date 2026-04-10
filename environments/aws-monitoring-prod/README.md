# AWS prod — dedicated monitoring host

Provisions a single Ubuntu EC2 instance tagged `Role = monitoring` for the full observability stack (installed by **infra-ansible**, not by this module).

## Stack on this VM (Ansible)

- **Prometheus** — scrapes Node Exporter and FastAPI `/metrics` on app hosts; optional Blackbox probes.
- **Grafana** — dashboards; datasources Prometheus, Loki, Alertmanager.
- **Loki** — log ingestion from Promtail on app servers.
- **Alertmanager** — alert delivery (e.g. Telegram).
- **Blackbox Exporter** — synthetic HTTP checks toward public URLs.
- **Node Exporter** — this host’s OS metrics.

## Usage

```bash
cd environments/aws-monitoring-prod
cp terraform.tfvars.example terraform.tfvars   # if present; edit ssh key, region, CIDR
terraform init
terraform plan
terraform apply
terraform output -raw public_ip   # paste into infra-ansible inventories/prod/hosts.ini (monitoring-aws)
```

Restrict `ingress_source_cidr` to your office IP `/32` in production so Grafana/Prometheus ports are not world-open.
