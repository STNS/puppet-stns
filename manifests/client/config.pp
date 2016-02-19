# Class: stns::client::config
# ===========================
#
# stns::client::config is to configure libnss-stns.

class stns::client::config {

  file { '/etc/stns/libnss_stns.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('stns/libnss_stns.conf.erb'),
  }

}
