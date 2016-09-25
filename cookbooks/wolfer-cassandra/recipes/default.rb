#
# Cookbook Name:: wolfer-cassandra
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/apache-cassandra.tar.gz" do
   source "http://apache.arvixe.com/cassandra/3.0.0/apache-cassandra-3.0.0-rc2-bin.tar.gz"
end

execute 'untar cassandra' do
  command 'tar -xzvf /tmp/apache-cassandra.tar.gz -C /tmp'
  action :run
  not_if {::File.exists?("/tmp/apache-cassandra-3.0.0-rc2")} 
end

execute 'move cassandra to opt dir' do
  command 'cp /tmp/apache-cassandra-3.0.0-rc2 /etc/apache-cassandra'
  action :run
  only_if {::File.exists?("/tmp/apache-cassandra-3.0.0-rc2")}
  not_if {::File.exists?("/etc/apache-cassandra")}
end

link '/usr/local/bin/cqlsh' do
  to '/etc/apache-cassandra/bin/cqlsh'
end

directory '/var/lib/cassandra' do
  mode "0644"
  recursive true
end

directory '/var/log/cassandra' do
  mode "0644"
  recursive true
end

template '/etc/apache-cassandra/conf/cassandra.yaml' do
  source 'cassandra.yaml.erb'
  mode '0644'
end

execute 'export $CASSANDRA_CONF' do
  command 'export CASSANDRA_CONF=/etc/apache-cassandra/conf/'
  action :run
end

execute 'run cassandra' do
  command '/etc/apache-cassandra/bin/cassandra'
  action :run
end
