require 'chef/util/file_edit'

BASE_DIR = ENV['PWD']
CACHE_DIR = File.join(BASE_DIR, 'cache')

releases = %w(11.0.4 11.0.6 11.0.8 11.0.10)

platforms = { ubuntu: %w(10.04 11.04 12.04),
              el:     %w(5 6) }

package_urls = platforms.map do |platform, platform_versions|
  platform_versions.map do |platform_version|
    releases.map do |version|
      Setup::OmnitruckClient.new(platform:         platform,
                                 platform_version: platform_version).
                                 package_for_version(version, false, false)
    end
  end
end.flatten

Chef::Log.info(package_urls.inspect)

package_urls.each do |package_url|
  package_name = ::File.basename(package_url)
  remote_file File.join(CACHE_DIR, 'releases', package_name) do
    source package_url
    action :create_if_missing
  end
end
