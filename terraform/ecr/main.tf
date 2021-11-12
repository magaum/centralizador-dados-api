data "aws_caller_identity" "current" {}

resource "null_resource" "ecr_login" {
  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
    EOF
  }

  depends_on = [
    aws_ecr_repository.sqs_worker,
    aws_ecr_repository.s3_worker
  ]
}

#build and push to ecr
resource "null_resource" "build_s3_worker" {
  provisioner "local-exec" {
    command = <<EOF
      docker build --tag ${aws_ecr_repository.s3_worker.repository_url} ${path.root}/../src/sqs-worker
    EOF
  }

  depends_on = [
    aws_ecr_repository.sqs_worker,
    aws_ecr_repository.s3_worker
  ]
}

#build and push to ecr
resource "null_resource" "build_sqs_worker" {
  provisioner "local-exec" {
    command = <<EOF
      docker build --tag ${aws_ecr_repository.sqs_worker.repository_url} ${path.root}/../src/sqs-worker
    EOF
  }

  depends_on = [
    aws_ecr_repository.sqs_worker,
    aws_ecr_repository.s3_worker
  ]
}

resource "null_resource" "push_sqs_worker" {
  provisioner "local-exec" {
    command = <<EOF
      docker push ${aws_ecr_repository.sqs_worker.repository_url}
    EOF
  }

  depends_on = [
    null_resource.build_sqs_worker
  ]
}

resource "null_resource" "push_s3_worker" {
  provisioner "local-exec" {
    command = <<EOF
      docker push ${aws_ecr_repository.s3_worker.repository_url}
    EOF
  }

  depends_on = [
    null_resource.build_s3_worker
  ]
}