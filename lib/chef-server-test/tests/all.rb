require 'chef-server-test/concerns/test'
require 'chef-server-test/concerns/valid_upgrade_targets'
require 'chef-server-test/tests/install'
require 'chef-server-test/tests/upgrade'

# This test sequentially invokes all the tests
module ChefServerTest
  module Tests
    class All
      include ChefServerTest::Concerns::Test
      include ChefServerTest::Concerns::ValidUpgradeTargets

      def execute!
        validate_upgrade_targets!

        ChefServerTest::Tests::Install.
          new(candidate_pkg_path: candidate_pkg_path).
          execute!

        ChefServerTest::Tests::Upgrade.
          new(candidate_pkg_path: candidate_pkg_path,
              upgrade_from:       options[:'upgrade-from']).
          execute!
      end

      def info!
        puts "Running install test on: #{normalized_candidate_pkg_path}"
        puts "Running upgrade test on: #{normalized_candidate_pkg_path}"
        puts "Upgrading from: #{upgrade_from}"
        puts "Expanded upgrade list:\n  #{upgrade_list.join("\n  ")}"
      end

      def error!(msg, exit_status)
        puts msg
        exit exit_status
      end
    end
  end
end
