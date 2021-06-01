# In case I want to store terraform state in DO spaces
# terraform {
#   required_version = "= 0.14.2"
#   backend "s3" {
#     endpoint = "nyc3.digitaloceanspaces.com"
#     region = "us-west-1"
#     skip_credentials_validation = true
#     skip_metadata_api_check = true
#     key = "terraform-backend.tfstate"
#     bucket = "workstation"
#   }
# }

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

provider "digitalocean" {
  token = var.workstation_do_token
}

