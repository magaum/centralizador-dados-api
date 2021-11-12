resource "aws_iam_role" "s3_worker_role" {
  name = "s3_worker_role"

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

resource "aws_iam_role" "sqs_worker_role" {
  name = "sqs_worker_role"

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

resource "aws_iam_role_policy_attachment" "sqs_worker" {
  policy_arn = aws_iam_policy.sqs_worker_role.arn
  role = aws_iam_role.sqs_worker_role.name
}

resource "aws_iam_policy" "sqs_worker_role" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowWorkerFetchSQS",
      "Action": [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "${var.sqs_arn}"
    }
  ]
}
  EOF
}