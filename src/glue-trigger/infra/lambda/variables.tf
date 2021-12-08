variable "sqs_glue_raw_file_arn" {}

variable "ecr_glue_trigger_url" {}

variable "env" {}

variable "account_id" {}

variable "region" {}

variable "glue_workflow" {
    default = "etl-produtos"
}