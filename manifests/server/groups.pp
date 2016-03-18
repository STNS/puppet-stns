# Define: stns::server::groups
# ===========================
#
# The stns::server::groups defined type allows to configure STNS groups.

define stns::server::groups (
  $id    = undef,
  $users = undef,
) {

  validate_integer($id)

  if !(is_string($users) or is_array($users)) {
    fail('$users must be either a string or an array.')
  }

  concat::fragment { "groups_${title}":
    target  => '/etc/stns/stns.conf',
    content => template('stns/groups.conf.erb'),
    order   => '61',
  }

}
