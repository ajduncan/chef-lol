#
# Cookbook Name:: lol
# Attributes:: default
#

default["lol"]["ruby"]["version"]       = "2.2.3"
default["lol"]["username"]              = "lol"
default["lol"]["group"]                 = "lol"
default["lol"]["password"]              = "$1$k4UUIYCK$qmYqvOjSupYT29YRNBum80"
default["lol"]["home"]                  = "/home/#{default["lol"]["username"]}"
default["lol"]["app_path"]              = "#{default["lol"]["home"]}/lol/lol.rb"
default["lol"]["rerun"]                 = ""
default["lol"]["ruby"]                  = "#{default["lol"]["home"]}/.rbenv/versions/#{default["lol"]["ruby"]["version"]}/bin/ruby"

default["lol"]["database"]["name"]      = "lol"
default["lol"]["database"]["host"]      = "localhost"
default["lol"]["database"]["username"]  = "lol"
default["lol"]["database"]["password"]  = "foobarbaz"
default["lol"]["database"]["url"]       = "postgresql://#{default["lol"]["database"]["username"]}:#{default["lol"]["database"]["password"]}@#{default["lol"]["database"]["host"]}/#{default["lol"]["database"]["name"]}"
