# EKS Cluster Definition
resource "aws_eks_cluster" "team2" {
  name     = var.cluster_name
  role_arn = aws_iam_role.team2_eks_role.arn

  vpc_config {
    subnet_ids = concat(
      aws_subnet.public[*].id,
      aws_subnet.private[*].id
    )
  }

  tags = {
    Name = "team-2-cluster"
  }
}

# IAM Role for EKS
resource "aws_iam_role" "team2_eks_role" {
  name        = "team-2-eks-role"
  description = "EKS cluster role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "team-2-eks-role"
  }
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.team2_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service" {
  role       = aws_iam_role.team2_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "vpc_resource_controller" {
  role       = aws_iam_role.team2_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}


