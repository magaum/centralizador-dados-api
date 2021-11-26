output "new_product_arn" {
  value = aws_sqs_queue.produtos_api.arn
}

output "glue_raw_file_arn" {
    value = aws_sqs_queue.new_file_raw_queue.arn
}

output "glue_processed_file_arn" {
    value = aws_sqs_queue.new_file_processed_queue.arn
}