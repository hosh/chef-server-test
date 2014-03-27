test_config  = data_bag_item 'tests', 'default'
vms_path     = test_config['vms_path']
server_url   = "https://#{test_config['chef_server_ip_address']}"
shelf_path   = File.join(vms_path, 'cookbooks')
berkshelf_conf_path = File.join(vms_path, 'berkshelf.conf')

cookbook_file 'Gemfile' do
  source 'berkshelf/Gemfile'
  path File.join(vms_path, 'Gemfile')
end

cookbook_file 'Berksfile' do
  source 'berkshelf/Berksfile'
  path File.join(vms_path, 'Berksfile')
end

berkshelf_conf = {
  chef: {
    server_url: "https://#{test_config['chef_server_ip_address']}",
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
  cwd vms_path
end

execute "berks update -c #{berkshelf_conf_path}" do
  cwd vms_path
end

execute "berks upload -c #{berkshelf_conf_path}" do
  cwd vms_path
end
