btsync
======

Overview
--------

The btsync module allows you to easily manage btsync instances with Puppet.

Pre-requirement
---------------

If you don't already have a btsync package repository, you can include btsync::repo class, that will configure yeasoft repository for Debian and Ubuntu:

    include btsync::repo


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

Todo
----

Support Shared Folders.
