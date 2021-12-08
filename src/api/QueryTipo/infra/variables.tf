variable "region" {
  description = "AWS Region"
  type        = string
}

variable "env" {
  description = "Lambda environment"
  type        = string
}

variable "dynamo" {
  description = "Dynamo table"
  type        = map(string)
}

variable "account_id" {
  description = "AWS Account id"
  type        = string
}

variable "role_arn" {
  description = "Lambda Role"
  type        = string
}

variable "layer_arn" {
  description = "API Gateway Layer response ARN"
  type = string
}