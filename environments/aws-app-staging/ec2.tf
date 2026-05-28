module "backend" {
  source = "../../modules/compute-instance"

  name                 = "${local.name_prefix}-backend"
  ami_id               = var.deployed_ami_id
  instance_type        = var.backend_instance_type
  key_name             = aws_key_pair.prod.key_name
  subnet_id            = module.network.public_subnet_id
  security_group_ids   = [module.security.security_group_id]
  root_volume_type     = var.root_volume_type
  root_volume_size_gb  = var.backend_root_volume_size_gb
  metadata_http_tokens = "required"
  extra_tags = merge(
    local.common_tags,
    { Role = "backend" }
  )
}

module "salome" {
  source = "../../modules/compute-instance"

  name                 = "${local.name_prefix}-salome"
  ami_id               = var.deployed_ami_id
  instance_type        = var.salome_instance_type
  key_name             = aws_key_pair.prod.key_name
  subnet_id            = module.network.public_subnet_id
  security_group_ids   = [module.security.security_group_id]
  root_volume_type     = var.root_volume_type
  root_volume_size_gb  = var.salome_root_volume_size_gb
  metadata_http_tokens = "required"
  extra_tags = merge(
    local.common_tags,
    { Role = "salome" }
  )
}
