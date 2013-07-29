# == Define: btsync::shared_folder
#
#   Configure a shared folder
#
# === Parameters
#
# [*instance*]
#   Name of the instance sharing this folder.
#
# [*secret*]
#   Shared secret.
#
# [*dir*]
#   Directory to shared. Defaults to resource name.
#
# [*use_relay_server*]
#   Whether or not use relay server when direct connection fails. Defaults to
#   `true`.
#
# [*use_tracker*]
#   can be enabled to facilitate communication between peers.
#
# [*use_dht*]
#
# [*search_lan*]
#
# [*use_sync_trash*]
#   Whether or not save all the files deleted on other clients to the hidden
#   '.SyncArchive' within your destination folder. The files deleted on your
#   computer are moved to system Trash (depending on OS preferences).
#
# [*known_hosts*]
#   An option to specify ip:port or host:port of known clients. So if one of
#   your devices has a static and accessible IP, peers can connect to it
#   directly.
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
