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

module "network" {
  source = "./network"

  env = var.env
}

module "database" {
  source = "./database"

  vpc_cidr = module.network.vpc_cidr
  vpc_id   = module.network.vpc_id
  region   = var.region
  env      = var.env
}

module "storage" {
  source = "./storage"

  env                 = var.env
  raw_queue_arn       = module.queue.glue_raw_file_arn
  processed_queue_arn = module.queue.glue_processed_file_arn
}

module "queue" {
  source = "./queue"

  env        = var.env
  bucket_arn = module.storage.arn
}

module "etl" {
  source = "./etl"

  bucket_arn  = module.storage.arn
  bucket_name = module.storage.bucket_name
}
