terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.region
}


data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket 
    key    = var.remote_state_key 
    region = var.remote_state_region 
  }
}

resource "aws_instance" "wazuh-server" {
  ami                         = var.ami 
  instance_type               = "t2.medium"
  key_name                    = var.desired_key
  subnet_id                   = data.terraform_remote_state.infra.outputs.mgmt_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id,aws_security_group.allow_wazuh.id]
  user_data                   = data.template_cloudinit_config.wazuh-init.rendered
  tags                        = {Name = "${var.project_name} wazuh-server"}
}

resource "aws_instance" "http-server" {
  ami                         = var.ami
  instance_type                = "t2.small"
  associate_public_ip_address = true
  key_name                    = var.desired_key
  subnet_id                   = data.terraform_remote_state.infra.outputs.web_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id,aws_security_group.allow_http.id]
  user_data                   = data.template_cloudinit_config.wordpress-init.rendered
  tags                        = {Name = "${var.project_name} http-server"}
}

resource "aws_instance" "elastic-server" {
  ami                         = var.ami 
  instance_type                = "t2.medium"
  key_name                    = var.desired_key
  subnet_id                   = data.terraform_remote_state.infra.outputs.mgmt_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id,aws_security_group.allow_elastic.id]
  user_data                   = data.template_cloudinit_config.elk-init.rendered
 tags                        = {Name = "${var.project_name} elk-server"}
}

resource "aws_instance" "vpn-server" {
  ami                         = var.ami 
  instance_type                = "t2.small"
  associate_public_ip_address = true
  key_name                    = var.desired_key
  subnet_id                   = data.terraform_remote_state.infra.outputs.vpn_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id,aws_security_group.allow_dns.id]
  user_data                   = data.template_cloudinit_config.vpn-init.rendered
  tags                        = {Name = "${var.project_name} vpn-server"}
}


