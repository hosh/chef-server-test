include_recipe 'layouts::single'

test_config     = data_bag_item 'tests', 'default'
local_log_path  = File.join(test_config['local_log_path'], 'install', test_config['package_info']['platform_info'])
host_cache_path = test_config['cache_path']

chef_server_ip_address = test_config['chef_server_ip_address']
ip_address             = test_config['converge_ip_address']

#chef_server_url = if test_config['use_ipv6']
#                    "https://[#{test_config['chef_server_ip_address']}]"
#                  else
#                    "https://#{test_config['chef_server_ip_address']}"
#                  end
# Use host-based ipv6 addressing for now
chef_server_url = "https://chef-server.test"

network_config = if test_config['use_ipv6']
                   "config.vm.network :public_network,  :bridge => \"#{test_config['vagrant_ipv6_interface']}\""
                 else
                   "config.vm.network :private_network, ip: \"#{ip_address}\""
                 end

machine "chef-server" do
  tag 'converge'
  attribute %w(chef-server-test log_path), local_log_path

  recipe 'chef-server'
  recipe 'chef-server-config::ipv6' if test_config['use_ipv6']
  recipe 'chef-server-config::clients'
end

include_recipe 'setup::berkshelf'

machine "converge" do
  tag 'converge'

  local_provisioner_options = {
    'vagrant_config' => <<ENDCONFIG
#{network_config}
config.vm.synced_folder "#{host_cache_path}", '/tmp/cache'
ENDCONFIG
  }

  provisioner_options ChefMetal.enclosing_provisioner_options.merge(local_provisioner_options)
end

# Switch to ipv6 mode before trying a converge
# TODO: Abstract this out into its own recipe
if test_config['use_ipv6']
  machine_execute "/sbin/ip -6 addr add #{ip_address}/64 dev eth1 || true" do
    machine 'converge'
  end

  machine_execute "/sbin/ip -4 addr delete dev eth1 || true" do
    machine 'converge'
  end

  machine_file '/etc/hosts' do
    machine 'converge'
    content <<END
127.0.0.1       localhost
::1             localhost

#{chef_server_ip_address}  chef-server.test
#{ip_address} converge.test
END
  end
end

machine "converge" do
  recipe 'apt' if test_config['package_info']['platform'] == 'ubuntu'
  recipe 'nginx'

  chef_server chef_server_url: chef_server_url,
    options: { client_name: test_config['admin_client'], signing_key_filename: test_config['admin_key_path'] }
end
