# Use an existing EC2 key pair (e.g. AWS + AWS.pem). Creating a duplicate name fails.
data "aws_key_pair" "monitoring" {
  key_name = var.key_name
}
