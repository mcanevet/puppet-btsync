class btsync::install {
  package{'btsync':
    ensure => $::btsync::version,
  }
}
