# == Define: btsync::shared_folder
#
#   Configure a shared folder. See README.md for more details.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
define btsync::shared_folder(
  $instance,
  $dir,
  $secret = $name,
  $use_relay_server = true,
  $use_tracker = true,
  $use_dht = true,
  $search_lan = true,
  $use_sync_trash = true,
  $known_hosts = [],
) {
  concat::fragment {"btsync_${instance} shared_folder ${name}":
    order   => '11',
    target  => "btsync_${instance}",
    #content => "
    content => template('btsync/shared_folder.erb'),
  }
}
