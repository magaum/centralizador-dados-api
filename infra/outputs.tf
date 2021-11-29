output "new_product_arn" {
  value = module.queue.new_product_arn
  
}

output "glue_raw_file_arn" {
    value = module.queue.glue_raw_file_arn
}

output "glue_processed_file_arn" {
    value = module.queue.glue_processed_file_arn
}

output "aws_glue_workflow_name" {
    value = module.etl.aws_glue_workflow_name
}