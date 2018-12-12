# Class: stns::server
# ===========================
#
# stns::server is to install and configure stns.

class stns::server (
  Integer          $port = 1104,
  Optional[String] $user,
  Optional[String] $password,
  Optional[Array]  $tokens,
  String           $package_ensure = 'present',
) {

  require stns::repo

  include stns::server::install
  include stns::server::config
  include stns::server::service

  Class['stns::repo']
  -> Class['stns::server::install']
  -> Class['stns::server::config']
  -> Class['stns::server::service']

}
