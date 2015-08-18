#
# Cookbook Name:: lol
# Recipe:: vagrant
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'rvm::vagrant'


directory '/home/lol' do
  owner 'vagrant'
  group 'vagrant'
  mode  '0755'
  action :create
end

link '/home/lol/lol' do
  to        '/vagrant'
  link_type :symbolic
end

bash 'install lol dependencies' do
  cwd '/home/lol/lol'
  user 'vagrant'
  code <<-EOH
    source /etc/profile.d/rvm.sh
    rvm use 2.1.2
    gem install bundler
    bundle install
  EOH
end
