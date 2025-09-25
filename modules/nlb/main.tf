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

resource "aws_lb_listener" "golang_api_listener" {
  load_balancer_arn = aws_lb.golang_api_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.golang_api_tg.arn
  }
}

# Get EKS nodes to attach to target group
data "aws_instances" "eks_nodes" {
  depends_on = [var.cluster_name]  # Ensure this runs after EKS cluster is created

  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["${var.cluster_name}-*"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

resource "aws_lb_target_group_attachment" "golang_api_attachment" {
  count = length(data.aws_instances.eks_nodes.ids)

  target_group_arn = aws_lb_target_group.golang_api_tg.arn
  target_id        = data.aws_instances.eks_nodes.ids[count.index]
  port             = 30080  # NodePort
}