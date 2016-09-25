#
# Cookbook Name:: wolfer-end
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


service 'cassandra' do
  action [:enable, :restart]
end