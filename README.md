# remote-workstation

## Pre-requisits

You need a cloud account, here I document everything for aws but if you have another cloud provider that provides a terraform provider, you can either contrubute to this project or fork it and adapt it.

I suggest a cloudflare account to manage your DNS records and for SSL certificates but on that front again, feel free to use others. In order to interact with cloudflare via terraform you wil need an API token. https://developers.cloudflare.com/fundamentals/api/get-started/create-token/

Install the following tools:
- AWS cli
- Packer >= 1.9.4
- Terraform >= 1.5.5
- Ansible >= 2.13.7

If you are not familiar with packer and terraform I suggest you the tutorials by Hashicorp.
https://developer.hashicorp.com/packer/tutorials/aws-get-started
https://developer.hashicorp.com/terraform/tutorials/aws-get-started


## Set the necessary variables

For AWS you need to configure the aws cli. For cloudflare you need an API key. Check the documentation on how to authenticate with the provider you are using. There are pleny available.

For terraform all the variables are listed in variable.tf file. For packer you only need the aws cli configured and a username of your choice.

## Create snapshot

Use packer to create a server image containing all your tools. The username below will be your user on the linx server.

    cd packer
    packer build -var "username=<username>" remote-workstation.pkr.hcl

## Start your workstation

    cd terraform
    terraform plan -out plan.out
    terraform apply plan.out

## Start vsode server

Ssh to the server you just created and execute:

    ~/start-vscode.sh

The script `~/start-vscode.sh` contains the password to enter your vscode session.


# Warning and futur work

1. Current setup does not contain any SSL certificate so traffic to vscode in the browser is not encrypted.
Improvement available soon.

2. Github workflow will be added to automate deployment and allow start/stop the server for cost optimization

