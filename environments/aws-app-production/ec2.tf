module "backend" {
  source = "../../modules/compute-instance"

  name                 = "${local.name_prefix}-backend"
  ami_id               = data.aws_ami.ubuntu.id
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
  ami_id               = data.aws_ami.ubuntu.id
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

# Optional split microservices (GEO + LLM on dedicated hosts).
# Set enable_split_microservices = true in terraform.tfvars to create these.
module "geo" {
  count = var.enable_split_microservices ? 1 : 0

  source = "../../modules/compute-instance"

  name                 = "${local.name_prefix}-geo"
  ami_id               = data.aws_ami.ubuntu.id
  instance_type        = var.geo_instance_type
  key_name             = aws_key_pair.prod.key_name
  subnet_id            = module.network.public_subnet_id
  security_group_ids   = [module.security.security_group_id]
  root_volume_type     = var.root_volume_type
  root_volume_size_gb  = var.geo_root_volume_size_gb
  metadata_http_tokens = "required"
  extra_tags = merge(
    local.common_tags,
    { Role = "geo" }
  )
}

module "llm" {
  count = var.enable_split_microservices ? 1 : 0

  source = "../../modules/compute-instance"

  name                 = "${local.name_prefix}-llm"
  ami_id               = data.aws_ami.ubuntu.id
  instance_type        = var.llm_instance_type
  key_name             = aws_key_pair.prod.key_name
  subnet_id            = module.network.public_subnet_id
  security_group_ids   = [module.security.security_group_id]
  root_volume_type     = var.root_volume_type
  root_volume_size_gb  = var.llm_root_volume_size_gb
  metadata_http_tokens = "required"
  extra_tags = merge(
    local.common_tags,
    { Role = "llm" }
  )
}
