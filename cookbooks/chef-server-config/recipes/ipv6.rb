host_info    = node['host']
ipv6_address = host_info['ipv6_address']

# Add ipv6 address
if ipv6_address
  execute "/sbin/ip -6 addr add #{ipv6_address}/64 dev eth1 || true"
  execute "/sbin/ip -4 addr delete dev eth1 || true"

  template '/etc/chef-server/chef-server.rb' do
    source 'chef-server.rb.erb'
    variables ip_version: 'ipv6'
  end

  execute '/opt/chef-server/bin/chef-server-ctl reconfigure'
end


ruby_block 'sleep 30 while restarting chef-server' do
  block { sleep 30 }
end
