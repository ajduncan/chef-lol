#
# Cookbook Name:: chef-lol
# Recipe:: lol
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'git'
include_recipe 'user'


user 'lol' do
  home        '/home/lol'
  manage_home true
  shell       '/bin/bash'
  password    '$1$k4UUIYCK$qmYqvOjSupYT29YRNBum80'
  action      :create
end


include_recipe 'rvm::user'


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


rvm_shell 'install lol dependencies' do
  cwd '/home/lol/lol'
  user 'lol'
  code <<-EOH
    source /home/lol/.rvm/scripts/rvm
    bundle install --path .bundle
  EOH
end
