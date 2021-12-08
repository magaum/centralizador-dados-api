resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/lambda.zip"
  layer_name = "api-gateway-response"

  compatible_runtimes = ["nodejs14.x"]

  depends_on = [
    data.archive_file.layer
  ]
}

data "archive_file" "layer" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_dir  = "${path.module}/../"
  excludes    = ["Infra", "test"]
}

