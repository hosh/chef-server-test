machine "chef-server" do
  tag 'chef-server'
  recipe 'chef-server'

  attribute %w(chef-server api_fqdn), 'chef-server.local'
end
