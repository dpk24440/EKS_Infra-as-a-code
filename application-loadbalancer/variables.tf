variable "VPC_ID" {
  type        = string
  description = "The ID of the VPC where the Application Load Balancer will be deployed."
}

variable "ALB_NAME" {
  type        = string
  description = "The name of the Application Load Balancer. Use only lowercase letters and numbers."
}

variable "AWS_REGION" {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS region where the ALB will be created."
}

variable "PUBLIC_SUBNET_IDS" {
  type        = list(string)
  description = "A list of public subnet IDs where the ALB will be deployed."
}

variable "ALB_SECURITY_GROUP_ID" {
  type        = string
  description = "The security group ID to attach to the ALB."
}
