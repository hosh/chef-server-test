# Runs the smoke tests for pedant

execute "pedant_full" do
  command 'chef-server-ctl test --all'
end
