require 'chef-server-test/concerns/test'

module ChefServerTest
  module Tests
    class Converge
      include ChefServerTest::Concerns::Test

      def execute!
        setup!
        puts "Running converge test on: #{candidate_pkg_path}"
        puts "Cached to #{cached_pkg_path}"
        chef_client 'tests::converge'
      end
    end
  end
end
