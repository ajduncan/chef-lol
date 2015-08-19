#
# Cookbook Name:: lol
# Recipe:: default
#
# Copyright (C) 2015 Andy Duncan
#

include_recipe 'lol::_postgres'


ruby_version = node["lol"]["ruby"]["version"]
db = node["lol"]["database"]
postgresql_uri = "postgresql://#{db["username"]}:#{db["password"]}@#{db["host"]}/#{db["name"]}"
ruby_lol = "/home/lol/.rbenv/versions/#{ruby_version}/bin/ruby"


# if using vagrant, use /vagrant, otherwise clone the git repo.
if node.chef_environment == 'development'
  include_recipe 'lol::_vagrant'
else
  include_recipe 'lol::_lol'
end


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


if node.chef_environment == 'development'
  rbenv_script "rerun" do
    rbenv_version ruby_version
    cwd '/home/lol/lol'
    user 'lol'
    group 'lol'
    code %{gem install rerun}
  end

  rbenv_script "rerun" do
    rbenv_version ruby_version
    cwd '/home/lol/lol'
    user 'lol'
    group 'lol'
    code "rerun --background #{ruby_lol} lol.rb"
  end
end
