output "s3_url" {
  value = aws_ecr_repository.s3_worker.repository_url
}

output "sqs_url" {
  value = aws_ecr_repository.sqs_worker.repository_url
}