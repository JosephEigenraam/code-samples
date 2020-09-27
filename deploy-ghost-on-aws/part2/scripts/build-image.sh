#!/usr/bin/env bash
set -euo pipefail

# Paste the ECS Cluster ARN below
ECS_CLUSTER="<ECS CLUSTER ARN>"

# The name of the service as defined in Cloudformation
SERVICE="ghost-on-aws"

# Pull the commands in this section from the AWS Console
#################

# Log into AWS ECR inside Docker
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR ARN>
# Build the docker image
# docker build -t ghost-on-aws-ecr .
# Tag the image with the repo
# docker tag ghost-on-aws-ecr:latest <ECR ARN>/ghost-on-aws-ecr:latest
# Push tag to AWS ECR
# docker push <ECR ARN>/ghost-on-aws-ecr:latest

####################

# Force ECS to update 
aws ecs update-service --cluster "$ECS_CLUSTER" --service "$SERVICE" --force-new-deployment