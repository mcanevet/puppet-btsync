class btsync::install {

  apt::source{'btsync':
    location          => 'http://debian.yeasoft.net/btsync',
    release           => 'wheezy',
    repos             => 'main contrib non-free',
    required_packages => 'debian-keyring debian-archive-keyring',
    key               => '6BF18B15',
    key_server        => 'pgp.mit.edu',
    include_src       => false,
  }
  ->
  package{'btsync':
    ensure => $::btsync::version,
  }
}
