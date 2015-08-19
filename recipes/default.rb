#
# Cookbook Name:: lol
# Recipe:: default
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'lol::_postgres'


# if using vagrant, use /vagrant, otherwise clone the git repo.
if node.chef_environment == 'development'
  include_recipe 'lol::_vagrant'
else
  include_recipe 'lol::_lol'
end
