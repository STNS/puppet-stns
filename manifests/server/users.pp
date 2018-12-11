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
  Optional[String] $gecos,
  Optional[String] $password,
) {

  concat::fragment { "users_${title}":
    target  => '/etc/stns/server/stns.conf',
    content => template('stns/server/users.conf.erb'),
    order   => '41';
  }

}
