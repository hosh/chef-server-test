require 'cheffish'
require 'chef_metal'

test_config  = data_bag_item 'tests', 'default'
base_path    = test_config['base_path']
vms_path     = test_config['vms_path']
cluster_repo = test_config['cluster_repo']

# Set up a vagrant cluster (place for vms) in ~/machinetest
vagrant_cluster vms_path

directory cluster_repo
with_chef_local_server :chef_repo_path => base_path
