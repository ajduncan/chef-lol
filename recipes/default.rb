#
# Cookbook Name:: chef-lol
# Recipe:: default
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'git'
include_recipe 'user'


user 'lol' do
  home        '/home/lol'
  manage_home true
  password    '$1$k4UUIYCK$qmYqvOjSupYT29YRNBum80'
  action      :create
end


directory '/home/lol/lol' do
  owner 'lol'
  group 'lol'
  mode  '0755'
  action :create
end


git '/home/lol/lol' do
  repository 'https://github.com/ajduncan/lol.git'
  reference  'master'
  user       'lol'
  group      'lol'
  action     :sync
end


db = node["lol"]["database"]

# ensure the database is installed if provisioning to localhost
include_recipe "postgresql::server" if db["host"] == "localhost"

# ensure the postgresql client is installed
include_recipe "postgresql::client"

# ensure the postgresql_database resource available
include_recipe "database::postgresql"

# ensure the database is created
postgresql_database db["name"] do
  connection(
    :host     => db["host"],
    :username => db["username"],
    :password => db["password"]
  )
end
