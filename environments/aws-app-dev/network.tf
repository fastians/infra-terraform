module "network" {
  source = "../../modules/network"

  name_prefix        = "aws-app-dev"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = data.aws_availability_zones.available.names[0]
}
