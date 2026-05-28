module "security" {
  source = "../../modules/security-rules"

  name          = var.security_group_name
  description   = "Shared SG for backend (8000-8002) and salome (8000) hosts in aws-app-staging"
  vpc_id        = module.network.vpc_id
  ingress_rules = local.ingress_rules
}
