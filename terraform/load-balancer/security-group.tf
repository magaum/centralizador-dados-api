resource "aws_security_group" "lb_sg" {
  name        = "Load Balancer SG"
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
  security_group_id = aws_security_group.lb_sg.id
}