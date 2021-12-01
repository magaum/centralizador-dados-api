terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "lambda" {
  source = "./lambda"

  sqs_glue_processed_file_arn = "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:s3-processed-file-event-notification"
  env                         = var.env
  region                      = var.region
  dynamo_table                = "catalogo-produtos"
}
