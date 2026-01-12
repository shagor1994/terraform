variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}
variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

resource "aws_iam_role" "ec2_sqs_role" {
  name = "ec2-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "ec2_sqs_policy" {
  name = "ec2-sqs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = "arn:aws:sqs:${var.aws_region}:${var.account_id}:test-queue"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2-instance-connect:SendSSHPublicKey"
        ]
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "ec2-sqs-policy"
  }
}
resource "aws_iam_role_policy_attachment" "attach_ec2_sqs_policy" {
  role       = aws_iam_role.ec2_sqs_role.name
  policy_arn = aws_iam_policy.ec2_sqs_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-sqs-profile"
  role = aws_iam_role.ec2_sqs_role.name
}

#create the queue
resource "aws_sqs_queue" "test_queue" {
  name                       = "test-queue"
  visibility_timeout_seconds = 30
  delay_seconds              = 0
  message_retention_seconds  = 86400
  tags = {
    Name = "test-queue"
  }
}

