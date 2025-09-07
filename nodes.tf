# Use existing IAM role instead of creating new one
data "aws_iam_role" "node" {
  name = "LabRole" # This is the default role name in AWS Academy
}

resource "aws_eks_node_group" "node-1" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "node-1"
  node_role_arn   = data.aws_iam_role.node.arn
  subnet_ids      = aws_subnet.subnets[*].id
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.minimum_size
  }
}
