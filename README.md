Overview
========

This is the "chef-repo" for building WolferX Development Environment.
It will automate bootstrap a complete server for your development environment.
It majorly includes:
..* Nginx
..* Tomcat
..* Jersey
..* Cassandra

How to use
==========

1. boot up CentOS-7 linux machine using Virtual Box (or EC2)
	- *Suggest:* recommend with 20GB virtual disk spaces
2. login with *root* user or running following command with sudo
	- *Suggest:* to add a password for root, somehow the system will add a password for you if you don't
	- *CMD:* passwd root
3. update yum package management tool
	- *CMD:* yum update -y
4. install chef-client by rpm
	- *CMD:* rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/7/x86_64/chef-12.5.1-1.el7.x86_64.rpm
5. create chef-client configure file
	- *CMD:* mkdir -p /etc/chef/
	- *CMD:* touch /etc/chef/client.rb
6. insert following config into /etc/chef/client.rb
	- *CMD:* vi /etc/chef/client.rb
	- *Config:* <br/>
	#environment 'production' <br/>
	#environment_path '/root/chef-repo/environments' <br/>
	#chef_server_url  "https://cfchef/organizations/wolferx" <br/>
	#validation_client_name "wolferx-validator" <br/>
	#Using default node name (fqdn) <br/>
	#trusted_certs_dir "/etc/chef/trusted_certs" <br/>
	log_location  STDOUT <br/>
	log_level :info <br/>
	cookbook_path  "/root/chef-repo/cookbooks" <br/>
	role_path '/root/chef-repo/roles' <br/>
	data_bag_path  '/root/chef-repo/data_bags' <br/>
	encrypted_data_bag_secret '/etc/chef' <br/>
	local_mode 'true' <br/>
	node_name 'node' <br/>
	node_path '/root/chef-repo/nodes' <br/>
7. install git & clone chef-repo
	- *CMD:* yum install git -y
	- *CMD:* git clone https://github.com/wolferian/wolferx-chef-repo ~/chef-repo
	- *Suggest:* make sure existence of ~/chef-repo
8. bootstrap the server by chef-client
	- *CMD:* chef-client
	- 1st time may fail at tomcat trying to add SSL, if so, just run chef-client again
9. deploy database schema for testing
	- *CMD:* cqlsh -f ~/chef-repo/wolfer_schema/cassandra/testTable.cql
10. add npm execution path into environment PATH
	- *CMD:* source ~/chef-repo/wolfer_script/export_npm_to_path.sh

Test
====

1. @Linux get ip address of the server
	- *CMD:* ifconfig
2. @Local add Linux hostname to hosts
	- *CMD:* vi /etc/hosts
	- insert "hostname ip", eg. "x.x.x.x wolferx.com"
3. @Browser 
	- *url:* http://wolferx.com:8080/wolferapi/rest/test
4. @Cassandra
	- *GUI Tool:* https://academy.datastax.com/downloads/ops-center?destination=downloads/ops-center&dxt=DX#devCenter 
	- connet to ip_address of VM, port 9042

Congrats!
=========

You should have a running machine with one line deployment enabled.
- *One Line*: chef-client
- *Deploy*: https://github.com/wolferian/wolferapi
