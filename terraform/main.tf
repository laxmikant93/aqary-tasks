terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region                      = "us-east-1"
  access_key                  = "111111111111"
  secret_key                  = "AKIAIOSFODNN7EXAMPLE"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true
  
  endpoints {
    acm             = "http://localhost:4566"
    apigateway      = "http://localhost:4566"
    appsync         = "http://localhost:4566"
    athena          = "http://localhost:4566"
    cloudformation  = "http://localhost:4566"
    cloudfront      = "http://localhost:4566"
    cloudwatch      = "http://localhost:4566"
    codebuild       = "http://localhost:4566"
    cognitoidentity = "http://localhost:4566"
    cognitoidp      = "http://localhost:4566"
    dynamodb        = "http://localhost:4566"
    ec2             = "http://localhost:4566"
    ecr             = "http://localhost:4566"
    ecs             = "http://localhost:4566"
    efs             = "http://localhost:4566"
    elasticache     = "http://localhost:4566"
    elbv2           = "http://localhost:4566"
    emr             = "http://localhost:4566"
    events          = "http://localhost:4566"
    firehose        = "http://localhost:4566"
    glue            = "http://localhost:4566"
    iam             = "http://localhost:4566"
    kinesis         = "http://localhost:4566"
    kms             = "http://localhost:4566"
    lambda          = "http://localhost:4566"
    logs            = "http://localhost:4566"
    rds             = "http://localhost:4566"
    route53         = "http://localhost:4566"
    s3              = "http://localhost:4566"
    s3control       = "http://localhost:4566"
    secretsmanager  = "http://localhost:4566"
    ses             = "http://localhost:4566"
    sesv2           = "http://localhost:4566"
    sns             = "http://localhost:4566"
    sqs             = "http://localhost:4566"
    ssm             = "http://localhost:4566"
    stepfunctions   = "http://localhost:4566"
    sts             = "http://localhost:4566"
    wafv2           = "http://localhost:4566"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "my-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_subnet" "public" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "web-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_instance" "web" {
  ami                    = "ami-0c94855ba95c71c99"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y amazon-linux-extras
amazon-linux-extras enable docker
yum install -y docker
service docker start
docker run -d --name nginx -p 80:80 nginx
curl -I http://localhost:80
EOF

  tags = {
    Name = "web-server"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/health"
    port = "traffic-port"
  }
}

resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id
  enable_deletion_protection = false

  tags = {
    Name = "web-alb"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "aqary-tasks-terraform-bucket"

  tags = {
    Name        = "app-bucket"
    Environment = "dev"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "PostgreSQL from web servers"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "postgres-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "postgres"
  password               = "Password123@"
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "postgres-db"
  }
}

resource "aws_sqs_queue" "app_queue" {
  name                       = "app-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144

  tags = {
    Name = "app-queue"
  }
}
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "processor" {
  function_name = "simple-processor"
  handler       = "index.handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_role.arn

  filename = "python.zip"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
}

resource "aws_s3_bucket_notification" "notify" {
  bucket = aws_s3_bucket.app_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

