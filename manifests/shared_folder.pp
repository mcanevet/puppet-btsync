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
  if ! defined(Concat_build["btsync_${instance}_json_shared_folders"]) {
    concat_build { "btsync_${instance}_json_shared_folders":
      parent_build => "btsync_${instance}_json",
      target       => "/var/lib/puppet/concat/fragments/btsync_${instance}_json/03",
    }

    concat_fragment { "btsync_${instance}_json_shared_folders+01":
      content => '
  "shared_folders":
  [',
    }

    concat_build { "btsync_${instance}_json_shared_folders_json":
      parent_build   => "btsync_${instance}_json_shared_folders",
      target         => "/var/lib/puppet/concat/fragments/btsync_${instance}_json_shared_folders/02",
      file_delimiter => ',',
      append_newline => false,
    }

    # FIXME: when a concat_build contains no fragment but only a concat_build(s)
    # The "fragments" directory is not created and it fails with "No fragments
    # specified for group", so we have to create a fake concat_fragment.
    # This is quite ugly though...
    concat_fragment { "btsync_${instance}_json_shared_folders_json+ZZZZ":
      content => '{}',
    }

    concat_fragment { "btsync_${instance}_json_shared_folders+99":
      content => '  ]',
    }
  }

  concat_build { "btsync_${instance}_json_shared_folders_json_${secret}":
    parent_build => "btsync_${instance}_json_shared_folders_json",
    target       => "/var/lib/puppet/concat/fragments/btsync_${instance}_json_shared_folders_json/${secret}",
  }

  concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}+01":
    content => '    {',
  }

  concat_build { "btsync_${instance}_json_shared_folders_json_${secret}_json":
    parent_build   => "btsync_${instance}_json_shared_folders_json_${secret}",
    target         => "/var/lib/puppet/concat/fragments/btsync_${instance}_json_shared_folders_json_${secret}/02",
    file_delimiter => ',',
    append_newline => false,
  }

  concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}+99":
    content => '    }
',
  }

  concat_fragment { "btsync_${instance}_json_shared_folders_json_${secret}_json+01":
    content => template('btsync/shared_folder.erb'),
  }

  $listening_port = getparam(Btsync::Instance[$instance], 'listening_port')
  $host = $listening_port ? {
    0       => $::ipaddress,
    default => "${::ipaddress}:${listening_port}",
  }

  $_known_hosts = prefix($known_hosts, "${secret} on ")
  btsync::known_host { $_known_hosts:
    secret   => $secret,
    instance => $instance,
  }

}
