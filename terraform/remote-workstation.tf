variable "workstation_do_token" {}
variable "workstation_domain_name" {}
variable "workstation_domain_prefix" {}

data "digitalocean_ssh_keys" "keys" {
  sort {
    key       = "name"
    direction = "asc"
  }
}

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
  ssh_keys           = data.digitalocean_ssh_keys.keys.ssh_keys.*.fingerprint
}

# Firewall that only allows to ssh (port 22) and connect to port 8443 (visual studio code in web browser)
resource "digitalocean_firewall" "workstation-firewall" {
  name        = "only-ssh"
  droplet_ids = [digitalocean_droplet.remote_workstation.id]
  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
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

