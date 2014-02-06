# Runs the smoke tests for pedant

execute "pedant_smoke" do
  command 'chef-server-ctl test'
end
