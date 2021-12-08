terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64"
    }
  }
}

provider "aws" {
  region = var.region
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_dir  = "${path.module}/../"
  excludes    = ["infra"]
}

resource "aws_lambda_function" "query_id" {
  description      = "Busca produto por id"
  function_name    = "query-id"
  role             = var.role_arn
  layers           = [var.layer_arn]
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      Environment  = var.env
      DYNAMO_TABLE = var.dynamo.table
    }
  }

  depends_on = [
    data.archive_file.lambda
  ]
}
