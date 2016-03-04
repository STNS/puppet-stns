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
    desc 'The unique user id you want to manage; must be specified numerically.'

    munge do |v|
      if v.is_a?(String) and v.match(/^[-0-9]+$/)
        v.to_i
      else
        v
      end
    end
  end

  newparam(:group_id) do
    desc 'The groups ID to which the user belongs; must be specified numerically.'

    munge do |v|
      if v.is_a?(String) and v.match(/^[-0-9]+$/)
        v.to_i
      else
        v
      end
    end
  end

  newparam(:directory) do
    desc 'The home directory of the user.'
  end

  newparam(:shell) do
    desc "The user's login shell."
  end

  newparam(:keys) do
    desc "Specify user attributes in an array of key = value pairs."
  end

  newparam(:link_users) do
    desc 'link_users.'
  end
end
