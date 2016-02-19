# Class: stns::client
# ===========================
#
# stns::client is to install and configure libnss-stns.
class stns::client {

  require stns

  include stns::client::install
  include stns::client::config
  include stns::client::nsswitch

  Class['stns::client::install']
  -> Class['stns::client::config']

}
