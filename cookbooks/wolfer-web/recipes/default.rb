#
# Cookbook Name:: wolfer-web
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'remove mongo lock file' do
  command 'rm -rf /var/lib/mongo/mongod.lock'
  only_if {::File.exists?("/var/lib/mongo/mongod.lock")}
end

include_recipe "mongodb::default"

execute 'npm install -g gulp' do
  command 'npm install -g gulp'
end

execute 'npm install -g bower' do
  command 'npm install -g bower'
end

execute 'npm install -g browserify' do
  command 'npm install -g browserify'
end

execute 'npm install -g nodemon' do
  command 'npm install -g nodemon'
end

execute 'npm install -g forever' do
  command 'npm install -g forever'
end

git '/site/wolferweb' do
  repository 'https://github.com/wolferian/wolferweb.git'
  revision 'master'
  action :sync
end

execute 'npm install wolferweb' do
  cwd '/site/wolferweb'
  user 'root'
  group 'root'
  environment 'PATH' => "#{ENV['PATH']}:/usr/local/nodejs-binary-5.1.0/bin"
  command 'npm install'
end

execute 'bower install wolferweb' do
  cwd '/site/wolferweb'
  environment 'PATH' => "#{ENV['PATH']}:/usr/local/nodejs-binary-5.1.0/bin"
  command 'bower install --allow-root --config.interactive=false'
end

execute 'gulp build wolferweb' do
  cwd '/site/wolferweb'
  environment 'PATH' => "#{ENV['PATH']}:/usr/local/nodejs-binary-5.1.0/bin"
  command 'gulp build'
end

execute 'forever stop all' do
  cwd '/site/wolferweb'
  environment 'PATH' => "#{ENV['PATH']}:/usr/local/nodejs-binary-5.1.0/bin"
  command 'forever stopall'
end

execute 'forever wolferweb' do
  cwd '/site/wolferweb'
  environment 'PATH' => "#{ENV['PATH']}:/usr/local/nodejs-binary-5.1.0/bin"
  command 'npm run forever'
end
