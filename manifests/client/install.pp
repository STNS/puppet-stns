# Class: stns::client::install
# ===========================
#
# stns::client::install is to install libnss-stns files.

class stns::client::install (
  String $libnss_stns_ensure = $stns::client::libnss_stns_ensure,
){

  package { 'libnss-stns-v2':
    ensure => $libnss_stns_ensure,
  }

}
