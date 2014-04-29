require 'rlet'
require 'chef-server-test/shell_out'

module ChefServerTest
  module Tasks
    class HostIPv6
      include Let
      include ChefServerTest::ShellOut

      attr_reader :options

      let(:interface)           { ChefServerTest::Config.host_ipv6_interface }
      let(:requested_interface) { options[:interface] }
      let(:host_addr)           { "#{ChefServerTest::Config.host_ipv6_address}/64" }
      let(:host_osx?)           { /darwin/ =~ RUBY_PLATFORM }

      def execute!
        info!
        # Override from command line
        # TODO: Put this into a recipe. We are already using a hostfile recipe anyways
        ChefServerTest::Config.host_ipv6_interface requested_interface if requested_interface
        if host_osx?
          sudo "ifconfig #{interface} inet6 #{host_addr} delete || true"
          sudo "ifconfig #{interface} inet6 #{host_addr} || true"
        else
          sudo "/sbin/ip -6 addr del #{host_addr} dev '#{interface}' || true"
          sudo "/sbin/ip -6 addr add #{host_addr} dev '#{interface}' || true"
        end

        chef_client 'setup::hostfile'
      end

      def info!
        puts "Attempting to (re)assign ip address #{host_addr} to #{interface} on HOST machine to allow it to talk to guests over ipv6"
      end

      def initialize(_options = {})
        @options = _options
      end

    end
  end
end

