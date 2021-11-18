terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.64"
        }
    }

    required_version = "~> 1.0"

    backend "s3" {
        bucket = "aws-admin-tf-bucket"
        key = "aws-admin-backend.tfstate"
        region = "ap-southeast-2"
        dynamodb_table = "aws-admin-tf-state-lock"
        encrypt = true
    }
}

provider "aws" {
    profile = "default"
    region = "ap-southeast-2"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "aws-admin-tf-bucket"

    lifecycle {
        prevent_destroy = true
    }

    versioning {
      enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
    name = "aws-admin-tf-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}