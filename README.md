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

Launching an instances
----------------------

Declare an instance:

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

Shared folders
--------------

You can also declare a shared folder:

    btsync::shared_folder { '/mnt/btsync':
      instance => 'btsync',
      secret   => 'MySecret',
    }

Or in in one step:

    class { 'btsync':
      instances => {
        btsync => {
          storage_path => '/home/btsync/.sync',
          webui        => {
            listen   => '0.0.0.0:8888',
            login    => 'btsync',
            password => 'password',
          },
          shared_folder => {
            /mnt/btsync => {
              secret => 'MySecret',
            }
          }
        }
      }
    }

And opf course in hiera:

    ---
    btsync::instances:
      btsync:
        storage_path: /home/btsync/.sync
        webui:
          listen: 0.0.0.0:8888
          login: btsync
          password: password
        shared_folder:
          /mnt/btsync:
            secret: MySecret

Reference
---------

Classes:

* [btsync](#class-btsync)

Resources:

* [btsync::instance](#resource-btsyncinstance)

###Class: btsync
This class is used to install btsync.

####`version`
The version of BitTorrent Sync to install/manage.

####`enable`
Should the service be enabled during boot time?

####`start`
Should the service be started by Puppet

####`instances`
Hash of instances to run

###Resource: btsync::instance
This resource is used to declare a btsync instance to run.

####`user`
A uid for supplying the user under which the btsync daemon should run. Defaults to resource name.

####`group`
A gid for supplying the group under which the btsync daemon should run. If omitted the daemon will run under the primary group of the user.

####`umask`
The umask for the btsync damon. If omitted the default umask is used.
