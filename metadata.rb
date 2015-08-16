name             'chef-lol'
maintainer       'Andy Duncan'
maintainer_email 'ajduncan@gmail.com'
license          'MIT'
description      'Installs/Configures lol'
long_description 'Installs/Configures lol'
version          '0.1.0'

supports "ubuntu", ">= 12.04"

%w{ apt apt-upgrade-once git database postgresql sudo user }.each do |cookbook|
  depends cookbook
end
