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
