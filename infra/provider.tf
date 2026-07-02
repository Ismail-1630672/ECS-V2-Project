terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "ismail-ecs-v2-bucket"
    key = "terraform.tfstate"
    region = "eu-west-2"
    encrypt = true 
    use_lockfile = true

  }

   
}


provider "aws" {
  region = "eu-west-2"
}