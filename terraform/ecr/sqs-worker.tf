resource "aws_ecr_repository" "sqs_worker" {
  name                 = "sqs-worker"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
