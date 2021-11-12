resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_worker.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_worker.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "processed/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_lambda_function" "s3_worker" {
  description    = "Gerencia novo arquivo recebido do Glue no diretorio processed"
  function_name  = "s3-worker"
  role           = aws_iam_role.s3_worker_role.arn
  package_type   = "Image"
  image_uri      = "${var.ecr_s3_url}:latest"
  
  environment {
    variables = {
      Environment = var.env
    }
  }
}