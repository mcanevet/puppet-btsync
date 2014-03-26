# == Class: btsync
#
# Install an manage BitTorrent Sync. See README.md for more details.
#
# === Author
#
# Mickaël Canévet <mickael.canevet@gmail.com>
#
# === Copyright
#
# Copyright 2013 Mickaël Canévet, unless otherwise noted.
#
class btsync(
  $version = present,
  $enable = true,
  $start = true,
  $instances = {},
) {

  if str2bool($is_pe) {
    $concat_path = '/var/opt/lib/pe-puppet/concat'
  } else {
    $concat_path = '/var/lib/puppet/concat'
  }

  validate_bool($enable)
  validate_bool($start)
  validate_hash($instances)

  class{'btsync::install': } ->
  class{'btsync::config': } ~>
  class{'btsync::service': } ->
  Class['btsync']
}
