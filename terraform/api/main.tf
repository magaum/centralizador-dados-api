resource "aws_kms_key" "produtos_api_kms" {
  description             = "ECS KMS Key"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "produtos_api_log_group" {
  name = "ecs/produtos-api"
}
