require 'rlet'
require 'chef-server-test/concerns/test_config'
require 'chef-server-test/shell_out'

module ChefServerTest
  module Concerns
    module Test
      extend Concern

      included do
        include Let
        include ChefServerTest::Concerns::TestConfig
        include ChefServerTest::ShellOut

        attr_reader :options

        let(:candidate_pkg_path)            { options[:candidate_pkg_path] }
        let(:normalized_candidate_pkg_path) { normalize_candidate_pkg_path!(candidate_pkg_path) }
      end

      def initialize(options = {})
        @options ||= options
      end

      def setup!(&blk)
        ensure_valid_package_name! candidate_pkg_path
        ChefServerTest::Tasks::Reset.execute! # TODO: Add --no-reset option
        yield if blk
        generate_test_config!(normalized_candidate_pkg_path)
      end
    end
  end
end
