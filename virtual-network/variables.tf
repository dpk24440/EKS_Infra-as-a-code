# Variables for EKS VPC and Subnets
variable "EKS_VPC_NAME" {
  type    = string
  default = "ecr-vpc"
}

variable "EKS_ADDRESS_SPACE" {
  type    = string
  default = "10.0.0.0/20"
}

variable "EKS_SUBNET_NAME" {
  type    = string
  default = "eks-subnet"
}

variable "EKS_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "10.0.0.0/22"
}

variable "APPGW_SUBNET_NAME" {
  type    = string
  default = "appgw-subnet"
}

variable "APPGW_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.16.0.0/22"
}

## Variables for ECR VPC (equivalent to ACR in Azure)
variable "ECR_VPC_NAME" {
  type = string
}

variable "ECR_ADDRESS_SPACE" {
  type = string
}

variable "ECR_SUBNET_NAME" {
  type = string
}

variable "ECR_SUBNET_ADDRESS_PREFIX" {
  type = string
}

# Variables for Self-hosted Agents VPC
variable "AGENT_VPC_NAME" {
  type    = string
  default = "agent-vpc"
}

variable "AGENT_ADDRESS_SPACE" {
  type    = string
  default = "172.16.0.0/20"
}

variable "AGENT_SUBNET_NAME" {
  type    = string
  default = "agent-subnet"
}

variable "AGENT_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.16.0.0/22"
}

# AWS Region (replaces Azure "LOCATION")
variable "AWS_REGION" {
  type = string

}
