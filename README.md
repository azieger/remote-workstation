# remote-workstation

## Pre-requisits
- Packer
- Terraform
- Ansible

## Create snapshot
    cd packer
    packer build remote-workstation.json

## Start your workstation
    cd terraform
    terraform plan -out plan.out
    terraform apply plan.out
