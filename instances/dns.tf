resource "aws_route53_zone" "dev" {
  name = var.internal_domain

  vpc {
    vpc_id = data.terraform_remote_state.infra.outputs.vpc_id 
  }
}


resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "web01.${var.internal_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.http-server.private_ip]
}


resource "aws_route53_record" "wazuh" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "wazuh01.${var.internal_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.wazuh-server.private_ip]
}


resource "aws_route53_record" "elastic" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "elastic01.${var.internal_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.elastic-server.private_ip]
}


resource "aws_route53_record" "vpn" {
  zone_id = aws_route53_zone.dev.zone_id
  name    = "vpn01.${var.internal_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vpn-server.private_ip]
}


