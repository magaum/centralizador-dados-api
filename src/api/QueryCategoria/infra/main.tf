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
  excludes    = ["infra", "test"]
}

resource "aws_lambda_function" "query_lambda_categoria_cnpj_codigo" {
  description      = "Busca produto por categoria cnpj ou codigo"
  function_name    = "query-categoria-cnpj-codigo"
  role             = var.role_arn
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  layers           = [var.layer_arn]
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      Environment  = var.env
      DYNAMO_TABLE = var.dynamo.table
      REGION       = var.region
      ITEM_LIMIT   = 150
    }
  }

  depends_on = [
    data.archive_file.lambda
  ]
}
