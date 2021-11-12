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

module "network" {
  source = "./network"

  env = var.env
}

module "lb" {
  source = "./load-balancer"

  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
  env            = var.env
}

module "api" {
  source = "./api"

  lb_target_group_arn = module.lb.lb_target_group_arn
  azs                 = module.network.azs
  public_subnets      = module.network.public_subnets
  env                 = var.env
  vpc_id              = module.network.vpc_id
  region              = var.region

  depends_on = [module.lb]
}

module "api_gateway" {
  source = "./api-gateway"

  lb_dns_name = module.lb.dns_name
  env         = var.env
}

module "storage" {
  source = "./storage"

  env       = var.env
  queue_arn = module.queue.new_file_queue_arn
}

module "queue" {
  source = "./queue"

  env        = var.env
  bucket_arn = module.storage.arn
}

module "container_hub" {
  source = "./ecr"

  region = var.region
}

module "worker" {
  source = "./worker"

  sqs_arn = module.queue.queue_produtos_arn
  s3_arn  = module.storage.arn
  bucket_id  = module.storage.id
  ecr_s3_url = module.container_hub.s3_url
  ecr_sqs_url = module.container_hub.sqs_url
  region = var.region
  env = var.env

  depends_on = [
    module.container_hub,
    module.queue,
    module.storage
  ]
}

module "database" {
  source = "./database"

  vpc_cidr            = module.network.vpc_cidr
  vpc_id              = module.network.vpc_id
  region              = var.region
  env                 = var.env
  private_subnets_ids = module.network.private_subnets_ids
}

module "etl" {
  source = "./etl"

  bucket_arn  = module.storage.arn
  bucket_name = module.storage.bucket_name
  queue_arn   = module.queue.new_file_queue_arn
}
