# VPC for AKS
resource "aws_vpc" "aks_vpc" {
  cidr_block = var.EKS_ADDRESS_SPACE
  tags = {
    Name = var.EKS_VPC_NAME
  }
}

resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.aks_vpc.id
  cidr_block        = var.EKS_SUBNET_ADDRESS_PREFIX
  availability_zone = var.AWS_REGION
  tags = {
    Name = var.EKS_SUBNET_NAME
  }
}

resource "aws_subnet" "appgw_subnet" {
  vpc_id            = aws_vpc.aks_vpc.id
  cidr_block        = var.APPGW_SUBNET_ADDRESS_PREFIX
  availability_zone = var.AWS_REGION
  tags = {
    Name = var.APPGW_SUBNET_NAME
  }
}

# VPC for ACR
resource "aws_vpc" "acr_vpc" {
  cidr_block = var.ECR_ADDRESS_SPACE
  tags = {
    Name = var.ECR_VPC_NAME
  }
}

resource "aws_subnet" "acr_subnet" {
  vpc_id            = aws_vpc.acr_vpc.id
  cidr_block        = var.ECR_SUBNET_ADDRESS_PREFIX
  availability_zone = var.AWS_REGION
  tags = {
    Name = var.ECR_SUBNET_NAME
  }
}

# VPC for Self-hosted Agents
resource "aws_vpc" "agent_vpc" {
  cidr_block = var.AGENT_ADDRESS_SPACE
  tags = {
    Name = var.AGENT_VPC_NAME
  }
}

resource "aws_subnet" "agent_subnet" {
  vpc_id            = aws_vpc.agent_vpc.id
  cidr_block        = var.AGENT_SUBNET_ADDRESS_PREFIX
  availability_zone = var.AWS_REGION
  tags = {
    Name = var.AGENT_SUBNET_NAME
  }
}

# VPC Peering between AKS and ACR
resource "aws_vpc_peering_connection" "aks_acr" {
  vpc_id      = aws_vpc.aks_vpc.id
  peer_vpc_id = aws_vpc.acr_vpc.id
  auto_accept = true
  tags = {
    Name = "akstoacr"
  }
}

# VPC Peering between ACR and Agents
resource "aws_vpc_peering_connection" "acr_agent" {
  vpc_id      = aws_vpc.acr_vpc.id
  peer_vpc_id = aws_vpc.agent_vpc.id
  auto_accept = true
  tags = {
    Name = "acrtoagent"
  }
}

# VPC Peering between AKS and Agents
resource "aws_vpc_peering_connection" "aks_agent" {
  vpc_id      = aws_vpc.aks_vpc.id
  peer_vpc_id = aws_vpc.agent_vpc.id
  auto_accept = true
  tags = {
    Name = "ekstoagent"
  }
}

# Route tables and route propagation for VPC peering
resource "aws_route_table" "aks_route_table" {
  vpc_id = aws_vpc.aks_vpc.id
  route {
    #cidr_block                = var.ACR_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.aks_acr.id
  }
  route {
    cidr_block                = var.AGENT_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.aks_agent.id
  }
}

resource "aws_route_table" "acr_route_table" {
  vpc_id = aws_vpc.acr_vpc.id
  route {
    cidr_block                = var.EKS_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.aks_acr.id
  }
  route {
    cidr_block                = var.AGENT_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.acr_agent.id
  }
}

resource "aws_route_table" "agent_route_table" {
  vpc_id = aws_vpc.agent_vpc.id
  route {
    cidr_block                = var.EKS_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.aks_agent.id
  }
  route {
    cidr_block                = var.ECR_ADDRESS_SPACE
    vpc_peering_connection_id = aws_vpc_peering_connection.acr_agent.id
  }
}
