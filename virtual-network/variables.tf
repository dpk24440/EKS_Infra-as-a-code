# Variables for EKS VPC and Subnets
variable "EKS_VPC_NAME" {
  type = string
}

variable "EKS_ADDRESS_SPACE" {
  type = string
}

variable "EKS_SUBNET_NAME" {
  type = string
}

variable "EKS_SUBNET_ADDRESS_PREFIX" {
  type = string
}

variable "APPGW_SUBNET_NAME" {
  type = string
}

variable "APPGW_SUBNET_ADDRESS_PREFIX" {
  type = string
}

# Variables for ECR VPC (equivalent to ACR in Azure)
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
  type = string
}

variable "AGENT_ADDRESS_SPACE" {
  type = string
}

variable "AGENT_SUBNET_NAME" {
  type = string
}

variable "AGENT_SUBNET_ADDRESS_PREFIX" {
  type = string
}

# AWS Region (replaces Azure "LOCATION")
variable "AWS_REGION" {
  type = string
}
