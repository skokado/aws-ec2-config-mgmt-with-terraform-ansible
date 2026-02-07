terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Terraform  = "true"
      Repository = "https://github.com/skokado/aws-ec2-config-mgmt-with-terraform-ansible"
    }
  }
}
