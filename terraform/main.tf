output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}


output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "vm_id" {
  description = "The ID of the VM"
  value       = aws_instance.web.id
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
