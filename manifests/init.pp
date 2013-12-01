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
  validate_bool($enable)
  validate_bool($start)
  validate_hash($instances)

  class{'btsync::install': }
  class{'btsync::config': }
  class{'btsync::service': }

  Class['btsync::install'] ->
  Class['btsync::config'] ~>
  Class['btsync::service']

  Class['btsync::install'] ->
  Btsync::Instance <| |> ~>
  Class['btsync::service']

  Class['btsync::service'] ->
  Class['btsync']
}
