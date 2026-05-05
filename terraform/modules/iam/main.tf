# # resource "aws_iam_role" "worker_role" {
#   name = "worker-sqs-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_policy" "sqs_policy" {
#   name = "worker-sqs-policy"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Action = [
#         "sqs:ReceiveMessage",
#         "sqs:DeleteMessage",
#         "sqs:GetQueueAttributes",
#         "sqs:SendMessage"
#       ]
#       Resource = var.queue_arn
#     }]
#   })
# }
# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.worker_role.name
#   policy_arn = aws_iam_policy.sqs_policy.arn
# }

# resource "aws_iam_instance_profile" "profile" {
#   role = aws_iam_role.worker_role.name
# }