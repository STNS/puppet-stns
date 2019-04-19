# Class: stns::client
# ===========================
#
# stns::client is to install and configure libnss-stns.
class stns::client (
  Optional[String]  $api_end_point = undef,
  Optional[String]  $auth_token = undef,
  Optional[String]  $user = undef,
  Optional[String]  $password = undef,
  Optional[String]  $wrapper_path = undef,
  Optional[String]  $chain_ssh_wrapper = undef,
  Optional[Boolean] $ssl_verify = undef,
  Optional[Integer] $request_timeout = undef,
  Optional[Integer] $request_retry = undef,
  Optional[String]  $http_proxy = undef,
  Optional[Integer] $uid_shift = undef,
  Optional[Integer] $gid_shift = undef,
  String            $libnss_stns_ensure = 'present',
  Boolean           $handle_nsswitch    = false,
  Boolean           $handle_sshd_config = false,
) {

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
        'set AuthorizedKeysCommand /usr/lib/stns/stns-key-wrapper',
        "set ${cmd_user} root",
      ],
      require => Package['openssh-server'],
      notify  => Service[$ssh_service],
    }
  }

}
