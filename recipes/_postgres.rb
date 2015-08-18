#
# Cookbook Name:: lol
# Recipe:: postgres
#
# Copyright (C) 2015 Andy Duncan
#

db = node["lol"]["database"]

# ensure the database is installed if provisioning to localhost
include_recipe "postgresql::server" if db["host"] == "localhost"

# ensure the postgresql client is installed
include_recipe "postgresql::client"
include_recipe "postgresql::ruby"

# ensure the postgresql_database resource available
include_recipe "database::postgresql"


postgresql_connection_info = {
  :host => db["host"],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}


# ensure the database is created
postgresql_database db["name"] do
  connection postgresql_connection_info
  action :create
end


postgresql_database_user db["username"] do
  connection postgresql_connection_info
  password db["password"]
  action :create
end

postgresql_database_user db["username"] do
  connection postgresql_connection_info
  database_name db["name"]
  password db["password"]
  privileges [:all]
  action :grant
end
