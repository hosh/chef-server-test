require 'rlet'

module ChefServerTest
  class FilenamePackageInfo
    include Let

    attr_reader :package_name

    # Sample package name:
    # chef-server_11.0.8+20140213205408.git.96.207d16a-1.ubuntu.10.04_amd64.deb

    let(:matcher)    { /^chef-server[-_](\d+\.\d+\.\d+).*(ubuntu\.\d+\.\d+|el\d+)[._](\S+)\.(deb|rpm)$/ }
    let(:match_data) { matcher.match(package_name)  }

    let(:version)       { match_data[1] }
    let(:platform_info) { match_data[2] }
    let(:arch)          { match_data[3] }
    let(:package_type)  { match_data[4] }

    let(:platform)         { /(ubuntu|el)/.match(platform_info)[1] }
    let(:platform_version) { /(ubuntu\.|el)([0-9.]+)/.match(platform_info)[2] }

    let(:valid?) { !match_data.nil? and (platform == 'ubuntu' && package_type == 'deb') || (platform == 'el' && package_type == 'rpm') }

    let(:to_hash) do
      {
        'version'          => version,
        'platform'         => platform,
        'platform_version' => platform_version,
        'platform_info'    => platform_info,
        'arch'             => arch
      }
    end

    def initialize(package_name)
      @package_name = package_name
    end
  end

  class MetadataPackageInfo
    include Let

    attr_reader :metadata_path, :package_name

    # Sample
    # {
    #   "platform": "ubuntu",
    #   "platform_version": "12.04",
    #   "arch": "x86_64",
    #   "version": "11.1.0-alpha.1+20140403222611.git.7.d52248b"
    # }

    let(:raw_json)   { File.read(metadata_path) }
    let(:metadata)   { JSON.parse(raw_json) }

    let(:version)          { metadata['version'] }
    let(:platform)         { metadata['platform'] }
    let(:platform_version) { metadata['platform_version'] }
    let(:arch)             { metadata['arch'] }
    let(:platform_info)    { "#{platform}.#{platform_version}" }

    let(:to_hash) do
      {
        'version'          => version,
        'platform'         => platform,
        'platform_version' => platform_version,
        'platform_info'    => platform_info,
        'arch'             => arch
      }
    end

    def initialize(metadata_path, package_name)
      @metadata_path = metadata_path
      @package_name = package_name
    end
  end
end
