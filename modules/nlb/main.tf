# Create a Network Load Balancer for API Gateway VPC Link integration
# This NLB will initially target EKS nodes directly via NodePort
# Later, when Kubernetes LoadBalancer service is deployed, it will be replaced
resource "aws_lb" "golang_api_nlb" {
  name               = "${var.prefix}-golang-api-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.prefix}-golang-api-nlb"
  }
}

# Security group for VPC Link access to NLB
resource "aws_security_group" "vpc_link_sg" {
  name_prefix = "${var.prefix}-vpc-link-"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from API Gateway VPC Link"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC CIDR
  }

  ingress {
    description = "Allow custom port from API Gateway VPC Link"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-vpc-link-sg"
  }
}

# Security group rule for EKS nodes to allow NLB health checks
data "aws_security_groups" "eks_node_sg" {
  filter {
    name   = "group-name"
    values = ["eks-cluster-sg-${var.prefix}-${var.cluster_name}-*"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group_rule" "eks_nodes_nlb_access" {
  count             = length(data.aws_security_groups.eks_node_sg.ids)
  type              = "ingress"
  from_port         = 30080
  to_port           = 30080
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]  # Allow from VPC
  security_group_id = data.aws_security_groups.eks_node_sg.ids[count.index]
  description       = "Allow NLB health checks on NodePort 30080"
}

resource "aws_lb_target_group" "golang_api_tg" {
  name     = "${var.prefix}-golang-api-tg"
  port     = 30080  # NodePort from Kubernetes service
  protocol = "TCP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/ping"  # Use /ping endpoint for health check
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.prefix}-golang-api-tg"
  }
}

# Original listener on port 8080 (keeping existing resource name)
resource "aws_lb_listener" "golang_api_listener" {
  load_balancer_arn = aws_lb.golang_api_nlb.arn
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.golang_api_tg.arn
  }
}

# Additional listener on port 80 for API Gateway VPC Link
resource "aws_lb_listener" "golang_api_listener_80" {
  load_balancer_arn = aws_lb.golang_api_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.golang_api_tg.arn
  }
}

# Get the Auto Scaling Group from the EKS node group
data "aws_eks_node_group" "node_group" {
  cluster_name    = "${var.prefix}-${var.cluster_name}"  # Use full cluster name
  node_group_name = "node-1"
  depends_on      = [var.node_group_arn]
}

# Get instances from the Auto Scaling Group
data "aws_autoscaling_group" "eks_asg" {
  name       = data.aws_eks_node_group.node_group.resources[0].autoscaling_groups[0].name
  depends_on = [data.aws_eks_node_group.node_group]
}

# Register ASG instances as targets
resource "aws_autoscaling_attachment" "golang_api_asg_attachment" {
  autoscaling_group_name = data.aws_autoscaling_group.eks_asg.name
  lb_target_group_arn    = aws_lb_target_group.golang_api_tg.arn
}