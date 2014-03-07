# Runs all Pedant tests

log_path   = node['chef-server-test']['log_path']
pedant_http_log  = File.join(log_path, 'pedant-http.log')
pedant_junit_log = File.join(log_path, 'pedant-junit.log')
pedant_log       = File.join(log_path, 'pedant.log')

directory log_path do
  owner 'root'
  group 'root'
  mode '00666'
  recursive true
  action :create
end

# Some distros require utf-8 to be explicitly declared
env = { 'LANG' => 'en_US.UTF-8' }

execute "pedant_full" do
  command "chef-server-ctl test --all -L #{pedant_http_log} -J #{pedant_junit_log} > #{pedant_log}"
  environment env
end
