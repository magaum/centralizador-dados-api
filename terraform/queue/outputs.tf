output "arn" {
  value = aws_sqs_queue.produtos_api.arn
}

output "new_file_queue_arn" {
    value = aws_sqs_queue.new_file_queue.arn
}