resource "aws_eip" "vpn-server_ip" {
  instance = aws_instance.vpn-server.id
  vpc      = true
  tags     = {Name = "sec-lab_vpn-server_ip"}
}


resource "aws_eip" "http-server_ip" {
  instance = aws_instance.http-server.id
  vpc      = true
  tags     = {Name = "sec-lab_http-server_ip"}
}

