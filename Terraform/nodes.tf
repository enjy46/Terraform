resource "aws_eks_node_group" "team2" {
  cluster_name    = aws_eks_cluster.team2.name
  node_group_name = "team-2-node-group"
  node_role_arn   = aws_iam_role.team2_node_role.arn
  subnet_ids      = concat(
    aws_subnet.public[*].id, 
    aws_subnet.private[*].id
  )

  instance_types = ["t2.micro"] // Add this line

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = 1
    min_size     = 1
  }

  tags = {
    Name = "team-2-node-group"
  }
}

resource "aws_iam_role" "team2_node_role" {
  name        = "team-2-node-role"
  description = "EKS node role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "team-2-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.team2_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.team2_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.team2_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.team2_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_security_group" "team2_sg" {
  vpc_id = aws_vpc.team2.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
    }  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "team-2-eks-nodes-sg"
  }
}
