#
# Cookbook Name:: wolfer-api
# Recipe:: default
#
# Copyright 2015, WolferX
#
# All rights reserved - Do Not Redistribute
#

git '/site/wolferapi' do
  repository 'https://github.com/wolferian/wolferapi.git'
  revision 'master'
  action :sync
end

execute 'mvn clean install wolferapi' do
  command 'mvn -f /site/wolferapi/pom.xml clean install'
  notifies :run, 'execute[rm previous wolferapi.war]', :immediately
end

execute 'rm previous wolferapi.war' do
  command 'rm -f /var/lib/tomcat/webapps/wolferapi.war'
  only_if {File.exist?("/var/lib/tomcat/webapps/wolferapi.war")} 
  action :nothing
  notifies :run, 'execute[cp war wolferapi to tomcat home]', :immediately
end

execute 'cp war wolferapi to tomcat home' do
  command 'cp /site/wolferapi/target/wolferapi.war /var/lib/tomcat/webapps/'
end

service "tomcat" do
  action :restart
end