## VPC Setup
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.EKS_ADDRESS_SPACE
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_subnet" {
  count = length(var.EKS_SUBNET_ADDRESS_PREFIX)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = element(var.EKS_SUBNET_ADDRESS_PREFIX, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-subnet-${count.index}"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.eks_subnet[*].id
  node_group_name = var.default_node_group_name

  scaling_config {
    desired_size = var.default_node_group_desired_capacity
    max_size     = var.default_node_group_max_size
    min_size     = var.default_node_group_min_size
  }

  instance_types = ["t2.small"]

  tags = {
    Name = "eks-node-group"
  }
}

# Route 53 Private DNS Zone
resource "aws_route53_zone" "private_dns_zone" {
  name = "privatelink.centralindia.k8s.io"
  vpc {
    vpc_id = aws_vpc.eks_vpc.id
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_policy.json
}

data "aws_iam_policy_document" "eks_cluster_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_policy.json
}

data "aws_iam_policy_document" "eks_node_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
  role       = aws_iam_role.eks_node_role.name
}

# Application Load Balancer (Replacing App Gateway)
resource "aws_lb" "eks_alb" {
  name               = "eks-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_lb_sg.id]
  subnets            = aws_subnet.eks_subnet[*].id
}

# Security Groups
resource "aws_security_group" "eks_lb_sg" {
  vpc_id = aws_vpc.eks_vpc.id

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
}
