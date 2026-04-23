resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size_gb
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens                 = var.metadata_http_tokens
    http_endpoint               = "enabled"
    http_put_response_hop_limit = var.metadata_hop_limit
  }

  tags = merge(
    {
      Name = var.name
    },
    var.extra_tags
  )
}
