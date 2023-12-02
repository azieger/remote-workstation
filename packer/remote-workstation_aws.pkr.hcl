variable "username" {
  type = string
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "remote_workstation_image" {
  ami_name      = "remote-workstation-${local.timestamp}"
  instance_type = "t2.small"
  region        = "ca-central-1"
  source_ami    = "ami-06873c81b882339ac" # ubuntu 22.04
  ssh_username  = "ubuntu"
  tags = {
      OS_Version    = "Ubuntu"
      Base_AMI_Name = "{{ .SourceAMIName }}"
      Name          = "remote-workstation-${local.timestamp}"
      Source        = "packer"
  }
}

build {
  sources = ["source.amazon-ebs.remote_workstation_image"]

  provisioner "ansible" {
    use_proxy           = false
    inventory_directory = "../playbooks"
    extra_arguments     = ["--extra-vars", "username=${var.username}"]
    playbook_file       = "../playbooks/main.yml"
    user                = "ubuntu"
  }
}
