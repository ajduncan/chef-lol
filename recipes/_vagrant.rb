#
# Cookbook Name:: lol
# Recipe:: vagrant
#
# Copyright (C) 2015 Andy Duncan
#


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
