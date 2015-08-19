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
ruby_lol = "/home/lol/.rbenv/versions/#{ruby_version}/bin/ruby"


user 'lol' do
  home        '/home/lol'
  manage_home true
  shell       '/bin/bash'
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


include_recipe 'rbenv::user'


rbenv_script "bundle install" do
  rbenv_version ruby_version
  cwd '/home/lol/lol'
  user 'vagrant'
  group 'vagrant'
  code %{bundle install}
end


rbenv_script "sequel migration" do
  rbenv_version ruby_version
  cwd '/home/lol/lol'
  user 'lol'
  group 'lol'
  code "sequel -m db/migrations #{postgresql_uri}"
end
