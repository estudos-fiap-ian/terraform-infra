# Before im using aws standard, so i can create users, roles, policies
# now i need to use aws academy

# resource "aws_security_group" "sg" {
#   vpc_id = aws_vpc.new-vpc.id
#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#     prefix_list_ids = []
#   }
#   tags = {
#     Name = "${var.prefix}-sg"
#   }
# }

# resource "aws_iam_role" "cluster" {
#   name               = "${var.prefix}-${var.cluster_name}-role"
#   assume_role_policy = <<POLICY
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Service": "eks.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#       }
#     ]
#   }
#   POLICY
# }

# resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
#   role       = aws_iam_role.cluster.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
# }

# resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
#   role       = aws_iam_role.cluster.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_cloudwatch_log_group" "log" {
#   name              = "/aws/eks/${var.prefix}-${var.cluster_name}/cluster"
#   retention_in_days = var.log_retention_days
# }

# resource "aws_eks_cluster" "cluster" {
#   name                      = "${var.prefix}-${var.cluster_name}"
#   role_arn                  = aws_iam_role.cluster.arn
#   enabled_cluster_log_types = ["api", "audit"]

#   vpc_config {
#     subnet_ids         = aws_subnet.subnets[*].id
#     security_group_ids = [aws_security_group.sg.id]
#   }

#   depends_on = [
#     aws_cloudwatch_log_group.log,
#     aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController
#   ]
# }

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.new-vpc.id
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.prefix}-sg"
  }
}

# Use existing IAM role instead of creating new one
data "aws_iam_role" "cluster" {
  name = "LabRole" # This is the default role name in AWS Academy
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/aws/eks/${var.prefix}-${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
}

resource "aws_eks_cluster" "cluster" {
  name                      = "${var.prefix}-${var.cluster_name}"
  role_arn                  = data.aws_iam_role.cluster.arn
  enabled_cluster_log_types = ["api", "audit"]
  vpc_config {
    subnet_ids         = aws_subnet.subnets[*].id
    security_group_ids = [aws_security_group.sg.id]
  }
  depends_on = [
    aws_cloudwatch_log_group.log
  ]
}
