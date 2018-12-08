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
  $request_timeout   = $stns::client::request_timeout,
  $http_proxy        = $stns::client::http_proxy,
  $request_header    = $stns::client::request_header,
  $uid_shift         = $stns::client::uid_shift,
  $gid_shift         = $stns::client::gid_shift,
){

  file { '/etc/stns/client/stns.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('stns/client/stns.conf.erb'),
  }

}
