resource "aws_lb" "produtos_api" {
  name               = "produtos-api-lb"
  internal           = false
  idle_timeout       = "120"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_target_group" "produtos_api" {
  name        = "produtos-api-lb"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    path     = "/health"
    matcher  = "200"
    interval = 120
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.produtos_api]
}

resource "aws_lb_listener" "produtos_api_listenter" {
  load_balancer_arn = aws_lb.produtos_api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.produtos_api.arn
  }
}
