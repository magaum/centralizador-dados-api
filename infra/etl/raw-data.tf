resource "aws_glue_classifier" "produto_mainframe" {
  name = "produto-mainframe"

  grok_classifier {
    classification  = "produto_mainframe"
    grok_pattern    = "%%{fields}"
    custom_patterns = "fields (?<fields>[^.].*)"
  }
}

resource "aws_glue_crawler" "raw_s3" {
  database_name = aws_glue_catalog_database.produtos.name
  name          = "raw-s3-crawler"
  role          = aws_iam_role.glue_role.arn
  classifiers   = [aws_glue_classifier.produto_mainframe.id]

  s3_target {
    path = "${var.bucket_name}/raw"
  }
}
