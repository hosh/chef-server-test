require 'chef-server-test/concerns/test'

module ChefServerTest
  module Tests
    class Upgrade
      include ChefServerTest::Concerns::Test

      let(:upgrade_list) { requesting_all? ? available_releases : parsed_upgrade_from }
      let(:upgrade_from) { options[:upgrade_from] || :latest }
      let(:parsed_upgrade_from) { Array(upgrade_from.to_s.gsub(/\s+/, '').split(',')).uniq }
      let(:requesting_all?) { upgrade_from == 'all' }

      let(:available_releases) { %w(11.0.4 11.0.6 11.0.8 11.0.10 11.0.11) }
      let(:valid_upgrade_target) { ->(x) { x =~ /\d+\.\d+\.\d+|latest/ } }

      def execute!
        validate!
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

      def validate!
        return true if requesting_all?
        parsed_upgrade_from.each do |version|
          error!("Not a valid version #{version}.\nAvailable releases: #{available_releases}", 3) unless valid_upgrade_target.(version)
          error!("Requested release #{version} not available.\nAvailable releases: #{available_releases}", 3) unless version == 'latest' || available_releases.include?(version)
        end
      end

      def info!
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
