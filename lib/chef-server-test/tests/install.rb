require 'chef-server-test/concerns/test'

module ChefServerTest
  module Tests
    class Install
      include ChefServerTest::Concerns::Test

      def execute!
        setup!
        puts "Running install test on: #{normalized_candidate_pkg_path}"
        chef_client 'tests::install'
      end
    end
  end
end
