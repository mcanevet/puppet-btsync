# == Define: btsync::known_host
#
#   Add a known host to the list of known hosts of a shared folder.
#
# === Parameters
#
# [*secret*]
#   The secret of the shared folder.
#
# [*host*]
#   The host to add. Defaults to namevar.
#
# [*instance*]
#   The instance to use. Defaults to the instance of the shared folder of the
#   secret passed as parameter
#
# === Composite namevars
#
# The define supports composite namevars in order to easily specify the entry
# you want to manage. The format for composite namevars is:
#
#  <secret> on <host>
#
# === Examples
#
#  btsync::known_host { 'my known host':
#    secret => 'MY_SECRET_1',
#    host   => '192.168.1.2:44444',
#  }
#
#  equals to
#
#  btsync::known_host { 'MY_SECRET_1 on 192.168.1.2:44444': }
#
#  with an array:
#
#  btsync::known_host { prefix(['192.168.1.2:44444'], 'MY_SECRET_1 on '): }
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
      target       => "/var/lib/puppet/concat/fragments/btsync_${instance}_json_shared_folders_json_${secret}_json/03",
    }

    concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts+01":
      content => '"known_hosts" : [',
    }

    concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts_json":
      parent_build   => "btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts", 
      target         => "/var/lib/puppet/concat/fragments/btsync_${instance}_json_shared_folders_json_${secret}_json_known_hosts/02",
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
