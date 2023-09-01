terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = var.profile
  default_tags {
    tags = {
      Project = "Lara-test"
    }
  }
}
