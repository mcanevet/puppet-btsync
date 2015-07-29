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
  Augeas {
    incl => getparam(Btsync::Instance[$instance], 'conffile'),
    lens => 'Json.lns',
  }

  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+secret":
    changes => "set secret ${secret}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+dir":
    changes => "set dir ${dir}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+use_relay_server":
    changes => "set use_relay_server ${use_relay_server}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+use_tracker":
    changes => "set use_tracker ${use_tracker}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+use_dht":
    changes => "set use_dht ${use_dht}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+search_lan":
    changes => "set search_lan ${search_lan}",
  }
  augeas { "btsync_${instance}_json_shared_folders_json_${secret}_json+use_sync_trash":
    changes => "set use_sync_trash ${use_sync_trash}",
  }

  $_known_hosts = prefix($known_hosts, "${secret} on ")
  btsync::known_host { $_known_hosts:
    secret   => $secret,
    instance => $instance,
  }

}
