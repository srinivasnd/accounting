#!/usr/bin/env ruby

Vagrant.configure("2") do |config|

  config.berkshelf.enabled = true

  # ubuntu
  # config.vm.box     = 'precise'
  # config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  # centos
  config.vm.box     = 'pagoda_cent6_minimal'
  config.vm.box_url = 'https://s3.amazonaws.com/vagrant.pagodabox.com/boxes/centos-6.4-x86_64-minimal.box'

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpus", "2", "--memory", "1024", "--cpuexecutioncap", "75"]
  end

  config.ssh.forward_agent = true

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "test/data_bags"
    chef.add_recipe 'accounting'
    chef.json = {
      'accounting' => {
        'users' => %w( root tylerflint joe ),
        # 'implode_users' => %w( tylerflint ),
        'groups' => [
          {
            'name' => 'sudo',
            'gid' => 27,
            'members' => %w( tylerflint )
          }
        ]
        # 'implode_groups' => %w( sudo )
      }
    }
  end

end
