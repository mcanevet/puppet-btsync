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
    api_key  => undef,
  },
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

  Class['btsync::install'] ->
  Btsync::Instance[$title] ~>
  Class['btsync::service']

  validate_absolute_path($conffile)

  if $storage_path != undef {
    validate_absolute_path($storage_path)
  }

  concat_build { "btsync_${name}": }
  ->
  file { $conffile:
    owner  => $user,
    group  => $group,
    mode   => '0400',
    source => concat_output("btsync_${name}"),
  }

  concat_fragment { "btsync_${name}+01":
    content => template('btsync/yeasoft_initscript_header.erb'),
  }

  concat_fragment { "btsync_${name}+02":
    content => '{',
  }

  concat_build { "btsync_${name}_json":
    parent_build   => "btsync_${name}",
    target         => "${::puppet_vardir}/concat/fragments/btsync_${name}/03",
    file_delimiter => ',',
    append_newline => false,
  }

  concat_fragment { "btsync_${name}_json+01":
    content => template('btsync/global_preferences.erb'),
  }

  concat_fragment { "btsync_${name}_json+02":
    content => template('btsync/webui.erb'),
  }

  # Advanced Preferences
  if $disk_low_priority != undef {
    validate_bool($disk_low_priority)
    concat_fragment { "btsync_${name}_json+disk_low_priority":
      content => "
  \"disk_low_priority\": ${disk_low_priority}",
    }
  }

  if $folder_rescan_interval != undef {
    validate_re($folder_rescan_interval, '\d+')
    concat_fragment { "btsync_${name}_json+folder_rescan_interval":
      content => "
  \"folder_rescan_interval\": ${folder_rescan_interval}",
    }
  }

  if $lan_encrypt_data != undef {
    validate_bool($lan_encrypt_data)
    concat_fragment { "btsync_${name}_json+lan_encrypt_data":
      content => "
  \"lan_encrypt_data\": ${lan_encrypt_data}",
    }
  }

  if $lan_use_tcp != undef {
    validate_bool($lan_use_tcp)
    concat_fragment { "btsync_${name}_json+lan_use_tcp":
      content => "
  \"lan_use_tcp\": ${lan_use_tcp}",
    }
  }

  if $max_file_size_diff_for_patching != undef {
    validate_re($max_file_size_diff_for_patching, '\d+')
    concat_fragment { "btsync_${name}_json+max_file_size_diff_for_patching":
      content => "
  \"max_file_size_diff_for_patching\": ${max_file_size_diff_for_patching}",
    }
  }

  if $max_file_size_for_versioning != undef {
    validate_re($max_file_size_for_versioning, '\d+')
    concat_fragment { "btsync_${name}_json+max_file_size_for_versioning":
      content => "
  \"max_file_size_for_versioning\": ${max_file_size_for_versioning}",
    }
  }

  if $rate_limit_local_peers != undef {
    validate_bool($rate_limit_local_peers)
    concat_fragment { "btsync_${name}_json+rate_limit_local_peers":
      content => "
  \"rate_limit_local_peers\": ${rate_limit_local_peers}",
    }
  }

  if $send_buf_size != undef {
    validate_re($send_buf_size, '\d+')
    concat_fragment { "btsync_${name}_json+send_buf_size":
      content => "
  \"send_buf_size\": ${send_buf_size}",
    }
  }

  if $recv_buf_size != undef {
    validate_re($recv_buf_size, '\d+')
    concat_fragment { "btsync_${name}_json+recv_buf_size":
      content => "
  \"recv_buf_size\": ${recv_buf_size}",
    }
  }

  if $sync_max_time_diff != undef {
    validate_re($sync_max_time_diff, '\d+')
    concat_fragment { "btsync_${name}_json+sync_max_time_diff":
      content => "
  \"sync_max_time_diff\": ${sync_max_time_diff}",
    }
  }

  if $sync_trash_ttl != undef {
    validate_re($sync_trash_ttl, '\d+')
    concat_fragment { "btsync_${name}_json+sync_trash_ttl":
      content => "
  \"sync_trash_ttl\": ${sync_trash_ttl}",
    }
  }

  concat_fragment { "btsync_${name}+99":
    content => '}',
  }

  create_resources(
    btsync::shared_folder,
    $shared_folders,
    { instance => $name })

}
