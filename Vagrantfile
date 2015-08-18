# -*- mode: ruby -*-
# vi: set ft=ruby :

def abspath(f)
  File.expand_path("../#{f}", __FILE__)
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'chef-lol'

  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = 'latest'
  end

  config.vm.box = 'chef/ubuntu-14.04'
  config.vm.network :private_network, type: 'dhcp'
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    # Load node attributes and run list from a JSON file
    json_file = if File.exist?(abspath("chef.json"))
                  abspath("chef.json")
                else
                  abspath("chef.json.example")
                end
    chef.json = JSON.parse(IO.read(json_file))
    chef.environments_path = 'environments'
    chef.environment = 'production'
    chef.run_list = [
      'recipe[apt]',
      'recipe[lol::default]'
    ]
  end
end
