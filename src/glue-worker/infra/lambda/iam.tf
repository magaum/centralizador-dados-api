data "aws_caller_identity" "current" {}

resource "aws_iam_role" "glue_worker_role" {
  name = "glue_worker_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_worker_role_role_attachment" {
  policy_arn = aws_iam_policy.glue_worker_role.arn
  role = aws_iam_role.glue_worker_role.name
}

resource "aws_iam_policy" "glue_worker_role" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListBucket",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Sid": "CloudWatchLogs",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.glue_worker.function_name}:*",
      "Effect": "Allow"
    },
    {
      "Sid": "AllowFetchSQS",
      "Action": [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "${var.sqs_glue_processed_file_arn}"
    },
    {
      "Sid": "AllowDynamoListAndWrite",
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:BatchWriteItem"
      ],
      "Resource": "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamo_table}",
      "Effect": "Allow"
    }
  ]
}
  EOF
}
