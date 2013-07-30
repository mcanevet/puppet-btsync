# == Define: btsync::known_host
#
#   Add a known host to the list of known hosts of a shared folder.
#
# === Parameters
#
# [*secret*]
#   The secret of the shared folder.
#
# [*instance*]
#   The instance to use. Defaults to the instance of the shared folder of the
#   secret passed as parameter
#
# [*host*]
#   The host to add. Defaults to namevar.
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
  $secret,
  $instance = getparam(Btsync::Shared_folder[$secret], 'instance'),
  $host = $title,
) {

  if ! defined(Concat_build["btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts"]) {
    concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts":
    }
    ->
    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json+03":
      content => file(
        concat_output("btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts")),
    }

    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+01":
      content => '"known_hosts" : [',
    }

    concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json":
      file_delimiter => ',',
      append_newline => false,
    }
    ->
    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+02":
      content => file(
        concat_output("btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json")),
    }

    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+99":
      content => ']',
    }

  }

  concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json+${host}":
    content => "\"${host}\"",
  }

}
