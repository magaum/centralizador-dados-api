resource "aws_lambda_permission" "allow_glue_worker" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.glue_worker.arn
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_glue_processed_file_arn
}

resource "aws_lambda_event_source_mapping" "glue_worker" {
  event_source_arn = var.sqs_glue_processed_file_arn
  function_name    = aws_lambda_function.glue_worker.arn
  batch_size       = 1
  enabled          = true
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../../app.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "glue_worker" {
  description      = "Gerencia novo arquivo recebido do Glue no diretorio processed"
  function_name    = "glue-worker"
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
  role             = aws_iam_role.glue_worker_role.arn
  runtime          = "python3.8"
  handler          = "app.handler"
  timeout          = 15
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      Environment  = var.env
      DYNAMO_TABLE = var.dynamo_table
    }
  }

  depends_on = [
    data.archive_file.lambda
  ]
}
