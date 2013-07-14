btsync
======

Overview
--------

The btsync module allows you to easily manage btsync instances with Puppet.

Pre-requirement
---------------

You need a btsync package for one source (I use debian package from yeasoft).

    apt::source{'btsync':
      location          => 'http://debian.yeasoft.net/btsync',
      release           => 'wheezy',
      repos             => 'main contrib non-free',
      required_packages => 'debian-keyring debian-archive-keyring',
      key               => '6BF18B15',
      key_server        => 'pgp.mit.edu',
      include_src       => false,
    }


Usage
-----

Just include the `btsync` class:

    include btsync

Then declare an instance:

    btsync::instance { 'btsync':
      storage_path => '/home/btsync/.sync',
      webui        => {
        listen   => '0.0.0.0:8888',
        login    => 'btsync',
        password => 'password',
      }
    }

You can also do it in one step:

    class { 'btsync':
      instances => {
        btsync => {
          storage_path => '/home/btsync/.sync',
          webui        => {
            listen   => '0.0.0.0:8888',
            login    => 'btsync',
            password => 'password',
          }
        }
      }
    }

You can also store you configuration in hiera:

    ---
    btsync::instances:
      btsync:
        storage_path: /home/btsync/.sync
        webui:
          listen: 0.0.0.0:8888
          login: btsync
          password: password

And simply include the `btsync` class if you have puppet 3+:

    include btsync
