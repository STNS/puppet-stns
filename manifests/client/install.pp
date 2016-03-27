# Class: stns::client::install
# ===========================
#
# stns::client::install is to install lib-stns and files.

class stns::client::install {

  package { 'lib-stns':
    ensure => present,
  }

}
