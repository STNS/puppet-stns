# Class: stns::server
# ===========================
#
# stns::server is to install and configure stns.

class stns::server (
  $port              = 1104,
  $user              = undef,
  $password          = undef,
  $package_ensure    = present,
  $sudoers_password  = undef,
  $sudoers_hash_type = undef,
) {

  validate_integer($port)
  validate_string($user)
  validate_string($password)
  validate_string($package_ensure)
  validate_string($sudoers_password)
  validate_string($sudoers_hash_type)

  require stns::repo

  include stns::server::install
  include stns::server::config
  include stns::server::service

  Class['stns::repo']
  -> Class['stns::server::install']
  -> Class['stns::server::config']
  -> Class['stns::server::service']

}
