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

resource "aws_s3_bucket_object" "raw_directory" {
  bucket = aws_s3_bucket.produtos.id
  acl    = "private"
  key    = "raw/"
  # source = "/dev/null"
}

resource "aws_s3_bucket_object" "processed_directory" {
  bucket = aws_s3_bucket.produtos.id
  acl    = "private"
  key    = "processed/"
  # source = "/dev/null"
}

data "local_file" "script" {
  filename = "${path.root}/etl/mainframe-data-job.py"
}

resource "aws_s3_bucket_object" "mainframe_data_job" {
  bucket = aws_s3_bucket.produtos.id
  key    = "mainframe-data-job.py"
  source = data.local_file.script.filename
  acl    = "private"
  etag   = filemd5(data.local_file.script.filename)
}
