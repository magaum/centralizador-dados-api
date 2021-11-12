resource "aws_ecr_repository" "s3_worker" {
  name                 = "s3-worker"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
