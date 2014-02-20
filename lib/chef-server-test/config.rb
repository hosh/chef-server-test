# This file aggregates all the different configs for the tests

require 'mixlib/config'
require 'pathname'
require 'chef/json_compat'

module ChefServerTest
  module Config
    extend Mixlib::Config
    config_strict_mode true  # will see how annoying this is

    # Sets the base path. Usually called from bin/validate
    def self.with_base_path(path)
      self.base_path path
      self
    end

    # Sets the candidate path. Usually called from bin/validate
    def self.with_candidate_pkg(pkg)
      self.candidate_pkg pkg
      self
    end

    # Base Path points to the root of the chef-server-test repo
    # By default, the bin/validate script will set this to the parent
    # dir of bin
    default :base_path, nil

    # Chef Client flags gets added for each chef-client operations
    # These defaults are set for a dev environment, and may need to
    # be tweaked if used with CI.
    default :chef_client_flags, '-z -l info -F doc --color --no-fork'

    # Sets the candidate package for install and upgrade tests
    # bin/validate will accept this in the command line option
    configurable :candidate_pkg

    # Derived values
    default(:vms_path)       { File.join base_path, 'vms' }
    default(:cluster_repo)   { File.join vms_path, 'repo' }

    default(:cache_path)     { File.join base_path, 'cache' }
    default(:releases_path)  { File.join cache_path, 'releases' }
    default(:data_bags_path) { File.join base_path, 'data_bags' }

    # Internal settings, usually test-dependent

    # If a candidate package is available, install it.
    # Upgrade tests will set set this to false.
    default :install_candidate, true

    # Glue layer for generating config for chef-client

    def self.to_hash
      {
        'id'            => 'default',
        'base_path'     => base_path,
        'vms_path'      => vms_path,
        'cluster_repo'  => cluster_repo,
        'cache_path'    => cache_path,
        'releases_path' => releases_path,

        'host_candidate_pkg_path' => candidate_pkg,
        'candidate_pkg'           => (candidate_pkg.nil? || candidate_pkg.empty? ? nil : File.basename(candidate_pkg)),
        'install_candidate'       => install_candidate
      }
    end

    # TODO: Check what parser we are supposed to be using
    def self.to_json
      Chef::JSONCompat.to_json_pretty(to_hash)
    end

    def self.generate_data_bag!
      ensure_test_data_bag_dir!
      File.open(File.join(data_bags_path, 'tests', 'default.json'), "w") do |f|
        f.puts to_json
      end
    end

    def self.normalize_candidate_pkg(pkg_path)
      if Pathname.new(pkg_path).absolute?
        return pkg_path if File.exists? pkg_path
        return nil # Always return nil if package does not exist
      end
      return File.join cache_path, pkg_path if File.exists?(File.join(cache_path, pkg_path))
      return File.join base_path,  pkg_path if File.exists?(File.join(base_path, pkg_path))
    end

    private

    def self.ensure_test_data_bag_dir!
      Pathname.new(File.join(base_path, 'data_bags', 'tests')).mkpath
    end
  end
end
