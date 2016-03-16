# Define: stns::server::groups
# ===========================
#
# The stns::server::groups defined type allows to configure STNS groups.

define stns::server::groups (
  $ensure = file,
  $id     = undef,
  $users  = undef,
) {

  validate_re($ensure,  ['file', 'present', 'absent'])
  validate_integer($id)

  if !(is_string($users) or is_array($users)) {
    fail('$users must be either a string or an array.')
  }

  file { "/etc/stns/conf.d/${title}.conf":
    ensure  => $ensure,
    content => template('stns/header.erb','stns/groups.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['stns'],
  }

}
