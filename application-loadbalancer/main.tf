variable "VPC_ID" {
  type        = string
  description = "The ID of the VPC where the Gateway Load Balancer will be deployed."
}

variable "SUBNET_IDS" {
  type        = list(string)
  description = "A list of subnet IDs where the Gateway Load Balancer will be deployed."
}

variable "GWLB_NAME" {
  type        = string
  description = "The name of the Gateway Load Balancer."
}

variable "TARGET_GROUP_NAME" {
  type        = string
  description = "The name of the target group for the Gateway Load Balancer."
}

variable "LISTENER_PORT" {
  type        = number
  description = "The port on which the Gateway Load Balancer will listen."
  default     = 80
}

## AWS Gateway Load Balancer
resource "aws_lb" "gwlb" {
  name                       = var.GWLB_NAME
  load_balancer_type         = "gateway"
  subnets                    = var.SUBNET_IDS
  enable_deletion_protection = false

  tags = {
    Name = var.GWLB_NAME
  }
}

# Target Group for GWLB
resource "aws_lb_target_group" "gwlb_target_group" {
  name     = var.TARGET_GROUP_NAME
  port     = 80
  protocol = "GENEVE"
  vpc_id   = var.VPC_ID

  health_check {
    protocol = "TCP"
  }

  tags = {
    Name = var.TARGET_GROUP_NAME
  }
}

# GWLB Listener
resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.arn
  protocol          = "GENEVE"
  port              = var.LISTENER_PORT
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  }
}
