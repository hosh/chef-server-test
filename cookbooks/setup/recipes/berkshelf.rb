test_config  = data_bag_item 'tests', 'default'
vms_path     = test_config['vms_path']
#server_url   = if test_config['use_ipv6']
#                 "https://[#{test_config['chef_server_ip_address']}]"
#               else
#                 "https://#{test_config['chef_server_ip_address']}"
#               end
server_url = 'https://chef-server.test'
shelf_path   = File.join(vms_path, 'cookbooks')
gemfile_conf_path   = File.join(vms_path, 'Gemfile')
berkshelf_conf_path = File.join(vms_path, 'berkshelf.conf')

cookbook_file 'Gemfile' do
  source 'berkshelf/Gemfile'
  path gemfile_conf_path
end

cookbook_file 'Berksfile' do
  source 'berkshelf/Berksfile'
  path berkshelf_conf_path
end

berkshelf_conf = {
  chef: {
    server_url: server_url,
    client_key: test_config['admin_key_path'],
    node_name: test_config['admin_client'],
    chef_server_url: server_url
  },
  ssl: {
    verify: false
  }
}

file 'berkshelf.conf' do
  path berkshelf_conf_path
  content berkshelf_conf.to_json
end

execute 'bundle install' do
  environment({'BUNDLE_GEMFILE' => gemfile_conf_path})
  cwd vms_path
end

execute "berks update -c #{berkshelf_conf_path}" do
  environment({'BUNDLE_GEMFILE' => gemfile_conf_path})
  cwd vms_path
end

execute "berks upload -c #{berkshelf_conf_path}" do
  environment({'BUNDLE_GEMFILE' => gemfile_conf_path})
  cwd vms_path
end
