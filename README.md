# chef-server-test

## Overview

This project uses chef-metal to stand up VMs for testing OSC omnibus packages. It will
currently test installs and upgrades. There are a lot of room for improvements.

## Installing

Make sure you have:

  - Vagrant 1.3+
  - Ruby 1.9.3+

Clone the project, then run bundle install

````
git clone git://github.com/hosh/chef-server-test.git
cd chef-server-test
git submodule init
git submodule update
bundle install
````

## Testing

To run an install test:

````
bin/validate install chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb
````

To run an upgrade test

````
bin/validate upgrade chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb
````

To run an upgrade test against an older release
````
bin/validate upgrade chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb --upgrade-from=11.0.6
````

To run an upgrade test against all releases
````
bin/validate upgrade chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb --upgrade-from=all
````

To run both an install and upgrade
````
bin/validate all chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb
````

To run a converge test
````
bin/validate all chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb
````

The "all" tests can also take an ````---upgrade-from```` option:
````
bin/validate all chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb --upgrade-from=all
````

## Testing ipv6

You can test in ipv6 mode. First, you need to set up an ipv6 interface on your box:

```
sudo bin/validate ipv6
```

Important: If you are running this in OSX, you will want to plug the ethernet into a switch. For whatever
reason, some versions of OSX becomes unstable running in ipv6 mode against the wireless interface.

Once you have done this, you can run the tests with the ```--ipv6``` flag. For example, to run the
converge test in ipv6 mode,

````
bin/validate all chef-server_11.0.8+20140224180558.git.102.d79b820-1.ubuntu.12.04_amd64.deb --ipv6
````

## Logging

Results of all tests are created in a timestamped directory in cache/, and sorted by platform, platform version
and test type.

## TODO

  - Automatic rsync of packages. You should be able to specify an arbitrary path to candidate package and
    have the system automatically copy the package over.

  - Set up a log/ symbolic link pointing to the latest run. This way, you don't have to manually look for it.

  - Add global option -l to pass in the log timestamp you want. This would allow CI to drive the directory it
    wants. Alternatively, make it an arbitrary path on the host machine, and have this system mount it. (This
    might not work so well on EC2/Dreamhost VMs).

  - Additional cleanup tasks to clean up the cache

  - Add a test summary into the log, so you know which platform/platform-version failed

  - Add arbitrary numbers of candidate packages for the 'all' test.

  - Version-lock chef-metal. Possibly by invoking ````chef-client```` through ````bundle exec```

  - Add parallelization (dependent on chef-metal)

  - Add other tests like ipv6 and convergance tests (stand up a chef-server, stand up a different node that
    converges against that chef-server)
