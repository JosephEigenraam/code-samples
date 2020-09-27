#!/usr/bin/env bash
set -euo pipefail

# check if stack prefix was provided
if [ $# == 0 ] | [ -z "$0" ]; then
  echo "Invalid stack prefix"
  exit 1
fi

# general stack properties
REGION="us-east-1"
TAGS="Project=DeployGhostOnAWS"

# stack scale properties
DESIRED_COUNT=1
CONTAINER_CPU=256
CONTAINER_MEMORY=512

# Paste image URL arn below
IMAGE_URL="<IMAGE URL ARN>" 

# retrieve prefix from command line parameters
PREFIX="$1"

# apply ecr cloudformation stack
ECR_STACK_NAME="${PREFIX}-ecr"
aws cloudformation deploy \
  --region=$REGION \
  --stack-name="$ECR_STACK_NAME" \
  --template-file=./infrastructure/ecr.yaml \
  --tags=$TAGS \
  --no-fail-on-empty-changeset
  
VPC_STACK_NAME="${PREFIX}-vpc"
# apply vpc cloudformation stack
aws cloudformation deploy \
  --region=$REGION \
  --stack-name="$VPC_STACK_NAME" \
  --template-file=./infrastructure/vpc.yaml \
  --capabilities=CAPABILITY_IAM \
  --no-fail-on-empty-changeset

# apply the web service
WEB_STACK_NAME="${PREFIX}-web"
aws cloudformation deploy \
  --stack-name="$WEB_STACK_NAME" \
  --template-file=./infrastructure/service.yaml \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
  StackName="$VPC_STACK_NAME" \
  ServiceName=web \
  ImageUrl="$IMAGE_URL" \
  DesiredCount=$DESIRED_COUNT \
  ContainerCpu=$CONTAINER_CPU \
  ContainerMemory=$CONTAINER_MEMORY \
  ContainerPort=2368