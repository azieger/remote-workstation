data "aws_ami" "workstation_ami" {
  most_recent      = true
  name_regex       = var.ami_name
  owners           = ["self"]
}

# Deafult VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Creating a new security group for EC2 instance with ssh and http inbound rules
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group_workstation"
  description = "Allow SSH and vscode inbounds traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https for cert testing"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "remote_workstation" {
  ami           = data.aws_ami.workstation_ami.id
  availability_zone = "ca-central-1a"
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  instance_type = var.instance_type
  root_block_device {
    volume_size = "80"
  }
  tags = {
    Name = "remote_workstation"
  }
}

resource "aws_eip" "constant_ip" {
  instance = aws_instance.remote_workstation.id
}

data "cloudflare_zone" "dns_zone" {
  name = var.workstation_domain_name
}

resource "cloudflare_record" "workstation_dns_record" {
  zone_id = data.cloudflare_zone.dns_zone.id
  name    = "${var.workstation_domain_prefix}.${var.workstation_domain_name}"
  value   = aws_eip.constant_ip.public_ip
  type    = "A"
  ttl     = 120
}
