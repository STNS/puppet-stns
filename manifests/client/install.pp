# Class: stns::client::install
# ===========================
#
# stns::client::install is to install libnss-stns and libpam-stns files.

class stns::client::install (
  $libnss_stns_ensure = $stns::client::libnss_stns_ensure,
  $libpam_stns_ensure = $stns::client::libpam_stns_ensure,
){

  package {
    'libnss-stns':
      ensure => $libnss_stns_ensure;

    'libpam-stns':
      ensure => $libpam_stns_ensure;
  }

}
