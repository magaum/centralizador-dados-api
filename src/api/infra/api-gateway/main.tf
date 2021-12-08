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

resource "aws_api_gateway_rest_api" "produtos_api" {
  name = "Produtos api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_api_gateway_resource" "produtos_resource_base" {
  path_part   = "produtos"
  parent_id   = aws_api_gateway_rest_api.produtos_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
}

resource "aws_api_gateway_deployment" "produtos_api" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource_categoria.id,
      aws_api_gateway_method.method_categoria.id,
      aws_api_gateway_integration.integration_categoria.id,
      aws_api_gateway_resource.resource_cnpj.id,
      aws_api_gateway_method.method_cnpj.id,
      aws_api_gateway_integration.integration_cnpj.id,
      aws_api_gateway_resource.resource_codigo.id,
      aws_api_gateway_method.method_codigo.id,
      aws_api_gateway_integration.integration_codigo.id,
      aws_api_gateway_resource.resource_id.id,
      aws_api_gateway_method.method_id.id,
      aws_api_gateway_integration.integration_id.id,
      aws_api_gateway_resource.resource_tipo.id,
      aws_api_gateway_method.method_tipo.id,
      aws_api_gateway_integration.integration_tipo.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "produtos_api" {
  deployment_id = aws_api_gateway_deployment.produtos_api.id
  rest_api_id   = aws_api_gateway_rest_api.produtos_api.id
  stage_name    = var.env
}
