# Class: stns::client
# ===========================
#
# stns::client is to install and configure libnss-stns.
class stns::client (
  Variant[String, Array] $api_end_point      = 'http://localhost:1104',
  Optional[String]       $user               = undef,
  Optional[String]       $password           = undef,
  String                 $wrapper_path       = '/usr/local/bin/stns-query-wrapper',
  Optional[String]       $chain_ssh_wrapper  = undef,
  Boolean                $ssl_verify         = true,
  Integer                $request_timeout    = 3,
  Optional[String]       $http_proxy         = undef,
  Optional[Hash]         $request_header     = undef,
  Integer                $uid_shift          = 0,
  Integer                $gid_shift          = 0,
  String                 $libnss_stns_ensure = 'present',
  String                 $libpam_stns_ensure = 'present',
  Boolean                $handle_nsswitch    = false,
  Boolean                $handle_sshd_config = false,
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
