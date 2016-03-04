# Define: stns::server::groups
# ===========================
#
# The stns::server::groups defined type allows to configure STNS groups.

define stns::server::groups (
  $id    = undef,
  $users = undef,
) {

  require stns::server

  if !(is_string($id) or is_integer($id)) {
    fail('$id must be either a string or an integer.')
  }

  if !(is_string($users) or is_array($users)) {
    fail('$users must be either a string or an array.')
  }

  stns_server_groups { $title:
    id    => $id,
    users => $users,
  }

}
