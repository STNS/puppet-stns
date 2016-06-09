# Class: stns::server::install
# ===========================
#
# stns::server::install is to install stns.

class stns::server::install (
  $ensure = $stns::server::package_ensure,
) {

  package { 'stns':
    ensure => $ensure,
  }

  file { '/etc/stns/conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
