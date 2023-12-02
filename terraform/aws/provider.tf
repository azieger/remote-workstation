terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.23.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.20.0"
    }
  }
  backend "s3" {
    bucket = "workstation-terraform"
    key    = "remote-workstation"
    region = "ca-central-1"
  }
}

provider "aws" {
  region = "ca-central-1"
}

provider "cloudflare" {
  api_token = var.workstation_cloudflare_token
}
