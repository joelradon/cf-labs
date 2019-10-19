#***********************************************************
# Wazuh Server Install Script by Joel Radon - 04/16/19
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
#Create symbolic link to python
#***********************************************************

sudo sh -c "if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi"


#***********************************************************
#Install GPG Key
#***********************************************************

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -


#***********************************************************
#Add repository 
#***********************************************************

sudo echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list


#***********************************************************
#Pull down latest package information
#***********************************************************

sudo apt update


#***********************************************************
#Install wazuh
#***********************************************************

sudo apt install -y wazuh-manager=3.10.0-1

#***********************************************************
#Install Wazuh API
#***********************************************************

sudo apt install -y wazuh-api=3.10.0-1

#***********************************************************
#Install auditd
#***********************************************************

sudo apt install -y auditd


#***********************************************************
# Build appropriate groups
#***********************************************************

sudo sh -c "/var/ossec/bin/agent_groups -a -g ubuntu1804 -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g ubuntu1604 -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g management -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g web -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g app -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g database -q"

sudo sh -c "/var/ossec/bin/agent_groups -a -g docker -q"



#***********************************************************
#Add Node JS repository
#***********************************************************

sudo sh -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"

#***********************************************************
#Install Node JS
#***********************************************************

sudo apt install -y nodejs


#***********************************************************
#Disable Wazuh automatic updates
#***********************************************************

sudo sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
sudo apt update

#***********************************************************
#Setup Wazuh API
#***********************************************************
sudo sh -c "apt-get install -y pwgen > /dev/null 2>&1"
WAZUH_API_USER=`pwgen -c -n -1 20` > /dev/null 2>&1
WAZUH_API_PASSWORD=`pwgen -c -n -1 20` > /dev/null 2>&1
echo "WAZUH_API_USER: ${WAZUH_API_USER}" >> /root/wazuh-api.txt
echo "WAZUH_API_PASSWORD: ${WAZUH_API_PASSWORD}" >> /root/wazuh-api.txt
sudo sh -c "cd /var/ossec/api/configuration/auth && node htpasswd -c user ${WAZUH_API_USER} -b ${WAZUH_API_PASSWORD}"

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
#Install Filebeat
#***********************************************************
sudo apt install -y filebeat=7.3.2

#***********************************************************
#Download Filebeat config file to forward logs
#***********************************************************

sudo sh -c "curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/v3.9.5/extensions/filebeat/7.x/filebeat.yml"
sudo sh -c "curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v3.9.5/extensions/elasticsearch/7.x/wazuh-template.json"
sudo sh -c "curl -s https://packages.wazuh.com/3.x/filebeat/wazuh-filebeat-0.1.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module"


#***********************************************************
#Edit Filebeat config file to point to Elastic Server IP (In this lab environment I am using 127.0.0.1)
#***********************************************************

sudo sed -i 's/YOUR_ELASTIC_SERVER_IP/127.0.0.1/' /etc/filebeat/filebeat.yml

#***********************************************************
#Start Filebeat service and configure it to automatically start at boot
#***********************************************************
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service

#***********************************************************
#Disable Elasticsearch repository updates
#***********************************************************
sudo sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-7.x.list
sudo apt -y update


#***********************************************************
# Install OpenSCAP on Ubuntu
#***********************************************************

sudo apt install -y libopenscap8 xsltproc


#***********************************************************
# Grab newest OVAL OpenSCAP scan XML files
#***********************************************************

sudo sh -c "wget https://github.com/ComplianceAsCode/content/releases/download/v0.1.43/scap-security-guide-0.1.43-oval-510.zip"

#***********************************************************
# Unzip, move, and cleanup OVAL OpenSCAP scan XML files
#***********************************************************

sudo sh -c "unzip scap-security-guide-0.1.43-oval-510.zip"
sudo sh -c "cp -r scap-security-guide-0.1.43-oval-5.10/* /var/ossec/wodles/oscap/content/"
sudo sh -c "rm -r scap-security-guide-0.1.43-oval-5.10/"
sudo sh -c "rm scap-security-guide-0.1.43-oval-510.zip"

#***********************************************************
# Install Suricata
#***********************************************************
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt update
sudo apt install suricata -y
sudo suricata-update
sudo systemctl restart suricata

#***********************************************************
# Restart Wazuh
#***********************************************************

sudo systemctl restart wazuh-manager



sudo sed -i 's/127.0.0.1/elastic01.dev.cloudforums.net/' /etc/filebeat/filebeat.yml
