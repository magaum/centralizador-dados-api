variable "desired_ecs_instances" {
  default = 2
}

variable "lb_target_group_arn" {}

variable "vpc_id" {}

variable "public_subnets" {}

variable "region" {}

variable "azs" {}

variable "env" {}