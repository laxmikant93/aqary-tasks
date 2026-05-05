variable "ami_id" {}
variable "instance_type" { default = "t3.micro" }
variable "subnet_id" {}
variable "security_group_ids" { type = list(string) }
variable "key_name" {}
variable "name" {}