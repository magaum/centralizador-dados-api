data "aws_caller_identity" "current" {}

resource "aws_iam_role" "glue_trigger_role" {
  name = "glue_trigger_role"

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

resource "aws_iam_role_policy_attachment" "glue_trigger_role_role_attachment" {
  policy_arn = aws_iam_policy.glue_trigger_role.arn
  role = aws_iam_role.glue_trigger_role.name
}

resource "aws_iam_policy" "glue_trigger_role" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowTriggerFetchSQS",
      "Action": [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "${var.sqs_glue_raw_file_arn}"
    },
    {
      "Sid": "AllowTriggerStartGlueWorkflow",
      "Action": [
        "glue:StartWorkflowRun"
      ],
      "Effect": "Allow",
      "Resource": "arn:*:glue:${var.region}:${data.aws_caller_identity.current.account_id}:workflow/${var.glue_workflow}"
    },
    {
      "Sid": "CloudWatchLogs",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
  EOF
}