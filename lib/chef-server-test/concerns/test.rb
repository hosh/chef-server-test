require 'rlet'
require 'chef-server-test/concerns/test_config'
require 'chef-server-test/tasks/cache-package'
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

        let(:candidate_pkg_path) { options[:candidate_pkg_path] }
        let(:cached_pkg_path)    { ChefServerTest::Config.cached_candidate_pkg }
      end

      def initialize(options = {})
        @options ||= options
      end

      def setup!(&blk)
        ChefServerTest::Tasks::Reset.execute! # TODO: Add --no-reset option
        ChefServerTest::Tasks::CachePackage.new(candidate_pkg_path).execute!
        yield if blk
        generate_test_config!(cached_pkg_path)
      end
    end
  end
end
