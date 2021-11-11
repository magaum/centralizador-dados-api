
resource "aws_ecs_cluster" "produtos_api_cluster" {
  name = "produtos-api-cluster"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.produtos_api_kms.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.produtos_api_log_group.name
      }
    }
  }
}
