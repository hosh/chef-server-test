require 'chef-server-test/concerns/test'
require 'chef-server-test/concerns/valid_upgrade_targets'

module ChefServerTest
  module Tests
    class Upgrade
      include ChefServerTest::Concerns::Test
      include ChefServerTest::Concerns::ValidUpgradeTargets

      def execute!
        validate_upgrade_targets!
        info!

        results = upgrade_list.map do |base_version|
          setup! do
            ChefServerTest::Config.upgrade_from_version base_version

            # Disable initial install of candidate pkg so that we can test upgrade
            ChefServerTest::Config.install_candidate false
          end

          result = chef_client 'tests::upgrade'
          [base_version, result.status.success?]
        end

        puts "", "Summary of test results:"
        results.each do |version, result|
          puts "#{version}:   #{(result ? 'success' : 'failure')}"
        end
      end

      def info!
        puts "Running upgrade test on: #{candidate_pkg_path}"
        puts "Cached to #{cached_pkg_path}"
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
