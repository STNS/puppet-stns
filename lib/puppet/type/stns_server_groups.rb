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
    desc 'The group ID; must be specified numerically.'

    munge do |v|
      if v.is_a?(String) and v.match(/^[-0-9]+$/)
        v.to_i
      else
        v
      end
    end
  end

  newparam(:users) do
    desc 'Specify users contained in a group; must be specified numerically.'
  end
end