# Class: stns::server
# ===========================
#
# stns::server is to install and configure stns.

class stns::server (
  $port              = 1104,
  $user              = undef,
  $password          = undef,
  $package_ensure    = present,
  $sudoers_name      = undef,
  $sudoers_password  = undef,
  $sudoers_hash_type = 'sha256',
) {

  validate_integer($port)
  validate_string($user)
  validate_string($password)
  validate_string($package_ensure)
  validate_string($sudoers_name)
  validate_string($sudoers_password)
  validate_re($sudoers_hash_type, '\Asha(256|512)\z', 'sudoers_hash_type supports sha256 or sha512.')

  require stns::repo

  include stns::server::install
  include stns::server::config
  include stns::server::service

  Class['stns::repo']
  -> Class['stns::server::install']
  -> Class['stns::server::config']
  -> Class['stns::server::service']

}
