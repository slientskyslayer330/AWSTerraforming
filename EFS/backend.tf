terraform {
  # cloud {
  #   organization = "winmawoo"

  #   workspaces {
  #     name = "hellocloud-aws-testing"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}