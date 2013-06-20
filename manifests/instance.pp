define btsync::instance(
  $device_name = $name,
  $listening_port = 0,
  $storage_path = '/var/lib/btsync',
  $check_for_updates = false,
  $use_upnp = true,
  $download_limit = 0,
  $upload_limit = 0,
  $webui = {
    listen   => '0.0.0.0:8888',
    login    => undef,
    password => undef,
  },
  $user = undef,
) {

  validate_absolute_path($storage_path)

  $instance_name = $user ? {
    undef   => $name,
    default => "${name}.${user}",
  }

  $owner = $user ? {
    undef   => 'root',
    default => $user,
  }

  $group = $user ? {
    undef   => 'root',
    default => $user,
  }

  file{"/etc/btsync/${instance_name}.conf":
    owner   => $owner,
    group   => $group,
    mode    => '0400',
    content => template('btsync/instance.erb'),
  }
}
