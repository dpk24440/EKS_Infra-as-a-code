
# Define an IAM Role for EKS with a trust policy
resource "aws_iam_role" "eks_role" {
  name               = "eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

# Trust policy for EKS
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Define IAM policies for network-related permissions
resource "aws_iam_policy" "network_contributor_policy" {
  name        = "NetworkContributorPolicy"
  description = "Grants network-related permissions to EKS resources."

  policy = data.aws_iam_policy_document.network_contributor.json
}

data "aws_iam_policy_document" "network_contributor" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:CreateRoute",
      "ec2:DeleteRoute"
    ]
    resources = ["*"]
  }
}

# Attach the network contributor policy to the EKS role
resource "aws_iam_role_policy_attachment" "eks_network_contributor" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.network_contributor_policy.arn
}

# Define a read-only policy for resource group equivalent
resource "aws_iam_policy" "reader_policy" {
  name        = "ReaderPolicy"
  description = "Read-only permissions for resources."

  policy = data.aws_iam_policy_document.reader_policy.json
}

data "aws_iam_policy_document" "reader_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeSecurityGroups"
    ]
    resources = ["*"]
  }
}

# Attach the read-only policy to the EKS role
resource "aws_iam_role_policy_attachment" "eks_reader" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.reader_policy.arn
}

# Define a Contributor policy (e.g., for application gateway equivalent)
resource "aws_iam_policy" "app_gw_contributor_policy" {
  name        = "AppGWContributorPolicy"
  description = "Contributor permissions for application gateway."

  policy = data.aws_iam_policy_document.app_gw_contributor.json
}

data "aws_iam_policy_document" "app_gw_contributor" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:*",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups"
    ]
    resources = ["*"]
  }
}

# Attach the Contributor policy to the EKS role
resource "aws_iam_role_policy_attachment" "eks_app_gw_contributor" {
  role       = aws_iam_role.eks_role.name
  policy_arn = aws_iam_policy.app_gw_contributor_policy.arn
}
