terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description = "git repo secrets encryption with sops"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
  key_users          = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
  # Aliases
  aliases = ["${data.aws_caller_identity.current.id}/sops"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
