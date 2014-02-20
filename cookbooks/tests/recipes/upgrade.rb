include_recipe 'layouts::single'

machine "chef-server" do
  tag 'install'

  recipe 'chef-server'
  recipe 'chef-server-upgrade'
  recipe 'pedant::full'
end
