# Class: stns::client::install
# ===========================
#
# stns::client::install is to install libnss-stns and files.

class stns::client::install(
  $package_latest = $stns::client::package_latest,
) {

  $package_ensure = $package_latest ? {
    true    => latest,
    default => present,
  }

  package { [
    'libnss-stns',
    'libpam-stns',
  ]:
    ensure => $package_ensure,
  }

}
