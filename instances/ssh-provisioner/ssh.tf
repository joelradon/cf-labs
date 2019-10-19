terraform {
  backend "s3" {}
}


resource "null_resource" "vpn_file" {
  provisioner "local-exec" {
    command = "sudo scp -i ~/.keys/wazuh.pem ubuntu@${data.terraform_remote_state.instances.outputs.vpn-server_ip}:/root/client.ovpn ~/" 
  }
}

