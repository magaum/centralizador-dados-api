resource "aws_sqs_queue" "produtos_api" {
  name                        = "produtos-api.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Service     = "Produtos api"
    Environment = var.env
  }
}

resource "aws_sqs_queue" "new_file_raw_queue" {
  name = "s3-raw-file-event-notification"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
       "Resource": "arn:aws:sqs:*:*:s3-raw-file-event-notification",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${var.bucket_arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "new_file_processed_queue" {
  name = "s3-processed-file-event-notification"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3-processed-file-event-notification",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${var.bucket_arn}" }
      }
    }
  ]
}
POLICY
}