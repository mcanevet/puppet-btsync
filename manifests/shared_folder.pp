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
  if ! defined(Concat_build["instance_${instance}_shared_folders"]) {
    concat_build { "instance_${instance}_shared_folders":
      parent_build   => "instance_${instance}",
      target         => "/var/lib/puppet/concat/fragments/instance_${instance}/04",
      file_delimiter => ',',
      append_newline => false,
    }
  }
  $shared_folder = regsubst($name, '/', '_', 'G')
  validate_array($known_hosts)
  concat_fragment { "instance_${instance}_shared_folders+${shared_folder}":
    content => template('btsync/shared_folder.erb'),
  }
}
