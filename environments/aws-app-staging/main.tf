resource "aws_key_pair" "prod" {
  key_name   = var.key_name
  public_key = var.ssh_public_key

  tags = local.common_tags
}
