# Class: stns::server::service
# ===========================
#
# stns::server::service is to manage service of stns.

class stns::server::service {

  service { 'stns':
    ensure => running,
    enable => true,
  }

}
