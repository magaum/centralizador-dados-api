data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "glue_trigger" {
  name                 = "glue-trigger"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "null_resource" "ecr_login" {
  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
    EOF
  }

  depends_on = [
    aws_ecr_repository.glue_trigger
  ]
}

#build and push to ecr
resource "null_resource" "build_glue_trigger" {
  provisioner "local-exec" {
    command = <<EOF
      docker build --tag ${aws_ecr_repository.glue_trigger.repository_url} ${path.root}/..
    EOF
  }

  depends_on = [
    aws_ecr_repository.glue_trigger
  ]
}

resource "null_resource" "push_glue_trigger" {
  provisioner "local-exec" {
    command = <<EOF
      docker push ${aws_ecr_repository.glue_trigger.repository_url}
    EOF
  }

  depends_on = [
    null_resource.build_glue_trigger
  ]
}
