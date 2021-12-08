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

module "ecr" {
  source = "./ecr"

  region     = var.region
  account_id = data.aws_caller_identity.current.account_id
}

module "lambda" {
  source = "./lambda"

  sqs_glue_raw_file_arn = "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:s3-raw-file-event-notification"
  ecr_glue_trigger_url  = module.ecr.ecr_glue_trigger_url
  env                   = var.env
  region                = var.region
  account_id            = data.aws_caller_identity.current.account_id

  depends_on = [
    module.ecr
  ]
}
