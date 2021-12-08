output "output" {
  value = {
    invoke_arn = aws_lambda_function.query_lambda_categoria_cnpj_codigo.invoke_arn
    name = aws_lambda_function.query_lambda_categoria_cnpj_codigo.function_name
  }
}