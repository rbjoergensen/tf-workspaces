terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
  backend "s3" {
    region = "eu-central-1"
    bucket = "callofthevoid-terraform-statefiles"
    dynamodb_table = "terraform-statefile-locks"
    key = "terraform-workspace-example/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  alias  = "frankfurt"
  region = "eu-central-1"
}

module "bucket" {
  providers = {
    aws = aws.frankfurt
  }
  source = "git::https://github.com/rbjoergensen/tf-s3-bucket.git?ref=v1"
  bucket_name = local.bucket_name
}

module "bucket_development" {
  # If workspace is development create 1, else create 0
  count = terraform.workspace == "development" ? 1 : 0
  providers = {
    aws = aws.frankfurt
  }
  source = "git::https://github.com/rbjoergensen/tf-s3-bucket.git?ref=v1"
  bucket_name = local.bucket_name
}