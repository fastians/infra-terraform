resource "aws_key_pair" "dev" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.dev.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  tags = {
    Name = "dev-monitor"
  }
}

resource "aws_instance" "monitoring_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.dev.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  tags = {
    Name = "monitoring-server"
  }
}
