test_config = data_bag_item 'tests', 'default'

include_recipe 'stacks::vagrant'

case test_config['package_info']['platform_info']
when 'ubuntu.10.04' then include_recipe 'os::ubuntu-10.04'
when 'ubuntu.11.04' then include_recipe 'os::ubuntu-11.04'
when 'ubuntu.12.04' then include_recipe 'os::ubuntu-12.04'
when 'el5'          then include_recipe 'os::centos-5.10'
when 'el6'          then include_recipe 'os::centos-6.5'
else raise "Unsupported platform #{test_config['package_info']['platform_info']}"
end

include_recipe 'machines::chef-server'
