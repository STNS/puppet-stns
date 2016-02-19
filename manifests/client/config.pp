# Class: stns::client::config
# ===========================
#
# stns::client::config is to configure libnss-stns.

class stns::client::config (
  $api_end_point     = $stns::client::api_end_point,
  $user              = $stns::client::user,
  $password          = $stns::client::password,
  $wrapper_path      = $stns::client::wrapper_path,
  $chain_ssh_wrapper = $stns::client::chain_ssh_wrapper,
  $ssl_verify        = $stns::client::ssl_verify,
)
{

  file { '/etc/stns/libnss_stns.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('stns/libnss_stns.conf.erb'),
  }

}
