require 'chef-server-test/shell_out'

module ChefServerTest
  module Tasks
    class Reset
      extend ChefServerTest::ShellOut

      def self.execute!
        shell_out 'rm -fr nodes/ clients/'
        shell_out 'vagrant destroy -f', cwd: File.join(BASE_DIR, 'vms')
      end

    end
  end
end

