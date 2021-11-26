resource "aws_lambda_permission" "allow_glue_trigger" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.glue_trigger.arn
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_glue_raw_file_arn
}

resource "aws_lambda_event_source_mapping" "glue_trigger" {
  event_source_arn = var.sqs_glue_raw_file_arn
  function_name    = aws_lambda_function.glue_trigger.arn
  batch_size       = 1
  enabled          = true
}

resource "aws_lambda_function" "glue_trigger" {
  description    = "Inicia workflow do glue para processamento de arquivos"
  function_name  = "glue-trigger"
  role           = aws_iam_role.glue_trigger_role.arn
  package_type   = "Image"
  image_uri      = "${var.ecr_glue_trigger_url}:latest"
  
  environment {
    variables = {
      Environment = var.env
      GLUE_WORKFLOW = var.glue_workflow
    }
  }
}