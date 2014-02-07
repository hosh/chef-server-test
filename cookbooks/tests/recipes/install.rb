include_recipe 'layouts::single'

machine "chef-server" do
  tag 'install'

  recipe 'chef-server'
  recipe 'pedant::full'
end
