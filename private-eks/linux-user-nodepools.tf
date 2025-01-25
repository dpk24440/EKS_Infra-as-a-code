## AWS EKS Managed Node Group for Linux Nodes
resource "aws_eks_node_group" "linux_node_pool" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.default_node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.eks_subnet.ids

  scaling_config {
    desired_size = var.default_node_group_desired_capacity
    max_size     = var.default_node_group_max_size
    min_size     = var.default_node_group_min_size
  }

  instance_types = [var.default_node_pool_vm_size] # EC2 instance type
  ami_type       = "AL2_x86_64"                    # Amazon Linux 2 (x86_64 architecture)

  capacity_type = "ON_DEMAND" # Change to "SPOT" for spot instances

  labels = {
    "environment" = var.environment
    "nodepoolos"  = "linux"
    "app"         = "user-apps"
  }

  tags = {
    "Name"        = "${var.environment}-linux-nodepool"
    "Environment" = var.environment
  }

  launch_template {
    id      = aws_launch_template.eks_linux_template.id
    version = "$Latest"
  }
}

# AWS Launch Template for Linux Nodes
resource "aws_launch_template" "eks_linux_template" {
  name_prefix   = "${var.environment}-linux-nodepool"
  instance_type = var.default_node_pool_vm_size

  # Security group and subnet configurations
  network_interfaces {
    associate_public_ip_address = var.default_node_pool_enable_node_public_ip
    security_groups             = [aws_security_group.eks_node_sg.id]
  }

  # Disk configuration
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20 # Adjust as needed
      volume_type = "gp3"
    }
  }

  # Add SSH Key
  key_name = var.ssh_public_key
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_policy.json
}

data "aws_iam_policy_document" "eks_node_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Attach policies to the IAM Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
