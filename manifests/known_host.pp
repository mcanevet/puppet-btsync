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

  if ! defined(Concat_build["btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts"]) {
    concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts":
      parent_build => "btsync_${instance}_json_shared_folders_json_${secret}_json",
      target       => "${::puppet_vardir}/concat/fragments/btsync_${instance}_json_shared_folders_json_${secret}_json/03",
    }

    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+01":
      content => '"known_hosts" : [',
    }

    concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json":
      parent_build   => "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts",
      target         => "${::puppet_vardir}/concat/fragments/btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts/02",
      file_delimiter => ',',
      append_newline => false,
    }

    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+99":
      content => ']',
    }

  }

  concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json+${host}":
    content => "\"${host}\"",
  }

}
