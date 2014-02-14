# vim: set ft=ruby

def env(key)
  ENV[key.to_s] || abort("Must define $#{key.to_s}.")
end

Vagrant.configure("2") do |config|
  config.vm.box = "drone"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.omnibus.chef_version = :latest

  config.ssh.forward_agent = true

  config.vm.provider :aws do |aws, override|
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    aws.access_key_id     = env(:AWS_ACCESS_KEY)
    aws.secret_access_key = env(:AWS_SECRET_KEY)
    aws.keypair_name      = env(:AWS_KEYPAIR)
    aws.region            = env(:AWS_REGION)
    aws.ami               = env(:AWS_AMI)
    aws.instance_type     = env(:AWS_INSTANCE_TYPE)
    aws.security_groups   = [env(:AWS_SECURITY_GROUP)]
    aws.availability_zone = env(:AWS_AVAILABILITY_ZONE)
    aws.tags              = { "Name" => env(:AWS_INSTANCE_NAME) }

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = env(:PRIVATE_KEY_PATH)
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.add_recipe "chef-golang"
    chef.add_recipe "runit"
    chef.add_recipe "aws"
    chef.add_recipe "docker"
    chef.add_recipe "drone::aws"
    chef.add_recipe "drone::droned"

    chef.json = {
      go: {
        version: "1.2",
      },
      aws: {
        access_key: env(:AWS_ACCESS_KEY),
        secret_access_key: env(:AWS_SECRET_KEY),
        elastic_ip: env(:AWS_ELASTIC_IP),
        ebs_volume_id: env(:AWS_EBS_VOLUME_ID),
      },
      docker: {
        options: "-g /mnt/docker",
      }
    }
  end
end
