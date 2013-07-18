# == Define: btsync::shared_folder
#
#   Configure a shared folder
#
define btsync::shared_folder(
  $instance,
  $secret,
  $dir = $name,
  $use_relay_server = true,
  $use_tracker = true,
  $use_dht = true,
  $search_lan = true,
  $use_sync_trash = true,
  $known_hosts = [],
) {
  $shared_folder = regsubst($name, '/', '_', 'G')
  validate_array($known_hosts)
  concat_fragment { "instance_${instance}_shared_folders+${shared_folder}":
    content => template('btsync/shared_folder.erb'),
  }
}
