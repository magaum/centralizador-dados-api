resource "aws_s3_bucket" "produtos" {
  bucket = "projeto-aplicado-produtos-glue"
  acl    = "private"

  tags = {
    Name        = "projeto-aplicado-produtos-glue"
    Environment = var.env
  }
}

resource "aws_s3_bucket_notification" "new_files_notifications" {
  bucket = aws_s3_bucket.produtos.id

  queue {
    queue_arn     = var.processed_queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "processed/"
  }

  queue {
    queue_arn     = var.raw_queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "raw/"
  }

  depends_on = [
    aws_s3_bucket_object.processed_directory,
    aws_s3_bucket_object.raw_directory
  ]
}

resource "aws_s3_bucket_object" "raw_directory" {
  bucket = aws_s3_bucket.produtos.id
  acl    = "private"
  key    = "raw/"
}

resource "aws_s3_bucket_object" "processed_directory" {
  bucket = aws_s3_bucket.produtos.id
  acl    = "private"
  key    = "processed/"
}

data "local_file" "script" {
  filename = "${path.root}/etl/mainframe-data-job.py"
}

data "local_file" "schema" {
  filename = "${path.root}/etl/schema_mainframe.csv"
}

resource "aws_s3_bucket_object" "mainframe_data_job" {
  bucket = aws_s3_bucket.produtos.id
  key    = "mainframe-data-job.py"
  source = data.local_file.script.filename
  acl    = "private"
  etag   = filemd5(data.local_file.script.filename)
}


resource "aws_s3_bucket_object" "mainframe_schema" {
  bucket = aws_s3_bucket.produtos.id
  key    = "schema_mainframe.csv"
  source = data.local_file.schema.filename
  acl    = "private"
  etag   = filemd5(data.local_file.schema.filename)
}
