include_recipe 'layouts::single'

test_config    = data_bag_item 'tests', 'default'
local_log_path = File.join(test_config['local_log_path'], 'install', test_config['package_info']['platform_info'])

machine "chef-server" do
  tag 'install'

  attribute %w(chef-server-test log_path), local_log_path

  recipe 'chef-server'
  recipe 'chef-server-config::ipv6' if test_config['use_ipv6']
  recipe 'pedant::full'
end
