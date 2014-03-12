require 'rlet'

# Validates upgrade target
# Meant to be included after including the Test concern
module ChefServerTest
  module Concerns
    module ValidUpgradeTargets
      extend Concern

      included do
        let(:upgrade_list) { requesting_all? ? available_releases : parsed_upgrade_from }
        let(:upgrade_from) { options[:upgrade_from] || :latest }
        let(:parsed_upgrade_from) { Array(upgrade_from.to_s.gsub(/\s+/, '').split(',')).uniq }
        let(:requesting_all?) { upgrade_from == 'all' }

        let(:available_releases) { %w(11.0.4 11.0.6 11.0.8 11.0.10 11.0.11) }
        let(:valid_upgrade_target) { ->(x) { x =~ /\d+\.\d+\.\d+|latest/ } }
      end

      def validate_upgrade_targets!
        return true if requesting_all?
        parsed_upgrade_from.each do |version|
          error!("Not a valid version #{version}.\nAvailable releases: #{available_releases}", 3) unless valid_upgrade_target.(version)
          error!("Requested release #{version} not available.\nAvailable releases: #{available_releases}", 3) unless version == 'latest' || available_releases.include?(version)
        end
      end

    end
  end
end
