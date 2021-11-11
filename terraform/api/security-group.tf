resource "aws_security_group" "produtos_api_ecs_security_group" {
  name        = "ECS Security group"
  description = "ECS Trafic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_outbound_security_group" {
  description       = "Outbound VPC"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.produtos_api_ecs_security_group.id
}

resource "aws_security_group" "http_security_group" {
  name        = "VPC Security group"
  description = "Allowed HTTP Trafic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "security_group_inbound_rule" {
  type              = "ingress"
  description       = "Http inbound VPC"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.http_security_group.id
}

resource "aws_security_group_rule" "ecs_inbound_security_group" {
  description              = "Inbound ecs"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.produtos_api_ecs_security_group.id
  source_security_group_id = aws_security_group.http_security_group.id
}