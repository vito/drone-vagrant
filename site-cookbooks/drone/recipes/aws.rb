if node['aws']['access_key'] && node['aws']['secret_access_key']
  include_recipe 'aws'

  aws_elastic_ip 'drone_elastic_ip' do
    aws_access_key node['aws']['access_key']
    aws_secret_access_key node['aws']['secret_access_key']
    ip node['aws']['elastic_ip']
    action :associate
    only_if { node['aws']['elastic_ip'] }
  end

  if node['aws']['ebs_volume_id']
    aws_ebs_volume 'docker_ebs_volume' do
      aws_access_key node['aws']['access_key']
      aws_secret_access_key node['aws']['secret_access_key']
      volume_id node['aws']['ebs_volume_id']
      device '/dev/sdi'
      action :attach
    end

    execute 'format drive' do
      command 'mkfs -t ext4 /dev/xvdi'
      not_if 'file -s /dev/xvdi | grep ext4'
    end

    directory "/opt/store" do
      owner 'root'
      group 'root'
      mode 00644
    end

    mount "/opt/store" do
      device '/dev/xvdi'
      fstype 'ext4'
      action [:mount, :enable]
    end
  end
end
