resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sqs_worker.arn
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_arn
}

resource "aws_lambda_function" "sqs_worker" {
  description    = "Gerencia nova mensagem recebida do sistema produto"
  function_name  = "sqs-worker"
  role           = aws_iam_role.sqs_worker_role.arn
  package_type   = "Image"
  image_uri      = "${var.ecr_sqs_url}:latest"
  
  environment {
    variables = {
      Environment = var.env
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_worker" {
  event_source_arn = var.sqs_arn
  function_name    = aws_lambda_function.sqs_worker.arn
  batch_size       = 1
  enabled          = true
}
