# == Class: btsync::config
#
#   Configure btsync. See README.md for more details.
#   You should not declare this class explicitely, it should be done by btsync
#   class.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
class btsync::config {
  if ! defined(Class['btsync']) {
    fail 'You should not declare this class explicitely, it should be done by Class[btsync].'
  }
  file{'/etc/btsync':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    recurse => true,
    force   => true,
  }
  validate_hash($::btsync::instances)
  create_resources(btsync::instance, $::btsync::instances)
}
