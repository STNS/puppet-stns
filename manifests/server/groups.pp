# Define: stns::server::groups
# ===========================
#
# The stns::server::groups defined type allows to configure STNS groups.

define stns::server::groups (
  Integer $id,
  Variant[String, Array, Undef] $users,
  Optional[Array] $link_groups,
) {

  concat::fragment { "groups_${title}":
    target  => '/etc/stns/server/stns.conf',
    content => template('stns/server/groups.conf.erb'),
    order   => '61',
  }

}
