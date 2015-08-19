#
# Cookbook Name:: lol
# Recipe:: vagrant
#
# Copyright (C) 2015 Andy Duncan
#


include_recipe 'rbenv::user'

ruby_version = node["lol"]["ruby"]["version"]
db = node["lol"]["database"]
postgresql_uri = "postgresql://#{db["username"]}:#{db["password"]}@#{db["host"]}/#{db["name"]}"
ruby_lol = "/home/vagrant/.rbenv/versions/#{ruby_version}/bin/ruby"


rbenv_script "bundle install" do
  rbenv_version ruby_version
  cwd '/vagrant'
  user 'vagrant'
  group 'vagrant'
  code %{bundle install}
end


rbenv_script "sequel migration" do
  rbenv_version ruby_version
  cwd '/vagrant'
  user 'vagrant'
  group 'vagrant'
  code "sequel -m db/migrations #{postgresql_uri}"
end


# this won't work - put this into upstart, supervisor, etc.
rbenv_script "rerun-run" do
  rbenv_version ruby_version
  cwd '/vagrant'
  user 'vagrant'
  group 'vagrant'
  code "rerun --background #{ruby_lol} lol.rb"
end
