class btsync::repo {
  case $::operatingsystem {
    Debian: {
      apt::source { 'btsync':
        location          => 'http://debian.yeasoft.net/btsync',
        release           => $::lsbdistcodename,
        repos             => 'main contrib non-free',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '6BF18B15',
        key_server        => 'pgp.mit.edu',
        include_src       => true,
      }
    }
    Ubuntu: {
      apt::ppa { 'ppa:tuxpoldo/btsync': }
    }
    default: {
      fail "Unsupported Operating System: ${::operatingsystem}"
    }
  }
  Class['btsync::repo'] -> Class['btsync::install']
}
