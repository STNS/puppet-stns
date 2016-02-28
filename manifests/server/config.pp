# Class: stns::server::config
# ===========================
#
# stns::server::config is to configure stns.

class stns::server::config (
  $port     = $stns::server::port,
  $user     = $stns::server::user,
  $password = $stns::server::password,
  $users    = $stns::server::users,
  $groups   = $stns::server::groups,
) {

  file { '/etc/stns/stns.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('stns/stns.conf.erb'),
  }

}
