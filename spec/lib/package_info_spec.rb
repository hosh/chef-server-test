require 'spec_helper'
require 'chef-server-test/package_info'

describe ChefServerTest::PackageInfo do
  subject { ChefServerTest::PackageInfo.new(package_name) }

  def self.with_package_name(_package_name, &_examples)
    context "with #{_package_name}" do
      let(:package_name) { _package_name }
      instance_eval(&_examples)
    end
  end

  def self.should_be_invalid(_package_name)
    with_package_name(_package_name) do
      it { should_not be_valid }
    end
  end

  with_package_name  'chef-server_11.0.4-1.ubuntu.10.04_amd64.deb' do
    its(:package_name)     { should eql package_name }
    its(:platform)         { should eql 'ubuntu' }
    its(:platform_version) { should eql '10.04' }
    its(:version)          { should eql '11.0.4' }
    its(:arch)             { should eql 'amd64' }

    it { should be_valid }
  end

  with_package_name 'chef-server_11.0.8-1.ubuntu.12.04_amd64.deb' do
    its(:package_name)     { should eql package_name }
    its(:platform)         { should eql 'ubuntu' }
    its(:platform_version) { should eql '12.04' }
    its(:version)          { should eql '11.0.8' }
    its(:arch)             { should eql 'amd64' }

    it { should be_valid }
  end

  with_package_name 'chef-server-11.0.10-1.el5.x86_64.rpm' do
    its(:package_name)     { should eql package_name }
    its(:platform)         { should eql 'el' }
    its(:platform_version) { should eql '5' }
    its(:version)          { should eql '11.0.10' }
    its(:arch)             { should eql 'x86_64' }

    it { should be_valid }
  end

  with_package_name 'chef-server-11.0.8-1.el6.x86_64.rpm' do
    its(:package_name)     { should eql package_name }
    its(:platform)         { should eql 'el' }
    its(:platform_version) { should eql '6' }
    its(:version)          { should eql '11.0.8' }
    its(:arch)             { should eql 'x86_64' }

    it { should be_valid }
  end

  with_package_name 'chef-server_11.0.8+20140213205408.git.96.207d16a-1.ubuntu.10.04_amd64.deb' do
    its(:package_name)     { should eql package_name }
    its(:platform)         { should eql 'ubuntu' }
    its(:platform_version) { should eql '10.04' }
    its(:version)          { should eql '11.0.8' }
    its(:arch)             { should eql 'amd64' }

    it { should be_valid }
  end

  should_be_invalid 'chef-server_11.0.4-1.ubuntu.10.04_amd64.rpm'
  should_be_invalid 'chef-server-11.0.10-1.el5.x86_64.deb'
  should_be_invalid 'chef-server11.0.4-1.ubuntu.10.04_amd64.deb'
  should_be_invalid 'chef-server-11.0.10-1.bad-el5.x86_64.deb'
  should_be_invalid 'chef-11.10.4-1.el5.i686.rpm' # In case you try to test the client
  should_be_invalid 'blah.deb'
  should_be_invalid 'blah.rpm'
end
