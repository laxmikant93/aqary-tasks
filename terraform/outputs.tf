output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}


output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "sg_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.web_sg.id
}

output "web_ip" {
  value       = aws_eip.web.public_ip
  description = "Public IP address assigned to the web server elastic IP"
}

output "alb_url" {
  value       = "http://${aws_lb.web.dns_name}"
  description = "URL of the Application Load Balancer."
}