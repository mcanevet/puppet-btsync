BitTorrent Sync
===============

Overview
--------

The btsync module allows you to easily manage BitTorrent Sync instances with Puppet.

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

####`conffile`
Override default configuration file. Defaults to /etc/btsync/$name.conf

####`device_name`
Public name of the device. Defaults to $name.

####`listening_port`
Port the daemon listen to. Defaults to 0 (random port).

####`storage_path`
storage_path dir contains auxilliary app files if no storage_path field: .sync dir created in the directory where binary is located.

####`pid_file`
Override location of pid file.

####`check_for_updates`
Whether or not check for updates. Defaults to `false`.

####`use_upnp`
Whether or not use UPnP for port mapping. Defaults to `true`.

####`download_limit`
Download limit in kB/s. `0` means no limit. Defaults to `0`.

####`upload_limit`
Upload limit in kB/s. `0` means no limit. Defauls to `0`.

####`webui`
Hash containing web user interface configuration.

####`webui['listen']`
Address and port to listen to.

####`webui['login']`
Web ui login.

####`webui['password']`
Web ui password.

####`shared_folders`
Hash containing shared folders resources.

####`disk_low_priority`
Sets priority for the file operations on disc. If set to `false`, Sync will perform read and write file operations with	the highest speed and priority which can result in degradation of performance for othe applications.

####`lan_encrypt_data`
If set to `true`, will use encryption in the local network.

####`lan_use_tcp`
If set to `true`, Sync will use TCP instead of UDP in local network.
Note: disabling	encryption and using TCP in LAN can increase speed ofsync on low-end devices due to lower use of CPU.

####`rate_limit_local_peers`
Applies speed limits to the peers in local network. By default the limits are not applied in LAN.

TODO
----

* Unit tests
* Finish documentation
