#!/bin/bash

# Variables - CHANGE THESE to be unique
BUCKET_NAME="my-terraform-state-bucket-unique-12345-23122025"
TABLE_NAME="terraform-state-lock"
REGION="ap-south-1"

echo "Creating S3 Bucket for State..."
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION

echo "Enabling Versioning on Bucket..."
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

echo "Creating DynamoDB Table for Locking..."
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region $REGION

echo "Backend Infrastructure Created!"
echo "Bucket: $BUCKET_NAME"
echo "Table: $TABLE_NAME"
