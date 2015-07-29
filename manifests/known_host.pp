# == Define: btsync::known_host
#
#   Add a known host to the list of known hosts of a shared folder.
#   See README.md for more details.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
define btsync::known_host(
  $secret = values_at(split($name, ' on '), 0),
  $host = values_at(split($name, ' on '), 1),
  $instance = getparam(Btsync::Shared_folder[$secret], 'instance'),
) {

  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json+${host}":
    incl    => getparam(Btsync::Instance[$instance], 'conffile'),
    lens    => 'Json.lns',
    changes => "set known_host ${host}", # Append to known_host array
  }

}
