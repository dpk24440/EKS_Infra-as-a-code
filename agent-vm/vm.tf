/*# Variables

# Retrieve VPC
data "aws_vpc" "default" {
  default = true
}
*/

# Retrieve Subnet
data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Create Security Group
resource "aws_security_group" "agent_sg" {
  name        = "${var.AGENT_VM_NAME}-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.AGENT_VM_NAME}-sg"
  }
}

# Elastic IP
resource "aws_eip" "public_ip" {
  vpc = true
}

# EC2 Instance
resource "aws_instance" "agent_vm" {
  ami                         = var.AMI_ID
  instance_type               = var.INSTANCE_TYPE
  subnet_id                   = data.aws_subnet.default.id
  key_name                    = var.KEY_NAME # Use the provided SSH key pair name
  associate_public_ip_address = true
  security_group_ids          = [aws_security_group.agent_sg.id]

  tags = {
    Name = var.AGENT_VM_NAME
  }

  # User Data for Initial Configuration (optional)
  user_data = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y docker.io
  EOF
}

# Install Docker and Configure Self-Hosted Agent
resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    inline = [
      "bash ../agent-vm/script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"              # Default username for most AMIs (replace if different)
      private_key = file("~/.ssh/id_rsa") # Path to your private key
      host        = aws_instance.agent_vm.public_ip
      timeout     = "10m"
    }
  }

  depends_on = [aws_instance.agent_vm]
}

# Output the Public IP Address
output "public_ip" {
  value = aws_instance.agent_vm.public_ip
}


#########################################################

/*
# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "public-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

# Add Route to Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create Security Group
resource "aws_security_group" "ssh_access" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ssh-access-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 Instance
resource "aws_instance" "web_server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name = "public-ec2-instance"
  }
}

# Outputs
output "instance_id" {
  value = aws_instance.web_server.id
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  value = aws_instance.web_server.public_dns
}
*/