#***********************************************************
# Install Suricata
#***********************************************************
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
sudo apt install suricata -y
sudo suricata-update
sudo systemctl restart suricata


#***********************************************************
#Install Wazuh-agent
#***********************************************************

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
sudo echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt update
sudo apt install -y wazuh-agent
sudo systemctl start wazuh-agent


#***********************************************************
# Join Wazuh Agent
#***********************************************************

sudo sh -c "/var/ossec/bin/agent-auth -m wazuh01.dev.cloudforums.net"

