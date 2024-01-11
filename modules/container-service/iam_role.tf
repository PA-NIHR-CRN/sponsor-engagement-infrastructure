resource "aws_iam_role" "iam-ecs-task-role" {
  name = "${var.account}-iam-${var.env}-ecs-${var.system}-iam-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  tags = {
    Name        = "${var.account}-iam-${var.env}-ecs-${var.system}-iam-role",
    Environment = var.env,
    System      = var.system,
  }
}

resource "aws_iam_role_policy" "task-execution-role-policy" {
  name = "${var.account}-iam-policy-${var.env}-ecs-${var.system}-task-definition"
  role = aws_iam_role.iam-ecs-task-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "lambda:InvokeFunction",
          "sqs:ReceiveMessage",
          "kafka:*",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:GetSendQuota"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

output "role_arn" {
  value = aws_iam_role.iam-ecs-task-role.arn
}