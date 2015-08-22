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
  home = '/home/vagrant'
  group = 'vagrant'
  app_home = '/vagrant'
  app_path = '/vagrant/lol.rb'
  rerun = "/home/vagrant/.rbenv/versions/#{node["lol"]["ruby"]["version"]}/lib/ruby/gems/2.2.0/bin/rerun --force-polling "
  ruby = "/home/vagrant/.rbenv/versions/#{node["lol"]["ruby"]["version"]}/bin/ruby"
else
  include_recipe 'lol::_lol'
  home = node["lol"]["home"]
  group = node["lol"]["group"]
  app_home = "#{home}/lol"
  app_path = node["lol"]["app_path"]
  rerun = node["lol"]["rerun"]
  ruby_path = node["lol"]["ruby_path"]
end


template "/etc/init/lol.conf" do
  source "lol.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :user => node["lol"]["username"],
    :home =>  home,
    :group => group,
    :rerun => rerun,
    :ruby => ruby,
    :app_home => app_home,
    :app_path => app_path
  )
end


template "/#{app_home}/.env" do
  source "env.erb"
  owner  node["lol"]["username"]
  group  node["lol"]["group"]
  mode   "0644"
  variables(
    :db_url => node["lol"]["database"]["url"]
  )
end


service "lol" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action   :enable
end
