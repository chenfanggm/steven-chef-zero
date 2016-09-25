#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, C.F.Studio 
#
# All rights reserved - Do Not Redistribute
#

execute 'install epel-release' do
  command 'rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
  not_if "rpm -qa | grep 'epel-release'"
end    

package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start]
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  mode '0644'
end

directory '/etc/nginx/sites-available' do
  mode "0644"
  recursive true
end

directory '/etc/nginx/sites-enabled' do
  mode "0644"
  recursive true
end

execute "set SELinux to permissive" do
  command "setenforce 0"
end

node["nginx"]["sites"].each do |sitedomain, data|
  
  template "/etc/nginx/sites-available/#{data['server_name']}" do
    source "wolfx.conf.erb"
    mode "0644"
    variables(
      :port => data["port"],
      :server_domain => data["server_domain"],
      :server_name => data["server_name"]
    )
  end

  execute "add to sites-enabled" do
    command "ln -s /etc/nginx/sites-available/#{data['server_name']} /etc/nginx/sites-enabled/#{data['server_name']}"
    not_if { File.exists?("/etc/nginx/sites-enabled/#{data['server_name']}") }
  end

	directory "/site" do
	  mode "0644"
	end

	execute "change SELinux type" do
	  command "chcon -Rt httpd_sys_content_t /site/#{data['server_name']}"
	  action :nothing
	end

end

service 'nginx' do
  action [ :restart]
end

