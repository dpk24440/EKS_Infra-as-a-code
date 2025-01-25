# General Cluster Information
variable "cluster_name" {
  description = "(Required) Specifies the name of the EKS cluster."
  type        = string
}

variable "aws_region" {
  description = "(Required) Specifies the AWS region where the EKS cluster will be deployed."
  type        = string
  default     = "ap-southeast-1"
}

# DNS and Network Settings
variable "dns_service_ip" {
  description = "Specifies the DNS service IP for the EKS cluster."
  default     = "10.2.0.10"
  type        = string
}

variable "service_cidr" {
  description = "Specifies the service CIDR for the EKS cluster."
  default     = "10.2.0.0/24"
  type        = string
}

# EKS Cluster Settings
variable "kubernetes_version" {
  description = "Specifies the Kubernetes version for the EKS cluster."
  default     = "1.27"
  type        = string
}

variable "private_cluster_enabled" {
  description = "Should the EKS cluster have its API server only accessible on private IP addresses? Defaults to true."
  type        = bool
  default     = true
}

# Node Groups
variable "default_node_group_name" {
  description = "Specifies the name of the default node group."
  default     = "system"
  type        = string
}

variable "default_node_group_instance_type" {
  description = "Specifies the instance type of the default node group."
  default     = "t3.medium"
  type        = string
}

variable "default_node_group_min_size" {
  description = "(Required) The minimum number of nodes in the default node group."
  type        = number
  default     = 3
}

variable "default_node_group_max_size" {
  description = "(Required) The maximum number of nodes in the default node group."
  type        = number
  default     = 5
}

variable "default_node_group_desired_capacity" {
  description = "(Optional) The desired number of nodes in the default node group."
  type        = number
  default     = 3
}

variable "node_group_availability_zones" {
  description = "Specifies the availability zones for the default node group."
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list(string)
}

variable "enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaling for the default node group. Defaults to true."
  type        = bool
  default     = true
}

variable "max_pods_per_node" {
  description = "(Optional) The maximum number of pods that can run on each node."
  type        = number
  default     = 50
}

# Authentication and SSH Access
variable "admin_username" {
  description = "(Required) Specifies the admin username for worker nodes."
  type        = string
  default     = "eksadmin"
}

variable "ssh_public_key" {
  description = "(Required) Specifies the SSH public key used to access the cluster."
  type        = string
}

# Role-Based Access Control
variable "role_based_access_control_enabled" {
  description = "(Required) Is RBAC enabled for the EKS cluster? Defaults to true."
  type        = bool
  default     = true
}

# Environment
variable "environment" {
  description = "Specifies the name of the environment."
  default     = "dev"
  type        = string
}

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

variable "default_node_pool_vm_size" {
  type = string
}

variable "availability_zones" {
  type = list(string)


}