# CLAUDE.md - Terraform Platform Conventions

This document defines how infrastructure changes are made in `infra_terraform`.

## Engineering Principles

- Prefer small, reviewable changes over broad rewrites.
- Keep each environment in `environments/` as an isolated Terraform root/state.
- Favor reusable modules for repeated patterns (`network`, `compute-instance`, `security-rules`).
- Treat security defaults seriously: narrow CIDRs and enforce IMDSv2.
- Never hardcode cloud credentials or private keys in code.

## Directory Intent

- `environments/<name>/`: concrete deployment roots and state boundaries.
- `modules/`: reusable building blocks with stable inputs/outputs.
- `providers/` and `global/`: shared references/examples for provider/version patterns.

## Required Workflow For Changes

From repository root:

```bash
terraform fmt -recursive infra_terraform
terraform -chdir=infra_terraform/environments/<env> init
terraform -chdir=infra_terraform/environments/<env> validate
terraform -chdir=infra_terraform/environments/<env> plan
```

## Style and Structure Rules

- Use typed variables with clear descriptions and validation where needed.
- Keep naming deterministic via `locals` (`project_name + environment`).
- Use a `common_tags` local and pass tags explicitly to modules/resources.
- Expose only operationally useful outputs (IPs, IDs, SSH hints).
- Keep `terraform.tfvars.example` realistic and synchronized with variables.

## Security Baseline

- Default root volume type: `gp3`; enforce size guardrails where required.
- Use IMDSv2 (`metadata_http_tokens = "required"`).
- Avoid `0.0.0.0/0` except for temporary bootstrap/dev.
- Restrict SSH access to known source CIDRs.
- Do not commit secrets; store sensitive values in secure secret stores or CI variables.

## PR Checklist

- [ ] Change is scoped to the intended environment/module.
- [ ] `terraform fmt`, `validate`, and `plan` completed successfully.
- [ ] Variable and output docs/examples updated.
- [ ] Security implications reviewed (ingress, IAM, encryption).
- [ ] Rollback/destroy impact understood.
