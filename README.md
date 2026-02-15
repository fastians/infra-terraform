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
│   ├── dev/
│   ├── staging/
│   └── prod/
├── providers/              ← Provider configurations (AWS, GCP, Oracle)
│   ├── aws.tf
│   ├── gcp.tf
│   └── oracle.tf
└── global/                 ← Global settings and versions
    └── versions.tf
```

## Usage

Each environment in `environments/` manages its own state and can consume modules defined in `modules/`.

### Providers
Configurations for each cloud provider are located in `providers/`. Make sure your local environment is authenticated with the respective CLIs.
