# Class: stns::client::install
# ===========================
#
# stns::client::install is to install libnss-stns and files.

class stns::client::install(
  $package_ensure = $stns::client::package_ensure,
) {

  package { [
    'libnss-stns',
    'libpam-stns',
  ]:
    ensure => $package_ensure,
  }

}
