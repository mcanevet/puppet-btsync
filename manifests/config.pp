class btsync::config {
  file{'/etc/btsync':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    recurse => true,
    force   => true,
  }
  create_resources(btsync::instance, $::btsync::instances)
}
