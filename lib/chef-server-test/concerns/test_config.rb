require 'chef-server-test/package_info'
require 'chef-server-test/config'

require 'chef-server-test/tasks/reset'

module ChefServerTest
  module Concerns
    module TestConfig
      def ensure_base_path!
        ChefServerTest::Config.with_base_path(BASE_DIR) unless ChefServerTest::Config.base_path
      end

      def ensure_valid_package_name!(_pkg)
        package_info = ChefServerTest::PackageInfo.new(File.basename(_pkg))
        return package_info if package_info.valid?

        $stderr.puts "Error: #{_pkg} does not have valid filename format"
        exit 2
      end

      def generate_test_config!(candidate_pkg_path)
        ensure_base_path!
        ChefServerTest::Config.
          with_candidate_pkg(candidate_pkg_path).
          generate_data_bag!
      end

      # TODO: if the absolute path is outside the cache dir, then rsync it over
      def normalize_candidate_pkg_path!(path)
        ensure_base_path!
        normalized_path = ChefServerTest::Config.normalize_candidate_pkg(path)
        unless normalized_path
          $stderr.puts "Error: Unable to find candidate package at #{normalized_path}"
          exit 1
        end
        return normalized_path
      end
    end
  end
end
