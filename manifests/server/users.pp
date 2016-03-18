# Define: stns::server::users
# ===========================
#
# The stns::server::users defined type is to configure STNS users.

define stns::server::users (
  $id         = undef,
  $group_id   = undef,
  $directory  = undef,
  $shell      = undef,
  $keys       = undef,
  $link_users = undef,
) {

  validate_integer($id)
  validate_integer($group_id)
  validate_absolute_path($directory)
  validate_absolute_path($shell)

  if !(is_string($keys) or is_array($keys)) {
    fail('$keys must be either a string or an array.')
  }

  if !(is_string($link_users) or is_array($link_users)) {
    fail('$link_users must be either a string or an array.')
  }

  concat::fragment { "users_${title}":
    target  => '/etc/stns/stns.conf',
    content => template('stns/users.conf.erb'),
    order   => '41';
  }

}
