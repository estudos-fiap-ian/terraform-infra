# Data source to find the Kubernetes-managed NLB
data "aws_lb" "kubernetes_nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/go-web-api-service-lb"
  }
}

# If the Kubernetes NLB doesn't exist yet, create a temporary one
# This will be replaced by the Kubernetes-managed NLB once the service is deployed
resource "aws_lb" "golang_api_nlb" {
  count = length(try(data.aws_lb.kubernetes_nlb.arn, "")) == 0 ? 1 : 0

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
  count = length(try(data.aws_lb.kubernetes_nlb.arn, "")) == 0 ? 1 : 0

  name     = "${var.prefix}-golang-api-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
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
  count = length(try(data.aws_lb.kubernetes_nlb.arn, "")) == 0 ? 1 : 0

  load_balancer_arn = aws_lb.golang_api_nlb[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.golang_api_tg[0].arn
  }
}

data "aws_instances" "eks_nodes" {
  count = length(try(data.aws_lb.kubernetes_nlb.arn, "")) == 0 ? 1 : 0

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
  count = length(try(data.aws_lb.kubernetes_nlb.arn, "")) == 0 ? length(try(data.aws_instances.eks_nodes[0].ids, [])) : 0

  target_group_arn = aws_lb_target_group.golang_api_tg[0].arn
  target_id        = data.aws_instances.eks_nodes[0].ids[count.index]
  port             = 8080
}