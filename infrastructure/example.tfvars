#************************************************
#Set Project Name and VPC_ID like this:
# project_name   = "MyCoolVPC"
# vpc_id         = "aws_vpc.MyCoolVPC.id"
#************************************************

project_name = "cf_lab"


vpc_cidr = "10.112.0.0/16"
vpn_subnet_cidr = "10.112.1.0/24"
web_subnet_cidr = "10.112.2.0/24"
mgmt_subnet_cidr = "10.112.3.0/24"
region = "us-west-1"
vpn_az = "us-west-1a"
web_az = "us-west-1a"
mgmt_az = "us-west-1a"
my_ip = "0.0.0.0/32"



remote_state_bucket = "my-s3-bucket"
remote_state_key = "lab-infra"
remote_state_region = "us-west-1"
