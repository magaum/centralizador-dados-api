resource "aws_api_gateway_resource" "resource_codigo" {
  path_part   = "codigo"
  parent_id   = aws_api_gateway_resource.produtos_resource_base.id
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
}

resource "aws_api_gateway_method" "method_codigo" {
  rest_api_id   = aws_api_gateway_rest_api.produtos_api.id
  resource_id   = aws_api_gateway_resource.resource_codigo.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.search"           = true
    "method.request.querystring.lastEvaluatedKey" = false
  }
}

resource "aws_api_gateway_integration" "integration_codigo" {
  rest_api_id             = aws_api_gateway_rest_api.produtos_api.id
  resource_id             = aws_api_gateway_resource.resource_codigo.id
  http_method             = aws_api_gateway_method.method_codigo.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_categoria_cnpj_codigo.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200_codigo" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
  resource_id = aws_api_gateway_resource.resource_codigo.id
  http_method = aws_api_gateway_method.method_codigo.http_method
  status_code = "200"
  response_models = {
    "application/json" = "QueryProduto"
  }

  depends_on = [
    aws_api_gateway_model.query_produto,
    aws_api_gateway_model.produto,
    aws_api_gateway_model.model_400,
    aws_api_gateway_model.model_404
  ]
}

resource "aws_api_gateway_method_response" "response_400_codigo" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
  resource_id = aws_api_gateway_resource.resource_codigo.id
  http_method = aws_api_gateway_method.method_codigo.http_method
  status_code = "400"
  response_models = {
    "application/json" = "400"
  }

  depends_on = [
    aws_api_gateway_model.query_produto,
    aws_api_gateway_model.produto,
    aws_api_gateway_model.model_400,
    aws_api_gateway_model.model_404
  ]
}

resource "aws_api_gateway_method_response" "response_404_codigo" {
  rest_api_id = aws_api_gateway_rest_api.produtos_api.id
  resource_id = aws_api_gateway_resource.resource_codigo.id
  http_method = aws_api_gateway_method.method_codigo.http_method
  status_code = "404"
  response_models = {
    "application/json" = "404"
  }

  depends_on = [
    aws_api_gateway_model.query_produto,
    aws_api_gateway_model.produto,
    aws_api_gateway_model.model_400,
    aws_api_gateway_model.model_404
  ]
}
