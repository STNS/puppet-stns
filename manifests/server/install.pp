# Class: stns::server::install
# ===========================
#
# stns::server::install is to install stns.

class stns::server::install (
  $_ensure = $stns::server::package_ensure,
){

  package { 'stns-v2':
    ensure => $_ensure,
  }

  file { '/etc/stns/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
