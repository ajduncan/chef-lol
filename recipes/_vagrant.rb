#
# Cookbook Name:: lol
# Recipe:: vagrant
#
# Copyright (C) 2015 Andy Duncan
#


ruby_version = node["lol"]["ruby"]["version"]


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


rbenv_script "bundle install" do
  rbenv_version ruby_version
  cwd '/home/lol/lol'
  user 'vagrant'
  group 'vagrant'
  code %{bundle install}
end
