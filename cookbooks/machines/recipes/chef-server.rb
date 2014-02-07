machine "chef-server" do
  tag 'chef-server'
  recipe 'chef-server'
  recipe 'pedant::full'

  attribute %w(chef-server api_fqdn), 'chef-server'

  local_provisioner_options = {
    'vagrant_config' => <<ENDCONFIG
config.vm.synced_folder "#{File.join(ENV['PWD'], 'cache')}", '/tmp/cache'
ENDCONFIG
  }

  provisioner_options ChefMetal.enclosing_provisioner_options.merge(local_provisioner_options)

  complete true
end
