
class stns::client::service {

  service { 'cache-stnsd':
    ensure => running,
    enable => true,
  }

}
