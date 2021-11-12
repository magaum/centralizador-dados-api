resource "aws_security_group" "es" {
  name        = "Allow-http-https-elasticsearch-${var.domain}"
  description = "ES allow http and https sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr,
    ]
  }
}