terraform {
    required_version = ">=1.0.0"
    required_providers {
    aws = {
            source   = "hashicorp/aws"
            version  = "3.73.0"
        }
    }
    backend "s3" {
    bucket = "pvs-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
    }
}
provider "aws" {
    region  = var.aws_region
    profile = var.aws_profile
}