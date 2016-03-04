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

  require stns::server

  validate_absolute_path($directory)
  validate_absolute_path($shell)

  if !(is_string($id) or is_integer($id)) {
    fail('$id must be either a string or an integer.')
  }

  if !(is_string($group_id) or is_integer($group_id)) {
    fail('$group_id must be either a string or an integer.')
  }

  if !(is_string($keys) or is_array($keys)) {
    fail('$keys must be either a string or an array.')
  }

  if !(is_string($link_users) or is_array($link_users)) {
    fail('$link_users must be either a string or an array.')
  }

  stns_server_users { $title:
    id         => $id,
    group_id   => $group_id,
    directory  => $directory,
    shell      => $shell,
    keys       => $keys,
    link_users => $link_users,
  }

}
