resource "aws_api_gateway_rest_api" "produtos_api" {
  name = "Produtos api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Environment = var.env
  }
}

resource "aws_api_gateway_deployment" "produtos_api" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.produtos_api.id,
      aws_api_gateway_method.produtos_api.id,
      aws_api_gateway_integration.produtos_api.id
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

resource "aws_api_gateway_resource" "produtos_api" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
  parent_id   = aws_api_gateway_rest_api.produtos_api.root_resource_id
  path_part   = "produtos"
}

resource "aws_api_gateway_method" "produtos_api" {
  rest_api_id   = aws_api_gateway_rest_api.produtos_api.id
  resource_id   = aws_api_gateway_resource.produtos_api.id
  http_method   = "GET"
  authorization = "NONE"
  # request_parameters = {
  #   "method.request.path.username" = true
  # }
}


resource "aws_api_gateway_integration" "produtos_api" {
  http_method             = aws_api_gateway_method.produtos_api.http_method
  integration_http_method = "GET"
  resource_id             = aws_api_gateway_resource.produtos_api.id
  rest_api_id             = aws_api_gateway_rest_api.produtos_api.id
  type                    = "HTTP_PROXY"
  timeout_milliseconds    = 29000
  uri                     = "http://${var.lb_dns_name}"

  depends_on = [
    aws_api_gateway_method.produtos_api
  ]
}


resource "aws_api_gateway_method_settings" "produtos_api" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
  stage_name  = aws_api_gateway_stage.produtos_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    # caching_enabled = false
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_account" "produtos_api" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_produtos_api_role.arn
}
