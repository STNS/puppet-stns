# Class: stns::server::install
# ===========================
#
# stns::server::install is to install stns.

class stns::server::install {

  package { 'stns':
    ensure => present,
  }

  file { '/etc/stns/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
