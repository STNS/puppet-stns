# Define: stns::server::groups
# ===========================
#
# The stns::server::groups defined type allows to configure STNS groups.

define stns::server::groups (
  Integer $id,
  Variant[String, Array, Undef] $users,
) {

  concat::fragment { "groups_${title}":
    target  => '/etc/stns/stns.conf',
    content => template('stns/groups.conf.erb'),
    order   => '61',
  }

}
