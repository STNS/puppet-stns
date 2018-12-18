require 'beaker-rspec'

# Install Puppet agent on all hosts
install_puppet_agent_on(hosts, {})

RSpec.configure do |c|
  c.formatter = :documentation
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.before :suite do
    # Install module to all hosts
    install_dev_puppet_module(source: module_root)

    # Install dependencies
    hosts.each do |host|
      apply_manifest_on(host, 'package { "tar": }')
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
      on(host, puppet('module', 'install', 'puppetlabs-concat'))
      if host.platform =~ %r{(debian|ubuntu)}
        on(host, puppet('module', 'install', 'puppetlabs-apt'))
      end

      host[:hieradatadir] = 'hieradata'
      write_hiera_config_on(host, ['%{facts.os.family}', 'common'])
      copy_hiera_data_to(host, File.join(module_root, 'spec', 'fixtures', 'hieradata'))
    end
  end
end
