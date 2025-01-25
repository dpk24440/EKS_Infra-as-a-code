# Variables for Self-hosted Agents VPC
variable "AGENT_VPC_NAME" {
  type    = string
  default = "agent-vpc"
}

variable "AGENT_ADDRESS_SPACE" {
  type    = string
  default = "192.168.0.0"
}

variable "AGENT_SUBNET_NAME" {
  type    = string
  default = ""
}

variable "AGENT_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "192.168.0.0/22"
}

variable "AGENT_VM_NAME" {
  type        = string
  default     = "my-agent-vm"
  description = "The name of the EC2 instance (equivalent to AGENT_VM_NAME in Azure)"
}

variable "AWS_REGION" {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS region where the EC2 instance will be deployed (equivalent to LOCATION in Azure)"
}

variable "INSTANCE_TYPE" {
  type        = string
  default     = "t2.micro"
  description = "The instance type for the EC2 instance (equivalent to VM_SIZE in Azure)"
}

variable "AMI_ID" {
  type        = string
  default     = "ami-0abcdef1234567890" # Replace with your desired AMI ID
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance"
}

variable "KEY_NAME" {
  type        = string
  default     = "my-key-pair"
  description = "The name of the SSH key pair to use for authentication (replaces ADMIN_USERNAME and ADMIN_PASSWORD)"
}

variable "USER_DATA" {
  type        = string
  description = "Optional user data script to bootstrap the instance (e.g., Docker installation)"
  default     = ""
}
#######################################################################
#######################################################################

variable "AGENT_VM_NAME" {
  type        = string
  default     = "my-agent-vm"
  description = "The name of the EC2 instance (equivalent to AGENT_VM_NAME in Azure)"
}

variable "AWS_REGION" {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS region where the EC2 instance will be deployed (equivalent to LOCATION in Azure)"
}

variable "VPC_ID" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The ID of the VPC where the EC2 instance will be deployed (equivalent to RESOURCE_GROUP_NAME in Azure)"
}

variable "SUBNET_ID" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The ID of the subnet where the EC2 instance will reside (related to Azure virtual networks/subnets)"
}

variable "INSTANCE_TYPE" {
  type        = string
  default     = "t2.micro"
  description = "The instance type for the EC2 instance (equivalent to VM_SIZE in Azure)"
}

variable "AMI_ID" {
  type        = string
  default     = "ami-0abcdef1234567890" # Replace with your desired AMI ID
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance"
}

variable "KEY_NAME" {
  type        = string
  default     = "my-key-pair"
  description = "The name of the SSH key pair to use for authentication (replaces ADMIN_USERNAME and ADMIN_PASSWORD)"
}

variable "USER_DATA" {
  type        = string
  description = "Optional user data script to bootstrap the instance (e.g., Docker installation)"
  default     = ""
}


##############################################################
/*
# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet CIDR Block
variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Instance Type
variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}

# AMI ID
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

# Key Pair Name
variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

# Public SSH CIDR
variable "ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance"
  type        = string
  default     = "0.0.0.0/0"
}
*/