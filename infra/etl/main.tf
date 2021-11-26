resource "aws_glue_catalog_database" "produtos" {
  name        = "produtos"
  description = "Informações catalogadas de produtos"
}

resource "aws_glue_job" "extract_mainframe_data" {
  name     = "extract-mainframe-data"
  role_arn = aws_iam_role.glue_role.arn

  default_arguments = {
    "--job-language" = "python"
    "--BUCKET_OBJECT_PATH"  = "s3://${var.bucket_name}/schema_mainframe.csv"
  }

  command {
    script_location = "s3://${var.bucket_name}/mainframe-data-job.py"
  }
}

resource "aws_glue_workflow" "etl_produtos" {
  name = "etl-produtos"
}
