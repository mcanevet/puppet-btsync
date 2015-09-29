BitTorrent Sync
===============

[![Build Status](https://travis-ci.org/mcanevet/puppet-btsync.png?branch=master)](https://travis-ci.org/mcanevet/puppet-btsync)

Overview
--------

The btsync module allows you to easily manage BitTorrent Sync instances with Puppet.

Pre-requirement
---------------

If you don't already have a btsync package repository, you can include btsync::repo class, that will configure yeasoft repository for Debian and Ubuntu:

```puppet
include btsync::repo
```


Usage
-----

Just include the `btsync` class:

```puppet
include btsync
```

Launching an instances
----------------------

Declare an instance:

```puppet
btsync::instance { 'user':
  storage_path => '/home/user/.sync',
  webui        => {
    listen   => '0.0.0.0:8888',
    login    => 'admin',
    password => 'password',
  }
}
```

You can also do it in one step:

```puppet
class { 'btsync':
  instances => {
    user => {
      storage_path => '/home/user/.sync',
      webui        => {
        listen   => '0.0.0.0:8888',
        login    => 'admin',
        password => 'password',
      }
    }
  }
}
```

You can also store you configuration in hiera:

```yaml
---
btsync::instances:
  user:
    storage_path: /home/user/.sync
    webui:
      listen: 0.0.0.0:8888
      login: admin
      password: password
```

And simply include the `btsync` class if you have puppet 3+:

```puppet
include btsync
```

Shared folders
--------------

You can also declare a shared folder:

```puppet
btsync::shared_folder { 'MY_SECRET_1':
  instance => 'user',
  dir      => '/home/user/bittorrent/sync_test',
}
```

Or in in one step:

```puppet
class { 'btsync':
  instances => {
    user => {
      storage_path => '/home/user/.sync',
      webui        => {
        listen   => '0.0.0.0:8888',
        login    => 'admin',
        password => 'password',
      },
      shared_folders => {
        'MY_SECRET_1' => {
          dir => '/home/user/bittorrent/sync_test',
        }
      }
    }
  }
}
```

And of course in hiera:

```yaml
---
btsync::instances:
  user:
    storage_path: /home/user/.sync
    webui:
      listen: 0.0.0.0:8888
      login: admin
      password: password
    shared_folders:
      MY_SECRET_1:
        dir: /home/user/bittorrent/sync_test
```

Known hosts:
------------

A Btsync::Known_host resource is automatically exported for the given secret key, and every Btsync::Known_host resources matching the given secret key are automatically realized.

You can also declare explicitely a known host resource for a given secret key:

```puppet
btsync::known_host { '192.168.1.2:44444':
  secret   => 'MY_SECRET_1',
  instance => 'btsync',
}
```

Or in one step:

```puppet
class { 'btsync':
  instances => {
    user => {
      storage_path => '/home/user/.sync',
      webui        => {
        listen   => '0.0.0.0:8888',
        login    => 'admin',
        password => 'password',
      },
      shared_folders => {
        'MY_SECRET_1' => {
          dir         => '/home/user/bittorrent/sync_test',
          known_hosts => ['192.168.1.2:44444'],
        }
      }
    }
  }
}
```

Or with hiera:

```yaml
---
btsync::instances:
  user:
    storage_path: /home/user/.sync
    webui:
      listen: 0.0.0.0:8888
      login: admin
      password: password
    shared_folders:
      MY_SECRET_1:
        dir: /home/user/bittorrent/sync_test
        known_hosts: ['192.168.1.2:44444']
```

The define also supports composite namevars in order to easily specify the
entry you want to manage. The format for composite namevars is:

```puppet
<secret> on <host>
```

Example:

```puppet
btsync::known_host { 'my known host':
  secret => 'MY_SECRET_1',
  host   => '192.168.1.2:44444',
}
```

equals to

```puppet
btsync::known_host { 'MY_SECRET_1 on 192.168.1.2:44444': }
```

or with an array:

```puppet
btsync::known_host { prefix(['192.168.1.2:44444'], 'MY_SECRET_1 on '): }
```

This example configures an instance like the sample configuration of BitTorrent Sync 1.1.48:

```yaml
---
btsync::instances:
  user:
    device_name: My Sync Device
    listening_port: 0
    storage_path: /home/user/.sync
    check_for_updates: true
    use_upnp: true
    download_limit: 0
    upload_limit: 0
    webui:
      listen: 0.0.0.0:8888
      login: admin
      password: password
    shared_folders:
      MY_SECRET_1:
        dir: /home/user/bittorrent/sync_test
        use_relay_server: true
        use_tracker: true
        use_dht: true
        search_lan: true
        use_sync_trash: true
        known_hosts: ['192.168.1.2:44444']
```

Reference
---------

Classes:

* [btsync](#class-btsync)
* [btsync::config](#class-btsyncconfig)
* [btsync::install](#class-btsyncinstall)
* [btsync::repo](#class-btsyncrepo)
* [btsync::service](#class-btsyncservice)

Resources:

* [btsync::instance](#resource-btsyncinstance)
* [btsync::shared_folder](#resource-btsyncshared_folder)
* [btsync::known_host](#resource-btsyncknown_host)

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

###Class: btsync::config
Configure btsync.
You should not declare this class explicitely, it should be done by btsync class.

###Class: btsync::install
Install btsync.
You should not declare this class explicitely, it should be done by btsync class.

###Class: btsync::repo
Configure yeasoft repository for Debian or Ubuntu.

###Class: btsync::service
Manage btsync service. 
You should not declare this class explicitely, it should be done by btsync class.

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
storage_path dir contains auxiliary app files if no storage_path field: .sync dir created in the directory where binary is located.

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

####`webui['api_key']`
Web ui API Key (Beta)

####`shared_folders`
Hash containing shared folders resources.

####`disk_low_priority`
Sets priority for the file operations on disc. If set to `false`, Sync will perform read and write file operations with	the highest speed and priority which can result in degradation of performance for othe applications.

####`folder_rescan_interval`
Sets a time interval in seconds for rescanning sync folders.
This serves as an additional measure for detecting changes in file system.

####`lan_encrypt_data`
If set to `true`, will use encryption in the local network.

####`lan_use_tcp`
If set to `true`, Sync will use TCP instead of UDP in local network.
Note: disabling	encryption and using TCP in LAN can increase speed ofsync on low-end devices due to lower use of CPU.

####`max_file_size_diff_for_patching`
Determines a size difference in MB between versions of one file for patching. When it is reached or exceeded, the file will be updated by downloading missing chunks of information (patches). Updates for a file with a smaller size difference will be downloaded as separate files.

####`max_file_size_for_versioning`
Determines maximum file size in MB for creating file versions. When this size is exceeded, versions will not be created to save space on disk.

####`rate_limit_local_peers`
Applies speed limits to the peers in local network. By default the limits are not applied in LAN.

####`send_buf_size`
Amount of real memory that will be used for cached send operations. This value can be set in the range from 1 to 100 MB.

####`recv_buf_size`
Amount of real memory that will be used for cached receive operations. This value can be set in the range from 1 to 100 MB.

####`sync_max_time_diff`
Shows maximum allowed time in seconds difference between devices. If the difference exceeds this limit, the devices will not be synced as it may result in incorrect tracing of file changes.

####`sync_trash_ttl`
Sets the number of days after reaching which files will be automatically deleted from the .SyncArchive folder.

###Resource: btsync::shared_folder
This resource is used to declare a btsync shared folder for an instance.

####`instance`
Name of the instance sharing this folder.

####`dir`
Directory to share.

####`secret`
Shared secret. Defaults to resource name.

####`use_relay_server`
Whether or not use relay server when direct connection fails. Defaults to `true`.

####`use_tracker`
Can be enabled to facilitate communication between peers.

####`use_dht`

####`search_lan`

####`use_sync_trash`
Whether or not save all the files deleted on other clients to the hidden '.SyncArchive' within your destination folder. The files deleted on your computer are moved to system Trash (depending on OS preferences).

####`known_hosts`
An array containing the ip:port or host:port of known clients. So if one of your devices has a static and accessible IP, peers can connect to it directly.

###Resource: btsync::known_host
Add a known host to the list of known hosts of a shared folder.

####`secret`
The secret of the shared folder.

####`instance`
The instance to use. Defaults to the instance of the shared folder of the secret passed as parameter.

####`host`
The host to add. Defaults to namevar.

TODO
----

* Finish unit tests
