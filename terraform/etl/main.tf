resource "aws_glue_classifier" "produto_mainframe" {
  name = "produto-mainframe"

  grok_classifier {
    classification  = "produto_mainframe"
    grok_pattern    = "fields"
    custom_patterns = "fields (?<fields>[^.].*)"
  }
}

resource "aws_glue_catalog_database" "produtos" {
  name        = "produtos"
  description = "Informações catalogadas de produtos"
}

resource "aws_glue_crawler" "s3" {
  database_name = aws_glue_catalog_database.produtos.name
  name          = "s3-crawler"
  role          = aws_iam_role.glue_role.arn
  classifiers   = [aws_glue_classifier.produto_mainframe.id]

  s3_target {
    path = "${var.bucket_name}/processed"
    event_queue_arn = var.queue_arn
  }
}

resource "aws_glue_job" "extract_mainframe_data" {
  name     = "extract-mainframe-data"
  role_arn = aws_iam_role.glue_role.arn

  default_arguments = {
    "--job-language" = "python"
  }
  
  command {
    script_location = "s3://${var.bucket_name}/mainframe-data-job.py"
  }
}

# resource "aws_glue_trigger" "produtos" {
#   name = "produtos_trigger"
#   type = "ON_DEMAND"

#   actions {
#     job_name = aws_glue_job.extract_mainframe_data.name
#   }
# }
