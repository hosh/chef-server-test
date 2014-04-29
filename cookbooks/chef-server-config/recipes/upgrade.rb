require 'chef/mixin/shell_out'


candidate_pkg = node['chef-server']['candidate_pkg']

# Print out version manifest to verify original version
ruby_block 'verify_original_install' do
  block do
    self.class.send(:include, Chef::Mixin::ShellOut)
    Chef::Log.info(self.shell_out('cat /opt/chef-server/version-manifest.txt').stdout)
  end
end

# First, stop chef server and wait 30 seconds

execute '/opt/chef-server/bin/chef-server-ctl stop' do
  retries 20
end

ruby_block 'sleep_30' do
  block { sleep 30 }
end

# install the platform package
package candidate_pkg do # ignore ~FC009 known bug in food critic causes this to trigger see Foodcritic Issue #137
  source candidate_pkg
  provider case node["platform_family"]
           when "debian"; Chef::Provider::Package::Dpkg
           when "rhel"; Chef::Provider::Package::Rpm
           else
            raise RuntimeError("I don't know how to install chef-server packages for platform family '#{node["platform_family"]}'!")
           end
  action :install
end

# Actually perform the upgrade
execute '/opt/chef-server/bin/chef-server-ctl upgrade'

# Print out version manifest to verify original version
ruby_block 'verify_upgrade' do
  block do
    Chef::Log.info(shell_out('cat /opt/chef-server/version-manifest.txt').stdout)
  end
end

# Start up services again
execute '/opt/chef-server/bin/chef-server-ctl start' do
  retries 20
end

ruby_block 'sleep_another_30' do
  block { sleep 30 }
end

