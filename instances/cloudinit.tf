data "template_cloudinit_config" "elk-init" {
  part {
    content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - wget
 - curl
runcmd:
 - [ sh, -c, "curl -fsSL https://raw.githubusercontent.com/MichaelRoberts98/LinuxSetupScripts/master/elk-setup.sh -o /tmp/elk.sh" ]
 - [ sh, -c, "sudo sh /tmp/elk.sh" ]
EOF
  }
}

data "template_cloudinit_config" "wordpress-init" {
  part {
    content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - wget
runcmd:
 - [ sh, -c, "curl -fsSL https://raw.githubusercontent.com/MichaelRoberts98/LinuxSetupScripts/master/wordpress_withNaxsi.sh -o /tmp/wordpress.sh" ]
 - [ sh, -c, "sudo sh /tmp/wordpress.sh" ]
 - [ sh, -c, "curl -fsSL https://raw.githubusercontent.com/MichaelRoberts98/LinuxSetupScripts/master/universal.sh -o /tmp/universal.sh"]
 - [ sh, -c, "sudo sh /tmp/universal.sh" ]
EOF
  }
}

data "template_cloudinit_config" "wazuh-init" {
  part {
    content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - wget
runcmd:
 - [ sh, -c, "curl -fsSL https://raw.githubusercontent.com/MichaelRoberts98/LinuxSetupScripts/master/wazuh-manager.sh -o /tmp/wazuh.sh" ]
 - [ sh, -c, "sudo sh /tmp/wazuh.sh" ]
EOF
  }
}

data "template_cloudinit_config" "vpn-init" {
  part {
    content = <<EOF
#cloud-config
repo_update: true
repo_upgrade: all
packages:
 - wget
 - bind9
runcmd:
 - [ sh, -c, "curl https://raw.githubusercontent.com/MichaelRoberts98/LinuxSetupScripts/master/universal.sh | bash" ]
 - [ sh, -c, "curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh" ]
 - [ sh, -c, "chmod +x openvpn-install.sh" ]
 - [ sh, -c, "AUTO_INSTALL=y ./openvpn-install.sh" ]
 - [ sh, -c, "" ]
EOF
  }
}