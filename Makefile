.PHONY: help fmt init validate plan apply destroy output check

ENV ?= aws-app-dev
ENV_DIR := environments/$(ENV)

help:
	@echo "infra_terraform helper targets"
	@echo ""
	@echo "Usage:"
	@echo "  make fmt"
	@echo "  make init ENV=aws-app-dev"
	@echo "  make check ENV=aws-app-dev"
	@echo "  make validate ENV=aws-app-dev"
	@echo "  make plan ENV=aws-app-dev"
	@echo "  make apply ENV=aws-app-dev"
	@echo "  make destroy ENV=aws-app-dev"
	@echo "  make output ENV=aws-app-dev"
	@echo ""
	@echo "Current ENV: $(ENV)"

fmt:
	terraform fmt -recursive .

init:
	terraform -chdir="$(ENV_DIR)" init

check: fmt init validate

validate:
	terraform -chdir="$(ENV_DIR)" validate

plan:
	terraform -chdir="$(ENV_DIR)" plan

apply:
	terraform -chdir="$(ENV_DIR)" apply

destroy:
	terraform -chdir="$(ENV_DIR)" destroy

output:
	terraform -chdir="$(ENV_DIR)" output
