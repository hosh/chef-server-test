
test_config       = data_bag_item 'tests', 'default'
host_cache_path   = test_config['cache_path']
candidate_pkg     = test_config['local_candidate_pkg_path']
install_candidate = test_config['install_candidate']
upgrade_from      = test_config['upgrade_from_version']
ip_address        = test_config['chef_server_ip_address']

machine "chef-server" do
  tag 'chef-server'

  # Some of this stuff would need to support Windows
  attribute %w(chef-server api_fqdn), 'chef-server'
  attribute %w(chef-server file_cache_path), '/tmp/cache/releases'
  attribute %w(chef-server package_file), candidate_pkg if candidate_pkg && install_candidate
  attribute %w(chef-server candidate_pkg), candidate_pkg
  attribute %w(chef-server version), upgrade_from if upgrade_from

  local_provisioner_options = {
    'vagrant_config' => <<ENDCONFIG
config.vm.network "private_network", ip: "#{ip_address}"
config.vm.synced_folder "#{host_cache_path}", '/tmp/cache'
ENDCONFIG
  }

  provisioner_options ChefMetal.enclosing_provisioner_options.merge(local_provisioner_options)
end
