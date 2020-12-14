variable "workstation_do_token" {}
variable "workstation_ssh_key" {}
variable "workstation_domain_name" {}
variable "workstation_domain_prefix" {}

# get the latest image, there should only be one with this prefix
data "digitalocean_images" "workstation_images" {
  filter {
    key      = "name"
    match_by = "substring"
    values   = ["remote-workstation"]
  }
  sort {
    key       = "created"
    direction = "desc"
  }
}

# Create droplet from image
resource "digitalocean_droplet" "remote_workstation" {
  image              = data.digitalocean_images.workstation_images.images[0].id
  name               = "workstation"
  region             = "nyc1"
  size               = "s-1vcpu-2gb"
  monitoring         = true
  private_networking = true
  ssh_keys           = [var.workstation_ssh_key]
}

# Update DNS record to avoid using ip 
resource "digitalocean_record" "workstation_prefix" {
  domain = var.workstation_domain_name
  type   = "A"
  name   = var.workstation_domain_prefix
  value  = digitalocean_droplet.remote_workstation.ipv4_address
  ttl    = 30
}

output "server_ip" {
  value = digitalocean_droplet.remote_workstation.ipv4_address
}
