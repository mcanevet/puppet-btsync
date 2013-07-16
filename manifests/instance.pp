# == Define: btsync::instance
#
# Launch btsync daemon with resource parameters.
#
# === Parameters
#
# [*user*]
#   A uid for supplying the user under which the btsync daemon should run
#   Defaults to $name.
#
# [*group*]
#   A gid for supplying the group under which the btsync daemon should run.
#   If omitted the daemon will run under the primary group of the user.
#
# [*umask*]
#   The umask for the btsync damon. If omitted the default umask is used.
#
# [*conffile*]
#   Override default configuration file. Defaults to /etc/btsync/$name.conf
#
# [*device_name*]
#   Public name of the device. Defaults to $name.
#
# [*listening_port*]
#   Port the daemon listen to. Defaults to 0 (random port).
#
# [*storage_path*]
#   storage_path dir contains auxilliary app files if no storage_path field:
#   .sync dir created in the directory where binary is located.
#
# [*pid_file*]
#   Override location of pid file.
#
# [*check_for_updates*]
#   Whether or not check for updates. Defaults to false.
#
# [*use_upnp*]
#   Whether or not use UPnP for port mapping. Defaults to true.
#
# [*download_limit*]
#   Download limit in kB/s. 0 means no limit. Defaults to 0.
#
# [*upload_limit*]
#   Upload limit in kB/s. 0 means no limit. Defauls to 0.
#
define btsync::instance(
  $user = $name,
  $group = undef,
  $umask = undef,
  $conffile = "/etc/btsync/${name}.conf",

  $device_name = $name,
  $listening_port = 0,
  $storage_path = undef,
  $pid_file = undef,
  $check_for_updates = false,
  $use_upnp = true,
  $download_limit = 0,
  $upload_limit = 0,
  $webui = {
    listen   => undef,
    login    => undef,
    password => undef,
  },
  $shared_folders = {},
  $disk_low_priority = undef,
  $lan_encrypt_data = undef,
  $lan_use_tcp = undef,
  $rate_limit_local_peers = undef,
) {

  validate_absolute_path($conffile)
  validate_absolute_path($storage_path)

  concat_build { "instance_${name}":
    order  => ['*.tmp'],
  }

  concat_fragment { "instance_${name}+01.tmp":
    content => template('btsync/global.erb'),
  }

  concat_fragment { "instance_${name}+99.tmp":
    content => '  ]
}',
  }

  concat_build { "instance_${name}_shared_folders":
    parent_build   => "instance_${name}",
    target         => "/var/lib/puppet/concat/fragments/instance_${name}/04.tmp",
    file_delimiter => ',',
    append_newline => false,
  }

  file { $conffile:
    owner  => $user,
    group  => $group,
    mode   => '0400',
    source => concat_output("instance_${name}"),
  }

  Btsync::Shared_folder{
    instance => $name,
  }
  create_resources(btsync::shared_folder, $shared_folders)

}
