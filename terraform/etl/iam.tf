resource "aws_iam_role" "glue_role" {
  name               = "GlueWriteAccessRole"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
     {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
 ]
}
EOF
}

resource "aws_iam_role_policy" "s3_write_policy" {
  name = "s3_write_policy"
  role = aws_iam_role.glue_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "glue:*"
        ],
        "Resource": [
            "*"
        ]
    },
   {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:PutObject"
        ],
        "Resource": [
            "${var.bucket_arn}"
        ]
   }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service_role_attachment" {
    role = aws_iam_role.glue_role.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
