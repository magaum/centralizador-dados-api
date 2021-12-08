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

data "aws_caller_identity" "current" {}

module "response_layer" {
  source = "./ResponseLayer/Infra"
}

module "api_gateway" {
  source = "./infra/api-gateway"

  lambda_categoria_cnpj_codigo = module.lambda_lambda_categoria_cnpj_codigo.output
  lambda_id                    = module.lambda_id.output
  lambda_tipo                  = module.lambda_tipo.output
  account_id                   = data.aws_caller_identity.current.account_id
  region                       = var.region
  env                          = var.env
}

module "lambda_lambda_categoria_cnpj_codigo" {
  source = "./QueryCategoria/infra"

  layer_arn = module.response_layer.arn
  role_arn  = aws_iam_role.api_role.arn
  env       = var.env
  region    = var.region
  dynamo = {
    table = var.dynamo.table
  }
  account_id = data.aws_caller_identity.current.account_id
}

module "lambda_id" {
  source = "./QueryId/infra"

  layer_arn = module.response_layer.arn
  role_arn  = aws_iam_role.api_role.arn
  env       = var.env
  region    = var.region
  dynamo = {
    table = var.dynamo.table
  }
  account_id = data.aws_caller_identity.current.account_id
}

module "lambda_tipo" {
  source = "./QueryTipo/infra"

  layer_arn = module.response_layer.arn
  role_arn  = aws_iam_role.api_role.arn
  env       = var.env
  region    = var.region
  dynamo = {
    table = var.dynamo.table
    index = var.dynamo.tipo_index
  }
  account_id = data.aws_caller_identity.current.account_id
}
