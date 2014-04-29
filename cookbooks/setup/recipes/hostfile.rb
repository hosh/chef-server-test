test_config  = data_bag_item 'tests', 'default'

hostsfile_entry test_config['chef_server_ip_address'] do
  hostname  'chef-server.test'
  action    :create
end

hostsfile_entry test_config['converge_ip_address'] do
  hostname  'converge.test'
  action    :create
end
