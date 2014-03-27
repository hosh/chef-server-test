include_recipe 'layouts::single'

test_config    = data_bag_item 'tests', 'default'
local_log_path = File.join(test_config['local_log_path'], 'install', test_config['package_info']['platform_info'])
host_cache_path = test_config['cache_path']

machine "chef-server" do
  tag 'converge'
  attribute %w(chef-server-test log_path), local_log_path

  recipe 'chef-server'
  recipe 'setup::chef-server-clients'
end

ruby_block 'delay' do
  block do
    sleep 30
  end
end

machine "converge" do
  tag 'converge'
  chef_server chef_server_url: "https://#{test_config['chef_server_ip_address']}",
    options: { client_name: test_config['admin_client'], signing_key_filename: test_config['admin_key_path'] }
  local_provisioner_options = {
    'vagrant_config' => <<ENDCONFIG
config.vm.synced_folder "#{host_cache_path}", '/tmp/cache'
ENDCONFIG
  }

  provisioner_options ChefMetal.enclosing_provisioner_options.merge(local_provisioner_options)
end
