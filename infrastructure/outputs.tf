output "vpc_id" {
  value = aws_vpc.cf_lab.id 

}
output "vpn_subnet_id" {
  value = aws_subnet.vpn-subnet.id
}

output "web_subnet_id" {
  value = aws_subnet.web-subnet.id
}

output "mgmt_subnet_id" {
  value = aws_subnet.mgmt-subnet.id
}


output "vpc_cidr" {
  value = aws_vpc.cf_lab.cidr_block 
}

