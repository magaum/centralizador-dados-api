resource "aws_iam_role" "api_gateway_produtos_api_role" {
  name = "api_gateway_produtos_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "cloudwatch_api_gateway"
  role = aws_iam_role.api_gateway_produtos_api_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_permission" "apigw_lambda_cnpj" {
  statement_id  = "AllowExecutionCNPJAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_categoria_cnpj_codigo.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.produtos_api.id}/*/${aws_api_gateway_method.method_cnpj.http_method}${aws_api_gateway_resource.resource_cnpj.path}"
}

resource "aws_lambda_permission" "apigw_lambda_categoria" {
  statement_id  = "AllowExecutionCategoriaAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_categoria_cnpj_codigo.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.produtos_api.id}/*/${aws_api_gateway_method.method_categoria.http_method}${aws_api_gateway_resource.resource_categoria.path}"
}

resource "aws_lambda_permission" "apigw_lambda_codigo" {
  statement_id  = "AllowExecutionCodigoAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_categoria_cnpj_codigo.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.produtos_api.id}/*/${aws_api_gateway_method.method_codigo.http_method}${aws_api_gateway_resource.resource_codigo.path}"
}

resource "aws_lambda_permission" "apigw_lambda_id" {
  statement_id  = "AllowExecutionIdAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_id.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.produtos_api.id}/*/${aws_api_gateway_method.method_id.http_method}${aws_api_gateway_resource.resource_id.path}"
}

resource "aws_lambda_permission" "apigw_lambda_tipo" {
  statement_id  = "AllowExecutionTipoAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_tipo.name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.produtos_api.id}/*/${aws_api_gateway_method.method_tipo.http_method}${aws_api_gateway_resource.resource_tipo.path}"
}
