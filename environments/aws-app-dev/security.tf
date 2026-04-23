module "security" {
  source = "../../modules/security-rules"

  name          = "${local.name_prefix}-sg"
  description   = "Security group for app host"
  vpc_id        = module.network.vpc_id
  ingress_rules = local.ingress_rules
}
