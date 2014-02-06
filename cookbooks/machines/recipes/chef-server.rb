machine "chef-server" do
  tag 'chef-server'
  recipe 'chef-server'

  attribute %w(chef-server api_fqdn), 'chef-server.local'

  provisioner_options({
    'vagrant_config' => <<ENDCONFIG
config.vm.synced_folder "#{File.join(ENV['PWD'], 'cache')}", '/tmp/cache'
ENDCONFIG
  })
end
