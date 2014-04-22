require 'rlet'
require 'chef-server-test/shell_out'
require 'chef-server-test/package_info'
require 'chef-server-test/concerns/test_config'

module ChefServerTest
  module Tasks
    class CachePackage
      include Let
      include ChefServerTest::Concerns::TestConfig
      include ChefServerTest::ShellOut

      attr_reader :package_path

      let(:cache_path)           { ChefServerTest::Config.cache_path }
      let(:package_cache_dir)    { File.join cache_path, 'pkgs' }
      let(:cached_package_path)  { File.join package_cache_dir, full_package_name }
      let(:cached_metadata_path) { File.join package_cache_dir, platform_dir, metadata_basename }
      let(:platform_dir)         { File.join package_platform, package_platform_version }
      let(:full_package_name)    { File.join platform_dir, package_basename }

      let(:metadata_path)           { File.exists?(default_metadata_path) ? default_metadata_path : extracted_metadata_path }
      let(:default_metadata_path)   { "#{package_path}.metadata.json" }
      let(:package_basename)        { File.basename package_path }
      let(:metadata_basename)       { File.basename default_metadata_path }

      let(:package_info)            { filename_package_info.valid? ? filename_package_info : metadata_package_info }
      let(:filename_package_info)   { ChefServerTest::FilenamePackageInfo.new(package_basename) }
      let(:metadata_package_info)   { ChefServerTest::MetadataPackageInfo.new(metadata_path, package_basename) }
      let(:extracted_metadata_path) { extract_metadata!; temp_metadata_path }
      let(:temp_metadata_path)      { "/tmp/#{metadata_basename}" }

      let(:package_platform)         { package_info.platform }
      let(:package_platform_version) { package_info.platform_version }

      def execute!
        ensure_base_path!
        # TODO: Check and make sure we are not using the same cached path
        shell_out "mkdir -p #{package_cache_dir}/#{platform_dir}"
        shell_out "rsync -v #{package_path} #{cached_package_path}",   live_stream: STDOUT
        shell_out "rsync -v #{metadata_path} #{cached_metadata_path}", live_stream: STDOUT

        # Set the config so we know where the cached packages are
        ChefServerTest::Config.cached_candidate_pkg cached_package_path
        ChefServerTest::Config.cached_candidate_pkg_info package_info
        ChefServerTest::Config.full_package_name full_package_name
      end

      # This takes relatively long, so we try to do this as a last resort.
      # TODO: Guard this so only debs are extracted
      def extract_metadata!
        shell_out "tar zOxf #{package_path} data.tar.gz | tar zOxf - ./opt/chef-server/version-manifest.json > #{temp_metadata_path}"
      end

      def initialize(_package_path)
        @package_path = _package_path
      end

    end
  end
end
