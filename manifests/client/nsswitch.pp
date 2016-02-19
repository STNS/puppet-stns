# Class: stns::client::nsswitch
# ===========================
#
# stns::client::nsswitch is to configure nsswitch.conf.

class stns::client::nsswitch {

  file_line {
    'nsswitch_passwd':
      ensure => present,
      path   => '/etc/nsswitch.conf',
      line   => 'passwd:     files stns',
      match  => '^passwd:\s+';

    'nsswitch_shadow':
      ensure => present,
      path   => '/etc/nsswitch.conf',
      line   => 'shadow:     files stns',
      match  => '^shadow:\s+';

    'nsswitch_group':
      ensure => present,
      path   => '/etc/nsswitch.conf',
      line   => 'group:      files stns',
      match  => '^group:\s+';
  }

}
