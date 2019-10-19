resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = {
    Name = "${var.project_name} SSH"
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.my_ip, data.terraform_remote_state.infra.outputs.vpc_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_wazuh" {
  name        = "allow_wazuh"
  description = "Allow wazuh inbound traffic"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = {
    Name = "${var.project_name} Wazuh"
  }


  ingress {
    from_port   = 1514
    to_port     = 1514
    protocol    = "udp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }
  ingress {
    from_port   = 1515
    to_port     = 1515
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }
  ingress {
    from_port   = 55000
    to_port     = 55000
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = { 
    Name = "${var.project_name} HTTP_HTTPS"   
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_elastic" {
  name        = "allow_elastic"
  description = "Allow elastic inbound traffic"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = { 
    Name = "${var.project_name} Elastic"   
  }


  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.vpn-server_ip.public_ip}/32"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "allow_dns" {
  name        = "allow_dns"
  description = "Allow dns and vpn inbound traffic"
  vpc_id      = data.terraform_remote_state.infra.outputs.vpc_id

  tags = { 
    Name = "${var.project_name} DNS"   
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [data.terraform_remote_state.infra.outputs.vpc_cidr]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}
