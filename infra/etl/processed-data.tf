resource "aws_glue_crawler" "processed_s3" {
  database_name = aws_glue_catalog_database.produtos.name
  name          = "processed-s3-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "${var.bucket_name}/processed"
  }
}
