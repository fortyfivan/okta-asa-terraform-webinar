// Ubuntu 16.04 AMI
data "google_compute_image" "my_image" {
  family = "ubuntu-1604-lts"
}
/*
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
  name   = "sg_ssh"
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
*/
// Bastion Host
resource "google_compute_instance" "bastion" {
  count = 1
  name  = "vm-bastion"
  #ami          = data.aws_ami.ubuntu1604.id
  machine_type = "f1-micro"
  #vpc_security_group_ids  = [aws_security_group.security_group.id]
  #subnet                  = var.public_subnet
  metadata_startup_script = templatefile("${path.module}/userdata-scripts/ubuntu-bastion-userdata-sftd.sh", { sftd_version = var.sftd_version, enrollment_token = var.enrollment_token })

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image
    }
  }

  tags = ["bastion"]

  metadata = {
    Name        = var.name
    Environment = var.environment
    terraform   = true
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  /*
  lifecycle {
    ignore_changes = [user_data]
  }
  */
}

// Target Instances
resource "google_compute_instance" "target" {
  count = var.instances
  #ami          = data.aws_ami.ubuntu1604.id
  name         = "vm-target"
  machine_type = "f1-micro"
  #vpc_security_group_ids  = [aws_security_group.security_group.id]
  #subnet                  = var.private_subnet
  metadata_startup_script = templatefile("${path.module}/userdata-scripts/ubuntu-userdata-sftd.sh", { sftd_version = var.sftd_version, enrollment_token = var.enrollment_token, instance = count.index })

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image
    }
  }

  metadata = {
    Name        = var.name,
    Environment = var.environment,
    terraform   = true
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  /*
  lifecycle {
    ignore_changes = [user_data]
  }
  */
}
