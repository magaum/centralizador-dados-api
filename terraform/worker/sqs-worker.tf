module "sqs_worker" {
  source = "terraform-aws-modules/lambda/aws"

  function_name                 = "sqs-worker"
  description                   = "Salva dados recebidos do SQS no opensearch"
  attach_cloudwatch_logs_policy = true
  create_package                = false
  package_type                  = "Image"

  image_uri = "132367819851.dkr.ecr.eu-west-1.amazonaws.com/complete-cow:1.0"

  allowed_triggers = {
    SQSMessage = {
      service    = "sqs"
      source_arn = var.sqs_arn
    }
  }
}
