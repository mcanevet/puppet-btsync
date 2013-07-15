# == Define: btsync::shared_folder
#
#   Configure a shared folder
#   FIXME: Find a way to generate a valid json file with multiple resources
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
  fail 'btsync::shared_folder is not yet implemented'
}
