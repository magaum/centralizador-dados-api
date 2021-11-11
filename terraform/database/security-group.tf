resource "aws_security_group" "es" {
  name        = "${var.vpc_id}-elasticsearch-${var.domain}"
  description = "ES SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
    ]
  }
}