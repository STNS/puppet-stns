# Class: stns::repo
# ===========================
#
# stns::repo is to setup repository.
class stns::repo {

  case $::osfamily {
    'RedHat': {
      yumrepo { 'stns':
        ensure   => present,
        descr    => 'stns',
        baseurl  => 'http://repo.stns.jp/centos/$basearch',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'https://repo.stns.jp/gpg/GPG-KEY-stns',
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

}
