# Define: stns::server::users
# ===========================
#
# The stns::server::users defined type is to configure STNS users.

define stns::server::users (
  Integer $id,
  Integer $group_id,
  Variant[String, Array] $keys,
  Variant[String, Array] $link_users,
  String $directory = "/home/${title}",
  String $shell = '/bin/bash',
) {

  validate_absolute_path($directory)
  validate_absolute_path($shell)

  concat::fragment { "users_${title}":
    target  => '/etc/stns/stns.conf',
    content => template('stns/users.conf.erb'),
    order   => '41';
  }

}
