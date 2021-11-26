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

module "ecr" {
  source = "./ecr"

  region = var.region
}

module "lambda" {
  source = "./lambda"

  sqs_glue_raw_file_arn = "arn:aws:sqs:*:*:s3-raw-file-event-notification"
  ecr_glue_trigger_url  = module.ecr.ecr_glue_trigger_url
  env                   = var.env
  region                = var.region

  depends_on = [
    module.ecr
  ]
}
