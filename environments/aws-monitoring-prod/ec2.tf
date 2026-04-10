module "compute" {
  source = "../../modules/compute-instance"

  name                = "aws-monitoring-prod"
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = var.instance_type
  key_name            = data.aws_key_pair.monitoring.key_name
  subnet_id           = module.network.public_subnet_id
  security_group_ids  = [module.security.security_group_id]
  root_volume_type    = var.root_volume_type
  root_volume_size_gb = var.root_volume_size_gb
  extra_tags = {
    Project = "mek-lab"
    Role    = "monitoring"
  }
}
