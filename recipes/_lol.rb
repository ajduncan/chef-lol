#
# Cookbook Name:: chef-lol
# Recipe:: lol
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'git'
include_recipe 'user'

ruby_version = node["lol"]["ruby"]["version"]
db = node["lol"]["database"]
postgresql_uri = "postgresql://#{db["username"]}:#{db["password"]}@#{db["host"]}/#{db["name"]}"
ruby_lol = "/home/#{node["lol"]["username"]}/.rbenv/versions/#{ruby_version}/bin/ruby"


user "#{node["lol"]["username"]}" do
  home        "/home/#{node["lol"]["username"]}"
  manage_home true
  shell       '/bin/bash'
  password    node["lol"]["password"]
  action      :create
end


directory "/home/#{node["lol"]["username"]}" do
  owner node["lol"]["username"]
  group node["lol"]["group"]
  mode  '0755'
  action :create
end


git "/home/#{node["lol"]["username"]}/lol" do
  repository 'https://github.com/ajduncan/lol.git'
  reference  'master'
  user       node["lol"]["username"]
  group      node["lol"]["group"]
  action     :sync
end


include_recipe 'rbenv::user'


rbenv_script "bundle install" do
  rbenv_version ruby_version
  cwd "/home/#{node["lol"]["username"]}/lol"
  user node["lol"]["username"]
  group node["lol"]["group"]
  code %{bundle install}
end


rbenv_script "sequel migration" do
  rbenv_version ruby_version
  cwd "/home/#{node["lol"]["username"]}/lol"
  user node["lol"]["username"]
  group node["lol"]["group"]
  code "sequel -m db/migrations #{postgresql_uri}"
end
