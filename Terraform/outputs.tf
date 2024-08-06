output "cluster_name" {
  value       = aws_eks_cluster.team2.name
  description = "The name of the EKS cluster"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.team2.endpoint
  description = "The endpoint of the EKS cluster"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.team2.certificate_authority[0].data
  description = "The certificate authority data of the EKS cluster"
}

output "node_group_role_arn" {
  value       = aws_iam_role.team2_node_role.arn
  description = "The ARN of the IAM role for the node group"
}
