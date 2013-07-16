# == Class: btsync
#
# Install an manage BitTorrent Sync
#
# === Parameters
#
# [*version*]
#   The package version to install
#
# [*enable*]
#   Should the service be enabled during boot time?
#
# [*start*]
#   Should the service be started by Puppet
#
# [*instances*]
#   Instances to run
#
# === Examples
#
#  class { 'btsync':
#    instances => {
#      btsync => {
#        storage_path => '/home/btsync/.sync',
#        webui        => {
#          listen   => '0.0.0.0:8888',
#          login    => 'btsync',
#          password => 'password',
#        }
#      }
#    }
#  }
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
  $version = 'present',
  $enable = true,
  $start = true,
  $instances = {},
) {
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
