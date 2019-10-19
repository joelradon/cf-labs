output "wazuh-server_ID" {
  value = aws_instance.wazuh-server.id
}
output "wazuh-server_privateIP" {
  value = aws_instance.wazuh-server.private_ip
}

output "http-server_ID" {
  value = aws_instance.http-server.id
}
output "http-server_privateIP" {
  value = aws_instance.http-server.private_ip
}

output "elastic-server_ID" {
  value = aws_instance.elastic-server.id
}
output "elastic-server_privateIP" {
  value = aws_instance.elastic-server.private_ip
}

output "vpn-server_ip" {
  value = aws_eip.vpn-server_ip.public_ip
}

output "http-public_ip" {
  value = aws_eip.http-server_ip.public_ip
}

