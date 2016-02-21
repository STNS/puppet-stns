# Class: stns::client
# ===========================
#
# stns::client is to install and configure libnss-stns.
class stns::client (
  $api_end_point     = 'http://localhost:1104',
  $user              = undef,
  $password          = undef,
  $wrapper_path      = '/usr/local/bin/stns-query-wrapper',
  $chain_ssh_wrapper = undef,
  $ssl_verify        = true,
) {

  validate_string($user)
  validate_string($password)
  validate_absolute_path($wrapper_path)
  if $chain_ssh_wrapper {
    validate_absolute_path($chain_ssh_wrapper)
  }
  validate_bool($ssl_verify)

  require stns::repo

  include stns::client::install
  include stns::client::config
  include stns::client::nsswitch

  Class['stns::client::install']
  -> Class['stns::client::config']

  ensure_packages('nscd')
  ensure_resource('service','nscd',
  {
    'ensure' => 'running',
    'enable' => true,
  }
  )

}
