machine "chef-server" do
  tag 'chef-server'

  attribute %w(chef-server api_fqdn), 'chef-server'
  attribute %w(chef-server file_cache_path), '/tmp/cache/releases'

  local_provisioner_options = {
    'vagrant_config' => <<ENDCONFIG
config.vm.synced_folder "#{File.join(ENV['PWD'], 'cache')}", '/tmp/cache'
ENDCONFIG
  }

  provisioner_options ChefMetal.enclosing_provisioner_options.merge(local_provisioner_options)
end
