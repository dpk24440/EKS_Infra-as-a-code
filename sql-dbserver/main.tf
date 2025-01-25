## Lookup an existing subnet
data "aws_subnet" "eks_subnet" {
  filter {
    name   = "tag:Name"
    values = ["eks-subnet"]
  }
}

output "subnet_id" {
  value = data.aws_subnet.eks_subnet.id
}

output "subnet_name" {
  value = data.aws_subnet.eks_subnet.tags["Name"]
}

output "subnet_cidr_block" {
  value = data.aws_subnet.eks_subnet.cidr_block
}

# RDS Database Instance
resource "aws_db_instance" "db_instance" {
  identifier              = var.DB_IDENTIFIER
  instance_class          = var.DB_INSTANCE_CLASS
  allocated_storage       = 20
  engine                  = "mysql" # Replace with your database engine, e.g., "postgres"
  engine_version          = "8.0"   # Replace with your version, e.g., "14.6" for PostgreSQL
  username                = var.DB_USERNAME
  password                = var.DB_PASSWORD
  db_name                 = var.DB_NAME
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  subnet_ids              = [data.aws_subnet.eks_subnet.id]
  multi_az                = false
  storage_type            = "gp2"
  deletion_protection     = false
  backup_retention_period = 7
}

# Security group for the RDS instance
resource "aws_security_group" "db_sg" {
  name_prefix = "db-sg-"

  ingress {
    from_port   = 3306 # Replace with your database port, e.g., 5432 for PostgreSQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Replace with your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Subnet group for the RDS instance
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [data.aws_subnet.eks_subnet.id]
}

output "db_instance_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.db_instance.id
}
