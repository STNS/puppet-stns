# Class: stns::repo
# ===========================
#
# stns::repo is to setup repository.
class stns::repo {

  $gpgkey_url = 'https://repo.stns.jp/gpg/GPG-KEY-stns'

  case $::osfamily {
    'RedHat': {
      yumrepo { 'stns':
        ensure   => present,
        descr    => 'stns',
        baseurl  => 'http://repo.stns.jp/centos/$basearch',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => $gpgkey_url,
      }
    }
    'Debian': {
      apt::source { 'stns':
        location => 'http://repo.stns.jp/debian/',
        release  => 'stns',
        key      => {
          id     => '6BACCE33697C7E568D5C162F018A7A21B2EC51BA',
          source => $gpgkey_url,
        }
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

}
