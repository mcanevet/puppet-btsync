define btsync::known_host(
  $secret,
  $instance = getparam(Btsync::Shared_folder[$secret], 'instance'),
  $host = $title,
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
