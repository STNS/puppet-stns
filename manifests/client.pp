# Class: stns::client
# ===========================
#
# stns::client is to install and configure libnss-stns.
class stns::client (
  $api_end_point      = 'http://localhost:1104',
  $user               = undef,
  $password           = undef,
  $wrapper_path       = '/usr/local/bin/stns-query-wrapper',
  $chain_ssh_wrapper  = undef,
  $ssl_verify         = true,
  $request_timeout    = 3,
  $http_proxy         = undef,
  $package_ensure     = present,

  $handle_nsswitch    = false,
  $handle_sshd_config = false,
  $handle_sudo_config = false,
  $sudoers_name       = undef,
) {

  validate_string($user)
  validate_string($password)
  validate_absolute_path($wrapper_path)
  if $chain_ssh_wrapper {
    validate_absolute_path($chain_ssh_wrapper)
  }
  validate_bool($ssl_verify)
  validate_integer($request_timeout)
  validate_string($http_proxy)
  validate_string($package_ensure)
  validate_bool($handle_nsswitch)
  validate_bool($handle_sshd_config)

  require stns::repo

  include stns::client::install
  include stns::client::config

  Class['stns::repo']
  -> Class['stns::client::install']
  -> Class['stns::client::config']

  if $handle_nsswitch {
    augeas { 'nsswitch stns':
      context => '/files/etc/nsswitch.conf',
      changes => [
        "set *[self::database = 'passwd']/service[1] files",
        "set *[self::database = 'passwd']/service[2] stns",
        "set *[self::database = 'shadow']/service[1] files",
        "set *[self::database = 'shadow']/service[2] stns",
        "set *[self::database = 'group']/service[1] files",
        "set *[self::database = 'group']/service[2] stns",
      ],
    }
  }

  if $handle_sshd_config {
    if ($::osfamily == 'RedHat' and $::operatingsystemmajrelease != '7') {
      $cmd_user = 'AuthorizedKeysCommandRunAs'
    } else {
      $cmd_user = 'AuthorizedKeysCommandUser'
    }

    $ssh_service = $::osfamily ? {
      'RedHat' => 'sshd',
      'Debian' => 'ssh',
    }

    augeas {'sshd_config with stns':
      context => '/files/etc/ssh/sshd_config',
      changes => [
        'set PubkeyAuthentication yes',
        'set AuthorizedKeysCommand /usr/local/bin/stns-key-wrapper',
        "set ${cmd_user} root",
      ],
      require => Package['openssh-server'],
      notify  => Service[$ssh_service],
    }
  }

  if $handle_sudo_config {
    validate_string($sudoers_name)

    augeas {'sudo pam with stns':
      context => '/files/etc/pam.d/sudo',
      changes => [
        'ins "01" after #comment',
        'set 01/type auth',
        'set 01/control sufficient',
        'set 01/module libpam_stns.so',
        'set 01/argument[1] sudo',
        "set 01/argument[2] ${sudoers_name}",
      ],
      onlyif  => [
        "values *[type = 'auth']/module not_include libpam_stns.so",
        "match *[module = 'libpam_stns.so']/argument size < 2",
        "match *[module = 'libpam_stns.so']/argument != ['sudo', ${sudoers_name}]",
      ],
    }
  }

}
