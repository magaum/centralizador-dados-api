resource "aws_security_group" "lb_sg" {
  name        = "Load Balancer SG"
  description = "Allowed HTTP Trafic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "security_group_inbound_rule" {
  type              = "ingress"
  description       = "Allow inbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "security_group_outbound_rule" {
  type              = "egress"
  description       = "Allow outbound traffic"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.lb_sg.id
}
