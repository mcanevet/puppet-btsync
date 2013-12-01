# == Class: btsync::config
#
#   Manage btsync service. See README.md for more details.
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
class btsync::service {
  $ensure = $::btsync::start ? { true => running, default => stopped }

  service{'btsync':
    ensure    => $ensure,
    enable    => $::btsync::enable,
  }
}
