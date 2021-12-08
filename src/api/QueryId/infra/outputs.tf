output "output" {
  value = {
    invoke_arn = aws_lambda_function.query_id.invoke_arn
    name = aws_lambda_function.query_id.function_name
  }
}