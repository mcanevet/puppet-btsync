class btsync::service {
  $ensure = $::btsync::start ? { true => running, default => stopped }

  service{'btsync':
    ensure => $ensure,
    enable => $::btsync::enable,
  }
}
