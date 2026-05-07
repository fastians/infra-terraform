module "security" {
  source = "../../modules/security-rules"

  name          = "${local.name_prefix}-sg"
  description   = "Shared SG for backend (8000-8002) and salome (8000) hosts in aws-app-prod"
  vpc_id        = module.network.vpc_id
  ingress_rules = local.ingress_rules
}
