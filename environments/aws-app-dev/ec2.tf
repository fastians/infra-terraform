module "compute" {
  source = "../../modules/compute-instance"

  name                 = local.name_prefix
  ami_id               = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.dev.key_name
  subnet_id            = module.network.public_subnet_id
  security_group_ids   = [module.security.security_group_id]
  root_volume_type     = var.root_volume_type
  root_volume_size_gb  = var.root_volume_size_gb
  metadata_http_tokens = "required"
  extra_tags           = local.common_tags
}
