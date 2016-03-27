# Class: stns::client
# ===========================
#
# stns::client is to install and configure lib-stns.
class stns::client (
  $api_end_point      = 'http://localhost:1104',
  $user               = undef,
  $password           = undef,
  $wrapper_path       = '/usr/local/bin/stns-query-wrapper',
  $chain_ssh_wrapper  = undef,
  $ssl_verify         = true,

  $handle_nsswitch    = false,
  $handle_sshd_config = false,
) {

  validate_string($user)
  validate_string($password)
  validate_absolute_path($wrapper_path)
  if $chain_ssh_wrapper {
    validate_absolute_path($chain_ssh_wrapper)
  }
  validate_bool($ssl_verify)
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

}
