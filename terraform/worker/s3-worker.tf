module "s3_worker" {
  source = "terraform-aws-modules/lambda/aws"

  function_name                 = "s3-worker"
  description                   = "Salva dados recebidos do Glue no opensearch"
  attach_cloudwatch_logs_policy = true
  create_package                = false
  package_type                  = "Image"

  image_uri = "132367819851.dkr.ecr.eu-west-1.amazonaws.com/complete-cow:1.0"

  allowed_triggers = {
    S3Object = {
      service    = "s3"
      source_arn = var.s3_arn
    }
  }
}
