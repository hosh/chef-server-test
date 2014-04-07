require 'chef-server-test/package_info'
require 'chef-server-test/config'

require 'chef-server-test/tasks/reset'

module ChefServerTest
  module Concerns
    module TestConfig
      def ensure_base_path!
        ChefServerTest::Config.with_base_path(BASE_DIR) unless ChefServerTest::Config.base_path
      end

      def generate_test_config!(pkg_path)
        ensure_base_path!
        ChefServerTest::Config.
          with_candidate_pkg(pkg_path).
          generate_data_bag!
      end
    end
  end
end
