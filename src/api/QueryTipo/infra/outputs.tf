output "output" {
  value = {
    invoke_arn = aws_lambda_function.query_tipo.invoke_arn
    name = aws_lambda_function.query_tipo.function_name
  }
}