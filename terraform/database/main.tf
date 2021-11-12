
resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type          = "t2.small.elasticsearch"
    zone_awareness_enabled = false
    # zone_awareness_config {
    #   availability_zone_count = 1
    # }
  }

  vpc_options {
    subnet_ids = [var.private_subnets_ids[0]]

    security_group_ids = [aws_security_group.es.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2" //gereral purpose
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${var.region}:*:domain/${var.domain}/*"
        }
    ]
}
CONFIG

  tags = {
    Domain      = var.domain
    Environment = var.env
  }

  depends_on = [aws_iam_service_linked_role.es]
}
