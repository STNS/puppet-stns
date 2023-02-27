# Class: stns::client::config
# ===========================
#
# stns::client::config is to configure libnss-stns.

class stns::client::config (
  Optional[String]  $api_end_point      = $stns::client::api_end_point,
  Optional[String]  $auth_token         = $stns::client::auth_token,
  Optional[String]  $user               = $stns::client::user,
  Optional[String]  $password           = $stns::client::password,
  Optional[String]  $wrapper_path       = $stns::client::wrapper_path,
  Optional[String]  $chain_ssh_wrapper  = $stns::client::chain_ssh_wrapper,
  Optional[Boolean] $ssl_verify         = $stns::client::ssl_verify,
  Optional[Integer] $request_timeout    = $stns::client::request_timeout,
  Optional[Integer] $request_retry      = $stns::client::request_retry,
  Optional[String]  $http_proxy         = $stns::client::http_proxy,
  Optional[Boolean] $http_keepalive     = $stns::client::http_keepalive,
  Optional[Integer] $uid_shift          = $stns::client::uid_shift,
  Optional[Integer] $gid_shift          = $stns::client::gid_shift,
  Optional[Boolean] $cache              = $stns::client::cache,
  Optional[Boolean] $use_cached         = $stns::client::use_cached,
  Optional[Boolean] $cached_enable      = $stns::client::cached_enable,
  Optional[Boolean] $cached_prefetch    = $stns::client::cached_prefetch,
  Optional[String]  $cache_dir          = $stns::client::cache_dir,
  Optional[Integer] $cache_ttl          = $stns::client::cache_ttl,
  Optional[Integer] $negative_cache_ttl = $stns::client::negative_cache_ttl,
){

  file { '/etc/stns/client/stns.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('stns/client/stns.conf.erb'),
    notify  => Class['stns::client::service'],
  }

}
