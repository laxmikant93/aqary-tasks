# aqary-tasks

main.tf

1 . it includes all the detailed resources.
2 . the file starts with configuration of versioning and provider blocks.
3 . here we are trying to use ministack endpoint to add aws infra to local build
4 . First we added VPC , then included group of public and private subnets, security groups and then added VMS for nginx docker deployment
5 . we need to create vm, alb url , s3 storage and postgres rds for provisioning.
6 . creation AWS SQS
