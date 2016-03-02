Puppet::Type.newtype(:stns_server_groups) do
  @doc = %q{
    This type provides Puppet with the capabilities to manage STNS groups.

    Example:

      stns_server_groups { 'example':
        id    => 1001,
        users => 'example',
      }
  }

  ensurable

  newparam(:id, :namevar => true) do
    desc 'The unique group you want to manage.'
  end

  newparam(:users) do
    desc 'The user ID of the groups.'
  end
end
