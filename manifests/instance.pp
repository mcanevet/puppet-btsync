# == Define: btsync::instance
#
# Launch btsync daemon with resource parameters. See README.md for more details.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
define btsync::instance(
  $user = $name,
  $group = btsync,
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
  $webui = {},
  $shared_folders = {},
  $disk_low_priority = undef,
  $folder_rescan_interval = undef,
  $lan_encrypt_data = undef,
  $lan_use_tcp = undef,
  $max_file_size_diff_for_patching = undef,
  $max_file_size_for_versioning = undef,
  $rate_limit_local_peers = undef,
  $send_buf_size = undef,
  $recv_buf_size = undef,
  $sync_max_time_diff = undef,
  $sync_trash_ttl = undef,
) {

  Class['btsync::install']
  -> Btsync::Instance[$title]
  ~> Class['btsync::service']

  validate_absolute_path($conffile)

  if $storage_path != undef {
    validate_absolute_path($storage_path)
  }

  concat {"btsync_${name}":
    path  => $conffile,
    owner => $user,
    group => $group,
    mode  => '0400',
  }

  concat::fragment {"btsync_${name}_json_global":
    order   => '03',
    target  => "btsync_${name}",
    content => template('btsync/global_preferences.erb'),
  }

  if !empty($webui) {
    concat::fragment {"btsync_${name}_json_webui":
      order   => '04',
      target  => "btsync_${name}",
      content => template('btsync/webui.erb'),
    }
  }

  concat::fragment { "btsync_${name}_shared_folder_header":
    order   => '10',
    target  => "btsync_${name}",
    content => '
  "shared_folders":
  [
',
  }

  concat::fragment { "btsync_${name}+99":
    order   => '99',
    target  => "btsync_${name}",
    content => template('btsync/advanced_options.erb'),
  }

  create_resources(
    btsync::shared_folder,
    $shared_folders,
    {
      instance => $name
    }
  )

}
