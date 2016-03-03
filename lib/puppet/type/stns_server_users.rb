Puppet::Type.newtype(:stns_server_users) do
  @doc = %q{
    This type provides Puppet with the capabilities to manage STNS users.

    Example:

      stns_server_users {
        id         => $id,
        group_id   => $group_id,
        directory  => $directory,
        shell      => $shell,
        keys       => $keys,
        link_users => $link_users,
      }
  }

  ensurable

  newparam(:id, :namevar => true) do
    desc 'The unique user id you want to manage.'
  end

  newparam(:group_id) do
    desc 'GID.'
  end

  newparam(:directory) do
    desc 'The home directory of user.'
  end

  newparam(:shell) do
    desc 'shell'
  end

  newparam(:keys) do
    desc 'The keys ID of the users.'
  end

  newparam(:link_users) do
    desc 'link_users.'
  end
end
