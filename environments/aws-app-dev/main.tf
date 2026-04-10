resource "aws_key_pair" "dev" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}
