# == Class: btsync::install
#
#   Install btsync. See README.md for more details.
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
class btsync::install {
  if ! defined(Class['btsync']) {
    fail 'You should not declare this class explicitely, it should be done by Class[btsync].'
  }
  package{'btsync':
    ensure => $::btsync::version,
  }
}
