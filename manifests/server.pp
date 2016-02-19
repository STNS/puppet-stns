# Class: stns::server
# ===========================
#
# stns::server is to install and configure stns.

class stns::server {

  require stns

  include stns::server::install
  include stns::server::config
  include stns::server::service

  Class['stns::server::install']
  -> Class['stns::server::config']
  ~> Class['stns::server::service']

}
