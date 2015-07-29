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

  file { $conffile:
    owner  => $user,
    group  => $group,
    mode   => '0400',
  }

  augeas_file { $conffile:
    lens => 'Json.lns',
    base => '/usr/share/doc/btsync-core/btsync.conf.sample',
  }

  Augeas {
    incl => $conffile,
    lens => 'Json.lns',
  }

  # Yeasoft's initscript header
  augeas { "btsync_${name}_json+DAEMON_UID":
    changes => "set // DAEMON_UID ${user}",
  }
  augeas { "btsync_${name}_json+DAEMON_GID":
    changes => "set // DAEMON_GID ${group}",
  }
  augeas { "btsync_${name}_json+DAEMON_UMASK":
    changes => "set // DAEMON_UMASK ${umask}",
  }

  # Global preferences
  if $device_name != undef {
    augeas { "btsync_${name}_json+device_name":
      changes => "set device_name ${device_name}",
    }
  }
  if $listening_port != undef {
    augeas { "btsync_${name}_json+listening_port":
      changes => "set listening_port ${listening_port}",
    }
  }
  if $storage_path != undef {
    augeas { "btsync_${name}_json+storage_path":
      changes => "set storage_path ${storage_path}",
    }
  }
  if $pid_file != undef {
    augeas { "btsync_${name}_json+pid_file":
      changes => "set pid_file ${pid_file}",
    }
  }
  if $check_for_updates != undef {
    augeas { "btsync_${name}_json+check_for_updates":
      changes => "set check_for_updates ${check_for_updates}",
    }
  }
  if $use_upnp != undef {
    augeas { "btsync_${name}_json+use_upnp":
      changes => "set use_upnp ${use_upnp}",
    }
  }
  if $download_limit != undef {
    augeas { "btsync_${name}_json+download_limit":
      changes => "set download_limit ${download_limit}",
    }
  }
  if $upload_limit != undef {
    augeas { "btsync_${name}_json+upload_limit":
      changes => "set upload_limit ${upload_limit}",
    }
  }

  # Web UI
  if has_key($webui, 'listen') {
    augeas { "btsync_${name}_json+webui/listen":
      changes => "set webui/listen ${webui['listen']}",
    }
    if has_key($webui, 'login') {
      augeas { "btsync_${name}_json+webui/login":
        changes => "set webui/login ${webui['login']}",
      }
    }
    augeas { "btsync_${name}_json+webui/password":
      changes => "set webui/password ${webui['password']}",
    }
    if has_key($webui, 'api_key') {
      augeas { "btsync_${name}_json+webui/api_key":
        changes => "set webui/api_key ${webui['api_key']}",
      }
    }
  }

  # Advanced Preferences
  if $disk_low_priority != undef {
    validate_bool($disk_low_priority)
    augeas { "btsync_${name}_json+disk_low_priority":
      changes => "set disk_low_priority ${disk_low_priority}",
    }
  }

  if $folder_rescan_interval != undef {
    if !is_integer($folder_rescan_interval) {
      fail 'folder_rescan_interval does not match integer'
    }
    augeas { "btsync_${name}_json+folder_rescan_interval":
      changes => "set folder_rescan_interval ${folder_rescan_interval}",
    }
  }

  if $lan_encrypt_data != undef {
    validate_bool($lan_encrypt_data)
    augeas { "btsync_${name}_json+lan_encrypt_data":
      changes => "set lan_encrypt_data ${lan_encrypt_data}",
    }
  }

  if $lan_use_tcp != undef {
    validate_bool($lan_use_tcp)
    augeas { "btsync_${name}_json+lan_use_tcp":
      changes => "set lan_use_tcp ${lan_use_tcp}",
    }
  }

  if $max_file_size_diff_for_patching != undef {
    if !is_integer($max_file_size_diff_for_patching) {
      fail 'max_file_size_diff_for_patching does not match integer'
    }
    augeas { "btsync_${name}_json+max_file_size_diff_for_patching":
      changes => "set max_file_size_diff_for_patching ${max_file_size_diff_for_patching}",
    }
  }

  if $max_file_size_for_versioning != undef {
    if !is_integer($max_file_size_for_versioning) {
      fail 'max_file_size_for_versioning does not match integer'
    }
    augeas { "btsync_${name}_json+max_file_size_for_versioning":
      changes => "set max_file_size_for_versioning ${max_file_size_for_versioning}",
    }
  }

  if $rate_limit_local_peers != undef {
    validate_bool($rate_limit_local_peers)
    augeas { "btsync_${name}_json+rate_limit_local_peers":
      changes => "set rate_limit_local_peers ${rate_limit_local_peers}",
    }
  }

  if $send_buf_size != undef {
    if !is_integer($send_buf_size) {
      fail 'send_buf_size does not match integer'
    }
    augeas { "btsync_${name}_json+send_buf_size":
      changes => "set send_buf_size ${send_buf_size}",
    }
  }

  if $recv_buf_size != undef {
    if !is_integer($recv_buf_size) {
      fail 'recv_buf_size does not match integer'
    }
    augeas { "btsync_${name}_json+recv_buf_size":
      changes => "set recv_buf_size ${recv_buf_size}",
    }
  }

  if $sync_max_time_diff != undef {
    if !is_integer($sync_max_time_diff) {
      fail 'sync_max_time_diff does not match integer'
    }
    augeas { "btsync_${name}_json+sync_max_time_diff":
      changes => "set sync_max_time_diff ${sync_max_time_diff}",
    }
  }

  if $sync_trash_ttl != undef {
    if !is_integer($sync_trash_ttl) {
      fail 'sync_trash_ttl does not match integer'
    }
    augeas { "btsync_${name}_json+sync_trash_ttl":
      changes => "set sync_trash_ttl ${sync_trash_ttl}",
    }
  }

  create_resources(
    btsync::shared_folder,
    $shared_folders,
    { instance => $name })

}
