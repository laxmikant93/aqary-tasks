# resource "aws_instance" "worker" {
#   ami                    = var.ami_id
#   instance_type         = var.instance_type
#   subnet_id             = var.subnet_id
#   vpc_security_group_ids = var.security_group_ids

#   iam_instance_profile = var.instance_profile

#   user_data = file("${path.module}/worker.sh")

#   tags = {
#     Name = "sqs-worker"
#   }
# }