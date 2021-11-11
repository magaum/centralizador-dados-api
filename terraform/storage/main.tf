resource "aws_s3_bucket" "produtos" {
  bucket = "projeto-aplicado-produtos-glue"
  acl    = "private"

  tags = {
    Name        = "projeto-aplicado-produtos-glue"
    Environment = var.env
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.produtos.id

  queue {
    queue_arn     = var.queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "raw/"
  }
}
