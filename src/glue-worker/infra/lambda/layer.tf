resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "${path.module}/awswrangler-layer-2.12.1-py3.8.zip"
  layer_name = "awswrangler"

  compatible_runtimes = ["python3.8"]
}
