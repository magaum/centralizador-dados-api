resource "aws_iam_role" "api_role" {
  name = "api_role"

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

resource "aws_iam_role_policy_attachment" "api_role_role_attachment" {
  policy_arn = aws_iam_policy.api_role.arn
  role       = aws_iam_role.api_role.name
}

resource "aws_iam_policy" "api_role" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudWatchLogs",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*:*",
      "Effect": "Allow"
    },
    {
      "Sid":"AllowSSMParameter",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/categoria",
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/cnpj",
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/codigo"
      ],
      "Effect": "Allow"
    },
    {
      "Sid": "AllowDynamoReadOnly",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:BatchGetItem",
        "dynamodb:Query"
      ],
      "Resource": [
        "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamo.table}",
        "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamo.table}/index/*"
      ],
      "Effect": "Allow"
    }
  ]
}
  EOF
}
