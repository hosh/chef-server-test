test_config    = data_bag_item 'tests', 'default'
keys_path      = test_config['local_key_path']
admin_pem      = File.join(keys_path, 'admin.pem')

directory keys_path do
  owner 'root'
  group 'root'
  mode '00666'
  recursive true
  action :create
end


remote_file admin_pem do
  owner 'root'
  group 'root'
  mode 0644
  path admin_pem
  source 'file:///etc/chef-server/admin.pem' # Default location
  action :create # Always overwrite
end

