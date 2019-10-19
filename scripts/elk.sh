#***********************************************************
# ELK Server Install Script
#***********************************************************

#***********************************************************
#Pull down latest repository updates
#***********************************************************

sudo apt update -y

#***********************************************************
#Install curl, apt-transport-https, and lsb-release
#***********************************************************

sudo apt install -y curl
sudo apt install -y apt-transport-https
sudo apt install -y lsb-release



#***********************************************************
#Install GPG keys and add repository
#***********************************************************

curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

#***********************************************************
# APT Update
#***********************************************************

sudo apt -y update

#***********************************************************
#Install Elasticsearch and Kibana
#***********************************************************
sudo apt install -y elasticsearch=7.3.2
sudo apt install -y kibana=7.3.2

#***********************************************************
#Start elasticsearch service and configure it to automatically start at boot
#***********************************************************
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

#***********************************************************
#Start kibana service and configure it to automatically start at boot
#***********************************************************
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service


#Wazuh Kibana app
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.10.0_7.3.2.zip

#***********************************************************
# Install Suricata
#***********************************************************
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
sudo apt install suricata -y
sudo suricata-update
sudo systemctl restart suricata

#***********************************************************
#Disable Elasticsearch repository updates
#***********************************************************
sudo sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-7.x.list
sudo apt -y update


#***********************************************************
#Install Wazuh-agent
#***********************************************************

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
sudo echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt update
sudo apt install -y wazuh-agent
sudo sed -i 's/MANAGER_IP/wazuh01.dev.cloudforums.net/' /var/ossec/etc/ossec.conf 
sudo systemctl start wazuh-agent

#***********************************************************
#Configure Kibana
#***********************************************************

echo 'server.host: "0.0.0.0"' >> /etc/kibana/kibana.yml
echo 'logging.dest: "/var/log/kibana/kibana.log"' >> /etc/kibana/kibana.yml
mkdir /var/log/kibana
sudo touch /var/log/kibana/kibana.log
systemctl restart kibana

#***********************************************************
#Configure elasticsearch
#***********************************************************

echo 'server.host: "0.0.0.0"' >> /etc/elasticsearch/elasticsearch.yml
echo 'discovery.type: single-node' >> /etc/elasticsearch/elasticsearch.yml
systemctl restart elasticsearch

#***********************************************************
# Join Wazuh Agent
#***********************************************************

sleep 90s
sudo sh -c "/var/ossec/bin/agent-auth -m wazuh01.dev.cloudforums.net"

