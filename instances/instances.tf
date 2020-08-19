// Ubuntu 16.04 AMI
data "aws_ami" "ubuntu1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// Security Group
resource "aws_security_group" "security_group" {
  name = "sg_ssh"
  vpc_id = var.vpc_id
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

// Bastion Host
resource "aws_instance" "bastion" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu1604.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = var.public_subnet
  source_dest_check      = false
  user_data              = templatefile("${path.module}/userdata-scripts/ubuntu-bastion-userdata-sftd.sh", { sftd_version = var.sftd_version, enrollment_token = var.enrollment_token })

  tags = {
    Name        = var.name
    Environment = var.environment
    terraform   = true
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

// Target Instances
resource "aws_instance" "target" {
  count                  = var.instances
  ami                    = data.aws_ami.ubuntu1604.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = var.private_subnet
  source_dest_check      = false
  user_data              = templatefile("${path.module}/userdata-scripts/ubuntu-userdata-sftd.sh", { sftd_version = var.sftd_version, enrollment_token = var.enrollment_token, instance = count.index})

  tags = {
    Name        = "${var.name}-${count.index}"
    Environment = var.environment
    terraform   = true
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}