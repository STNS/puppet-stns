# Class: stns::client::install
# ===========================
#
# stns::client::install is to install libnss-stns and files.

class stns::client::install {

  package { [
    'libnss-stns',
    'libpam-stns',
  ]:
    ensure => present,
  }

}
